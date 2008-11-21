PRO MakeGuiFinalResultBase, MAIN_BASE

;*******************************************************************************
;                           Define size arrays
;*******************************************************************************
confirm_base = { size  : [100, $
                          250, $
                          500, $
                          110],$
                 uname : 'final_result_base'}

label = { size  : [0,0],$
          value : '                    CREATION OF A NEW GEOMETRY FILE - STATUS                      ',$
          frame : 1}

XYoff = [5,25]
text  = { size  : [label.size[0]+XYoff[0],$
                   label.size[0]+XYoff[1],$
                   490,$
                   50],$
          uname : 'final_result_text_field'}

XYoff = [180,text.size[3]]
button = { size  : [label.size[0]+XYoff[0],$
                    text.size[1]+XYoff[1],$
                    100,35],$
           value : 'OK',$
           uname : 'final_result_ok_button'}

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
                    MAP          = 0)

label = WIDGET_LABEL(base1,$
                     XOFFSET   = label.size[0],$
                     YOFFSET   = label.size[1],$
                     FRAME     = label.frame,$
                     VALUE     = label.value)

text1 = WIDGET_TEXT(base1,$
                    XOFFSET    = text.size[0],$
                    YOFFSET    = text.size[1],$
                    SCR_XSIZE  = text.size[2],$
                    SCR_YSIZE  = text.size[3],$
                    UNAME      = text.uname,$
                    /WRAP,$
                    /SCROLL)

button = WIDGET_BUTTON(base1,$
                       XOFFSET   = button.size[0],$
                       YOFFSET   = button.size[1],$
                       SCR_XSIZE = button.size[2],$
                       SCR_YSIZE = button.size[3],$
                       UNAME     = button.uname,$
                       VALUE     = button.value)
                    
END
