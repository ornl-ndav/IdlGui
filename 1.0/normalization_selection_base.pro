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

;+
; :Description:
;   main base event
;
; :Params:
;   Event
;
; :Author: j35
;-
pro normalization_selection_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_norm
  main_event = (*global_norm).main_event
  
  case Event.id of
  
    widget_info(event.top, $
      find_by_uname='normalization_base_cancel'): begin
      
      id = widget_info(Event.top, $
        find_by_uname='normalization_selection_base')
      widget_control, id, /destroy
      
      return
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;   create the base
;
; :Params:
;    wBase
;    main_base_geometry
;    normalization_files
;    global
;
; :Keywords:    
;    data_file
;
; :Author: j35
;-
pro normalization_selection_base_gui, wBase, $
    main_base_geometry, $
    normalization_files, $
    global, $
    data_file = data_file

  compile_opt idl2
  
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize/2.
  yoffset = main_base_yoffset + main_base_ysize/2.
  
  ourGroup = WIDGET_BASE()
  
  title = 'Select normalization file!'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'normalization_selection_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    /modal, $
    /column, $
    GROUP_LEADER = ourGroup)

  label = widget_label(wBase,$
  value = 'Please select the normalization file for the following data file:')
  label2 = widget_label(wBase,$
  value = data_file)

  normalization_files = reform(normalization_files)
  max_nbr_data_nexus = (*global).max_nbr_data_nexus
  table = widget_table(wBase,$
    value = normalization_files, $
    uname = 'normalization_table',$
    xsize = 1,$
    ysize = max_nbr_data_nexus,$
    column_labels = ['Normalization files'],$
    /no_row_headers,$
        column_widths = [625])

  ;row2
  row2 = widget_base(wBase,$
  /align_center,$
  /row)
  cancel = widget_button(row2,$
  value= 'CANCEL',$
  xsize = 100,$
  uname = 'normalization_base_cancel')
  space = widget_label(row2,$
  value = '                                             ')
  ok = widget_button(row2,$
  value = 'OK',$
  xsize = 100,$
  uname = 'normalization_base_ok')

        
end

;+
; :Description:
;
;
; :Keywords:
;    main_base
;    event
;    row_selected
;
; :Author: j35
;-
pro normalization_selection_base, main_base_uname=main_base_uname, $
    event=event, $
    row_selected = row_selected
    
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=main_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;SETUP
  border = 40
  colorbar_xsize = 70
  
  table_value = getValue(event=event, uname='tab1_table')
  normalization_files = table_value[1,*]
  data_file = table_value[0,row_selected]
  
  ;build gui
  wBase = ''
  normalization_selection_base_gui, wBase, $
    main_base_geometry, $
    normalization_files, $
    global, $
    data_file = data_file
    
  widget_control, wBase, /realize
  
  global_norm = PTR_NEW({ wbase: wbase,$
    global: global, $
    normalization_files: normalization_files, $
    main_event: event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_norm
  
  XMANAGER, "normalization_selection_base", wBase, GROUP_LEADER = ourGroup, $
  /NO_BLOCK
    
end

