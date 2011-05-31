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

PRO MakeGuiReduceDataBase, Event, REDUCE_BASE, IndividualBaseWidth

  ;size of Data base
  DataBaseSize   = [0,10,IndividualBaseWidth, 170]
  
  DataLabelSize  = [20,2]
  DataLabelTitle = 'D A T A'
  DataFrameSize  = [10,10,IndividualBaseWidth-30,150]
  
  ;runs number
  RunsLabelSize     = [33,27]
  RunsLabelTitle    = 'Runs:'
  d_L_T = 50
  RunsTextFieldSize = [RunsLabelSize[0]+d_L_T,$
    RunsLabelSize[1]-5,530,30]
    
  d_vertical_L_L = 35
  ;region of interest
  RegionOfInterestLabelSize = [RunsLabelSize[0],$
    RunsLabelSize[1]+d_vertical_L_L]
  RegionOfInterestLabelTitle = 'Region of interest (ROI) file:'
  RegionOfInterestTextFieldSize = [230,$
    RegionOfInterestLabelSize[1]-7,$
    453,30]
    
  ;Exclusion peak region / Background -------------------------------------------
    
  XYoff = [-1,60] ;Peak Base and labels
  sPeakBase = { size:  [RunsLabelSize[0]+XYoff[0],$
    RunsLabelSize[1]+XYoff[1],$
    650,30],$
    frame: 0,$
    uname: 'data_peak_base',$
    map:   1}
    
  XYoff = [0,7] ;Main label
  sPeakMainLabel = { size:  XYoff,$
    value: 'Peak Exclusion Region:'}
  XYoff = [250,0]
  sPeakYminLabel = { size: [sPeakMainLabel.size[0]+XYoff[0],$
    sPeakMainLabel.size[1]+XYoff[1]],$
    value: 'Ymin:'}
  XYoff = [50,-6]
  sPeakYminValue = { size: [sPeakYminLabel.size[0]+XYoff[0],$
    sPeakYminLabel.size[1]+XYoff[1],$
    50,30],$
    value: '',$
    uname: 'data_exclusion_low_bin_text'}
  XYoff = [100,0]
  sPeakYmaxLabel = { size: [sPeakYminValue.size[0]+XYoff[0],$
    sPeakYminLabel.size[1]+XYoff[1]],$
    value: 'Ymax:'}
  XYoff = [50,-6]
  sPeakYmaxValue = { size: [sPeakYmaxLabel.size[0]+XYoff[0],$
    sPeakYmaxLabel.size[1]+XYoff[1],$
    50,30],$
    value: '',$
    uname: 'data_exclusion_high_bin_text'}
    
  ;Background Base, label and text_field
  sBackBase = { size:  sPeakBase.size,$
    frame: 0,$
    uname: 'data_background_base',$
    map:   0}
    
  XYoff = [0,7]                   ;Main label
  sBackMainLabel = { size:  XYoff,$
    value: 'Background Selection File:'}
  XYoff = [170,-6]
  sBackFileValue = { size: [sBackMainLabel.size[0]+XYoff[0],$
    sBackMainLabel.size[1]+XYoff[1],$
    453,30],$
    value: '',$
    uname: 'data_back_selection_file_value'}
    
  ;background flag
  XYoff = [0,10]
  BackgroundLabelSize = [sPeakBase.size[0]+XYoff[0],$
    sPeakBase.size[1]+sPeakBase.size[3]+XYoff[1]]
  BackgroundLabelTitle = 'Background:'
  d_L_T_3 = 100
  BackgroundBGroupSize = [BackgroundLabelSize[0]+d_L_T_3,$
    BackgroundLabelSize[1]-5]
  BackgroundBGroupList = [' Yes ',' No ']
  
  ;******************************************************************************
  ;Create GUI
  ;******************************************************************************
  
  ;base
  data_base = WIDGET_BASE(REDUCE_BASE,$
    UNAME     = 'reduce_data_base',$
    XOFFSET   = DataBaseSize[0],$
    YOFFSET   = DataBaseSize[1],$
    SCR_XSIZE = DataBaseSize[2],$
    SCR_YSIZE = DataBaseSize[3])
    
  ;base that will hide the Peak Exclusion Region and background file
  hide_base = widget_base(data_base,$
  xoffset = sPeakBase.size[0],$
  yoffset = sPeakBase.size[1],$
  scr_xsize = sPeakBase.size[2],$
  scr_ysize = sPeakBase.size[3],$
  map = 0,$
  uname = 'hide_background_base')
  
  ;Data main label
  DataLabel = WIDGET_LABEL(data_base,$
    XOFFSET = DataLabelSize[0],$
    YOFFSET = DataLabelSize[1],$
    VALUE   = DataLabelTitle)
    
  ;runs label
  RunsLabel = WIDGET_LABEL(data_base,$
    XOFFSET = RunsLabelSize[0],$
    YOFFSET = RunsLabelSize[1],$
    VALUE   = RunsLabelTitle)
    
  ;runs text field
  RunsTextField = WIDGET_TEXT(data_base,$
    XOFFSET   = RunsTextFieldSize[0],$
    YOFFSET   = RunsTextFieldSize[1],$
    SCR_XSIZE = RunsTextFieldSize[2],$
    SCR_YSIZE = RunsTextFieldSize[3],$
    UNAME     ='reduce_data_runs_text_field',$
    VALUE     = '',$
    /EDITABLE,$
    /ALIGN_LEFT,$
    /ALL_EVENTS)
    
  plot_all = widget_base(data_base,$
  xoffset = RunsTextFieldSize[0] + RunsTextFieldSize[2],$
  yoffset = RunsTextFieldSize[1],$
  /row,$
  /nonexclusive)
    
  button = widget_button(plot_all,$
  value='Plot all',$
  uname='plot_all_data_file_together_uname')  
    
  ;region of interest label
  RegionOfInterestLabel = WIDGET_LABEL(data_base,$
    XOFFSET = RegionOfInterestLabelSize[0],$
    YOFFSET = RegionOfInterestLabelSize[1],$
    VALUE   = RegionOfInterestLabelTitle)
    
  ;region of interest text field
  RegionOfInterestTextField = $
    WIDGET_LABEL(data_base,$
    XOFFSET   = RegionOfInterestTextFieldSize[0],$
    YOFFSET   = RegionOfInterestTextFieldSize[1],$
    SCR_XSIZE = RegionOfInterestTextFieldSize[2],$
    SCR_YSIZE = RegionOfInterestTextFieldSize[3],$
    VALUE     = '',$
    UNAME     = 'reduce_data_region_of_interest_file_name',$
    /ALIGN_LEFT)
    
  ;Peak exlusion Base -----------------------------------------------------------
  wPeakBase = WIDGET_BASE(data_base,$
    XOFFSET   = sPeakBase.size[0],$
    YOFFSET   = sPeakBase.size[1],$
    SCR_XSIZE = sPeakBase.size[2],$
    SCR_YSIZE = sPeakBase.size[3],$
    FRAME     = sPeakBase.frame,$
    UNAME     = sPeakBase.uname,$
    MAP       = sPeakBase.map)
    
  wPeakMainLabel = WIDGET_LABEL(wPeakBase,$
    XOFFSET = sPeakMainLabel.size[0],$
    YOFFSET = sPeakMainLabel.size[1],$
    VALUE   = sPeakMainLabel.value)
    
  wPeakYminLabel = WIDGET_LABEL(wPeakBase,$
    XOFFSET = sPeakYminLabel.size[0],$
    YOFFSET = sPeakYminLabel.size[1],$
    VALUE   = sPeakYminLabel.value)
    
  wPeakYminVALUE = WIDGET_LABEL(wPeakBase,$
    XOFFSET   = sPeakYminValue.size[0],$
    YOFFSET   = sPeakYminValue.size[1],$
    SCR_XSIZE = sPeakYminValue.size[2],$
    SCR_YSIZE = sPeakYminValue.size[3],$
    VALUE     = sPeakYminValue.value,$
    UNAME     = sPeakYminValue.uname,$
    /ALIGN_LEFT)
    
  wPeakYmaxLabel = WIDGET_LABEL(wPeakBase,$
    XOFFSET = sPeakYmaxLabel.size[0],$
    YOFFSET = sPeakYmaxLabel.size[1],$
    VALUE   = sPeakYmaxLabel.Value)
    
  wPeakYmaxVALUE = WIDGET_LABEL(wPeakBase,$
    XOFFSET   = sPeakYmaxValue.size[0],$
    YOFFSET   = sPeakYmaxValue.size[1],$
    SCR_XSIZE = sPeakYmaxValue.size[2],$
    SCR_YSIZE = sPeakYmaxValue.size[3],$
    VALUE     = sPeakYmaxValue.value,$
    UNAME     = sPeakYmaxValue.uname,$
    /ALIGN_LEFT)
    
  ;Background exlusion Base -----------------------------------------------------
  wBackBase = WIDGET_BASE(data_base,$
    XOFFSET   = sBackBase.size[0],$
    YOFFSET   = sBackBase.size[1],$
    SCR_XSIZE = sBackBase.size[2],$
    SCR_YSIZE = sBackBase.size[3],$
    FRAME     = sBackBase.frame,$
    UNAME     = sBackBase.uname,$
    MAP       = sBackBase.map)
    
  wBackMainLabel = WIDGET_LABEL(wBackBase,$
    XOFFSET = sBackMainLabel.size[0],$
    YOFFSET = sBackMainLabel.size[1],$
    VALUE   = sBackMainLabel.value)
    
  wBackFileVALUE = WIDGET_LABEL(wBackBase,$
    XOFFSET   = sBackFileValue.size[0],$
    YOFFSET   = sBackFileValue.size[1],$
    SCR_XSIZE = sBackFileValue.size[2],$
    SCR_YSIZE = sBackFileValue.size[3],$
    VALUE     = sBackFileValue.value,$
    UNAME     = sBackFileValue.uname,$
    /ALIGN_LEFT)
    
  ;background
  BackgroundLabel = WIDGET_LABEL(data_base,$
    XOFFSET = BackgroundLabelSize[0],$
    YOFFSET = BackgroundLabelSize[1],$
    VALUE   = BackgroundLabelTitle)
    
  BackgroundBGroup = CW_BGROUP(data_base,$
    BackgroundBGroupList,$
    XOFFSET   = BackgroundBGroupSize[0],$
    YOFFSET   = BackgroundBGroupSize[1],$
    SET_VALUE = 0,$
    UNAME     = 'data_background_cw_bgroup',$
    ROW       = 1,$
    /NO_RELEASE,$
    /EXCLUSIVE)
    
  ;tof cut  base
  tof_cut = WIDGET_BASE(data_base,$
    XOFFSET = 295,$
    YOFFSET = 118,$
    FRAME = 1,$
    /ROW)
    
  label = WIDGET_LABEL(tof_cut,$
    VALUE = 'TOF cutting:')
  label = WIDGET_LABEL(tof_cut,$
    VALUE = ' min:')
  value = WIDGET_TEXT(tof_cut,$
    VALUE = '',$
    XSIZE = 6,$
    UNAME = 'tof_cutting_min',$
    /EDITABLE)
  label = WIDGET_LABEL(tof_cut,$
    VALUE = ' max:')
  value = WIDGET_TEXT(tof_cut,$
    VALUE = '',$
    XSIZE = 6,$
    UNAME = 'tof_cutting_max',$
    /EDITABLE)
    
  units_base = WIDGET_BASE(tof_cut,$
    /ROW,$
    /EXCLUSIVE)
    
  unit2 = WIDGET_BUTTON(units_base,$
    VALUE = 'mS',$
    UNAME = 'reduce_data_tof_units_ms')
  unit1 = WIDGET_BUTTON(units_base,$
    VALUE = 'microS',$
    UNAME = 'reduce_data_tof_units_micros')
   WIDGET_CONTROL, unit2, /SET_BUTTON
    
  ;------------------------------------------------------------------------------
    
  ;frame
  DataFrame = WIDGET_LABEL(data_base,$
    XOFFSET   = DataFrameSize[0],$
    YOFFSET   = DataFrameSize[1],$
    SCR_XSIZE = DataFrameSize[2],$
    SCR_YSIZE = DataFrameSize[3],$
    FRAME     = 1,$
    VALUE     = '')
    
END
