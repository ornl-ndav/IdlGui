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
PRO readAsciiData, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ;get list of files
  list_OF_files = (*(*global).list_OF_ascii_files)
  i = 0
  nbr = N_ELEMENTS(list_OF_files)
  final_new_pData         = PTRARR(nbr,/ALLOCATE_HEAP)
  final_new_pData_y_error = PTRARR(nbr,/ALLOCATE_HEAP)
  final_new_pData_x       = PTRARR(nbr,/ALLOCATE_HEAP)
  WHILE (i LT nbr) DO BEGIN
    iClass = OBJ_NEW('IDL3columnsASCIIparser',list_OF_files[i])
    pData = iClass->getDataQuickly()
    OBJ_DESTROY, iClass
    ;keep only the second column
    new_pData_x       = STRARR((SIZE(*pData[0]))(2))
    new_pData_x[*]    = (*pData[i])[0,*] ;retrieve x-array
    new_pData         = STRARR(N_ELEMENTS(pData),(SIZE(*pData[0]))(2))
    new_pData_y_error = FLTARR(N_ELEMENTS(pData),(SIZE(*pData[0]))(2))
    
    FOR j=0,(N_ELEMENTS(pData)-1) DO BEGIN ;retrieve y_array and error_y_array
      new_pData[j,*]         = (*pData[j])[1,*]
      new_pData_y_error[j,*] = (*pData[j])[2,*]
    ENDFOR

    *final_new_pData[i]         = new_pData
    *final_new_pData_y_error[i] = new_pData_y_error
    *final_new_pData_x[i]       = new_pData_x
    ++i
  ENDWHILE
  (*(*global).pData_y)         = final_new_pData
  (*(*global).pData_y_error)   = final_new_pData_y_error
  (*(*global).pData_x)         = final_new_pData_x
  (*global).plot_realign_data = 0
  
END

