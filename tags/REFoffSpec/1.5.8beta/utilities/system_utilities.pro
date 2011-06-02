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

;This function returns the ucams of the user
FUNCTION get_ucams
ucams_error = 0
CATCH, ucams_error
IF (ucams_error NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN, 'Undefined'
ENDIF ELSE BEGIN
    spawn, '/usr/bin/whoami', listening
ENDELSE
RETURN, listening[0]
END

;-----------------------------------------------------------------------------

FUNCTION convert_rgb, rgb
COMPILE_OPT idl2, HIDDEN
RETURN, rgb[0] + (rgb[1] * 2L^8) + (rgb[2]*2L^16)
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION getListOfProposal, instrument, ucams, MAIN_BASE

prefix = '/SNS/users/' + ucams + $
  '/data/SNS/' + STRCOMPRESS(instrument,/REMOVE_ALL)

IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE, $
  '> Checking for list of proposal in ' + prefix

cmd_ls = 'ls -dt ' + prefix + '/*'
IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE, $
  '-> cmd: ' + cmd_ls
IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE, $
  '-> List of Proposal Readable by ' + ucams
spawn, cmd_ls, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN ;at least one folder found
    sz = N_ELEMENTS(listening)
    ProposalList = STRARR(sz+1)
    FOR i=0,(sz-1) DO BEGIN
        str_array = STRSPLIT(listening[i],prefix+'*',/EXTRACT,/REGEX)
        folder_with_slash = str_array[0]
        str_array = STRSPLIT(folder_with_slash,'/',/EXTRACT)
        folder_without_slash = str_array[0]
        ProposalList[i] = folder_without_slash
        IDLsendLogBook_addLogBookText_fromMainBase, MAIN_BASE,$
          '   ' + str_array[0]
    ENDFOR
    ProposalList[i] = ['> CHECK IN ALL FOLDERS <']
ENDIF ELSE BEGIN
    ProposalList = ['FOLDER IS EMPTY !']
ENDELSE
RETURN, ProposalList
END

