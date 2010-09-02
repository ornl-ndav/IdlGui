;===============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;===============================================================================

PRO MakeGuiLoadingGeometry, MAIN_BASE, $
                            MainBaseSize, $
                            InstrumentList, $
                            InstrumentIndex, $
                            VersionLight

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

base = { size  : [0,0,MainBaseSize[2:3]],$
         uname : 'loading_geometry_base'} 

IF (InstrumentIndex EQ 0) THEN BEGIN
    sensitiveStatus = 0
ENDIF ELSE BEGIN
    sensitiveStatus = 1
ENDELSE

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
XYoff = [0,40]

geometryFrame    = { size  : [5, $
                              instrumentLabel.size[1]+XYoff[1], $
                              MainBaseSize[2]-13, $
                              110],$
                     frame : 1,$
                     uname : 'geometry_frame'}

XYoff = [15,-8]
geometryLabel    = { size  : [geometryFrame.size[0]+XYoff[0],$
                              geometryFrame.size[1]+XYoff[1]],$
                     value : 'geometry.xml',$
                     uname : 'geometry_label'}

XYoff = [-5,20]
geometryDroplist = { size  : [geometryLabel.size[0]+XYoff[0],$
                              geometryLabel.size[1]+XYoff[1]],$
                     list  : ['                                                            '],$
                     uname : 'geometry_droplist'}

XYoff = [435,10]
geometryOrLabel  = { size  : [geometryDroplist.size[0]+XYoff[0],$
                              geometryDroplist.size[1]+XYoff[1]],$
                     value : 'OR',$
                     uname : 'geometry_or_label'}

XYoff = [35,-7]
geometryButton   = { size  : [geometryOrLabel.size[0]+XYoff[0],$
                              geometryOrLabel.size[1]+XYoff[1],$
                              100, $
                              30],$
                     uname : 'geometry_browse_button',$
                     title : ' BROWSE ... '}


XYoff = [605,15]
geometryPreview  = { size      : [geometryLabel.size[0]+XYoff[0],$
                                  geometryLabel.size[1]+XYoff[1],$
                                  65,100],$
                     value     : 'VIEW/EDIT',$
                     uname     : 'geometry_preview',$
                     sensitive : 0}


XYoff = [10,50]
geometryText     = { size  : [geometryDroplist.size[0]+XYoff[0],$
                              geometryDroplist.size[1]+XYoff[1],$
                              595,35],$
                     uname : 'geometry_text_field',$
                     value : ''}

;///////////
;cvinfo.xml/
;///////////
XYoff = [0,25]

cvinfoFrame      = { size  : [5, $
                              geometryFrame.size[1]+geometryFrame.size[3]+XYoff[1], $
                              MainBaseSize[2]-13, $
                              100],$
                     frame : 1,$
                     uname : 'cvinfo_frame'}

XYoff = [15,-8]
cvinfoLabel      = { size  : [cvinfoFrame.size[0]+XYoff[0],$
                              cvinfoFrame.size[1]+XYoff[1]],$
                     value : 'cvinfo.xml',$
                     uname : 'cvinfo_label'}

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
            value : 'OR',$
            uname : 'or_label'}

XYoff = [40,-5]
browseButton = { size  : [orLabel.size[0]+XYoff[0],$
                          orLabel.size[1]+XYoff[1],$
                          100,30],$
                 value : 'BROWSE...',$
                 uname : 'cvinfo_browse_button'}

XYoff = [400,-18]
cvinfoPreview  = { size      : [BrowseButton.size[0]+XYoff[0],$
                                BrowseButton.size[1]+XYoff[1],$
                                65,93],$
                   value     : 'PREVIEW',$
                   uname     : 'cvinfo_preview',$
                   sensitive : 0}


XYoff = [20,40]
cvinfoText = { size : [XYoff[0],$
                       browseButton.size[1]+XYoff[1],$
                       600,35],$
               uname : 'cvinfo_text_field',$
               value : ''}

;////////////////////////
;Geometry File Generator/
;////////////////////////
XYoff = [0,25]
GeoFileFrame      = { size  : [5, $
                               cvinfoFrame.size[1]+cvinfoFrame.size[3]+XYoff[1], $
                               MainBaseSize[2]-13, $
                               100],$
                      frame : 1,$
                      uname : 'geo_file_frame'}

XYoff = [15,-8]
GeoFileLabel      = { size  : [GeoFileFrame.size[0]+XYoff[0],$
                               GeoFileFrame.size[1]+XYoff[1]],$
                      value : 'New Geometry File Name',$
                      uname : 'geo_file_label'}

XYoff = [5,30]
GeoNameLabel      = { size  : [GeoFileLabel.size[0]+XYoff[0],$
                               GeoFileLabel.size[1]+XYoff[1]],$
                      value : 'Name:',$
                      uname : 'geo_name_label'}
XYoff = [40,-5]
GeoNameTextField  = { size  : [GeoNameLabel.size[0]+XYoff[0],$
                               GeoNameLabel.size[1]+XYoff[1],$
                               300,35],$
                      uname : 'geo_name_text_field'}
XYoff = [GeoNameTextField.size[2],0]
AutoNameButton1   = { size  : [GeoNameTextField.size[0]+XYoff[0],$
                               GeoNameTextField.size[1]+XYoff[1],$
                               163,35],$
                      uname : 'auto_name_with_run_button',$
                      value : 'Generate Name with Run#'}
XYoff = [AutoNameButton1.size[2],0]
AutoNameButton2   = { size  : [AutoNameButton1.size[0]+XYoff[0],$
                               AutoNameButton1.size[1]+XYoff[1],$
                               AutoNameButton1.size[2],35],$
                      uname : 'auto_name_with_time_button',$
                      value : 'Generate Name with Time'}
XYoff = [0,40]
GeoPathLabel      = { size  : [GeoNameLabel.size[0]+XYoff[0],$
                               GeoNameLabel.size[1]+XYoff[1]],$
                      value : 'Path:',$
                      uname : 'geo_path_label'}
XYoff = [40,-5]
GeoPathTextField  = { size  : [GeoPathLabel.size[0]+XYoff[0],$
                               GeoPathLabel.size[1]+XYoff[1],$
                               485,35],$
                      value : '~/local',$
                      uname : 'geo_path_text_field'}

XYoff = [GeoPathTextField.size[2]+3,8]
GeoOrLabel        = { size  : [GeoPathTextField.size[0]+XYoff[0],$
                               GeoPathTextField.size[1]+XYoff[1]],$
                      value : 'OR',$
                      uname : 'geo_or_label'}
XYoff = [20,0]
GeoPathButton     = { size  : [GeoOrLabel.size[0]+XYoff[0],$
                               GeoPathTextField.size[1]+XYOff[1],$
                               118,35],$
                      uname : 'geo_path_button',$
                      value : 'Select Path...'}

;////////////////////////
;Loading Geometry Button/
;////////////////////////
IF (VersionLight) THEN BEGIN
    loadingGeometryButton = {size  : [30,445,650,40],$
                             value : 'C  R  E  A  T  E    G  E  O  M  E  T  R  Y',$
                             uname : 'loading_geometry_button'}

    XYoff = [0,50]
    status_label          = {size  : [LoadingGeometryButton.size[0],$
                                      LoadingGeometryButton.size[1]+XYoff[1],$
                                      650,40],$
                             uname : 'status_label',$
                             value : ''}

    XYoff = [0,40]
    debug_text            = {size  : [status_label.size[0]+XYoff[0],$
                                      status_label.size[1]+XYoff[1],$
                                      650,150],$
                             uname : 'debug_text_field'}

ENDIF ELSE BEGIN
    loadingGeometryButton = {size  : [30,445,650,40],$
                             value : 'L  O  A  D  I  N  G     G  E  O  M  E  T  R  Y',$
                             uname : 'loading_geometry_button'}

    LGPbase = { size  : [30,445,645,36],$
                uname : 'loading_geometry_processing_label_base',$
                frame : 3,$
                map   : 0}

    LGPlabel = { size  : [0,0,LGPBase.size[2],LGPbase.size[3]],$
                 value : 'L O A D I N G   G E O M E T R Y  ...  (PROCESSING)'}

ENDELSE


;***********************************************************************************
;                                Build GUI
;***********************************************************************************
base = WIDGET_BASE(MAIN_BASE,$
                   UNAME     = base.uname,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = base.size[2],$
                   SCR_YSIZE = base.size[3],$
                   map=1)  ;REMOVE 0 and put back 1

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
                     XOFFSET   = geometryOrLabel.size[0],$
                     YOFFSET   = geometryOrLabel.size[1],$
                     VALUE     = geometryOrLabel.value,$
                     SENSITIVE = sensitiveStatus,$
                     UNAME     = geometryOrLabel.uname)

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
                     XOFFSET   = geometryLabel.size[0],$
                     YOFFSET   = geometryLabel.size[1],$
                     VALUE     = geometryLabel.value,$
                     SENSITIVE = sensitiveStatus,$
                     UNAME     = geometryLabel.uname)

frame = WIDGET_LABEL(base,$
                     XOFFSET   = geometryFrame.size[0],$
                     YOFFSET   = geometryFrame.size[1],$
                     SCR_XSIZE = geometryFrame.size[2],$
                     SCR_YSIZE = geometryFrame.size[3],$
                     FRAME     = geometryFrame.frame,$
                     VALUE     = '',$
                     UNAME     = geometryFrame.uname,$
                     SENSITIVE = sensitiveStatus)

;\\\\\\\\\\\
;cvinfo.xml\
;\\\\\\\\\\\
label = WIDGET_LABEL(base,$
                     XOFFSET   = cvinfoLabel.size[0],$
                     YOFFSET   = cvinfoLabel.size[1],$
                     VALUE     = cvinfoLabel.value,$
                     SENSITIVE = sensitiveStatus,$
                     UNAME     = cvinfoLabel.uname)

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
                 /LONG)
                   
orLabel = WIDGET_LABEL(base,$
                       XOFFSET   = orLabel.size[0],$
                       YOFFSET   = orLabel.size[1],$
                       VALUE     = orLabel.value,$
                       SENSITIVE = sensitiveStatus,$
                       UNAME     = orLabel.uname)

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
                       SENSITIVE = cvinfoPreview.sensitive)

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
                     VALUE     = '',$
                     SENSITIVE = sensitiveStatus,$
                     UNAME     = cvinfoFrame.uname)


;\\\\\\\\\\\\\\\\\\\\\\\\
;Geometry File Generator\
;\\\\\\\\\\\\\\\\\\\\\\\\

label = WIDGET_LABEL(base,$
                     XOFFSET   = GeoFileLabel.size[0],$
                     YOFFSET   = GeoFileLabel.size[1],$
                     VALUE     = GeoFileLabel.value,$
                     SENSITIVE = 0,$
                     UNAME     = GeoFileLabel.uname)

label = WIDGET_LABEL(base,$
                     XOFFSET   = GeoNameLabel.size[0],$
                     YOFFSET   = GeoNameLabel.size[1],$
                     VALUE     = GeoNameLabel.value,$
                     SENSITIVE = 0,$
                     UNAME     = GeoNameLabel.uname)

text  = WIDGET_TEXT(base,$
                    XOFFSET   = GeoNameTextField.size[0],$
                    YOFFSET   = GeoNameTextField.size[1],$
                    SCR_XSIZE = GeoNameTextField.size[2],$
                    SCR_YSIZE = GeoNameTextField.size[3],$
                    UNAME     = GeoNameTextField.uname,$
                    SENSITIVE = 0,$
                    /EDITABLE)

button1 = WIDGET_BUTTON(base,$
                        XOFFSET   = AutoNameButton1.size[0],$
                        YOFFSET   = AutoNameButton1.size[1],$
                        SCR_XSIZE = AutoNameButton1.size[2],$
                        SCR_YSIZE = AutoNameButton1.size[3],$
                        UNAME     = AutoNameButton1.uname,$
                        VALUE     = AutoNameButton1.value,$
                        SENSITIVE = 0)

button2 = WIDGET_BUTTON(base,$
                        XOFFSET   = AutoNameButton2.size[0],$
                        YOFFSET   = AutoNameButton2.size[1],$
                        SCR_XSIZE = AutoNameButton2.size[2],$
                        SCR_YSIZE = AutoNameButton2.size[3],$
                        UNAME     = AutoNameButton2.uname,$
                        VALUE     = AutoNameButton2.value,$
                        SENSITIVE = 0)
                    
label = WIDGET_LABEL(base,$
                     XOFFSET   = GeoPathLabel.size[0],$
                     YOFFSET   = GeoPathLabel.size[1],$
                     VALUE     = GeoPathLabel.value,$
                     SENSITIVE = 0,$
                     UNAME     = GeoPathLabel.uname)

text  = WIDGET_TEXT(base,$
                    XOFFSET   = GeoPathTextField.size[0],$
                    YOFFSET   = GeoPathTextField.size[1],$
                    SCR_XSIZE = GeoPathTextField.size[2],$
                    SCR_YSIZE = GeoPathTextField.size[3],$
                    UNAME     = GeoPathTextField.uname,$
                    VALUE     = GeoPathTextField.value,$
                    SENSITIVE = 0,$
                    /ALL_EVENTS,$
                    /EDITABLE)

label = WIDGET_LABEL(base,$
                     XOFFSET   = GeoOrLabel.size[0],$
                     YOFFSET   = GeoOrLabel.size[1],$
                     VALUE     = GeoOrLabel.value,$
                     SENSITIVE = 0,$
                     UNAME     = GeoOrLabel.uname)

button1 = WIDGET_BUTTON(base,$
                        XOFFSET   = GeoPathButton.size[0],$
                        YOFFSET   = GeoPathButton.size[1],$
                        SCR_XSIZE = GeoPathButton.size[2],$
                        SCR_YSIZE = GeoPathButton.size[3],$
                        UNAME     = GeoPathButton.uname,$
                        VALUE     = GeoPathButton.value,$
                        SENSITIVE = 0)

frame = WIDGET_LABEL(base,$
                     XOFFSET   = GeoFileFrame.size[0],$
                     YOFFSET   = GeoFileFrame.size[1],$
                     SCR_XSIZE = GeoFileFrame.size[2],$
                     SCR_YSIZE = GeoFileFrame.size[3],$
                     FRAME     = GeoFileFrame.frame,$
                     VALUE     = '',$
                     SENSITIVE = 0,$
                     UNAME     = GeoFileFrame.uname)

;\\\\\\\\\\\\\\\\\
;LOADING GEOMETRY\
;\\\\\\\\\\\\\\\\\

base1 = WIDGET_BASE(base,$
                    XOFFSET   = LGPbase.size[0],$
                    YOFFSET   = LGPbase.size[1],$
                    SCR_XSIZE = LGPbase.size[2],$
                    SCR_YSIZE = LGPbase.size[3],$
                    UNAME     = LGPbase.uname,$
                    FRAME     = LGPbase.frame,$
                    MAP       = LGPbase.map)

label1 = WIDGET_LABEL(base1,$
                      XOFFSET   = LGPlabel.size[0],$
                      YOFFSET   = LGPlabel.size[1],$
                      SCR_XSIZE = LGPlabel.size[2],$
                      SCR_YSIZE = LGPlabel.size[3],$
                      VALUE     = LGPlabel.value)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = loadingGeometryButton.size[0],$
                       YOFFSET   = loadingGeometryButton.size[1],$
                       SCR_XSIZE = loadingGeometryButton.size[2],$
                       SCR_YSIZE = loadingGeometryButton.size[3],$
                       UNAME     = loadingGeometryButton.uname,$
                       VALUE     = loadingGeometryButton.value,$
                       SENSITIVE = 0)
                      
IF (VersionLight) THEN BEGIN
    label1 = WIDGET_LABEL(base,$
                          XOFFSET = status_label.size[0],$
                          YOFFSET = status_label.size[1],$
                          VALUE   = status_label.value,$
                          UNAME   = status_label.uname,$
                          /DYNAMIC_RESIZE)

    text_widget = WIDGET_TEXT(base,$
                              XOFFSET   = debug_text.size[0],$
                              YOFFSET   = debug_text.size[1],$
                              SCR_XSIZE = debug_text.size[2],$
                              SCR_YSIZE = debug_text.size[3],$
                              UNAME     = debug_text.uname,$
                              /SCROLL,$
                              /WRAP)

ENDIF




END
