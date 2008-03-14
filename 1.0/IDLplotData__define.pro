;-------------------------------------------------------------------------------
PRO DefineMainBase, sMainBase, wBase

ourGroup = WIDGET_BASE()

xsize = long(sMainBase.xcoeff) * long(sMainBase.xsize)
ysize = long(sMainBase.ycoeff) * long(sMainBase.ysize)

wBase    = WIDGET_BASE(GROUP_LEADER = ourGroup,$
                       TITLE        = sMainBase.title,$
                       XOFFSET      = sMainBase.xoff,$
                       YOFFSET      = sMainBase.yoff,$
                       SCR_XSIZE    = xsize,$
                       SCR_YSIZE    = ysize,$
                       MAP          = 1,$
                       UNAME        = sMainBase.uname)

Widget_Control, /REALIZE, wBase
XManager, 'MAIN_BASE', wBase, /NO_BLOCK

END

;***** Class constructor *******************************************************
FUNCTION IDLplotData::init, XSIZE=xsize, YSIZE=ysize, DATA=data

;define value of parameters
self.x     = 1
self.y     = 1
self.xoff  = 300
self.yoff  = 300
self.title = 'PLOT'
self.uname = 'main_plot'

;design Main Base
sMainBase = { xsize   : xsize,$
              ysize   : ysize,$
              xcoeff  : self.x,$
              ycoeff  : self.y,$
              title   : self.title,$
              xoff    : self.xoff,$
              yoff    : self.yoff,$
              uname   : self.uname}

wBase = ''
DefineMainBase, sMainBase, wBase
XMANAGER, "DefineMainBase", wBase, /NO_BLOCK

RETURN, 1
END

;*******************************************************************************
PRO IDLplotData__define
struct = {IDLplotData,$
          x     : 0,$ ;width of each pixel
          y     : 0,$ ;height of each pixel
          xoff  : 0,$
          yoff  : 0,$
          title : '',$
          uname : ''}
END
