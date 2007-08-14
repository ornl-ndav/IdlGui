PRO MakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle, instrument

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;RunNumber widgets (label - text_field and button)
d_L_T = 85
d_L_B = 200
RunNumberLabelSize      = [300,15]
RunNumberTextFieldSize  = [RunNumberLabelSize[0] + d_L_T,$
                           RunNumberLabelSize[1]-5,$
                           100,$
                           30]
RunNumberLoadButtonSize = [RunNumberLabelSize[0]+d_L_B,$
                           RunNumberLabelSize[1]-5,$
                           100,$
                           30]
GlobalRunNumber         = [RunNumberLabelSize,$
                           RunNumberTextFieldSize,$
                           RunNumberLoadButtonSize]
RunNumberTitles         =  ['RUN NUMBER: ',$
                            'L O A D ']

;1D and 2D tabs
LoadTabSize   = [0,$
                 0,$
                 MainTabSize[2],$
                 MainTabSize[3]]
D_DD_TabSize  = [30,$
                 30,$
                 MainTabSize[2]-570,$
                 MainTabSize[3]-90]
D_DD_BaseSize = [5,$
                 5,$
                 D_DD_TabSize[2],$
                 D_DD_TabSize[3]]
D_DD_TabTitle = ['   1 Dimension   ',$
                 '   2 Dimensions  ']
                   
;Size of 1D and 2D graphs
Nx = 256
Ny = 304
if (instrument EQ 'REF_L') then begin
    xoff = 45
    yoff = 0
    xsize = 2*Nx
    ysize = 2*Ny
endif else begin
    xoff = 5
    yoff = 40
    xsize = 2*Ny
    ysize = 2*Nx
endelse

LoadDataNormalization1DGraphSize    = [5,0,608,608]
LoadDataNormalization2DRefGraphSize = [xoff,yoff,xsize,ysize]
GlobalLoadDataGraphs = [LoadDataNormalization1DGraphSize,$
                        LoadDataNormalization2DRefGraphSize]

;File info hudge label (empty for now)
FileInfoSize = [D_DD_TabSize[2]+50,$
                15,$
                490,$
                800]

;----Build widgets-----
LOAD_BASE = WIDGET_BASE(MAIN_TAB,$
                        UNAME='load_base',$
                        TITLE=LoadTabTitle,$
                        XOFFSET=LoadTabSize[0],$
                        YOFFSET=LoadTabSize[1],$
                        SCR_XSIZE=LoadTabSize[2],$
                        SCR_YSIZE=LoadTabSize[3])

;Build DATA and NORMALIZATION tabs
MakeGuiLoadDataNormalizationTab,$
  LOAD_BASE,$
  MainTabSize,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles,$
  GlobalLoadDataGraphs,$
  FileInfoSize
  
END
