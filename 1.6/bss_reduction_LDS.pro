;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO load_live_data_streaming, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  WIDGET_CONTROL,/HOURGLASS
  
  PROCESSING = (*global).processing
  OK         = 'OK'
  FAILED     = 'FAILED'
  
  ;first we need to create the tmp folder
  cmd = 'mkdir ' + (*global).tmp_live_shared_folder
  spawn, cmd, listening, err_listening
  
  findlivenexus = (*global).findlivenexus
  cmd = findlivenexus + ' -i BSS'
  cmd_text = '> Looking for current Live Nexus File (' + cmd + ') ... ' + $
    PROCESSING
  AppendLogBookMessage, Event, cmd_text
  
  ;to grab the LDP NeXus file
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
    putTextFieldValue, Event, 'nexus_full_path_label', $
      ' No Live NeXus File Found !!!', 0
    text = 'Loading Live NeXus FAILED!'
    putMessageBoxInfo, Event, text
    activate_button, event, 'reduce_tab1_live_base', 0
    (*global).current_live_nexus = ''
  ENDIF ELSE BEGIN
    SPAWN, cmd, listening, err_listening
    IF (listening EQ '') THEN BEGIN ;no file found
      putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
      putTextFieldValue, Event, 'nexus_full_path_label', $
        ' No Live NeXus File Found !!!', 0
    ENDIF ELSE BEGIN ;file found
      putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
      ;first thing is to move that file to /SNS/BSS/shared/
      cmd_copy = 'cp ' + listening + ' ' +  (*global).tmp_live_shared_folder
      cmd_copy_text = '> ' + cmd_copy + ' ... ' + PROCESSING
      
      AppendLogBookMessage, Event, cmd_copy_text
      copy_error = 0
      CATCH, copy_error
      IF (copy_error NE 0) THEN BEGIN ;loading failed
        CATCH,/CANCEL
        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
        putTextFieldValue, Event, 'nexus_full_path_label', $
          ' Loading of Live NeXus Failed !!!', 0
        activate_button, event, 'reduce_tab1_live_base', 0
      ENDIF ELSE BEGIN ;loading worked
        spawn, cmd_copy, listening1, err_listening1
        IF (err_listening1[0] NE '') THEN BEGIN ;copy failed
          putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
          putTextFieldValue, Event, 'nexus_full_path_label', $
            ' Loading of Live NeXus Failed !!!', 0
          (*global).current_live_nexus = ''
        ENDIF ELSE BEGIN ;copy worked
          putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
          ;new long file name
          ArraySplit    = STRSPLIT(listening,'/',/EXTRACT)
          sz = N_ELEMENTS(ArraySplit)
          ShortFileName = ArraySplit[sz-1]
          LongFileName = (*global).tmp_live_shared_folder + ShortFileName
          putTextFieldValue, Event, 'nexus_full_path_label', $
            ShortFileName, 0
          LogBookText = '-> Full live NeXus name: ' + LongFileName
          (*global).current_live_nexus = LongFileName
          AppendLogBookMessage, Event, LogBookText
          iNexus = OBJ_NEW('IDLgetMetadata',LongFileName)
          sRunNumber = STRCOMPRESS(iNexus->getRunNumber())
          (*global).RunNumber = sRunNumber
          OBJ_DESTROY, iNexus
          LogBookText = '-> Run Number: ' + sRunNumber
          putTextFieldValue, Event,$
            'nexus_run_number',$
            sRunNumber, 0
          ;load nexus file (retrieve data and plot)
          load_live_nexus, Event, LongFileName ;_LoadNexus
          
          ;load the geometry file
          cmd = findlivenexus + ' -i BSS'
          cmd += ' -g'
          cmd_text = '> Looking for current Live Geoemtry File (' $
            + cmd + ') ... ' + PROCESSING
          AppendLogBookMessage, Event, cmd_text
          geo_error = 0
          CATCH, geo_error
          IF (geo_error NE 0) THEN BEGIN
            CATCH,/CANCEL
            activate_button, event, 'reduce_tab1_live_base', 0
            putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING            
          ENDIF ELSE BEGIN
            SPAWN, cmd, geometry_file, err_listening
            putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
            ;check if file realy exist
            IF (FILE_TEST(geometry_file)) THEN BEGIN
              text = '-> Checking if file exists ... OK'
              AppendLogBookMessage, Event, text
              ;copy the geo file now to /SNS/BSS/shared/
              cmd_geo_copy = 'cp ' + geometry_file + $
                ' ' + (*global).tmp_live_shared_folder
              cmd_geo_copy_text = '-> ' + cmd_geo_copy
              cmd_geo_copy_text += ' ... ' + PROCESSING
              AppendLogBookMessage, Event, cmd_geo_copy_text
              copy_geo_error = 0
              CATCH,copy_geo_error
              IF (copy_geo_error NE 0) THEN BEGIN
                CATCH,/CANCEL
                putTextAtEndOfLogBookLastLine, Event, FAILED, $
                  PROCESSING
                activate_button, event, 'reduce_tab1_live_base', 0
              ENDIF ELSE BEGIN
                spawn, cmd_geo_copy, listening2, err_listening2
                putTextAtEndOfLogBookLastLine, Event, $
                  OK, $
                  PROCESSING
                ;get last part of name only to define new full name
                ArraySplit       = $
                  STRSPLIT(geometry_file,'/',/EXTRACT)
                sz               = N_ELEMENTS(ArraySplit)
                ShortGeoFileName = ArraySplit[sz-1]
                FullGeoFileName  = $
                  (*global).tmp_live_shared_folder + ShortGeoFileName
                putTextFieldValue, Event, $
                  'aig_list_of_runs_text',$
                  STRCOMPRESS(FullGeoFileName,/REMOVE_ALL),0
                LogBookText = '-> Live Data Geometry file is: ' + $
                  STRCOMPRESS(FullGeoFileName,/REMOVE_ALL)
                AppendLogBookMessage, Event, LogBookText
                
                ;live data has been loaded with success to enable choice
                ;of live or run numbers loaded (reduce/tab1)
                activate_button, event, 'reduce_tab1_live_base', 1
                
              ENDELSE
            ENDIF ELSE BEGIN
              text = '-> Checking if file exists ... NO'
              AppendLogBookMessage, Event, text
            ENDELSE
          ENDELSE
        ENDELSE
      ENDELSE
    ENDELSE
  ENDELSE
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END
