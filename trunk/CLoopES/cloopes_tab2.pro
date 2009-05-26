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

PRO define_output_folder_tab2, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  
  path = (*global).ascii_path
  title = 'Select the output folder'
  
  folder = DIALOG_PICKFILE(/DIRECTORY,$
    DIALOG_PARENT=id,$
    /MUST_EXIST,$
    TITLE = title,$
    PATH = path)
    
  IF (folder NE '') THEN BEGIN
    (*global).ascii_path = folder
    putButtonValue, Event, 'tab2_output_folder_button_uname', folder
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO populate_tab2, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    refresh_button_status = 0
  ENDIF ELSE BEGIN
    ;get table
    tab2_table = (*(*global).tab2_table)
    putValue, Event, 'tab2_table_uname', tab2_table
    refresh_button_status = 1
  ENDELSE
  activate_widget, Event, 'tab2_refresh_table_uname', refresh_button_status
  
END

;------------------------------------------------------------------------------
PRO update_temperature, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  ; CATCH, error ;remove_me (important if user try to edit STATUS column
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
  
    ;get table value
    table = getTableValue(Event,'tab2_table_uname')
    ;    PRINT, SIZE(table)
    nbr_row = (SIZE(table))(2)
    
    ;get row and column edited
    rc_array = getCellSelectedTab1(Event, 'tab2_table_uname')
    column = rc_array[0]
    row = rc_array[1]
    
    ;continue work only if column 2 is selected
    IF (column EQ 2) THEN BEGIN
    
      CASE (row) OF
        0: TABLE[2,0] = STRCOMPRESS(FLOAT(table[2,0]))
        ELSE: BEGIN
        table[2,row] = STRCOMPRESS(FLOAT(table[2,row]))
          IF (row LT (nbr_row - 1)) THEN BEGIN
            increment = FLOAT(table[2,row]) - FLOAT(table[2,row-1])
            index = (row+1)
            WHILE (index LT nbr_row) DO BEGIN
              table[2,index] = STRCOMPRESS(table[2,index-1] + increment)
              index++
            ENDWHILE
          ENDIF
        END
      ENDCASE
      
      putValue, Event, 'tab2_table_uname', table
      
    ENDIF
    
  ENDELSE
  
END