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

PRO make_gui_reduce_tab1, REDUCE_TAB, tab_size, tab_title

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

yoff = 35
;- Solvant Buffer Only --------------------------------------------------------
sSolvantFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                     main_base_uname: 'solvant_base_uname',$
                     xoff:            0,$
                     yoff:            sROIfileTextField.size[1]+yoff,$
                     frame_title:     'Solvant Buffer Only',$
                     label_1:         'Run Number:',$
                     tf1_uname:       'solvant_run_number_cw_field',$
                     browse_uname:    'solvant_browse_button',$
                     file_name_uname: 'solvant_file_name_text_field'}

yoff = 65
;- Empty Can ------------------------------------------------------------------
sEmptyFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                   main_base_uname: 'empty_base_uname',$
                   xoff:            0,$
                   yoff:            sSolvantFileFrame.yoff+yoff,$
                   frame_title:     'Empty Can',$
                   label_1:         'Run Number:',$
                   tf1_uname:       'empty_run_number_cw_field',$
                   browse_uname:    'empty_browse_button',$
                   file_name_uname: 'empty_file_name_text_field'}

;- Open beam ------------------------------------------------------------------
sOpenFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                  main_base_uname: 'open_beam_base_uname',$
                  xoff:            0,$
                  yoff:            sEmptyFileFrame.yoff+yoff,$
                  frame_title:     'Open Beam (shutter open)',$
                  label_1:         'Run Number:',$
                  tf1_uname:       'open_run_number_cw_field',$
                  browse_uname:    'open_browse_button',$
                  file_name_uname: 'open_file_name_text_field'}

;- Dark Current ---------------------------------------------------------------
sDarkFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                  main_base_uname: 'dark_beam_base_uname',$
                  xoff:            0,$
                  yoff:            sOpenFileFrame.yoff+yoff,$
                  frame_title:     'Dark Current (shutter closed)',$
                  label_1:         'Run Number:',$
                  tf1_uname:       'dark_run_number_cw_field',$
                  browse_uname:    'dark_browse_button',$
                  file_name_uname: 'dark_file_name_text_field'}

;- Sample Data transmission File ----------------------------------------------
sSampleDataFileFrame = $
  {main_base_xsize: sBaseTab1.size[2],$
   main_base_uname: 'sample_data_transmission_base_uname',$
   xoff:            0,$
   yoff:            sDarkFileFrame.yoff+yoff,$
   frame_title:     'Sample Data Transmission',$
   label_1:         'Run Number:',$
   tf1_uname:       'sample_data_transmission_run_number_cw_field',$
   browse_uname:    'sample_data_transmission_browse_button',$
   file_name_uname: 'sample_data_transmission_file_name_text_field'}

;- Solvent Transmission -----------------------------------------------------
sSolventTransmissionFileFrame = $
  {main_base_xsize: sBaseTab1.size[2],$
   main_base_uname: 'solvent_transmission_base_uname',$
   xoff:            0,$
   yoff:            sSampleDataFileFrame.yoff+yoff,$
   frame_title:     'Solvent Transmission',$
   label_1:         'Run Number:',$
   tf1_uname:       'solvent_transmission_run_number_cw_field',$
   browse_uname:    'solvent_transmission_browse_button',$
   file_name_uname: 'solvent_transmission_file_name_text_field'}

;- Empty Can Transmission -----------------------------------------------------
sEmptyCanTransmissionFileFrame = $
  {main_base_xsize: sBaseTab1.size[2],$
   main_base_uname: 'empty_can_transmission_base_uname',$
   xoff:            0,$
   yoff:            sSolventTransmissionFileFrame.yoff+yoff,$
   frame_title:     'Empty Can Transmission',$
   label_1:         'Run Number:',$
   tf1_uname:       'empty_can_transmission_run_number_cw_field',$
   browse_uname:    'empty_can_transmission_browse_button',$
   file_name_uname: 'empty_can_transmission_file_name_text_field'}


;- Output Folder --------------------------------------------------------------
XYoff = [10,80]
sOutputFolderlabel = { size: [XYoff[0],$
                              sEmptyCanTransmissionFileFrame.yoff+XYoff[1]],$
                       value: 'Output Folder:'}
XYoff = [120,-8]                       
sOutputFolder = { size: [XYoff[0],$
                         sOutputFolderLabel.size[1]+XYoff[1],$
                         880,30],$
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
BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab1.uname,$
                      XOFFSET   = sBaseTab1.size[0],$
                      YOFFSET   = sBaseTab1.size[1],$
                      SCR_XSIZE = sBaseTab1.size[2],$
                      SCR_YSIZE = sBaseTab1.size[3],$
                      TITLE     = sBaseTab1.title)

;- Data File Frame ------------------------------------------------------------
cDataFileFrame = OBJ_NEW('IDLnexusFrame',$
                         MAIN_BASE_ID    = BaseTab,$
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
wROIfileButton = WIDGET_BUTTON(BaseTab,$
                               XOFFSET   = sROIfileButton.size[0],$
                               YOFFSET   = sROIfileButton.size[1],$
                               SCR_XSIZE = sROIfileButton.size[2],$
                               SCR_YSIZE = sROIfileButton.size[3],$
                               UNAME     = sROIfileButton.uname,$
                               VALUE     = sROIfileButton.value)
wROIfileTextField = WIDGET_TEXT(BaseTab,$
                                XOFFSET   = sROIfileTextField.size[0],$
                                YOFFSET   = sROIfileTextField.size[1],$
                                SCR_XSIZE = sROIfileTextField.size[2],$
                                SCR_YSIZE = sROIfileTextField.size[3],$
                                UNAME     = sROIfileTextField.uname,$
                                VALUE     = '',$
                                /EDITABLE,$
                                /ALL_EVENTS)

;- Solvant Buffer Only --------------------------------------------------------
cSolvantFileFrame = $
  OBJ_NEW('IDLnexusFrame',$
          MAIN_BASE_ID    = BaseTab,$
          MAIN_BASE_XSIZE = sSolvantFileFrame.main_base_xsize,$
          MAIN_BASE_UNAME = sSolvantFileFrame.main_base_uname,$
          XOFF            = sSolvantFileFrame.xoff,$
          YOFF            = sSolvantFileFrame.yoff,$
          FRAME_TITLE     = sSolvantFileFrame.frame_title,$
          LABEL_1         = sSolvantFileFrame.label_1,$
          CWFIELD_UNAME   = sSolvantFileFrame.tf1_uname,$
          BROWSE_UNAME    = sSolvantFileFrame.browse_uname,$
          FILE_NAME_UNAME = sSolvantFileFrame.file_name_uname)

;- Empty Can ------------------------------------------------------------------
cEmptyFileFrame = OBJ_NEW('IDLnexusFrame',$
                          MAIN_BASE_ID    = BaseTab,$
                          MAIN_BASE_XSIZE = sEmptyFileFrame.main_base_xsize,$
                          MAIN_BASE_UNAME = sEmptyFileFrame.main_base_uname,$
                          XOFF            = sEmptyFileFrame.xoff,$
                          YOFF            = sEmptyFileFrame.yoff,$
                          FRAME_TITLE     = sEmptyFileFrame.frame_title,$
                          LABEL_1         = sEmptyFileFrame.label_1,$
                          CWFIELD_UNAME   = sEmptyFileFrame.tf1_uname,$
                          BROWSE_UNAME    = sEmptyFileFrame.browse_uname,$
                          FILE_NAME_UNAME = sEmptyFileFrame.file_name_uname)

;- Open beam ------------------------------------------------------------------
cOpenFileFrame = OBJ_NEW('IDLnexusFrame',$
                         MAIN_BASE_ID    = BaseTab,$
                         MAIN_BASE_XSIZE = sOpenFileFrame.main_base_xsize,$
                         MAIN_BASE_UNAME = sOpenFileFrame.main_base_uname,$
                         XOFF            = sOpenFileFrame.xoff,$
                         YOFF            = sOpenFileFrame.yoff,$
                         FRAME_TITLE     = sOpenFileFrame.frame_title,$
                         LABEL_1         = sOpenFileFrame.label_1,$
                         CWFIELD_UNAME   = sOpenFileFrame.tf1_uname,$
                         BROWSE_UNAME    = sOpenFileFrame.browse_uname,$
                         FILE_NAME_UNAME = sOpenFileFrame.file_name_uname)

;- Dark Current ---------------------------------------------------------------
cDarkFileFrame = OBJ_NEW('IDLnexusFrame',$
                         MAIN_BASE_ID    = BaseTab,$
                         MAIN_BASE_XSIZE = sDarkFileFrame.main_base_xsize,$
                         MAIN_BASE_UNAME = sDarkFileFrame.main_base_uname,$
                         XOFF            = sDarkFileFrame.xoff,$
                         YOFF            = sDarkFileFrame.yoff,$
                         FRAME_TITLE     = sDarkFileFrame.frame_title,$
                         LABEL_1         = sDarkFileFrame.label_1,$
                         CWFIELD_UNAME   = sDarkFileFrame.tf1_uname,$
                         BROWSE_UNAME    = sDarkFileFrame.browse_uname,$
                         FILE_NAME_UNAME = sDarkFileFrame.file_name_uname)

;- Sample Data transmission File ----------------------------------------------
cSampleDataFileFrame = $
  OBJ_NEW('IDLtxtFrame',$
          MAIN_BASE_ID    = BaseTab,$
          MAIN_BASE_XSIZE = sSampleDataFileFrame.main_base_xsize,$
          MAIN_BASE_UNAME = sSampleDataFileFrame.main_base_uname,$
          XOFF            = sSampleDataFileFrame.xoff,$
          YOFF            = sSampleDataFileFrame.yoff,$
          FRAME_TITLE     = sSampleDataFileFrame.frame_title,$
          LABEL_1         = sSampleDataFileFrame.label_1,$
          BROWSE_UNAME    = sSampleDataFileFrame.browse_uname,$
          FILE_NAME_UNAME = sSampleDataFileFrame.file_name_uname)

;- Empty Can Transmission -----------------------------------------------------
cEmptyCanTransmissionFileFrame = $
  OBJ_NEW('IDLtxtFrame',$
          MAIN_BASE_ID    = BaseTab,$
          MAIN_BASE_XSIZE = sEmptyCanTransmissionFileFrame.main_base_xsize,$
          MAIN_BASE_UNAME = sEmptyCanTransmissionFileFrame.main_base_uname,$
          XOFF            = sEmptyCanTransmissionFileFrame.xoff,$
          YOFF            = sEmptyCanTransmissionFileFrame.yoff,$
          FRAME_TITLE     = sEmptyCanTransmissionFileFrame.frame_title,$
          LABEL_1         = sEmptyCanTransmissionFileFrame.label_1,$
          BROWSE_UNAME    = sEmptyCanTransmissionFileFrame.browse_uname,$
          FILE_NAME_UNAME = sEmptyCanTransmissionFileFrame.file_name_uname)

;- Solvent Transmission -----------------------------------------------------
cSolventTransmissionFileFrame = $
  OBJ_NEW('IDLtxtFrame',$
          MAIN_BASE_ID    = BaseTab,$
          MAIN_BASE_XSIZE = sSolventTransmissionFileFrame.main_base_xsize,$
          MAIN_BASE_UNAME = sSolventTransmissionFileFrame.main_base_uname,$
          XOFF            = sSolventTransmissionFileFrame.xoff,$
          YOFF            = sSolventTransmissionFileFrame.yoff,$
          FRAME_TITLE     = sSolventTransmissionFileFrame.frame_title,$
          LABEL_1         = sSolventTransmissionFileFrame.label_1,$
          BROWSE_UNAME    = sSolventTransmissionFileFrame.browse_uname,$
          FILE_NAME_UNAME = sSolventTransmissionFileFrame.file_name_uname)

;- Output Folder -------------------------------------------------------------
wOutputFolderLabel = WIDGET_LABEL(BaseTab,$
                                  XOFFSET = sOutputFolderLabel.size[0],$
                                  YOFFSET = sOutputFolderLabel.size[1],$
                                  VALUE   = sOutputFolderLabel.value)

wOutputFolder = WIDGET_BUTTON(BaseTab,$
                              XOFFSET   = sOutputFolder.size[0],$
                              YOFFSET   = sOutputFolder.size[1],$
                              SCR_XSIZE = sOutputFolder.size[2],$
                              SCR_YSIZE = sOutputFolder.size[3],$
                              VALUE     = sOutputFolder.value,$
                              UNAME     = sOutputFolder.uname)

;- Output File --------------------------------------------------------------
wOutputFileLabel = WIDGET_LABEL(BaseTab,$
                                  XOFFSET = sOutputFileLabel.size[0],$
                                  YOFFSET = sOutputFileLabel.size[1],$
                                  VALUE   = sOutputFileLabel.value)


wOutputFile = WIDGET_TEXT(BaseTab,$
                          XOFFSET   = sOutputFile.size[0],$
                          YOFFSET   = sOutputFile.size[1],$
                          SCR_XSIZE = sOutputFile.size[2],$
                          VALUE     = sOutputFile.value,$
                          UNAME     = sOutputFile.uname,$
                          /EDITABLE,$
                          /ALL_EVENTS,$
                          /ALIGN_LEFT)

wClear = WIDGET_BUTTON(BaseTab,$
                       XOFFSET   = sClear.size[0],$
                       YOFFSET   = sClear.size[1],$
                       SCR_XSIZE = sClear.size[2],$
                       SCR_YSIZE = sClear.size[3],$
                       VALUE     = sClear.value,$
                       UNAME     = sClear.uname)

wReset = WIDGET_BUTTON(BaseTab,$
                       XOFFSET   = sReset.size[0],$
                       YOFFSET   = sReset.size[1],$
                       SCR_XSIZE = sReset.size[2],$
                       SCR_YSIZE = sReset.size[3],$
                       VALUE     = sReset.value,$
                       UNAME     = sReset.uname)

group = CW_BGROUP(BaseTab,$
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
