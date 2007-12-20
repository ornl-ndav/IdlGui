PRO MakeGuiConfirmationBase, MAIN_BASE

;*******************************************************************************
;                           Define size arrays
;*******************************************************************************
confirm_base = { size  : [350,250,400,50],$
                 uname : 'confirmation_base'}

;*******************************************************************************
;                                Build GUI
;*******************************************************************************
base = WIDGET_BASE(/modal,$
                   GROUP_LEADER = MAIN_BASE,$
                   UNAME     = confirm_base.uname,$
                   XOFFSET   = confirm_base.size[0],$
                   YOFFSET   = confirm_base.size[1],$
                   SCR_XSIZE = confirm_base.size[2],$
                   SCR_YSIZE = confirm_base.size[3],$
                   map=1) ;remove 1 and put 0 back


END
