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

;------------------------------------------------------------------------------
FUNCTION getListOfProposal, instrument, MAIN_BASE
prefix = '/SNSlocal/' + instrument + '/'
cmd_ls = 'ls -dt ' + prefix + '*/'
spawn, cmd_ls, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN ;at least one folder found
    sz = (size(listening))(1)
    index = 0
    ProposalList = STRARR(sz)
    WHILE (index LT sz) DO BEGIN
       split = STRSPLIT(listening[index],'/',/EXTRACT)
       ProposalList[index] = split[N_ELEMENTS(split)-1]
       index++
    ENDWHILE
ENDIF ELSE BEGIN
    ProposalList = ['FOLDER IS EMPTY !']
ENDELSE
RETURN, ProposalList
END

;------------------------------------------------------------------------------
PRO populate_list_of_proposal, MAIN_BASE, instrument

;putMyLogBook_MainBase, MAIN_BASE, '> Get list of proposals:'
ListOfProposal = getListOfProposal(instrument, $
                                   MAIN_BASE)

uname_list = ['empty_cell_proposal_folder_droplist',$
              'data_proposal_folder_droplist',$
              'norm_proposal_folder_droplist']

sz = N_ELEMENTS(uname_list)
FOR i=0,(sz-1) DO BEGIN
  id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME=uname_list[i])
  WIDGET_CONTROL, id, SET_VALUE=ListOfProposal
ENDFOR

END

;------------------------------------------------------------------------------