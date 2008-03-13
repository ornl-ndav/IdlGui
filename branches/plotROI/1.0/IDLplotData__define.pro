;-------------------------------------------------------------------------------
PRO DefineMainBase, sMainBase, wBase

ourGroup = WIDGET_BASE()

wBase    = WIDGET_BASE(GROUP_LEADER = ourGroup,$
                       TITLE        = sMainBase.title,$
                       XOFFSET      = sMainBase.xoff,$
                       YOFFSET      = sMainBase.yoff,$
                       SCR_XSIZE    = sMainBase.xcoeff*sMainBase.xsize,$
                       SCR_YSIZE    = sMainBase.ycoeff*sMainBase.ysize,$
                       MAP          = 1,$
                       UNAME        = sMainBase.uname)

Widget_Control, /REALIZE, wBase
XManager, 'MAIN_BASE', wBase, /NO_BLOCK

END

;***** Class constructor *******************************************************
FUNCTION IDLplotData::init, XSIZE=xsize, YSIZE=ysize, DATA=data

print, 'in class'

;design Main Base
sMainBase = { xsize   : xsize,$
              ysize   : ysize,$
              xcoeff  : self.x,$
              ycoeff  : self.y,$
              title   : self.title,$
              xoff    : self.xoff,$
              yoff    : self.yoff,$
              uname   : self.uname}

print, sMainBase.xsize
stop
wBase = ''
DefineMainBase, sMainBase, wBase
XMANAGER, "DefineMainBase", wBase, /NO_BLOCK

RETURN, 1
END

;*******************************************************************************
PRO IDLplotData__define
struct = {IDLplotData,$
          x     : 6,$ ;width of each pixel
          y     : 6,$ ;height of each pixel
          xoff  : 300,$
          yoff  : 300,$
          title : 'PLOT',$
          uname : 'main_plot',$
          var   : ''}
END
