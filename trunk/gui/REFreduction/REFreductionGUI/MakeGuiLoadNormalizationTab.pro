PRO MakeGuiLoadNormalizationTab, DataNormalizationTab,$
                                 DataNormalizationTabSize,$
                                 NormalizationTitle,$
                                 D_DD_TabSize,$
                                 D_DD_BaseSize,$
                                 D_DD_TabTitle,$
                                 GlobalRunNumber,$
                                 RunNumberTitles,$
                                 GlobalLoadDataGraphs,$
                                 FileInfoSize,$
                                 LeftInteractionHelpsize,$
                                 LeftInteractionHelpMessageLabeltitle

 
;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LoadNormalizationTabSize = [0,0,$
                            DataNormalizationTabSize[2],$
                            DataNormalizationTabSize[3]]

;Build widgets
LOAD_NORMALIZATION_BASE = WIDGET_BASE(DataNormalizationTab,$
                                      UNAME='load_normalization_base',$
                                      TITLE=NormalizationTitle,$
                                      XOFFSET=LoadNormalizationTabSize[0],$
                                      YOFFSET=LoadNormalizationTabSize[1],$
                                      SCR_XSIZE=LoadNormalizationTabSize[2],$
                                      SCR_YSIZE=LoadNormalizationTabSize[3])

;Run Number widgets (label - text_field - LOAD button)
load_normalization_run_number_label = widget_label(LOAD_NORMALIZATION_BASE,$
                                                   value=RunNumberTitles[0],$
                                                   xoffset=GlobalRunNumber[0],$
                                                   yoffset=GlobalRunNumber[1])

load_normalization_run_number_text_field = widget_text(LOAD_NORMALIZATION_BASE,$
                                                       xoffset=GlobalRunNumber[2],$
                                                       yoffset=GlobalRunNumber[3],$
                                                       scr_xsize=GlobalRunNumber[4],$
                                                       scr_ysize=GlobalRunNumber[5],$
                                                       /editable,$
                                                       /align_left,$
                                                       /all_events,$
                                                       uname='load_normalization_run_number_text_field')

load_normalization_run_number_button = widget_button(LOAD_NORMALIZATION_BASE,$
                                                     xoffset=GlobalRunNumber[6],$
                                                     yoffset=GlobalRunNumber[7],$
                                                     scr_xsize=GlobalRunNumber[8],$
                                                     scr_ysize=GlobalRunNumber[9],$
                                                     sensitive=1,$
                                                     value=RunNumberTitles[1],$
                                                     uname='load_normalization_run_number_button')



;Build 1D and 2D tabs
MakeGuiLoadNormalization1D2DTab,$
  LOAD_NORMALIZATION_BASE,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadDataGraphs

;File info huge label
normalization_file_info_label = widget_label(LOAD_NORMALIZATION_BASE,$
                                             xoffset=FileInfoSize[0],$
                                             yoffset=FileInfoSize[1],$
                                             scr_xsize=FileInfoSize[2],$
                                             scr_ysize=FileInfoSize[3],$
                                             frame=1,$
                                             value='')

;Text field box to get info about current process
normalization_log_book_text_field = widget_text(LOAD_NORMALIZATION_BASE,$
                                                uname='normalization_log_book_text_field',$
                                                xoffset=FileInfoSize[4],$
                                                yoffset=FileInfoSize[5],$
                                                scr_xsize=FileInfoSize[6],$
                                                scr_ysize=FileInfoSize[7],$
                                                /scroll,$
                                                /wrap)





END
