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

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Returns the Run Number from the INPUT base
FUNCTION getEventRunNumber, Event
  id = WIDGET_INFO(Event.top,find_by_uname='run_number')
  WIDGET_CONTROL, id, get_value=RunNumber
  RETURN, STRCOMPRESS(RunNumber,/remove_all)
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Returns the contain of the Event file widget_text (in INPUT base)
FUNCTION getEventFile, Event
  id = WIDGET_INFO(Event.top,find_by_uname='event_file')
  WIDGET_CONTROL, id, get_value=event_file
  RETURN, event_file
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Returns the full path up to the prenexus folder
;example: /CNCS-DAS-FS/2007_1_18_SCI/CNCS_16/
FUNCTION getRunPath, Event, RunNumber, runFullPath
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ;get global structure
    id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,id,get_uvalue=global
    runFullPath = (*global).mac_CNCS_folder
    RETURN, 1
  ENDIF ELSE BEGIN
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
      CATCH,/cancel
      RETURN, 0
    ENDIF ELSE BEGIN
      SPAWN, 'findnexus -iCNCS --prenexus ' + RunNumber, listening
      IF (STRMATCH(listening[0],'*ERROR*')) THEN BEGIN
        RETURN, 0
      ENDIF ELSE BEGIN
        runFullPath = listening[0]
        RETURN, 1
      ENDELSE
    ENDELSE
  ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Get the list of mapping files
FUNCTION getMappingFileList
  cmd = 'findcalib -m --listall -iCNCS'
  SPAWN, cmd, listening, err_listening
  IF (err_listening[0] EQ '') THEN BEGIN
    RETURN, listening
  ENDIF ELSE BEGIN
    RETURN, ['']
  ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get value of text field
FUNCTION getTextFieldValue, Event, Uname
  id = WIDGET_INFO(Event.top,find_by_uname=Uname)
  WIDGET_CONTROL, id, get_value=value
  RETURN, STRCOMPRESS(value,/remove_all)
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get value status text_field
FUNCTION getStatusTextFieldValue, Event
  id = WIDGET_INFO(Event.top,find_by_uname='send_to_geek_message_text')
  WIDGET_CONTROL, id, get_value=value
  RETURN, value
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;retrieve selected mapping file from droplist
FUNCTION getMappingFile, Event
  ;get selected index
  id = WIDGET_INFO(Event.top, find_by_uname ='mapping_droplist')
  index_selected = WIDGET_INFO(id, /droplist_select)
  WIDGET_CONTROL, id, get_value=array
  RETURN, array[index_selected]
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get histogram type 0:linear 1:log
FUNCTION getHistogramType, Event
  id = WIDGET_INFO(Event.top, find_by_uname ='bin_type_droplist')
  index_selected = WIDGET_INFO(id, /droplist_select)
  RETURN, index_selected
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get full name of histo mapped file
FUNCTION getHistoMappedFileName, event_file_full_name, staging_folder
  event_file_only_array = strsplit(event_file_full_name,'/',/extract, $
    /regex,count=length)
  file_base = strsplit(event_file_only_array[length-1] ,'event.dat', $
    /extract,/regex,count=length)
  histo_file_name = file_base + 'histo_mapped.dat'
  histo_file_full_name = staging_folder + histo_file_name
  RETURN, histo_file_full_name
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get full contain of log book
FUNCTION getLogBookText, Event
  id = WIDGET_INFO(Event.top,find_by_uname='log_book')
  WIDGET_CONTROL, id, get_value=text
  RETURN, text
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the column of the bank selected
FUNCTION getColumnMainPlot, X
  Xwidth = 32
  FOR i=0,35 DO BEGIN
    xoff = i*36
    xmin = xoff
    xmax = xmin + Xwidth
    IF (X GE xmin AND X LE xmax) THEN RETURN, (i+1)
  ENDFOR
  
  FOR i=38,51 DO BEGIN
    xoff = i*36
    xmin = xoff
    xmax = xmin + Xwidth
    IF (X GE xmin AND X LE xmax) THEN RETURN, (i-1)
  ENDFOR
  
  RETURN, 0
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the column of the bank selected
FUNCTION getBankTubeMainPlot, X
  Xwidth = 32
  FOR i=0,35 DO BEGIN
    xoff = i*36
    ;    xmin = 10 + xoff
    xmin = xoff
    xmax = xmin + Xwidth
    IF (X GE xmin AND X LE xmax) THEN BEGIN
      bank = (i+1)
      delta_x = (X - xmin)
      tube = FIX(delta_x / 4.)
      RETURN, [bank,tube]
    ENDIF
  ENDFOR
  
  FOR i=38,51 DO BEGIN
    xoff = i*36
    ;    xmin = 10 + xoff
    xmin = xoff
    xmax = xmin + Xwidth
    IF (X GE xmin AND X LE xmax) THEN BEGIN
      bank = (i-1)
      delta_x = (X - xmin)
      tube = FIX(delta_x / 4.)
      RETURN, [bank,tube]
    ENDIF
  ENDFOR
  
  RETURN, [0,0]
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;this is used to determine the index of the bank
;L1 -> 0, L2 -> 1, M1 -> 38 ....
FUNCTION getColumnMainPlotIndex, X
  Xwidth = 32
  FOR i=0,50 DO BEGIN
    xoff = i*36
    xmin = xoff
    xmax = xmin + Xwidth
    IF (X GE xmin AND X LE xmax) THEN RETURN, (i)
  ENDFOR
  RETURN, -1
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the row of the bank selected
FUNCTION getRowMainPlot, Y
  YposArray = ['L','M','T']
  Ywidth    = 256
  FOR i=0,2 DO BEGIN
    yoff = i * (256+5)
    ymin = 5 + yoff
    ymax = ymin + Ywidth
    IF (Y GE ymin AND Y LE ymax) THEN RETURN, YposArray[i]
  ENDFOR
  RETURN, ''
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;this is used to determine the index of the bank
;L1 -> 0, L2 -> 1, M1 -> 38 ....
FUNCTION getRowMainPlotIndex, Y
  YposArray = [0,1,2]
  Ywidth    = 256
  FOR i=0,2 DO BEGIN
    yoff = i * (256+5)
    ymin = 5 + yoff
    ymax = ymin + Ywidth
    IF (Y GE ymin AND Y LE ymax) THEN RETURN, YposArray[i]
  ENDFOR
  RETURN, -1
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the bank number
FUNCTION getBank, Event
  X = Event.X
  Y = Event.Y
  column = getColumnMainPlot(X)
  ;row    = getRowMainPlot(Y)
  IF (Column NE 0) THEN BEGIN ;we click inside a bank
    RETURN, STRCOMPRESS(Column,/remove_all)
  ENDIF ELSE BEGIN ;if we click outside a bank
    RETURN, ''
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getRow, Event, Y
  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  Yfactor = (*global1).Yfactor
  row = Y/4
  IF (row LT 128 AND $
    row GE 0) THEN RETURN, row
  RETURN, -1
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the bank number
FUNCTION getBankTube, Event
  X = Event.X
  Y = Event.Y
  column_tube = getBankTubeMainPlot(X)
  row = getRow(Event, Y)
  IF (column_tube[0] NE 0 AND $
    row NE -1) THEN BEGIN ;we click inside a bank
    RETURN, [STRCOMPRESS(column_tube[0],/REMOVE_ALL),$
      STRCOMPRESS(column_tube[1],/REMOVE_ALL),$
      STRCOMPRESS(row,/REMOVE_ALL)]
  ENDIF ELSE BEGIN ;if we click outside a bank
    RETURN, ['','','']
  ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getBinTypeFromDas, Event, file_name
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    RETURN, 'linear'
  ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
      RETURN, 0
    ENDIF ELSE BEGIN
      oDocList = oDoc->GetElementsByTagName('DetectorInfo')
      obj1 = oDocList->item(0)
      obj2=obj1->GetElementsByTagName('Scattering')
      obj3=obj2->item(0)
      obj4=obj3->GetElementsByTagName('NumTimeChannels')
      obj4a=obj4->item(0)
      obj4b=obj4a->getattributes()
      obj4c=obj4b->getnameditem('scale')
      RETURN, STRCOMPRESS(obj4c->getvalue())
    ENDELSE
  ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getBinOffsetFromDas, Event, file_name
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    RETURN, '0'
  ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
      RETURN, 0
    ENDIF ELSE BEGIN
      oDocList = oDoc->GetElementsByTagName('DetectorInfo')
      obj1 = oDocList->item(0)
      obj2=obj1->GetElementsByTagName('Scattering')
      obj3=obj2->item(0)
      obj4=obj3->GetElementsByTagName('NumTimeChannels')
      obj4a=obj4->item(0)
      obj4b=obj4a->getattributes()
      obj4c=obj4b->getnameditem('startbin')
      RETURN, STRCOMPRESS(obj4c->getvalue())
    ENDELSE
  ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getBinMaxSetFromDas, Event, file_name
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    RETURN, '100000'
  ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
      RETURN, 0
    ENDIF ELSE BEGIN
      oDocList = oDoc->GetElementsByTagName('DetectorInfo')
      obj1 = oDocList->item(0)
      obj2=obj1->GetElementsByTagName('Scattering')
      obj3=obj2->item(0)
      obj4=obj3->GetElementsByTagName('NumTimeChannels')
      obj4a=obj4->item(0)
      obj4b=obj4a->getattributes()
      obj4c=obj4b->getnameditem('endbin')
      RETURN, STRCOMPRESS(obj4c->getvalue())
    ENDELSE
  ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getBinWidthSetFromDas, Event, file_name
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    RETURN, '200'
  ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
      RETURN, 0
    ENDIF ELSE BEGIN
      oDocList = oDoc->GetElementsByTagName('DetectorInfo')
      obj1 = oDocList->item(0)
      obj2=obj1->GetElementsByTagName('Scattering')
      obj3=obj2->item(0)
      obj4=obj3->GetElementsByTagName('NumTimeChannels')
      obj4a=obj4->item(0)
      obj4b=obj4a->getattributes()
      obj4c=obj4b->getnameditem('width')
      RETURN, STRCOMPRESS(obj4c->getvalue())
    ENDELSE
  ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getBankIndex, Event, X, Y
  ColumnIndex = getColumnMainPlotIndex(X)
  IF (ColumnIndex EQ -1) THEN RETURN, -1
  index = ColumnIndex
  RETURN, index
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the tube number from the bank view
FUNCTION getBankPlotX, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global2
  Xfactor = (*global2).Xfactor
  X = Event.X
  RETURN, STRCOMPRESS(X/Xfactor,/remove_all)
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the Y from the bank view
FUNCTION getBankPlotY, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global2
  Yfactor = (*global2).Yfactor
  Y = Event.Y
  RETURN, STRCOMPRESS(Y/Yfactor,/remove_all)
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;return the pixelID from the widget_text found in the bank base
FUNCTION getPixelIdFromBankBase, Event
  value = getTextFieldValue(Event,'pixelid_input')
  RETURN, value
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get type desired 'lin' or 'log'
FUNCTION getTypeDesired, Event
  id = WIDGET_INFO(Event.top,find_by_uname='plot_scale_type')
  WIDGET_CONTROL, id, get_value=value
  IF (value EQ 'Linear Y-axis      ') THEN RETURN, 'lin'
  RETURN, 'log'
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get pixelID using bank name (M12), tube (X) and row (Y) position
FUNCTION getPixelID, BankID, X, Y
  pxOffset = LONG(Y) + 128L*LONG(X)
  RETURN, pxOffset
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;get range of pixel selected
FUNCTION getPixelIdRangeFromBankBase, BankID, xleft, yleft, xright, yright
  Xfix = FIX([xleft,xright])
  xmin = MIN(Xfix,MAX=xmax)
  Yfix = FIX([yleft,yright])
  ymin = MIN(Yfix,MAX=ymax)
  nbr = (xmax-xmin+1)*(ymax-ymin+1)
  pixelIDRange = LONARR(nbr)
  k=0
  FOR i=xmin,xmax DO BEGIN
    FOR j=ymin,ymax DO BEGIN
      pixelIDRange[k]=getPixelID(BankID,i,j)
      ++k
    ENDFOR
  ENDFOR
  RETURN, pixelIDRange
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  RETURN, WIDGET_INFO(id, /DROPLIST_SELECT)
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getDroplistValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=list
  RETURN, list
END

;+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+
;get proposal selected
FUNCTION getSelectedProposal, Event
  proposalIndex = getDroplistSelectedIndex(Event,'proposal_droplist')
  IF (proposalIndex EQ 0) THEN RETURN, ''
  proposalList = getDroplistValue(Event,'proposal_droplist')
  RETURN, proposalList[proposalIndex]
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getCW_BgroupValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getCWFieldValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+
FUNCTION getBrowseOrListAllValue, Event
  value = getCWFieldValue(Event,'archived_or_list_all')
  RETURN, value
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getTabSelected, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='histo_nexus_tab')
  tab_current = WIDGET_INFO(id, /TAB_CURRENT)
  RETURN, tab_current
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION isArchivedBaseActivated, Event
  id         = WIDGET_INFO(Event.top,find_by_uname='archived_base')
  map_status = WIDGET_INFO(id,/map)
  RETURN, map_status
END

;-------------------------------------------------------------------------------
FUNCTION isListAllBaseActivated, Event
  id         = WIDGET_INFO(Event.top,find_by_uname='list_all_base')
  map_status = WIDGET_INFO(id,/map)
  RETURN, map_status
END

;+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+
FUNCTION getArchivedOrListAllBaseActivated, Event
  IF (isArchivedBaseActivated(Event)) THEN RETURN, 'archived'
  IF (isListAllBaseActivated(Event))  THEN RETURN, 'list_all'
  RETURN, ''
END

;+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+
FUNCTION getSelectedNexus, Event, uname
  DroplistValue = getDroplistValue(Event, uname)
  DroplistIndex = getDroplistSelectedIndex(Event, uname)
  RETURN, DroplistValue[DroplistIndex]
END

;+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+^+
FUNCTION getNexusFileName, Event
  BaseActivated = getArchivedOrListAllBaseActivated(Event)
  CASE (BaseActivated) OF
    'archived': BEGIN
      FullNexusName = getTextFieldValue(Event,'archived_text_field')
    END
    'list_all': BEGIN
      FullNexusName = getSelectedNexus(Event,'list_all_droplist')
    END
  ENDCASE
  RETURN, FullNexusName
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FUNCTION getNbrBinsPerFrame, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='nbr_bins_per_frame_tof')
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getTimePerFrame, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='time_per_frame_tof')
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getFromBin, Event
  RETURN, getCW_BgroupValue(Event, 'from_bin')
END

;------------------------------------------------------------------------------
FUNCTION getToBin, Event
  RETURN, getCW_BgroupValue(Event, 'to_bin')
END

;------------------------------------------------------------------------------
PRO add_element_to_array, array, element

  IF (N_ELEMENTS(array) EQ 0) THEN BEGIN
  array = [element]
  RETURN
  ENDIF
  
  IF (array[0] NE '') THEN BEGIN
    array = [array, element]
  ENDIF ELSE BEGIN
    array[0] = element
  ENDELSE
  
END

;------------------------------------------------------------------------------
FUNCTIOn getArray, text_field

  s_text_field = STRCOMPRESS(text_field,/REMOVE_ALL)
  IF (s_text_field EQ '') THEN RETURN, ['']
  
  split_comma = STRSPLIT(s_text_field,',',/EXTRACT,/REGEX, COUNT=nbr_1)
  
  index = 0
  WHILE (index LT nbr_1) DO BEGIN
  
    split_dash = STRSPLIT(split_comma[index],'-',/EXTRACT,/REGEX, COUNT=nbr_2)
    IF (nbr_2 EQ 1) THEN BEGIN ;no dash found in this number
      add_element_to_array, big_array, split_dash[0]
    ENDIF ELSE BEGIN ;found 1 dash
      from = FIX(split_dash[0])
      to   = FIX(split_dash[1])
      FOR i=from,to DO BEGIN
      add_element_to_array, big_array, i
      ENDFOR
    ENDELSE
    
    index++
  ENDWHILE
  
  RETURN, FIX(big_array[SORT(big_array)])
END