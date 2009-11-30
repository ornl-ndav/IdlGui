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
    uname: 'reduce_tab3_base',$
    title: tab_title}
    
  ;- Time Zero offset (microS) --------------------------------------------------
  XYoff = [10,5] ;title
  sTZObase = { size: [XYoff[0],$
    XYoff[1],$
    tab_size[2]-30, $
    45],$
    frame: 1,$
    uname: 'time_zero_offset_base'}
  XYoff = [20,-8]
  sTZOtitle = { size: [sTZObase.size[0]+XYoff[0],$
    sTZObase.size[1]+XYoff[1]],$
    value: 'Time Zero Offset (microS)'}
    
  XYoff = [50,15]
  sTZO_detector_value = {size:  [XYoff[0],$
    XYoff[1]],$
    value: 'Detector:'}
  XYoff = [65,-5]
  sTZO_detector_field = {size:  [sTZO_detector_value.size[0]+XYoff[0],$
    sTZO_detector_value.size[1]+XYoff[1],$
    70,30],$
    value: '0.0',$
    uname: 'time_zero_offset_detector_uname'}
  XYoff = [120,0]
  sTZO_beam_value = {size:  [sTZO_detector_field.size[0]+XYoff[0],$
    sTZO_detector_value.size[1]+XYoff[1]],$
    value: 'Beam Monitor:'}
  XYoff = [90,0]
  sTZO_beam_field = {size:  [sTZO_beam_value.size[0]+XYoff[0],$
    sTZO_detector_field.size[1]+XYoff[1],$
    sTZO_detector_field.size[2:3]],$
    value: '0.0',$
    uname: 'time_zero_offset_beam_monitor_uname'}
  XYOff = [60,0]
  sTZOhelp = { size: [sTZO_beam_field.size[0]+sTZO_beam_field.size[2]+XYoff[0],$
    sTZO_beam_value.size[1]+XYoff[1]],$
    value: '(Specify the time zero offset in microseconds of the ' +$
    'Detector and the Monitor)'}
    
  ;- Monitor Efficiency ---------------------------------------------------------
  XYoff = [0,20] ;title
  sMEbase = { size: [sTZOBase.size[0]+XYoff[0],$
    sTZObase.size[1]+sTZObase.size[3]+XYoff[1],$
    sTZObase.size[2:3]], $
    frame: 1,$
    sensitive: 1,$
    uname: 'time_zero_offset_base'}
  XYoff = [20,-8]
  sMEtitle = { size: [sMEbase.size[0]+XYoff[0],$
    sMEbase.size[1]+XYoff[1]],$
    value: 'Monitor Efficiency'}
    
  XYoff = [50,10]
  sMEgroup = { size: [sTZO_detector_value.size[0]+XYoff[0],$
    XYoff[1]],$
    uname: 'monitor_efficiency_group',$
    list: ['YES','NO'],$
    value: 1.0}
  XYoff = [0,5]
  sMElabel = { size: [sTZO_beam_value.size[0]+XYoff[0],$
    sMEgroup.size[1]+XYoff[1]],$
    uname: 'monitor_efficiency_constant_label',$
    value: 'Value:'}
  XYoff = [50,-6]
  sMEvalue = { size: [sMElabel.size[0]+XYoff[0],$
    sMElabel.size[1]+XYoff[1],$
    sTZO_detector_field.size[2:3]],$
    value: '',$
    uname: 'monitor_efficiency_constant_value'}
  XYoff = [0,0]
  sMEhelp = { size: [sTZOhelp.size[0]+XYoff[0],$
    sMElabel.size[1]+XYoff[1]],$
    value: '(Specify the monitor efficiency constant in 1/Angstroms)'}
    
  ;- Detector Efficiency ---------------------------------------------------------
  XYoff = [0,20] ;title
  sDEbase = { size: [sMEBase.size[0]+XYoff[0],$
    sMEbase.size[1]+sMEbase.size[3]+XYoff[1],$
    sMEbase.size[2:3]], $
    frame: 1,$
    sensitive: 1,$
    uname: 'detector_efficiency_base'}
  XYoff = [20,-8]
  sDEtitle = { size: [sDEbase.size[0]+XYoff[0],$
    sDEbase.size[1]+XYoff[1]],$
    value: 'Detector Efficiency'}
    
  XYoff = [50,10]
  sDEgroup = { size: [sTZO_detector_value.size[0]+XYoff[0],$
    XYoff[1]],$
    uname: 'detector_efficiency_group',$
    list: ['YES','NO'],$
    value: 1.0}
  XYoff = [0,5]
  sDElabel = { size: [sTZO_beam_value.size[0]+XYoff[0],$
    sDEgroup.size[1]+XYoff[1]],$
    uname: 'detector_efficiency_scaling_label',$
    sensitive: 0,$
    value: 'Scaling:'}
  XYoff = [55,-6]
  sDEvalue = { size: [sDElabel.size[0]+XYoff[0],$
    sDElabel.size[1]+XYoff[1],$
    sTZO_detector_field.size[2:3]],$
    value: '',$
    sensitive: 0,$
    uname: 'detector_efficiency_scaling_value'}
    
  XYoff = [100,5]
  sDEAlabel = { size: [sDEvalue.size[0]+XYoff[0],$
    sDEgroup.size[1]+XYoff[1]],$
    uname: 'detector_efficiency_attenuator_label',$
    sensitive: 0,$
    value: 'Attenuation:'}
  XYoff = [79,-6]
  sDEAvalue = { size: [sDEAlabel.size[0]+XYoff[0],$
    sDEAlabel.size[1]+XYoff[1],$
    sTZO_detector_field.size[2:3]],$
    sensitive: 0,$
    value: '',$
    uname: 'detector_efficiency_attenuator_value'}
  XYoff = [70,0]
  sDEAunits = { size: [sDEAvalue.size[0]+XYoff[0],$
    sDEAlabel.size[1]+XYoff[1]],$
    value: '(1/Angstroms)',$
    sensitive: 0,$
    uname: 'detector_efficiency_attenuator_units'}
    
  ;- Q --------------------------------------------------------------------------
  XYoff = [0,20]
  sQbase = { size:  [sDEbase.size[0]+XYoff[0],$
    sDEbase.size[1]+sDEbase.size[3]+XYoff[1],$
    sDEbase.size[2:3]],$
    frame: sDEbase.frame,$
    uname: 'q_base'}
  XYoff = [20,-8]
  sQTitle = { size:  [sQbase.size[0]+XYoff[0],$
    sQbase.size[1]+XYoff[1]],$
    value: 'Q range'}
  ;Qmin
  QXoff = 70
  XYoff = [80,12]
  sQminLabel = { size:  [XYoff[0],$
    XYoff[1]],$
    value: 'Min:'}
  XYoff = [30,-5]
  sQminText = {  size:  [sQminLabel.size[0]+XYoff[0],$
    sQminLabel.size[1]+XYoff[1],$
    70,30],$
    value: '0.001',$
    uname: 'qmin_text_field'}
    
  ;Qmax
  XYoff = [QXoff+5,0]
  sQmaxLabel = { size:  [sQminText.size[0]+sQminText.size[2]+XYoff[0],$
    sQminLabel.size[1]+XYoff[1]],$
    value: 'Max:'}
  XYoff = [30,0]
  sQmaxText = {  size:  [sQmaxLabel.size[0]+XYoff[0],$
    sQminText.size[1]+XYoff[1],$
    sQminText.size[2:3]],$
    value: '1.0',$
    uname: 'qmax_text_field'}
    
  ;Qwidth
  XYoff = [Qxoff+5,0]
  sQwidthLabel = { size:  [sQmaxText.size[0]+sQminText.size[2]+XYoff[0],$
    sQminLabel.size[1]+XYoff[1]],$
    value: 'Width:'}
  XYoff = [45,0]
  sQwidthText = {  size:  [sQwidthLabel.size[0]+XYoff[0],$
    sQminText.size[1]+XYoff[1],$
    sQminText.size[2:3]],$
    value: '0.01',$
    uname: 'qwidth_text_field'}
    
  ;Q scale
  XYoff = [Qxoff+5,5]
  sQscaleGroup = { size:  [sQwidthText.size[0]+sQwidthText.size[2]+XYoff[0],$
    sQwidthText.size[1]+XYoff[1]],$
    list:  ['Linear','Logarithmic'],$
    value: 0.0,$
    uname: 'q_scale_group'}
    
  ;- Lambda cut-off -------------------------------------------------------------
  XYoff = [0,20]
  sQLbase = { size: [sQbase.size[0]+XYoff[0],$
    sQbase.size[1]+sQbase.size[3]+XYoff[1],$
    sQbase.size[2:3]],$
    frame: sMEbase.frame,$
    uname: 'wave_cut_off_base'}
  XYoff = [20,-8]
  sQLTitle = { size:  [sQLbase.size[0]+XYoff[0],$
    sQLbase.size[1]+XYoff[1]],$
    value: 'Wavelength Cut-off (Angstroms)'}
    
  ;- Minimum
  XYoff = [80,5]
  sMinLambdaGroup = { size:  [XYoff[0],$
    XYoff[1]],$
    list:  ['ON','OFF'],$
    value: 1.0,$
    uname: 'minimum_lambda_cut_off_group',$
    title: 'Minimum:'}
  XYoff    = [180,2]
  sMLvalue = { size: [sMinLambdaGroup.size[0]+XYoff[0],$
    sMinLambdaGroup.size[1]+XYoff[1],$
    50],$
    value: '4.0',$
    uname: 'minimum_lambda_cut_off_value',$
    sensitive: 0}
    
  ;- Maximum
  XYoff = [350,0]
  sMaxLambdaGroup = { size:  [sMinLambdaGroup.size[0]+XYoff[0],$
    sMinLambdaGroup.size[1]],$
    list:  ['ON','OFF'],$
    value: 1.0,$
    uname: 'maximum_lambda_cut_off_group',$
    title: 'Maximum:'}
  XYoff = [180,3]
  sMaxValue = { size: [sMaxLambdaGroup.size[0]+XYoff[0],$
    sMaxLambdaGroup.size[1]+XYoff[1],$
    sMLvalue.size[2]],$
    value: '',$
    uname: 'maximum_lambda_cut_off_value',$
    sensitive: 0}
    
  ;- Wavelength dependent background subtraction --------------------------------
  XYoff = [0,20]
  sWaveBase = { size:  [sQLbase.size[0]+XYoff[0],$
    sQLbase.size[1]+sQLbase.size[3]+XYoff[1],$
    sQLbase.size[2],$
    80],$
    frame: sQLbase.frame}
  XYoff = [20,-8]
  sWaveTitle = { size:  [sWaveBase.size[0]+XYoff[0],$
    sWaveBase.size[1]+XYoff[1]],$
    value: 'Wavelength Dependent Background Subtraction'}
    
  ;Wave label
  WaveXoff = 10
  XYoff = [20,15]
  sWaveLabel = { size:  [XYoff[0],$
    XYoff[1]],$
    value: 'Comma-delimited List of Increasing Coefficients',$
    uname: 'wave_para_label_uname'}
    
  XYoff = [300,-8]
  sWaveText = { size: [sWaveLabel.size[0]+XYoff[0],$
    sWaveLabel.size[1]+XYoff[1],$
    560],$
    VALUE: '',$
    UNAME: 'wave_dependent_back_sub_text_field'}
  XYoff = [0,0]
  sWaveClearField = { size: [sWaveText.size[0]+$
    sWaveText.size[2]+XYoff[0],$
    sWaveText.size[1]+XYoff[1],$
    30,$
    30],$
    value: 'X',$
    uname: 'wave_clear_text_field'}
  XYoff = [0,0]
  sWaveHelpButton = { size: [sWaveClearField.size[0]+$
    sWaveClearField.size[2]+XYoff[0],$
    sWaveText.size[1]+XYoff[1],$
    60,$
    30],$
    VALUE: 'HELP',$
    UNAME: 'wave_help_button'}
  XYoff = [0,25]
  sBrowseWave = { size: [sWaveLabel.size[0]+XYoff[0],$
    sWaveLabel.size[1]+XYoff[1],$
    950,$
    sWaveHelpButton.size[3]],$
    value : 'BROWSE ...',$
    uname: 'wave_dependent_back_browse_button'}
    
  ;- Accelerator Down Time (seconds) --------------------------------------------
  XYoff = [0,20]
  sAcceBase = { size:  [sWavebase.size[0]+XYoff[0],$
    sWaveBase.size[1]+$
    sWaveBase.size[3]+XYoff[1],$
    sWaveBase.size[2],$
    50],$
    sensitive: 0,$
    frame: sWaveBase.frame,$
    uname: 'acce_base'}
  XYoff = [20,-8]
  sAcceTitle = { size:  [sAcceBase.size[0]+XYoff[0],$
    sAcceBase.size[1]+XYoff[1]],$
    value: 'Accelerator Down Time (seconds)'}
    
  ;Data
  AcceXoff = 55
  XYoff = [80,18]
  sAcceDataLabel = { size:  [XYoff[0],$
    XYoff[1]],$
    value: 'Data:',$
    sensitive: 0,$
    uname: 'acce_data_label'}
  XYoff = [35,-5]
  sDataText = {  size:  [sAcceDataLabel.size[0]+XYoff[0],$
    sAcceDataLabel.size[1]+XYoff[1],$
    70,30],$
    value: '0.0',$
    sensitive: 0,$
    uname: 'acce_data_text_field'}
    
  ;Solvent
  XYoff = [AcceXoff+5,0]
  sSolventLabel = { size:  [sDataText.size[0]+sDataText.size[2]+XYoff[0],$
    sAcceDataLabel.size[1]+XYoff[1]],$
    value: 'Solvent:',$
    sensitive: 0,$
    uname: 'acce_solvent_label'}
  XYoff = [53,0]
  sSolventText = {  size:  [sSolventLabel.size[0]+XYoff[0],$
    sDataText.size[1]+XYoff[1],$
    sDataText.size[2:3]],$
    value: '0.0',$
    sensitive: 0,$
    uname: 'acce_solvent_text_field'}
    
  ;Empty Can
  XYoff = [AcceXoff+5,0]
  sEmptyCanLabel = { size:  [sSolventText.size[0]+$
    sSolventText.size[2]+XYoff[0],$
    sSolventLabel.size[1]+XYoff[1]],$
    value: 'Empty Can:',$
    sensitive: 0,$
    uname: 'acce_empty_can_label'}
  XYoff = [65,0]
  sEmptyCanText = {  size:  [sEmptyCanLabel.size[0]+XYoff[0],$
    sSolventText.size[1]+XYoff[1],$
    sSolventText.size[2:3]],$
    value: '0.0',$
    sensitive: 0,$
    uname: 'acce_empty_can_text_field'}
    
  ;Open Beam
  XYoff = [AcceXoff+5,0]
  sOpenBeamLabel = { size:  [sEmptyCanText.size[0]+$
    sEmptyCanText.size[2]+XYoff[0],$
    sEmptyCanLabel.size[1]+XYoff[1]],$
    value: 'Open Beam:',$
    sensitive: 0,$
    uname: 'acce_open_beam_label'}
  XYoff = [65,0]
  sOpenBeamText = {  size:  [sOpenBeamLabel.size[0]+XYoff[0],$
    sEmptyCanText.size[1]+XYoff[1],$
    sEmptyCanText.size[2:3]],$
    value: '0.0',$
    sensitive: 0,$
    uname: 'acce_open_beam_text_field'}
    
  ;- scaling constant -----------------------------------------------------------
  XYoff = [0,20]
  sScaleBase = { size:  [sAcceBase.size[0]+XYoff[0],$
    sAcceBase.size[1]+sAcceBase.size[3]+XYoff[1],$
    sAcceBase.size[2],$
    sQLbase.size[3]],$
    frame: sAcceBase.frame}
  XYoff = [20,-8]
  sScaleTitle = { size:  [sScaleBase.size[0]+XYoff[0],$
    sScaleBase.size[1]+XYoff[1]],$
    value: 'Scale Factor for Final Spectrum'}
  XYoff = [50,10]
  sScalegroup = { size: [sTZO_detector_value.size[0]+XYoff[0],$
    XYoff[1]],$
    uname: 'scaling_constant_group',$
    list: ['YES','NO'],$
    value: 1.0}
  XYoff = [0,5]
  sScaleLabel = { size: [sTZO_beam_value.size[0]+XYoff[0],$
    sScalegroup.size[1]+XYoff[1]],$
    uname: 'scaling_constant_label',$
    value: 'Value:',$
    sensitive: 0}
  XYoff = [50,-6]
  sScaleValue = { size: [sScaleLabel.size[0]+XYoff[0],$
    sScaleLabel.size[1]+XYoff[1],$
    sTZO_detector_field.size[2:3]],$
    value: '',$
    uname: 'scaling_constant_value',$
    sensitive: 0}
  XYoff = [0,5]
  sScaleHelp = { size: [sTZOhelp.size[0]+XYoff[0],$
    sScaleValue.size[1]+XYoff[1]],$
    value: '(Specify the constant with which to scale ' + $
    '(multiply) the final data)'}
    
  ;- Flags ----------------------------------------------------------------------
  XYoff = [0,20]
  sFlagsBase = { size: [sScaleBase.size[0]+XYoff[0],$
    sScaleBase.size[1]+sScaleBase.size[3]+XYoff[1],$
    sWaveBase.size[2],$
    80],$
    frame: sWaveBase.frame}
  XYoff = [20,-8]
  sFlagsTitle = { size:  [sFlagsBase.size[0]+XYoff[0],$
    sFlagsBase.size[1]+XYoff[1]],$
    value: 'Flags'}
    
  ;- Overwrite Geometry
  XYoff    = [20,20]
  sOG      = {size:  [XYoff[0],$
    XYoff[1]],$
    value: '* Overwrite Geometry'}
  XYoff    = [150,-6]
  sOGgroup = {size:  [XYoff[0],$
    sOG.size[1]+XYoff[1]],$
    list:  ['YES','NO'],$
    uname: 'overwrite_geometry_group'}
  XYoff    = [105,-3]
  sOGbase  = {size:  [sOGgroup.size[0]+XYoff[0],$
    sOGgroup.size[1]+XYoff[1],$
    700,30],$
    uname: 'overwrite_geometry_base',$
    map:   0}
  XYoff     = [0,0]
  sOGbutton = {size:  [XYoff[0],$
    XYoff[1],$
    sOGbase.size[2],$
    sOGbase.size[3]],$
    value: 'Select a Geometry File ...',$
    uname: 'overwrite_geometry_button'}
    
  XYoff    = [0,30]
  sBM      = {size:  [sOG.size[0]+XYoff[0],$
    sOG.size[1]+XYoff[1]],$
    value: '* With Beam Monitor Normalization'}
  XYoff    = [230,-6]
  sBMgroup = {size:  [XYoff[0],$
    sBM.size[1]+XYoff[1]],$
    list:  ['YES','NO'],$
    uname: 'beam_monitor_normalization_group'}
    
  ;- Verbose Mode ---------------------------------------------------------------
  XYoff = [0,20]
  sVerboseGroup = { size:  [sOG.size[0]+XYoff[0],$
    sOG.size[1]+XYoff[1]],$
    list:  ['YES','NO'],$
    value: 0.0,$
    uname: 'verbose_mode_group',$
    title: '* Verbose Mode      '}
    
  ;==============================================================================
  ;= Build Widgets ==============================================================
  Basetab = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBaseTab.uname,$
    XOFFSET   = sBaseTab.size[0],$
    YOFFSET   = sBaseTab.size[1],$
    SCR_XSIZE = sBaseTab.size[2],$
    SCR_YSIZE = sBaseTab.size[3],$
    TITLE     = sBaseTab.title)
    
  ;- Time Zero offset (microS) --------------------------------------------------
  label = WIDGET_LABEL(Basetab,$
    XOFFSET = sTZOtitle.size[0],$
    YOFFSET = sTZOtitle.size[1],$
    VALUE   = sTZOtitle.value)
    
  base = WIDGET_BASE(BaseTab,$
    XOFFSET   = sTZObase.size[0],$
    YOFFSET   = sTZObase.size[1],$
    SCR_XSIZE = sTZObase.size[2],$
    SCR_YSIZE = sTZObase.size[3],$
    FRAME     = sTZObase.frame,$
    UNAME     = sTZObase.uname)
    
  label = WIDGET_LABEL(Base,$
    XOFFSET = sTZO_detector_value.size[0],$
    YOFFSET = sTZO_detector_value.size[1],$
    VALUE   = sTZO_detector_value.value)
    
  text = WIDGET_TEXT(Base,$
    XOFFSET   = sTZO_detector_field.size[0],$
    YOFFSET   = sTZO_detector_field.size[1],$
    SCR_XSIZE = sTZO_detector_field.size[2],$
    SCR_YSIZE = sTZO_detector_field.size[3],$
    VALUE     = sTZO_detector_field.value,$
    UNAME     = sTZO_detector_field.uname,$
    /ALL_EVENTS,$
    /EDITABLE)
    
  label = WIDGET_LABEL(Base,$
    XOFFSET = sTZO_beam_value.size[0],$
    YOFFSET = sTZO_beam_value.size[1],$
    VALUE   = sTZO_beam_value.value)
    
  text = WIDGET_TEXT(Base,$
    XOFFSET   = sTZO_beam_field.size[0],$
    YOFFSET   = sTZO_beam_field.size[1],$
    SCR_XSIZE = sTZO_beam_field.size[2],$
    SCR_YSIZE = sTZO_beam_field.size[3],$
    VALUE     = sTZO_beam_field.value,$
    UNAME     = sTZO_beam_field.uname,$
    /ALL_EVENTS,$
    /EDITABLE)
    
  help = WIDGET_LABEL(Base,$
    XOFFSET = sTZOhelp.size[0],$
    YOFFSET = sTZOhelp.size[1],$
    VALUE   = sTZOhelp.value)
    
  ;- Monitor Efficiency ---------------------------------------------------------
  label = WIDGET_LABEL(Basetab,$
    XOFFSET = sMEtitle.size[0],$
    YOFFSET = sMEtitle.size[1],$
    VALUE   = sMEtitle.value)
    
  base = WIDGET_BASE(BaseTab,$
    XOFFSET   = sMEbase.size[0],$
    YOFFSET   = sMEbase.size[1],$
    SCR_XSIZE = sMEbase.size[2],$
    SCR_YSIZE = sMEbase.size[3],$
    FRAME     = sMEbase.frame,$
    SENSITIVE = sMEbase.sensitive,$
    UNAME     = sMEbase.uname)
    
  group = CW_BGROUP(Base,$
    sMEgroup.list,$
    XOFFSET    = sMEgroup.size[0],$
    YOFFSET    = sMEgroup.size[1],$
    ROW        = 1,$
    SET_VALUE  = sMEgroup.value,$
    UNAME      = sMEgroup.uname,$
    /EXCLUSIVE)
    
  ;label and value
  wLabel = WIDGET_LABEL(Base,$
    XOFFSET   = sMElabel.size[0],$
    YOFFSET   = sMElabel.size[1],$
    VALUE     = sMElabel.value,$
    UNAME     = sMElabel.uname)
    
  wValue = WIDGET_TEXT(Base,$
    XOFFSET   = sMEvalue.size[0],$
    YOFFSET   = sMEvalue.size[1],$
    SCR_XSIZE = sMEvalue.size[2],$
    SCR_YSIZE = sMEvalue.size[3],$
    UNAME     = sMEvalue.uname,$
    VALUE     = sMEvalue.value,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  ;help
  whelp = WIDGET_LABEL(Base,$
    XOFFSET = sMEhelp.size[0],$
    YOFFSET = sMEhelp.size[1],$
    VALUE   = sMEhelp.value)
    
  ;- Detector Efficiency ------------------------------------------------------
  label = WIDGET_LABEL(Basetab,$
    XOFFSET = sDEtitle.size[0],$
    YOFFSET = sDEtitle.size[1],$
    VALUE   = sDEtitle.value)
    
  base = WIDGET_BASE(BaseTab,$
    XOFFSET   = sDEbase.size[0],$
    YOFFSET   = sDEbase.size[1],$
    SCR_XSIZE = sDEbase.size[2],$
    SCR_YSIZE = sDEbase.size[3],$
    FRAME     = sDEbase.frame,$
    SENSITIVE = sDEbase.sensitive,$
    UNAME     = sDEbase.uname)
    
  group = CW_BGROUP(Base,$
    sDEgroup.list,$
    XOFFSET    = sDEgroup.size[0],$
    YOFFSET    = sDEgroup.size[1],$
    ROW        = 1,$
    SET_VALUE  = sDEgroup.value,$
    UNAME      = sDEgroup.uname,$
    /EXCLUSIVE)
    
  ;label and value
  wLabel = WIDGET_LABEL(Base,$
    XOFFSET   = sDElabel.size[0],$
    YOFFSET   = sDElabel.size[1],$
    VALUE     = sDElabel.value,$
    SENSITIVE = sDElabel.sensitive,$
    UNAME     = sDElabel.uname)
    
  wValue = WIDGET_TEXT(Base,$
    XOFFSET   = sDEvalue.size[0],$
    YOFFSET   = sDEvalue.size[1],$
    SCR_XSIZE = sDEvalue.size[2],$
    SCR_YSIZE = sDEvalue.size[3],$
    UNAME     = sDEvalue.uname,$
    VALUE     = sDEvalue.value,$
    SENSITIVE = sDEvalue.sensitive,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  ;label and value
  wLabel = WIDGET_LABEL(Base,$
    XOFFSET   = sDEAlabel.size[0],$
    YOFFSET   = sDEAlabel.size[1],$
    VALUE     = sDEAlabel.value,$
    SENSITIVE = sDEAlabel.sensitive,$
    UNAME     = sDEAlabel.uname)
    
  wValue = WIDGET_TEXT(Base,$
    XOFFSET   = sDEAvalue.size[0],$
    YOFFSET   = sDEAvalue.size[1],$
    SCR_XSIZE = sDEAvalue.size[2],$
    SCR_YSIZE = sDEAvalue.size[3],$
    UNAME     = sDEAvalue.uname,$
    SENSITIVE = sDEAvalue.sensitive,$
    VALUE     = sDEAvalue.value,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  ;units
  wunits = WIDGET_LABEL(Base,$
    XOFFSET = sDEAunits.size[0],$
    YOFFSET = sDEAunits.size[1],$
    VALUE   = sDEAunits.value,$
    SENSITIVE = sDEAunits.sensitive,$
    UNAME   = sDEAunits.uname)
    
  ;- Q --------------------------------------------------------------------------
  wQTitle = WIDGET_LABEL(Basetab,$
    XOFFSET = sQTitle.size[0],$
    YOFFSET = sQTitle.size[1],$
    VALUE   = sQTitle.value)
    
  ;Q base
  Base = WIDGET_BASE(Basetab,$
    XOFFSET   = sQbase.size[0],$
    YOFFSET   = sQbase.size[1],$
    SCR_XSIZE = sQbase.size[2],$
    SCR_YSIZE = sQbase.size[3],$
    FRAME     = sQbase.frame,$
    UNAME     = sQbase.uname)
      
  ;Qmin
  wQminLabel = WIDGET_LABEL(Base,$
    XOFFSET = sQminLabel.size[0],$
    YOFFSET = sQminLabel.size[1],$
    VALUE   = sQminLabel.value)
    
  wQminText = WIDGET_TEXT(Base,$
    XOFFSET   = sQminText.size[0],$
    YOFFSET   = sQminText.size[1],$
    SCR_XSIZE = sQminText.size[2],$
    SCR_YSIZE = sQminText.size[3],$
    VALUE     = sQminText.value,$
    UNAME     = sQminText.uname,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;Qmax
  wQmaxLabel = WIDGET_LABEL(Base,$
    XOFFSET = sQmaxLabel.size[0],$
    YOFFSET = sQmaxLabel.size[1],$
    VALUE   = sQmaxLabel.value)
    
  wQmaxText = WIDGET_TEXT(Base,$
    XOFFSET   = sQmaxText.size[0],$
    YOFFSET   = sQmaxText.size[1],$
    SCR_XSIZE = sQmaxText.size[2],$
    SCR_YSIZE = sQmaxText.size[3],$
    VALUE     = sQmaxText.value,$
    UNAME     = sQmaxText.uname,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;Qwidth
  wQwidthLabel = WIDGET_LABEL(Base,$
    XOFFSET = sQwidthLabel.size[0],$
    YOFFSET = sQwidthLabel.size[1],$
    VALUE   = sQwidthLabel.value)
    
  wQwidthText = WIDGET_TEXT(Base,$
    XOFFSET   = sQwidthText.size[0],$
    YOFFSET   = sQwidthText.size[1],$
    SCR_XSIZE = sQwidthText.size[2],$
    SCR_YSIZE = sQwidthText.size[3],$
    VALUE     = sQwidthText.value,$
    UNAME     = sQwidthText.uname,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
    label = WIDGET_LABEL(Base,$
    XOFFSET = sQscaleGroup.size[0],$
    YOFFSET = sQscaleGroup.size[1],$
    VALUE = '(Logarithmic binning)')
    
;  ;Q scale
;  wQscaleGroup =  CW_BGROUP(Base,$
;    sQscaleGroup.list,$
;    XOFFSET    = sQscaleGroup.size[0],$
;    YOFFSET    = sQscaleGroup.size[1],$
;    ROW        = 1,$
;    SET_VALUE  = sQscaleGroup.value,$
;    UNAME      = sQscaleGroup.uname,$
;    /EXCLUSIVE)
    
  ;- Lambda cut-off -------------------------------------------------------------
  wQLTitle = WIDGET_LABEL(Basetab,$
    XOFFSET = sQLTitle.size[0],$
    YOFFSET = sQLTitle.size[1],$
    VALUE   = sQLTitle.value)
    
  ;Lambda base
  Base = WIDGET_BASE(Basetab,$
    XOFFSET   = sQLbase.size[0],$
    YOFFSET   = sQLbase.size[1],$
    SCR_XSIZE = sQLbase.size[2],$
    SCR_YSIZE = sQLbase.size[3],$
    FRAME     = sQLbase.frame,$
    UNAME     = sQLbase.uname)
    
  ;- Minimum
  group = CW_BGROUP(Base,$
    sMinLambdaGroup.list,$
    XOFFSET    = sMinLambdaGroup.size[0],$
    YOFFSET    = sMinLambdaGroup.size[1],$
    ROW        = 1,$
    SET_VALUE  = sMinLambdaGroup.value,$
    UNAME      = sMinLambdaGroup.uname,$
    LABEL_LEFT = sMinLambdaGroup.title,$
    /EXCLUSIVE)
    
  wValue = WIDGET_TEXT(Base,$
    XOFFSET   = sMLvalue.size[0],$
    YOFFSET   = sMLvalue.size[1],$
    SCR_XSIZE = sMLvalue.size[2],$
    UNAME     = sMLvalue.uname,$
    SENSITIVE = sMLvalue.sensitive,$
    VALUE     = sMLvalue.value,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  ;- Maximum
  group = CW_BGROUP(Base,$
    sMaxLambdaGroup.list,$
    XOFFSET    = sMaxLambdaGroup.size[0],$
    YOFFSET    = sMaxLambdaGroup.size[1],$
    ROW        = 1,$
    SET_VALUE  = sMaxLambdaGroup.value,$
    UNAME      = sMaxLambdaGroup.uname,$
    LABEL_LEFT = sMaxLambdaGroup.title,$
    /EXCLUSIVE)
    
  wValue = WIDGET_TEXT(Base,$
    XOFFSET   = sMaxvalue.size[0],$
    YOFFSET   = sMaxvalue.size[1],$
    SCR_XSIZE = sMaxvalue.size[2],$
    UNAME     = sMaxvalue.uname,$
    SENSITIVE = sMaxvalue.sensitive,$
    VALUE     = sMaxvalue.value,$
    /EDITABLE,$
    /ALL_EVENTS,$
    /ALIGN_LEFT)
    
  ;- Wavelength dependent background subtraction --------------------------------
  wWaveTitle = WIDGET_LABEL(Basetab,$
    XOFFSET = sWaveTitle.size[0],$
    YOFFSET = sWaveTitle.size[1],$
    VALUE   = sWaveTitle.value)
    
  ;Wave frame
  Base = WIDGET_Base(Basetab,$
    XOFFSET   = sWaveBase.size[0],$
    YOFFSET   = sWaveBase.size[1],$
    SCR_XSIZE = sWaveBase.size[2],$
    SCR_YSIZE = sWaveBase.size[3],$
    FRAME     = sWaveBase.frame)
    
  ;Wave Label
  wWaveLabel = WIDGET_LABEL(Base,$
    XOFFSET = sWaveLabel.size[0],$
    YOFFSET = sWaveLabel.size[1],$
    VALUE   = sWaveLabel.value,$
    UNAME   = sWaveLabel.uname)
    
  wWaveText = WIDGET_TEXT(Base,$
    XOFFSET   = sWaveText.size[0],$
    YOFFSET   = sWaveText.size[1],$
    SCR_XSIZE = sWaveText.size[2],$
    VALUE     = sWaveText.value,$
    UNAME     = sWaveText.uname,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;Wave Clear Text Field
  wWaveClearField = WIDGET_BUTTON(Base,$
    XOFFSET   = sWaveClearField.size[0],$
    YOFFSET   = sWaveClearField.size[1],$
    SCR_XSIZE = sWaveClearField.size[2],$
    SCR_YSIZE = sWaveClearField.size[3],$
    VALUE     = sWaveClearField.value,$
    UNAME     = sWaveClearField.uname)
    
  ;Wave Help Button
  wWaveButton = WIDGET_BUTTON(Base,$
    XOFFSET   = sWaveHelpButton.size[0],$
    YOFFSET   = sWaveHelpButton.size[1],$
    SCR_XSIZE = sWaveHelpButton.size[2],$
    SCR_YSIZE = sWaveHelpButton.size[3],$
    VALUE     = sWaveHelpButton.value,$
    UNAME     = sWaveHelpButton.uname,$
    /PUSHBUTTON_EVENTS)
    
  ;Wave browse
  wWaveBrowseButton = WIDGET_BUTTON(Base,$
    XOFFSET   = sBrowseWave.size[0],$
    YOFFSET   = sBrowseWave.size[1],$
    SCR_XSIZE = sBrowseWave.size[2],$
    SCR_YSIZE = sBrowseWave.size[3],$
    VALUE     = sBrowseWave.value,$
    UNAME     = sBrowseWave.uname)
    
  ;- Scaling Constant -----------------------------------------------------------
  wScaleTitle = WIDGET_LABEL(Basetab,$
    XOFFSET = sScaleTitle.size[0],$
    YOFFSET = sScaleTitle.size[1],$
    VALUE   = sScaleTitle.value)
    
  ;Wave frame
  Base = WIDGET_Base(Basetab,$
    XOFFSET   = sScaleBase.size[0],$
    YOFFSET   = sScaleBase.size[1],$
    SCR_XSIZE = sScaleBase.size[2],$
    SCR_YSIZE = sScaleBase.size[3],$
    FRAME     = sScaleBase.frame)
    
  group = CW_BGROUP(Base,$
    sScaleGroup.list,$
    XOFFSET    = sScaleGroup.size[0],$
    YOFFSET    = sScaleGroup.size[1],$
    ROW        = 1,$
    SET_VALUE  = sScaleGroup.value,$
    UNAME      = sScaleGroup.uname,$
    /EXCLUSIVE)
    
  ;label and value
  label = WIDGET_LABEL(Base,$
    XOFFSET   = sScaleLabel.size[0],$
    YOFFSET   = sScaleLabel.size[1],$
    VALUE     = sScaleLabel.value,$
    UNAME     = sScaleLabel.uname,$
    SENSITIVE = sScaleLabel.sensitive)
    
  wScaleText = WIDGET_TEXT(Base,$
    XOFFSET   = sScaleValue.size[0],$
    YOFFSET   = sScaleValue.size[1],$
    SCR_XSIZE = sScaleValue.size[2],$
    VALUE     = sScaleValue.value,$
    UNAME     = sScaleValue.uname,$
    SENSITIVE = sScaleValue.sensitive,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  wScaleHelp = WIDGET_LABEL(Base,$
    XOFFSET = sScaleHelp.size[0],$
    YOFFSET = sScaleHelp.size[1],$
    VALUE   = sScaleHelp.value)
    
  ;- Flags ----------------------------------------------------------------------
  wFlagTitle = WIDGET_LABEL(Basetab,$
    XOFFSET = sFlagsTitle.size[0],$
    YOFFSET = sFlagsTitle.size[1],$
    VALUE   = sFlagsTitle.value)
    
  ;Wave frame
  Base = WIDGET_Base(Basetab,$
    XOFFSET   = sFlagsBase.size[0],$
    YOFFSET   = sFlagsBase.size[1],$
    SCR_XSIZE = sFlagsBase.size[2],$
    SCR_YSIZE = sFlagsBase.size[3],$
    FRAME     = sFlagsBase.frame)
    
  ;- Overwrite Geometry ----------------------
  label = WIDGET_LABEL(Base,$
    XOFFSET = sOG.size[0],$
    YOFFSET = sOG.size[1],$
    VALUE   = sOG.value,$
    /ALIGN_LEFT)
    
  group = CW_BGROUP(Base,$
    sOGgroup.list,$
    XOFFSET   = sOGgroup.size[0],$
    YOFFSET   = sOGgroup.size[1],$
    ROW       = 1,$
    SET_VALUE = 1,$
    UNAME     = sOGgroup.uname,$
    /NO_RELEASE,$
    /EXCLUSIVE)
    
  base1 = WIDGET_BASE(Base,$
    XOFFSET   = sOGbase.size[0],$
    YOFFSET   = sOGBase.size[1],$
    SCR_XSIZE = sOGbase.size[2],$
    SCR_YSIZE = sOGbase.size[3],$
    UNAME     = sOGbase.uname,$
    MAP       = sOGbase.map)
    
  button = WIDGET_BUTTON(base1,$
    XOFFSET   = sOGbutton.size[0],$
    YOFFSET   = sOGbutton.size[1],$
    SCR_XSIZE = sOGbutton.size[2],$
    SCR_YSIZE = sOGbutton.size[3],$
    VALUE     = sOGbutton.value,$
    UNAME     = sOGbutton.uname)
    
  ;- beam monitor normalization ----------------------
  label = WIDGET_LABEL(Base,$
    XOFFSET = sBM.size[0],$
    YOFFSET = sBM.size[1],$
    VALUE   = sBM.value,$
    /ALIGN_LEFT)
    
  group = CW_BGROUP(Base,$
    sOGgroup.list,$
    XOFFSET   = sBMgroup.size[0],$
    YOFFSET   = sBMgroup.size[1],$
    ROW       = 1,$
    SET_VALUE = 1,$
    UNAME     = sBMgroup.uname,$
    /NO_RELEASE,$
    /EXCLUSIVE)
    
  ;- Verbose Mode ---------------------------------------------------------------
  ; group = CW_BGROUP(Base,$
  ;                   sVerboseGroup.list,$
  ;                   XOFFSET    = sVerboseGroup.size[0],$
  ;                   YOFFSET    = sVerboseGroup.size[1],$
  ;                   ROW        = 1,$
  ;                   SET_VALUE  = sVerboseGroup.value,$
  ;                   UNAME      = sVerboseGroup.uname,$
  ;                   LABEL_LEFT = sVerboseGroup.title,$
  ;                   /EXCLUSIVE)
    
  ;- Accelerator Down Time ----------------------------------------------------
  wAcceTitle = WIDGET_LABEL(Basetab,$
    XOFFSET = sAcceTitle.size[0],$
    YOFFSET = sAcceTitle.size[1],$
    VALUE   = sAcceTitle.value)
    
  ;Accelerator Down Time base
  Base = WIDGET_BASE(Basetab,$
    XOFFSET   = sAcceBase.size[0],$
    YOFFSET   = sAcceBase.size[1],$
    SCR_XSIZE = sAcceBase.size[2],$
    SCR_YSIZE = sAcceBase.size[3],$
    FRAME     = sAcceBase.frame,$
    SENSITIVE = sAcceBase.sensitive,$
    UNAME     = sAcceBase.uname)
    
  ;Data
  wAcceDataLabel = WIDGET_LABEL(Base,$
    XOFFSET = sAcceDataLabel.size[0],$
    YOFFSET = sAcceDataLabel.size[1],$
    VALUE   = sAcceDataLabel.value,$
    UNAME   = sAcceDataLabel.uname,$
    SENSITIVE = sAcceDataLabel.sensitive)
    
  wDataText = WIDGET_TEXT(Base,$
    XOFFSET   = sDataText.size[0],$
    YOFFSET   = sDataText.size[1],$
    SCR_XSIZE = sDataText.size[2],$
    SCR_YSIZE = sDataText.size[3],$
    VALUE     = sDataText.value,$
    UNAME     = sDataText.uname,$
    SENSITIVE = sDataText.sensitive,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;Solvent
  wSolventLabel = WIDGET_LABEL(Base,$
    XOFFSET = sSolventLabel.size[0],$
    YOFFSET = sSolventLabel.size[1],$
    VALUE   = sSolventLabel.value,$
    SENSITIVE = sSolventLabel.sensitive,$
    UNAME   = sSolventLabel.uname)
    
  wSolventText = WIDGET_TEXT(Base,$
    XOFFSET   = sSolventText.size[0],$
    YOFFSET   = sSolventText.size[1],$
    SCR_XSIZE = sSolventText.size[2],$
    SCR_YSIZE = sSolventText.size[3],$
    VALUE     = sSolventText.value,$
    SENSITIVE = sSolventText.sensitive,$
    UNAME     = sSolventText.uname,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;EmptyCan
  wEmptyCanLabel = WIDGET_LABEL(Base,$
    XOFFSET = sEmptyCanLabel.size[0],$
    YOFFSET = sEmptyCanLabel.size[1],$
    VALUE   = sEmptyCanLabel.value,$
    SENSITIVE = sEmptyCanLabel.sensitive,$
    UNAME   = sEmptyCanLabel.uname)
    
  wEmptyCanText = WIDGET_TEXT(Base,$
    XOFFSET   = sEmptyCanText.size[0],$
    YOFFSET   = sEmptyCanText.size[1],$
    SCR_XSIZE = sEmptyCanText.size[2],$
    SCR_YSIZE = sEmptyCanText.size[3],$
    VALUE     = sEmptyCanText.value,$
    SENSITIVE = sEmptyCanText.sensitive,$
    UNAME     = sEmptyCanText.uname,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;OpenBeam
  wOpenBeamLabel = WIDGET_LABEL(Base,$
    XOFFSET = sOpenBeamLabel.size[0],$
    YOFFSET = sOpenBeamLabel.size[1],$
    VALUE   = sOpenBeamLabel.value,$
    SENSITIVE = sOpenBeamLabel.sensitive,$
    UNAME   = sOpenBeamLabel.uname)
    
  wOpenBeamText = WIDGET_TEXT(Base,$
    XOFFSET   = sOpenBeamText.size[0],$
    YOFFSET   = sOpenBeamText.size[1],$
    SCR_XSIZE = sOpenBeamText.size[2],$
    SCR_YSIZE = sOpenBeamText.size[3],$
    VALUE     = sOpenBeamText.value,$
    SENSITIVE = sOpenBeamText.sensitive,$
    UNAME     = sOpenBeamText.uname,$
    /ALL_EVENTS,$
    /EDITABLE,$
    /ALIGN_LEFT)
    
END
