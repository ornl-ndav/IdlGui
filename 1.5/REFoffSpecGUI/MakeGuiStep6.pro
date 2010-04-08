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

PRO make_gui_step6, REDUCE_TAB, tab_size, TabTitles, global

  ;summary table settings
  NbrRows    = 6
  NbrColumns = 3
  
  instrument = (*global).instrument
  
  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************
  
  sBaseTab = { size:  tab_size,$
    uname: 'step6_tab_base',$
    title: TabTitles.step6}
    
  ;Output file name frame -------------------------------------------------------
  XYoff = [10,15] ;base
  sOutputFileBase = { size: [XYoff[0],$
    XYoff[1],$
    tab_size[2]-3*XYoff[0],110],$
    uname: 'create_output_file_base',$
    frame: 2}
  XYoff = [20,-8] ;title
  sOutputFileTitle = { size: [sOutputFileBase.size[0]+XYoff[0],$
    sOutputFileBase.size[1]+ $
    XYoff[1]],$
    value: 'Output File Name'}
  XYoff = [5,10] ;folder button
  sOutputFolder = { size: [XYoff[0],$
    XYoff[1],$
    sOutputFileBase.size[2]-2*XYoff[0]],$
    value: '~/results/',$
    uname: 'create_output_file_path_button'}
  XYoff = [5,35] ;file name label
  sOutputFileNameLabel = { size: [XYoff[0],$
    sOutputFolder.size[1]+XYoff[1]],$
    value: 'File Name:'}
  XYoff = [80,-5] ;file name text field
  sOutputFileNameTF = { size: [XYoff[0],$
    sOutputFileNameLabel.size[1]+XYoff[1],$
    sOutputFolder.size[2]-XYoff[0]+5],$
    value: '',$
    uname: 'create_output_file_name_text_field'}
  XYoff = [0,35] ;full file name preview
  sOutputFileNamePreview = { size: [sOutputFileNameLabel.size[0]+$
    XYoff[0],$
    sOutputFileNameLabel.size[1]+$
    XYoff[1]],$
    value: 'Full File Name is ->'}
  XYoff = [130,0] ;full file name value
  sOutputFileValuePreview = { size: [sOutputFileNamePreview.size[0]+XYoff[0],$
    sOutputFileNamePreview.size[1]+XYoff[1],$
    sOutputFilenameTF.size[2]],$
    uname: 'create_output_full_file_name_' + $
    'preview_value',$
    value: '~/results/'}
    
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  XYoff = [0,15]
  sSummaryBase = { size: [sOutputFileBase.size[0]+XYoff[0],$
    sOutputFileBase.size[1]+$
    sOutputFileBase.size[3]+XYoff[1],$
    618,250],$
    uname: 'output_file_summary_base',$
    frame: 1}
    
  XYoff = [20,-8] ;title
  sSummaryTitle = { size: [sSummaryBase.size[0]+XYoff[0],$
    sSummaryBase.size[1]+XYoff[1]],$
    value: 'Summary of Shifting/Scaling Parameters Defined'}
    
  XYoff = [10,15] ;table
  
  TableAlign = INTARR(NbrColumns,NbrRows)+1
  sSummaryTable = { size: [XYoff[0],$
    XYoff[1],$
    sSummaryBase.size[2]-2*XYoff[0],$
    150,$
    NbrColumns,$
    NbrRows],$
    uname: 'output_file_summary_table',$
    sensitive: 1,$sSummaryBase
  label: ['Name of files used',$
    'Shifting (# pixels)',$
    'Scaling Factor'],$
    align: TableAlign,$
    width: [374,120,100]}
    
  ;recap of polarization state used --------------------------------------------
  XYoff = [0,5]
  sSummaryWorkingPola = { size: [sSummaryTable.size[0]+XYoff[0],$
    sSummaryTable.size[1]+$
    sSummaryTable.size[3]+XYoff[1]],$
    value: 'Polarization state:'}
  XYoff = [130,1]
  sSummaryWorkingPolaValue = { size: [sSummaryWorkingPola.size[0]+XYoff[0],$
    sSummaryWorkingPola.size[1]+XYoff[1],$
    500],$
    value: 'N/A',$
    uname: 'summary_working_polar_value'}
    
  ;label of input file path -----------------------------------------------------
  XYoff = [0,25]
  sSummaryInputPath = { size: [sSummaryWorkingPola.size[0]+XYoff[0],$
    sSummaryWorkingPola.size[1]+XYoff[1]],$
    value: 'Input File Path   :'}
  XYoff = [130,1]
  sSummaryInputPathValue = { size: [sSummaryInputPath.size[0]+XYoff[0],$
    sSummaryInputPath.size[1]+$
    XYoff[1],$
    500],$
    value: 'N/A',$
    uname: 'summary_input_path_name_value'}
    
  ;label of output file name (short file name) ----------------------------------
  XYoff = [0,25]
  sSummaryOutputFileLabel = { size: [sSummaryTable.size[0]+XYoff[0],$
    sSummaryInputPath.size[1]+XYoff[1]],$
    value: 'Output File Name  :'}
  XYoff = [130,1]
  sSummaryOutputFileValue = { size: [sSummaryOutputFileLabel.size[0]+$
    XYoff[0],$
    sSummaryOutputFileLabel.size[1]+$
    XYoff[1],$
    370],$
    value: 'N/A',$
    uname: 'summary_output_file_name_value'}
    
  ;Get preview of output file ---------------------------------------------------
  XYoff = [0,-5]
  sPreviewPolar1Button = { size: [sSummaryOutputFileValue.size[0]+$
    sSummaryOutputFileValue.size[2]+$
    XYoff[0],$
    sSummaryOutputFileValue.size[1]+$
    XYoff[1],$
    100],$
    value: 'PREVIEW',$
    sensitive: 0,$
    uname: 'step6_preview_pola_state1'}
    
  ;Recap of Second Polarization state -------------------------------------------
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  XYoff = [10,0]
  sPolar2SummaryBase = { size: [sSummaryBase.size[0]+$
    sSummaryBase.size[2]+XYoff[0],$
    sSummaryBase.size[1]+XYoff[1],$
    sSummaryBase.size[2],$
    225],$
    uname: 'polarization_state2_summary_base',$
    frame: 1}
    
  XYoff = [20,-8]                 ;title
  sPolar2SummaryTitle = { size: [sPolar2SummaryBase.size[0]+XYoff[0],$
    sPolar2SummaryBase.size[1]+XYoff[1]],$
    value: 'Recap. of parameters that will be used for' + $
    ' Polarization state #2',$
    uname: 'polarization_state2_summary_base_title'}
    
  XYoff = [520,-6]
  sTurnOffPolar2 = { size: [sPolar2SummaryTitle.size[0]+XYoff[0],$
    sPolar2SummaryTitle.size[1]+XYoff[1]],$
    value: 'EXCLUDE',$
    uname: 'exclude_polarization_state2'}
    
  XYoff = [10,15]                 ;table
  TableAlign = INTARR(NbrColumns,NbrRows)+1
  sPolar2SummaryTable = { size: [XYoff[0],$
    XYoff[1],$
    sPolar2SummaryBase.size[2]-2*XYoff[0],$
    150,$
    NbrColumns,$
    NbrRows],$
    uname: 'polarization_state2_summary_table',$
    sensitive: 1,$
    label: ['Name of files used',$
    'Shifting (# pixels)',$
    'Scaling Factor'],$
    align: TableAlign,$
    width: sSummaryTable.width}
    
  ;recap of polarization state used --------------------------------------------
  XYoff = [0,5]
  sPolar2SummaryPola = { size: [sPolar2SummaryTable.size[0]+XYoff[0],$
    sPolar2SummaryTable.size[1]+$
    sPolar2SummaryTable.size[3]+XYoff[1]],$
    value: 'Polarization state:'}
    
  XYoff = [130,1]
  sPolar2SummaryPolaValue = { size: [sPolar2SummaryPola.size[0]+XYoff[0],$
    sPolar2SummaryPola.size[1]+XYoff[1],$
    50],$
    value: 'N/A',$
    uname: 'summary_polar2_value'}
    
  ;repopulate gui button --------------------------------------------------------
  XYoff = [180,-4]
  sPolar2Button = { size: [sPolar2SummaryPola.size[0]+XYoff[0],$
    sPolar2SummaryPola.size[1]+XYoff[1],$
    420],$
    value: 'REPOPULATE GUI USING THIS POLARIZATION STATE',$
    uname: 'summary_polar2_repopulate_button',$
    sensitive: 0}
    
  ;label of output file name (short file name) ----------------------------------
  XYoff = [0,25]
  sPola2OutputFileLabel = { size: [sPolar2SummaryPola.size[0]+XYoff[0],$
    sPolar2SummaryPola.size[1]+XYoff[1]],$
    value: 'Output File Name  :'}
  XYoff = [130,1]
  sPola2OutputFileValue = { size: [sPola2OutputFileLabel.size[0]+$
    XYoff[0],$
    sPola2OutputFileLabel.size[1]+$
    XYoff[1],$
    370],$
    value: 'N/A',$
    uname: 'pola2_output_file_name_value'}
    
  ;Get preview of output file ---------------------------------------------------
  XYoff = [0,-2]
  sPreviewPolar2Button = { size: [sPola2OutputFileValue.size[0]+$
    sPola2OutputFileValue.size[2]+$
    XYoff[0],$
    sPola2OutputFileValue.size[1]+$
    XYoff[1],$
    sPreviewPolar1Button.size[2]],$
    value: 'PREVIEW',$
    sensitive: 0,$
    uname: 'step6_preview_pola_state2'}
    
  ;Recap of third Polarization state --------------------------------------------
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  XYoff = [10,20]
  sPolar3SummaryBase = { size: [sSummaryBase.size[0]+$
    sSummaryBase.size[2]+XYoff[0],$
    sPolar2SummaryBase.size[1]+ $
    sPolar2SummaryBase.size[3]+XYoff[1],$
    sSummaryBase.size[2],$
    225],$
    uname: 'polarization_state3_summary_base',$
    frame: 1}
    
  XYoff = [20,-8]                 ;title
  sPolar3SummaryTitle = { size: [sPolar3SummaryBase.size[0]+XYoff[0],$
    sPolar3SummaryBase.size[1]+XYoff[1]],$
    value: 'Recap. of parameters that will be used for' + $
    ' Polarization state #3',$
    uname: 'polarization_state3_summary_base_title'}
    
  XYoff = [520,-6]
  sTurnOffPolar3 = { size: [sPolar3SummaryTitle.size[0]+XYoff[0],$
    sPolar3SummaryTitle.size[1]+XYoff[1]],$
    value: 'EXCLUDE',$
    uname: 'exclude_polarization_state3'}
    
  XYoff = [10,15]                 ;table
  TableAlign = INTARR(NbrColumns,NbrRows)+1
  sPolar3SummaryTable = { size: [XYoff[0],$
    XYoff[1],$
    sPolar3SummaryBase.size[2]-2*XYoff[0],$
    150,$
    NbrColumns,$
    NbrRows],$
    uname: 'polarization_state3_summary_table',$
    sensitive: 1,$
    label: ['Name of files used',$
    'Shifting (# pixels)',$
    'Scaling Factor'],$
    align: TableAlign,$
    width: sSummaryTable.width}
    
  ;recap of polarization state used --------------------------------------------
  XYoff = [0,5]
  sPolar3SummaryPola = { size: [sPolar3SummaryTable.size[0]+XYoff[0],$
    sPolar3SummaryTable.size[1]+$
    sPolar3SummaryTable.size[3]+XYoff[1]],$
    value: 'Polarization state:'}
    
  XYoff = [130,1]
  sPolar3SummaryPolaValue = { size: [sPolar3SummaryPola.size[0]+XYoff[0],$
    sPolar3SummaryPola.size[1]+XYoff[1],$
    50],$
    value: 'N/A',$
    uname: 'summary_polar3_value'}
    
  ;repopulate gui button --------------------------------------------------------
  XYoff = [180,-4]
  sPolar3Button = { size: [sPolar3SummaryPola.size[0]+XYoff[0],$
    sPolar3SummaryPola.size[1]+XYoff[1],$
    sPolar2Button.size[2]],$
    value: 'REPOPULATE GUI USING THIS POLARIZATION STATE',$
    uname: 'summary_polar3_repopulate_button',$
    sensitive: 0}
    
  ;label of output file name (short file name) ----------------------------------
  XYoff = [0,25]
  sPola3OutputFileLabel = { size: [sPolar3SummaryPola.size[0]+XYoff[0],$
    sPolar3SummaryPola.size[1]+XYoff[1]],$
    value: 'Output File Name  :'}
  XYoff = [130,1]
  sPola3OutputFileValue = { size: [sPola3OutputFileLabel.size[0]+$
    XYoff[0],$
    sPola3OutputFileLabel.size[1]+$
    XYoff[1],$
    370],$
    value: 'N/A',$
    uname: 'pola3_output_file_name_value'}
    
  ;Get preview of output file ---------------------------------------------------
  XYoff = [0,-2]
  sPreviewPolar3Button = { size: [sPola3OutputFileValue.size[0]+$
    sPola3OutputFileValue.size[2]+$
    XYoff[0],$
    sPola3OutputFileValue.size[1]+$
    XYoff[1],$
    sPreviewPolar1Button.size[2]],$
    value: 'PREVIEW',$
    sensitive: 0,$
    uname: 'step6_preview_pola_state3'}
    
  ;Recap of fourth Polarization state -------------------------------------------
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  XYoff = [10,20]
  sPolar4SummaryBase = { size: [sSummaryBase.size[0]+$
    sSummaryBase.size[2]+XYoff[0],$
    sPolar3SummaryBase.size[1]+ $
    sPolar3SummaryBase.size[3]+XYoff[1],$
    sSummaryBase.size[2],$
    225],$
    uname: 'polarization_state4_summary_base',$
    frame: 1}
    
  XYoff = [20,-8]                 ;title
  sPolar4SummaryTitle = { size: [sPolar4SummaryBase.size[0]+XYoff[0],$
    sPolar4SummaryBase.size[1]+XYoff[1]],$
    value: 'Recap. of parameters that will be used for' + $
    ' Polarization state #4',$
    uname: 'polarization_state4_summary_base_title'}
    
  XYoff = [520,-6]
  sTurnOffPolar4 = { size: [sPolar4SummaryTitle.size[0]+XYoff[0],$
    sPolar4SummaryTitle.size[1]+XYoff[1]],$
    value: 'EXCLUDE',$
    uname: 'exclude_polarization_state4'}
    
    
  XYoff = [10,15]                 ;table
  TableAlign = INTARR(NbrColumns,NbrRows)+1
  sPolar4SummaryTable = { size: [XYoff[0],$
    XYoff[1],$
    sPolar4SummaryBase.size[2]-2*XYoff[0],$
    150,$
    NbrColumns,$
    NbrRows],$
    uname: 'polarization_state4_summary_table',$
    sensitive: 1,$
    label: ['Name of files used',$
    'Shifting (# pixels)',$
    'Scaling Factor'],$
    align: TableAlign,$
    width: sSummaryTable.width}
    
  ;recap of polarization state used ------------------------------------------
  XYoff = [0,5]
  sPolar4SummaryPola = { size: [sPolar4SummaryTable.size[0]+XYoff[0],$
    sPolar4SummaryTable.size[1]+$
    sPolar4SummaryTable.size[3]+XYoff[1]],$
    value: 'Polarization state:'}
    
  XYoff = [130,1]
  sPolar4SummaryPolaValue = { size: [sPolar4SummaryPola.size[0]+XYoff[0],$
    sPolar4SummaryPola.size[1]+XYoff[1],$
    sPolar2SummaryPolaValue.size[2]],$
    value: 'N/A',$
    uname: 'summary_polar4_value'}
    
  ;repopulate gui button ------------------------------------------------------
  XYoff = [180,-4]
  sPolar4Button = { size: [sPolar4SummaryPola.size[0]+XYoff[0],$
    sPolar4SummaryPola.size[1]+XYoff[1],$
    sPolar2Button.size[2]],$
    value: 'REPOPULATE GUI USING THIS POLARIZATION STATE',$
    uname: 'summary_polar4_repopulate_button',$
    sensitive: 0}
    
  ;label of output file name (short file name) --------------------------------
  XYoff = [0,25]
  sPola4OutputFileLabel = { size: [sPolar4SummaryPola.size[0]+XYoff[0],$
    sPolar4SummaryPola.size[1]+XYoff[1]],$
    value: 'Output File Name  :'}
  XYoff = [130,1]
  sPola4OutputFileValue = { size: [sPola4OutputFileLabel.size[0]+$
    XYoff[0],$
    sPola4OutputFileLabel.size[1]+$
    XYoff[1],$
    370],$
    value: 'N/A',$
    uname: 'pola4_output_file_name_value'}
    
  ;Get preview of output file -------------------------------------------------
  XYoff = [0,-2]
  sPreviewPolar4Button = { size: [sPola4OutputFileValue.size[0]+$
    sPola4OutputFileValue.size[2]+$
    XYoff[0],$
    sPola4OutputFileValue.size[1]+$
    XYoff[1],$
    sPreviewPolar1Button.size[2]],$
    value: 'PREVIEW',$
    sensitive: 0,$
    uname: 'step6_preview_pola_state4'}
    
  ;----------------------------------------------------------------------------
  ;Create output file button --------------------------------------------------
  XYoff = [0,10]
  sCreateOutput = { size: [sSummaryBase.size[0]+XYoff[0],$
    sSummaryBase.size[1]+$
    sSummaryBase.size[3]+XYoff[1],$
    620],$
    value: 'CREATE OUTPUT FILE',$
    sensitive: 0,$
    uname: 'create_output_file_create_button'}
    
  ;----------------------------------------------------------------------------
  ;Status of process (label and text_field)
  XYoff = [5,30]
  sStatusLabel = { size: [sCreateOutput.size[0]+XYoff[0],$
    sCreateOutput.size[1]+XYoff[1]],$
    value: 'S T A T U S'}
  XYoff = [0,20]
  sStatusText = { size: [sCreateOutput.size[0]+XYoff[0],$
    sStatusLabel.size[1]+XYoff[1],$
    sCreateOutput.size[2],$
    230],$
    value: '',$
    uname: 'step6_status_text_field'}
    
  ;list of I vs Q (or TOF) files ----------------------------------------------
  ;base
  XYoff = [0,12]
  sIvsQbase = { size: [sSummaryBase.size[0]+XYoff[0],$
    sStatusText.size[1]+sStatusText.size[3]+XYoff[1],$
    sSummaryBase.size[2],$
    162],$
    frame: 1}
    
  ;title
  XYoff = [-5,-10]
  XYoff = [sOutputFileTitle.size[0]+XYoff[0],XYoff[1]]
  sIvsQtitle = { size: [sIvsQbase.size[0]+XYoff[0],$
    sIvsQbase.size[1]+XYoff[1]],$
    value: 'List of I vs Q or TOF files'}
    
    
  ;****************************************************************************
  ;            BUILD GUI
  ;****************************************************************************
    
  BaseTab = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBaseTab.uname,$
    XOFFSET   = sBaseTab.size[0],$
    YOFFSET   = sBaseTab.size[1],$
    SCR_XSIZE = sBaseTab.size[2],$
    SCR_YSIZE = sBaseTab.size[3],$
    TITLE     = sBaseTab.title, $
    /SCROLL)
    
  ;Output file name frame -----------------------------------------------------
  ;title
  wOutputFileTitle = WIDGET_LABEL(BaseTab,$
    XOFFSET = sOutputfileTitle.size[0],$
    YOFFSET = sOutputFileTitle.size[1],$
    VALUE   = sOutputFileTitle.value)
    
  ;base
  wOutputFileBase = WIDGET_BASE(BaseTab,$
    XOFFSET   = sOutputFileBase.size[0],$
    YOFFSET   = sOutputFileBase.size[1],$
    SCR_XSIZE = sOutputFileBase.size[2],$
    SCR_YSIZE = sOutputFileBase.size[3],$
    FRAME     = sOutputFileBase.frame,$
    UNAME     = sOutputFileBase.uname)
    
  ;path button
  wOutputFolder = WIDGET_BUTTON(wOutputFileBase,$
    XOFFSET   = sOutputFolder.size[0],$
    YOFFSET   = sOutputFolder.size[1],$
    SCR_XSIZE = sOutputFolder.size[2],$
    VALUE     = sOutputFolder.value,$
    UNAME     = sOutputFolder.uname)
  ;file name
  wOutputFileName = WIDGET_LABEL(wOutputFileBase,$
    XOFFSET = sOutputFileNameLabel.size[0],$
    YOFFSET = sOutputFileNameLabel.size[1],$
    VALUE   = sOutputFileNameLabel.value)
    
  ;file name text field
  wOutputFileNameTF = WIDGET_TEXT(wOutputFileBase,$
    XOFFSET   = sOutputFileNameTF.size[0],$
    YOFFSET   = sOutputFileNameTF.size[1],$
    SCR_XSIZE = sOutputFileNameTF.size[2],$
    VALUE     = sOutputFileNameTF.value,$
    UNAME     = sOutputFileNameTF.uname,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  ;full file name preview label
  wOutputFullFileName = WIDGET_LABEL(wOutputFileBase,$
    XOFFSET = sOutputFileNamePreview.size[0],$
    YOFFSET = sOutputFileNamePreview.size[1],$
    VALUE   = sOutputFileNamePreview.value,$
    /ALIGN_LEFT)
    
  ;full file name preview value
  wOutputFullFileValue = WIDGET_LABEL(wOutputFileBase,$
    XOFFSET   = $
    sOutputFileValuePreview.size[0],$
    YOFFSET   = $
    sOutputFileValuePreview.size[1],$
    SCR_XSIZE = $
    sOutputFileValuePreview.size[2],$
    VALUE      = $
    sOutputFileValuePreview.value,$
    UNAME      = $
    sOutputFileValuePreview.uname,$
    /ALIGN_LEFT)
    
  ;Summary of Shifting/Scaling parameters used title ----------------------------
  wSummaryTitle = WIDGET_LABEL(BaseTab,$
    XOFFSET = sSummaryTitle.size[0],$
    YOFFSET = sSummaryTitle.size[1],$
    VALUE   = sSummaryTitle.value)
    
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  wSummaryBase = WIDGET_BASE(BaseTab,$
    XOFFSET   = sSummaryBase.size[0],$
    YOFFSET   = sSummaryBase.size[1],$
    SCR_XSIZE = sSummaryBase.size[2],$
    SCR_YSIZE = sSummaryBase.size[3],$
    UNAME     = sSummaryBase.uname,$
    FRAME     = sSummaryBase.frame)
    
  ;Table that summarize the files used and the parameters defined ---------------
  wSummaryTable = WIDGET_TABLE(wSummaryBase,$
    XOFFSET       = sSummaryTable.size[0],$
    YOFFSET       = sSummaryTable.size[1],$
    SCR_XSIZE     = sSummaryTable.size[2],$
    SCR_YSIZE     = sSummaryTable.size[3],$
    XSIZE         = sSummaryTable.size[4],$
    YSIZE         = sSummaryTable.size[5],$
    UNAME         = sSummaryTable.uname,$
    SENSITIVE     = sSummaryTable.sensitive,$
    COLUMN_LABELS = sSummaryTable.label,$
    COLUMN_WIDTHS = sSummaryTable.width,$
    ALIGNMENT     = sSummaryTable.align,$
    /NO_ROW_HEADERS,$
    /ROW_MAJOR,$
    /EDITABLE,$
    /RESIZEABLE_COLUMNS,$
    /SCROLL)
    
  ;label of polarization state used ---------------------------------------------
  wSummaryWorkingPola = $
    WIDGET_LABEL(wSummaryBase,$
    XOFFSET   = sSummaryWorkingPola.size[0],$
    YOFFSET   = sSummaryWorkingPola.size[1],$
    VALUE     = sSummaryWorkingPola.value)
  wSummaryWorkingPolaValue = $
    WIDGET_LABEL(wSummaryBase,$
    XOFFSET   = sSummaryWorkingPolaValue.size[0],$
    YOFFSET   = sSummaryWorkingPolaValue.size[1],$
    SCR_XSIZE = sSummaryWorkingPolaValue.size[2],$
    VALUE     = sSummaryWorkingPolaValue.value,$
    UNAME     = sSummaryWorkingPolaValue.uname,$
    /ALIGN_LEFT)
    
  ;label of input file path -----------------------------------------------------
  wSummaryInputPath = $
    WIDGET_LABEL(wSummaryBase,$
    XOFFSET   = sSummaryInputPath.size[0],$
    YOFFSET   = sSummaryInputPath.size[1],$
    VALUE     = sSummaryInputPath.value)
  wSummaryInputPathValue = $
    WIDGET_LABEL(wSummaryBase,$
    XOFFSET   = sSummaryInputPathValue.size[0],$
    YOFFSET   = sSummaryInputPathValue.size[1],$
    SCR_XSIZE = sSummaryInputPathValue.size[2],$
    VALUE     = sSummaryInputPathValue.value,$
    UNAME     = sSummaryInputPathValue.uname,$
    /ALIGN_LEFT)
    
  ;label of output file name (short file name) ----------------------------------
  wSummaryOutputFileLabel = $
    WIDGET_LABEL(wSummaryBase,$
    XOFFSET   = sSummaryOutputFileLabel.size[0],$
    YOFFSET   = sSummaryOutputFileLabel.size[1],$
    VALUE     = sSummaryOutputFileLabel.value)
  wSummaryOutputFileValue = $
    WIDGET_LABEL(wSummaryBase,$
    XOFFSET   = sSummaryOutputFileValue.size[0],$
    YOFFSET   = sSummaryOutputFileValue.size[1],$
    SCR_XSIZE = sSummaryOutputFileValue.size[2],$
    VALUE     = sSummaryOutputFileValue.value,$
    UNAME     = sSummaryOutputFileValue.uname,$
    /ALIGN_LEFT)
    
  ; Get preview of output file
  wPreviewButton = WIDGET_BUTTON(wSummaryBase,$
    XOFFSET   = sPreviewPolar1Button.size[0],$
    YOFFSET   = sPreviewPolar1Button.size[1],$
    SCR_XSIZE = sPreviewPolar1Button.size[2],$
    UNAME     = sPreviewPolar1Button.uname,$
    SENSITIVE = sPreviewPolar1Button.sensitive,$
    VALUE     = sPreviewPolar1Button.value)
    
  ;------------------------------------------------------------------------------
    
  ;Create output file button
  wCreateButton = WIDGET_BUTTON(BaseTab,$
    XOFFSET   = sCreateOutput.size[0],$
    YOFFSET   = sCreateOutput.size[1],$
    SCR_XSIZE = sCreateOutput.size[2],$
    UNAME     = sCreateOutput.uname,$
    SENSITIVE = sCreateOutput.sensitive,$
    VALUE     = sCreateOutput.value)
    
  ;------------------------------------------------------------------------------
  ;Status of process (label and text_field)
  wStatusLabel = WIDGET_LABEL(BaseTab,$
    XOFFSET = sStatusLabel.size[0],$
    YOFFSET = sStatusLabel.size[1],$
    VALUE   = sStatusLabel.value)
    
  wStatusTextField = WIDGET_TEXT(BaseTab,$
    XOFFSET = sStatusText.size[0],$
    YOFFSET = sStatusText.size[1],$
    SCR_XSIZE = sStatusText.size[2],$
    SCR_YSIZE = sStatusText.size[3],$
    VALUE     = sStatusText.value,$
    UNAME     = sStatusText.uname,$
    /SCROLL,$
    /WRAP)
    
  title = WIDGET_LABEL(BaseTab,$
    XOFFSET = sIvsQtitle.size[0],$
    YOFFSET = sIvsQtitle.size[1],$
    VALUE   = sIvsQtitle.value,$
    UNAME = 'i_vs_q_output_base_title')
    
  base = WIDGET_BASE(BaseTab,$
    XOFFSET = sIvsQbase.size[0],$
    YOFFSET = sIvsQbase.size[1],$
    SCR_XSIZE = sIvsQbase.size[2],$
    SCR_YSIZE = sIvsQbase.size[3],$
    FRAME = sIvsQbase.frame,$
    UNAME  = 'i_vs_q_output_base',$
    MAP = 1,$
    /COLUMN)
    
  row1 = WIDGET_BASE(base,$
    uname = 'i_vs_q_output_file_working_spin_state_base',$
    /ROW)
    
  title = WIDGET_LABEL(row1,$
    VALUE = 'Working State: ')
    
  value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    UNAME = 'i_vs_q_output_file_working_spin_state',$
    SCR_XSIZE = 450,$
    /ALIGN_LEFT)
    
  button = WIDGET_BUTTON(row1,$
    VALUE = 'PREVIEW',$
    UNAME = 'i_vs_q_output_file_working_spin_state_preview')
    
  row2 = WIDGET_BASE(base,$
    uname = 'i_vs_q_output_file_spin_state2_base',$
    /ROW)
    
  IF (instrument EQ 'REF_M') THEN BEGIN
  
    title = WIDGET_LABEL(row2,$
      VALUE = 'State #2     :')
      
    value = WIDGET_TEXT(row2,$
      VALUE = '',$
      UNAME = 'i_vs_q_output_file_spin_state2',$
      XSIZE = 73,$
      /EDITABLE,$
      /ALL_EVENTS,$
      /ALIGN_LEFT)
      
    button = WIDGET_BUTTON(row2,$
      VALUE = 'PREVIEW',$
      UNAME = 'i_vs_q_output_file_spin_state2_preview')
      
    row3 = WIDGET_BASE(base,$
      uname = 'i_vs_q_output_file_spin_state3_base',$
      /ROW)
      
    title = WIDGET_LABEL(row3,$
      VALUE = 'State #3     :')
      
    value = WIDGET_TEXT(row3,$
      VALUE = '',$
      UNAME = 'i_vs_q_output_file_spin_state3',$
      XSIZE = 73,$
      /EDITABLE,$
      /ALL_EVENTS,$
      /ALIGN_LEFT)
      
    button = WIDGET_BUTTON(row3,$
      VALUE = 'PREVIEW',$
      UNAME = 'i_vs_q_output_file_spin_state3_preview')
      
    row4 = WIDGET_BASE(base,$
      uname = 'i_vs_q_output_file_spin_state4_base',$
      /ROW)
      
    title = WIDGET_LABEL(row4,$
      VALUE = 'State #4     :')
      
    value = WIDGET_TEXT(row4,$
      VALUE = '',$
      UNAME = 'i_vs_q_output_file_spin_state4',$
      XSIZE = 73,$
      /EDITABLE,$
      /ALL_EVENTS,$
      /ALIGN_LEFT)
      
    button = WIDGET_BUTTON(row4,$
      VALUE = 'PREVIEW',$
      UNAME = 'i_vs_q_output_file_spin_state4_preview')
      
  ENDIF
  
  IF (instrument EQ 'REF_L') THEN RETURN
  
  ;Recap of Second Polarization state -------------------------------------------
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  wPolar2SummaryTitle = WIDGET_LABEL(BaseTab,$
    XOFFSET = sPolar2SummaryTitle.size[0],$
    YOFFSET = sPolar2SummaryTitle.size[1],$
    UNAME   = sPolar2SummaryTitle.uname,$
    VALUE   = sPolar2SummaryTitle.value)
    
  ;exclude polar2
  wPolar = WIDGET_BASE(BaseTab,$
    XOFFSET = sTurnOffPolar2.size[0],$
    YOFFSET = sTurnoffPolar2.size[1],$
    /ROW,$
    /NONEXCLUSIVE)
    
  wbutton = WIDGET_BUTTON(wPolar,$
    VALUE = sTurnOffPolar2.value,$
    UNAME = sTurnOffPolar2.uname)
    
  ;Shifting/Scaling parameters used base ----------------------------------------
  wPolar2SummaryBase = WIDGET_BASE(BaseTab,$
    XOFFSET   = sPolar2SummaryBase.size[0],$
    YOFFSET   = sPolar2SummaryBase.size[1],$
    SCR_XSIZE = sPolar2SummaryBase.size[2],$
    SCR_YSIZE = sPolar2SummaryBase.size[3],$
    UNAME     = sPolar2SummaryBase.uname,$
    FRAME     = sPolar2SummaryBase.frame)
    
  ;Table that summarize the files used and the parameters defined ---------------
  wPolar2SummaryTable = WIDGET_TABLE(wPolar2SummaryBase,$
    XOFFSET       = sPolar2SummaryTable.size[0],$
    YOFFSET       = sPolar2SummaryTable.size[1],$
    SCR_XSIZE     = sPolar2SummaryTable.size[2],$
    SCR_YSIZE     = sPolar2SummaryTable.size[3],$
    XSIZE         = sPolar2SummaryTable.size[4],$
    YSIZE         = sPolar2SummaryTable.size[5],$
    UNAME         = sPolar2SummaryTable.uname,$
    SENSITIVE     = sPolar2SummaryTable.sensitive,$
    COLUMN_LABELS = sPolar2SummaryTable.label,$
    COLUMN_WIDTHS = sPolar2SummaryTable.width,$
    ALIGNMENT     = sPolar2SummaryTable.align,$
    /NO_ROW_HEADERS,$
    /ROW_MAJOR,$
    /EDITABLE,$
    /RESIZEABLE_COLUMNS, $
    /SCROLL)
    
  ;label of polarization state used ---------------------------------------------
  wPolar2SummaryPola = $
    WIDGET_LABEL(wPolar2SummaryBase,$
    XOFFSET   = sPolar2SummaryPola.size[0],$
    YOFFSET   = sPolar2SummaryPola.size[1],$
    VALUE     = sPolar2SummaryPola.value)
  wPolar2SummaryPolaValue = $
    WIDGET_LABEL(wPolar2SummaryBase,$
    XOFFSET   = sPolar2SummaryPolaValue.size[0],$
    YOFFSET   = sPolar2SummaryPolaValue.size[1],$
    SCR_XSIZE = sPolar2SummaryPolaValue.size[2],$
    VALUE     = sPolar2SummaryPolaValue.value,$
    UNAME     = sPolar2SummaryPolaValue.uname,$
    /ALIGN_LEFT)
    
  ;repopulate gui button --------------------------------------------------------
  wPolar2Button = WIDGET_BUTTON(wPolar2SummaryBase,$
    XOFFSET   = sPolar2Button.size[0],$
    YOFFSET   = sPolar2Button.size[1],$
    SCR_XSIZE = sPolar2Button.size[2],$
    VALUE     = sPolar2Button.value,$
    UNAME     = sPolar2Button.uname,$
    SENSITIVE = sPolar2Button.sensitive)
    
  ;label of output file name (short file name) ----------------------------------
  wSummaryOutputFileLabel = $
    WIDGET_LABEL(wPolar2SummaryBase,$
    XOFFSET   = sPola2OutputFileLabel.size[0],$
    YOFFSET   = sPola2OutputFileLabel.size[1],$
    VALUE     = sPola2OutputFileLabel.value)
  wSummaryOutputFileValue = $
    WIDGET_LABEL(wPolar2SummaryBase,$
    XOFFSET   = sPola2OutputFileValue.size[0],$
    YOFFSET   = sPola2OutputFileValue.size[1],$
    SCR_XSIZE = sPola2OutputFileValue.size[2],$
    VALUE     = sPola2OutputFileValue.value,$
    UNAME     = sPola2OutputFileValue.uname,$
    /ALIGN_LEFT)
    
  ; Get preview of output file
  wPreviewButton = WIDGET_BUTTON(wPolar2SummaryBase,$
    XOFFSET   = sPreviewPolar2Button.size[0],$
    YOFFSET   = sPreviewPolar2Button.size[1],$
    SCR_XSIZE = sPreviewPolar2Button.size[2],$
    UNAME     = sPreviewPolar2Button.uname,$
    SENSITIVE = sPreviewPolar2Button.sensitive,$
    VALUE     = sPreviewPolar2Button.value)
    
  ;Recap of third Polarization state --------------------------------------------
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  wPolar3SummaryTitle = WIDGET_LABEL(BaseTab,$
    XOFFSET = sPolar3SummaryTitle.size[0],$
    YOFFSET = sPolar3SummaryTitle.size[1],$
    UNAME   = sPolar3SummaryTitle.uname,$
    VALUE   = sPolar3SummaryTitle.value)
    
  ;excluse polar2
  wPolar = WIDGET_BASE(BaseTab,$
    XOFFSET = sTurnOffPolar3.size[0],$
    YOFFSET = sTurnoffPolar3.size[1],$
    /ROW,$
    /NONEXCLUSIVE)
    
  wbutton = WIDGET_BUTTON(wPolar,$
    VALUE = sTurnOffPolar3.value,$
    UNAME = sTurnOffPolar3.uname)
    
  ;Shifting/Scaling parameters used base ----------------------------------------
  wPolar3SummaryBase = WIDGET_BASE(BaseTab,$
    XOFFSET   = sPolar3SummaryBase.size[0],$
    YOFFSET   = sPolar3SummaryBase.size[1],$
    SCR_XSIZE = sPolar3SummaryBase.size[2],$
    SCR_YSIZE = sPolar3SummaryBase.size[3],$
    UNAME     = sPolar3SummaryBase.uname,$
    FRAME     = sPolar3SummaryBase.frame)
    
  ;Table that summarize the files used and the parameters defined ---------------
  wPolar3SummaryTable = WIDGET_TABLE(wPolar3SummaryBase,$
    XOFFSET       = sPolar3SummaryTable.size[0],$
    YOFFSET       = sPolar3SummaryTable.size[1],$
    SCR_XSIZE     = sPolar3SummaryTable.size[2],$
    SCR_YSIZE     = sPolar3SummaryTable.size[3],$
    XSIZE         = sPolar3SummaryTable.size[4],$
    YSIZE         = sPolar3SummaryTable.size[5],$
    UNAME         = sPolar3SummaryTable.uname,$
    SENSITIVE     = sPolar3SummaryTable.sensitive,$
    COLUMN_LABELS = sPolar3SummaryTable.label,$
    COLUMN_WIDTHS = sPolar3SummaryTable.width,$
    ALIGNMENT     = sPolar3SummaryTable.align,$
    /NO_ROW_HEADERS,$
    /EDITABLE,$
    /ROW_MAJOR,$
    /RESIZEABLE_COLUMNS,$
    /SCROLL)
    
  ;label of polarization state used ---------------------------------------------
  wPolar3SummaryPola = $
    WIDGET_LABEL(wPolar3SummaryBase,$
    XOFFSET   = sPolar3SummaryPola.size[0],$
    YOFFSET   = sPolar3SummaryPola.size[1],$
    VALUE     = sPolar3SummaryPola.value)
  wPolar3SummaryPolaValue = $
    WIDGET_LABEL(wPolar3SummaryBase,$
    XOFFSET   = sPolar3SummaryPolaValue.size[0],$
    YOFFSET   = sPolar3SummaryPolaValue.size[1],$
    SCR_XSIZE = sPolar3SummaryPolaValue.size[2],$
    VALUE     = sPolar3SummaryPolaValue.value,$
    UNAME     = sPolar3SummaryPolaValue.uname,$
    /ALIGN_LEFT)
    
  ;repopulate gui button --------------------------------------------------------
  wPolar3Button = WIDGET_BUTTON(wPolar3SummaryBase,$
    XOFFSET   = sPolar3Button.size[0],$
    YOFFSET   = sPolar3Button.size[1],$
    SCR_XSIZE = sPolar3Button.size[2],$
    VALUE     = sPolar3Button.value,$
    UNAME     = sPolar3Button.uname,$
    SENSITIVE = sPolar3Button.sensitive)
    
  ;label of output file name (short file name) ----------------------------------
  wSummaryOutputFileLabel = $
    WIDGET_LABEL(wPolar3SummaryBase,$
    XOFFSET   = sPola3OutputFileLabel.size[0],$
    YOFFSET   = sPola3OutputFileLabel.size[1],$
    VALUE     = sPola3OutputFileLabel.value)
  wSummaryOutputFileValue = $
    WIDGET_LABEL(wPolar3SummaryBase,$
    XOFFSET   = sPola3OutputFileValue.size[0],$
    YOFFSET   = sPola3OutputFileValue.size[1],$
    SCR_XSIZE = sPola3OutputFileValue.size[2],$
    VALUE     = sPola3OutputFileValue.value,$
    UNAME     = sPola3OutputFileValue.uname,$
    /ALIGN_LEFT)
    
  ; Get preview of output file
  wPreviewButton = WIDGET_BUTTON(wPolar3SummaryBase,$
    XOFFSET   = sPreviewPolar3Button.size[0],$
    YOFFSET   = sPreviewPolar3Button.size[1],$
    SCR_XSIZE = sPreviewPolar3Button.size[2],$
    UNAME     = sPreviewPolar3Button.uname,$
    SENSITIVE = sPreviewPolar3Button.sensitive,$
    VALUE     = sPreviewPolar3Button.value)
    
  ;Recap of fourth Polarization state -------------------------------------------
  ;Summary of Shifting/Scaling parameters used base -----------------------------
  wPolar4SummaryTitle = WIDGET_LABEL(BaseTab,$
    XOFFSET = sPolar4SummaryTitle.size[0],$
    YOFFSET = sPolar4SummaryTitle.size[1],$
    UNAME   = sPolar4SummaryTitle.uname,$
    VALUE   = sPolar4SummaryTitle.value)
    
  ;excluse polar2
  wPolar = WIDGET_BASE(BaseTab,$
    XOFFSET = sTurnOffPolar4.size[0],$
    YOFFSET = sTurnoffPolar4.size[1],$
    /ROW,$
    /NONEXCLUSIVE)
    
  wbutton = WIDGET_BUTTON(wPolar,$
    VALUE = sTurnOffPolar4.value,$
    UNAME = sTurnOffPolar4.uname)
    
  ;Shifting/Scaling parameters used base ----------------------------------------
  wPolar4SummaryBase = WIDGET_BASE(BaseTab,$
    XOFFSET   = sPolar4SummaryBase.size[0],$
    YOFFSET   = sPolar4SummaryBase.size[1],$
    SCR_XSIZE = sPolar4SummaryBase.size[2],$
    SCR_YSIZE = sPolar4SummaryBase.size[3],$
    UNAME     = sPolar4SummaryBase.uname,$
    FRAME     = sPolar4SummaryBase.frame)
    
  ;Table that summarize the files used and the parameters defined ---------------
  wPolar4SummaryTable = WIDGET_TABLE(wPolar4SummaryBase,$
    XOFFSET       = sPolar4SummaryTable.size[0],$
    YOFFSET       = sPolar4SummaryTable.size[1],$
    SCR_XSIZE     = sPolar4SummaryTable.size[2],$
    SCR_YSIZE     = sPolar4SummaryTable.size[3],$
    XSIZE         = sPolar4SummaryTable.size[4],$
    YSIZE         = sPolar4SummaryTable.size[5],$
    UNAME         = sPolar4SummaryTable.uname,$
    SENSITIVE     = sPolar4SummaryTable.sensitive,$
    COLUMN_LABELS = sPolar4SummaryTable.label,$
    COLUMN_WIDTHS = sPolar4SummaryTable.width,$
    ALIGNMENT     = sPolar4SummaryTable.align,$
    /NO_ROW_HEADERS,$
    /ROW_MAJOR,$
    /EDITABLE,$    
    /RESIZEABLE_COLUMNS,$
    /SCROLL)
    
  ;label of polarization state used ---------------------------------------------
  wPolar4SummaryPola = $
    WIDGET_LABEL(wPolar4SummaryBase,$
    XOFFSET   = sPolar4SummaryPola.size[0],$
    YOFFSET   = sPolar4SummaryPola.size[1],$
    VALUE     = sPolar4SummaryPola.value)
  wPolar4SummaryPolaValue = $
    WIDGET_LABEL(wPolar4SummaryBase,$
    XOFFSET   = sPolar4SummaryPolaValue.size[0],$
    YOFFSET   = sPolar4SummaryPolaValue.size[1],$
    SCR_XSIZE = sPolar4SummaryPolaValue.size[2],$
    VALUE     = sPolar4SummaryPolaValue.value,$
    UNAME     = sPolar4SummaryPolaValue.uname,$
    /ALIGN_LEFT)
    
  ;repopulate gui button --------------------------------------------------------
  wPolar4Button = WIDGET_BUTTON(wPolar4SummaryBase,$
    XOFFSET   = sPolar4Button.size[0],$
    YOFFSET   = sPolar4Button.size[1],$
    SCR_XSIZE = sPolar4Button.size[2],$
    VALUE     = sPolar4Button.value,$
    UNAME     = sPolar4Button.uname,$
    SENSITIVE = sPolar4Button.sensitive)
    
  ;label of output file name (short file name) ----------------------------------
  wSummaryOutputFileLabel = $
    WIDGET_LABEL(wPolar4SummaryBase,$
    XOFFSET   = sPola4OutputFileLabel.size[0],$
    YOFFSET   = sPola4OutputFileLabel.size[1],$
    VALUE     = sPola4OutputFileLabel.value)
  wSummaryOutputFileValue = $
    WIDGET_LABEL(wPolar4SummaryBase,$
    XOFFSET   = sPola4OutputFileValue.size[0],$
    YOFFSET   = sPola4OutputFileValue.size[1],$
    SCR_XSIZE = sPola4OutputFileValue.size[2],$
    VALUE     = sPola4OutputFileValue.value,$
    UNAME     = sPola4OutputFileValue.uname,$
    /ALIGN_LEFT)
    
  ; Get preview of output file
  wPreviewButton = WIDGET_BUTTON(wPolar4SummaryBase,$
    XOFFSET   = sPreviewPolar4Button.size[0],$
    YOFFSET   = sPreviewPolar4Button.size[1],$
    SCR_XSIZE = sPreviewPolar4Button.size[2],$
    UNAME     = sPreviewPolar4Button.uname,$
    SENSITIVE = sPreviewPolar4Button.sensitive,$
    VALUE     = sPreviewPolar4Button.value)
    
END
