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

;##############################################################################
;******************************************************************************

;This function defines the new color and moves the slider if necessary
PRO defineColorIndex, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
list_of_color_slider_id = widget_info(event.top, $
                                      find_by_uname='list_of_color_slider')
widget_control, list_of_color_slider_id, get_value = ColorIndex

PreviousColorIndex = (*global).PreviousColorIndex
if (ColorIndex EQ (PreviouscolorIndex)) Then begin
    ColorIndex += 25
    MoveColorIndex,Event,ColorIndex
    (*global).PreviousColorIndex = ColorIndex
endif 
END

;******************************************************************************

;This function remove the short file name and keep
;the path and reset the default working path
Function DEFINE_NEW_DEFAULT_WORKING_PATH, Event, file
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
path = get_path_to_file_name(file)
(*global).input_path = path ;reset the default path
return, path
end

;******************************************************************************

;This function reset various parameters when a new session is launched 
;(full reset)
PRO ResetAllOtherParameters, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
(*global).FirstTimePlotting = 1 ;next load will be the first one
END

;******************************************************************************

PRO populateColorLabel, Event, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
SelectedIndex = getSelectedIndex(Event,'list_of_files_droplist')
ListShortFileName = (*(*global).list_of_files)
fileName = ListShortFileName[SelectedIndex]
fileName = '(-> ' + fileName + ')'
END

;******************************************************************************
;this function activate (if validateMap=1) or desactive-hide(if validateMap=0)
;the RescaleBase
PRO ActivateRescaleBase, Event, validateMap
RescaleBaseId = widget_info(Event.top,find_by_uname='RescaleBase')
widget_control, RescaleBaseId, map=validateMap
END

;******************************************************************************
;This function activates or not the CLEAR file button
PRO ActivateClearFileButton, Event, ValidateButton
ClearButtonId = widget_info(Event.top,find_by_uname='clear_button')
widget_control, ClearButtonId, sensitive=ValidateButton
END

;------------------------------------------------------------------------------
PRO ref_scale_file_utility
END
