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
;    Main routine of application. Will build and start the application
;
; :Keywords:
;    GROUP_LEADER
;    _EXTRA
;
; :Author: j35
;-
pro BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  compile_opt idl2
   
  ;retrieve the global structure
  global = getGlobal()
  
  MainBaseTitle  = 'iMAging Reduction Software (iMars)'
  
  ;initialize log book message
  date = GenerateReadableIsoTimeStamp()
  log_book = ['------------------------------------------------------------',$
    'Log Book of iMars',' Application started at: ' + date]
  (*(*global).log_book) = log_book
  
  ;Build Main Base
  main_base = Widget_Base( GROUP_LEADER = wGroup,$
    UNAME        = 'MAIN_BASE',$
    TITLE        = MainBaseTitle,$
    SPACE        = 0,$
    XPAD         = 0,$
    YPAD         = 2,$
    MBAR         = top_base_menu)
  (*global).top_base = main_base
    
  build_menu, top_base_menu
  build_gui, main_base, global
  
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, main_base, SET_UVALUE=global
  
  Widget_Control, /REALIZE, main_base
  XManager, 'MAIN_BASE', main_base, /NO_BLOCK, CLEANUP='iMars_cleanup'
  
  ;initialize all the buttons
  initialize_all_images, main_base=main_base

  DEVICE, DECOMPOSED = 0
  loadct, (*global).default_colorbar, /silent
  
;  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
end

;+
; :Description:
;    Application __main__ function
;
;
;
; :Keywords:
;    GROUP_LEADER
;    _EXTRA
;
; :Author: j35
;-
pro iMars, GROUP_LEADER=wGroup,_EXTRA=_VWBExtra_
  compile_opt idl2
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





