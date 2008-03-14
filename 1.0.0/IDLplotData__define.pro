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

PRO PlotROI, sMainBase, wBase, Xarray, Yarray, NbrPixelExcluded

x_coeff = sMainBase.xcoeff
y_coeff = sMainBase.ycoeff
xsize   = sMainBase.xsize
ysize   = sMainBase.ysize
color   = sMainBase.gridColor

;plot in x-direction
FOR i=0,(NbrPixelExcluded-1) DO BEGIN
    PLOTS, Xarray[i] * x_coeff, Yarray[i] * y_coeff, /DEVICE, COLOR=color
    PLOTS, Xarray[i] * x_coeff, (Yarray[i]+1) * y_coeff, /DEVICE, /CONTINUE, $
      COLOR=color
    PLOTS, (Xarray[i]+1) * x_coeff, (Yarray[i]+1) * y_coeff, /DEVICE, /CONTINUE, $
      COLOR=color
    PLOTS, (Xarray[i]+1) * x_coeff, Yarray[i] * y_coeff, /DEVICE, /CONTINUE, $
      COLOR=color
    PLOTS, Xarray[i] * x_coeff, Yarray[i] * y_coeff, /DEVICE, /CONTINUE, COLOR=color
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
                    UNAME        = sMainBase.uname)

wDraw = WIDGET_DRAW(wBase,$
                    XOFFSET   = 0,$
                    YOFFSET   = 0,$
                    SCR_XSIZE = xsize,$
                    SCR_YSIZE = ysize,$
                    UNAME     = sMainBase.DrawUname)

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
self.x         = 2
self.y         = 2
self.xoff      = 300
self.yoff      = 300
self.title     = 'PLOT'
self.uname     = 'plot_base'
self.DrawUname = 'draw'

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
              gridColor : 200}

wBase = ''
DefineMainBase, sMainBase, wBase
XMANAGER, "DefineMainBase", wBase, /NO_BLOCK

;Plot Main Data
PlotMainData, data, sMainBase, wBase

;plot ROI file on top (if any)
IF (ROIfileName NE '') THEN BEGIN
    
    NbrPixelExcluded = 0
    StringArray = RetrieveStringArray(ROIfileName, NbrPixelExcluded)
    
;create the arrays (X and Y) of the pixels to exclude
    Xarray = INTARR(NbrPixelExcluded)
    Yarray  = INTARR(NbrPixelExcluded)
    getXYROI, NbrPixelExcluded, StringArray,  Xarray, Yarray

;plot ROI
    PlotROI, sMainBase, wBase, Xarray, Yarray, NbrPixelExcluded

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
