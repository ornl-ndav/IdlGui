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

PRO MakeGuiLoadDataTab, DataNormalizationTab,$
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
    
  ;Build widgets
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
  DataListNexusBase = WIDGET_BASE(LOAD_DATA_BASE,$
    uname='data_list_nexus_base',$
    xoffset=NexusListSizeGlobal[0],$
    yoffset=NexusListSizeGlobal[1],$
    scr_xsize=NexusListSizeGlobal[2],$
    scr_ysize=NexusListSizeGlobal[3],$
    frame=2,$
    map=0)
    
  DataListNexusLabel = WIDGET_LABEL(DataListNexusBase,$
    xoffset=NexusListSizeGlobal[4],$
    yoffset=NexusListSizeGlobal[5],$
    scr_xsize=NexusListSizeGlobal[6],$
    scr_ysize=NexusListSizeGlobal[7],$
    value=NexusListLabelGlobal[0],$
    frame=1)
    
  DropListvalue = ['                                        ' + $
    '                                ']
  DataListNexusDropList = WIDGET_DROPLIST(DataListNexusBase,$
    uname='data_list_nexus_droplist',$
    xoffset=NexusListSizeGlobal[8],$
    yoffset=NexusListSizeGlobal[9],$
    value=DropListValue,$
    /tracking_events)
    
  DataListNexusNXsummary = WIDGET_TEXT(DataListNexusBase,$
    xoffset=NexusListSizeGlobal[10],$
    yoffset=NexusListSizeGlobal[11],$
    scr_xsize=NexusListSizeGlobal[12],$
    scr_ysize=NexusListSizeGlobal[13],$
    /wrap,$
    /scroll,$
    uname='data_list_nexus_nxsummary_' + $
    'text_field')
    
  DataListNexusLoadButton = WIDGET_BUTTON(DataListNexusBase,$
    uname='data_list_nexus_load_button',$
    xoffset=NexusListSizeGlobal[14],$
    yoffset=NexusListSizeGlobal[15],$
    scr_xsize=NexusListSizeGlobal[16],$
    scr_ysize=NexusListSizeGlobal[17],$
    value=NexusListLabelGlobal[1])
    
  DataListNexusCancelButton = WIDGET_BUTTON(DataListNexusBase,$
    uname='data_list_nexus_' + $
    'cancel_button',$
    xoffset=NexusListSizeGlobal[18],$
    yoffset=NexusListSizeGlobal[19],$
    scr_xsize=NexusListSizeGlobal[20],$
    scr_ysize=NexusListSizeGlobal[21],$
    value=NexusListLabelGlobal[2])
    
    
  ;Build 1D and 2D tabs
  MakeGuiLoadData1D2DTab,$
    LOAD_DATA_BASE,$
    D_DD_TabSize,$
    D_DD_BaseSize,$
    D_DD_TabTitle,$
    GlobalLoadDataGraphs,$
    LoadctList
    
  ;base about X, Y and counts value --------------------------------------------
  info_base = WIDGET_BASE(LOAD_DATA_BASE,$
    XOFFSET   = 920,$
    YOFFSET   = 3,$
    SCR_XSIZE = 260,$
    SCR_YSIZE = 25,$
    UNAME     = 'info_data_base',$
    MAP       = 0,$
    FRAME     = 1)
    
  ;X label/value
  y_off = 5
  x_label = WIDGET_LABEL(info_base,$
    XOFFSET = 0,$
    YOFFSET = y_off,$
    VALUE   = 'X:')
  x_value = WIDGET_LABEL(info_base,$
    XOFFSET   = 15,$
    YOFFSET   = y_off,$
    SCR_XSIZE = 50,$
    VALUE     = 'N/A',$
    UNAME     = 'data_x_info_value',$
    /ALIGN_LEFT)
    
  ;Y label/value
  y_label = WIDGET_LABEL(info_base,$
    XOFFSET = 70,$
    YOFFSET = y_off,$
    VALUE   = 'Y:')
  y_value = WIDGET_LABEL(info_base,$
    XOFFSET   = 85,$
    YOFFSET   = y_off,$
    SCR_XSIZE = 50,$
    VALUE     = 'N/A',$
    UNAME     = 'data_y_info_value',$
    /ALIGN_LEFT)
    
  ;COUNTS label/value
  counts_label = WIDGET_LABEL(info_base,$
    XOFFSET = 140,$
    YOFFSET = y_off,$
    VALUE   = 'COUNTS:')
  counts_value = WIDGET_LABEL(info_base,$
    XOFFSET   = 185,$
    YOFFSET   = y_off,$
    SCR_XSIZE = 50,$
    VALUE     = 'N/A',$
    UNAME     = 'data_counts_info_value',$
    /ALIGN_LEFT)
    
  ;NXsummary and zoom tab
  NxsummaryZoomTab = WIDGET_TAB(LOAD_DATA_BASE,$
    uname='data_nxsummary_zoom_tab',$
    location=0,$
    xoffset=NxsummaryZoomTabSize[0],$
    yoffset=NxsummaryZoomTabSize[1]+25,$
    scr_xsize=NxsummaryZoomTabSize[2],$
    scr_ysize=NxsummaryZoomTabSize[3]-20,$
    /tracking_events)
    
  ;NXsummary tab #1
  data_Nxsummary_base = WIDGET_BASE(NxsummaryZoomTab,$
    uname='data_nxsummary_base',$
    xoffset=0,$
    yoffset=0,$
    scr_xsize=NXsummaryZoomTabSize[2],$
    scr_ysize=NXsummaryZoomTabSize[3],$
    title=NxsummaryZoomTitle[0])
    
  data_file_info_text = WIDGET_TEXT(data_Nxsummary_base,$
    xoffset=FileInfoSize[0],$
    yoffset=FileInfoSize[1],$
    scr_xsize=FileInfoSize[2],$
    scr_ysize=FileInfoSize[3]-20,$
    /wrap,$
    /scroll,$
    value='',$
    uname='data_file_info_text')
    
  ;ZOOM tab #2
  data_Zoom_base = WIDGET_BASE(NxsummaryZoomTab,$
    uname='data_zoom_base',$
    xoffset=0,$
    yoffset=0,$
    scr_xsize=NXsummaryZoomTabSize[2],$
    scr_ysize=NXsummaryZoomTabSize[3],$
    title=NxsummaryZoomTitle[1])
    
  ;zoom base and droplist inside zoom tab (top right corner)
  data_zoom_scale_base = WIDGET_BASE(data_zoom_base,$
    xoffset=ZoomScaleBaseSize[0],$
    yoffset=ZoomScaleBaseSize[1],$
    scr_xsize=ZoomScaleBaseSize[2],$
    scr_ysize=ZoomScaleBaseSize[3],$
    frame=2,$
    uname='data_zoom_scale_base')
    
  data_zoom_scale_cwfield = CW_FIELD(data_zoom_scale_base,$
    Title=ZoomScaleTitle,$
    xsize=2,$
    /integer,$
    ysize=1,$
    return_events=1,$
    uname='data_zoom_scale_cwfield')
    
  data_zoom_draw = WIDGET_DRAW(data_zoom_base,$
    uname='data_zoom_draw',$
    xoffset=0,$
    yoffset=0,$
    scr_xsize=NXsummaryZoomTabSize[2],$
    scr_ysize=NXsummaryZoomTabSize[3])
    
;  ;geometry info --------------------------------------------------------------
;  GeoBase = WIDGET_BASE(LOAD_DATA_BASE,$
;    XOFFSET = 680,$
;    YOFFSET = 425,$
;    SCR_XSIZE = 160,$
;    SCR_YSIZE = 290,$
;    FRAME = 1,$
;    XPAD         = 0,$
;    YPAD         = 0,$
;    UNAME = 'data_geometry_info_base',$
;    /COLUMN)
;    
;  row1 = WIDGET_BASE(GeoBase,$
;  xpad = 0,$
;    /column)
;  label1 = WIDGET_LABEL(row1,$
;    value = 'DANGLE0:')
;  col1 = WIDGET_BASE(row1,$
;  xpad = 0,$
;    /column)
;  row11 = WIDGET_BASE(col1,$
;  xpad = 0,$
;    /row)
;  lab = WIDGET_LABEL(row11,$
;    value = 'Value:')
;  val = WIDGET_LABEL(row11,$
;    value = 'N/A',$
;    scr_xsize = 85,$
;    /align_left,$
;    uname = 'data_geometry_dangle_value')
;  row12 = WIDGET_BASE(col1,$
;  xpad = 0,$
;    /row)
;  lab = WIDGET_LABEL(row12,$
;    value = 'Units:')
;  val = WIDGET_LABEL(row12,$
;    value = 'N/A',$
;    scr_xsize = 105,$
;    /align_left,$
;    uname = 'data_geometry_dangle_units')
;    
;  row2 = WIDGET_BASE(GeoBase,$
;  xpad = 0,$
;    /column)
;  label1 = WIDGET_LABEL(row2,$
;    value = 'DIRPIX:')
;  col2 = WIDGET_BASE(row2,$
;  xpad = 0,$
;    /column)
;  row21 = WIDGET_BASE(col2,$
;  xpad = 0,$
;    /row)
;  lab = WIDGET_LABEL(row21,$
;    value = 'Value :')
;  val = WIDGET_LABEL(row21,$
;    value = 'N/A',$
;    scr_xsize = 85,$
;    /align_left,$
;    uname = 'data_geometry_dirpix_value')
;  row31 = WIDGET_BASE(col2,$
;  xpad = 0,$
;    /row)
;  lab = WIDGET_LABEL(row31,$
;    value = 'Val. (user):')
;  val = WIDGET_TEXT(row31,$
;    value = 'N/A',$
;    scr_xsize = 80,$
;    /align_right,$
;    /EDITABLE,$
;    uname = 'data_geometry_dirpix_value_user')
;    
;  row22 = WIDGET_BASE(col2,$
;  xpad = 0,$
;    /row)
;  lab = WIDGET_LABEL(row22,$
;    value = 'Units:')
;  val = WIDGET_LABEL(row22,$
;    value = 'N/A',$
;    scr_xsize = 95,$
;    /align_left,$
;    uname = 'data_geometry_dirpix_units')
;    
;  row3 = WIDGET_BASE(GeoBase,$
;  xpad = 0,$
;    /column)
;  label1 = WIDGET_LABEL(row3,$
;    value = 'REFPIX:')
;  col3 = WIDGET_BASE(row3,$
;  xpad = 0,$
;    /column)
;  row31 = WIDGET_BASE(col3,$
;  xpad = 0,$
;    /row)
;  lab = WIDGET_LABEL(row31,$
;    value = 'Value:')
;  val = WIDGET_LABEL(row31,$
;    value = 'N/A',$
;    scr_xsize = 85,$
;    /align_left,$
;    uname = 'data_geometry_refpix_value')
;  row32 = WIDGET_BASE(col3,$
;      xpad = 0,$
;    /row)
;  lab = WIDGET_LABEL(row32,$
;    value = 'Units:')
;  val = WIDGET_LABEL(row32,$
;    value = 'N/A',$
;    scr_xsize = 85,$
;    /align_left,$
;    uname = 'data_geometry_refpix_units')
;    
;  ;----------------------------------------------------------------------------
    
  ;Help base and text field that will show what is going on in the
  ;drawing region
  LeftInteractionHelpMessageBase = WIDGET_BASE(LOAD_DATA_BASE,$
    uname='left_interaction_' + $
    'help_message_base',$
    xoffset= 680,$
    ;LeftInteractionHelpsize[0],$
    yoffset= $
    LeftInteractionHelpsize[1],$
    scr_xsize= 500,$
    ;LeftInteractionHelpsize[2],$
    scr_ysize= $
    LeftInteractionHelpsize[3],$
    frame=1)
    
  LeftInteractionHelpMessageLabel = WIDGET_LABEL($
    LeftInteractionHelpMessageBase,$
    uname= $
    'left_data_interaction_' + $
    'help_message_help',$
    xoffset= $
    LeftInteractionHelpSize[4],$
    yoffset= $
    LeftInteractionHelpSize[5],$
    scr_xsize= $
    LeftInteractionHelpSize[8],$
    value= $
    LeftInteractionHelpMessageLabelTitle)
    
  LeftInteractionHelpTextField = WIDGET_TEXT(LeftInteractionHelpMessageBase,$
    xoffset=LeftInteractionHelpSize[6],$
    yoffset=LeftInteractionHelpSize[7],$
    scr_xsize= 490,$
    ;                                           LeftInteractionHelpSize[8],$
    scr_ysize= $
    LeftInteractionHelpSize[9],$
    uname= $
    'DATA_left_interaction_help_text',$
    /wrap,$
    /scroll)
    
  ;Text field box to get info about current process
  data_log_book_text_field = WIDGET_TEXT(LOAD_DATA_BASE,$
    uname='data_log_book_text_field',$
    xoffset=FileInfoSize[4],$
    yoffset=FileInfoSize[5],$
    scr_xsize=FileInfoSize[6],$
    scr_ysize=FileInfoSize[7],$
    /scroll,$
    /wrap)
    
    
END