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
                                 insideSelectionType,$
                                 TYPE=type

tmp_array = INTARR(80,80)
IF (N_ELEMENTS(TYPE) EQ 0) THEN type = 'accurate' ;default type

Xsize = 320*2
Ysize = 320*2
IF (type EQ 'accurate') THEN BEGIN ;accurate
    FOR i=0,(Xsize-1) DO BEGIN
        state_changed = 0 ;0,1,0 for inside selection and 1,0,1 for outside
        FOR j=0,(Ysize-1) DO BEGIN
;if inside selection region
            IF (insideSelectionType EQ 1b) THEN BEGIN 
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
ENDIF ELSE BEGIN                ;fast
    Xsize = 320*2
    Ysize = 320*2
    FOR i=0,(Xsize-1),4 DO BEGIN
        state_changed = 0 ;0,1,0 for inside selection and 1,0,1 for outside
        FOR j=0,(Ysize-1) DO BEGIN
;if inside selection region
            IF (insideSelectionType EQ 1b) THEN BEGIN
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
ENDELSE

IF (type EQ 'accurate') THEN BEGIN ;accurate

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

ENDIF ELSE BEGIN ;fast

    CASE (CurrentSelectionSettings) OF
;half in
        0: BEGIN
            IndexArray = WHERE(tmp_array GE 8) 
        END
;half out
        1: BEGIN
            IndexArray = WHERE(tmp_array GT 8) 
        END
;out in
        2: BEGIN
            IndexArray = WHERE(tmp_array GT 0) 
        END
;out out
        3: BEGIN
            IndexArray = WHERE(tmp_array EQ 16) 
        END
        ELSE:
    ENDCASE

ENDELSE

;only if IndexArray is not empty
IF (SIZE(IndexArray,/N_DIMENSION) EQ 1) THEN BEGIN 
    PixelSelectedArray(IndexArray) = 1
ENDIF

END

;------------------------------------------------------------------------------
PRO ExclusionRegionCircle, Event, TYPE=type
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
      bR1Inside, $
      TYPE=type

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
      bR2Inside,$
      TYPE=type
      
    
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
;------------------------------------------------------------------------------
PRO ExclusionRegionRectangle, Event, TYPE=type
WIDGET_CONTROL, Event.top, GET_UVALUE=global

IF ((*global).data_nexus_file_name EQ '') THEN RETURN

;indicate initialization with hourglass icon
widget_control,/hourglass

struct = {myIDLgrROI, inside_flag: 1b, INHERITS IDLgrROI}

coeff = FLOAT((*global).DrawXcoeff)
PixelSelectedArray = INTARR(80,80)

;get X0, Y0, X1 and Y1
XY0 = (*global).Rectangle_XY0_mouse
X0 = XY0[0] 
Y0 = XY0[1]
XY1 = (*global).Rectangle_XY1_mouse
X1 = XY1[0]
Y1 = XY1[1]

X0 = MIN([X0,X1],MAX=X1)
Y0 = MIN([Y0,Y1],MAX=Y1)

;check if in or out
IF (getCWBgroupValue(Event,'rectangle_in_out_group') EQ 0) THEN BEGIN ;inside
    inside_selection = 1b
ENDIF ELSE BEGIN ;outside
    inside_selection = 0b
ENDELSE

;get type of selection
selection_type = (*global).exclusion_type_index

IF (X0 NE 0 AND $
    Y0 NE 0 AND $
    X1 NE 0 AND $
    Y1 NE 0) THEN BEGIN

    oROI = OBJ_NEW('myIDLgrROI',$
                   COLOR = (*global).rectangle_selection_color,$
                   STYLE = 0)
    oROI->setInsideFlag, inside_selection
    
    NewX = [X0,X1,X1,X0,X0]
    NewY = [Y0,Y0,Y1,Y1,Y0]
    newZ = INTARR(N_ELEMENTS(NewX))
    
    oROI->GetProperty, N_VERTS=nVerts
    oROI->ReplaceData, newX, newY, newZ, START=0, FINISH=nVerts-1
    oROI->SetProperty, STYLE=style
    
    CreateArrayOfPixelSelected, $
      PixelSelectedArray,$
      oROI,$
      selection_type,$
      inside_selection, $
      TYPE=type

;refresh plot
    refresh_main_plot, Event
    
    (*(*global).RoiPixelArrayExcluded) = PixelSelectedArray
    
    OBJ_DESTROY, oROI
    (*global).there_is_a_selection = 1    
    
;plot ROI
    plotRoi, Event, $
      DisplayR1 = DisplayR1, $
      DisplayR2 = DisplayR2, $
      COEFF =     coeff
    
    resetROIfileName, Event
    
ENDIF ELSE BEGIN
    
;    (*global).there_is_a_selection = 0
    
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

;------------------------------------------------------------------------------
PRO FastExclusionRegionCircle, Event 
;check if user wants circle or rectangle
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='circle_in_out_button')
IF (WIDGET_INFO(id, /BUTTON_SET) EQ 1) THEN BEGIN ;circle
    ExclusionRegionCircle, Event, TYPE='fast'
ENDIF ELSE BEGIN ;rectangle
    ExclusionRegionRectangle, Event, TYPE='fast'
ENDELSE
END

;------------------------------------------------------------------------------
PRO AccurateExclusionRegionCircle, Event 
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='circle_in_out_button')
IF (WIDGET_INFO(id, /BUTTON_SET) EQ 1) THEN BEGIN ;circle
    ExclusionRegionCircle, Event, TYPE='accurate'
ENDIF ELSE BEGIN ;rectangle
    ExclusionRegionRectangle, Event, TYPE='accurate'
ENDELSE
END

;------------------------------------------------------------------------------
PRO EnableCircleBase, Event
uname_list = ['rectangle_base_part_1',$
              'rectangle_base_part_2']
map_base_list, Event, uname_list, 0
END

;------------------------------------------------------------------------------
PRO EnableRectangleBase, Event
uname_list = ['rectangle_base_part_1',$
              'rectangle_base_part_2']
map_base_list, Event, uname_list, 1
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

PRO RectangleLeftClick, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
XY0 = (*global).rectangle_XY0_mouse
XY0[0] = Event.x
XY0[1] = Event.y
(*global).rectangle_XY0_mouse = XY0
END

;------------------------------------------------------------------------------
PRO RectangleReleased, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
XY0 = (*global).rectangle_XY0_mouse
XY1 = (*global).rectangle_XY1_mouse
END

;------------------------------------------------------------------------------
PRO RectangleMoving, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
refresh_main_plot, Event ;refresh main plot (without selection)
;plot selection borders
XY0 = (*global).rectangle_XY0_mouse
X0 = XY0[0]
Y0 = XY0[1]
X1 = Event.x
Y1 = Event.y
color = (*global).rectangle_selection_color
plots, X0, Y0, /DEVICE, COLOR=color
plots, X1, Y0, /DEVICE, COLOR=color, /CONTINUE
plots, X1, Y1, /DEVICE, COLOR=color, /CONTINUE
plots, X0, Y1, /DEVICE, COLOR=color, /CONTINUE
plots, X0, Y0, /DEVICE, COLOR=color, /CONTINUE
(*global).rectangle_XY1_mouse = [X1,Y1]
END

;------------------------------------------------------------------------------
PRO select_rectangle, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global
IF(Event.type EQ 0 AND $
   Event.press EQ 1) THEN BEGIN ;left press button
    (*global).mouse_status = 1
    RectangleLeftClick, Event
ENDIF
IF (Event.type EQ 1) THEN BEGIN ;released left button
    (*global).mouse_status = 0
    RectangleReleased, Event
ENDIF
IF (Event.type EQ 2 AND $
    (*global).mouse_status EQ 1) THEN BEGIN ;moving left button
    RectangleMoving, Event
ENDIF
END
