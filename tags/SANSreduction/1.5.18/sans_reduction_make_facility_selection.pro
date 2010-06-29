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

PRO MakeGuiFacilitySelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, $
SCROLL=scroll

  facilitySelectionBaseSize = [400,300,240,140]
  facilitySelectioncwbgroupSize = [10,5]
  facilitySelectioncwbgroupTitle = '       SELECT  YOUR  FACILITY'
  facilityList = [' SNS (EQ-SANS)',$
    ' LENS (SANS)']
  facilitySelectionGoButtonSize = [10,100,220,30]
  facilitySelectionGoButtontitle = 'VALIDATE FACILITY'
  
  ;Build GUI
  MAIN_BASE = widget_base(GROUP_LEADER=wGroup,$
    xoffset=facilitySelectionBaseSize[0],$
    yoffset=facilitySelectionBaseSize[1],$
    scr_xsize=facilitySelectionBaseSize[2],$
    scr_ysize=facilitySelectionBaseSize[3],$
    Title = 'Facility Selection',$
    SPACE=0,$
    XPAD=0,$
    YPAD=0,$
    uname='MAIN_BASE',$
    frame=2)
    
  global = ptr_new({data_nexus_file_name: '',$
  scroll: scroll,$
  build_command_line: 0})
  
  ;attach global structure with widget ID of widget main base widget ID
  widget_control, MAIN_BASE, set_uvalue=global
  
  facilityCWBgroup = cw_bgroup(MAIN_BASE,$
    facilityList,$
    /exclusive,$
    xoffset=facilitySelectioncwbgroupSize[0],$
    yoffset=facilitySelectioncwbgroupSize[1],$
    set_value=0,$
    uname='facility_selection_cw_bgroup',$
    column=1,$
    label_top=facilitySelectioncwbgroupTitle)
    
  facilitySelectionGoButton = $
    widget_button(MAIN_BASE,$
    xoffset=facilitySelectionGoButtonSize[0],$
    yoffset=facilitySelectionGoButtonSize[1],$
    scr_xsize=facilitySelectionGoButtonSize[2],$
    scr_ysize=facilitySelectionGoButtonSize[3],$
    value=facilitySelectionGoButtonTitle,$
    uname='facility_selection_validate_button')
    
  ;attach global structure with widget ID of widget main base widget ID
  widget_control, MAIN_BASE, SET_UVALUE=global
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
END