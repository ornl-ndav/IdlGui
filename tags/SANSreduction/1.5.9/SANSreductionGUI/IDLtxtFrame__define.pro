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

;= This function builds the Main Base =========================================
FUNCTION IDLtxtFrame_make_base, MAIN_BASE, $
                                MAIN_BASE_UNAME, $
                                MAIN_BASE_XSIZE, $
                                XOFF, $
                                YOFF

base = WIDGET_BASE(MAIN_BASE,$
                   UNAME     = MAIN_BASE_UNAME,$
                   XOFFSET   = XOFF,$
                   YOFFSET   = YOFF,$
                   SCR_XSIZE = MAIN_BASE_XSIZE,$
                   SCR_YSIZE = 65,$
                   FRAME     = 0)
RETURN, base
END

;= This Function builds the frame and put the title of the frame ==============
PRO IDLtxtFrame_make_frame, BaseID, frame_title, main_base_xsize
title = WIDGET_LABEL(BaseID,$
                     XOFFSET = 20,$
                     YOFFSET = 5,$
                     VALUE   = frame_title)
frame = WIDGET_LABEL(BaseID,$
                     XOFFSET   = 5,$
                     YOFFSET   = 13,$
                     SCR_XSIZE = main_base_xsize-20,$
                     SCR_YSIZE = 40,$
                     FRAME     = 3,$
                     VALUE     = '')
END


;= Make BROWSE button =========================================
PRO IDLtxtFrame_make_browse_button, BaseID, browse_uname
button = WIDGET_BUTTON(BaseID,$
                       XOFFSET   = 15,$
                       YOFFSET   = 20,$
                       SCR_XSIZE = 80,$
                       SCR_YSIZE = 35,$
                       UNAME     = browse_uname,$
                       VALUE     = 'BROWSE ...')
END

;= Make text field of file Name ===============================================
PRO IDLtxtFrame_make_text_field, BaseID, text_field_uname
text_field = WIDGET_TEXT(BaseID,$
                         XOFFSET   = 100,$
                         YOFFSET   = 20,$
                         SCR_XSIZE = 895,$
                         SCR_YSIZE = 35,$
                         UNAME     = text_field_uname,$
                         /EDITABLE,$
                         /ALL_EVENTS)
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLtxtFrame::init, $
                      MAIN_BASE_ID    = main_base_id,$
                      MAIN_BASE_XSIZE = main_base_xsize,$
                      MAIN_BASE_UNAME = main_base_uname,$
                      XOFF            = xoff,$
                      YOFF            = yoff,$
                      FRAME_TITLE     = frame_title,$
                      LABEL_1         = label_1,$
                      BROWSE_UNAME    = browse_uname,$
                      FILE_NAME_UNAME = file_name_uname

;Make Base
BaseID = IDLtxtFrame_make_base(MAIN_BASE_ID, $
                               MAIN_BASE_UNAME, $
                               MAIN_BASE_XSIZE, $
                               XOFF, $
                               YOFF)

;Make BROWSE button
IDLtxtFrame_make_browse_button, BaseID, BROWSE_UNAME

;Make text field of file Name
IDLtxtFrame_make_text_field, BaseID, FILE_NAME_UNAME
               
;Make Title of Frame and Frame
IDLtxtFrame_make_frame, BaseID, FRAME_TITLE, MAIN_BASE_XSIZE

RETURN, 1
END

;******************************************************************************
PRO IDLtxtFrame__define
struct = {IDLtxtFrame,$
          var: 0}
END
