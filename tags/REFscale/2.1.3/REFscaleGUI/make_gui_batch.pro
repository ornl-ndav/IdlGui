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

PRO MakeGuiLoadBatch, STEPS_TAB, StepsTabSize

;******************************************************************************
;Define Parameters
;******************************************************************************
sLoadBatchBase = { size:  [0,0,StepsTabSize[2:3]],$
                   uname: 'load_batch_base',$
                   title: 'BATCH'}

;Load Batch File Button -------------------------------------------------------
XYoff = [5,5]
sLoadBatchButton = { size:  [XYoff[0],$
                             XYoff[1],$
                             135,30],$
                     value: 'Load Batch File ...',$
                     uname: 'load_batch_file_button'}

;Load Batch File Text ---------------------------------------------------------
XYoff = [5,0]
sLoadBatchText = { size:  [sLoadBatchButton.size[0]+ $
                           sLoadBatchButton.size[2]+XYoff[0],$
                           sLoadBatchButton.size[1]+XYoff[1],$
                           300,30],$
                   uname: 'load_batch_file_text_field'}

;Preview Button ---------------------------------------------------------------
XYoff = [5,0]
sPreviewBatch = { size:  [sLoadBatchText.size[0]+$
                          sLoadBatchText.size[2]+XYoff[0],$
                          sLoadBatchText.size[1],$
                          70,30],$
                  value: 'PREVIEW',$
                  uname: 'batch_preview_button'}

;Batch Table ------------------------------------------------------------------
XYoff = [0,5]
NbrRow     = 20
NbrColumn  = 5
RowAlign   = [0,0,0,1,1]
TableAlign = INTARR(NbrColumn,NbrRow)
FOR i=0,(NbrRow-1) DO BEGIN
    TableAlign(*,i)=RowAlign
ENDFOR
dTable = { size      : [XYoff[0], $
                        sLoadBatchButton.size[1]+sLoadBatchButton.size[3]+ $
                        XYoff[1], $
                        StepsTabSize[2]-5, $
                        300, $
                        NbrColumn, $
                        NbrRow],$
           uname     : 'ref_scale_batch_table_widget',$
           sensitive : 1,$
           label     : ['ACTIVE',$
                        'DATA RUNS', $
                        'NORM. RUNS',$
                        'SF',$
                        'DATE'],$
           align        : TableAlign,$
           column_width : [40,140,140,70,160]}

;Refresh bash file button -----------------------------------------------------
XYoff = [0,5]
sRefreshButton = { size:      [XYoff[0],$
                               dTable.size[1]+dTable.size[3]+XYoff[1],$
                               260,30],$
                   uname:     'ref_scale_refresh_batch_file',$
                   value:     'SAVE BATCH FILE',$
                   sensitive: 0}

;SAVE AS bash file button
XYOff = [5,0]
sSaveAsButton = { size:      [sRefreshButton.size[0]+sRefreshButton.size[2]+ $
                              XYoff[0],$
                              sRefreshButton.size[1]+XYoff[1],$
                              sRefreshButton.size[2:3]],$
                  uname:     'ref_scale_save_as_batch_file',$
                  value:     'SAVE BATCH FILE AS ...',$
                  sensitive: 0}


;******************************************************************************
;Build GUI
;******************************************************************************
wLoadBatchBase = WIDGET_BASE(STEPS_TAB,$
                           UNAME     = sLoadBatchBase.uname,$
                           XOFFSET   = sLoadBatchBase.size[0],$
                           YOFFSET   = sLoadBatchBase.size[1],$
                           SCR_XSIZE = sLoadBatchBase.size[2],$
                           SCR_YSIZE = sLoadBatchBase.size[3],$
                           TITLE     = sLoadBatchBase.title)

;Load Batch File Button -------------------------------------------------------
wLoadBatchButton = WIDGET_BUTTON(wLoadBatchBase,$
                                 XOFFSET   = sLoadBatchButton.size[0],$
                                 YOFFSET   = sLoadBatchButton.size[1],$
                                 SCR_XSIZE = sLoadBatchButton.size[2],$
                                 SCR_YSIZE = sLoadBatchButton.size[3],$
                                 UNAME     = sLoadBatchButton.uname,$
                                 VALUE     = sLoadBatchButton.value)

;Load Batch File Text ---------------------------------------------------------
wLoadBatchText = WIDGET_TEXT(wLoadBatchBase,$
                             XOFFSET   = sLoadBatchText.size[0],$
                             YOFFSET   = sLoadBatchText.size[1],$
                             SCR_XSIZE = sLoadBatchText.size[2],$
                             UNAME     = sLoadBatchText.uname,$
                             /ALIGN_LEFT)

;Preview Button ---------------------------------------------------------------
wPreviewBatch = WIDGET_BUTTON(wLoadBatchBase,$
                              XOFFSET   = sPreviewBatch.size[0],$
                              YOFFSET   = sPreviewBatch.size[1],$
                              SCR_XSIZE = sPreviewBatch.size[2],$
                              SCR_YSIZE = sPreviewBatch.size[3],$
                              VALUE     = sPreviewBatch.value,$
                              UNAME     = sPreviewBatch.uname)


;Table Widget -----------------------------------------------------------------
wTable = WIDGET_TABLE(wLoadBatchBase,$
                      XOFFSET       = dTable.size[0],$
                      YOFFSET       = dTable.size[1],$
                      SCR_XSIZE     = dTable.size[2],$
                      SCR_YSIZE     = dTable.size[3],$
                      XSIZE         = dTable.size[4],$
                      YSIZE         = dTable.size[5],$
                      UNAME         = dTable.uname,$
                      SENSITIVE     = dTable.sensitive,$
                      COLUMN_LABELS = dTable.label,$
                      COLUMN_WIDTHS = dTable.column_width,$
                      ALIGNMENT     = dTable.align,$
                      /NO_ROW_HEADERS,$
                      /ROW_MAJOR,$
                      /RESIZEABLE_COLUMNS,$
                      /ALL_EVENTS)


;Refresh Bash File Button -----------------------------------------------------
wRefreshButton = WIDGET_BUTTON(wLoadBatchBase,$
                               XOFFSET   = sRefreshButton.size[0],$
                               YOFFSET   = sRefreshButton.size[1],$
                               SCR_XSIZE = sRefreshButton.size[2],$
                               UNAME     = sRefreshButton.uname,$
                               VALUE     = sRefreshButton.value,$
                               SENSITIVE = sRefreshButton.sensitive)

;Save as Bash File Button -----------------------------------------------------
wSaveAsButton = WIDGET_BUTTON(wLoadBatchBase,$
                              XOFFSET   = sSaveAsButton.size[0],$
                              YOFFSET   = sSaveAsButton.size[1],$
                              SCR_XSIZE = sSaveAsButton.size[2],$
                              UNAME     = sSaveAsButton.uname,$
                              VALUE     = sSaveAsButton.value,$
                              SENSITIVE = sSaveAsButton.sensitive)

END

;------------------------------------------------------------------------------
PRO make_gui_batch
END
