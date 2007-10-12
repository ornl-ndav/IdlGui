PRO miniMakeGuiLoadDataTab, DataNormalizationTab,$
                            DataNormalizationTabSize,$
                            DataTitle,$
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
                            LoadctList

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
LoadDataTabSize = [0,0,$
                   DataNormalizationTabSize[2],$
                   DataNormalizationTabSize[3]]

;###############################################################################
;############################# Build widgets ###################################
;###############################################################################

LOAD_DATA_BASE = WIDGET_BASE(DataNormalizationTab,$
                             UNAME     = 'load_data_base',$
                             TITLE     = DataTitle,$
                             XOFFSET   = LoadDataTabSize[0],$
                             YOFFSET   = LoadDataTabSize[1],$
                             SCR_XSIZE = LoadDataTabSize[2],$
                             SCR_YSIZE = LoadDataTabSize[3])


;Run Number base and inside CW_FIELD
load_data_run_number_base = WIDGET_BASE(LOAD_DATA_BASE,$
                                        UNAME     = 'load_data_run_number_base',$
                                        XOFFSET   = GlobalRunNumber[0],$
                                        YOFFSET   = GlobalRunNumber[1],$
                                        SCR_XSIZE = GlobalRunNumber[2]-50,$
                                        SCR_YSIZE = GlobalRunNumber[3])

Load_data_run_number_text_field = $
  CW_FIELD(load_data_run_number_base,$
           ROW           = 1,$
           XSIZE         = GlobalRunNumber[4],$
           YSIZE         = GlobalRunNumber[5],$
           RETURN_EVENTS = 1,$
           TITLE         = RunNumberTitles[0],$
           UNAME         = 'load_data_run_number_text_field',$
           /LONG)

;Archived or All NeXus list
DataArchivedOrAllCWBgroup = $
  CW_BGROUP(LOAD_DATA_BASE,$
            ArchivedOrAllCWBgroupList,$
            UNAME     = 'data_archived_or_full_cwbgroup',$
            XOFFSET   = ArchivedOrAllCWBgroupSize[0],$
            YOFFSET   = ArchivedOrAllCWBgroupSize[1],$
            ROW       = 1,$
            SET_VALUE = 0,$
            /EXCLUSIVE)

;Nexus list base/label/droplist and buttons
DataListNexusBase = WIDGET_BASE(LOAD_DATA_BaSE,$
                                UNAME     = 'data_list_nexus_base',$
                                XOFFSET   = NexusListSizeGlobal[0],$
                                YOFFSET   = NexusListSizeGlobal[1],$
                                SCR_XSIZE = NexusListSizeGlobal[2],$
                                SCR_YSIZE = NexusListSizeGlobal[3],$
                                FRAME     = 2,$
                                MAP       = 0)

DataListNexusLabel = WIDGET_LABEL(DataListNexusBase,$
                                  XOFFSET   = NexusListSizeGlobal[4],$
                                  YOFFSET   = NexusListSizeGlobal[5],$
                                  SCR_XSIZE = NexusListSizeGlobal[6],$
                                  SCR_YSIZE = NexusListSizeGlobal[7],$
                                  VALUE     = NexusListLabelGlobal[0],$
                                  FRAME     = 1)

DropListvalue = $
  ['                                                                        ']
DataListNexusDropList = WIDGET_DROPLIST(DataListNexusBase,$
                                        UNAME   = 'data_list_nexus_droplist',$
                                        XOFFSET = NexusListSizeGlobal[8],$
                                        YOFFSET = NexusListSizeGlobal[9],$
                                        VALUE   = DropListValue,$
                                        /TRACKING_EVENTS)
                                   
DataListNexusNXsummary = $
  WIDGET_TEXT(DataListNexusBase,$
              XOFFSET   = NexusListSizeGlobal[10],$
              YOFFSET   = NexusListSizeGlobal[11],$
              SCR_XSIZE = NexusListSizeGlobal[12],$
              SCR_YSIZE = NexusListSizeGlobal[13],$
              UNAME     = 'data_list_nexus_nxsummary_text_field',$
              /WRAP,$
              /SCROLL)

DataListNexusLoadButton = $
  WIDGET_BUTTON(DataListNexusBase,$
                UNAME     = 'data_list_nexus_load_button',$
                XOFFSET   = NexusListSizeGlobal[14],$
                YOFFSET   = NexusListSizeGlobal[15],$
                SCR_XSIZE = NexusListSizeGlobal[16],$
                SCR_YSIZE = NexusListSizeGlobal[17],$
                VALUE     = NexusListLabelGlobal[1])
                                        
DataListNexusCancelButton = $
  WIDGET_BUTTON(DataListNexusBase,$
                UNAME     = 'data_list_nexus_cancel_button',$
                XOFFSET   = NexusListSizeGlobal[18],$
                YOFFSET   = NexusListSizeGlobal[19],$
                SCR_XSIZE = NexusListSizeGlobal[20],$
                SCR_YSIZE = NexusListSizeGlobal[21],$
                VALUE     = NexusListLabelGlobal[2])


;Build 1D and 2D tabs
miniMakeGuiLoadData1D2DTab,$
  LOAD_DATA_BASE,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadDataGraphs,$
  LoadctList


;NXsummary and zoom tab
NxsummaryZoomTab = WIDGET_TAB(LOAD_DATA_BASE,$
                              UNAME     = 'data_nxsummary_zoom_tab',$
                              LOCATION  = 0,$
                              XOFFSET   = NxsummaryZoomTabSize[0],$
                              YOFFSET   = NxsummaryZoomTabSize[1],$
                              SCR_XSIZE = NxsummaryZoomTabSize[2],$
                              SCR_YSIZE = NxsummaryZoomTabSize[3],$
                              /TRACKING_EVENTS)

;NXsummary tab #1
data_Nxsummary_base = WIDGET_BASE(NxsummaryZoomTab,$
                                  UNAME     = 'data_nxsummary_base',$
                                  XOFFSET   = 0,$
                                  YOFFSET   = 0,$
                                  SCR_XSIZE = NXsummaryZoomTabSize[2],$
                                  SCR_YSIZE = NXsummaryZoomTabSize[3],$
                                  TITLE     = NxsummaryZoomTitle[0])

data_file_info_text = WIDGET_TEXT(data_Nxsummary_base,$
                                  XOFFSET   = FileInfoSize[0],$
                                  YOFFSET   = FileInfoSize[1],$
                                  SCR_XSIZE = FileInfoSize[2],$
                                  SCR_YSIZE = FileInfoSize[3],$
                                  VALUE     = '',$
                                  UNAME     = 'data_file_info_text',$
                                  /WRAP,$
                                  /SCROLL)

;ZOOM tab #2
data_Zoom_base = WIDGET_BASE(NxsummaryZoomTab,$
                             UNAME     = 'data_zoom_base',$
                             XOFFSET   = 0,$
                             YOFFSET   = 0,$
                             SCR_XSIZE = NXsummaryZoomTabSize[2],$
                             SCR_YSIZE = NXsummaryZoomTabSize[3],$
                             TITLE     = NxsummaryZoomTitle[1])

;zoom base and droplist inside zoom tab (top right corner)
data_zoom_scale_base = WIDGET_BASE(data_zoom_base,$
                                   XOFFSET   = ZoomScaleBaseSize[0],$
                                   YOFFSET   = ZoomScaleBaseSize[1],$
                                   SCR_XSIZE = ZoomScaleBaseSize[2],$
                                   SCR_YSIZE = ZoomScaleBaseSize[3],$
                                   FRAME     = 2,$
                                   UNAME     ='data_zoom_scale_base')

data_zoom_scale_cwfield = CW_FIELD(data_zoom_scale_base,$
                                   TITLE         = ZoomScaleTitle,$
                                   XSIZE         = 2,$
                                   YSIZE         = 1,$
                                   RETURN_EVENTS = 1,$
                                   UNAME         = 'data_zoom_scale_cwfield',$
                                   /INTEGER)

data_zoom_draw = WIDGET_DRAW(data_zoom_base,$
                             UNAME     = 'data_zoom_draw',$
                             XOFFSET   = 0,$
                             YOFFSET   = 0,$
                             SCR_XSIZE = NXsummaryZoomTabSize[2],$
                             SCR_YSIZE = NXsummaryZoomTabSize[3])


;Help base and text field that will show what is going on in the
;drawing region
LeftInteractionHelpMessageBase = $
  WIDGET_BASE(LOAD_DATA_BASE,$
              UNAME     = 'left_interaction_help_message_base',$
              XOFFSET   = LeftInteractionHelpsize[0],$
              YOFFSET   = LeftInteractionHelpsize[1],$
              SCR_XSIZE = LeftInteractionHelpsize[2],$
              SCR_YSIZE = LeftInteractionHelpsize[3],$
              FRAME     = 1)

LeftInteractionHelpMessageLabel = $
  WIDGET_LABEL(LeftInteractionHelpMessageBase,$
               UNAME     = 'left_data_interaction_help_message_help',$
               XOFFSET   = LeftInteractionHelpSize[4],$
               YOFFSET   = LeftInteractionHelpSize[5],$
               SCR_XSIZE = LeftInteractionHelpSize[8],$
               VALUE     = LeftInteractionHelpMessageLabelTitle)

LeftInteractionHelpTextField = $
  WIDGET_TEXT(LeftInteractionHelpMessageBase,$
              XOFFSET   = LeftInteractionHelpSize[6],$
              YOFFSET   = LeftInteractionHelpSize[7],$
              SCR_XSIZE = LeftInteractionHelpSize[8],$
              SCR_YSIZE = LeftInteractionHelpSize[9],$
              UNAME     = 'DATA_left_interaction_help_text',$
              /WRAP,$
              /SCROLL)

;Text field box to get info about current process
data_log_book_text_field = $
  WIDGET_TEXT(LOAD_DATA_BASE,$
              UNAME     = 'data_log_book_text_field',$
              XOFFSET   = FileInfoSize[4],$
              YOFFSET   = FileInfoSize[5],$
              SCR_XSIZE = FileInfoSize[6],$
              SCR_YSIZE = FileInfoSize[7],$
              /SCROLL,$
              /WRAP)

END
