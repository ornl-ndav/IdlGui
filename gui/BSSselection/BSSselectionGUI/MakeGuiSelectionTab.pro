PRO MakeGuiSelectionTab, MAIN_TAB, MainTabSize, SelectionTitle, XYfactor

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************

CountsVsTofLabelSize  = [890,210]
CountsVsTofLabelTitle = ' C O U N T S   vs   T O F'

CountsVsTofSize = [755,$
                   230,$
                   430,$
                   225]

;X, Y, PixelID and Bank of data display in counts vs tof
CountsVsTofXLabelSize = [750,450,100,30]
xoff = 100
CountsVsTofYLabelSize = [CountsVsTofXLabelSize[0]+xoff,$
                         CountsVsTofXLabelSize[1:3]]
CountsVsTofBankLabelSize = [CountsVsTofXLabelSize[0]+2*xoff,$
                            CountsVsTofXLabelSize[1:3]]
xoff = 105
CountsVsTofPixelLabelSize = [CountsVsTofXLabelSize[0]+3*xoff,$
                             CountsVsTofXLabelSize[1:3]]

CountsVsTofFrameSize = [748,205,440,275]

OpenNeXusSelectionTab = [755,5,425,170]
OpenNeXusTitle        = ' NEXUS / ROI '
SelectionTitle        = '  SELECTION  '

XYPixelIDBaseSize     = [120,330,515,35]
xbaseSize             = [0,0,55,35]
xoff = 60
ybasesize             = [xbaseSize[0]+xoff,$
                         xbaseSize[1],$
                         xbaseSize[2],$
                         xbaseSize[3]]
xoff = 60
bankBaseSize          = [ybaseSize[0]+xoff,$
                         xbaseSize[1],$
                         65,$
                         xbaseSize[3]]
xoff = 70
rowBaseSize           = [bankbaseSize[0]+xoff,$
                         xbaseSize[1],$
                         80,$
                         xbaseSize[3]]
xoff = 80
pixelIDbaseSize       = [rowbaseSize[0]+xoff,$
                         xbaseSize[1],$
                         110,$
                         xbaseSize[3]]
xoff = 110
countsBaseSize        = [pixelIDbasesize[0]+xoff,$
                         xbaseSize[1],$
                         150,$
                         xbaseSize[3]]

Xfactor = XYfactor.Xfactor 
Yfactor = XYfactor.Yfactor
TopBankSize    = [15, $
                  5, $
                  56*Xfactor, $
                  64*Yfactor]
BottomBankSize = [TopBankSize[0], $
                  375, $
                  TopBankSize[2], $
                  TopBanksize[3]]

;***********************************************************************************
;                                Build GUI
;***********************************************************************************

SelectionBase = WIDGET_BASE(MAIN_TAB,$
                            XOFFSET   = 0,$
                            YOFFSET   = 0,$
                            SCR_XSIZE = MainTabSize[2],$
                            SCR_YSIZE = MainTabSize[3],$
                            TITLE     = SelectionTitle)

;COUNTS VS TOF
counts_vs_tof_label = WIDGET_LABEL(SelectionBase,$
                                   XOFFSET = CountsVsTofLabelSize[0],$
                                   YOFFSET = CountsVsTofLabelSize[1],$
                                   VALUE   = CountsVsTofLabelTitle)

COUNTS_VS_TOF = WIDGET_DRAW(SelectionBase,$
                            UNAME     = 'counts_vs_tof_draw',$
                            XOFFSET   = CountsVsTofSize[0],$
                            YOFFSET   = CountsVsTofSize[1],$
                            SCR_XSIZE = CountsVsTofSize[2],$
                            SCR_YSIZE = CountsVsTofSize[3],$
                            /MOTION_EVENTS,$
                            /BUTTON_EVENTS)

CountsVsTofXLabel = WIDGET_LABEL (SelectionBase,$
                                  UNAME     = 'counts_vs_tof_x_label',$
                                  XOFFSET   = CountsVsTofXLabelSize[0],$
                                  YOFFSET   = CountsVsTofXLabelSize[1],$
                                  SCR_XSIZE = CountsVsTofXLabelSize[2],$
                                  SCR_YSIZE = CountsVsTofXLabelSize[3],$
                                  VALUE     = 'X:')

CountsVsTofYLabel = WIDGET_LABEL (SelectionBase,$
                                  UNAME     = 'counts_vs_tof_y_label',$
                                  XOFFSET   = CountsVsTofYLabelSize[0],$
                                  YOFFSET   = CountsVsTofYLabelSize[1],$
                                  SCR_XSIZE = CountsVsTofYLabelSize[2],$
                                  SCR_YSIZE = CountsVsTofYLabelSize[3],$
                                  VALUE     = 'Y:')

CountsVsTofBankLabel = WIDGET_LABEL (SelectionBase,$
                                     UNAME     = 'counts_vs_tof_bank_label',$
                                     XOFFSET   = CountsVsTofBankLabelSize[0],$
                                     YOFFSET   = CountsVsTofBankLabelSize[1],$
                                     SCR_XSIZE = CountsVsTofBankLabelSize[2],$
                                     SCR_YSIZE = CountsVsTofBankLabelSize[3],$
                                     VALUE     = 'Bank:')

CountsVsTofPixelLabel = WIDGET_LABEL (SelectionBase,$
                                      UNAME     = 'counts_vs_tof_pixel_label',$
                                      XOFFSET   = CountsVsTofPixelLabelSize[0],$
                                      YOFFSET   = CountsVsTofPixelLabelSize[1],$
                                      SCR_XSIZE = CountsVsTofPixelLabelSize[2],$
                                      SCR_YSIZE = CountsVsTofPixelLabelSize[3],$
                                      VALUE     = 'Pixel:')

CountsVsTofFrame = WIDGET_LABEL(SelectionBase,$
                                XOFFSET   = CountsVsTofFrameSize[0],$
                                YOFFSET   = CountsVsTofFrameSize[1],$
                                SCR_XSIZE = CountsVsTofFrameSize[2],$
                                SCR_YSIZE = CountsVsTofFrameSize[3],$
                                FRAME     = 1)

;NeXus/ROI & SELECTION tab
NeXusRoiSelectionTab = WIDGET_TAB(SelectionBase,$
                                  UNAME     = 'nexus_roi_selection_tab',$
                                  LOCATION  = 0,$
                                  XOFFSET   = OpenNeXusSelectionTab[0],$
                                  YOFFSET   = OpenNeXusSelectionTab[1],$
                                  SCR_XSIZE = OpenNeXusSelectionTab[2],$
                                  SCR_YSIZE = OpenNeXusSelectionTab[3],$
                                  SENSITIVE = 1,$
                                  /TRACKING_EVENTS)

;make NeXus/ROI tab (tab#1)
MakeGuiNeXusRoiBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, OpenNeXusTitle

;make Selection tab (tab#2)
MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, SelectionTitle

;X, Y and pixelID info box
XYPixelIDBase = WIDGET_BASE(SelectionBase,$
                            XOFFSET   = XYPixelIDBaseSize[0],$
                            YOFFSET   = XYPixelIDBaseSize[1],$
                            SCR_XSIZE = XYPixelIDBaseSize[2],$
                            SCR_YSIZE = XYPixelIDBaseSize[3],$
                            FRAME     = 1)

xbase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = xbaseSize[0],$
                    YOFFSET   = ybaseSize[1],$
                    SCR_XSIZE = xbaseSize[2],$
                    SCR_YSIZE = xbaseSize[3])

Xfield = CW_FIELD(xbase,$
                  UNAME         = 'x_value',$
                  RETURN_EVENTS = 1,$
                  TITLE         = 'X:',$
                  ROW           = 1,$
                  XSIZE         = 2)

ybase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = ybaseSize[0],$
                    YOFFSET   = ybaseSize[1],$
                    SCR_XSIZE = ybaseSize[2],$
                    SCR_YSIZE = ybaseSize[3])

Yfield = CW_FIELD(ybase,$
                  UNAME         = 'y_value',$
                  RETURN_EVENTS = 1,$
                  TITLE         = 'Y:',$
                  ROW           = 1,$
                  XSIZE         = 2)

bankBase = WIDGET_BASE(XYPixelIDBase,$
                       XOFFSET   = bankBaseSize[0],$
                       YOFFSET   = bankBaseSize[1],$
                       SCR_XSIZE = bankBaseSize[2],$
                       SCR_YSIZE = bankBaseSize[3])

bankfield = CW_FIELD(bankBase,$
                     UNAME         = 'bank_value',$
                     RETURN_EVENTS = 1,$
                     TITLE         = 'Bank:',$
                     ROW           = 1,$
                     XSIZE         = 1)

rowBase = WIDGET_BASE(XYPixelIDBase,$
                      XOFFSET   = rowBaseSize[0],$
                      YOFFSET   = rowBaseSize[1],$
                      SCR_XSIZE = rowBaseSize[2],$
                      SCR_YSIZE = rowBaseSize[3])

rowfield = CW_FIELD(rowbase,$
                    UNAME         = 'row_value',$
                    RETURN_EVENTS = 1,$
                    TITLE         = 'Row:',$
                    ROW           = 1,$
                    XSIZE         = 3)

pixelIDbase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = pixelIDbaseSize[0],$
                    YOFFSET   = pixelIDbaseSize[1],$
                    SCR_XSIZE = pixelIDbaseSize[2],$
                    SCR_YSIZE = pixelIDbaseSize[3])

Pixelfield = CW_FIELD(pixelIDbase,$
                      UNAME         = 'pixel_value',$
                      RETURN_EVENTS = 1,$
                      TITLE         = 'PixelID:',$
                      ROW           = 1,$
                      XSIZE         = 5)

countsBase = WIDGET_BASE(XYPixelIDBase,$
                         XOFFSET = countsBaseSize[0],$
                         YOFFSET = countsBaseSize[1],$
                         SCR_XSIZE=countsBaseSize[2],$
                         SCR_YSIZE=countsBaseSize[3])

countsfield = CW_FIELD(countsbase,$
                       UNAME         = 'counts_value',$
                       RETURN_EVENTS = 1,$
                       TITLE         = 'Counts:',$
                       ROW           = 1,$
                       XSIZE         = 8)

;TOP_BANK
TOP_BANK_DRAW = WIDGET_DRAW(SelectionBase,$
                            UNAME     = 'top_bank_draw',$
                            XOFFSET   = TopBankSize[0],$
                            YOFFSET   = TopBankSize[1],$
                            SCR_XSIZE = TopBankSize[2],$
                            SCR_YSIZE = TopBankSize[3],$
                            /BUTTON_EVENTS,$
                            /MOTION_EVENTS)

;BOTTOM_BANK
BOTTOM_BANK_DRAW = WIDGET_DRAW(SelectionBase,$
                               UNAME     = 'bottom_bank_draw',$
                               XOFFSET   = BottomBankSize[0],$
                               YOFFSET   = BottomBankSize[1],$
                               SCR_XSIZE = BottomBankSize[2],$
                               SCR_YSIZE = BottomBankSize[3],$
                               /BUTTON_EVENTS,$
                               /MOTION_EVENTS)

END
