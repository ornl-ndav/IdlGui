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
;==============================================================================

FUNCTION getOutputFileName, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='tof_ascii_file_name')
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
PRO putTOFbuttonValue, Event, uname, value
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=value
END

;------------------------------------------------------------------------------
PRO make_tof_base_cleanup, MAIN_BASE
WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=sMainBase
main_base_id = sMainBase.main_base_id
no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
   CATCH,/CANCEL
   WIDGET_CONTROL, main_base_id, /DESTROY
ENDIF ELSE BEGIN
   activate_widget, sMainBase.main_base_event, $
     (*sMainBase.global).main_base_uname, 1
   WIDGET_CONTROL, main_base_id, /DESTROY
ENDELSE
END

;------------------------------------------------------------------------------
PRO cancel_tof_ascii_base, Event
no_error = 0
CATCH,no_error
IF (no_error NE 0) THEN BEGIN
   CATCH,/CANCEL
   id = WIDGET_INFO(Event.top,FIND_BY_UNAME='tof_main_base')
   WIDGET_CONTROL, id, /DESTROY
ENDIF ELSE BEGIN
   WIDGET_CONTROL, event.top, GET_UVALUE=sMainBase
   (*sMainBase.global).tof_ascii_path = $
      (*sMainBase.global).tof_ascii_path_backup
   activate_widget, sMainBase.main_base_event, $
                    (*sMainBase.global).main_base_uname, 1
   id = WIDGET_INFO(Event.top,FIND_BY_UNAME='tof_main_base')
   WIDGET_CONTROL, id, /DESTROY
ENDELSE
END

;------------------------------------------------------------------------------
PRO determinePositionOfApplication, sMainBase, sBase

;size of MainBase
MainBaseSize = (*sMainBase.global).MainBaseSize
xoffset = MainBaseSize[0]
yoffset = MainBaseSize[1]
xsize   = MainBaseSize[2]
ysize   = MainBaseSize[3]

;size of tof_base
tof_xsize = sBase.size[2]
tof_ysize = sbase.size[3]

;determine offset of tof_base
tof_xoffset = xoffset + FIX((xsize - tof_xsize)/2)
tof_yoffset = yoffset + FIX((ysize - tof_ysize)/2)

;put new value of tof_offset in structure
sBase.size[0] = tof_xoffset
sBase.size[1] = tof_yoffset

END

;------------------------------------------------------------------------------
PRO pick_tof_ascii_path, Event
WIDGET_CONTROL, event.top, GET_UVALUE=sMainBase
path  = (*sMainBase.global).tof_ascii_path
title = 'Path of ASCII File '
CASE ((*sMainBase.global).tof_ascii_type) OF
   'all': title += '(Full Detector)'
   'selection': title += '(Selection Only)'
   'monitor': title += '(Monitor)'
ENDCASE
new_path = DIALOG_PICKFILE(/DIRECTORY,$
                           TITLE = title,$
                           PATH  = path)
IF (path NE '') THEN BEGIN
   (*sMainBase.global).tof_ascii_path = new_path
   putTOFButtonValue, Event, 'tof_ascii_file_path', new_path
ENDIF

END

;------------------------------------------------------------------------------
PRO validate_ascii_plot, Event
WIDGET_CONTROL, event.top, GET_UVALUE=sMainBase

main_event = (sMainBase).Event
text = '> Entering validate_ascii_plot:'
IDLsendToGeek_addLogBookText, main_event, text

;disable counts_vs_tof gui
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='tof_main_base')
WIDGET_CONTROL, id, SENSITIVE=0

;;show log book page
;    id1 = WIDGET_INFO(main_event.top, FIND_BY_UNAME='main_tab')
;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 3

(*sMainBase.global).tof_ascii_path_backup = $
  (*sMainBase.global).tof_ascii_path

path = (*sMainBase.global).tof_ascii_path
name = (*sMainBase.global).tof_ascii_name
output_file_name = path + name
(*sMainBase.global).tof_ascii_file_name = output_file_name

text = '-> output_file_name: ' + output_file_name
IDLsendToGeek_addLogBookText, main_event, text

;run the driver to produce the ascii file
run_driver, $
  sMainBase.Event, $
  TYPE = sMainBase.TYPE,$
  OUTPUT_FILE_NAME = output_file_name
cancel_tof_ascii_base, Event
END

;------------------------------------------------------------------------------
PRO DefineMainBase_event, Event
WIDGET_CONTROL, event.top, GET_UVALUE=sMainBase
wWidget =  Event.top            ;widget id

CASE Event.id OF

;button to select path
    Widget_Info(wWidget, FIND_BY_UNAME='tof_ascii_file_path'): BEGIN
       pick_tof_ascii_path, Event ;_IDLmakeTOFbase
    END

;widget_text (file name)
    Widget_Info(wWidget, FIND_BY_UNAME='tof_ascii_file_name'): BEGIN
        name = getOutputFileName(Event)
        (*sMainBase.global).tof_ascii_name = name
    END    

;button to cancel base
    Widget_Info(wWidget, FIND_BY_UNAME='tof_ascii_cancel'): BEGIN
       cancel_tof_ascii_base, Event ;_IDLmakeTOFbase
    END

;path or name of ROI file
    Widget_Info(wWidget, FIND_BY_UNAME='tof_roi_path_button'): BEGIN
        path = FILE_DIRNAME(sMainBase.ROIfile)
        IF (path EQ '.') THEN path = 'N/A'
        putTextFieldValue, Event, 'tof_roi_file_name', path
    END
    Widget_Info(wWidget, FIND_BY_UNAME='tof_roi_name_button'): BEGIN
        name = FILE_BASENAME(sMainBase.ROIfile)
        IF (name EQ '') THEN name = 'N/A'
        putTextFieldValue, Event, 'tof_roi_file_name', name
    END

;Create ASCII and Visualize Data
    Widget_Info(wWidget, FIND_BY_UNAME='tof_ascii_validate'): BEGIN
        validate_ascii_plot, Event
    END

    ELSE:
ENDCASE
END

;------------------------------------------------------------------------------
PRO DefineMainBase, sMainBase, wBase
ourGroup = WIDGET_BASE()

;define structures ............................................................
IF (sMainBase.type EQ 'selection') THEN BEGIN
   ysize = 145
ENDIF ELSE BEGIN
   ysize = 105
ENDELSE
sBase = { size: [0,$
                 0,$
                 500,$
                 ysize],$
          uname: 'tof_main_base',$
          title: sMainBase.title,$
          frame: 1}
;determine position of application
determinePositionOfApplication, sMainBase, sBase

sPathLabel = { value: 'Path'}
sPathButton = { value: (*sMainBase.global).tof_ascii_path,$
                xsize: 460,$
                uname: 'tof_ascii_file_path'}

sFileNameLabel = { value: 'File Name'}
sFileNameText = { value: sMainBase.output_file_name,$
                  xsize: 69,$
                  uname: 'tof_ascii_file_name'}

IF (sMainBase.type EQ 'selection') THEN BEGIN

    sROIlabel = { value: 'ROI'}
    sROIpath  = { value: 'PATH',$
                  uname: 'tof_roi_path_button'}
    sROIname  = { value: 'NAME',$
                  uname: 'tof_roi_name_button'}

    file_name = FILE_BASENAME(sMainBase.ROIfile)
    IF (file_name EQ '') THEN file_name = 'N/A'
    sROIvalue = { value: file_name,$
                  xsize: 350,$
                  frame: 1,$
                  uname: 'tof_roi_file_name'}
ENDIF

sCancelButton = { value: 'CANCEL',$
                  xsize: FIX(sbase.size[2]/2)-5,$
                  uname: 'tof_ascii_cancel'}
sOKButton = { value: 'CREATE ASCII and VISUALIZE DATA',$
              xsize: sCancelButton.xsize,$
              uname: 'tof_ascii_validate'}

;Build widgets ................................................................

wBase = WIDGET_BASE(GROUP_LEADER = ourGroup,$
                    TITLE        = sBase.title,$
                    XOFFSET      = sBase.size[0],$
                    YOFFSET      = sBase.size[1],$
                    SCR_XSIZE    = sBase.size[2],$
                    SCR_YSIZE    = sBase.size[3],$
                    MAP          = 1,$
                    UNAME        = sBase.uname,$
                    /COLUMN)

sMainBase.main_base_id = wBase
;path base and button
wPathBase = WIDGET_BASE(wBase,$
                        /ROW)
wPathLabel = WIDGET_LABEL(wPathBase,$
                          VALUE = sPathLabel.value)
wPathButton = WIDGET_BUTTON(wPathBase,$
                            XSIZE = sPathButton.xsize,$
                            VALUE = sPathButton.value,$
                            UNAME = sPathButton.uname)

wFileNameBase = WIDGET_BASE(wBase,$
                            /ROW)
wFileNameLabel = WIDGET_LABEL(wFileNameBase,$
                              VALUE = sFileNameLabel.value)
wFileNameText = WIDGET_TEXT(wFileNameBase,$
                            UNAME = sFileNameText.uname,$
                            XSIZE = sFileNameText.xsize,$
                            VALUE = sFileNameText.value,$
                            /EDITABLE,$
                            /ALL_EVENTS,$
                            /ALIGN_LEFT)

IF (sMainBase.type EQ 'selection') THEN BEGIN
   wROIBase = WIDGET_BASE(wBase,$
                          /ROW)
   wROIlabel = WIDGET_LABEL(wROIBase,$
                            VALUE = sROIlabel.value)

;path and name of roi file
   wROIBase2 = WIDGET_BASE(wROIbase,$
                           /ROW,$
                           /EXCLUSIVE)
   wROIpath = WIDGET_BUTTON(wROIBase2,$
                            VALUE = sROIpath.value,$
                            UNAME = sROIpath.uname,$
                            /NO_RELEASE)
   wROIname = WIDGET_BUTTON(wROIBase2,$
                            VALUE = sROIname.value,$
                            UNAME = sROIname.uname,$
                            /NO_RELEASE)

   WIDGET_CONTROL, wROIname, /SET_BUTTON


   wROIvalue = WIDGET_LABEL(wROIBase,$
                            VALUE = sROIvalue.value,$
                            XSIZE = sROIvalue.xsize,$
                            UNAME = sROIvalue.uname,$
                            FRAME = sROIvalue.frame,$
                            /ALIGN_LEFT)
ENDIF


wButtonsBase = WIDGET_BASE(wBase,$
                           /ROW)
wCancelButton = WIDGET_BUTTON(wButtonsBase,$
                              VALUE = sCancelButton.value,$
                              UNAME = sCancelButton.uname,$
                              XSIZE = sCancelButton.xsize)
wOKButton = WIDGET_BUTTON(wButtonsBase,$
                          VALUE = sOKButton.value,$
                          UNAME = sOKButton.uname,$
                          XSIZE = sOKButton.xsize)

Widget_Control, /REALIZE, wBase
XManager, 'MAIN_BASE', wBase, /NO_BLOCK, CLEANUP = 'make_tof_base_cleanup'
END

;***** Class constructor ******************************************************
FUNCTION IDLmakeTOFbase::init, $
                       EVENT   = event,$
                       GLOBAL  = global,$
                       ROIfile = ROIfile,$
                       FILE    = file,$          
                       TYPE    = type ;'all','selection','monitor'

CASE (type) OF
  'all': BEGIN
     title = 'Defined Full Name of ASCII File for Full Detector'
  END
  'selection': BEGIN
     title = 'Defined Full Name of ASCII File for Selection only' + $
             ' Defined by the ROI File'
  END
  'monitor': BEGIN
     title = 'Defined Full Name of ASCII File for Monitor'
  END
ENDCASE

;design Main Base
sMainBase = { global: GLOBAL,$
              output_file_name: FILE,$
              Event: event,$
              ROIfile: ROIfile,$
              type: type,$
              main_base_id: 0L,$
              main_base_event: event,$
              title:    title}

(*sMainBase.global).tof_ascii_type = TYPE
(*sMainBase.global).tof_ascii_name = FILE

;Design Main Base
DefineMainBase, sMainBase, wBase
WIDGET_CONTROL, wBase, SET_UVALUE = sMainBase
XMANAGER, "DefineMainBase", wBase, /NO_BLOCK
RETURN, 1
END

;******************************************************************************
PRO IDLmakeTOFbase__define
struct = {IDLmakeTOFbase,$
          var : ''}
END
