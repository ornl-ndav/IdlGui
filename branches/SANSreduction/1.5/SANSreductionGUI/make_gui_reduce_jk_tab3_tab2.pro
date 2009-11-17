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

PRO make_gui_reduce_jk_tab3_tab2, advanced_base, tab_size, tab_title

  ;= Build Widgets ==============================================================
  BaseTab = WIDGET_BASE(advanced_base,$
    UNAME     = 'reduce_jk_tab3_tab1_base_uname',$
    XOFFSET   = tab_size[0],$
    YOFFSET   = tab_size[1],$
    SCR_XSIZE = tab_size[2],$
    SCR_YSIZE = tab_size[3],$
    TITLE     = tab_title)
    
  ;Transmission label
  xoff = 25
  label = WIDGET_LABEL(BaseTab,$
    XOFFSET = xoff,$
    YOFFSET = 95,$
    VALUE = 'Transmission')
    
  base = WIDGET_BASE(BaseTab,$
    /COLUMN)
    
  row1 = WIDGET_BASE(base,$
    /ROW)
  yesno = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE)
  yes = WIDGET_BUTTON(yesno,$
    VALUE = 'Yes')
  no = WIDGET_BUTTON(yesno,$
    VALUE = 'No')
  WIDGET_CONTROL, yes, /SET_BUTTON
  label = WIDGET_LABEL(row1,$
    VALUE = 'Correction for source spectrum using transmission at the center.')
    
  row2 = WIDGET_BASE(base,$
    /ROW)
  yesno = WIDGET_BASE(row2,$
    /ROW,$
    /EXCLUSIVE)
  yes = WIDGET_BUTTON(yesno,$
    VALUE = 'Yes')
  no = WIDGET_BUTTON(yesno,$
    VALUE = 'No')
  WIDGET_CONTROL, yes, /SET_BUTTON
  label = WIDGET_LABEL(row2,$
    VALUE = 'Correction for Q-coverage difference for different ' + $
    'wavlength neutrons.')
    
  space = WIDGET_LABEL(base,$
    VALUE = ' ')
    
  ;Transmission
  frame1 = WIDGET_BASE(base,$
    FRAME = 1,$
    /COLUMN)
  row1 = WIDGET_BASE(frame1,$
    /ROW)
  yesno = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE)
  yes = WIDGET_BUTTON(yesno,$
    UNAME = 'reduce_jk_tab3_tab2_auto_find_transmission_yes',$
    /NO_RELEASE,$
    VALUE = 'Yes')
  no = WIDGET_BUTTON(yesno,$
    UNAME = 'reduce_jk_tab3_tab2_auto_find_transmission_no',$
    /NO_RELEASE,$
    VALUE = 'No')
  WIDGET_CONTROL, no, /SET_BUTTON
  label = WIDGET_LABEL(row1,$
    VALUE = 'Auto find Transmission')
    
    
  row2 = WIDGET_BASE(frame1,$
    SENSITIVE = 1,$
    UNAME = 'reduce_jk_tab3_tab2_auto_find_transmission_base',$
    /COLUMN)
  label = WIDGET_LABEL(row2,$
    VALUE = ' Number of Pixels on each side of Spectrum for calculating ' + $
    'transmission')
  row2 = WIDGET_BASE(row2, $
    /ROW)
  space = '        '
  label = WIDGET_LABEL(row2,$
    VALUE = space)
  label = WIDGET_LABEL(row2,$
    VALUE = 'x-axis:')
  value = WIDGET_TEXT(row2,$
    VALUE = '2',$
    XSIZE = 2)
  label = WIDGET_LABEL(row2,$
    VALUE = space)
  label = WIDGET_LABEL(row2,$
    VALUE = 'y-axis:')
  value = WIDGET_TEXT(row2,$
    VALUE = '2',$
    XSIZE = 2)
    
  space = WIDGET_LABEL(base,$
    VALUE = ' ')
    
  ;Nbr of time channel
  row2 = WIDGET_BASE(base,$
    /Row)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Number of time channel slices:')
  value = WIDGET_TEXT(row2,$
    VALUE = '400',$
    XSIZE = 5,$
    /EDITABLE)
  label = WIDGET_LABEL(row2,$
    VALUE = '(Used for save tof slices and source spectrum correction')
    
  ;source frequency
  row3 = WIDGET_BASE(base,$
    /Row)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Source frequency:')
  value = WIDGET_TEXT(row3,$
    VALUE = '60',$
    UNAME = 'reduce_jk_tab3_tab2_source_frequency',$
    XSIZE = 5,$
    /EDITABLE)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Hz')
    
  ;frame TOF offset
  row3 = WIDGET_BASE(base,$
    /Row)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Frame TOF offset (or start of the frame):')
  value = WIDGET_TEXT(row3,$
    VALUE = '0',$
    XSIZE = 5,$
    /EDITABLE)
  label = WIDGET_LABEL(row3,$
    VALUE = 'us')
    
  ;Half width of the proton pulse
  row3 = WIDGET_BASE(base,$
    /Row)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Half width of the proton pulse to be excluded from data:')
  value = WIDGET_TEXT(row3,$
    VALUE = '0',$
    XSIZE = 5,$
    /EDITABLE)
  label = WIDGET_LABEL(row3,$
    VALUE = 'us')
    
  ;Discard data
  row3 = WIDGET_BASE(base,$
    /Row)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Discard data at the beginning ')
  value = WIDGET_TEXT(row3,$
    VALUE = '0',$
    XSIZE = 5,$
    /EDITABLE)
  label = WIDGET_LABEL(row3,$
    VALUE = ' and end ')
  value = WIDGET_TEXT(row3,$
    VALUE = '0',$
    XSIZE = 5,$
    /EDITABLE)
  label = WIDGET_LABEL(row3,$
    VALUE = ' of a frame   ')
  ;micro or angstroms
  ma_base = WIDGET_BASE(row3,$
    /EXCLUSIVE, $
    /ROW)
  button1 = WIDGET_BUTTON(ma_base,$
    VALUE = 'us')
  button2 = WIDGET_BUTTON(ma_base,$
    VALUE = 'Angstroms')
  WIDGET_CONTROL, button1, /SET_BUTTON
  
;frame wavelength offset
  row3 = WIDGET_BASE(base,$
  /ROW)
  label = WIDGET_LABEL(row3,$
  VALUE = 'Frame wavelength offset')
  value = WIDGET_TEXT(row3,$
  VALUE = '0',$
  XSIZE = 3,$
  /EDITABLE)
  label = WIDGET_LABEL(row3,$
  VALUE = 'Angstroms')
  
  
  
  
  
  
  
END
