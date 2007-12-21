PRO MakeGuiConfirmationBase, MAIN_BASE

;*******************************************************************************
;                           Define size arrays
;*******************************************************************************
confirm_base = { size  : [100, $
                          250, $
                          500, $
                          80],$
                 uname : 'confirmation_base',$
                 title : 'Confirmation box'}

label = { size  : [0,0],$
          value : '               Loading a new geometry will reset all your changes                 ',$
          frame : 1}

XY1off = [-0,40]
label2 = {size  : [label.size[0]+XY1off[0], $
                   label.size[1]+XY1off[1]],$
          value : 'Do you really want to load a new Geometry?'}

XYoff = [280,-7]
button1 = {size  : [label2.size[0]+XYoff[0],$
                    label2.size[1]+XYoff[1],$
                    100,30],$
           value : 'YES',$
           uname : 'yes_confirmation_button'}
          
XYoff = [0,0]
button2 = {size  : [button1.size[0]+button1.size[2],$
                    button1.size[1]+XYoff[1],$
                    button1.size[2],$
                    button1.size[3]],$
           value : 'NO',$
           uname : 'no_confirmation_button'}

;*******************************************************************************
;                                Build GUI
;*******************************************************************************
base1 = WIDGET_BASE(MAIN_BASE,$
                    UNAME        = confirm_base.uname,$
                    XOFFSET      = confirm_base.size[0],$
                    YOFFSET      = confirm_base.size[1],$
                    SCR_XSIZE    = confirm_base.size[2],$
                    SCR_YSIZE    = confirm_base.size[3],$
                    FRAME        = 3,$
                    MAP          = 0) ;remove 1 and put 0 back

label = WIDGET_LABEL(base1,$
                     XOFFSET   = label.size[0],$
                     YOFFSET   = label.size[1],$
                     FRAME     = label.frame,$
                     VALUE     = label.value)

label2 = WIDGET_LABEL(base1,$
                     XOFFSET   = label2.size[0],$
                     YOFFSET   = label2.size[1],$
                     VALUE     = label2.value)

button1 = WIDGET_BUTTON(base1,$
                       XOFFSET   = button1.size[0],$
                       YOFFSET   = button1.size[1],$
                       SCR_XSIZE = button1.size[2],$
                       SCR_YSIZE = button1.size[3],$
                       UNAME     = button1.uname,$
                       VALUE     = button1.value)

button2 = WIDGET_BUTTON(base1,$
                       XOFFSET   = button2.size[0],$
                       YOFFSET   = button2.size[1],$
                       SCR_XSIZE = button2.size[2],$
                       SCR_YSIZE = button2.size[3],$
                       UNAME     = button2.uname,$
                       VALUE     = button2.value)

END
