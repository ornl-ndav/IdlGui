PRO MakeGuiSelectionTab, MAIN_TAB, MainTabSize, SelectionTitle, XYfactor

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************

CountsVsTofSize = [15,$
                   10,$
                   400,$
                   215]

OpenNeXusSelectionTab = [428,10,425,190]
OpenNeXusTitle        = ' NEXUS / ROI '
SelectionTitle        = '  SELECTION  '

Xfactor = XYfactor.Xfactor 
Yfactor = XYfactor.Yfactor
TopBankSize    = [15, $
                  240, $
                  56*Xfactor, $
                  64*Yfactor]
BottomBankSize = [TopBankSize[0], $
                  510, $
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
COUNTS_VS_TOF = WIDGET_DRAW(SelectionBase,$
                            UNAME     = 'counts_vs_tof_draw',$
                            XOFFSET   = CountsVsTofSize[0],$
                            YOFFSET   = CountsVsTofSize[1],$
                            SCR_XSIZE = CountsVsTofSize[2],$
                            SCR_YSIZE = CountsVsTofSize[3],$
                            /MOTION_EVENTS,$
                            /BUTTON_EVENTS)

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
