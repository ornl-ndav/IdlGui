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


  settingsTabBaseColumns = WIDGET_BASE(baseWidget, COLUMN=2)
  settingsTabCol1 = WIDGET_BASE(settingsTabBaseColumns, /COLUMN)
  settingsTabCol2 = WIDGET_BASE(settingsTabBaseColumns, /COLUMN)
  
  ; === Custom execution queue name ===
  
  customQueueBase = WIDGET_BASE(settingsTabCol1)
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
  
  outputPrefixBase = WIDGET_BASE(settingsTabCol1)
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
  
  ; Get the current name and display it
  myCommandObj->GetProperty, OutputPrefix=outputPrefixName
  WIDGET_CONTROL, outputPrefixID, SET_VALUE=outputPrefixName
  
  
  ; === Normalisation file locations ===
  normlocationBase = WIDGET_BASE(settingsTabCol1)
  normlocationLabel = WIDGET_LABEL(normlocationBase, VALUE=' Normalisation Directory ', XOFFSET=5)
  normlocationLabelGeometry = WIDGET_INFO(normlocationLabel, /GEOMETRY)
  normlocationLabelYSize = normlocationLabelGeometry.ysize
  normlocationPrettyBase = WIDGET_BASE(normlocationBase, /FRAME, /COLUMN, XPAD=10, YPAD=10, YOFFSET=normlocationLabelYSize/2.0)
  normlocationRow = WIDGET_BASE(normlocationPrettyBase, /ROW)
  normlocationButtons = WIDGET_BASE(normlocationRow, EXCLUSIVE=1)
  instrumentSharedButtonID = WIDGET_BUTTON(normlocationButtons, VALUE='Instrument Shared', $
    UNAME='DGS_NORMLOC_INST_SHARED', UVALUE='DGS_NORMLOC_INST_SHARED')
  proposalSharedButtonID = WIDGET_BUTTON(normlocationButtons, VALUE='Proposal Shared', $
    UNAME='DGS_NORMLOC_PROP_SHARED', UVALUE='DGS_NORMLOC_PROP_SHARED')
  HomeDirButtonID = WIDGET_BUTTON(normlocationButtons, VALUE='Home Directory', $
    UNAME='DGS_NORMLOC_HOME_DIR', UVALUE='DGS_NORMLOC_HOME_DIR')
    
  ; Make Proposal Shared the default.
  WIDGET_CONTROL, proposalSharedButtonID, SET_BUTTON=1
  myCommandObj->SetProperty, NormLocation='PROP'
  
  ; === dgs_reduction timing ===
  timingBase = WIDGET_BASE(settingsTabCol1)
  timingLabel = WIDGET_LABEL(timingBase, VALUE=' Diagnostic Timing ', XOFFSET=5)
  timingLabelGeometry = WIDGET_INFO(timingLabel, /GEOMETRY)
  timingLabelYSize = timingLabelGeometry.ysize
  timingPrettyBase = WIDGET_BASE(timingBase, /FRAME, /ROW, XPAD=10, YPAD=10, YOFFSET=timingLabelYSize/2.0)
  timingRow = WIDGET_BASE(timingPrettyBase, /ROW)
  timingButtons = WIDGET_BASE(timingRow, /ROW, EXCLUSIVE=1)
  timingOnID = WIDGET_BUTTON(timingButtons, Value=' ON  ', UNAME='DGS_TIMING_ON', UVALUE='DGS_TIMING_ON')
  timingOffID = WIDGET_BUTTON(timingButtons, Value=' OFF  ', UNAME='DGS_TIMING_OFF', UVALUE='DGS_TIMING_OFF')
  ; Make off the default
  WIDGET_CONTROL, timingOffID, SET_BUTTON=1
  
  
  ; === Field to specify the Corner Geometry File ===
  cornerGeomBase = WIDGET_BASE(settingsTabCol2)
  cornerGeomLabel = WIDGET_LABEL(cornerGeomBase, VALUE=' Corner Geometry File ', XOFFSET=5)
  cornerGeomLabelGeometry = WIDGET_INFO(cornerGeomLabel, /GEOMETRY)
  cornerGeomLabelYSize = cornerGeomLabelGeometry.ysize
  cornerGeomPrettyBase = WIDGET_BASE(cornerGeomBase, /FRAME, /ROW, XPAD=10, YPAD=10, YOFFSET=cornerGeomLabelYSize/2.0)
  
  customCornerGeomRow = WIDGET_BASE(cornerGeomPrettyBase, /ROW)
  customCornerGeomButtons = WIDGET_BASE(customCornerGeomRow, EXCLUSIVE=1)
  
  autoCornerGeomSelectionButtonID = WIDGET_BUTTON(customCornerGeomButtons, VALUE='Automatic', $
    UNAME='DGS_AUTO_CORNERGEOM', UVALUE='DGS_AUTO_CORNERGEOM')
  customCornerGeomSelectionButtonID = WIDGET_BUTTON(customCornerGeomButtons, VALUE='Custom', $
    UNAME='DGS_CUSTOM_CORNERGEOM', UVALUE='DGS_CUSTOM_CORNERGEOM')
    
  cornerGeomNameID = CW_FIELD(customCornerGeomRow, YSIZE=1, XSIZE=30, TITLE="  Corner Geometry Filename:", $
    UNAME="DGS_CORNER_GEOMETRY", UVALUE="DGS_CORNER_GEOMETRY", /ALL_EVENTS)
    
  ; Make 'Automatic' the default
  WIDGET_CONTROL, autoCornerGeomSelectionButtonID, SET_BUTTON=1
  WIDGET_CONTROL, cornerGeomNameID, SENSITIVE=0
  
  ; Get the current file name and display it
  myCommandObj->GetProperty, CornerGeometry=cornerGeomertyFilename
  WIDGET_CONTROL, cornerGeomNameID, SET_VALUE=cornerGeomertyFilename
  
  ; === Instrument Geometry Override ===
  instGeomBase = WIDGET_BASE(settingsTabCol2)
  instGeomLabel = WIDGET_LABEL(instGeomBase, VALUE=' Instrument Geometry File ', XOFFSET=5)
  instGeomLabelGeometry = WIDGET_INFO(instGeomLabel, /GEOMETRY)
  instGeomLabelYSize = instGeomLabelGeometry.ysize
  instGeomPrettyBase = WIDGET_BASE(instGeomBase, /FRAME, /ROW, XPAD=10, YPAD=10, YOFFSET=instGeomLabelYSize/2.0)
  
  customInstGeomRow = WIDGET_BASE(instGeomPrettyBase, /ROW)
  customInstGeomButtons = WIDGET_BASE(customInstGeomRow, EXCLUSIVE=1)
  
  autoInstGeomSelectionButtonID = WIDGET_BUTTON(customInstGeomButtons, VALUE='Automatic', $
    UNAME='DGS_AUTO_INSTGEOM', UVALUE='DGS_AUTO_INSTGEOM')
  customInstGeomSelectionButtonID = WIDGET_BUTTON(customInstGeomButtons, VALUE='Custom', $
    UNAME='DGS_CUSTOM_INSTGEOM', UVALUE='DGS_CUSTOM_INSTGEOM')
    
  instGeomNameID = CW_FIELD(customInstGeomRow, YSIZE=1, XSIZE=30, TITLE="  Instrument Geometry Filename:", $
    UNAME="DGS_INST_GEOMETRY", UVALUE="DGS_INST_GEOMETRY", /ALL_EVENTS)
    
  ; Make 'Automatic' the default
  WIDGET_CONTROL, autoInstGeomSelectionButtonID, SET_BUTTON=1
  WIDGET_CONTROL, instGeomNameID, SENSITIVE=0
  
  ; === Proton Current Units ===
  protonUnitsBase = WIDGET_BASE(settingsTabCol2)
  protonUnitsLabel = WIDGET_LABEL(protonUnitsBase, VALUE=' Proton Current Units ', XOFFSET=5)
  protonUnitsLabelGeometry = WIDGET_INFO(protonUnitsLabel, /GEOMETRY)
  protonUnitsLabelYSize = protonUnitsLabelGeometry.ysize
  protonUnitsPrettyBase = WIDGET_BASE(protonUnitsBase, /FRAME, /ROW, XPAD=10, YPAD=10, $
    YOFFSET=protonUnitsLabelYSize/2.0)
    
  protonUnitsColumn = WIDGET_BASE(protonUnitsPrettyBase, /COLUMN)
  protonUnitsButtons = WIDGET_BASE(protonUnitsColumn, EXCLUSIVE=1)
  
  coulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Coulombs (Recommended)', $
    UNAME='DGS_PROTON_UNITS_COULOMB', UVALUE='DGS_PROTON_UNITS_COULOMB')
  millCoulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Milli-Coulombs (mC)', $
    UNAME='DGS_PROTON_UNITS_MILLICOULOMB', UVALUE='DGS_PROTON_UNITS_MILLICOULOMB')
  microCoulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Micro-Coulombs (uC)', $
    UNAME='DGS_PROTON_UNITS_MICROCOULOMB', UVALUE='DGS_PROTON_UNITS_MICROCOULOMB')
  picoCoulombButtonID = WIDGET_BUTTON(protonUnitsButtons, VALUE='Pico-Coulombs (pC)', $
    UNAME='DGS_PROTON_UNITS_PICOCOULOMB', UVALUE='DGS_PROTON_UNITS_PICOCOULOMB')
    
  ; Make 'Coulombs' the default
  WIDGET_CONTROL, coulombButtonID, SET_BUTTON=1
  myCommandObj->SetProperty, ProtonCurrentUnits='C'
  
END