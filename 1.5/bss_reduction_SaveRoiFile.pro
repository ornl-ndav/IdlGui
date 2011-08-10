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

PRO BSSreduction_CreateRoiFileName, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
path       = (*global).roi_path
first_part = 'BASIS_'
RunNumber  = (*global).RunNumber
IF (RunNumber NE '') THEN BEGIN
    first_part += STRCOMPRESS(RunNumber,/REMOVE_ALL) + '_'
ENDIF
DateIso  = GenerateIsoTimeStamp()
ext_part = (*global).roi_ext
name     = path + first_part + DateIso + ext_part
;put new name into field
putRoiFileName, Event, name
END

;==============================================================================

PRO BSSreduction_SetRoiPath, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get value of button
current_path = (*global).roi_path

new_path = dialog_pickfile(PATH = current_path,$
                           TITLE = 'Select ROI destination folder',$
                           /DIRECTORY)

IF (new_path NE '') THEN BEGIN ;change label of ROI path
    
    (*global).roi_path = new_path
    
;display only the last part of the path
;    path_to_display = strmid(new_path,10,11,/reverse_offset)
;    path_to_display = '...' + path_to_display
    path_to_display = new_path
    putRoiPathButtonValue, Event, path_to_display

;gives new ROI output path in LogBook
    LogBookText = 'A new output path for the Region Of' + $
      ' Interest (ROI) files has been set:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> Path was    : ' + current_path
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> Path is now : ' + new_path
    AppendLogBookMessage, Event, LogBookText

;put new path and file name in Save ROI text
    BSSreduction_CreateRoiFileName, Event

ENDIF
END

;==============================================================================

PRO BSSreduction_SaveRoiFile, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;get ROI full file name
RoiFullFileName = getRoiFullFileName(Event)

LogBookText = 'Name of ROI file to create: ' + RoiFullFileName
AppendLogBookMessage, Event, LogBookText

;get ROI array
pixel_excluded = (*(*global).pixel_excluded)
pixel_excluded_bank3_4 = (*(*global).pixel_excluded_bank3_4)

sz = (size(pixel_excluded))(1)

error = 0
CATCH, error
IF (error NE 0) THEN BEGIN

    CATCH, /CANCEL
    LogBookText = 'ERROR: ROI file has not been saved:'
    AppendLogBookMessage, Event, LogBookText
    LogBookText = '   -> ROI file name: ' + RoiFullFileName
    AppendLogBookMessage, Event, LogBookText
    MessageBox = 'ROI File Creation -> ERROR !'

ENDIF ELSE BEGIN
    
;create output_path if this one does not exist yet
    ;first check that the output folder exist if not, create it
    output_path = FILE_DIRNAME(RoiFullFileName)
    ok_to_CONTINUE = 1

    IF (FILE_TEST(output_path,/DIRECTORY) EQ 0) THEN BEGIN 
;folder does not exist
        cmd_text = 'Check if output path (' + output_path + ') exists ... NO'
        AppendLogBookMessage, Event, cmd_text
        cmd_text = '-> Create output path ... ' + PROCESSING
        AppendLogBookMessage, Event, cmd_text
        spawn, 'mkdir ' + output_path, listening, err_listening
        IF (err_listening[0] NE '') THEN BEGIN
            putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
            status_text = (*global).DRstatusFAILED
            putDRstatusInfo, Event, status_text
            ok_to_CONTINUE = 0
        ENDIF ELSE BEGIN
            cmd_text = 'Check if output path (' + output_path + $
              ') exists ... YES'
            AppendLogBookMessage, Event, cmd_text
        ENDELSE

    ENDIF
    
    IF (ok_to_CONTINUE) THEN BEGIN

;open output file
        openw, 1, RoiFullFileName
        
;initialize info parameters
        ExcludedBank1Pixels = 4096
        ExcludedBank2Pixels = ExcludedBank1Pixels
        IncludedBank1Pixels = 0
        IncludedBank2Pixels = 0
        
        FOR i=0,(sz-1) DO BEGIN
            
            IF (pixel_excluded[i] EQ 0) THEN BEGIN
                
                IF (i LT 4096) THEN BEGIN ;bank1
                    bank = 'bank1_'
                    IncludedBank1PIxels += 1
                    ExcludedBank1PIxels -= 1
                ENDIF ELSE BEGIN ;bank2
                    bank = 'bank2_'
                    IncludedBank2PIxels += 1
                    ExcludedBank2PIxels -= 1
                ENDELSE
                
                XY = getXYfromPixelID_Untouched(i)
                X = strcompress(XY[0],/remove_all)
                Y = strcompress(XY[1],/remove_all)
                
                text = bank + X + '_' + Y
                PRINTF, 1, text
                
            ENDIF
            
        ENDFOR
        
;initialize info parameters
        ExcludedBank3Pixels = 4096
        ExcludedBank4Pixels = ExcludedBank3Pixels
        IncludedBank3Pixels = 0
        IncludedBank4Pixels = 0
        
        FOR i=0,(sz-1) DO BEGIN
            
            IF (pixel_excluded[i] EQ 0) THEN BEGIN
                
                IF (i LT 4096) THEN BEGIN ;bank1
                    bank = 'bank3_'
                    IncludedBank3PIxels += 1
                    ExcludedBank3PIxels -= 1
                ENDIF ELSE BEGIN ;bank2
                    bank = 'bank4_'
                    IncludedBank4PIxels += 1
                    ExcludedBank4PIxels -= 1
                ENDELSE
                
                XY = getXYfromPixelID_Untouched(i)
                X = strcompress(XY[0],/remove_all)
                Y = strcompress(XY[1],/remove_all)
                
                text = bank + X + '_' + Y
                PRINTF, 1, text
                
            ENDIF
            
        ENDFOR

        CLOSE, 1
        FREE_LUN, 1
        
        LogBookText = '    -> ROI file saved information: '
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '       * Bank 1:'
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels included: ' + $
          strcompress(IncludedBank1Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels excluded: ' + $
          strcompress(ExcludedBank1Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '       * Bank 2:'
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels included: ' + $
          strcompress(IncludedBank2Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels excluded: ' + $
          strcompress(ExcludedBank2Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText

        LogBookText = '       * Bank 3:'
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels included: ' + $
          strcompress(IncludedBank3Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels excluded: ' + $
          strcompress(ExcludedBank3Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '       * Bank 4:'
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels included: ' + $
          strcompress(IncludedBank4Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '         - Number of pixels excluded: ' + $
          strcompress(ExcludedBank4Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText

        LogBookText = '       * Total Number of pixels excluded: ' + $
          strcompress(ExcludedBank2Pixels + ExcludedBank1Pixels + $
          ExcludedBank3Pixels + ExcludedBank4Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '       * Total Number of pixels included: ' + $
          strcompress(IncludedBank2Pixels + IncludedBank1Pixels + $
          IncludedBank3Pixels + IncludedBank4Pixels,/remove_all)
        AppendLogBookMessage, Event, LogBookText
        
        MessageBox = 'ROI File Creation -> SUCCESS !'
        
;populate RoI file name in reduce tab1
        putReduceRoiFileName, Event, RoiFullFileName
        
        (*global).SavedRoiFullFileName = RoiFullFileName
        
    ENDIF ELSE BEGIN            ;output path can not be created
        
        LogBookText = 'ERROR: output path can not be created!'
        AppendLogBookMessage, Event, LogBookText
        LogBookText = '   -> ROI file name: ' + RoiFullFileName
        AppendLogBookMessage, Event, LogBookText
        MessageBox = 'ROI File Creation -> ERROR !'
        
    ENDELSE
    
ENDELSE

putMessageBoxInfo, Event, MessageBox

;remove name of file loaded from Loaded ROI text
putLoadedRoiFileName, Event, ''

END

;==============================================================================
