 ;=============================================================================
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
 ;determine the default full output file name
 ;==============================================================================
 ;determine the default full output file name
 FUNCTION DetermineTOFoutputFile, Event, TYPE=type
   ;get global structure
   WIDGET_CONTROL, Event.top, GET_UVALUE=global
   text = '-> Determine TOF output File name:'
   IDLsendToGeek_addLogBookText, Event, text
   
   file_name  = 'SANS_'
   ;get run number
   FullNexusName = (*global).data_nexus_file_name
   iNexus        = OBJ_NEW('IDLgetMetadata',FullNexusName)
   RunNumber     = iNexus->getRunNumber()
   OBJ_DESTROY, iNexus
   ;add extension
   CASE (TYPE) OF
     'all': ext1 = ''
     'selection': ext1 = '_sel'
     'monitor' : ext1 = '_mon'
   ENDCASE
   ext = ext1 + '.tof'
   output_file_name  = file_name + STRCOMPRESS(RunNumber,/REMOVE_ALL)
   output_file_name += ext
   IDLsendToGeek_addLogBookText, Event, '--> output_file_name: ' + $
     output_file_name
     
   RETURN, output_file_name
 END
 
 ;------------------------------------------------------------------------------
 ;run the driver
 PRO run_driver, Event, $
     TYPE = type, $
     OUTPUT_FILE_NAME = output_file_name
   ;get global structure
   WIDGET_CONTROL, Event.top, GET_UVALUE=global
   
   IDLsendToGeek_addLogBookText, Event, '-> Entering run_driver:'
   
   ;indicate initialization with hourglass icon
   WIDGET_CONTROL,/hourglass
   ;retrieve infos
   PROCESSING = (*global).processing
   OK         = (*global).ok
   FAILED     = (*global).failed
   ;get parameters
   nexus_file_name = (*global).data_nexus_file_name
   tof_slicer_cmd  = (*global).tof_slicer
   
   ;build cmd
   cmd  = tof_slicer_cmd
   cmd_base = cmd + ' ' + nexus_file_name
   IDLsendToGeek_AddLogBookText, Event, '--> Type: ' + type
   
   working_path = (*global).tof_ascii_path
   CD, working_path, CURRENT=current
   
   CASE (TYPE) OF
   
     'monitor'  : BEGIN
       no_error = 0
       CATCH, no_error
       cmd1 = cmd_base + ' ' + (*global).tof_monitor_flag
       IF (no_error NE 0) THEN BEGIN
         CATCH,/CANCEL
         IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
       ENDIF ELSE BEGIN
         cmd = cmd1 + '=' + (*global).tof_monitor_path
         text = ' monitor'
         cmd += ' -o ' + OUTPUT_FILE_NAME
         cmd_text  = '> Create ASCII file of Counts vs TOF of' + text + ':'
         IDLsendToGeek_addLogBookText, Event, cmd_text
         cmd_text1 = '-> cmd: ' + cmd + ' ... ' + PROCESSING
         IDLsendToGeek_addLogBookText, Event, cmd_text1
         
         SPAWN, cmd, listening, error_listening
         IF (error_listening[0] NE '') THEN BEGIN
           IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
           cmd = cmd1 + '=' + (*global).tof_monitor_path1
           text = ' monitor'
           cmd += ' -o ' + OUTPUT_FILE_NAME
           cmd_text  = '> Create ASCII file of Counts vs TOF of' + text + ':'
           IDLsendToGeek_addLogBookText, Event, cmd_text
           cmd_text1 = '-> cmd: ' + cmd + ' ... ' + PROCESSING
           IDLsendToGeek_addLogBookText, Event, cmd_text1
           SPAWN, cmd, listening, error_listening
           IF (error_listening[0] NE '') THEN BEGIN
             IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
           ENDIF ELSE BEGIN
             IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
             text = '-> Output File Name: ' + OUTPUT_FILE_NAME
             IDLsendToGeek_addLogBookText, Event, text
             plot_counts_vs_tof_data, Event, OUTPUT_FILE_NAME ;_counts_vs_tof
           ENDELSE
         ENDIF ELSE BEGIN
           IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
           text = '-> Output File Name: ' + OUTPUT_FILE_NAME
           IDLsendToGeek_addLogBookText, Event, text
           ;plot data
           plot_counts_vs_tof_data, Event, OUTPUT_FILE_NAME ;_counts_vs_tof
         ENDELSE
       ENDELSE
     END
     
     'selection': BEGIN
       cmd = cmd_base + ' ' + (*global).tof_roi_flag
       ROIfile = getROIfileName(Event)
       cmd += '=' + ROIfile
       text = ' selection (' + ROIfile + ')'
       cmd += ' -o ' + OUTPUT_FILE_NAME
       cmd_text  = '> Create ASCII file of Counts vs TOF of' + text + ':'
       IDLsendToGeek_addLogBookText, Event, cmd_text
       cmd_text1 = '-> cmd: ' + cmd + ' ... ' + PROCESSING
       IDLsendToGeek_addLogBookText, Event, cmd_text1
       no_error = 0
       CATCH, no_error
       IF (no_error NE 0) THEN BEGIN
         CATCH,/CANCEL
         IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
         result = DIALOG_MESSAGE(cmd_text + ' FAILED',/ERROR)
       ENDIF ELSE BEGIN
         SPAWN, cmd, listening, error_listening
         IF (listening[0] EQ '') THEN BEGIN ;worked
           IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
           text = '-> Output File Name: ' + OUTPUT_FILE_NAME
           IDLsendToGeek_addLogBookText, Event, text
           ;plot data
           plot_counts_vs_tof_data, Event, OUTPUT_FILE_NAME ;_counts_vs_tof
         ENDIF ELSE BEGIN
           IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
         ENDELSE
       ENDELSE
     END
     
     'all': BEGIN
       text = ' full detector'
       cmd = cmd_base + ' -o ' + OUTPUT_FILE_NAME
       cmd_text  = '> Create ASCII file of Counts vs TOF of' + text + ':'
       IDLsendToGeek_addLogBookText, Event, cmd_text
       cmd_text1 = '-> cmd: ' + cmd + ' ... ' + PROCESSING
       IDLsendToGeek_addLogBookText, Event, cmd_text1
       error = 0
       CATCH, error
       IF (error NE 0) THEN BEGIN
         CATCH,/CANCEL
         IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
         result = DIALOG_MESSAGE(cmd_text + ' FAILED',/ERROR)
       ENDIF ELSE BEGIN
         SPAWN, cmd, listening, error_listening
         IF (error_listening[0] NE '') THEN BEGIN
           IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
         ENDIF ELSE BEGIN
           IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
           text = '-> Output File Name: ' + OUTPUT_FILE_NAME
           IDLsendToGeek_addLogBookText, Event, text
           text = '-> listening: ' + listening
           IDLsendToGeek_addLogBookText, Event, text
           text = '-> error_listening: ' + error_listening
           IDLsendToGeek_addLogBookText, Event, text
           ;plot data
           plot_counts_vs_tof_data, Event, OUTPUT_FILE_NAME ;_counts_vs_tof
         ENDELSE
       ENDELSE
     END
     
   ENDCASE
   
   CD, current
   
   ;turn off hourglass
   WIDGET_CONTROL,hourglass=0
 END
 
 ;------------------------------------------------------------------------------
 PRO plot_counts_vs_tof_data, Event, output_file_name
 
   ;get global structure
   WIDGET_CONTROL, Event.top, GET_UVALUE=global
   ;retrieve infos
   PROCESSING = (*global).processing
   OK         = (*global).ok
   FAILED     = (*global).failed
   
   text = '-> Parsing ASCII file : '
   IDLsendToGeek_addLogBookText, Event, text
   iASCII = OBJ_NEW('IDL3columnsASCIIparser',output_file_name)
   IF (OBJ_VALID(iASCII)) THEN BEGIN
     text = '--> iASCII is a valid IDL3columnsASCIIparser object'
   ENDIF ELSE BEGIN
     text = '--> iASCII is not a valid IDL3columnsASCIIparser object'
   ENDELSE
   IDLsendToGeek_addLogBookText, Event, text
   sData = iASCII->getData(Event)
   DataArray = (*(*sData.data)[0].data)
   nbr_column = FIX((SIZE(DataArray))(1) / 3)
   
   newDataArray = REFORM(DAtaArray,3,nbr_column)
   
   title = ''
   
   IPLOT, newDataArray[0,*], $
     newDataArray[1,*],$
     /DISABLE_SPLASH_SCREEN,$
     TITLE = title,$
     VIEW_TITLE = view_title,$
     SYM_INDEX = 1,$
     XTITLE = 'TOF (microSeconds)',$
     YTITLE = 'Counts'
     
   OBJ_DESTROY, iASCII
 END
 
 ;------------------------------------------------------------------------------
 ;------------------------------------------------------------------------------
 PRO launch_counts_vs_tof_full_detector_button, Event
 
   text = '> Launch counts vs tof of full detector:'
   IDLsendToGeek_addLogBookText, Event, text
   ;determine the default full output file name
   FullOutputFileName = DetermineTOFoutputFile(Event,TYPE='all')
   
   ;Create the tof base
   text = '> Launch counts vs tof (map the tof base):'
   IDLsendToGeek_addLogBookText, Event, text
   launch_counts_vs_tof, Event, FullOutputFileName, ROIfile='', TYPE='all'
   
 END
 
 ;------------------------------------------------------------------------------
 PRO launch_counts_vs_tof_selection_button, Event
   ;determine the default full output file name
   FullOutputFileName = DetermineTOFoutputFile(Event,TYPE='selection')
   ;get ROI file name
   ROIfile = getROIfileName(Event)
   ;Create the tof base
   launch_counts_vs_tof, Event, FullOutputFileName, $
     ROIfile=ROIfile, $
     TYPE='selection'
 END
 
 ;------------------------------------------------------------------------------
 PRO launch_counts_vs_tof_monitor_button, Event
   ;determine the default full output file name
   FullOutputFileName = DetermineTOFoutputFile(Event,TYPE='monitor')
   ;Create the tof base
   launch_counts_vs_tof, Event, FullOutputFileName, ROIfile='', TYPE='monitor'
 END
 
 ;------------------------------------------------------------------------------
 ;------------------------------------------------------------------------------
 PRO launch_counts_vs_tof, Event, $
     FullOutputFileName, $
     ROIfile=ROIfile, $
     TYPE=type
   ;get global structure
   ;activate_widget, Event, 'MAIN_BASE',0 ;remove_me comments
   WIDGET_CONTROL, Event.top, GET_UVALUE=global
   iBase = OBJ_NEW('IDLmakeTOFbase', $
     EVENT  = Event,$
     GLOBAL = global, $
     ROIfile = ROIfile,$
     FILE   = FullOutputFileName,$
     TYPE   = type)
   OBJ_DESTROY, iBase
 END
