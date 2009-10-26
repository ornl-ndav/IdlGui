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

PRO display_plot_tab_fitting_base, Event

  COMPILE_OPT idl2, hidden
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  sys_color_window_bk = 0
  plot_tab_fitting_gui, wBase, $
    main_base_geometry, $
    sys_color_window_bk
    
  global_fitting = PTR_NEW({ wbase: wbase,$
    global: global,$
    main_event: Event})
    
  (*global).plot_tab_fitting_wBase = wBase
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global_fitting
  XMANAGER, "display_plot_tab_fitting_base", wBase, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK
;CLEANUP='transmission_manual_Cleanup'
    
;display_fitting_base_draw, MAIN_BASE=wBase, equation='rg'
    
END

;------------------------------------------------------------------------------
PRO display_fitting_base_draw, $
    MAIN_BASE=main_base, $
    EVENT=event, EQUATION=equation
    
  COMPILE_OPT idl2, hidden
  
  CASE (equation) OF
    'rg': button_image = READ_PNG('SANSreduction_images/RgEquation.png')
    'rt': button_image = READ_PNG('SANSreduction_images/RtEquation.png')
    'rc': button_image = READ_PNG('SANSreduction_images/RcEquation.png')
    'no': button_image = READ_PNG('SANSreduction_images/NoEquation.png')
    ELSE:
  ENDCASE
  
  IF (equation EQ 'no') THEN BEGIN
    status = 1
    draw_uname = 'plot_tab_fitting_base_no_equation_draw'
  ENDIF ELSE BEGIN
    status = 0
    draw_uname = 'plot_tab_fitting_base_draw'
  ENDELSE
  
  base_uname = 'plot_tab_fitting_no_base'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    MapBase_from_base, BASE=main_base, uname=base_uname, status
  ENDIF ELSE BEGIN
    MapBase, Event, uname=uname, status
  ENDELSE
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, FIND_BY_UNAME=draw_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME=draw_uname)
  ENDELSE
  
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, button_image, 0, 0,/true
  
END

;------------------------------------------------------------------------------
;This function will display the right equation corresponding to the axis
;scales selected, if the fitting base is shown
PRO display_right_equation_in_fitting_base, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  equation_to_show = getFittingEquationToShow(Event)
  IF (equation_to_show EQ 'no') THEN BEGIN
    help_label = ''
  ENDIF ELSE BEGIN
    help_label = 'Left clicks to select fitting range'
  ENDELSE
  putTextFieldValue, Event, 'plot_tab_help_label', help_label
  
  id = (*global).plot_tab_fitting_wBase
  IF (WIDGET_INFO(id, /VALID_ID)) THEN BEGIN
    equation_to_show = getFittingEquationToShow(Event)
    display_fitting_base_draw, $
      MAIN_BASE=(*global).plot_tab_fitting_wBase, $
      EQUATION=equation_to_show
  ENDIF
  
END