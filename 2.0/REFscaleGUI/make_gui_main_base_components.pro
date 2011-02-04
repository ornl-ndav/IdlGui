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

PRO MakeGuiMainBaseComponents, MAIN_BASE, StepsTabSize

  ;Define position and size of widgets
  yoff = 5
  ResetAllButtonSize   = [StepsTabSize[0]-2,$
    StepsTabSize[3]+yoff,$
    177,$
    30]
  RefreshPlotSize      = [StepsTabSize[0]+ResetAllButtonSize[2],$
    StepsTabSize[3]+yoff,$
    ResetAllButtonSize[2],$
    ResetAllButtonSize[3]]
    
  PrintButtonSize      = [RefreshPlotSize[0] + RefreshPlotSize[2],$
    ResetAllButtonSize[1],$
    ResetAllButtonSize[2],$
    ResetAllButtonsize[3]]
    
  ;--RESCALE
  yoff = 40
  xoff = 5
  RescaleBaseSize      = [StepsTabSize[0],$
    StepsTabSize[3]+yoff,$
    StepsTabSize[2]-xoff,$
    80]
  d12 = 50                        ;distance between 'x-axis:' and 'min:'
  d23 = 35                        ;distance between 'min' and text field
  d34 = 80                        ;distance between text field and 'max'
  d45 = d23                       ;distance between 'max' and text field
  d56 = 80                      ;distance between text field and lin/log
  d67 = 95                 ;distance between lin/log and validate button
  d78 = 70            ;distance between validate button and reset button
  axis_lin_log = ['lin','log']
  LabelSize    = [35,30]          ;scr_xsize and scr_ysize
  TextBoxSize  = [70,30]          ;scr_xsize and scr_ysize
  ResetButton  = [140,65]         ;scr_xsize and scr_ysize
  
  ;xaxis
  XaxisLabelSize       = [5,$
    5,$
    LabelSize[0],$
    LabelSize[1]]
  XaxisMinLabelSize    = [XaxisLabelSize[0]+d12,$
    XaxisLabelSize[1],$
    LabelSize[0],$
    LabelSize[1]]
  XaxisMinTextFieldSize= [XaxisMinLabelSize[0]+d23,$
    XaxisMinLabelSize[1],$
    TextBoxSize[0],$
    TextBoxSize[1]]
  XaxisMaxLabelSize    = [XaxisMinTextFieldSize[0]+d34,$
    XaxisMinTextFieldSize[1],$
    LabelSize[0],$
    LabelSize[1]]
  XaxisMaxTextFieldSize= [XaxisMaxLabelSize[0]+d45,$
    XaxisMaxLabelSize[1],$
    TextBoxSize[0],$
    TextBoxSize[1]]
  XaxisLinLogSize      = [XaxisMaxTextFieldSize[0]+d56,$
    XaxisMaxTextFieldSize[1]]
  ResetButtonSize     = [XAxisLinLogsize[0]+d67,$
    XAxisLinLogSize[1],$
    ResetButton[0],$
    ResetButton[1]]
  ;yaxis
  yoff= 35
  YaxisLabelSize       = [5,$
    5+yoff,$
    LabelSize[0],$
    LabelSize[1]]
  YaxisMinLabelSize    = [YaxisLabelSize[0]+d12,$
    YaxisLabelSize[1],$
    LabelSize[0],$
    LabelSize[1]]
  YaxisMinTextFieldSize= [YaxisMinLabelSize[0]+d23,$
    YaxisMinLabelSize[1],$
    TextBoxSize[0],$
    TextBoxSize[1]]
  YaxisMaxLabelSize    = [YaxisMinTextFieldSize[0]+d34,$
    YaxisMinTextFieldSize[1],$
    LabelSize[0],$
    LabelSize[1]]
  YaxisMaxTextFieldSize= [YaxisMaxLabelSize[0]+d45,$
    YaxisMaxLabelSize[1],$
    TextBoxSize[0],$
    TextBoxSize[1]]
  YaxisLinLogSize      = [YaxisMaxTextFieldSize[0]+d56,$
    YaxisMaxTextFieldSize[1]]
    
  ;Define title variables
  RefreshPlotButtonTitle = 'REFRESH PLOT'
  printButtonTitle = 'CREATE OUTPUT FILE'
  
  ;------------------------------------------------------------------------------
  ;Settings Base
  ;------------------------------------------------------------------------------
  XYoff = [660,525]
  sSettingsBase = { size  : [XYoff[0],$
    XYoff[1],$
    StepsTabSize[2]-5,$
    65],$
    frame : 1,$
    uname : 'settings_base',$
    map   : 1}
    
  ;Settings Label ---------------------------------------------------------------
  XYoff = [320,38]
  sSettingsLabel = { size  : [XYoff[0],$
    XYoff[1]],$
    value : 'S   E   T   T   I   N   G   S ',$
    frame : 2}
    
  ;Show Error Bars --------------------------------------------------------------
  XYoff = [5,0]
  sShowError = { size  : [XYoff[0],$
    XYoff[1]],$
    title : 'Show Error Bars:',$
    uname : 'show_error_bar_group',$
    list  : ['Yes','No']}
    
  ;Data to display --------------------------------------------------------------
  XYoff = [245,8]
  sDataToDisplayLabel = { size  : [XYoff[0],$
    sShowError.size[1]+XYoff[1]],$
    value : 'Nbr of data to display (Step 3): '}
  XYoff = [450,-8]
  sDataToDisplayText = { size  : [XYoff[0],$
    XYoff[1],$
    50],$
    value : STRCOMPRESS(100,/REMOVE_ALL),$
    uname : 'nbrDataTextField' }
    
  ;Data to Remove ---------------------------------------------------------------
  XYoff = [8,40]
  sDataToRemoveLabel = { size  : [XYoff[0],$
    XYoff[1]],$
    value : 'Nbr of data to remove (Auto. Scaling): '}
  XYoff = [248,-8]
  sDataToRemoveText = { size  : [XYoff[0],$
    sDataToRemoveLabel.size[1]+XYoff[1],$
    50],$
    value : STRCOMPRESS(1,/REMOVE_ALL),$
    uname : 'min_crap_text_field'}
    
  ;//////////////////////////////////////////////////////////////////////////////
  ;                               Build GUI
  ;//////////////////////////////////////////////////////////////////////////////
    
  button_base = widget_base(MAIN_BASE,$
    xoffset = ResetAllButtonSize[0],$
    yoffset = ResetAllButtonSize[1],$
    /row)
    
  RESET_ALL_BUTTON = WIDGET_BUTTON(button_base,$
    UNAME     = 'reset_all_button',$
    VALUE     = 'FULL RESET',$
    SENSITIVE = 0)
    
  REFRESH_PLOT_BUTTON = WIDGET_BUTTON(button_base,$
    UNAME     = 'refresh_plot_button',$
    VALUE     = 'REFRESH PLOT',$
    SENSITIVE = 0)
    
  PRINT_BUTTON = WIDGET_BUTTON(button_base,$
    UNAME     = 'print_button',$
    VALUE     = 'CREATE OUTPUT FILE',$
    SENSITIVE = 0)
    
  ;email_base
  email_base = widget_base(button_base,$
    /row,$
    frame = 1)
    
  group = cw_bgroup(email_base,$
    ['Y','N'],$
    /row,$
    /exclusive,$
    set_value=1,$
    uname = 'send_by_email_output',$
    label_left = 'email output?',$
    /no_release)
    
  button = widget_button(email_base,$
    uname = 'email_configure',$
    value = ' Setup... ',$
    sensitive = 0)
    
  ;--rescale base
  RescaleBase = WIDGET_BASE(MAIN_BASE,$
    UNAME     = 'RescaleBase',$
    XOFFSET   = RescaleBaseSize[0],$
    YOFFSET   = RescaleBaseSize[1]+20,$
    ;    SCR_XSIZE = RescaleBaseSize[2],$
    ;    SCR_YSIZE = RescaleBaseSize[3],$
    FRAME     = 1,$
    /row,$
    MAP       = 1)
    
  ;left part
  left = widget_base(RescaleBase,$
    /column)
    
  xsize = 16
  
  ;xaxis
  row1 = widget_base(left,$
    /row)
  XaxisLabel = WIDGET_LABEL(row1,$
    VALUE     = 'X-axis')
  XaxisMinLabel = WIDGET_LABEL(row1,$
    VALUE     = 'min:')
  XaxisMinTextField = WIDGET_TEXT(row1,$
    UNAME     = 'XaxisMinTextField',$
    xsize = xsize,$
    VALUE     = '',$
    /EDITABLE,$
    /ALIGN_LEFT)
  XaxisMaxLabel = WIDGET_LABEL(row1,$
    VALUE     = 'max:')
  XaxisMaxTextField = WIDGET_TEXT(row1,$
    UNAME     = 'XaxisMaxTextField',$
    XSIZE = xsize,$
    VALUE     = '',$
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;yaxis
  row2 = widget_base(left, $
    /row)
  ;yaxis
  YaxisLabel = WIDGET_LABEL(row2,$
    VALUE     = 'Y-axis')
  YaxisMinLabel = WIDGET_LABEL(row2,$
    VALUE     = 'min:')
  YaxisMinTextField = WIDGET_TEXT(row2,$
    UNAME     = 'YaxisMinTextField',$
    XSIZE = xsize,$
    VALUE     = '',$
    /EDITABLE,$
    /ALIGN_LEFT)
  YaxisMaxLabel = WIDGET_LABEL(row2,$
    VALUE     = 'max:')
  YaxisMaxTextField = WIDGET_TEXT(row2,$
    UNAME     = 'YaxisMaxTextField',$
    XSIZE = xsize,$
    VALUE     = '',$
    /EDITABLE,$
    /ALIGN_LEFT)
  YaxisLinLog = CW_BGROUP(row2,$
    axis_lin_log,$
    SET_VALUE = 0,$
    ROW       = 1,$
    UNAME     = 'YaxisLinLog',$
    /EXCLUSIVE,$
    /RETURN_NAME)
    
  ResetButton = WIDGET_BUTTON(RescaleBase,$
    SCR_XSIZE = 75,$
    UNAME     = 'ResetButton',$
    VALUE     = 'Reset X/Y')
    
  ;spin states base
  spin_state = widget_base(MAIN_BASE,$
    xoffset = sSettingsBase.size[0],$
    yoffset = sSettingsBase.size[1]+35,$
    uname = 'spin_state_button_base',$
    /row,$
    map = 1,$
    /exclusive)
    
  off_off = widget_button(spin_state,$
    value = 'Off_Off',$
    sensitive = 0,$
    /no_release,$
    uname = 'off_off')
  off_on = widget_button(spin_state,$
    value = 'Off_On',$
    sensitive = 0,$
    /no_release,$
    uname = 'off_on')
  on_off = widget_button(spin_state,$
    value = 'On_Off',$
    sensitive = 0,$
    /no_release,$
    uname = 'on_off')
  on_on = widget_button(spin_state,$
    value = 'On_On',$
    sensitive = 0,$
    /no_release,$
    uname = 'on_on')
    
    
  ;cleaning data button
  cleaning = widget_button(main_base, $
  xoffset = sSettingsBase.size[0]+300,$
  yoffset = sSettingsBase.size[1]+35,$
  value = 'Data cleaning ...',$
    uname='start_cleanup_button')

  ;settings button
  settings = widget_button(MAIN_BASE,$
    xoffset = sSettingsBase.size[0]+430,$
    yoffset = sSettingsBase.size[1]+35,$
    xsize = 100,$
    value = 'Settings ...',$
    uname = 'open_settings_base')
    
END

