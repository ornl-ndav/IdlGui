;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

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
    
  ;##############################################################################
  ;############################# Build widgets ##################################
  ;##############################################################################
    
  LOAD_DATA_BASE = WIDGET_BASE(DataNormalizationTab,$
    UNAME     = 'load_data_base',$
    TITLE     = DataTitle,$
    XOFFSET   = LoadDataTabSize[0],$
    YOFFSET   = LoadDataTabSize[1],$
    SCR_XSIZE = LoadDataTabSize[2],$
    SCR_YSIZE = LoadDataTabSize[3])
    
  ;******************* loading nexus interface **********************************
  NexusInterface, BASE_UNAME = LOAD_DATA_BASE,$
    BROWSE_BUTTON_UNAME = 'browse_data_nexus_button',$
    RUN_NBR_UNAME       = 'load_data_run_number_text_field',$
    ARCHIVED_ALL_UNAME  = 'data_archived_or_full_cwbgroup',$
    PROPOSAL_BUTTON_UNAME = 'with_data_proposal_button',$
    PROPOSAL_FOLDER_DROPLIST_UNAME = $
    'data_proposal_folder_droplist',$
    PROPOSAL_BASE_UNAME = 'data_proposal_base_uname',$
    SAVE_AS_JPEG_UNAME = 'save_as_jpeg_button_data',$
    PLOT_BUTTON_UNAME = 'advanced_plot_button_data'
    
  ;------------------------------------------------------------------------------
    
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
    
  ;TOF selection tool
  tof_button = widget_button(load_data_base,$
    value = '  T O F   selection  tool    ',$
    xoffset = 563,$
    yoffset = 37,$
    uname = 'tof_selection_tool_button')
    
  ;  ;base about X, Y and counts value --------------------------------------------
  ;  info_base = WIDGET_BASE(LOAD_DATA_BASE,$
  ;    XOFFSET   = 510,$
  ;    YOFFSET   = 35,$
  ;    SCR_XSIZE = 275,$
  ;    SCR_YSIZE = 20,$
  ;    UNAME     = 'info_data_base',$
  ;    MAP       = 0,$
  ;    FRAME     = 1)
  ;
  ;  ;X label/value
  ;  y_off = 0
  ;  x_label = WIDGET_LABEL(info_base,$
  ;    XOFFSET = 0,$
  ;    YOFFSET = y_off,$
  ;    VALUE   = 'X:')
  ;  x_value = WIDGET_LABEL(info_base,$
  ;    XOFFSET   = 15,$
  ;    YOFFSET   = y_off,$
  ;    SCR_XSIZE = 50,$
  ;    VALUE     = 'N/A',$
  ;    UNAME     = 'data_x_info_value',$
  ;    /ALIGN_LEFT)
  ;
  ;  ;Y label/value
  ;  y_label = WIDGET_LABEL(info_base,$
  ;    XOFFSET = 70,$
  ;    YOFFSET = y_off,$
  ;    VALUE   = 'Y:')
  ;  y_value = WIDGET_LABEL(info_base,$
  ;    XOFFSET   = 85,$
  ;    YOFFSET   = y_off,$
  ;    SCR_XSIZE = 50,$
  ;    VALUE     = 'N/A',$
  ;    UNAME     = 'data_y_info_value',$
  ;    /ALIGN_LEFT)
  ;
  ;  ;COUNTS label/value
  ;  counts_label = WIDGET_LABEL(info_base,$
  ;    XOFFSET = 140,$
  ;    YOFFSET = y_off,$
  ;    VALUE   = 'COUNTS:')
  ;  counts_value = WIDGET_LABEL(info_base,$
  ;    XOFFSET   = 185,$
  ;    YOFFSET   = y_off,$
  ;    SCR_XSIZE = 50,$
  ;    VALUE     = 'N/A',$
  ;    UNAME     = 'data_counts_info_value',$
  ;    /ALIGN_LEFT)
    
  ;------------------------------------------------------------------------------
    
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
    
  ;geometry info --------------------------------------------------------------
  GeoBase = WIDGET_BASE(LOAD_DATA_BASE,$
    XOFFSET = 365,$
    YOFFSET = 450,$
    SCR_XSIZE = 205,$
    SCR_YSIZE = 115,$
    UNAME = 'data_geometry_info_base',$
    FRAME = 1,$
    /COLUMN)
    
  title = widget_label(GeoBase,$
    value = 'Geometry Information')
    
  row1 = WIDGET_BASE(GeoBase,$
    xpad = 0,$
    /row)
  label1 = WIDGET_LABEL(row1,$
    value = 'DANGLE0 :')
  label2 = WIDGET_LABEL(row1,$
    value = 'N/A',$
    scr_xsize = 70,$
    /align_left,$
    uname = 'data_geometry_dangle_value')
  label3 = widget_label(row1,$
    value = ' ',$
    scr_xsize = 50,$
    /align_left,$
    uname = 'data_geometry_dangle_units')
    
  row2 = WIDGET_BASE(GeoBase,$
    xpad = 0,$
    /row)
  label1 = WIDGET_LABEL(row2,$
    value = 'DIRPIX')
  label = widget_label(row2,$
    value = '(N/A) :',$
    scr_xsize = 75,$
    /align_left,$
    uname = 'data_geometry_dirpix_value')
  label2 = WIDGET_TEXT(row2,$
    value = 'N/A',$
    scr_xsize = 82,$
    /EDITABLE,$
    /align_left,$
    uname = 'data_geometry_dirpix_value_user')
    
  row3 = WIDGET_BASE(GeoBase,$
    xpad = 0,$
    /row)
  label1 = WIDGET_LABEL(row3,$
    value = 'REFPIX :')
  label2 = WIDGET_LABEL(row3,$
    value = 'N/A',$
    scr_xsize = 70,$
    /align_left,$
    uname = 'data_geometry_refpix_value')
    
  ;----------------------------------------------------------------------------
    
  ;Help base and text field that will show what is going on in the
  ;drawing region
  LeftInteractionHelpMessageBase = $
    WIDGET_BASE(LOAD_DATA_BASE,$
    UNAME     = 'left_interaction_help_message_base',$
    XOFFSET   = 580,$
    YOFFSET   = LeftInteractionHelpsize[1],$
    SCR_XSIZE = 308,$
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
    XOFFSET   = 2,$
    YOFFSET   = LeftInteractionHelpSize[7],$
    SCR_XSIZE = 300,$
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
