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

;Run Number base and inside CW_FIELD
load_normalization_run_number_base = widget_base(LOAD_NORMALIZATION_BASE,$
                                                 uname='load_normalization_run_number_base',$
                                                 xoffset=GlobalRunNumber[0],$
                                                 yoffset=GlobalRunNumber[1],$
                                                 scr_xsize=GlobalRunNumber[2],$
                                                 scr_ysize=globalRunNumber[3])

Load_data_run_number_text_field = CW_FIELD(load_normalization_run_number_base,$
                                           row=1,$
                                           xsize=GlobalRunNumber[4],$
                                           ysize=GlobalRunNumber[5],$
                                           /integer,$
                                           return_events=1,$
                                           title=RunNumberTitles[1],$
                                           uname='load_normalization_run_number_text_field')


;Build 1D and 2D tabs
MakeGuiLoadNormalization1D2DTab,$
  LOAD_NORMALIZATION_BASE,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadDataGraphs

;File info huge label
normalization_file_info_text = widget_text(LOAD_NORMALIZATION_BASE,$
                                            xoffset=FileInfoSize[0],$
                                            yoffset=FileInfoSize[1],$
                                            scr_xsize=FileInfoSize[2],$
                                            scr_ysize=FileInfoSize[3],$
                                            /wrap,$
                                            /scroll,$
                                            uname='normalization_file_info_text',$
                                            value='')

;Help base and text field that will show what is going on in the
;drawing region
LeftInteractionHelpMessageBase = widget_base(LOAD_NORMALIZATION_BASE,$
                                             uname='left_interaction_help_message_base',$
                                             xoffset=LeftInteractionHelpsize[0],$
                                             yoffset=LeftInteractionHelpsize[1],$
                                             scr_xsize=LeftInteractionHelpsize[2],$
                                             scr_ysize=LeftInteractionHelpsize[3],$
                                             frame=1)

LeftInteractionHelpMessageLabel = widget_label(LeftInteractionHelpMessageBase,$
                                               uname='left_norm_interaction_help_message_help',$
                                               xoffset=LeftInteractionHelpSize[4],$
                                               yoffset=LeftInteractionHelpSize[5],$
                                               scr_xsize=LeftInteractionHelpSize[8],$
                                               value=LeftInteractionHelpMessageLabelTitle)

LeftInteractionHelpTextField = widget_text(LeftInteractionHelpMessageBase,$
                                           xoffset=LeftInteractionHelpSize[6],$
                                           yoffset=LeftInteractionHelpSize[7],$
                                           scr_xsize=LeftInteractionHelpSize[8],$
                                           scr_ysize=LeftInteractionHelpSize[9],$
                                           uname='NORM_left_interaction_help_text',$
                                           /wrap,$
                                           /scroll)
                                           
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
