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

;This function reset all the arrays (Q1,Q2,SF,list_of_files and
;ListOfLongFileName)
PRO ResetArrays, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

list_of_files      = strarr(1)
list_OF_files[0]   = '                                                   '
Qmin_array         = fltarr(1)
Qmax_array         = fltarr(1)
Q1_array           = lonarr(1)
Q2_array           = lonarr(1)
SF_array           = lonarr(1)
angle_array        = fltarr(1)
color_array        = lonarr(1)
color_array[0]     = getColorIndex(Event) ;_get
ListOfLongFileName = strarr(1)
FileHistory        = strarr(1)

(*(*global).list_of_files)      = list_of_files
(*(*global).Qmin_array)         = Qmin_array
(*(*global).Qmax_array)         = Qmax_array
(*(*global).Q1_array)           = Q1_array
(*(*global).Q2_array)           = Q2_array
(*(*global).SF_array)           = SF_array
(*(*global).angle_array)        = angle_array
(*(*global).color_array)        = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName
(*(*global).FileHistory)        = FileHistory

EnableMainBaseButtons, Event, 0 ;_Gui

END

;##############################################################################
;******************************************************************************

;This function remove the value at the index iIndex
PRO RemoveIndexFromList, Event, iIndex

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

FileHistory        = (*(*global).FileHistory)
ListOfFiles        = (*(*global).list_of_files)
Qmin_array         = (*(*global).Qmin_array)
Qmax_array         = (*(*global).Qmax_array)
Q1_array           = (*(*global).Q1_array)
Q2_array           = (*(*global).Q2_array)
SF_array           = (*(*global).SF_array)
angle_array        = (*(*global).angle_array)
color_array        = (*(*global).color_array)
ListOfLongFileName = (*(*global).ListOfLongFileName)

FileHistory        = ArrayDelete(FileHistory,At=iIndex,Length=1)
ListOfFiles        = ArrayDelete(ListOfFiles,AT=iIndex,Length=1)
Qmin_array         = ArrayDelete(Qmin_array,AT=iIndex,Length=1)
Qmax_array         = ArrayDelete(Qmax_array,AT=iIndex,Length=1)
Q1_array           = ArrayDelete(Q1_array,AT=iIndex,Length=1)
Q2_array           = ArrayDelete(Q2_array,AT=iIndex,Length=1)
SF_array           = ArrayDelete(SF_array,AT=iIndex,Length=1)
angle_array        = ArrayDelete(angle_array,AT=iIndex,Length=1)
color_array        = ArrayDelete(color_array,AT=iIndex,Length=1)
ListOfLongFileName = ArrayDelete(ListOfLongFileName,AT=iIndex,Length=1)

(*(*global).FileHistory)        = FileHistory
(*(*global).list_of_files)      = ListOfFiles
(*(*global).Qmin_array)         = Qmin_array
(*(*global).Qmax_array)         = Qmax_array
(*(*global).Q1_array )          = Q1_array
(*(*global).Q2_array)           = Q2_array
(*(*global).SF_array)           = SF_array
(*(*global).angle_array)        = angle_array
(*(*global).color_array)        = color_array
(*(*global).ListOfLongFileName) = ListOfLongFileName

END

;##############################################################################
;******************************************************************************

;this function removes from the Q1,Q2,SF and List_of_files, the info at 
;given index iIndex
PRO RemoveIndexFromArray, Event, iIndex

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

;check size of array
ListOfFiles     = (*(*global).list_of_files)
ListOfFilesSize = getSizeOfArray(ListOfFiles) ;_get

;if array contains only 1 element, reset all arrays
if (ListOfFilesSize EQ 1) then begin
    
    ResetArrays,Event  ;_utility
    ActivateRescaleBase, Event, 0 ;_Gui
    (*global).NbrFilesLoaded = 0

endif else begin

   RemoveIndexFromList, Event, iIndex ;_utility
   (*global).NbrFilesLoaded -= 1

endelse
END

;##############################################################################
;******************************************************************************

;this function does a full true reset of color index
;ie: is reset to 100/red
PRO ReinitializeColorArray, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

color_array               = lonarr(1)
color_array[0]            = (*global).ColorSliderDefaultValue
(*(*global).color_array)  = color_array

END

;##############################################################################
;******************************************************************************

;This function clears the contain of all the droplists
PRO ClearAllDropLists, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
 
;clear off list of file in droplist of step1
id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, id, set_value=['']

;clear off list of file in droplists of step3
id = widget_info(Event.top, find_by_uname='step3_work_on_file_droplist')
widget_control, id, set_value=['']

END

;##############################################################################
;******************************************************************************

PRO ref_scale_utility
END
