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
FUNCTION getRunNumber, Event
id = widget_info(Event.top,find_by_uname='run_number_cw_field')
widget_control, id, get_value=RunNumber
RETURN, strcompress(RunNumber,/remove_all)
END

;------------------------------------------------------------------------------
FUNCTION StringSplit, delimiter, text
RETURN, strsplit(text, delimiter,/extract)
END

;------------------------------------------------------------------------------
FUNCTION CreateList, text2
ON_IOERROR, L1 ;in case one of the variable can't be converted
;into an int
FixText2 = Fix(Text2)
min = MIN(FixText2,MAX=max)
list = lonarr(1)
list[0] = min
FOR i=1,(max-min) DO BEGIN
    list = [list,min+i]
ENDFOR
RETURN, list
return, [val1,val2]
L1: return, ''
END

;------------------------------------------------------------------------------
FUNCTION getListOfRuns, RunNumber
;parse according to ','
text1 = StringSplit(',',RunNumber)
;parse accordint to '-'
sz = (size(text1))(1)
FOR i=0,(sz-1) DO BEGIN
    text2 = StringSplit('-',text1[i])
    sz = (size(text2))(1)
    IF (sz GT 1) THEN BEGIN ;'10-15'
        list_to_add = CreateList(text2)
        IF (list_to_add NE [''] OR $
            list_to_add[0] EQ 0) THEN BEGIN
            list_to_add = string(list_to_add)
            IF (i EQ 0) THEN BEGIN ;only for first iteration
                List = list_to_add
            ENDIF ELSE BEGIN
                List = [List, list_to_add]
            ENDELSE
        ENDIF
    ENDIF ELSE BEGIN ;10
        IF (i EQ 0) THEN BEGIN ;only for first iteration
            List = text2
        ENDIF ELSE BEGIN
            List = [List, text2]
        ENDELSE
    ENDELSE
ENDFOR
return, strcompress(List,/remove_all)
END

;------------------------------------------------------------------------------
FUNCTION getInstrument, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
id = widget_info(Event.top,find_by_uname='instrument_droplist')
index = widget_info(id, /droplist_select)
instrumentShortList = (*(*global).instrumentShortList)
RETURN, instrumentShortList[index]
END

;------------------------------------------------------------------------------
FUNCTION getOutputPath, Event
id = widget_info(Event.top,find_by_uname='output_path_text')
widget_control, id, get_value=outputPath
RETURN,strcompress(outputPath,/remove_all)
END

;------------------------------------------------------------------------------
FUNCTION getLogBookText, Event
id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, get_value=text
RETURN, text
END

;------------------------------------------------------------------------------
FUNCTION getMyLogBookText, Event
id = widget_info(Event.top,find_by_uname='my_log_book')
widget_control, id, get_value=text
RETURN, text
END

;------------------------------------------------------------------------------
FUNCTION getTextFieldValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getProposalNumber, Event, prenexus_path
textSplit = strsplit(prenexus_path,'/',/extract)
RETURN, textSplit[1]
END

;------------------------------------------------------------------------------
FUNCTION getNbrPolaState, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, 0
ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        appendMyLogBook, Event, 'ERROR in getNbrPolaState: ' + $
          !ERROR_STATE.MSG
        CATCH,/CANCEL
        RETURN, '0'
    ENDIF ELSE BEGIN
        oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('States')
        obj3=obj2->item(0)
        obj3b=obj3->getattributes()
        obj3c=obj3b->getnameditem('number')
        result = STRCOMPRESS(obj3c->getvalue())
        OBJ_DESTROY, oDocList
        RETURN, result
    ENDELSE
ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getBinTypeFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, 'linear'
ENDIF ELSE BEGIN
    no_error = 0
    ;CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        appendMyLogBook, Event, 'ERROR in getBinTypeFromDas: ' + $
          !ERROR_STATE.MSG
        CATCH,/CANCEL
        RETURN, 'linear'
    ENDIF ELSE BEGIN
        oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('scale')
        result = STRCOMPRESS(obj4c->getvalue())
        OBJ_DESTROY, oDocList
        RETURN, result
    ENDELSE
ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getBinOffsetFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, '0'
ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        appendMyLogBook, Event, 'ERROR in getBinOffsetFromDas: ' + $
          !ERROR_STATE.MSG
        CATCH,/CANCEL
        RETURN, '0'
    ENDIF ELSE BEGIN
        oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('startbin')
        result = STRCOMPRESS(obj4c->getvalue())
        OBJ_DESTROY, oDocList
        RETURN, result
    ENDELSE
ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getBinMaxSetFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, '100000'
ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        appendMyLogBook, Event, 'ERROR in getBinMaxSetFromDas: ' + $
          !ERROR_STATE.MSG
        CATCH,/CANCEL
        RETURN, '0'
    ENDIF ELSE BEGIN
        oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('endbin')
        result = STRCOMPRESS(obj4c->getvalue())
        OBJ_DESTROY, oDocList
        RETURN, result
    ENDELSE
ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getBinWidthSetFromDas, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, '200'
ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        appendMyLogBook, Event, 'ERROR in getBinWidthFromDas: ' + $
          !ERROR_STATE.MSG
        CATCH,/CANCEL
        RETURN, '0'
    ENDIF ELSE BEGIN
        oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('Scattering')
        obj3=obj2->item(0)
        obj4=obj3->GetElementsByTagName('NumTimeChannels')
        obj4a=obj4->item(0)
        obj4b=obj4a->getattributes()
        obj4c=obj4b->getnameditem('width')
        result = STRCOMPRESS(obj4c->getvalue())
        OBJ_DESTROY, oDocList
        RETURN, result
    ENDELSE
ENDELSE
END

;------------------------------------------------------------------------------
;Gives the total number of pixels
FUNCTION getTotalNbrPixel, base_file_name
file_name = base_file_name + '_runinfo.xml'
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    RETURN, '77824' ;REF_L
ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        appendMyLogBook, Event, 'ERROR in getTotalNbrPixel: ' + $
          !ERROR_STATE.MSG
        CATCH,/CANCEL
        OBJ_DESTROY, oDocList
        RETURN, '0'
    ENDIF ELSE BEGIN
        oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('MaxScatPixelID')
        obj3=obj2->item(0)
        obj4=obj3->GetFirstChild()
        result = STRCOMPRESS(obj4->getNodevalue(),/REMOVE_ALL)
        OBJ_DESTROY, oDoc
        RETURN, result
    ENDELSE
ENDELSE
END

FUNCTION getBinType, Event
id = widget_info(Event.top,find_by_uname='bin_type_droplist')
index = widget_info(id, /droplist_select)
RETURN, index
END

;------------------------------------------------------------------------------
FUNCTION getBinWidth, Event
id = widget_info(Event.top,find_by_uname='time_bin')
widget_control, id, get_value=value
RETURN, strcompress(value,/remove_all)
END

;------------------------------------------------------------------------------
FUNCTION getBinOffset, Event
id = widget_info(Event.top,find_by_uname='time_offset')
widget_control, id, get_value=value
RETURN, strcompress(value,/remove_all)
END

;------------------------------------------------------------------------------
FUNCTION getBinMax, Event
id = widget_info(Event.top,find_by_uname='time_max')
widget_control, id, get_value=value
RETURN, strcompress(value,/remove_all)
END

;------------------------------------------------------------------------------
FUNCTION getListOfProposal, instrument, MAIN_BASE
prefix = '/' + instrument + '-DAS-FS/'
cmd_ls = 'ls -dt ' + prefix + '/*/'
print, cmd_ls
spawn, cmd_ls, listening, err_listening
print, listening
print, err_listening
IF (err_listening[0] EQ '') THEN BEGIN ;at least one folder found
    sz = (size(listening))(1)
    AppendMyLogBook_MainBase, MAIN_BASE, $
      '-> Found ' + STRCOMPRESS(sz) + ' folders'
    AppendMyLogBook_MainBase, MAIN_BASE, '-> List of folders:'
    nbr_folder_readable = 0
    FOR i=0,(sz-1) DO BEGIN
       IF (FILE_TEST(listening[i],/DIRECTORY,/READ)) THEN BEGIN
           str_array = STRSPLIT(listening[i],prefix+'*',/EXTRACT,/REGEX)
           current_proposal = str_array[0]
           IF (nbr_folder_readable EQ 0) THEN BEGIN
               ProposalList = [current_proposal]
           ENDIF ELSE BEGIN
               ProposalList = [ProposalList,current_proposal]
           ENDELSE
           text = '--> ' + current_proposal + ' IS READABLE BY USER ... YES'
           nbr_folder_readable++
       ENDIF ELSE BEGIN
           text = '--> ' + current_proposal + ' IS READABLE BY USER ... NO'
       ENDELSE
       AppendMyLogBook_MainBase, MAIN_BASE, text
   ENDFOR
   text = '-> Final list of folders the user can see is:'
   AppendMyLogBook_MainBase, MAIN_BASE, text
   proposal_array = STRJOIN(ProposalList,' ; ')
   AppendMyLogBook_MainBase, MAIN_BASE, '--> ' + proposal_array
   ProposalList = [ProposalList, 'ALL PROPOSAL FOLDERS']
;    ProposalList = STRARR(sz+1)
;    FOR i=0,(sz-1) DO BEGIN
;        str_array = STRSPLIT(listening[i],prefix+'*',/EXTRACT,/REGEX)
;        ProposalList[i]=str_array[0]
;    ENDFOR
;    ProposalList[sz] = 'ALL PROPOSAL FOLDERS'
ENDIF ELSE BEGIN
    ProposalList = ['FOLDER IS EMPTY !']
ENDELSE
RETURN, ProposalList
END

;------------------------------------------------------------------------------
FUNCTION getListOfProposal_event, instrument, Event
prefix = '/' + instrument + '-DAS-FS/'
cmd_ls = 'ls -dt ' + prefix + '/*/'
spawn, cmd_ls, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN ;at least one folder found
    sz = (size(listening))(1)
    AppendMyLogBook, Event, $
      '-> Found ' + STRCOMPRESS(sz) + ' folders'
    AppendMyLogBook, Event, '-> List of folders:'
    nbr_folder_readable = 0
    FOR i=0,(sz-1) DO BEGIN
       IF (FILE_TEST(listening[i],/DIRECTORY,/READ)) THEN BEGIN
           str_array = STRSPLIT(listening[i],prefix+'*',/EXTRACT,/REGEX)
           current_proposal = str_array[0]
           IF (nbr_folder_readable EQ 0) THEN BEGIN
               ProposalList = [current_proposal]
           ENDIF ELSE BEGIN
               ProposalList = [ProposalList,current_proposal]
           ENDELSE
           text = '--> ' + current_proposal + ' IS READABLE BY USER ... YES'
           nbr_folder_readable++
       ENDIF ELSE BEGIN
           text = '--> ' + current_proposal + ' IS READABLE BY USER ... NO'
       ENDELSE
       AppendMyLogBook, Event, text
   ENDFOR
   text = '-> Final list of folders the user can see is:'
   AppendMyLogBook, Event, text
   proposal_array = STRJOIN(ProposalList,' ; ')
   AppendMyLogBook, Event, '--> ' + proposal_array
   ProposalList = [ProposalList, 'ALL PROPOSAL FOLDERS']
;    ProposalList = STRARR(sz+1)
;    FOR i=0,(sz-1) DO BEGIN
;        str_array = STRSPLIT(listening[i],prefix+'*',/EXTRACT,/REGEX)
;        ProposalList[i]=str_array[0]
;    ENDFOR
;    ProposalList[sz] = 'ALL PROPOSAL FOLDERS'
ENDIF ELSE BEGIN
    ProposalList = ['FOLDER IS EMPTY !']
ENDELSE
RETURN, ProposalList
END

;------------------------------------------------------------------------------
FUNCTION getProposalSelected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='proposal_droplist')
index = WIDGET_INFO(id, /DROPLIST_SELECT)
WIDGET_CONTROL, id, GET_VALUE=list
sz = (size(list))(1)
IF (index EQ (sz-1)) THEN RETURN, ''
RETURN, list[index]
END

;------------------------------------------------------------------------------
FUNCTION get_up_to_date_geo_tran_map_file, instrument
cmd = 'findcalib -i' + instrument
spawn, cmd, listening, err_listening
IF (err_listening[0] NE '') THEN BEGIN
    RETURN = STRARR(3)
ENDIF ELSE BEGIN
    RETURN, listening
ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getIndexOfProposalInNewList, ListOfProposal, currentProposalSelected
sz = (size(ListOfProposal))(1)
IF (sz GT 1) THEN BEGIN
FOR i=0,(sz-1) DO BEGIN
    IF (ListOfProposal[i] EQ currentProposalSelected) THEN BEGIN
        RETURN, i
    ENDIF
ENDFOR
ENDIF ELSE BEGIN
    RETURN, 0
ENDELSE
RETURN, 0
END

;------------------------------------------------------------------------------
;Get the selected runinfo from the droplist
FUNCTION getRunInfoFileName, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='preview_droplist')
index = WIDGET_INFO(id, /DROPLIST_SELECT)
WIDGET_CONTROL, id, GET_VALUE=list
RETURN, list[index]
END

;------------------------------------------------------------------------------
;Get the selected runinfo index
FUNCTION getSelectedPreviewIndex, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='preview_droplist')
index = WIDGET_INFO(id, /DROPLIST_SELECT)
RETURN, index
END
