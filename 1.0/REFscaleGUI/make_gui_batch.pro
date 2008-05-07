;===============================================================================
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
;===============================================================================

PRO MakeGuiLoadBatch, STEPS_TAB, StepsTabSize

;*******************************************************************************
;Define Parameters
;*******************************************************************************
sLoadBatchBase = { size:  [0,0,StepsTabSize[2:3]],$
                   uname: 'load_batch_base',$
                   title: 'BATCH'}

;Load Batch File Button --------------------------------------------------------
XYoff = [5,5]
sLoadBatchButton = { size:  [XYoff[0],$
                             XYoff[1],$
                             135,30],$
                     value: 'Load Batch File ...',$
                     uname: 'load_batch_file_button'}

;Load Batch File Text ----------------------------------------------------------
XYoff = [5,0]
sLoadBatchText = { size:  [sLoadBatchButton.size[0]+ $
                           sLoadBatchButton.size[2]+XYoff[0],$
                           sLoadBatchButton.size[1]+XYoff[1],$
                           300,30],$
                   uname: 'load_batch_file_text_field'}

;Preview Button ----------------------------------------------------------------
XYoff = [5,0]
sPreviewBatch = { size:  [sLoadBatchText.size[0]+$
                          sLoadBatchText.size[2]+XYoff[0],$
                          sLoadBatchText.size[1],$
                          70,30],$
                  value: 'PREVIEW',$
                  uname: 'batch_preview_button'}

;*******************************************************************************
;Build GUI
;*******************************************************************************
wLoadBatchBase = WIDGET_BASE(STEPS_TAB,$
                           UNAME     = sLoadBatchBase.uname,$
                           XOFFSET   = sLoadBatchBase.size[0],$
                           YOFFSET   = sLoadBatchBase.size[1],$
                           SCR_XSIZE = sLoadBatchBase.size[2],$
                           SCR_YSIZE = sLoadBatchBase.size[3],$
                           TITLE     = sLoadBatchBase.title)

;Load Batch File Button --------------------------------------------------------
wLoadBatchButton = WIDGET_BUTTON(wLoadBatchBase,$
                                 XOFFSET   = sLoadBatchButton.size[0],$
                                 YOFFSET   = sLoadBatchButton.size[1],$
                                 SCR_XSIZE = sLoadBatchButton.size[2],$
                                 SCR_YSIZE = sLoadBatchButton.size[3],$
                                 UNAME     = sLoadBatchButton.uname,$
                                 VALUE     = sLoadBatchButton.value)

;Load Batch File Text ----------------------------------------------------------
wLoadBatchText = WIDGET_TEXT(wLoadBatchBase,$
                             XOFFSET   = sLoadBatchText.size[0],$
                             YOFFSET   = sLoadBatchText.size[1],$
                             SCR_XSIZE = sLoadBatchText.size[2],$
                             UNAME     = sLoadBatchText.uname,$
                             /ALIGN_LEFT)

;Preview Button ----------------------------------------------------------------
wPreviewBatch = WIDGET_BUTTON(wLoadBatchBase,$
                              XOFFSET   = sPreviewBatch.size[0],$
                              YOFFSET   = sPreviewBatch.size[1],$
                              SCR_XSIZE = sPreviewBatch.size[2],$
                              SCR_YSIZE = sPreviewBatch.size[3],$
                              VALUE     = sPreviewBatch.value,$
                              UNAME     = sPreviewBatch.uname)






END


PRO make_gui_batch
END
