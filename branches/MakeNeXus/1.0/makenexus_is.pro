;===============================================================================
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
;===============================================================================

;####### GENERIC FUNCTIONS #######
FUNCTION isSwitchSelected, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value
END


;###### PARTICULAR FUNCTIONS #########
;this function returns 1 if the prenexus exist and 0 if 
;it does not exist
FUNCTION isPreNexusExistOnDas, Event, RunNumber, Instrument, proposalFolder
;get global structure
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    (*global).prenexus_path      = (*global).mac.prenexus_path
    (*global).prenexus_found_nbr = 1
    RETURN, 1
ENDIF ELSE BEGIN
    defaultPath = instrument + '-DAS-FS'
    cmd = 'findnexus --prenexus --listall --prefix=' $
      + defaultPath + ' -i' + Instrument
    cmd += ' ' + RunNumber
    IF (proposalFolder NE '') THEN BEGIN
        cmd += ' --proposal=' + proposalFolder
    ENDIF
    spawn, cmd, listening
    sz = (size(listening))(1)
    FOR i=0,(sz-1) DO BEGIN
        prenexus_path = listening[i]
        text_to_compare = '/' + instrument + '-DAS-FS/*'
        isOnDas = strmatch(prenexus_path,text_to_compare)
        IF (isOnDas) THEN BEGIN
            (*global).prenexus_path = prenexus_path
            (*global).prenexus_found_nbr = (*global).prenexus_found_nbr + 1
            RETURN, 1
        ENDIF 
    ENDFOR
    (*global).prenexus_path = ''
    RETURN,0
ENDELSE
;(*global).prenexus_path = listening[0]
;result = STRMATCH(listening[0],'ERROR*')
;RETURN, ~result
END

;Returns 1 if the 'Instrument Shared Folder' has been
;selected
FUNCTION isInstrSharedFolderSelected, Event
valueArray = isSwitchSelected(Event,'shared_button')
RETURN, valueArray[0]
END

;Returns 1 if the 'Proposal Shared Folder' has been
;selected
FUNCTION isProposalSharedFolderSelected, Event
valueArray = isSwitchSelected(Event,'shared_button')
RETURN, valueArray[1]
END
