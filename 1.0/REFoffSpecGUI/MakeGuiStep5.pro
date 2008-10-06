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

PRO make_gui_step5, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step5_tab_base',$
             title: TabTitles.step5}
                         
;Output file name frame -------------------------------------------------------
XYoff = [10,15] ;base
sOutputFileBase = { size: [XYoff[0],$
                           XYoff[1],$
                           800,110],$
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
                             715],$
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
                                   600],$
                            uname: 'create_output_full_file_name_' + $
                            'preview_value',$
                            value: '~/'}

;Get preview of output file ---------------------------------------------------
XYoff = [0,15]
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
