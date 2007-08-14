PRO MakeGuiLoadDataTab, DataNormalizationTab,$
                        DataNormalizationTabSize,$
                        DataTitle,$
                        D_DD_TabSize,$
                        D_DD_TabTitle,$
                        GlobalRunNumber,$
                        RunNumberTitles

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LoadDataTabSize = [0,0,$
                   DataNormalizationTabSize[2],$
                   DataNormalizationTabSize[3]]

;Build widgets
LOAD_DATA_BASE = WIDGET_BASE(DataNormalizationTab,$
                             UNAME='load_data_base',$
                             TITLE=DataTitle,$
                             XOFFSET=LoadDataTabSize[0],$
                             YOFFSET=LoadDataTabSize[1],$
                             SCR_XSIZE=LoadDataTabSize[2],$
                             SCR_YSIZE=LoadDataTabSize[3])


;Run Number widgets (label - text_field - LOAD button)
load_data_run_number_label = widget_label(LOAD_DATA_BASE,$
                                          value=RunNumberTitles[0],$
                                          xoffset=GlobalRunNumber[0],$
                                          yoffset=GlobalRunNumber[1])

load_data_run_number_text_field = widget_text(LOAD_DATA_BASE,$
                                              xoffset=GlobalRunNumber[2],$
                                              yoffset=GlobalRunNumber[3],$
                                              scr_xsize=GlobalRunNumber[4],$
                                              scr_ysize=GlobalRunNumber[5],$
                                              /editable,$
                                              /align_left,$
                                              /all_events,$
                                              uname='load_data_run_number_text_field')

load_data_run_number_button = widget_button(LOAD_DATA_BASE,$
                                            xoffset=GlobalRunNumber[6],$
                                            yoffset=GlobalRunNumber[7],$
                                            scr_xsize=GlobalRunNumber[8],$
                                            scr_ysize=GlobalRunNumber[9],$
                                            sensitive=1,$
                                            value=RunNumberTitles[1],$
                                            uname='load_data_run_number_button')


;Build 1D and 2D tabs
MakeGuiLoadData1D2DTab, LOAD_DATA_BASE, D_DD_TabSize, D_DD_TabTitle


END
