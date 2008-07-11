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

PRO make_gui_reduce_tab1, REDUCE_TAB, tab_size, tab_title, global

;- Define Main Base of Reduce Tab 1 -------------------------------------------
sBaseTab1 = { size:  tab_size,$
              uname: 'reduce_tab1_base',$
              title: tab_title}

;- Data File Frame ------------------------------------------------------------
sDataFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                  main_base_uname: 'data_base_uname',$
                  xoff:            0,$
                  yoff:            0,$
                  frame_title:     'Data File',$
                  label_1:         'Run Number:',$
                  tf1_uname:       'data_run_number_cw_field',$
                  browse_uname:    'data_browse_button',$
                  file_name_uname: 'data_file_name_text_field'}

;- ROI file -------------------------------------------------------------------
XYoff = [0,70]
sROIfileButton = { size:  [XYoff[0], $
                           XYoff[1], $
                           150, $
                           35],$
                   value: 'Select ROI file ... ',$
                   uname: 'roi_browse_button'}
XYoff = [0,0]
sROIfileTextField = { size:  [sROIfileButton.size[0]+ $
                              sROIfileButton.size[2]+ $
                              XYoff[0],$
                              sROIfileButton.size[1]+XYoff[1],$
                              535, $
                              35],$
                      uname: 'roi_file_name_text_field'}

yoff = 37
;- Transmission Background -----------------------------------------------------
sTransmBackFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                     main_base_uname: 'transm_back_base_uname',$
                     xoff:            0,$
                     yoff:            sROIfileTextField.size[1]+yoff,$
                     frame_title:     (*global).CorrectPara.transm_back.title,$
                     label_1:         'Run Number:',$
                     tf1_uname:       'transm_back_run_number_cw_field',$
                     browse_uname:    'transm_back_browse_button',$
                     file_name_uname: 'transm_back_file_name_text_field'}

;==============================================================================
;= Build Widgets ==============================================================
BaseTab1 = WIDGET_BASE(REDUCE_TAB,$
                       UNAME     = sBaseTab1.uname,$
                       XOFFSET   = sBaseTab1.size[0],$
                       YOFFSET   = sBaseTab1.size[1],$
                       SCR_XSIZE = sBaseTab1.size[2],$
                       SCR_YSIZE = sBaseTab1.size[3],$
                       TITLE     = sBaseTab1.title)

;- Data File Frame ------------------------------------------------------------
cDataFileFrame = OBJ_NEW('IDLnexusFrame',$
                         MAIN_BASE_ID    = BaseTab1,$
                         MAIN_BASE_XSIZE = sDataFileFrame.main_base_xsize,$
                         MAIN_BASE_UNAME = sDataFileFrame.main_base_uname,$
                         XOFF            = sDataFileFrame.xoff,$
                         YOFF            = sDataFileFrame.yoff,$
                         FRAME_TITLE     = sDataFileFrame.frame_title,$
                         LABEL_1         = sDataFileFrame.label_1,$
                         CWFIELD_UNAME   = sDataFileFrame.tf1_uname,$
                         BROWSE_UNAME    = sDataFileFrame.browse_uname,$
                         FILE_NAME_UNAME = sDataFileFrame.file_name_uname)

;- ROI file -------------------------------------------------------------------
wROIfileButton = WIDGET_BUTTON(BaseTab1,$
                               XOFFSET   = sROIfileButton.size[0],$
                               YOFFSET   = sROIfileButton.size[1],$
                               SCR_XSIZE = sROIfileButton.size[2],$
                               SCR_YSIZE = sROIfileButton.size[3],$
                               UNAME     = sROIfileButton.uname,$
                               VALUE     = sROIfileButton.value)
wROIfileTextField = WIDGET_TEXT(BaseTab1,$
                                XOFFSET   = sROIfileTextField.size[0],$
                                YOFFSET   = sROIfileTextField.size[1],$
                                SCR_XSIZE = sROIfileTextField.size[2],$
                                SCR_YSIZE = sROIfileTextField.size[3],$
                                UNAME     = sROIfileTextField.uname,$
                                VALUE     = '',$
                                /EDITABLE,$
                                /ALL_EVENTS)

;- Solvant Buffer Only --------------------------------------------------------
cTransmBackFileFrame = $
  OBJ_NEW('IDLnexusFrame',$
          MAIN_BASE_ID    = BaseTab1,$
          MAIN_BASE_XSIZE = sTransmBackFileFrame.main_base_xsize,$
          MAIN_BASE_UNAME = sTransmBackFileFrame.main_base_uname,$
          XOFF            = sTransmBackFileFrame.xoff,$
          YOFF            = sTransmBackFileFrame.yoff,$
          FRAME_TITLE     = sTransmBackFileFrame.frame_title,$
          LABEL_1         = sTransmBackFileFrame.label_1,$
          CWFIELD_UNAME   = sTransmBackFileFrame.tf1_uname,$
          BROWSE_UNAME    = sTransmBackFileFrame.browse_uname,$
          FILE_NAME_UNAME = sTransmBackFileFrame.file_name_uname)
END
