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
                              845, $
                              35],$
                      uname: 'roi_file_name_text_field'}

yoff = 37
;- Transmission Background ----------------------------------------------------
sTransmBackFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                     main_base_uname: 'transm_back_base_uname',$
                     xoff:            0,$
                     yoff:            sROIfileTextField.size[1]+yoff,$
                     frame_title:     (*global).CorrectPara.transm_back.title,$
                     label_1:         'Run Number:',$
                     tf1_uname:       'transm_back_run_number_cw_field',$
                     browse_uname:    'transm_back_browse_button',$
                     file_name_uname: 'transm_back_file_name_text_field'}

;- Output Folder --------------------------------------------------------------
XYoff = [10,80]
sOutputFolderlabel = { size: [XYoff[0],$
                              sTransmBackFileFrame.yoff+XYoff[1]],$
                       value: 'Output Folder:'}
XYoff = [120,-5]                       
sOutputFolder = { size: [XYoff[0],$
                         sOutputFolderLabel.size[1]+XYoff[1],$
                         875],$
                  value: '~/',$
                  uname: 'output_folder'}

;- Output File Name ----------------------------------------------------------
XYoff = [10,30]
sOutputFileLabel = { size: [XYoff[0],$
                            sOutputFolderLabel.size[1]+XYoff[1]],$
                     value: 'Output File Name:'}
XYoff = [120,-5]
sOutputFile = { size: [XYoff[0],$
                       sOutputFileLabel.size[1]+XYoff[1],$
                       535],$
                value: '',$
                uname: 'output_file_name'}

;- Clear File Name
XYoff = [0,0]
sClear = { size: [sOutputFile.size[0]+sOutputFile.size[2]+XYoff[0],$
                  sOutputFile.size[1]+XYoff[1],$
                  30,30],$
           value: 'X',$
           uname: 'clear_output_file_name_button'}

;- Reset File Name
XYoff = [0,0]
sReset = { size: [sClear.size[0]+sClear.size[2]+XYoff[0],$
                  sClear.size[1]+XYoff[1],$
                  100,$
                  sClear.size[3]],$
           value: 'RESET FILE NAME',$
           uname: 'reset_output_file_name_button'}

;- Auto/user file name
XYoff = [10,-3]
sAUgroup = { size: [sReset.size[0]+sReset.size[2]+XYoff[0],$
                    sReset.size[1]+XYoff[1]],$
             list: ['Auto','User'],$
             uname: 'auto_user_file_name_group',$
             value: 0.0,$
             title: 'File Name Mode:'}

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

;- Transmission Bakcground  ---------------------------------------------------
cTransmBackFileFrame = $
  OBJ_NEW('IDLNexusFrame',$
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

;- Output Folder --------------------------------------------------------------
wOutputFolderLabel = WIDGET_LABEL(BaseTab1,$
                                  XOFFSET   = sOutputFolderLabel.size[0],$
                                  YOFFSET   = sOutputFolderLabel.size[1],$
                                  VALUE     = sOutputFolderLabel.value)

wOutputFolder = WIDGET_BUTTON(BaseTab1,$
                              XOFFSET   = sOutputFolder.size[0],$
                              YOFFSET   = sOutputFolder.size[1],$
                              SCR_XSIZE = sOutputFolder.size[2],$
                              VALUE     = sOutputFolder.value,$
                              UNAME     = sOutputFolder.uname)

;- Output File ----------------------------------------------------------------
wOutputFileLabel = WIDGET_LABEL(BaseTab1,$
                                  XOFFSET   = sOutputFileLabel.size[0],$
                                  YOFFSET   = sOutputFileLabel.size[1],$
                                  VALUE     = sOutputFileLabel.value)


wOutputFile = WIDGET_TEXT(BaseTab1,$
                          XOFFSET = sOutputFile.size[0],$
                          YOFFSET = sOutputFile.size[1],$
                          SCR_XSIZE = sOutputFile.size[2],$
                          VALUE     = sOutputFile.value,$
                          UNAME     = sOutputFile.uname,$
                          /EDITABLE,$
                          /ALL_EVENTS,$
                          /ALIGN_LEFT)

wClear = WIDGET_BUTTON(BaseTab1,$
                       XOFFSET   = sClear.size[0],$
                       YOFFSET   = sClear.size[1],$
                       SCR_XSIZE = sClear.size[2],$
                       SCR_YSIZE = sClear.size[3],$
                       VALUE     = sClear.value,$
                       UNAME     = sClear.uname)

wReset = WIDGET_BUTTON(BaseTab1,$
                       XOFFSET   = sReset.size[0],$
                       YOFFSET   = sReset.size[1],$
                       SCR_XSIZE = sReset.size[2],$
                       SCR_YSIZE = sReset.size[3],$
                       VALUE     = sReset.value,$
                       UNAME     = sReset.uname)

group = CW_BGROUP(BaseTab1,$
                  sAUgroup.list,$
                  XOFFSET    = sAUgroup.size[0],$
                  YOFFSET    = sAUgroup.size[1],$
                  LABEL_LEFT = sAUgroup.title,$
                  ROW        = 1,$
                  SET_VALUE  = sAUgroup.value,$
                  UNAME      = sAUgroup.uname,$
                  /NO_RELEASE,$
                  /EXCLUSIVE)

END
