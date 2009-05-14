;+
; :Author: scu
;-

PRO ReductionCmd::Cleanup
  PTR_FREE, self.extra
END

PRO ReductionCmd::SetProperty, $
    Program=program, $                   ; Program name
    Version=version, $
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    Instrument=instrument, $             ; Instrument Name
    SPE=spe, $                           ; Create SPE/PHX files
    CornerGeometry=cornergeometry, $     ; Corner Geometry filename
    
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  IF N_ELEMENTS(program) NE 0 THEN self.program = program
  IF N_ELEMENTS(version) NE 0 THEN self.version = version
  IF N_ELEMENTS(verbose) NE 0 THEN self.verbose = verbose
  IF N_ELEMENTS(quiet) NE 0 THEN self.quiet = quiet
  IF N_ELEMENTS(instrument) NE 0 THEN self.instrument = instrument
  IF N_ELEMENTS(spe) NE 0 THEN self.spe = spe
  IF N_ELEMENTS(CornerGeometry) NE 0 THEN self.cornergeometry = cornergeometry
  
  IF N_ELEMENTS(extra) NE 0 THEN *self.extra = extra
  
END

function ReductionCmd::Generate

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  ; Let's first start with the program name!
  cmd = self.program
  
  ; Various flags
  IF (self.verbose EQ 1) THEN cmd += " -v"
  IF (self.quiet EQ 1) THEN cmd += " -q"
  IF STRLEN(self.instrument) GT 1 THEN $
    cmd += " -i "+self.instrument
  IF (self.spe EQ 1) THEN cmd+= " --enable-spe"
  IF STRLEN(self.cornergeometry) GT 1 THEN $
    cmd += " --corner-geom="+self.cornergeometry
    
  return, cmd
end

function ReductionCmd::Init, $
    Program=program, $                   ; Program name
    Version=version, $
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    Instrument=instrument, $             ; Instrument Name
    SPE=spe, $                           ; Create SPE/PHX files
    CornerGeometry=cornergeometry, $     ; Corner Geometry filename
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  IF N_ELEMENTS(program) EQ 0 THEN program = "dgs_reduction"
  IF N_ELEMENTS(version) EQ 0 THEN version = 0
  IF N_ELEMENTS(verbose) EQ 0 THEN verbose = 1
  IF N_ELEMENTS(instrument) EQ 0 THEN instrument = ""
  IF N_ELEMENTS(cornergeometry) EQ 0 THEN cornergeometry = ""
  IF N_ELEMENTS(spe) eq 0 THEN spe = 1
  
  IF N_ELEMENTS(quiet) EQ 0 THEN quiet = 0
  
  self.program = program
  self.version = version
  self.verbose = verbose
  self.quiet = quiet
  self.instrument = instrument
  self.spe = spe
  self.cornergeometry = cornergeometry
  self.extra = PTR_NEW(extra)
  
  RETURN, 1
end

;+
; :Description:
;    ReductionCmd Define.
;
; :Author: scu
;-
pro ReductionCmd__Define

  struct = { REDUCTIONCMD, $
    program: "", $           ; Program name
    version: "", $           ; Program version
    verbose: 0L, $           ; Verbose flag
    quiet: 0L, $             ; Quiet flag
    instrument: "", $        ; Instrument (short) name
    spe: 0L, $               : SPE file creation
    cornergeometry: "", $    ; Corner Geometry File
    extra: PTR_NEW() }       ; Extra keywords
end
