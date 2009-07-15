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

FUNCTION get_bank_tube_row_format, excluded_pixel_array

  list_of_pixels = WHERE(excluded_pixel_array EQ 1, nbr)
  IF (nbr EQ 0) THEN RETURN, ['']
  nbr_pixels = N_ELEMENTS(list_of_pixels)
  preview_array = STRARR(nbr_pixels)
  FOR i=0,(nbr_pixels-1) DO BEGIN
    pixelid = list_of_pixels[i]
    bank_tube_row = getBankTubeRow_from_pixelid(pixelid)
    bank = bank_tube_row[0] + 1
    tube = bank_tube_row[1]
    row  = bank_tube_row[2]
    value = 'bank' + STRCOMPRESS(bank,/REMOVE_ALL)
    value += '_' + STRCOMPRESS(tube,/REMOVE_ALL)
    value += '_' + STRCOMPRESS(row,/REMOVE_ALL)
    preview_array[i] = value
  ENDFOR
  
  RETURN, preview_array
END

;------------------------------------------------------------------------------
PRO apply_new_pixelid, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_mask
  
  global = (*global_mask).global
  main_event = (*global_mask).main_event
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='edit_mask_base_uname')
  
  pixelid_list = getTextFieldValue(Event,'edit_mask_text_field')
  bank_tube_row_array = get_bank_tube_row_array(pixelid_list)
  IF (bank_tube_row_array[0,0] EQ '') THEN BEGIN
    message_text = 'Masking file format is wrong !'
    title = 'ERROR!'
    result = DIALOG_MESSAGE(message_text,$
    /ERROR,$
    DIALOG_PARENT=id,$
    TITLE = title)
    RETURN
  ENDIF
  
  pixelid_list = get_list_of_pixeldID(bank_tube_row_array)
  excluded_pixel_array = INTARR(128L * 400L)
  excluded_pixel_array[pixelid_list] = 1
  
  (*(*global).excluded_pixel_array) = excluded_pixel_array
  replot_main_plot_with_scale, main_event, without_scale=1
  refresh_masking_region, main_event
  
END

;------------------------------------------------------------------------------
PRO edit_mask_build_gui_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_mask
  
  CASE Event.id OF
  
    ;cancel button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='edit_mask_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='edit_mask_base_uname')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ;apply changed
    WIDGET_INFO(Event.top, FIND_BY_UNAME='edit_mask_apply_button'): BEGIN
      apply_new_pixelid, Event
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO edit_mask_build_gui, wBase, main_base_geometry, preview_pixel_array

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize/2 + 350
  yoffset = main_base_yoffset + main_base_ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'List of pixels masked',$
    UNAME        = 'edit_mask_base_uname',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup,$
    /COLUMN)
    
  label = WIDGET_LABEL(wBase,$
    VALUE = 'Input example:  bankB_T_R',$
    FRAME = 1)
  label = WIDGET_LABEL(wBase,$
    VALUE = 'with:  B bank number (1-50)')
  label = WIDGET_LABEL(wBase, $
    VALUE = '       T tube number (0-7)')
  label = WIDGET_LABEL(wBase, $
    VALUE = '       R Row number (0-127)')
    
  text = WIDGET_TEXT(wBase,$
    XSIZE = 35,$
    YSIZE = 50,$
    /EDITABLE,$
    /SCROLL,$
    VALUE = STRCOMPRESS(preview_pixel_array,/REMOVE_ALL),$
    UNAME = 'edit_mask_text_field')
    
  row2 = WIDGET_BASE(wBase,$
    /ROW)
    
  cancel = WIDGET_BUTTON(row2,$
    VALUE = 'CANCEL',$
    UNAME = 'edit_mask_cancel_button')
    
  space = WIDGET_LABEL(row2,$
    VALUE = '  ')
    
  apply = WIDGET_BUTTON(row2,$
    VALUE = 'APPLY CHANGES',$
    UNAME = 'edit_mask_apply_button')
    
  ok = WIDGET_BUTTON(row2,$
    VALUE = 'SAVE CHANGES and QUIT',$
    UNAME = 'edit_mask_ok_button')
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO edit_mask_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='main_plot_base')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  excluded_pixel_array = (*(*global).excluded_pixel_array)
  preview_pixel_array = get_bank_tube_row_format(excluded_pixel_array)
  
  ;build gui
  wBase = ''
  edit_mask_build_gui, wBase, $
    main_base_geometry, $
    preview_pixel_array
    
  global_mask = PTR_NEW({ wbase: wbase,$
    global: global,$
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_mask
  XMANAGER, "edit_mask_build_gui", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END
