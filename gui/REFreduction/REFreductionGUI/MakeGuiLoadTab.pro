PRO MakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LoadTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]
D_DD_TabSize  = [30,30,MainTabSize[2]-60,MainTabSize[3]-130]
D_DD_TabTitle = ['   1 Dimension   ',$
                 '   2 Dimensions  ']

d_L_T = 85
d_L_B = 200
RunNumberLabelSize      = [400,15]
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
                   

;Build widgets
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
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles

END
