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

PRO make_gui_tab1, MAIN_TAB, MainTabSize, title

  ;Load button
  XYoff = [5,5]
  sBrowse = { size: [XYoff[0],$
    XYoff[1],$
    150],$
    value: 'BROWSE CL FILE ...',$
    uname: 'load_cl_file_button'}
    
  ;Label (file name: and 'name of file')
  XYoff = [10,6]
  sLabel1 = { size: [sBrowse.size[0]+sBrowse.size[2]+XYoff[0],$
    sBrowse.size[1]+XYoff[1]],$
    value: 'CL File Loaded:' }
  XYoff = [100,0]
  sLabel2 = { size: [sLabel1.size[0]+XYoff[0],$
    sLabel1.size[1]+XYoff[1],$
    400],$
    value: 'N/A',$
    uname: 'cl_file_name_label'}
    
  ;Preview of CL file text box
  XYoff = [0,40]
  sPreview = { size: [sBrowse.size[0]+XYoff[0],$
    sBrowse.size[1]+XYoff[1],$
    MainTabSize[2]-15,$
    90],$
    uname: 'preview_cl_file_text_field'}
    
  ;Preview label
  XYoff = [630,-14]
  sPreviewLabel = { size: [sPreview.size[0]+XYoff[0],$
    sPreview.size[1]+XYoff[1]],$
    value: 'PREVIEW of File Loaded'}
    
  ;Instruction about what to do
  XYoff = [0,5]
  sInstruction = { size: [sPreview.size[0]+XYoff[0],$
    sPreview.size[1]+sPreview.size[3]+XYoff[1]],$
    value: 'Select text you want to modify in Preview, ' + $
    'enter new text and hit ENTER ->'}
    
  ;info text field
  XYoff = [0,30]
  sInfoFrame = { size: [sInstruction.size[0]+XYoff[0],$
    sInstruction.size[1]+XYoff[1],$
    465,50],$
    frame: 1}
    
  XYoff = [200,-8] ;title of info frame
  sInfoTitle = { size: [sInfoFrame.size[0]+XYoff[0],$
    sInfoFrame.size[1]+XYoff[1]],$
    value: 'I N F O S',$
    uname: 'info_title_label',$
    sensitive: 1}
    
  XYoff = [5,2] ;label1
  sInfo1 = { size: [sInfoFrame.size[0]+XYoff[0],$
    sInfoFrame.size[1]+XYoff[1],$
    450,30],$
    value: 'Text Removed: N/A',$
    uname: 'info_line1_label',$
    sensitive: 1}
    
  XYoff = [0,20] ;label2
  sInfo2 = { size: [sInfo1.size[0]+XYoff[0],$
    sInfo1.size[1]+XYoff[1],$
    sInfo1.size[2:3]],$
    value: 'Number of processes that will be launched: N/A',$
    uname: 'info_line2_label',$
    sensitive: 1}
    
  ;Input text box
  XYoff = [480,0]
  sInput = { size: [XYoff[0],$
    sInstruction.size[1]+XYoff[1],$
    310,3],$
    uname: 'input_text_field',$
    sensitive: 0}
    
  ;Help button
  XYoff = [0,59]
  sHelp = { size: [sInput.size[0]+XYoff[0],$
    sInput.size[1]+XYoff[1],$
    sInput.size[2]],$
    value: 'H E L P (example of Input)',$
    uname: 'help_button',$
    sensitive: 0}
    
  ;Widget table (list of runs created)
  XYoff = [0,10]
  sTable = { size: [sInfoFrame.size[0]+XYoff[0],$
    sInfoFrame.size[1]+sInfoFrame.size[3]+XYoff[1],$
    sPreview.size[2],$
    475,$ ;455
    2,$
    1],$
    uname: 'runs_table',$
    column_labels: ['Runs','Command Line Preview'],$
    column_widths: [200,750]}
    
  ;Check slurm processes
  XYoff = [5,5]
  sBrowseButton = { size: [XYoff[0],$
    sTable.size[1]+$
    sTable.size[3]+XYoff[1],$
    250],$
    value: 'Check Status of Jobs Submitted ...',$
    uname: 'check_status_button'}
    
  ;preview/save jobs listing
  XYoff = [5,0]
  sPreviewButton = { size: [sBrowseButton.size[0]+$
    sBrowseButton.size[2]+XYoff[0],$
    sBrowseButton.size[1]+XYoff[1],$
    200],$
    value: 'Preview/Save_as jobs ...',$
    uname: 'preview_jobs_button',$
    sensitive: 0}
    
  ;Launch jobs
  XYoff = [5,0]
  sRunButton = { size: [sPreviewButton.size[0]+$
    sPreviewButton.size[2]+XYoff[0],$
    sPreviewButton.size[1]+XYoff[1],$
    325],$
    value: 'L A U N C H    J O B S    I N    B A C K G R O U N D',$
    uname: 'run_jobs_button',$
    sensitive: 0}
    
  ;==============================================================================
    
  Base = WIDGET_BASE(MAIN_TAB,$
    UNAME     = 'tab1_uname',$
    XOFFSET   = MainTabSize[0],$
    YOFFSET   = MainTabSize[1],$
    SCR_XSIZE = MainTabSize[2],$
    SCR_YSIZE = MainTabSize[3],$
    TITLE     = title,$
    MAP       = 1)
    
  ;input example
  ex = WIDGET_LABEL(Base,$
    XOFFSET = 550,$
    YOFFSET = 265,$
    VALUE   = '(Ex: 3741-3749,[3750,3760-3763],3800)')
    
  tab1 = WIDGET_BASE(Base,/COLUMN)
  
  row1 = WIDGET_BASE(tab1,/ROW)
  wLoad = WIDGET_BUTTON(row1,$ ;load button
    SCR_XSIZE = 150,$
    UNAME     = 'load_cl_file_button',$
    VALUE     = 'BROWSE CL FILE ...')
  wLabel1 = WIDGET_LABEL(row1,$ ;File Name Labels
    VALUE = 'CL File Loaded:')
  wLabel2 = WIDGET_LABEL(row1,$
    SCR_XSIZE = 530,$
    VALUE     = 'N/A',$
    UNAME     = 'cl_file_name_label',$
    /ALIGN_LEFT)
    
  row2 = WIDGET_LABEL(tab1,$
    VALUE = 'Preview of CL file loaded')
    
  row3 = WIDGET_TEXT(tab1,$ ;Preview of CL file text box
    SCR_XSIZE = 785,$
    SCR_YSIZE = 90,$
    UNAME     = preview_cl_file_text_field,$
    /SCROLL,$
    /ALL_EVENTS,$
    /WRAP)
    
  row4 = WIDGET_BASE(tab1,$
    /ROW)
  row4_col2_row1 = WIDGET_BASE(row4,$
    /ROW)
  button1 = WIDGET_BUTTON(row4,$
    VALUE = '>>>>>>>>',$
    UNAME = 'selection_1')
  text  = WIDGET_LABEL(row4,$
    VALUE = ' ',$
    SCR_XSIZE = 330,$
    FRAME=1,$
    UNAME = 'selection_1_to_replaced')
  label = WIDGET_LABEL(row4,$
    VALUE = 'will be replaced by')
  text  = WIDGET_TEXT(row4,$
    VALUE = '',$
    XSIZE = 40,$
    /EDITABLE,$
    UNAME = 'selection_1_replaced_by')
    
  row5 = WIDGET_BASE(tab1,$
    /ROW)
  row5_col2_row1 = WIDGET_BASE(row5,$
    /ROW)
  button1 = WIDGET_BUTTON(row5,$
    VALUE = '        ',$
    UNAME = 'selection_2')
  text  = WIDGET_LABEL(row5,$
    VALUE = ' ',$
    SCR_XSIZE = 330,$
    FRAME=1,$
    UNAME = 'selection_2_to_replaced')
  label = WIDGET_LABEL(row5,$
    VALUE = 'will be replaced by')
  text  = WIDGET_TEXT(row5,$
    VALUE = '',$
    XSIZE = 40,$
    /EDITABLE,$
    UNAME = 'selection_2_replaced_by')
    
  row6 = WIDGET_BASE(tab1,$
    /ROW)
  row6_col2_row1 = WIDGET_BASE(row6,$
    /ROW)
  button1 = WIDGET_BUTTON(row6,$
    VALUE = '        ',$
    UNAME = 'selection_3')
  text  = WIDGET_LABEL(row6,$
    VALUE = ' ',$
    SCR_XSIZE = 330,$
    FRAME=1,$
    UNAME = 'selection_3_to_replaced')
  label = WIDGET_LABEL(row6,$
    VALUE = 'will be replaced by')
  text  = WIDGET_TEXT(row6,$
    VALUE = '',$
    XSIZE = 40,$
    /EDITABLE,$
    UNAME = 'selection_3_replaced_by')
    
    
  recap_label = WIDGET_LABEL(tab1,$
    /ALIGN_LEFT,$
    VALUE = '                  R E C A P   T A B L E ')
    
  ;Table
  wTable = WIDGET_TABLE(tab1,$
    SCR_XSIZE = 780,$
    SCR_YSIZE = 410,$
    XSIZE     = 4,$
    YSIZE     = 1,$
    COLUMN_WIDTHS = [100,100,100,1500],$
    /NO_ROW_HEADERS,$
    COLUMN_LABELS = ['Selection 1','Selection 2','Selection 3',$
    'Command Line Preview                                               '+$
    '                                                                   '+$
    '                                            '],$
    /SCROLL,$
    /RESIZEABLE_COLUMNS,$
    UNAME = 'runs_table')
    
    row7 = WIDGET_BASE(tab1,$
    /ROW)
    
    button1 = WIDGET_BUTTON(row7,$
    VALUE = 'Check Status of Jobs Submitted ...',$
    UNAME = 'check_status_button',$
    SCR_XSIZE = 250)

    button2 = WIDGET_BUTTON(row7,$
    VALUE = 'Preview/Save as  Jobs ...',$
    UNAME = 'preview_jobs_button',$
    SENSITIVE = 0,$
    SCR_XSIZE = 200)

    button3 = WIDGET_BUTTON(row7,$
    VALUE = 'L A U N C H    J O B S    I N    B A C K G R O U N D',$
    UNAME = 'run_jobs_button',$
    SENSITIVE = 0,$
    SCR_XSIZE = 325)

  
    
    ;  ;firefox button
;  wFirefox = WIDGET_BUTTON(Base,$
;    XOFFSET   = sBrowseButton.size[0],$
;    YOFFSET   = sBrowseButton.size[1],$
;    SCR_XSIZE = sBrowseButton.size[2],$
;    VALUE     = sBrowseButton.value,$
;    UNAME     = sBrowseButton.uname)
;
;      ;preview jobs button
;  wRun = WIDGET_BUTTON(Base,$
;    XOFFSET = sPreviewButton.size[0],$
;    YOFFSET = sPreviewButton.size[1],$
;    SCR_XSIZE = sPreviewButton.size[2],$
;    VALUE = sPreviewButton.value,$
;    UNAME = sPreviewButton.uname,$
;    SENSITIVE = sPreviewButton.sensitive)
;
;
;  ;run jobs button
;  wRun = WIDGET_BUTTON(Base,$
;    XOFFSET = sRunButton.size[0],$
;    YOFFSET = sRunButton.size[1],$
;    SCR_XSIZE = sRunButton.size[2],$
;    VALUE = sRunButton.value,$
;    UNAME = sRunButton.uname,$
;    SENSITIVE = sRunButton.sensitive)
    
    
;  wPreviewLabel = WIDGET_LABEL(Base,$
;    XOFFSET = sPreviewLabel.size[0],$
;    YOFFSET = sPreviewLabel.size[1],$
;    VALUE   = sPreviewLabel.value)
;
;  ;Instruction
;  wInstruction = WIDGET_LABEL(Base,$
;    XOFFSET = sInstruction.size[0],$
;    YOFFSET = sInstruction.size[1],$
;    VALUE   = sInstruction.value)
;
;  ;Input text field
;  wInput = WIDGET_TEXT(Base,$
;    XOFFSET   = sInput.size[0],$
;    YOFFSET   = sInput.size[1],$
;    SCR_XSIZE = sInput.size[2],$
;    YSIZE     = sInput.size[3],$
;    UNAME     = sInput.uname,$
;    SENSITIVE = sInput.sensitive,$
;    /SCROLL,$
;    /EDITABLE,$
;    /WRAP,$
;    /ALL_EVENTS)
;
;  ;Help button
;  wHelp = WIDGET_BUTTON(Base,$
;    XOFFSET   = sHelp.size[0],$
;    YOFFSET   = sHelp.size[1],$
;    SCR_XSIZE = sHelp.size[2],$
;    UNAME     = sHelp.uname,$
;    VALUE     = sHelp.value,$
;    SENSITIVE = sHelp.sensitive,$
;    /PUSHBUTTON_EVENTS)
;
;
;  wInfoTitle = WIDGET_LABEL(Base,$
;    XOFFSET   = sInfoTitle.size[0],$
;    YOFFSET   = sInfoTitle.size[1],$
;    VALUE     = sInfoTitle.value,$
;    UNAME     = sInfoTitle.uname,$
;    SENSITIVE = sInfoTitle.sensitive)
;
;  ;Info messages
;  wInfo1 = WIDGET_LABEL(Base,$
;    XOFFSET   = sInfo1.size[0],$
;    YOFFSET   = sInfo1.size[1],$
;    SCR_XSIZE = sInfo1.size[2],$
;    SCR_YSIZE = sInfo1.size[3],$
;    VALUE     = sInfo1.value,$
;    SENSITIVE = sInfo1.sensitive,$
;    UNAME     = sInfo1.uname,$
;    /ALIGN_LEFT)
;
;  wInfo2 = WIDGET_LABEL(Base,$
;    XOFFSET   = sInfo2.size[0],$
;    YOFFSET   = sInfo2.size[1],$
;    SCR_XSIZE = sInfo2.size[2],$
;    SCR_YSIZE = sInfo2.size[3],$
;    VALUE     = sInfo2.value,$
;    UNAME     = sInfo2.uname,$
;    SENSITIVE = sInfo2.sensitive,$
;    /ALIGN_LEFT)
;
;  ;Info frame
;  wInfo = WIDGET_LABEL(Base,$
;    XOFFSET   = sInfoFrame.size[0],$
;    YOFFSET   = sInfoFrame.size[1],$
;    SCR_XSIZE = sInfoFrame.size[2],$
;    SCR_YSIZE = sInfoFrame.size[3],$
;    VALUE     = '',$
;    FRAME     = sInfoFrame.frame)
;
;
    
END




