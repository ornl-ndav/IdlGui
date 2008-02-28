;This function checks the Input File Format GUI
;and returns:
; 0  : distance ok and angle ok
; 1  : distance is empty and angle ok
; 2  : distance wrong and angle ok
; 10 : distance ok and angle empty
; 11 : distance empty and angle empty
; 12 : distance wrong and angle empty
; 20 : distance ok and angle wrong
; 21 : distance empty and angle wrong
; 22 : distance wrong and angle wrong
FUNCTION InputParameterStatus, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
 
isTOFselected = getButtonValidated(Event,'InputFileFormat')
Status = 0
IF (isTOFselected EQ 0) THEN BEGIN ;TOF is selected (else Q)
    
    distanceTextFieldValue = $
      getTextFieldValue(Event,$
                        'ModeratorDetectorDistanceTextField')
    distanceTextFieldValue = strcompress(distanceTextFieldValue,/remove_all)
    
;distance text field is blank
    IF (distanceTextFieldValue EQ '') THEN BEGIN
        
        Status = 1

    ENDIF ELSE BEGIN
        
;distance text field can't be turned into a float
        IF (isValueFloat(distanceTextFieldValue) NE 1) THEN BEGIN

            Status = 2

        ENDIF 

    ENDELSE
    
    angleTextFieldValue = $
      getTextFieldValue(Event,$
                        'AngleTextField')
    angleTextFieldValue = strcompress(angleTextFieldValue,/remove_all)
    
;angle text field is blank
    IF (angleTextFieldValue EQ '') THEN BEGIN

        Status += 10

    ENDIF ELSE BEGIN
        
;angle text field can't be turned into a float
        IF (isValueFloat(angleTextFieldValue) NE 1) THEN BEGIN

            Status += 20

        ENDIF ELSE BEGIN        ;else save angleValue

            (*global).angleValue = float(angleTextFieldValue)

        ENDELSE

    ENDELSE

ENDIF  

RETURN,Status
END

;###############################################################################
;*******************************************************************************

;This function will check if the LOAD button can be validated or no
PRO CheckOpenButtonStatus, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

InputParameter = InputParameterStatus(Event)
activateErrorBase = 1
validateLoadButton = 0

CASE (InputParameter) OF

    0: BEGIN                    ; ok
        validateLoadButton = 1
        activateErrorBase = 0
    END
    1: BEGIN                    ;distance empty and angle ok
        text = 'Dist. is empty'
    END
    2: BEGIN                    ;distance wrong and angle ok
        text = 'Angle has wrong format'
    END
    10: BEGIN                   ;distance ok but angle empty
        text = 'Angle is empty'
    END
    11: BEGIN                   ;distance and angle are empty
        text = 'Dist. & angle are empty'
    END
    12: BEGIN                   ;distance wrong and angle empty
        text = 'Dist. is wrong & angle empty'
    END
    20: BEGIN                   ;distance ok and angle wrong
        text = 'Angle has wrong format'
    END
    21: BEGIN                   ;distance is empty and angle is wrong
        text = 'Dist. empty & wrong angle format'
    END
    22: BEGIN                   ;distance and angle are wrong
        text = 'Dist. & angle have wrong format'
    END
    ELSE:

ENDCASE

activateErrorMessageBaseFunction, Event, activateErrorBase
DisplayErrorMessage, Event, text
ActivateButton, Event, 'ok_load_button', validateLoadButton

END

;###############################################################################
;*******************************************************************************

;This function moves the color slider by the index given as an input
;parameter (>0 will move it to the right, <0 to move it to the left)
PRO MoveColorIndex_by_index, Event, index

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get current color Index selected
ColorIndex = getColorIndex(Event)
 
PreviousColorIndex = (*global).PreviousColorIndex
IF (ColorIndex EQ PreviouscolorIndex) THEN BEGIN
    
    ColorIndex = ColorIndex + index
    (*global).PreviousColorIndex = ColorIndex
    id = widget_info(Event.top,find_by_uname='list_of_color_slider')
    widget_control, id, set_value=ColorIndex
    
ENDIF
END

;###############################################################################
;*******************************************************************************

;This function moves the color index to the right position
PRO MoveColorIndex,Event

index = + 25
MoveColorIndex_by_index, Event, index

END

;###############################################################################
;*******************************************************************************

;This function moves back the color index when the loading process failed
PRO MoveColorIndexBack,Event

index = - 25
MoveColorIndex_by_index, Event, index
 
END

