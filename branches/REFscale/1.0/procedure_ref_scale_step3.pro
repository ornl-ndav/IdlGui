;===============================================================================
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
;===============================================================================

;###############################################################################
;*******************************************************************************
;This is the main function that will do the scaling of all the loaded
;files one after the other
PRO Step3AutomaticRescaling, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

IDLsendToGeek_addLogBookText, Event, '> Automatic Rescaling :' 

flt0_rescale_ptr = (*global).flt0_rescale_ptr
flt1_rescale_ptr = (*global).flt1_rescale_ptr
flt2_rescale_ptr = (*global).flt2_rescale_ptr
Qmin_array       = (*(*global).Qmin_array)
Qmax_array       = (*(*global).Qmax_array)

;get number of files loaded
nbrFile = (*global).NbrFilesLoaded
IDLsendToGeek_addLogBookText, Event, '-> Number of files loaded : ' + $
  STRCOMPRESS(nbrFile,/REMOVE_ALL)

FOR i=1,(nbrFile-1) DO BEGIN

    IDLsendToGeek_addLogBookText, Event, '--> Working with File # ' + $
      STRCOMPRESS(i,/REMOVE_ALL)
    
    CurrentFileName = getFileFromIndex(Event, i)
    IDLsendToGeek_addLogBookText, Event, '---> Name of File : ' + $
      CurrentFileName

;get Qmin and Qmax
    Qmin = float(Qmin_array[i])
    Qmax = float(Qmax_array[i-1])
    IDLsendToGeek_addLogBookText, Event, '---> Qmin : ' + $
      STRCOMPRESS(Qmin,/REMOVE_ALL)
    IDLsendToGeek_addLogBookText, Event, '---> Qmax : ' + $
      STRCOMPRESS(Qmax,/REMOVE_ALL)
    
;Number of data to exclude from auto-fitting
    Ncrap = getTextFieldValue(Event,'min_crap_text_field') ;_get
    Ncrap = fix(Ncrap)

;HIGH Q file
;get flt0 of high Q file
    flt0_highQ = *flt0_rescale_ptr[i]
    flt1_highQ = *flt1_rescale_ptr[i]
    flt2_highQ = *flt2_rescale_ptr[i]

;determine the working indexes of flt0, flt1 and flt2 for high Q file
    RangeIndexes = getArrayRangeFromQ1Q2(flt0_highQ, Qmin, Qmax) ;_get
    left_index   = RangeIndexes[0]
    right_index  = RangeIndexes[1]
    IDLsendToGeek_addLogBookText, Event, '---> left_index  : ' + $
      STRCOMPRESS(left_index,/REMOVE_ALL)
    IDLsendToGeek_addLogBookText, Event, '---> right_index : ' + $
      STRCOMPRESS(right_index,/REMOVE_ALL)
    
;determine working range of low Q file
    flt0_highQ_new = flt0_highQ[left_index:right_index]
    flt1_highQ_new = flt1_highQ[left_index:right_index]
    flt2_highQ_new = flt2_highQ[left_index:right_index]

;set to 0 the indefined data 
    flt1_highQ_new = getArrayOfInfValues(flt1_highQ_new) ;_get
    
;remove points that have error GE than their values
    RangeIndexes   = GEValue(flt1_highQ_new, flt2_highQ_new) ;_get
    flt0_highQ_new = flt0_highQ_new(RangeIndexes)
    flt1_highQ_new = flt1_highQ_new(RangeIndexes)
    flt2_highQ_new = flt2_highQ_new(RangeIndexes)

;LOW Q file
;get flt0 of low Q file
    flt0_lowQ = *flt0_rescale_ptr[i-1]
    flt1_lowQ = *flt1_rescale_ptr[i-1]
    flt2_lowQ = *flt2_rescale_ptr[i-1]

;determine the working indexes of flt0, flt1 and flt2 for low Q file
    RangeIndexes = getArrayRangeFromQ1Q2(flt0_lowQ, Qmin, Qmax) ;_get
    left_index   = RangeIndexes[0]
    right_index  = RangeIndexes[1]
    
;determine working range of high Q file
    flt0_lowQ_new = flt0_lowQ[left_index:right_index]
    flt1_lowQ_new = flt1_lowQ[left_index:right_index]
    flt2_lowQ_new = flt2_lowQ[left_index:right_index]

;set to 0 the indefined data 
    flt1_lowQ_new = getArrayOfInfValues(flt1_lowQ_new) ;_get

;remove the non defined and inf values from flt0_lowQ, flt1_lowQ and flt2_lowQ
    RangeIndexes  = getArrayRangeOfNotNanValues(flt1_lowQ_new) ;_get
    flt0_lowQ_new = flt0_lowQ_new(RangeIndexes)
    flt1_lowQ_new = flt1_lowQ_new(RangeIndexes)
    flt2_lowQ_new = flt2_lowQ_new(RangeIndexes)

;remove points that have error GE than their values
    RangeIndexes  = GEvalue(flt1_LowQ_new, flt2_LowQ_new) ;_get
    flt0_LowQ_new = flt0_LowQ_new(RangeIndexes)
    flt1_LowQ_new = flt1_LowQ_new(RangeIndexes)
    flt2_LowQ_new = flt2_LowQ_new(RangeIndexes)

;Calculate the data totals
    TLowQflt1  = total(flt1_LowQ_new[Ncrap:*])
    THighQflt1 = total(flt1_highQ_new[Ncrap:*])

;Calculate the Q totals
    TLowQflt0  = total(flt0_LowQ_new[Ncrap:*])
    THighQflt0 = total(flt0_HighQ_new[Ncrap:*])

;SF
    SF = (TLowQflt0 * THighQflt1)/(TLowQflt1 * THighQflt0)
    IDLsendToGeek_addLogBookText, Event, '---> SF : ' + $
    STRCOMPRESS(SF,/REMOVE_ALL)

;store the SF
    SF_array = (*(*global).SF_array)
    SF_array[i] = SF
    (*(*global).SF_array) = SF_array

;Rescale the initial data
    flt1_rescale_ptr = (*global).flt1_rescale_ptr
    flt2_rescale_ptr = (*global).flt2_rescale_ptr

    flt1_highQ = *flt1_rescale_ptr[i]
    flt2_highQ = *flt2_rescale_ptr[i]

    flt1_highQ = flt1_highQ / SF
    flt2_highQ = flt2_highQ / SF

    *flt1_rescale_ptr[i] = flt1_highQ
    *flt2_rescale_ptr[i] = flt2_HighQ

    (*global).flt1_rescale_ptr = flt1_rescale_ptr
    (*global).flt2_rescale_ptr = flt2_rescale_ptr

ENDFOR

plot_loaded_file, Event, '2plots' ;_Plot
IDLsendToGeek_showLastLineLogBook, Event

END

;###############################################################################
;*******************************************************************************

;This function displays the flt0, flt1 array of the low Q file and the flt1
;array of the high Q file
PRO Step3OutputFlt0Flt1, Event

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

;get selected index of droplist
index = getSelectedIndex(Event,'step3_work_on_file_droplist')

flt0_ptr = (*global).flt0_rescale_ptr
flt1_ptr = (*global).flt1_rescale_ptr

flt0_lowQ  = *flt0_ptr[index-1]
flt0_highQ = *flt0_ptr[index]
flt1_lowQ  = *flt1_ptr[index-1]
flt1_highQ = *flt1_ptr[index]
Q1         = (*(*global).Qmin_array)
Q2         = (*(*global).Qmax_array)

;Qmin and Qmax
QminHighQ = Q1[index]
QmaxLowQ  = Q2[index-1]

;remove -inf, inf and NAN values from flt1_lowQ and flt1_highQ
flt1_lowQ_range = getArrayRangeOfNotNanValues(flt1_lowQ) ;_get
flt1_lowQ       = flt1_lowQ(flt1_lowQ_range)
flt0_lowQ       = flt0_lowQ(flt1_lowQ_range)

flt1_highQ_range = getArrayRangeOfNotNanValues(flt1_highQ) ;_get
flt1_highQ       = flt1_highQ(flt1_highQ_range)
flt0_highQ       = flt0_highQ(flt1_highQ_range)

;get index of values inside range of data
;check where to start, Qmin of HighQ for each flt0
flt0_lowQ_index_array = $
  getArrayRangeFromQ1Q2(flt0_LowQ, QminHighQ, QmaxLowQ) ;_get
flt0_lowQ = flt0_lowQ[flt0_lowQ_index_array[0]:flt0_lowQ_index_array[1]]
flt1_lowQ = flt1_lowQ[flt0_lowQ_index_array[0]:flt0_lowQ_index_array[1]]

flt0_highQ_index_array = $
  getArrayRangeFromQ1Q2(flt0_HighQ, QminHighQ, QmaxLowQ) ;_get
flt0_highQ = flt0_highQ[flt0_highQ_index_array[0]:flt0_highQ_index_array[1]]
flt1_highQ = flt1_highQ[flt0_highQ_index_array[0]:flt0_highQ_index_array[1]]

;create master_flt0 (addtion of flt0_low and flt0_high)
;WORK on flt0
flt0_lowQ  = flt0_lowQ[sort(flt0_lowQ)]
flt0_highQ = flt0_highQ[sort(flt0_highQ)]
flt0       = [flt0_lowQ, flt0_highQ]
flt0_uniq  = flt0[uniq(flt0,sort(flt0))]
flt0_size  = (size(flt0_uniq))(1)

nbr_to_display = float(getTextFieldValue(Event,'nbrDataTextField')) ;_get

IF (nbr_to_display LE flt0_size) THEN BEGIN
    max_number = nbr_to_display
ENDIF ELSE BEGIN
    max_number = flt0_size
ENDELSE

max_number = max_number[0]

i_lowQ  = 0
i_highQ = 0
FOR i=0,(max_number-1) DO BEGIN
   text = strcompress(flt0_uniq[i])
   text += "-----"
   IF (flt0_lowQ[i_lowQ] EQ flt0_uniq[i]) THEN BEGIN
      text = text + strcompress(flt1_lowQ[i_lowQ])
      i_lowQ += 1
   ENDIF ELSE BEGIN
      text += '---------'
   ENDELSE
   text += "-----"
   IF (flt0_highQ[i_highQ] EQ flt0_uniq[i]) THEN BEGIN
      text =  text + strcompress(flt1_highQ[i_highQ])
      i_highQ += 1
   ENDIF
   IF (i EQ 0) THEN BEGIN
       putValueInTextField,Event,'step3_flt_text_field',text ;_put
   ENDIF ELSE BEGIN
       appendValueInTextField,Event,'step3_flt_text_field',text  ;_put
   ENDELSE
ENDFOR
IDLsendToGeek_showLastLineLogBook, Event
END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^

;This function rescale manually the working file using the new SF 
PRO Step3RescaleFile, Event, delta_SF

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

IDLsendToGeek_addLogBookText, Event, '> Manual Rescaling :' 

index = getSelectedIndex(Event,'step3_work_on_file_droplist')
CurrentFileName = getFileFromIndex(Event, index)
IDLsendToGeek_addLogBookText, Event, '> Manual Rescaling of : ' + $
  CurrentFileName

flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr

;get value of current SF
sSF = getTextFieldValue(Event,'Step3SFTextField') ;_get
SF  = float(sSF)
SF += float(delta_SF)

if (SF LE 0) then begin
    SF = float(0.001)
endif

IDLsendToGeek_addLogBookText, Event, '-> SF : ' + STRCOMPRESS(SF,/REMOVE_ALL)

;put new SF value in text box
putValueInTextField, Event,'Step3SFTextField',SF ;_put

;get selected index of droplist
index = getSelectedIndex(Event,'step3_work_on_file_droplist') ;_get

flt1 = *flt1_ptr[index]
flt2 = *flt2_ptr[index]

SF = SF[0]

;rescale data
flt1 = flt1 / SF
flt2 = flt2 / SF

flt1_rescale_ptr = (*global).flt1_rescale_ptr
flt2_rescale_ptr = (*global).flt2_rescale_ptr

*flt1_rescale_ptr[index] = flt1
*flt2_rescale_ptr[index] = flt2

(*global).flt1_rescale_ptr = flt1_rescale_ptr
(*global).flt2_rescale_ptr = flt2_rescale_ptr

plot_loaded_file, Event, '2plots' ;_Plot

;this function displays in step3 the list of flt0, flt1 for low Q file
;and flt1 for high Q file only if user wants too.
displayData = getButtonValidated(Event,'display_value_yes_no') ;_get
IF (displayData EQ 0) THEN BEGIN
    Step3OutputFlt0Flt1, Event ;_Step3
ENDIF ELSE BEGIN ;clear text box
    putValueInTextField, Event,'step3_flt_text_field','' ;_put
ENDELSE
IDLsendToGeek_showLastLineLogBook, Event
END

;###############################################################################
;*******************************************************************************

;This function rescale manually the working file using the new SF 
PRO Step3RescaleFile2, Event, delta_SF

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

IDLsendToGeek_addLogBookText, Event, '> Manual Rescaling :' 

;get selected index of droplist
index = getSelectedIndex(Event,'step3_work_on_file_droplist')
CurrentFileName = getFileFromIndex(Event, index)
IDLsendToGeek_addLogBookText, Event, '> Manual Rescaling of : ' + $
  CurrentFileName

flt1_ptr = (*global).flt1_ptr
flt2_ptr = (*global).flt2_ptr

;get value of current SF
SF  = float(delta_SF)

if (SF LE 0) then begin
    SF = float(0.0001)
endif

;get selected index of droplist
index = getSelectedIndex(Event,'step3_work_on_file_droplist') ;_get

flt1 = *flt1_ptr[index]
flt2 = *flt2_ptr[index]

SF = SF[0]

IDLsendToGeek_addLogBookText, Event, '-> SF : ' + STRCOMPRESS(SF,/REMOVE_ALL)

;rescale data
flt1 = flt1 / SF
flt2 = flt2 / SF

flt1_rescale_ptr = (*global).flt1_rescale_ptr
flt2_rescale_ptr = (*global).flt2_rescale_ptr

*flt1_rescale_ptr[index] = flt1
*flt2_rescale_ptr[index] = flt2

(*global).flt1_rescale_ptr = flt1_rescale_ptr
(*global).flt2_rescale_ptr = flt2_rescale_ptr

plot_loaded_file, Event, '2plots' ;_Plot

;this function displays in step3 the list of flt0, flt1 for low Q file
;and flt1 for high Q file only if user wants too.
displayData = getButtonValidated(Event,'display_value_yes_no') ;_get
IF (displayData EQ 0) THEN BEGIN
    Step3OutputFlt0Flt1, Event ;_Step3
ENDIF ELSE BEGIN ;clear text box
    putValueInTextField, Event,'step3_flt_text_field','' ;_put
ENDELSE
IDLsendToGeek_showLastLineLogBook, Event
END

;###############################################################################
;*******************************************************************************

;This function will disable the widgets of step3 if
;the first file (CE file) is selected 
PRO ManageStep3Tab, Event 

index = getSelectedIndex(Event,'step3_work_on_file_droplist') ;_get
IF (index EQ 0) THEN BEGIN 
    ;disable all widgets of step3
    enableStep3Widgets,Event,0 ;_Gui
ENDIF ELSE BEGIN
    ;enable all widgets of step3
    enableStep3Widgets,Event,1 ;_Gui
endelse

END

;###############################################################################
;*******************************************************************************

;This function is reached only when the CE file of step 3 has been
;selected in the droplist. In this case, all the widgets of the manual
;scalling box are hidden
PRO Step3DisableManualScalingBox, Event
HideBase, Event, 'Step3ManualModeHiddenFrame', 0
END

;###############################################################################
;*******************************************************************************

;This function is reached only when the selected file in the step 3
;droplist is any of the file except the first one (CE file). In this
;case, all the widgets of the manual scalling box are shown.
PRO Step3EnableManualScalingBox, Event
HideBase, Event, 'Step3ManualModeHiddenFrame', 1
END

;###############################################################################
;*******************************************************************************

;This function displays the base file name unless the first file is
;selected, in this case, it shows that the working file is the CE file
PRO Step3DisplayLowQFileName, Event, indexSelected

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

IF (indexSelected EQ 0) THEN BEGIN
    textHighQ = 'C.E. file ->'
    textLowQ  = ''
    text      = ''
    text2     = ''
ENDIF ELSE BEGIN
    textLowQ      = 'Low Q file:'
    textHighQ     = 'High Q file:'
    list_of_files = (*(*global).list_of_files)
    text  = list_of_files[indexSelected-1]
    text2 = list_of_files[indexSelected]
ENDELSE
putValueInLabel, Event, 'Step3ManualModeLowQFileLabel',textLowQ ;_put
putValueInLabel, Event, 'Step3ManualModeHighQFileLabel',textHighQ ;_put
putValueInLabel, Event, 'Step3ManualModeLowQFileName',text ;_put
END

;###############################################################################
;*******************************************************************************

;This function displays the SF of the selected file
PRO Step3_display_SF_values, Event,index

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

SF_array = (*(*global).SF_array)

IF (index NE 0) THEN BEGIN
    SF = SF_array[index]
ENDIF ELSE BEGIN
    SF = ''
ENDELSE
GuisetValue, Event, 'Step3SFTextField', SF ;_Gui
END

;###############################################################################
;*******************************************************************************
PRO procedure_ref_scale_step3
END
