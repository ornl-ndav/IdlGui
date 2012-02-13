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

PRO miniMakeGuiLoadNormalizationTab, DataNormalizationTab,$
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

;##############################################################################
;###############################Build widgets##################################
;##############################################################################

LOAD_NORMALIZATION_BASE = WIDGET_BASE(DataNormalizationTab,$
                                      UNAME     = 'load_normalization_base',$
                                      TITLE     = NormalizationTitle,$
                                      XOFFSET   = LoadNormalizationTabSize[0],$
                                      YOFFSET   = LoadNormalizationTabSize[1],$
                                      SCR_XSIZE = LoadNormalizationTabSize[2],$
                                      SCR_YSIZE = LoadNormalizationTabSize[3])

;******************* loading nexus interface **********************************
NexusInterface, BASE_UNAME = LOAD_NORMALIZATION_BASE,$
                BROWSE_BUTTON_UNAME = 'browse_norm_nexus_button',$
                RUN_NBR_UNAME       = 'load_normalization_run_number_text_field',$
                ARCHIVED_ALL_UNAME  = 'normalization_archived_or_full_cwbgroup',$
                PROPOSAL_BUTTON_UNAME = 'with_norm_proposal_button',$
                PROPOSAL_FOLDER_DROPLIST_UNAME = $
                'norm_proposal_folder_droplist',$
                PROPOSAL_BASE_UNAME = 'normalization_proposal_base_uname',$
                SAVE_AS_JPEG_UNAME = 'save_as_jpeg_button_normalization',$
                PLOT_BUTTON_UNAME = 'advanced_plot_button_normalization'

;------------------------------------------------------------------------------

;Nexus list base/label/droplist and buttons
NormListNexusBase = $
  WIDGET_BASE(LOAD_normalization_Base,$
              UNAME     = 'norm_list_nexus_base',$
              XOFFSET   = NexusListSizeGlobal[0],$
              YOFFSET   = NexusListSizeGlobal[1],$
              SCR_XSIZE = NexusListSizeGlobal[2],$
              SCR_YSIZE = NexusListSizeGlobal[3],$
              FRAME     = 2,$
              MAP       = 0)

NormListNexusLabel = $
  WIDGET_LABEL(NormListNexusBase,$
               XOFFSET   = NexusListSizeGlobal[4],$
               YOFFSET   = NexusListSizeGlobal[5],$
               SCR_XSIZE = NexusListSizeGlobal[6],$
               SCR_YSIZE = NexusListSizeGlobal[7],$
               VALUE     = NexusListLabelGlobal[0],$
               FRAME     = 1)

DropListvalue = ['                                                                        ']
NormListDropList = $
  widget_droplist(NormListNexusBase,$
                  UNAME   = 'normalization_list_nexus_droplist',$
                  XOFFSET = NexusListSizeGlobal[8],$
                  YOFFSET = NexusListSizeGlobal[9],$
                  VALUE   = DropListValue,$
                  /TRACKING_EVENTS)
                                   
NormListNexusNXsummary = $
  WIDGET_TEXT(NormListNexusBase,$
              XOFFSET   = NexusListSizeGlobal[10],$
              YOFFSET   = NexusListSizeGlobal[11],$
              SCR_XSIZE = NexusListSizeGlobal[12],$
              SCR_YSIZE = NexusListSizeGlobal[13],$
              /WRAP,$
              /SCROLL,$
              UNAME     = 'normalization_list_nexus_nxsummary_text_field')
  
NormListNexusLoadButton = $
  WIDGET_BUTTON(NormListNexusBase,$
                UNAME     = 'norm_list_nexus_load_button',$
                XOFFSET   = NexusListSizeGlobal[14],$
                YOFFSET   = NexusListSizeGlobal[15],$
                SCR_XSIZE = NexusListSizeGlobal[16],$
                SCR_YSIZE = NexusListSizeGlobal[17],$
                VALUE     = NexusListLabelGlobal[1])
                                        
NormListNexusCancelButton = $
  WIDGET_BUTTON(NormListNexusBase,$
                UNAME     = 'norm_list_nexus_cancel_button',$
                XOFFSET   = NexusListSizeGlobal[18],$
                YOFFSET   = NexusListSizeGlobal[19],$
                SCR_XSIZE = NexusListSizeGlobal[20],$
                SCR_YSIZE = NexusListSizeGlobal[21],$
                VALUE     = NexusListLabelGlobal[2])


;Build 1D and 2D tabs
miniMakeGuiLoadNormalization1D2DTab,$
  LOAD_NORMALIZATION_BASE,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalLoadDataGraphs,$
  loadctList

 ;TOF selection tool
  tof_button = widget_button(load_normalization_base,$
    value = '  T O F   selection  tool    ',$
    xoffset = 563,$
    yoffset = 37,$
    uname = 'norm_tof_selection_tool_button')    

;;base about X, Y and counts value --------------------------------------------
;info_base = WIDGET_BASE(LOAD_NORMALIZATION_BASE,$
;                        XOFFSET   = 510,$
;                        YOFFSET   = 35,$
;                        SCR_XSIZE = 275,$
;                        SCR_YSIZE = 20,$
;                        UNAME     = 'info_norm_base',$
;                        MAP       = 0,$
;                        FRAME     = 1)
;
;;X label/value
;y_off = 0
;x_label = WIDGET_LABEL(info_base,$
;                       XOFFSET = 0,$
;                       YOFFSET = y_off,$
;                       VALUE   = 'X:')
;x_value = WIDGET_LABEL(info_base,$
;                       XOFFSET   = 15,$
;                       YOFFSET   = y_off,$
;                       SCR_XSIZE = 50,$
;                       VALUE     = 'N/A',$
;                       UNAME     = 'norm_x_info_value',$
;                       /ALIGN_LEFT)
;                       
;;Y label/value
;y_label = WIDGET_LABEL(info_base,$
;                       XOFFSET = 70,$
;                       YOFFSET = y_off,$
;                       VALUE   = 'Y:')
;y_value = WIDGET_LABEL(info_base,$
;                       XOFFSET   = 85,$
;                       YOFFSET   = y_off,$
;                       SCR_XSIZE = 50,$
;                       VALUE     = 'N/A',$
;                       UNAME     = 'norm_y_info_value',$
;                       /ALIGN_LEFT)
;                       
;;COUNTS label/value
;counts_label = WIDGET_LABEL(info_base,$
;                            XOFFSET = 140,$
;                            YOFFSET = y_off,$
;                            VALUE   = 'COUNTS:')
;counts_value = WIDGET_LABEL(info_base,$
;                            XOFFSET   = 185,$
;                            YOFFSET   = y_off,$
;                            SCR_XSIZE = 50,$
;                            VALUE     = 'N/A',$
;                            UNAME     = 'norm_counts_info_value',$
;                            /ALIGN_LEFT)

;------------------------------------------------------------------------------

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
