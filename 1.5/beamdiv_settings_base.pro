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

PRO beamdiv_settings_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_beamdiv
  global = (*global_beamdiv).global
  main_event = (*global_beamdiv).main_event
  
  CASE Event.id OF
  
   ;ok
   widget_info(event.top, find_by_uname='beamdivergence_ok'): begin
   center_pixel = getTextFieldValue(Event,'beamdivergence_center_pixel')
   detector_resolution = getTextFieldValue(event,$
   'beamdivergence_detector_resolution')
   (*global).center_pixel = center_pixel
   (*global).detector_resolution = detector_resolution
     id = widget_info(Event.top, find_by_uname='beamdiv_settings_base_uname')
     widget_control, id, /destroy
     REFreduction_CommandLineGenerator, main_Event
   end
  
   ;cancel
   widget_info(event.top, find_by_uname='beamdivergence_cancel'): begin
     id = widget_info(Event.top, find_by_uname='beamdiv_settings_base_uname')
     widget_control, id, /destroy
   end
  
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
pro beamdiv_settings_base_gui, wBase, $
    main_base_geometry, $
    center_pixel = center_pixel, $
    spatial_resolution = spatial_resolution
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Beamdivergence Correction',$
    UNAME        = 'beamdiv_settings_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  main_base = WIDGET_BASE(wBase,$
    /COLUMN)
    
  row1 = widget_base(main_base,$
  /row)
  label1 = widget_label(row1,$
  value = '       Center pixel:')
  value1 = widget_text(row1,$
  value = center_pixel,$
  /editable,$
  scr_xsize = 100,$
  uname = 'beamdivergence_center_pixel')
  
  row2 = widget_base(main_base,$
  /row)
  label1 = widget_label(row2,$
  value = 'Detector resolution:')  
  value1 = widget_text(row2,$
  value = spatial_resolution,$
  /editable,$
  scr_xsize = 60,$
  uname = 'beamdivergence_detector_resolution')
  label2 = widget_label(row2,$
  value = 'mm')  
    
  space = widget_label(main_base,$
  value = '')
  
  row3  = widget_base(main_base,$
  /row)
  cancel = widget_button(row3,$
  value = 'CANCEL',$
  scr_xsize = 100,$
  uname = 'beamdivergence_cancel')
  space = widget_label(row3,$
  value = '     ')
  ok = widget_button(row3,$
  value = 'OK',$
  scr_xsize = 100,$
  uname = 'beamdivergence_ok')
    
end

;------------------------------------------------------------------------------
pro beamdiv_settings_base, Event

    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase1 = ''
  beamdiv_settings_base_gui, wBase1, $
    main_base_geometry, $
    center_pixel = (*global).center_pixel, $
    spatial_resolution = (*global).detector_resolution
    
  (*global).beamdiv_settings_base_id = wBase1
  
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_beamdiv = PTR_NEW({ wbase: wbase1,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_beamdiv
  
  XMANAGER, "beamdiv_settings_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END

