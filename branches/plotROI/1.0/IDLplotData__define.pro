;-------------------------------------------------------------------------------
PRO DefineMainBase_event, Event
WIDGET_CONTROL, event.top, GET_UVALUE=sMainBase
wWidget =  Event.top            ;widget id
xy_coeff = 1

CASE Event.id OF
    Widget_Info(wWidget, FIND_BY_UNAME='draw'): BEGIN
        DisplayInfoAboutMousePosition, Event, sMainBase
;        IF (Event.type EQ 0) THEN BEGIN
;        ENDIF	
    END
    ELSE:
ENDCASE

SWITCH Event.id OF
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_10'): ++xy_coeff
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_9'): ++xy_coeff 
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_8'): ++xy_coeff 
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_7'): ++xy_coeff 
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_6'): ++xy_coeff 
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_5'): ++xy_coeff 
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_4'): ++xy_coeff 
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_3'): ++xy_coeff 
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_2'): ++xy_coeff
    Widget_Info(wWidget, FIND_BY_UNAME='main_plot_zoom_1'): BEGIN
        sMainBase.xcoeff = xy_coeff
        sMainBase.ycoeff = xy_coeff
        replotMainData, Event, sMainBase
        replotRoiData, Event, sMainBase
    END
    ELSE:
ENDSWITCH
END

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
PRO replotRoiData, Event, sMainBase
;retrieve info needed to replot
wbase = sMainBase.wbase
PlotROI, sMainBase, wbase
END

;-------------------------------------------------------------------------------
PRO setBaseTitle, Event, uname, title
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, TLB_SET_TITLE=title
END

;-------------------------------------------------------------------------------
PRO SetPlotBaseTitle, Event, title
setBaseTitle, Event, 'plot_base', title
END

;-------------------------------------------------------------------------------
PRO DisplayInfoAboutMousePosition, Event, sMainBase
;calculate PixelX and Y positions
X      = Event.X
Y      = Event.Y
xcoeff = sMainBase.xcoeff
ycoeff = sMainBase.ycoeff
PixelX = floor(X) / xcoeff
PixelY = floor(Y) / ycoeff
;calcuate intensity
data   = sMainBase.data
dataYX = TOTAL(data,1)
;Create title info
title  = 'X:'  + STRCOMPRESS(PixelX,/REMOVE_ALL)
title += ';Y:' + STRCOMPRESS(PixelY,/REMOVE_ALL)
title += ';Counts=' + STRCOMPRESS(dataYX(PixelY,PixelX),/REMOVE_ALL)
SetPlotBaseTitle, Event, title
END

;-------------------------------------------------------------------------------
PRO replotMainData, Event, sMainBase
;change size of base and draw region
id = widget_info(Event.top,find_by_uname='plot_base')
widget_control, id, SCR_XSIZE = sMainBase.xsize * sMainBase.xcoeff
widget_control, id, SCR_YSIZE = sMainBase.ysize * sMainBase.ycoeff
id = widget_info(Event.top,find_by_uname='draw')
widget_control, id, SCR_XSIZE = sMainBase.xsize * sMainBase.xcoeff
widget_control, id, SCR_YSIZE = sMainBase.ysize * sMainBase.ycoeff
;retrieve info needed to replot
data  = sMainBase.data
wbase = sMainBase.wbase
PlotMainData, data, sMainBase, wbase
END

;-------------------------------------------------------------------------------
FUNCTION RetrieveStringArray, ROIfileName, NbrElement
openr, u, ROIfileName, /get
onebyte = 0b
tmp = ''
i = 0
NbrLine   = getNbrLines(ROIFileName)
FileArray = STRARR(NbrLine)
WHILE (NOT eof(u)) DO BEGIN
    READU,u,onebyte
    fs = FSTAT(u)
    IF (fs.cur_ptr EQ 0) THEN BEGIN
        POINT_LUN,u,0
    ENDIF ELSE BEGIN
        POINT_LUN,u,fs.cur_ptr - 1
    ENDELSE
    READF,u,tmp
    FileArray[i++] = tmp
ENDWHILE
CLOSE, u
FREE_LUN,u
NbrElement = i ;nbr of lines
RETURN, FileArray
END

;-------------------------------------------------------------------------------
PRO PlotROI, sMainBase, wBase
NbrPixelExcluded = sMainBase.NbrPxExcl
Xarray           = sMainBase.Xarray
Yarray           = sMainBase.Yarray
x_coeff          = sMainBase.xcoeff
y_coeff          = sMainBase.ycoeff
xsize            = sMainBase.xsize
ysize            = sMainBase.ysize
color            = sMainBase.gridColor
;plot in x-direction
FOR i=0,(NbrPixelExcluded-1) DO BEGIN
    PLOTS, Xarray[i] * x_coeff, Yarray[i] * y_coeff, /DEVICE, COLOR=color
    PLOTS, Xarray[i] * x_coeff, (Yarray[i]+1) * y_coeff, /DEVICE, /CONTINUE, $
      COLOR=color
    PLOTS, (Xarray[i]+1) * x_coeff, (Yarray[i]+1) * y_coeff, /DEVICE, $
      /CONTINUE, COLOR=color
    PLOTS, (Xarray[i]+1) * x_coeff, Yarray[i] * y_coeff, /DEVICE, /CONTINUE, $
      COLOR=color
    PLOTS, Xarray[i] * x_coeff, Yarray[i] * y_coeff, /DEVICE, /CONTINUE, $
      COLOR=color
ENDFOR    
END

;-------------------------------------------------------------------------------
PRO PlotMainData, data, sMainBase, wbase
xsize     = sMainBase.xsize
ysize     = sMainBase.ysize
x         = sMainBase.xcoeff
y         = sMainBase.ycoeff
DrawUname = sMainBase.DrawUname
;Plot data
dataXY   = TOTAL(data,1)
tDataXY  = TRANSPOSE(dataXY)
rtDataXY = REBIN(tDataXY, xsize*x, ysize*y, /SAMPLE)
DEVICE, DECOMPOSED = 0
LOADCT,5
id = WIDGET_INFO(wBase, FIND_BY_UNAME = DrawUname)
WIDGET_CONTROL, id, GET_VALUE = id_value
WSET, id_value
TVSCL, rtDataXY, /DEVICE
END

;-------------------------------------------------------------------------------
PRO DefineMainBase, sMainBase, wBase
ourGroup = WIDGET_BASE()
xsize = long(sMainBase.xcoeff) * long(sMainBase.xsize)
ysize = long(sMainBase.ycoeff) * long(sMainBase.ysize)
wBase = WIDGET_BASE(GROUP_LEADER = ourGroup,$
                    TITLE        = sMainBase.title,$
                    XOFFSET      = sMainBase.xoff,$
                    YOFFSET      = sMainBase.yoff,$
                    SCR_XSIZE    = xsize,$
                    SCR_YSIZE    = ysize,$
                    MAP          = 1,$
                    UNAME        = sMainBase.uname,$
                    MBAR         = MBAR)
wDraw = WIDGET_DRAW(wBase,$
                    XOFFSET   = 0,$
                    YOFFSET   = 0,$
                    SCR_XSIZE = xsize,$
                    SCR_YSIZE = ysize,$
                    UNAME     = sMainBase.DrawUname,$
                    /MOTION_EVENTS,$
                    /BUTTON_EVENTS)
wZoom = WIDGET_BUTTON(MBAR,$
                      VALUE = 'ZOOM',$
                      /MENU)
ZoomValue = ['1','2','3','4','5','6','7','8','9','10']
sz = (size(ZoomValue))(1)
ZoomUname = STRARR(sz) + 'main_plot_zoom_'
FOR i=0,(sz-1) DO BEGIN
    ZoomUname[i] += STRCOMPRESS(ZoomValue[i],/REMOVE_ALL)
    button = WIDGET_BUTTON(wZoom,$
                           UNAME = ZoomUname[i],$
                           VALUE = ZoomValue[i])
ENDFOR
Widget_Control, /REALIZE, wBase
XManager, 'MAIN_BASE', wBase, /NO_BLOCK
END

;***** Class constructor *******************************************************
FUNCTION IDLplotData::init, $
                    XSIZE       = xsize, $
                    YSIZE       = ysize, $
                    DATA        = data, $
                    ROIfileName = ROIfileName
;define value of parameters
self.x         = 1
self.y         = 1
self.xoff      = 300
self.yoff      = 300
self.title     = 'PLOT'
self.uname     = 'plot_base'
self.DrawUname = 'draw'
;plot ROI file on top (if any)
IF (ROIfileName NE '') THEN BEGIN
    NbrPixelExcluded = 0
    StringArray = RetrieveStringArray(ROIfileName, NbrPixelExcluded)
;create the arrays (X and Y) of the pixels to exclude
    Xarray  = INTARR(NbrPixelExcluded)
    Yarray  = INTARR(NbrPixelExcluded)
    getXYROI, NbrPixelExcluded, StringArray,  Xarray, Yarray
ENDIF
;design Main Base
sMainBase = { xsize     : xsize,$
              ysize     : ysize,$
              xcoeff    : self.x,$
              ycoeff    : self.y,$
              title     : self.title,$
              xoff      : self.xoff,$
              yoff      : self.yoff,$
              uname     : self.uname,$
              DrawUname : self.DrawUname,$
              data      : data,$
              gridColor : 200,$
              NbrPxExcl : NbrPixelExcluded,$
              Xarray    : Xarray,$
              Yarray    : Yarray,$
              wbase     : 0L}
;Design Main Base
wBase = ''
DefineMainBase, sMainBase, wBase
sMainBase.wBase = wBase
WIDGET_CONTROL, wBase, SET_UVALUE = sMainBase
XMANAGER, "DefineMainBase", wBase, /NO_BLOCK
;Plot Main Data
PlotMainData, data, sMainBase, wBase
;plot ROI file on top (if any)
IF (ROIfileName NE '') THEN BEGIN
    PlotROI, sMainBase, wBase
ENDIF
RETURN, 1
END

;*******************************************************************************
PRO IDLplotData__define
struct = {IDLplotData,$
          x         : 0,$ ;width of each pixel
          y         : 0,$ ;height of each pixel
          xoff      : 0,$
          yoff      : 0,$
          title     : '',$
          uname     : '',$
          DrawUname : ''}
END
