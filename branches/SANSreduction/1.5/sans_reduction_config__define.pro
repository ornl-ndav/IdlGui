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

PRO sans_reduction_config::Cleanup
  PTR_FREE, self.extra
END

PRO sans_reduction_config::GetProperty, $
    Program=program, $                   ; Program name
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  IF ARG_PRESENT(Program) NE 0 THEN Program = self.program
  
END

;------------------------------------------------------------------------------
PRO sans_reduction_config::SetProperty, $
    Program=program, $                   ; Program name
    _Extra=extra
    
  ; Error Handling
  CATCH, theError
  IF theError NE 0 THEN BEGIN
    CATCH, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    RETURN
  ENDIF
  
  IF N_ELEMENTS(program) NE 0 THEN self.program = program
  IF N_ELEMENTS(extra) NE 0 THEN *self.extra = extra
  
END

;-----------------------------------------------------------------------------
FUNCTION sans_reduction_config::Init, $
    Program=program, $
    _Extra=extra
    
  ; Error Handling
  CATCH, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    RETURN, 0
  ENDIF
  
  IF N_ELEMENTS(program) EQ 0 THEN program = "blabla"
  self.program = program
  
  self.extra = PTR_NEW(extra)
  
  RETURN, 1
END

;------------------------------------------------------------------------------
PRO sans_reduction_config__define

  struct = { sans_reduction_config, $
    program: "", $
    extra: PTR_NEW() }       ; Extra keywords
    
END