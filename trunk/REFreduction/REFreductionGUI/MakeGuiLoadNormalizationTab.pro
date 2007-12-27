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
                                 LeftInteractionHelpMessageLabeltitle,$
                                 NxsummaryZoomTabSize,$
                                 NxsummaryZoomTitle,$
                                 ZoomScaleBaseSize,$
                                 ZoomScaleTitle,$
                                 ArchivedOrAllCWBgroupList,$
                                 ArchivedOrAllCWBgroupSize,$
                                 NexusListSizeGlobal,$
                                 NexusListLabelGlobal,$
                                 loadctList

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
                                           /long,$
                                           return_events=1,$
                                           title=RunNumberTitles[1],$
                                           uname='load_normalization_run_number_text_field')


;Archived or All NeXus list
NormArchivedOrAllCWBgroup = cw_bgroup(LOAD_NORMALIZATION_BASE,$
                                      ArchivedOrAllCWBgroupList,$
                                      uname='normalization_archived_or_full_cwbgroup',$
                                      xoffset=ArchivedOrAllCWBgroupSize[0],$
                                      yoffset=ArchivedOrAllCWBgroupSize[1],$
                                      /exclusive,$
                                      row=1,$
                                      set_value=0)

;Nexus list base/label/droplist and buttons
NormListNexusBase = widget_base(LOAD_normalization_BaSE,$
                                uname='norm_list_nexus_base',$
                                xoffset=NexusListSizeGlobal[0],$
                                yoffset=NexusListSizeGlobal[1],$
                                scr_xsize=NexusListSizeGlobal[2],$
                                scr_ysize=NexusListSizeGlobal[3],$
                                frame=2,$
                                map=0)

NormListNexusLabel = widget_label(NormListNexusBase,$
                                  xoffset=NexusListSizeGlobal[4],$
                                  yoffset=NexusListSizeGlobal[5],$
                                  scr_xsize=NexusListSizeGlobal[6],$
                                  scr_ysize=NexusListSizeGlobal[7],$
                                  value=NexusListLabelGlobal[0],$
                                  frame=1)

DropListvalue = ['                                                                        ']
NormListDropList = widget_droplist(NormListNexusBase,$
                                   uname='normalization_list_nexus_droplist',$
                                   xoffset=NexusListSizeGlobal[8],$
                                   yoffset=NexusListSizeGlobal[9],$
                                   value=DropListValue,$
                                   /tracking_events)
                                   
NormListNexusNXsummary = widget_text(NormListNexusBase,$
                                     xoffset=NexusListSizeGlobal[10],$
                                     yoffset=NexusListSizeGlobal[11],$
                                     scr_xsize=NexusListSizeGlobal[12],$
                                     scr_ysize=NexusListSizeGlobal[13],$
                                     /wrap,$
                                     /scroll,$
                                     uname='normalization_list_nexus_nxsummary_text_field')
  
NormListNexusLoadButton = widget_button(NormListNexusBase,$
                                        uname='norm_list_nexus_load_button',$
                                        xoffset=NexusListSizeGlobal[14],$
                                        yoffset=NexusListSizeGlobal[15],$
                                        scr_xsize=NexusListSizeGlobal[16],$
                                        scr_ysize=NexusListSizeGlobal[17],$
                                        value=NexusListLabelGlobal[1])
                                        
NormListNexusCancelButton = widget_button(NormListNexusBase,$
                                          uname='norm_list_nexus_cancel_button',$
                                          xoffset=NexusListSizeGlobal[18],$
                                          yoffset=NexusListSizeGlobal[19],$
                                          scr_xsize=NexusListSizeGlobal[20],$
                                          scr_ysize=NexusListSizeGlobal[21],$
                                          value=NexusListLabelGlobal[2])


;Build 1D and 2D tabs
MakeGuiLoadNormalization1D2DTab,$
  LOAD_NORMALIZATION_BASE,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadDataGraphs,$
  loadctList

;NXsummary and zoom tab
NxsummaryZoomTab = widget_tab(LOAD_NORMALIZATION_BASE,$
                              uname='normalization_nxsummary_zoom_tab',$
                              location=0,$
                              xoffset=NxsummaryZoomTabSize[0],$
                              yoffset=NxsummaryZoomTabSize[1],$
                              scr_xsize=NxsummaryZoomTabSize[2],$
                              scr_ysize=NxsummaryZoomTabSize[3],$
                              /tracking_events)

;NXsummary tab #1
data_Nxsummary_base = widget_base(NxsummaryZoomTab,$
                                  uname='normalization_nxsummary_base',$
                                  xoffset=0,$
                                  yoffset=0,$
                                  scr_xsize=NXsummaryZoomTabSize[2],$
                                  scr_ysize=NXsummaryZoomTabSize[3],$
                                  title=NxsummaryZoomTitle[0])

normalization_file_info_text = widget_text(data_Nxsummary_base,$
                                  xoffset=FileInfoSize[0],$
                                  yoffset=FileInfoSize[1],$
                                  scr_xsize=FileInfoSize[2],$
                                  scr_ysize=FileInfoSize[3],$
                                  /wrap,$
                                  /scroll,$
                                  value='',$
                                  uname='normalization_file_info_text')

;ZOOM tab #2
normalization_Zoom_base = widget_base(NxsummaryZoomTab,$
                             uname='normalization_zoom_base',$
                             xoffset=0,$
                             yoffset=0,$
                             scr_xsize=NXsummaryZoomTabSize[2],$
                             scr_ysize=NXsummaryZoomTabSize[3],$
                             title=NxsummaryZoomTitle[1])

;zoom base and droplist inside zoom tab (top right corner)
normalization_zoom_scale_base = widget_base(normalization_zoom_base,$
                                            xoffset=ZoomScaleBaseSize[0],$
                                            yoffset=ZoomScaleBaseSize[1],$
                                            scr_xsize=ZoomScaleBaseSize[2],$
                                            scr_ysize=ZoomScaleBaseSize[3],$
                                            frame=2,$
                                            uname='normalization_zoom_scale_base')

normalization_zoom_scale_cwfield = cw_field(normalization_zoom_scale_base,$
                                            Title=ZoomScaleTitle,$
                                            xsize=2,$
                                            /integer,$
                                            return_events=1,$
                                            ysize=1,$
                                            uname='normalization_zoom_scale_cwfield')

normalization_zoom_draw = widget_draw(normalization_zoom_base,$
                             uname='normalization_zoom_draw',$
                             xoffset=0,$
                             yoffset=0,$
                             scr_xsize=NXsummaryZoomTabSize[2],$
                             scr_ysize=NXsummaryZoomTabSize[3])

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
                                               uname='left_normalization_interaction_help_message_help',$
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
