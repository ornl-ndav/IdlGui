; $Id: //depot/idl/releases/IDL_80/idldir/lib/obsolete/itresolve.pro#1 $
; Copyright (c) 2003-2010, ITT Visual Information Solutions. All
;       rights reserved. Unauthorized reproduction is prohibited.
;+
; Name:
;   ITRESOLVE
;
; Purpose:
;   Resolves all IDL code within the iTools directory, as well
;   as all other necessary IDL code. Useful for constructing save
;   files containing user code that requires the iTools framework.
;
; Arguments:
;   None.
;
; Keywords:
;   PATH: Set this keyword to a string giving the full path to the iTools
;       directory. The default is to use the lib/itools subdirectory
;       within which the ITRESOLVE procedure resides.
;
; MODIFICATION HISTORY:
;   Written by:  CT, RSI, June 2003
;   Modified:
;


;-------------------------------------------------------------------------
pro itresolve, PATH=pathIn

    compile_opt idl2, hidden

    iResolve, PATH=pathIn

end

