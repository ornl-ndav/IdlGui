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

;This method of the new class myIDLgrROI returns the inside_flag 
;1 means the ROI is inside the selection
;0 means the ROI is outside the selection
FUNCTION myIDLgrROI::getInsideFlag
RETURN, self.inside_flag
END

;==============================================================================
;This method of the new class myIDLgrROI sets the inside_flag
;1 means the ROI is inside the selection
;0 means the ROI is outside the selection
PRO myIDLgrROI::setInsideFlag, value
self.inside_flag = value
END

;------------------------------------------------------------------------------
;This procedure clears the Exclusion Region Selection Tool fields
PRO ClearInputBoxes, Event 
uname_array = ['x_center_value',$
               'y_center_value',$
               'r1_radii',$
               'r2_radii']
putArrayTextFieldValue, Event, uname_array, ''
END

;------------------------------------------------------------------------------
;This procedure will go screen pixel by screen pixel to check if the
;pixel is part of the selection and the result will depend on the
;settings of the selection
PRO  CreateArrayOfPixelSelected, PixelSelectedArray,$
                                 oROI,$
                                 CurrentSelectionSettings,$
                                 insideSelectionType

tmp_array = INTARR(80,80)
Xsize = 320*2
Ysize = 320*2
FOR i=0,(Xsize-1) DO BEGIN
    state_changed = 0 ;0,1,0 for inside selection and 1,0,1 for outside
    FOR j=0,(Ysize-1) DO BEGIN
        IF (insideSelectionType EQ 1b) THEN BEGIN ;if inside selection region
            IF (oROI->ContainsPoints(i,j) GT 0) THEN BEGIN
                x = FIX(i/8)
                y = FIX(j/8)
                ++tmp_array[x,y]
                state_changed = 1
            ENDIF ELSE BEGIN
                IF (state_changed EQ 1) THEN BREAK
            ENDELSE
        ENDIF ELSE BEGIN
            IF (oROI->ContainsPoints(i,j) EQ 0) THEN BEGIN
                x = FIX(i/8)
                y = FIX(j/8)
                ++tmp_array[x,y]
            ENDIF
        ENDELSE
    ENDFOR
ENDFOR

CASE (CurrentSelectionSettings) OF
;half in
    0: BEGIN
        IndexArray = WHERE(tmp_array GE 32) 
    END
;half out
    1: BEGIN
        IndexArray = WHERE(tmp_array GT 32) 
    END
;out in
    2: BEGIN
        IndexArray = WHERE(tmp_array GT 0) 
    END
;out out
    3: BEGIN
        IndexArray = WHERE(tmp_array EQ 64) 
    END
    ELSE:
ENDCASE

;only if IndexArray is not empty
IF (SIZE(IndexArray,/N_DIMENSION) EQ 1) THEN BEGIN 
    PixelSelectedArray(IndexArray) = 1
ENDIF

END

;------------------------------------------------------------------------------
PRO ExclusionRegionCircle, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

IF ((*global).data_nexus_file_name EQ '') THEN RETURN

;indicate initialization with hourglass icon
widget_control,/hourglass

struct = {myIDLgrROI, inside_flag: 1b, INHERITS IDLgrROI}

coeff = FLOAT((*global).DrawXcoeff)
PixelSelectedArray = INTARR(80,80)

;get x_center, y_center
x_center = getTextFieldValue(Event,'x_center_value')
Display_x_center = FLOAT(x_center) * coeff
y_center = getTextFieldValue(Event,'y_center_value')
Display_y_center = FLOAT(y_center) * coeff

;get R1
r1 = getTextFieldValue(Event,'r1_radii')
DisplayR1 = FLOAT(r1) * coeff
(*global).DisplayR1 = DisplayR1

IF (getCWBgroupValue(Event,'radii_r1_group') EQ 0) THEN BEGIN
    bR1Inside = 1
ENDIF ELSE BEGIN
    bR1Inside = 0
ENDELSE

;get R2
r2 = getTextFieldValue(Event,'r2_radii')
DisplayR2 = FLOAT(r2) * coeff
(*global).DisplayR2 = DisplayR2
IF (getCWBgroupValue(Event,'radii_r2_group') EQ 0) THEN BEGIN
    bR2Inside = 1
ENDIF ELSE BEGIN
    bR2Inside = 0
ENDELSE

;get type of selection
selection_type = (*global).exclusion_type_index

IF (DisplayR1 NE 0) THEN BEGIN    
;work on R1
    oROI = OBJ_NEW('myIDLgrROI',$
                   COLOR = 200,$
                   STYLE = 0)
    oROI->setInsideFlag, bR1Inside
    
    NewX = FLTARR(1)
    NewY = FLTARR(1)
    CIRCLE, FIX(Display_x_center), FIX(Display_y_center), DisplayR1, NewX, NewY
    newZ = INTARR(N_ELEMENTS(NewX))
    
    oROI->GetProperty, N_VERTS=nVerts
    oROI->ReplaceData, newX, newY, newZ, START=0, FINISH=nVerts-1
    oROI->SetProperty, STYLE=style
    
    CreateArrayOfPixelSelected, $
      PixelSelectedArray,$
      oROI,$
      selection_type,$
      bR1Inside

ENDIF

IF (DisplayR2 NE 0) THEN BEGIN
    
;work on R2
    oROI = OBJ_NEW('myIDLgrROI',$
                   COLOR = 200,$
                   STYLE = 0)
    oROI->setInsideFlag, bR2Inside
    
    NewX = FLTARR(1)
    NewY = FLTARR(1)
    CIRCLE, FIX(Display_x_center), FIX(Display_y_center), DisplayR2, NewX, NewY
    newZ = INTARR(N_ELEMENTS(NewX))
    
    oROI->GetProperty, N_VERTS=nVerts
    oROI->ReplaceData, newX, newY, newZ, START=0, FINISH=nVerts-1
    oROI->SetProperty, STYLE=style
    
    CreateArrayOfPixelSelected, $
      PixelSelectedArray,$
      oROI,$
      selection_type,$
      bR2Inside
    
ENDIF

;refresh plot
refresh_main_plot, Event

(*(*global).RoiPixelArrayExcluded) = PixelSelectedArray

IF (DisplayR1 NE 0 OR $
    DisplayR2 NE 0) THEN BEGIN

    OBJ_DESTROY, oROI
    (*global).there_is_a_selection = 1    

;plot ROI
    plotRoi, Event, $
      DisplayR1 = DisplayR1, $
      DisplayR2 = DisplayR2, $
      COEFF =     coeff
    
    resetROIfileName, Event

ENDIF ELSE BEGIN
    
    (*global).there_is_a_selection = 0
    
ENDELSE

;turn off hourglass
widget_control,hourglass=0
  
END

;------------------------------------------------------------------------------
;This procedure is in charged of only plotting the ROI
PRO plotROI, Event, $
             DisplayR1=DisplayR1, $
             DisplayR2=DisplayR2, $
             COEFF=coeff

WIDGET_CONTROL, Event.top, GET_UVALUE=global

id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
WIDGET_CONTROL, id, GET_VALUE = id_value
WSET, id_value

IF (N_ELEMENTS(COEFF) EQ 0) THEN  coeff = FLOAT((*global).DrawXcoeff)
IF (N_ELEMENTS(DisplayR1) EQ 0) THEN DisplayR1 = (*global).DisplayR1
IF (N_ELEMENTS(DisplayR2) EQ 0) THEN DisplayR2 = (*global).DisplayR2

PixelSelectedArray = (*(*global).RoiPixelArrayExcluded)

x_coeff = coeff
y_coeff = coeff
color   = 250
FOR i=0,(80L-1) DO BEGIN
    FOR j=0,(80L-1) DO BEGIN
        IF (PixelSelectedArray[i,j] EQ 1) THEN BEGIN
            plots, i*x_coeff, j*x_coeff, $
              /DEVICE, $
              COLOR=color
            plots, i*x_coeff, (j+1)*x_coeff, /DEVICE, $
              /CONTINUE, $
              COLOR=color
            plots, (i+1)*x_coeff, (j+1)*x_coeff, /DEVICE, $
              /CONTINUE, $
              COLOR=color
            plots, (i+1)*x_coeff, (j)*x_coeff, /DEVICE, $
              /CONTINUE, $
              COLOR=color
            plots, (i)*x_coeff, (j)*x_coeff, /DEVICE, $
              /CONTINUE, $
              COLOR=color
        ENDIF
    ENDFOR
ENDFOR

END

;------------------------------------------------------------------------------
;Type of selection (0:half_in, 1:half_out, 2:outside_in, 3:outside_out)
PRO exclusion_type, Event, INDEX=index
WIDGET_CONTROL, Event.top, GET_UVALUE=global
(*global).exclusion_type_index = index
END

;------------------------------------------------------------------------------
PRO PreviewExclusionRegionCircle, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;refresh plot
refresh_main_plot, Event

;indicate initialization with hourglass icon
widget_control,/hourglass

struct = {myIDLgrROI, inside_flag: 1b, INHERITS IDLgrROI}
coeff = FLOAT((*global).DrawXcoeff)
;get x_center, y_center
x_center = getTextFieldValue(Event,'x_center_value')
Display_x_center = FLOAT(x_center) * coeff
y_center = getTextFieldValue(Event,'y_center_value')
Display_y_center = FLOAT(y_center) * coeff

;get R1
r1 = getTextFieldValue(Event,'r1_radii')
DisplayR1 = FLOAT(r1) * coeff
IF (getCWBgroupValue(Event,'radii_r1_group') EQ 0) THEN BEGIN
    bR1Inside = 1
ENDIF ELSE BEGIN
    bR1Inside = 0
ENDELSE

;get R2
r2 = getTextFieldValue(Event,'r2_radii')
DisplayR2 = FLOAT(r2) * coeff
IF (getCWBgroupValue(Event,'radii_r2_group') EQ 0) THEN BEGIN
    bR2Inside = 1
ENDIF ELSE BEGIN
    bR2Inside = 0
ENDELSE

;get type of selection
selection_type = (*global).exclusion_type_index

;work on R1
oROI = OBJ_NEW('myIDLgrROI',$
               COLOR = 200,$
               STYLE = 0)
oROI->setInsideFlag, bR1Inside

NewX = FLTARR(1)
NewY = FLTARR(1)
CIRCLE, FIX(Display_x_center), FIX(Display_y_center), DisplayR1, NewX, NewY
newZ = INTARR(N_ELEMENTS(NewX))

oROI->GetProperty, N_VERTS=nVerts
oROI->ReplaceData, newX, newY, newZ, START=0, FINISH=nVerts-1
oROI->SetProperty, STYLE=style

draw_roi, oROI, /line_fill, thick=2, linestyle=0, orientation=90,/device

;work on R2
oROI = OBJ_NEW('myIDLgrROI',$
               COLOR = 200,$
               STYLE = 0)
oROI->setInsideFlag, bR2Inside

NewX = FLTARR(1)
NewY = FLTARR(1)
CIRCLE, FIX(Display_x_center), FIX(Display_y_center), DisplayR2, NewX, NewY
newZ = INTARR(N_ELEMENTS(NewX))

oROI->GetProperty, N_VERTS=nVerts
oROI->ReplaceData, newX, newY, newZ, START=0, FINISH=nVerts-1
oROI->SetProperty, STYLE=style

draw_roi, oROI, /line_fill, thick=2, linestyle=0, orientation=315,/device

OBJ_DESTROY, oROI

END

;------------------------------------------------------------------------------
PRO SaveAsExclusionRoi, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;retrieve infos
extension  = (*global).selection_extension
filter     = (*global).selection_filter
title      = (*global).selection_title
path       = (*global).selection_path

RoiFileName = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
                              FILTER            = filter,$
                              GET_PATH          = new_path,$
                              PATH              = path,$
                              TITLE             = title,$
                              /READ,$
                              /MUST_EXIST)

IF (RoiFileName NE '') THEN BEGIN
    length = 35
    folder = FILE_DIRNAME(RoiFileName,/MARK_DIRECTORY)
    (*global).selection_path = folder
    ;display only the last part of path
    sz = STRLEN(folder)
    IF (sz GT length) THEN BEGIN
        folder = '... ' + STRMID(folder,sz-length,length)
    ENDIF
    putNewButtonValue, Event, 'save_roi_folder_button',folder
    file   = FILE_BASENAME(RoiFileName)
    putTextFieldValue, Event, 'save_roi_text_field', file

;create roi file
    SaveExclusionFile, Event

ENDIF

END

;------------------------------------------------------------------------------
PRO SaveExclusionRoiFolderButton, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;retrieve infos
path  = (*global).selection_path
title = 'Select a Folder' 
folder = DIALOG_PICKFILE(GET_PATH          = new_path,$
                         PATH              = path,$
                         TITLE             = title,$
                         /DIRECTORY,$
                         /READ,$
                         /MUST_EXIST)

IF (folder NE '') THEN BEGIN
    (*global).selection_path = folder
    length = 35
;display only the last part of path
    sz = STRLEN(folder)
    IF (sz GT length) THEN BEGIN
        folder = '... ' + STRMID(folder,sz-length,length)
    ENDIF
    putNewButtonValue, Event, 'save_roi_folder_button',folder
ENDIF
END

;------------------------------------------------------------------------------
;This procedure create the ROI file 
PRO CreateROIfileFromExclusionArray, file_name, PixelExcludedArray
;indicate initialization with hourglass icon
widget_control,/hourglass
;get ROI array
pixel_excluded = PixelExcludedArray

sz1 = (size(pixel_excluded))(1) ;X
sz2 = (size(pixel_excluded))(2) ;Y
error = 0
CATCH, error
IF (error NE 0) then begin
    CATCH, /CANCEL
ENDIF ELSE BEGIN
;open output file
    openw, 1, file_name
    index_array = WHERE(pixel_excluded EQ 0, nbr)
    FOR i=0,(nbr-1) DO BEGIN
        y    = STRCOMPRESS(FIX(index_array[i]/sz1),/REMOVE_ALL)
        x    = STRCOMPRESS(index_array[i] MOD sz1,/REMOVE_ALL)
        bank = 'bank1_'
        text = bank + x + '_' + y
        printf, 1, text
    ENDFOR
    close, 1
    free_lun, 1
ENDELSE
;turn off hourglass
widget_control,hourglass=0
END

;------------------------------------------------------------------------------
PRO SaveExclusionFile, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
folder         = (*global).selection_path
file_name      = getTextfieldValue(Event,'save_roi_text_field')
full_file_name = folder + file_name
PixelExcludedArray = (*(*global).RoiPixelArrayExcluded)
CreateROIfileFromExclusionArray, full_file_name, PixelExcludedArray
putTextFieldValue, Event, 'roi_file_name_text_field', full_file_name
;enable PREVIEW button if file exist
IF (FILE_TEST(full_file_name)) THEN BEGIN
    activate_widget = 1
ENDIF ELSE BEGIN
    activate_widget = 0
ENDELSE
activate_widget, Event, 'preview_roi_exclusion_file', activate_widget
END

;------------------------------------------------------------------------------
PRO PreviewRoiExclusionFile, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
folder         = (*global).selection_path
file_name      = getTextfieldValue(Event,'save_roi_text_field')
full_file_name = folder + file_name
XDISPLAYFILE, full_file_name
END

;------------------------------------------------------------------------------
PRO SaveRoiTextFieldInteraction, Event 
WIDGET_CONTROL, Event.top, GET_UVALUE=global
folder         = (*global).selection_path
file_name      = getTextfieldValue(Event,'save_roi_text_field')
full_file_name = folder + file_name
IF (FILE_TEST(full_file_name)) THEN BEGIN
    activate_preview = 1
ENDIF ELSE BEGIN
    activate_preview = 0
ENDELSE
activate_widget, Event, 'preview_roi_exclusion_file', activate_preview
END

;------------------------------------------------------------------------------
;This procedure reset the name of the ROI file:
;    - when the user selects a new ROI
;    - ... (to be defined if necessary)
PRO resetROIfileName, Event
FullFileName = getTextFieldValue(Event,'data_file_name_text_field')
IF (FILE_TEST(FullFileName)) THEN BEGIN
    IF (N_ELEMENTS(RunNumber) EQ 0) THEN BEGIN
        iObject = OBJ_NEW('IDLgetMetadata',FullFileName)
        IF (OBJ_VALID(iObject)) THEN BEGIN
            RunNumber = iObject->getRunNumber()
        ENDIF ELSE BEGIN
            RunNumber = ''
        ENDELSE
    ENDIF
    default_name = 'SANS' 
    IF (RunNumber NE '') THEN BEGIN
        default_name += '_' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
    ENDIF
    DateIso = GenerateIsoTimeStamp()
    default_name += '_' + DateIso
    default_name += '_ROI.dat'
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    new_name = default_name
    putTextFieldValue, Event, 'save_roi_text_field', new_name
ENDIF
END
