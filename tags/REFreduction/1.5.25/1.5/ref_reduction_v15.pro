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

PRO BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  RESOLVE_ROUTINE, 'ref_reduction_eventcb',$
    /COMPILE_FULL_FILE            ; Load event callback routines
  ;build the Instrument Selection base
  MakeGuiInstrumentSelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END

;------------------------------------------------------------------------------
PRO BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;retrieve global structure
  global = getGlobal(INSTRUMENT=instrument,MINIversion=0)
  
  LOADCT,5, /SILENT
  
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    MainBaseSize  = [0,0,1200,885]
  ENDIF ELSE BEGIN
    MainBaseSize  = [50,50,1200,885]
  ENDELSE
  
  MainBaseTitle = 'Reflectometer Data Reduction Package ' + $
  '(detector rotated - x:304px y:256px) - '
  MainBaseTitle += (*global).VERSION
  IF ((*global).DEBUGGING_VERSION EQ 'yes') THEN BEGIN
    MainBaseTitle += ' (DEBUGGING MODE)'
  ENDIF
  
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
    UNAME        = 'MAIN_BASE',$
    SCR_XSIZE    = MainBaseSize[2],$
    SCR_YSIZE    = MainBaseSize[3],$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    TITLE        = MainBaseTitle,$
    SPACE        = 0,$
    XPAD         = 0,$
    YPAD         = 2,$
    MBAR         = WID_BASE_0_MBAR)
    
  (*global).main_base = MAIN_BASE
    
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, set_uvalue=global
  
;  ;HELP MENU in Menu Bar --------------------------------------------------------
;  HELP_MENU = WIDGET_BUTTON(WID_BASE_0_MBAR,$
;    UNAME = 'help_menu',$
;    VALUE = 'HELP',$
;    /MENU)
;    
;  HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
;    VALUE = 'HELP',$
;    UNAME = 'help_button')
;    
;  IF ((*global).ucams EQ 'j35') THEN BEGIN
;    my_help_button = WIDGET_BUTTON(HELP_MENU,$
;      VALUE = 'MY HELP',$
;      UNAME = 'my_help_button')
;  ENDIF
  
  structure = {with_launch_button: (*global).with_launch_switch}
  
  MakeGuiMainTab, $
    MAIN_BASE, $
    MainBaseSize, $
    instrument, $
    (*(*global).PlotsTitle), $
    structure
    
  ;hidden widget_text
  DataHiddenWidgetText = WIDGET_TEXT(MAIN_BASE,$
    XOFFSET = 1,$
    YOFFSET = 1,$
    /ALL_EVENTS,$
    UNAME='data_hidden_widget_text')
  (*global).DataHiddenWidgetTextId = DataHiddenWidgetText
  (*global).DataHiddenWidgetTextUname = 'data_hidden_widget_text'
  
  NormHiddenWidgetText = WIDGET_TEXT(MAIN_BASE,$
    XOFFSET = 1,$
    YOFFSET = 1,$
    /ALL_EVENTS,$
    UNAME='norm_hidden_widget_text')
  (*global).NormHiddenWidgetTextId = NormHiddenWidgetText
  (*global).NormHiddenWidgetTextUname = 'norm_hidden_widget_text'
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='ref_reduction_Cleanup'
  
  ;initialize contrast droplist
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_contrast_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialDataContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_contrast_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNormContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_loadct_1d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialData1d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_loadct_1d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNorm1d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_loadct_2d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialData2d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_loadct_2d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNorm2d3DContrastDropList
    
  ;initialize CommandLineOutput widgets (path and file name)
  id = WIDGET_INFO(Main_base, find_by_uname='cl_directory_text')
  WIDGET_CONTROL, id, set_value=(*global).cl_output_path
  time = RefReduction_GenerateIsoTimeStamp()
  file_name = (*global).cl_file_ext1 + time + (*global).cl_file_ext2
  id = WIDGET_INFO(Main_Base, find_by_uname='cl_file_text')
  WIDGET_CONTROL, id, set_value=file_name
  
  IF ((*global).ucams EQ 'j35') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='reduce_cmd_line_preview')
    WIDGET_CONTROL, id, /editable
    WIDGET_CONTROL, /CONTEXT_EVENTS
  ENDIF
  
  IF ((*global).ucams EQ 'j35') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='cmd_status_preview')
    WIDGET_CONTROL, id, /editable
  ENDIF
  
  IF ((*global).DEBUGGING_VERSION EQ 'yes') THEN debugging, MAIN_BASE, global
  
  ;------------------------------------------------------------------------------
  ;populate the list of proposal droplist (data, normalization,empty_cell)
  populate_list_of_proposal, MAIN_BASE, (*global).instrument
  
  ;==============================================================================
   
  IF ((*global).CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    packages_required, global, my_package ;packages_required
    checking_packages_routine, MAIN_BASE, my_package, global
   ; update_gui_according_to_package, MAIN_BASE, my_package
  ENDIF
  ;==============================================================================
  
  ;send message to log current run of application
  logger, global
  
END


; Empty stub procedure used for autoloading.
pro ref_reduction_v15, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, 'REF_L', GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





