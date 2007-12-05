PRO MakeGuiLoadingGeometry, MAIN_BASE, MainBaseSize, InstrumentList, InstrumentIndex

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

base = { size  : [0,0,MainBaseSize[2:3]],$
         uname : 'loading_geometry_base'} 

IF (InstrumentIndex EQ 0) THEN BEGIN
    sensitiveStatus = 0
endif else begin
    sensitiveStatus = 1
endelse

;///////////
;Instrument/
;///////////
instrumentLabel    = { size  : [10,25],$
                       value : 'Select your instrument:'}

XYoff = [150,-8]
instrumentDroplist = { size  : [instrumentLabel.size[0]+XYoff[0],$
                                instrumentLabel.size[1]+XYoff[1]],$
                       uname : 'instrument_droplist'}

;/////////////
;Geometry.xml/
;/////////////
XYoff = [0,60]
geometryFrame    = { size  : [5, $
                              instrumentLabel.size[1]+XYoff[1], $
                              MainBaseSize[2]-13, $
                              110],$
                     frame : 1}

XYoff = [15,-8]
geometryLabel    = { size  : [geometryFrame.size[0]+XYoff[0],$
                              geometryFrame.size[1]+XYoff[1]],$
                     value : 'geometry.xml'}

XYoff = [-5,20]
geometryDroplist = { size  : [geometryLabel.size[0]+XYoff[0],$
                              geometryLabel.size[1]+XYoff[1]],$
                     list  : ['                                                            '],$
                     uname : 'geometry_droplist'}

XYoff = [430,10]
geometryOrLabel  = { size  : [geometryDroplist.size[0]+XYoff[0],$
                              geometryDroplist.size[1]+XYoff[1]],$
                     value : 'OR'}

XYoff = [35,-7]
geometryButton   = { size  : [geometryOrLabel.size[0]+XYoff[0],$
                              geometryOrLabel.size[1]+XYoff[1],$
                              100, $
                              30],$
                     uname : 'geometry_browse_button',$
                     title : ' BROWSE ... '}


XYoff = [605,15]
geometryPreview  = { size  : [geometryLabel.size[0]+XYoff[0],$
                              geometryLabel.size[1]+XYoff[1],$
                              65,100],$
                     value : 'PREVIEW',$
                     uname : 'geometry_preview'}


XYoff = [10,50]
geometryText     = { size  : [geometryDroplist.size[0]+XYoff[0],$
                              geometryDroplist.size[1]+XYoff[1],$
                              595,35],$
                     uname : 'geometry_text_field',$
                     value : ''}

;///////////
;cvinfo.xml/
;///////////
XYoff = [0,60]
cvinfoFrame      = { size  : [5, $
                              geometryFrame.size[1]+geometryFrame.size[3]+XYoff[1], $
                              MainBaseSize[2]-13, $
                              100],$
                     frame : 1}

XYoff = [15,-8]
cvinfoLabel      = { size  : [cvinfoFrame.size[0]+XYoff[0],$
                              cvinfoFrame.size[1]+XYoff[1]],$
                     value : 'cvinfo.xml'}

XYoff = [5,25]
runNumberBase    = { title : 'Run Number:',$
                     size  : [cvinfoLabel.size[0]+XYoff[0],$
                             cvinfoLabel.size[1]+XYoff[1],$
                             150,35],$
                     uname : 'cvinfo_base',$ 
                     cw_field : { uname : 'cvinfo_run_number_field',$
                                  size  : 8}}

XYoff = [160,10]
orLabel = { size  : [runNumberBase.size[0]+XYoff[0],$
                     runNumberBase.size[1]+XYoff[1]],$
            value : 'OR'}

XYoff = [40,-5]
browseButton = { size  : [orLabel.size[0]+XYoff[0],$
                          orLabel.size[1]+XYoff[1],$
                          100,30],$
                 value : 'BROWSE...',$
                 uname : 'cvinfo_browse_button'}

XYoff = [400,-18]
cvinfoPreview  = { size  : [BrowseButton.size[0]+XYoff[0],$
                            BrowseButton.size[1]+XYoff[1],$
                            65,93],$
                   value : 'PREVIEW',$
                   uname : 'cvinfo_preview'}


XYoff = [20,40]
cvinfoText = { size : [XYoff[0],$
                       browseButton.size[1]+XYoff[1],$
                       600,35],$
               uname : 'cvinfo_text_field',$
               value : ''}

;////////////////////////
;Loading Geometry Button/
;////////////////////////
loadingGeometryButton = {size  : [30,400,650,40],$
                         value : 'L  O  A  D  I  N  G     G  E  O  M  E  T  R  Y',$
                         uname : 'loading_geometry_button'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
base = WIDGET_BASE(MAIN_BASE,$
                   UNAME     = base.uname,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = base.size[2],$
                   SCR_YSIZE = base.size[3],$
                   map=0)  ;REMOVE 0 and put back 1

;\\\\\\\\\\\
;Instrument\
;\\\\\\\\\\\
label = WIDGET_LABEL(base,$
                     XOFFSET = instrumentLabel.size[0],$
                     YOFFSET = instrumentLabel.size[1],$
                     VALUE   = instrumentLabel.value)

droplist = WIDGET_DROPLIST(base,$
                           VALUE   = InstrumentList,$
                           XOFFSET = instrumentDroplist.size[0],$
                           YOFFSET = instrumentDroplist.size[1],$
                           UNAME   = instrumentDroplist.uname)

;\\\\\\\\\\\\\
;Geometry.xml\
;\\\\\\\\\\\\\
label = WIDGET_LABEL(base,$
                     XOFFSET = geometryOrLabel.size[0],$
                     YOFFSET = geometryOrLabel.size[1],$
                     VALUE   = geometryOrLabel.value)

droplist = WIDGET_DROPLIST(base,$
                           value     = geometryDroplist.list,$
                           XOFFSET   = geometryDroplist.size[0],$
                           YOFFSET   = geometryDroplist.size[1],$
                           UNAME     = geometryDroplist.uname,$
                           SENSITIVE = sensitiveStatus,$
                           /DYNAMIC_RESIZE)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = geometryPreview.size[0],$
                       YOFFSET   = geometryPreview.size[1],$
                       SCR_XSIZE = geometryPreview.size[2],$
                       SCR_YSIZE = geometryPreview.size[3],$
                       UNAME     = geometryPreview.uname,$
                       VALUE     = geometryPreview.value,$
                       SENSITIVE = sensitiveStatus)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = geometryButton.size[0],$
                       YOFFSET   = geometryButton.size[1],$
                       SCR_XSIZE = geometryButton.size[2],$
                       SCR_YSIZE = geometryButton.size[3],$
                       VALUE     = geometryButton.title,$
                       UNAME     = geometryButton.uname,$
                       SENSITIVE = sensitiveStatus)

text = WIDGET_TEXT(base,$
                   XOFFSET   = geometryText.size[0],$
                   YOFFSET   = geometryText.size[1],$
                   SCR_XSIZE = geometryText.size[2],$
                   SCR_YSIZE = geometryText.size[3],$
                   UNAME     = geometryText.uname,$
                   VALUE     = geometryText.value,$
                   SENSITIVE = sensitiveStatus,$
                   /EDITABLE,$
                   /ALL_EVENTS)

label = WIDGET_LABEL(base,$
                     XOFFSET = geometryLabel.size[0],$
                     YOFFSET = geometryLabel.size[1],$
                     VALUE   = geometryLabel.value)

frame = WIDGET_LABEL(base,$
                     XOFFSET   = geometryFrame.size[0],$
                     YOFFSET   = geometryFrame.size[1],$
                     SCR_XSIZE = geometryFrame.size[2],$
                     SCR_YSIZE = geometryFrame.size[3],$
                     FRAME     = geometryFrame.frame,$
                     VALUE     = '')

;\\\\\\\\\\\
;cvinfo.xml\
;\\\\\\\\\\\
label = WIDGET_LABEL(base,$
                     XOFFSET = cvinfoLabel.size[0],$
                     YOFFSET = cvinfoLabel.size[1],$
                     VALUE   = cvinfoLabel.value)

field_base = WIDGET_BASE(base,$
                         XOFFSET   = runNumberBase.size[0],$
                         YOFFSET   = runNumberBase.size[1],$
                         SCR_XSIZE = runNumberBase.size[2],$
                         SCR_YSIZE = runNumberBase.size[3],$
                         SENSITIVE = sensitiveStatus,$
                         UNAME     = runNumberBase.uname)

field = CW_FIELD(field_base,$
                 XSIZE         = runNumberBase.cw_field.size[0],$
                 ROW           = 1,$
                 UNAME         = runNumberBase.cw_field.uname,$
                 RETURN_EVENTS = 1,$
                 TITLE         = runNumberBase.title,$
                 /INTEGER)
                   
orLabel = WIDGET_LABEL(base,$
                       XOFFSET = orLabel.size[0],$
                       YOFFSET = orLabel.size[1],$
                       VALUE   = orLabel.value)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = browseButton.size[0],$
                       YOFFSET   = browseButton.size[1],$
                       SCR_XSIZE = browseButton.size[2],$
                       SCR_YSIZE = browseButton.size[3],$
                       UNAME     = browseButton.uname,$
                       VALUE     = browseButton.value,$
                       SENSITIVE = sensitiveStatus)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = cvinfoPreview.size[0],$
                       YOFFSET   = cvinfoPreview.size[1],$
                       SCR_XSIZE = cvinfoPreview.size[2],$
                       SCR_YSIZE = cvinfoPreview.size[3],$
                       UNAME     = cvinfoPreview.uname,$
                       VALUE     = cvinfoPreview.value,$
                       SENSITIVE = sensitiveStatus)

text = WIDGET_TEXT(base,$
                   XOFFSET   = cvinfoText.size[0],$
                   YOFFSET   = cvinfoText.size[1],$
                   SCR_XSIZE = cvinfoText.size[2],$
                   SCR_YSIZE = cvinfoText.size[3],$
                   UNAME     = cvinfoText.uname,$
                   VALUE     = cvinfoText.value,$
                   SENSITIVE = sensitiveStatus,$
                   /EDITABLE,$
                   /ALL_EVENTS)

frame = WIDGET_LABEL(base,$
                     XOFFSET   = cvinfoFrame.size[0],$
                     YOFFSET   = cvinfoFrame.size[1],$
                     SCR_XSIZE = cvinfoFrame.size[2],$
                     SCR_YSIZE = cvinfoFrame.size[3],$
                     FRAME     = cvinfoFrame.frame,$
                     VALUE     = '')

;\\\\\\\\\\\\\\\\\
;LOADING GEOMETRY\
;\\\\\\\\\\\\\\\\\
button = WIDGET_BUTTON(base,$
                       XOFFSET   = loadingGeometryButton.size[0],$
                       YOFFSET   = loadingGeometryButton.size[1],$
                       SCR_XSIZE = loadingGeometryButton.size[2],$
                       SCR_YSIZE = loadingGeometryButton.size[3],$
                       UNAME     = loadingGeometryButton.uname,$
                       VALUE     = loadingGeometryButton.value,$
                       SENSITIVE = sensitiveStatus)

END
