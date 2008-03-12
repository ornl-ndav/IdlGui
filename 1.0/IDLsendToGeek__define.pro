;-------------------------------------------------------------------------------
;This method define the send_to_geek_base
FUNCTION MakeBase, MainBase,$ 
                   XOFFSET, $
                   YOFFSET, $
                   XSIZE

STGbase = WIDGET_BASE(MainBase,$
                      XOFFSET   = XOFFSET-5,$
                      YOFFSET   = YOFFSET-10,$
                      SCR_XSIZE = XSIZE+10,$
                      SCR_YSIZE = 60,$
                      UNAME     = 'send_to_geek_base',$
                      SENSITIVE = 0)
RETURN, STGbase
END



;-------------------------------------------------------------------------------
;This method plots the Frame and add the title 
PRO MakeFrame, STGbase, $
               XSIZE, $
               FRAME,$
               TITLE

;Define structures
sFrame = { size : [5,$
                   10,$
                   XSIZE,$
                   45],$
           frame : FRAME}

sTitle = { size : [20,$
                   sFrame.size[1]-8],$
           value : TITLE}
                  
;Define GUI
wTitle = WIDGET_LABEL(STGbase,$
                      XOFFSET = sTitle.size[0],$
                      YOFFSET = sTitle.size[1],$
                      VALUE   = sTitle.value)

wFrame = WIDGET_LABEL(STGbase,$
                      XOFFSET   = sFrame.size[0],$
                      YOFFSET   = sFrame.size[1],$
                      SCR_XSIZE = sFrame.size[2],$
                      SCR_YSIZE = sFrame.size[3],$
                      VALUE     = '',$
                      FRAME     = sFrame.frame)
END

;-------------------------------------------------------------------------------
;This method plots the Frame and add the title 
PRO MakeContain, STGbase, Xsize

;**Define Structure**
sLabel = { size  : [20,25],$
           value : 'Message:'}

XYoff  = [55,-5]
sTextField = { size : [sLabel.size[0]+XYoff[0],$
                       sLabel.size[1]+XYoff[1],$
                       Xsize - 180,$
                       34],$
               uname : 'sent_to_geek_text_field'}

XYoff = [0,0]
sButton = { size : [sTextField.size[0]+sTextField.size[2]+XYoff[0],$
                    sTextField.size[1]+XYoff[1],$
                    100,35],$
            value : 'SEND TO GEEK',$
            uname : 'send_to_geek_button'}

;**Define GUI**
wLabel = WIDGET_LABEL(STGbase,$
                      XOFFSET = sLabel.size[0],$
                      YOFFSET = sLabel.size[1],$
                      VALUE   = sLabel.value)

wTextField = WIDGET_TEXT(STGbase,$
                         XOFFSET   = sTextField.size[0],$
                         YOFFSET   = sTextField.size[1],$
                         SCR_XSIZE = sTextField.size[2],$
                         SCR_YSIZE = sTextField.size[3],$
                         UNAME     = sTextField.uname,$
                         /EDITABLE)

wButton = WIDGET_BUTTON(STGbase,$
                        XOFFSET   = sButton.size[0],$
                        YOFFSET   = sButton.size[1],$
                        SCR_XSIZE = sButton.size[2],$
                        SCR_YSIZE = sButton.size[3],$
                        UNAME     = sButton.uname,$
                        VALUE     = sButton.value)
                       
END

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

FUNCTION IDLsendToGeek::init, $
                      XOFFSET   = XOFFSET,$
                      YOFFSET   = YOFFSET,$
                      XSIZE     = XSIZE,$
                      TITLE     = TITLE,$
                      FRAME     = FRAME,$
                      MAIN_BASE = MAIN_BASE

IF (n_elements(XOFFSET) EQ 0) THEN XOFFSET = 0
IF (n_elements(YOFFSET) EQ 0) THEN YOFFSET = 0
IF (n_elements(TITLE)   EQ 0) THEN TITLE   = 'SEND TO GEEK'
IF (n_elements(FRAME)   EQ 0) THEN FRAME   = 3

;Make the Send_to_geek Base
STGbase = MakeBase (MAIN_BASE, $
                    XOFFSET, $
                    YOFFSET, $
                    XSIZE)

;Plot contain (message label, widget_text and button)
MakeContain, STGbase, Xsize

;Plot the frame and the add the title
MakeFrame, STGbase, $
  XSIZE, $
  FRAME, $
  TITLE

  
RETURN, 1
END





;******  Class Define **** *****************************************************
PRO IDLsendToGeek__define
STRUCT = { IDLsendToGeek,$
           var : ''}
END


