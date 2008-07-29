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

IF (DisplayR1 NE 0 OR $
    DisplayR2 NE 0) THEN BEGIN
    
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
    
    OBJ_DESTROY, oROI
    
ENDIF

;turn off hourglass
widget_control,hourglass=0



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
