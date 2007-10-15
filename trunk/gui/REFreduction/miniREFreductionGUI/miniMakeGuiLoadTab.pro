PRO miniMakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle, instrument

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;RunNumber label and inside CW_FIELD
RunNumberBaseSize    = [20,0,210,35]
RunNumberCWFieldSize = [10,0]
GlobalRunNumber      = [RunNumberBaseSize,$
                        RunNumberCWFieldSize]
RunNumberTitles      =  ['RUN NUMBER:',$
                         'RUN NUMBER:']

;1D and 2D tabs
LoadTabSize   = [0,$
                 0,$
                 MainTabSize[2],$
                 MainTabSize[3]]
D_DD_TabSize  = [20,$
                 35,$
                 330,$ 
                 590]
D_DD_BaseSize = [5,$
                 5,$
                 D_DD_TabSize[2],$
                 D_DD_TabSize[3]]

if (instrument EQ 'REF_L') then begin
    DTitle = 'Y vs TOF (2D)'
    D3DTitle = 'Y vs TOF (3D)'
endif else begin
    DTitle = 'X vs TOF'
    D3DTitle = 'X vs TOF (3D)'
endelse

D_DD_TabTitle = [DTitle,$
                 'Y vs X (2D)',$
                 D3DTitle,$
                 'Y vs X (3D)']

;Size of 1D and 2D graphs
Nx = 256
Ny = 304
if (instrument EQ 'REF_L') then begin
    xoff = 35
    yoff = 10
    xsize = Nx
    ysize = Ny
endif else begin
    xoff = 5
    yoff = 40
    xsize = Ny
    ysize = Nx
endelse

LoadDataNormalization1DGraphSize    = [5, $
                                       0, $
                                       304, $
                                       304]
LoadDataNormalization2DRefGraphSize = [xoff, $
                                       yoff, $
                                       xsize, $
                                       ysize]
GlobalLoadDataGraphs = [LoadDataNormalization1DGraphSize,$
                        LoadDataNormalization2DRefGraphSize]

;NXsummary and Zoom tab
NxsummaryZoomTabSize = [D_DD_TabSize[2]+35,$
                        5,$
                        495,$
                        395]
NxsummaryZoomTitle = ['NX summary','ZOOM']

ZoomScaleBaseSize = [380,0,110,35]
ZoomScaleTitle = 'Zoom factor'

;File info hudge label (previous of roi file...)
;top label
FileInfoSize_1 = [0,$
                  0,$
                  489,$
                  370] ;393

;help text box to explain what is going on on the left
LeftInteractionHelpMessageBaseSize = [NxsummaryZoomTabSize[0],$
                                      405,$
                                      493,$
                                      150]
LeftInteractionHelpMessageLabelSize = [5,5]
LeftInteractionHelpMessageLabelTitle = 'I N F O'
LeftInteractionHelpTextSize = [5,25,485,123]
LeftInteractionHelpSize = [LeftInteractionHelpMessageBaseSize,$
                           LeftInteractionHelpMessageLabelSize,$
                           LeftInteractionHelpTextsize]
                           
;bottom text field
FileInfoSize_2 = [NxsummaryZoomTabSize[0]-3,$
                  565,$
                  498,$
                  60]

FileInfoSize = [FileInfoSize_1,FileInfoSize_2]

;###############################################################################
;############################# Build widgets ###################################
;###############################################################################

LOAD_BASE = WIDGET_BASE(MAIN_TAB,$
                        UNAME         = 'load_base',$
                        TITLE         = LoadTabTitle,$
                        XOFFSET       = LoadTabSize[0],$
                        YOFFSET       = LoadTabSize[1],$
                        SCR_XSIZE     = LoadTabSize[2],$
                        SCR_YSIZE     = LoadTabSize[3],$
                        x_scroll_size = 400,$
                        y_scroll_size = 300,$
                       /scroll)


;Build DATA and NORMALIZATION tabs
miniMakeGuiLoadDataNormalizationTab,$
  LOAD_BASE,$
  MainTabSize,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles,$
  GlobalLoadDataGraphs,$
  FileInfoSize,$
  LeftInteractionHelpsize,$
  LeftInteractionHelpMessageLabeltitle,$
  NxsummaryZoomTabSize,$
  NxsummaryZoomTitle,$
  ZoomScaleBaseSize,$
  ZoomScaleTitle
  
END
