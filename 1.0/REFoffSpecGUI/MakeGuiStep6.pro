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
                  value: '~/',$
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
                            value: '~/'}

;Summary of Shifting/Scaling parameters used base -----------------------------
XYoff = [0,15]
sSummaryBase = { size: [sOutputFileBase.size[0]+XYoff[0],$
                        sOutputFileBase.size[1]+$
                        sOutputFileBase.size[3]+XYoff[1],$
                        618,400],$
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
                  sensitive: 1,$
                  label: ['Name of files used',$
                          'Shifting',$
                          'Scaling'],$
                  align: TableAlign,$
                  width: [394,100,100]}

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
                                   500],$
                            value: 'N/A',$
                            uname: 'summary_output_file_name_value'}

;Recap of Second Polarization state -------------------------------------------
;Summary of Shifting/Scaling parameters used base -----------------------------
XYoff = [10,0]
sPolar2SummaryBase = { size: [sSummaryBase.size[0]+$
                              sSummaryBase.size[2]+XYoff[0],$
                              sSummaryBase.size[1]+XYoff[1],$
                              sSummaryBase.size[2],$
                              200],$
                       uname: 'polarization_state2_summary_base',$
                       frame: 1}

XYoff = [20,-8]                 ;title
sPolar2SummaryTitle = { size: [sPolar2SummaryBase.size[0]+XYoff[0],$
                               sPolar2SummaryBase.size[1]+XYoff[1]],$
                        value: 'Recap. of parameters that will be used for' + $
                        ' Polarization state #2'}

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
                                'Shifting',$
                                'Scaling'],$
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
                                   500],$
                            value: 'N/A',$
                            uname: 'summary_polar2_value'}








;Get preview of output file ---------------------------------------------------
XYoff = [0,500]
sPreviewButton = { size: [sOutputFileBase.size[0]+XYoff[0],$
                          sOutputFileBase.size[1]+$
                          sOutputFileBase.size[3]+XYoff[1],$
                          300],$
                   value: 'PREVIEW OF OUTPUT FILE',$
                   sensitive: 0,$
                   uname: 'create_output_file_preview_button'}

;Create output file button ----------------------------------------------------
XYoff = [0,0]
sCreateOutput = { size: [sPreviewButton.size[0]+$
                         sPreviewButton.size[2]+$
                         XYoff[0],$
                         sPreviewButton.size[1]+$
                         XYoff[1],$
                         500],$
                  value: 'CREATE OUTPUT FILE',$
                  sensitive: 0,$
                  uname: 'create_output_file_create_button'}











;******************************************************************************
;            BUILD GUI
;******************************************************************************

BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab.uname,$
                      XOFFSET   = sBaseTab.size[0],$
                      YOFFSET   = sBaseTab.size[1],$
                      SCR_XSIZE = sBaseTab.size[2],$
                      SCR_YSIZE = sBaseTab.size[3],$
                      TITLE     = sBaseTab.title)

;Output file name frame -------------------------------------------------------
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
                             /RESIZEABLE_COLUMNS)

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

;Recap of Second Polarization state -------------------------------------------
;Summary of Shifting/Scaling parameters used base -----------------------------
wPolar2SummaryTitle = WIDGET_LABEL(BaseTab,$
                             XOFFSET = sPolar2SummaryTitle.size[0],$
                             YOFFSET = sPolar2SummaryTitle.size[1],$
                             VALUE   = sPolar2SummaryTitle.value)

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
                             /RESIZEABLE_COLUMNS)

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















;Get preview of output file 
wPreviewButton = WIDGET_BUTTON(BaseTab,$
                               XOFFSET   = sPreviewButton.size[0],$
                               YOFFSET   = sPreviewButton.size[1],$
                               SCR_XSIZE = sPreviewButton.size[2],$
                               UNAME     = sPreviewButton.uname,$
                               SENSITIVE = sPreviewButton.sensitive,$
                               VALUE     = sPreviewButton.value)

;Create output file button
wCreateButton = WIDGET_BUTTON(BaseTab,$
                              XOFFSET   = sCreateOutput.size[0],$
                              YOFFSET   = sCreateOutput.size[1],$
                              SCR_XSIZE = sCreateOutput.size[2],$
                              UNAME     = sCreateOutput.uname,$
                              SENSITIVE = sCreateOutput.sensitive,$
                              VALUE     = sCreateOutput.value)


END
