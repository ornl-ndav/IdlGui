;+
; :Author: scu
;-

PRO ReductionCmd::Cleanup
  
END

function ReductionCmd::Generate

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  cmd = self.program
  
  return, cmd
end

function ReductionCmd::Init, $
    program=program, $                   ; Program name
    version=version, $
    verbose=verbose, $                   ; Verbose flag
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  IF N_ELEMENTS(program) EQ 0 THEN program = "reduction"
  IF N_ELEMENTS(version) EQ 0 THEN version = 0
  IF N_ELEMENTS(verbose) EQ 0 THEN verbose = 1
  
  self.program = program
  self.version = version
  self.verbose = verbose
  self.extra = PTR_NEW(extra)
  
end


pro ReductionCmd__Define

  struct = { REDUCTIONCMD, $
    program: "", $           ; Program name
    version: "", $           ; Program version
    verbose: 0L, $           ; Verbose flag
    extra: PTR_NEW() }       ; Extra keywords
end


