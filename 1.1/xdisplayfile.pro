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

PRO SaveNewFilename, Event, new_filename
;get global from this GUI
WIDGET_CONTROL, Event.top, GET_UVALUE=state
old_event = state.event_str
;get global from group_leader GUI and change value of geometry text field
WIDGET_CONTROL, old_event.top, GET_UVALUE=global
id = widget_info(old_event.top,find_by_uname='geometry_text_field')
widget_control, id, set_value = new_filename
END

;===============================================================================
; $Id: //depot/idl/IDL_63_RELEASE/idldir/lib/utilities/xdisplayfile.pro#1 $
;
; Copyright (c) 1991-2006, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;===============================================================================
PRO XDISPLAYFILE_write, wText, filename
  COMPILE_OPT hidden
  WIDGET_CONTROL, /HOURGLASS
  OPENW, unit, FILENAME, /GET_LUN, ERROR=i		;open the file and then
  IF (i lt 0) THEN BEGIN		;OK?
	a = [ !error_state.msg, filename + ' could not be opened for writing.']
	void = DIALOG_MESSAGE(a, /ERROR, DIALOG_PARENT=wText)
  ENDIF ELSE BEGIN
	WIDGET_CONTROL, wText, GET_VALUE=txtArray
	ON_IOERROR, done_writing
	; print out each line separately in order to get desired line breaks
	FOR j=0, N_ELEMENTS(txtArray)-1 DO PRINTF, unit, txtArray[j]
done_writing:
	ON_IOERROR, null
	FREE_LUN, unit				;free the file unit.
  ENDELSE
END

;===============================================================================
PRO XDISPLAYFILE_event, event
COMPILE_OPT hidden
WIDGET_CONTROL, event.top, GET_UVALUE=state

CASE TAG_NAMES(event, /STRUCTURE_NAME) OF
    'WIDGET_BASE': BEGIN
        w = (event.x gt state.x_reserve) $
          ? (event.x - state.x_reserve) : state.x_reserve
        IF (!version.os_family EQ 'Windows') THEN BEGIN
            h=event.y
        ENDIF ELSE BEGIN
            h = (event.y GT state.y_reserve) $
              ? (event.y - state.y_reserve) : state.y_reserve
        ENDELSE
        WIDGET_CONTROL, state.filetext, SCR_XSIZE=w, SCR_YSIZE=h
        RETURN
    END
    'WIDGET_KILL_REQUEST': retval = "EXIT"
    ELSE: WIDGET_CONTROL, event.id, GET_UVALUE = retval
ENDCASE

CASE retval OF
    "SAVE": BEGIN
        if (LMGR(/DEMO)) then begin
            tmp = DIALOG_MESSAGE( /ERROR, $
                                  'Save: Feature disabled for demo mode.')
            return
        endif
        IF (STRLEN(state.filename) EQ 0) THEN BEGIN
            state.filename = DIALOG_PICKFILE(/WRITE)
        ENDIF
        IF (STRLEN(state.filename) GT 0) THEN BEGIN
            XDISPLAYFILE_write, state.filetext, state.filename
            WIDGET_CONTROL, event.top, SET_UVALUE=state
            IF state.notitle THEN WIDGET_CONTROL, event.top, $
              TLB_SET_TITLE=state.filename
        ENDIF
        
        RETURN
    END
    "SAVE_AS": BEGIN
        if (LMGR(/DEMO)) then begin
            tmp = DIALOG_MESSAGE( /ERROR, $
                                  'Save As: Feature disabled for demo mode.')
            return
        endif
        state.filename = DIALOG_PICKFILE(/WRITE)
                                ;get global structure
        id=widget_info(state.event_str.top, FIND_BY_UNAME='MAIN_BASE')
        widget_control,id,get_uvalue=global
        (*global).new_geo_xml_filename  = state.filename
        IF (STRLEN(state.filename) GT 0) THEN BEGIN
            XDISPLAYFILE_write, state.filetext, state.filename
            WIDGET_CONTROL, event.top, SET_UVALUE=state
            geom_xml_file_title = (*global).geom_xml_file_title
            
                                ;get only the last part of the full file name
            filename_array = strsplit(state.filename,'/',count=nbr,/extract)
            short_filename = filename_array[nbr-1]
            
            title = 'Done with ' + short_filename
            WIDGET_CONTROL, event.top, $
              TLB_SET_TITLE=title
            
                                ;done with <filename> button
                                ;change contain
            id = WIDGET_INFO(event.top,find_by_uname='EXIT')
            title2 = 'Done with ' + state.filename
            widget_control, id, set_value=title2
            
            SaveNewFilename, Event, state.filename
            
        ENDIF
        RETURN
    END
    "EXIT": BEGIN
        WIDGET_CONTROL, event.top, /DESTROY
        IF (WIDGET_INFO(state.ourGroup, /VALID)) THEN $
          WIDGET_CONTROL, state.ourGroup, /DESTROY
    END
    
    "find_text": BEGIN
;reinitialize find_iteration counter
        id=widget_info(state.event_str.top, FIND_BY_UNAME='MAIN_BASE')
        widget_control,id,get_uvalue=global
        (*global).stringFoundIteration = 1
;retrieve full text
        id = widget_info(event.top,find_by_uname='text')
        widget_control, id, get_value=text
        sz   = (size(text))(1)
;get text to find
        id = widget_info(event.top,FIND_BY_UNAME='find_text_uname')
        widget_control, id, GET_VALUE = stringToFind
        sz_stringToFind = strlen(stringToFind)
        IF (stringToFind NE '') THEN BEGIN
;is it case sensitive or not
            id = widget_info(event.top,find_by_uname='case_sensitive')
            widget_control, id, get_value=isCaseSensitive
            IF (isCaseSensitive) THEN BEGIN ;case sensitive search
                position = strpos(text,stringToFind)
            ENDIF ELSE BEGIN
                position = strpos(STRUPCASE(text),$
                                  STRUPCASE(StringToFind))
            ENDELSE
            a=where(position NE -1,NbrStrFound)
;inform user of the number of time the string has been located
            message = 'String <' + stringToFind + '> '
            CASE NbrStrFound OF
                0: BEGIN
                    message += 'can not be found'
                    id = widget_info(Event.top,find_by_uname='iteration_label')
                    widget_control, id, set_value = ''
                    id = widget_info(event.top,find_by_uname='find_cancel')
                    widget_control, id, sensitive = 0
                    id = widget_info(Event.top,find_by_uname='find_next')
                    widget_control, id, sensitive = 0
                    id = widget_info(Event.top,find_by_uname='find_previous')
                    widget_control, id, sensitive = 0
                    id = widget_info(event.top,FIND_BY_UNAME='text')
                    widget_control, id, $
                      SET_TEXT_SELECT=[0]
                END
                1: BEGIN
                    message += 'has been located 1 time'
                    id = widget_info(Event.top,find_by_uname='find_next')
                    widget_control, id, sensitive = 0
                    id = widget_info(Event.top,find_by_uname='iteration_label')
                    widget_control, id, set_value = '1/'+ $
                      strcompress(NbrStrFound,/remove_all)
                END
                ELSE: BEGIN
                    message += 'has been located ' + $
                      strcompress(NbrStrFound,/remove_all) + $
                      ' times'
                    id = widget_info(Event.top,find_by_uname='find_next')
                    widget_control, id, sensitive = 1
                    id = widget_info(Event.top,find_by_uname='iteration_label')
                    widget_control, id, set_value = '1/'+ $
                      strcompress(NbrStrFound,/remove_all)
                END
            ENDCASE
            id = widget_info(Event.top,find_by_uname='find_status')
            widget_control, id, set_value = 'Status: ' + message[0]
            
;id of widget_text
            id = widget_info(event.top,FIND_BY_UNAME='text')
            position_offset = 0
            
            FOR i=0,(sz-1) DO BEGIN
                IF (position[i] NE -1) THEN BEGIN ;we found it in this line
                    widget_control, id, $
                      SET_TEXT_SELECT=[position_offset+position[i], $
                                       sz_stringToFind]
                    break
                ENDIF ELSE BEGIN
                    position_offset += strlen(text[i]) + 1
                    widget_control, id, SET_TEXT_SELECT=[1]
                ENDELSE
            ENDFOR
            id = widget_info(event.top,find_by_uname='find_cancel')
            widget_control, id, sensitive = 1
        ENDIF ELSE BEGIN        ;if (stringToFind NE '')
            id = widget_info(event.top,find_by_uname='find_cancel')
            widget_control, id, sensitive = 0
            id = widget_info(Event.top,find_by_uname='find_next')
            widget_control, id, sensitive = 0
            id = widget_info(Event.top,find_by_uname='find_previous')
            widget_control, id, sensitive = 0
            id = widget_info(Event.top,find_by_uname='find_status')
            widget_control, id, SET_VALUE = 'Status: '
            id = widget_info(event.top,FIND_BY_UNAME='find_text_uname')
            widget_control, id, SET_VALUE = ''
            id = widget_info(event.top,FIND_BY_UNAME='text')
            widget_control, id, $
              SET_TEXT_SELECT=[0]
            id = widget_info(Event.top,find_by_uname='iteration_label')
            widget_control, id, set_value = ''
        ENDELSE
    END
    
    "find_previous": BEGIN
        id=widget_info(state.event_str.top, FIND_BY_UNAME='MAIN_BASE')
        widget_control,id,get_uvalue=global
        (*global).stringFoundIteration = (*global).stringFoundIteration - 1
        find_iteration = (*global).stringFoundIteration
;retrieve full text
        id = widget_info(event.top,find_by_uname='text')
        widget_control, id, get_value=text
        sz   = (size(text))(1)
;get text to find
        id = widget_info(event.top,FIND_BY_UNAME='find_text_uname')
        widget_control, id, GET_VALUE = stringToFind
        sz_stringToFind = strlen(stringToFind)
;is it case sensitive or not
        id = widget_info(event.top,find_by_uname='case_sensitive')
        widget_control, id, get_value=isCaseSensitive
        IF (isCaseSensitive) THEN BEGIN ;case sensitive search
            position = strpos(text,stringToFind)
        ENDIF ELSE BEGIN
            position = strpos(STRUPCASE(text),$
                              STRUPCASE(StringToFind))
        ENDELSE
        a=where(position NE -1,NbrStrFound)
;inform user which iteration of string found is selected
        id = widget_info(Event.top,find_by_uname='iteration_label')
        value = strcompress(find_iteration,/remove_all)
        value += '/' + strcompress(NbrStrFound,/remove_all)
        widget_control, id, set_value = value
;id of widget_text
        id = widget_info(event.top,FIND_BY_UNAME='text')
        position_offset = 0
        string_found = 0
        FOR i=0,(sz-1) DO BEGIN
            IF (position[i] NE -1) THEN BEGIN ;we found it in this line
                ++string_found 
                IF (string_found EQ find_iteration) THEN BEGIN
                    widget_control, id, $
                      SET_TEXT_SELECT=[position_offset+position[i], $
                                       sz_stringToFind]
                    BREAK
                ENDIF
                position_offset += strlen(text[i]) + 1
            ENDIF ELSE BEGIN
                position_offset += strlen(text[i]) + 1
                widget_control, id, SET_TEXT_SELECT=[1]
            ENDELSE
        ENDFOR
;desactivate find_previous if find_itearation = 1
        IF (find_iteration EQ 1) THEN BEGIN
            id = widget_info(Event.top,find_by_uname='find_previous')
            widget_control, id, sensitive = 0
        ENDIF
;activate find_next if find_iteration is less than NbrSTrFound-1
        IF (find_iteration LT NbrStrFound) THEN BEGIN
            id = widget_info(Event.top,find_by_uname='find_next')
            widget_control, id, sensitive = 1
        ENDIF
    END
    
    "find_next": BEGIN
        id=widget_info(state.event_str.top, FIND_BY_UNAME='MAIN_BASE')
        widget_control,id,get_uvalue=global
        (*global).stringFoundIteration = (*global).stringFoundIteration + 1
        find_iteration = (*global).stringFoundIteration
;retrieve full text
        id = widget_info(event.top,find_by_uname='text')
        widget_control, id, get_value=text
        sz   = (size(text))(1)
;get text to find
        id = widget_info(event.top,FIND_BY_UNAME='find_text_uname')
        widget_control, id, GET_VALUE = stringToFind
        sz_stringToFind = strlen(stringToFind)
;is it case sensitive or not
        id = widget_info(event.top,find_by_uname='case_sensitive')
        widget_control, id, get_value=isCaseSensitive
        IF (isCaseSensitive) THEN BEGIN ;case sensitive search
            position = strpos(text,stringToFind)
        ENDIF ELSE BEGIN
            position = strpos(STRUPCASE(text),$
                              STRUPCASE(StringToFind))
        ENDELSE
        a=where(position NE -1,NbrStrFound)
;inform user which iteration of string found is selected
        id = widget_info(Event.top,find_by_uname='iteration_label')
        value = strcompress(find_iteration,/remove_all)
        value += '/' + strcompress(NbrStrFound,/remove_all)
        widget_control, id, set_value = value
;id of widget_text
        id = widget_info(event.top,FIND_BY_UNAME='text')
        position_offset = 0
        string_found = 0
        FOR i=0,(sz-1) DO BEGIN
            IF (position[i] NE -1) THEN BEGIN ;we found it in this line
                ++string_found 
                IF (string_found EQ find_iteration) THEN BEGIN
                    widget_control, id, $
                      SET_TEXT_SELECT=[position_offset+position[i], $
                                       sz_stringToFind]
                    BREAK
                ENDIF
                position_offset += strlen(text[i]) + 1
            ENDIF ELSE BEGIN
                position_offset += strlen(text[i]) + 1
                widget_control, id, SET_TEXT_SELECT=[1]
            ENDELSE
        ENDFOR
;desactivate find_next if find_itearation = NbrStrFound
        IF (find_iteration EQ NbrStrFound) THEN BEGIN
            id = widget_info(Event.top,find_by_uname='find_next')
            widget_control, id, sensitive = 0
        ENDIF
;activate find_previous if find_iteration is at least 2
        IF (find_iteration GT 1) THEN BEGIN
            id = widget_info(Event.top,find_by_uname='find_previous')
            widget_control, id, sensitive = 1
        ENDIF
    END
    "find_cancel": BEGIN
        id = widget_info(Event.top,find_by_uname='find_status')
        widget_control, id, SET_VALUE = 'Status: '
        id = widget_info(event.top,FIND_BY_UNAME='find_text_uname')
        widget_control, id, SET_VALUE = ''
        id = widget_info(event.top,FIND_BY_UNAME='text')
        widget_control, id, $
          SET_TEXT_SELECT=[0]
        id = widget_info(Event.top,find_by_uname='find_next')
        widget_control, id, sensitive = 0
        id = widget_info(Event.top,find_by_uname='find_previous')
        widget_control, id, sensitive = 0
        id = widget_info(event.top,find_by_uname='find_cancel')
        widget_control, id, sensitive = 0
        id = widget_info(Event.top,find_by_uname='iteration_label')
        widget_control, id, set_value = ''
    END
        
    "case_sensitive": BEGIN
;reinitialize find_iteration counter
        id=widget_info(state.event_str.top, FIND_BY_UNAME='MAIN_BASE')
        widget_control,id,get_uvalue=global
        (*global).stringFoundIteration = 1
;retrieve full text
        id = widget_info(event.top,find_by_uname='text')
        widget_control, id, get_value=text
        sz   = (size(text))(1)
;get text to find
        id = widget_info(event.top,FIND_BY_UNAME='find_text_uname')
        widget_control, id, GET_VALUE = stringToFind
        sz_stringToFind = strlen(stringToFind)
        IF (stringToFind NE '') THEN BEGIN
;is it case sensitive or not
            id = widget_info(event.top,find_by_uname='case_sensitive')
            widget_control, id, get_value=isCaseSensitive
            IF (isCaseSensitive) THEN BEGIN ;case sensitive search
                position = strpos(text,stringToFind)
            ENDIF ELSE BEGIN
                position = strpos(STRUPCASE(text),$
                                  STRUPCASE(StringToFind))
            ENDELSE
            a=where(position NE -1,NbrStrFound)
;inform user of the number of time the string has been located
            message = 'String <' + stringToFind + '> '
            CASE NbrStrFound OF
                0: BEGIN
                    message += 'can not be found'
                    id = widget_info(Event.top,find_by_uname='iteration_label')
                    widget_control, id, set_value = ''
                    id = widget_info(event.top,find_by_uname='find_cancel')
                    widget_control, id, sensitive = 0
                    id = widget_info(Event.top,find_by_uname='find_next')
                    widget_control, id, sensitive = 0
                    id = widget_info(Event.top,find_by_uname='find_previous')
                    widget_control, id, sensitive = 0
                    id = widget_info(event.top,FIND_BY_UNAME='text')
                    widget_control, id, $
                      SET_TEXT_SELECT=[0]
                END
                1: BEGIN
                    message += 'has been located 1 time'
                    id = widget_info(Event.top,find_by_uname='find_next')
                    widget_control, id, sensitive = 1
                    id = widget_info(Event.top,find_by_uname='iteration_label')
                    widget_control, id, set_value = '1/'+ $
                      strcompress(NbrStrFound,/remove_all)
                END
                ELSE: BEGIN
                    message += 'has been located ' + $
                      strcompress(NbrStrFound,/remove_all) + $
                      ' times'
                    id = widget_info(Event.top,find_by_uname='find_next')
                    widget_control, id, sensitive = 1
                    id = widget_info(Event.top,find_by_uname='iteration_label')
                    widget_control, id, set_value = '1/'+ $
                      strcompress(NbrStrFound,/remove_all)
                END
            ENDCASE
            id = widget_info(Event.top,find_by_uname='find_status')
            widget_control, id, set_value = 'Status: ' + message[0]
            
;id of widget_text
            id = widget_info(event.top,FIND_BY_UNAME='text')
            position_offset = 0
            
            FOR i=0,(sz-1) DO BEGIN
                IF (position[i] NE -1) THEN BEGIN ;we found it in this line
                    widget_control, id, $
                      SET_TEXT_SELECT=[position_offset+position[i], $
                                       sz_stringToFind]
                    break
                ENDIF ELSE BEGIN
                    position_offset += strlen(text[i]) + 1
                    widget_control, id, SET_TEXT_SELECT=[1]
                ENDELSE
            ENDFOR
            id = widget_info(event.top,find_by_uname='find_cancel')
            widget_control, id, sensitive = 1
        ENDIF ELSE BEGIN        ;if (stringToFind NE '')
            id = widget_info(event.top,find_by_uname='find_cancel')
            widget_control, id, sensitive = 0
            id = widget_info(Event.top,find_by_uname='find_next')
            widget_control, id, sensitive = 0
            id = widget_info(Event.top,find_by_uname='find_previous')
            widget_control, id, sensitive = 0
            id = widget_info(Event.top,find_by_uname='find_status')
            widget_control, id, SET_VALUE = 'Status: '
            id = widget_info(event.top,FIND_BY_UNAME='find_text_uname')
            widget_control, id, SET_VALUE = ''
            id = widget_info(event.top,FIND_BY_UNAME='text')
            widget_control, id, $
              SET_TEXT_SELECT=[0]
            id = widget_info(Event.top,find_by_uname='iteration_label')
            widget_control, id, set_value = ''
        ENDELSE
    END
    ELSE:
ENDCASE
END

;===============================================================================
PRO XDisplayFileGrowToScreen, tlb, text, height, nlines
; Grow the text widget so that it displays all of the text or
; it is as large as the screen can hold.

max_y = (get_screen_size())[1] - 100
cur_y = (WIDGET_INFO(tlb, /geometry)).scr_ysize

; If the display is already long enough, then there's nothing to do.
;
; We are only filling to grow the display, not shrink it, so if its
; already too big, there's nothing to do. This can only happen if
; the caller sets a large HEIGHT keyword, which is operator error.
IF ((nlines LE height) || (cur_y GT max_y)) THEN RETURN
; The strategy I use is binary divide and conquer. Furthermore,
; if nlines is more than 150, I limit the search to that much.
; (Consider that a typical screen is 1024 pixels high, and that
; using 10pt type, this yields 102 lines). This number may need to
; be adjusted as screen resolution grows but that will almost certainly
; be a slowly moving and easy to track target.
;
; Note: The variable cnt should never hit its limit. It is there
; as a "deadman switch".
low = height
high = MIN([150, nlines+1])
cnt=0
WHILE ((low LT high) && (cnt++ LT 100)) DO BEGIN
    old_low = low
    old_high = high
    mid = low + ((high - low + 1) / 2)
    WIDGET_CONTROL, text, YSIZE=mid
    cur_y = (WIDGET_INFO(tlb, /GEOMETRY)).scr_ysize
    IF (cur_y LT max_y) THEN low = mid ELSE high = mid
    IF ((old_low EQ low) && (old_high EQ high)) THEN BREAK
ENDWHILE
END

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
PRO XDisplayFile, event, $
                  FILENAME, $
                  TITLE          = TITLE, $
                  GROUP          = GROUP, $
                  WIDTH          = WIDTH, $
                  HEIGHT         = HEIGHT, $
                  TEXT           = TEXT, $
                  FONT           = font, $
                  DONE_BUTTON    = done_button, $
                  MODAL          = MODAL, $
                  EDITABLE       = editable, $
                  GROW_TO_SCREEN = grow_to_screen, $
                  WTEXT          = filetext, $
                  BLOCK          = block, $
                  RETURN_ID      = return_id
  
;+
; NAME:
;	XDISPLAYFILE
;
; PURPOSE:
;	Display an ASCII text file using widgets and the widget manager.
;
; CATEGORY:
;	Widgets.
;
; CALLING SEQUENCE:
;	XDISPLAYFILE, Filename
;
; INPUTS:
;     Event   : the top Event of the calling widget
;
;     Filename:	A scalar string that contains the filename of the file
;		to display.  The filename can include a path to that file.
;
; KEYWORD PARAMETERS:
;	BLOCK:  Set this keyword to have XMANAGER block when this
;		application is registered.  By default the Xmanager
;               keyword NO_BLOCK is set to 1 to provide access to the
;               command line if active command 	line processing is available.
;               Note that setting BLOCK for this application will cause
;		all widget applications to block, not only this
;		application.  For more information see the NO_BLOCK keyword
;		to XMANAGER.
;
;	DONE_BUTTON: the text to use for the Done button.  If omitted,
;		the text "Done with <filename>" is used.
;
;	EDITABLE: Set this keyword to allow modifications to the text
;		displayed in XDISPLAYFILE.  Setting this keyword also
;		adds a "Save" button in addition to the Done button, and
;               a set of widgets to find a string.
;
;	FONT:   The name of the font to use.  If omitted use the default
;		font.
;	GROUP:	The widget ID of the group leader of the widget.  If this
;		keyword is specified, the death of the group leader results in
;		the death of XDISPLAYFILE.
;
;       GROW_TO_SCREEN: If TRUE, the length of the display area is grown
;		to show as much of the text as possible without being too
;		large to fit on the screen. In this case, HEIGHT sets the
;		lower bound on the size instead of setting the size itself.
;
;	HEIGHT:	The number of text lines that the widget should display at one
;		time.  If this keyword is not specified, 24 lines is the
;		default.
;
;       RETURN_ID : A variable to be set to the widget ID of the top level
;               base of the resulting help application.
;	TEXT:	A string or string array to be displayed in the widget
;		instead of the contents of a file.  This keyword supercedes
;		the FILENAME input parameter.
;
;	TITLE:	A string to use as the widget title rather than the file name
;		or "XDisplayFile".
;
;	WIDTH:	The number of characters wide the widget should be.  If this
;		keyword is not specified, 80 characters is the default.
;
;	WTEXT:	Output parameter, the id of the text widget.  This allows
;		setting text selections and cursor positions programmatically.
;
; OUTPUTS:
;	No explicit outputs.  A file viewing widget is created.
;
; SIDE EFFECTS:
;	Triggers the XMANAGER if it is not already in use.
;
; RESTRICTIONS:
;	None.
;
; PROCEDURE:
;	Open a file and create a widget to display its contents.
;
; MODIFICATION HISTORY:
;	Written By Steve Richards, December 1990
;	Graceful error recovery, DMS, Feb, 1992.
;       12 Jan. 1994  - KDB
;               If file was empty, program would crash. Fixed.
;       4 Oct. 1994     MLR Fixed bug if /TEXT was present and /TITLE was not.
;	2 jan 1997	DMS Added DONE_BUTTON keyword, made Done
;			button align on left, removed padding.
;	19 Nov 2004, GROW_TO_SCREEN and RETURN_ID keywords. Allow for
;                       user to resize display. General updating.
;       January 2008, Add possibility to find a string (Jean Bilheux - ORNL-SNS)
;-

; Establish defaults if keywords not specified
IF(NOT(KEYWORD_SET(EDITABLE))) THEN editable = 0
IF(NOT(KEYWORD_SET(HEIGHT)))   THEN HEIGHT = 24
IF(NOT(KEYWORD_SET(WIDTH)))    THEN WIDTH = 80
IF N_ELEMENTS(block) EQ 0      THEN block=0
noTitle = N_ELEMENTS(title) EQ 0

IF(NOT(KEYWORD_SET(TEXT))) THEN BEGIN
    IF noTitle THEN TITLE = FILENAME
    
    unit = -1
    CATCH, err
    IF (err ne 0) THEN BEGIN
        CATCH,/CANCEL
        IF (unit NE -1) THEN FREE_LUN, 1
        a = [ !error_state.msg, ' Unable to display ' + filename]
        nlines = n_elements(a)
    ENDIF ELSE BEGIN
        nlines = MIN([FILE_LINES(filename), 10000])
        OPENR, unit, FILENAME, /GET_LUN
        a = STRARR(nlines)
        readf, unit, a
        CATCH, /CANCEL
        FREE_LUN, unit
    ENDELSE
ENDIF ELSE BEGIN
    IF(N_ELEMENTS(FILENAME) EQ 0) THEN FILENAME=''
    IF noTitle THEN TITLE = 'XDisplayFile'
    a = TEXT
    nlines = N_ELEMENTS(a)
ENDELSE

ourGroup = 0L
IF KEYWORD_SET(MODAL) THEN BEGIN
    IF (N_ELEMENTS(GROUP)) GT 0 THEN BEGIN
        filebase = WIDGET_BASE(TITLE = TITLE, $
                               /TLB_KILL_REQUEST_EVENTS, $
                               TLB_FRAME_ATTR = 1, $
                               /BASE_ALIGN_LEFT, $
                               /COLUMN, $
                               /MODAL, $
                               GROUP_LEADER  = GROUP)
    ENDIF ELSE BEGIN
                                ; modal requires a group leader
        ourGroup = WIDGET_BASE()
        filebase = WIDGET_BASE(TITLE = TITLE, $
                               /TLB_KILL_REQUEST_EVENTS, $
                               TLB_FRAME_ATTR=1, $
                               /BASE_ALIGN_LEFT, $
                               /COLUMN, $
                               /MODAL, $
                               GROUP_LEADER = ourGroup)
    ENDELSE
    menu_bar = filebase
ENDIF ELSE BEGIN
    filebase = WIDGET_BASE(TITLE = TITLE, $
                           /TLB_KILL_REQUEST_EVENTS, $
                           /TLB_SIZE_EVENTS, $
                           /BASE_ALIGN_LEFT, $
                           /COLUMN, $
                           MBAR=menu_bar, $
                           GROUP_LEADER = GROUP)
ENDELSE
return_id = filebase

extra = ''
IF (menu_bar NE filebase) THEN BEGIN
    IF (!VERSION.OS_FAMILY EQ 'Windows') THEN extra = '&'
    menu_bar = WIDGET_BUTTON(menu_bar, VALUE=extra+'File', /MENU)
ENDIF ELSE $
  menu_bar = WIDGET_BASE(filebase, /ROW)

IF (editable) THEN BEGIN
                                ; add 'Save', 'Save as...' buttons here
    saveButton = WIDGET_BUTTON(menu_bar, VALUE = extra+'Save', UVALUE = "SAVE")
    saveAsButton = WIDGET_BUTTON(menu_bar, $
                                 VALUE = 'Save '+extra+'As...', UVALUE = "SAVE_AS")
ENDIF

                                ; Done button
                                ;get only the last part of the full file name

IF N_ELEMENTS(done_button) eq 0 THEN BEGIN
    filename_array = STRSPLIT(filename,'/', $
                              COUNT=nbr, $
                              /EXTRACT)
    short_filename = filename_array[nbr-1]
    done_button    = "Done with " + short_filename
ENDIF

filequit = WIDGET_BUTTON(menu_bar, $
                         SEPARATOR = editable, $
                         XSIZE     = 405,$
                         VALUE     = extra + done_button, $
                         UVALUE    = "EXIT", $
                         UNAME     = 'EXIT')

                                ; Create a text widget to display the text
IF n_elements(font) GT 0 THEN BEGIN
    filetext = WIDGET_TEXT(filebase, $
                           XSIZE    = WIDTH, $
                           YSIZE    = HEIGHT, $
                           EDITABLE = editable, $
                           UVALUE   = 'TEXT', $
                           UNAME    = 'text',$
                           /SCROLL, $
                           VALUE    = a, $
                           FONT      = font)
ENDIF ELSE BEGIN
    filetext = WIDGET_TEXT(filebase, $
                           XSIZE    = WIDTH, $
                           YSIZE    = HEIGHT, $
                           EDITABLE = $
                           editable, $
                           UVALUE   = 'TEXT', $
                           UNAME    = 'text',$
                           /SCROLL, $
                           VALUE    = a)
ENDELSE

;add find widgets  
IF (editable) THEN BEGIN
    find_bar = WIDGET_BASE(filebase, /ROW)
    
                                ;find label
    findLabel = WIDGET_LABEL(find_bar, VALUE = 'Find:')
    findText  = WIDGET_TEXT(find_bar,  $
                            VALUE  = '', $
                            UVALUE = 'find_text',$
                            UNAME  = 'find_text_uname',$
                            XSIZE  = 20,$
                            YSIZE  = 1,$
                            /EDITABLE,$
                            FONT   = font,$
                            /ALL_EVENTS)

    CaseSensitiveBase = WIDGET_BASE(find_bar,$
                                    UNAME     = 'case_sensitive_base',$
                                    SCR_XSIZE = 115,$
                                    SCR_YSIZE = 35)
    
    caseSensitiveGroup = CW_BGROUP(CaseSensitiveBase,$
                                   'Case sensitive',$
                                   UNAME     = 'case_sensitive',$
                                   UVALUE    = 'case_sensitive',$
                                   ROW       = 1,$
                                   SET_VALUE = 1,$
                                   /NONEXCLUSIVE)
    
    findPreviousButton = WIDGET_BUTTON(find_bar,$
                                       VALUE     = '<-- Previous',$
                                       UVALUE    = 'find_previous',$
                                       UNAME     = 'find_previous',$
                                       SCR_XSIZE = 85,$
                                       SCR_YSIZE = 30,$
                                       SENSITIVE = 0)
    
    findNextButton = WIDGET_BUTTON(find_bar,$
                                   VALUE     = 'Next -->',$
                                   UVALUE    = 'find_next',$
                                   UNAME     = 'find_next',$
                                   SCR_XSIZE = 70,$
                                   SCR_YSIZE = 30,$
                                   SENSITIVE = 0)

    findCancel = WIDGET_BUTTON(find_bar,$
                               VALUE     = 'Cancel',$
                               UVALUE    = 'find_cancel',$
                               UNAME     = 'find_cancel',$
                               SENSITIVE = 0,$
                               SCR_XSIZE = 60,$
                               SCR_YSIZE = 30)

    find_status_bar = WIDGET_BASE(filebase, /ROW)

    findStatusText  = WIDGET_LABEL(find_status_bar,  $
                                   VALUE      = 'Status: ', $
                                   UNAME      = 'find_status',$
                                   SCR_XSIZE  = 460,$
                                   SCR_YSIZE  = 30,$
                                   FONT       = font,$
                                   /ALIGN_LEFT,$
                                   FRAME      = 1)

    iterationDisplayed = WIDGET_LABEL(find_status_bar,$
                                      VALUE     = '',$
                                      UNAME     = 'iteration_label',$
                                      SCR_XSIZE = 50,$
                                      SCR_YSIZE = 30,$
                                      FONT      = font,$
                                      FRAME     = 1)
                                        
ENDIF

IF (keyword_set(grow_to_screen)) THEN $
  XDisplayFileGrowToScreen, filebase, filetext, height, nlines

WIDGET_CONTROL, filebase, /REALIZE

geo_base = WIDGET_INFO(filebase, /geometry)
geo_text = WIDGET_INFO(filetext, /geometry)

state={ ourGroup       : ourGroup, $
        find_iteration : 0,$
        full_text      : a,$
        filename       : filename, $
        new_filename   : '',$
        event_str      : event,$
        filetext       : filetext, $
        notitle        : noTitle, $
        x_reserve      : geo_base.scr_xsize - geo_text.scr_xsize, $
        y_reserve      : geo_base.scr_ysize - geo_text.scr_ysize }

WIDGET_CONTROL, filebase, SET_UVALUE = state
xmanager, "XDISPLAYFILE", filebase, GROUP_LEADER = GROUP, $
  NO_BLOCK=(NOT(FLOAT(block)))

END


