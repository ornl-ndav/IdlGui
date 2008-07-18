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

PRO make_gui_reduce_tab2, REDUCE_TAB, tab_size, tab_title

;- Define Main Base of Reduce Tab 1 -------------------------------------------
sBaseTab = { size:  tab_size,$
             uname: 'reduce_tab2_base',$
             title: tab_title}

;- Sample Data transmission File ----------------------------------------------
sSampleDataFileFrame = $
  {main_base_xsize: sBaseTab.size[2],$
   main_base_uname: 'sample_data_transmission_base_uname',$
   xoff:            0,$
   yoff:            0,$
   frame_title:     'Sample Data Transmission',$
   label_1:         'Run Number:',$
   tf1_uname:       'sample_data_transmission_run_number_cw_field',$
   browse_uname:    'sample_data_transmission_browse_button',$
   file_name_uname: 'sample_data_transmission_file_name_text_field'}

yoff = 60
;- Empty Can Transmission -----------------------------------------------------
sEmptyCanTransmissionFileFrame = $
  {main_base_xsize: sBaseTab.size[2],$
   main_base_uname: 'empty_can_transmission_base_uname',$
   xoff:            0,$
   yoff:            sSampleDataFileFrame.yoff+yoff,$
   frame_title:     'Empty Can Transmission',$
   label_1:         'Run Number:',$
   tf1_uname:       'empty_can_transmission_run_number_cw_field',$
   browse_uname:    'empty_can_transmission_browse_button',$
   file_name_uname: 'empty_can_transmission_file_name_text_field'}

;- Output Folder --------------------------------------------------------------
XYoff = [10,100]
sOutputFolderlabel = { size: [XYoff[0],$
                              sEmptyCanTransmissionFileFrame.yoff+XYoff[1]],$
                       value: 'Output Folder:'}
XYoff = [120,-5]                       
sOutputFolder = { size: [XYoff[0],$
                         sOutputFolderLabel.size[1]+XYoff[1],$
                         560],$
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
                       430],$
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

;==============================================================================
;= Build Widgets ==============================================================
BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab.uname,$
                      XOFFSET   = sBaseTab.size[0],$
                      YOFFSET   = sBaseTab.size[1],$
                      SCR_XSIZE = sBaseTab.size[2],$
                      SCR_YSIZE = sBaseTab.size[3],$
                      TITLE     = sBaseTab.title)

;- Sample Data transmission File ----------------------------------------------
cSampleDataFileFrame = $
  OBJ_NEW('IDLnexusFrame',$
          MAIN_BASE_ID    = BaseTab,$
          MAIN_BASE_XSIZE = sSampleDataFileFrame.main_base_xsize,$
          MAIN_BASE_UNAME = sSampleDataFileFrame.main_base_uname,$
          XOFF            = sSampleDataFileFrame.xoff,$
          YOFF            = sSampleDataFileFrame.yoff,$
          FRAME_TITLE     = sSampleDataFileFrame.frame_title,$
          LABEL_1         = sSampleDataFileFrame.label_1,$
          CWFIELD_UNAME   = sSampleDataFileFrame.tf1_uname,$
          BROWSE_UNAME    = sSampleDataFileFrame.browse_uname,$
          FILE_NAME_UNAME = sSampleDataFileFrame.file_name_uname)

;- Empty Can Transmission -----------------------------------------------------
cEmptyCanTransmissionFileFrame = $
  OBJ_NEW('IDLnexusFrame',$
          MAIN_BASE_ID    = BaseTab,$
          MAIN_BASE_XSIZE = sEmptyCanTransmissionFileFrame.main_base_xsize,$
          MAIN_BASE_UNAME = sEmptyCanTransmissionFileFrame.main_base_uname,$
          XOFF            = sEmptyCanTransmissionFileFrame.xoff,$
          YOFF            = sEmptyCanTransmissionFileFrame.yoff,$
          FRAME_TITLE     = sEmptyCanTransmissionFileFrame.frame_title,$
          LABEL_1         = sEmptyCanTransmissionFileFrame.label_1,$
          CWFIELD_UNAME   = sEmptyCanTransmissionFileFrame.tf1_uname,$
          BROWSE_UNAME    = sEmptyCanTransmissionFileFrame.browse_uname,$
          FILE_NAME_UNAME = sEmptyCanTransmissionFileFrame.file_name_uname)

;- Output Folder --------------------------------------------------------------
wOutputFolderLabel = WIDGET_LABEL(BaseTab,$
                                  XOFFSET   = sOutputFolderLabel.size[0],$
                                  YOFFSET   = sOutputFolderLabel.size[1],$
                                  VALUE     = sOutputFolderLabel.value)

wOutputFolder = WIDGET_BUTTON(BaseTab,$
                              XOFFSET   = sOutputFolder.size[0],$
                              YOFFSET   = sOutputFolder.size[1],$
                              SCR_XSIZE = sOutputFolder.size[2],$
                              VALUE     = sOutputFolder.value,$
                              UNAME     = sOutputFolder.uname)

;- Output File --------------------------------------------------------------
wOutputFileLabel = WIDGET_LABEL(BaseTab,$
                                  XOFFSET   = sOutputFileLabel.size[0],$
                                  YOFFSET   = sOutputFileLabel.size[1],$
                                  VALUE     = sOutputFileLabel.value)


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

END

