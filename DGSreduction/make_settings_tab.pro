;+
; :Copyright:
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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Description:
;    Constructs the Settings Tab for the given command object 'myCommandObj' 
;    and as a child of 'baseWidget'.
;
; :Params:
;    baseWidget
;    myCommandObj
;
; :Author: scu
;-
PRO make_settings_tab, baseWidget, myCommandObj

  ; === Custom execution queue name ===
  
  customQueueBase = WIDGET_BASE(baseWidget)
  customQueueLabel = WIDGET_LABEL(customQueueBase, VALUE=' SLURM Queue Selection ', XOFFSET=5)
  customQueueLabelGeometry = WIDGET_INFO(customQueueLabel, /GEOMETRY)
  customQueueLabelYSize = customQueueLabelGeometry.ysize
  
  customQueuePrettyBase = WIDGET_BASE(customQueueBase, /FRAME, /ROW, $
    XPAD=10, YPAD=10, YOFFSET=customQueueLabelYSize/2.0)
  
  customQueueRow = WIDGET_BASE(customQueuePrettyBase, /ROW)

  
  customQueueButtons = WIDGET_BASE(customQueueRow, EXCLUSIVE=1)
  autoSLURMQueueSelectionButtonID = WIDGET_BUTTON(customQueueButtons, VALUE='Automatic', $
    UNAME='DGS_AUTO_SLURM', UVALUE='DGS_AUTO_SLURM')
  customSLURMQueueSelectionButtonID = WIDGET_BUTTON(customQueueButtons, VALUE='Custom', $
    UNAME='DGS_CUSTOM_SLURM', UVALUE='DGS_CUSTOM_SLURM')

  queueNameID = CW_FIELD(customQueueRow, YSIZE=1, XSIZE=30, TITLE="  SLURM Queue:", $
    UNAME="DGS_SLURM_QUEUE", UVALUE="DGS_SLURM_QUEUE", /ALL_EVENTS)

  ; Make 'Automatic' the default 
  WIDGET_CONTROL, autoSLURMQueueSelectionButtonID, SET_BUTTON=1
  WIDGET_CONTROL, queueNameID, SENSITIVE=0
  
  ; Get the current Queue name and display it
  myCommandObj->GetProperty, Queue=queueName
  WIDGET_CONTROL, queueNameID, SET_VALUE=queueName

  
  ; === Output Prefix ===
  
  outputPrefixBase = WIDGET_BASE(baseWidget)
  outputPrefixLabel = WIDGET_LABEL(outputPrefixBase, VALUE=' Output Directory ', XOFFSET=5)
  outputPrefixLabelGeometry = WIDGET_INFO(outputPrefixLabel, /GEOMETRY)
  outputPrefixLabelYSize = outputPrefixLabelGeometry.ysize
  outputPrefixPrettyBase = WIDGET_BASE(outputPrefixBase, /FRAME, /COLUMN, XPAD=10, YPAD=10, YOFFSET=outputPrefixLabelYSize/2.0)
  outputPrefixRow = WIDGET_BASE(outputPrefixPrettyBase, /ROW)
  outputPrefixButtons = WIDGET_BASE(outputPrefixRow, EXCLUSIVE=1)
  autoOutputPrefixButtonID = WIDGET_BUTTON(outputPrefixButtons, VALUE='Automatic', $
    UNAME='DGS_AUTO_OUTPUT_PREFIX', UVALUE='DGS_AUTO_OUTPUT_PREFIX')
  forceHomeOutputButtonID = WIDGET_BUTTON(outputPrefixButtons, VALUE='Force Home Directory', $
    UNAME='DGS_FORCE_HOME_OUTPUT', UVALUE='DGS_FORCE_HOME_OUTPUT')
  customOutputPrefixButtonID = WIDGET_BUTTON(outputPrefixButtons, VALUE='Custom', $
    UNAME='DGS_CUSTOM_OUTPUT_PREFIX', UVALUE='DGS_CUSTOM_OUTPUT_PREFIX')
  outputPrefixID = CW_FIELD(outputPrefixRow, YSIZE=1, XSIZE=30, TITLE='Directory:', $
    UNAME='DGS_OUTPUT_PREFIX', UVALUE='DGS_OUTPUT_PREFIX', /ALL_EVENTS)
    
  outputFeedbackRow = WIDGET_BASE(outputPrefixPrettyBase, /ROW)
  outputDirectoryLabel1 = WIDGET_LABEL(outputFeedbackRow, VALUE='Current output will be written to ')
  outputDirectoryLabel2 = WIDGET_LABEL(outputFeedbackRow, VALUE='<unknown>', $
    UNAME='DGS_OUTPUT_DIRECTORY_LABEL', $
    XSIZE=300, ALIGN_LEFT=1)
  
  ; Make 'Automatic' the default 
  WIDGET_CONTROL, autoOutputPrefixButtonID, SET_BUTTON=1
  WIDGET_CONTROL, outputPrefixID, SENSITIVE=0
  
  ; Get the current Queue name and display it
  myCommandObj->GetProperty, OutputPrefix=outputPrefixName
  WIDGET_CONTROL, outputPrefixID, SET_VALUE=outputPrefixName
  
  ; === dgs_reduction timing ===
  timingBase = WIDGET_BASE(baseWidget)
  timingLabel = WIDGET_LABEL(timingBase, VALUE=' Diagnostic Timing ', XOFFSET=5)
  timingLabelGeometry = WIDGET_INFO(timingLabel, /GEOMETRY)
  timingLabelYSize = timingLabelGeometry.ysize
  timingPrettyBase = WIDGET_BASE(timingBase, /FRAME, /COLUMN, XPAD=10, YPAD=10, YOFFSET=timingLabelYSize/2.0)
  timingRow = WIDGET_BASE(timingPrettyBase, /ROW)
  timingButtons = WIDGET_BASE(timingRow, EXCLUSIVE=1)
  timingOnID = WIDGET_BUTTON(timingButtons, Value='ON', UNAME='DGS_TIMING_ON', UVALUE='DGS_TIMING_ON')
  timingOffID = WIDGET_BUTTON(timingButtons, Value='OFF', UNAME='DGS_TIMING_OFF', UVALUE='DGS_TIMING_OFF') 
  ; Make off the default
  WIDGET_CONTROL, timingOffID, SET_BUTTON=1
END