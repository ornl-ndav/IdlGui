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
    
; Change code (RC Ward, October 5-6, 2010): Fix data that does not start at zero to start at zero    
; note that data is in pData as follows: (*pData[i])[0,*] is x axis array for dataset i
;                                        (*pData[j])[1,*] is 2D y data for pixel j for all xaxis values
;                                        (*pData[j])[2,*] is 2D y_error data for pixel j for all xaxis values 
; We want to extend these arrays such that they start at zero and extend up to but below the intial value of x
; using the delta that we get from the difference between the original first two values.
; So first compute delta
    pData_x = FLTARR((SIZE(*pData[0]))(2))
    pData_x[*] = (*pData[i])[0,*]
;    print, pData_x[1], pData_x[0]
    delta = pData_x[1] - pData_x[0]
;    print, "read_ascii_data:  delta: ", delta
     j = 0
; Now add values to new_pData_x up to the original value pData_x[0]
    new = FLTARR((SIZE(*pData[0]))(2))
    WHILE (delta*j LT pData_x[0]) DO BEGIN
      new[j] = delta*j
;      print, new[j]
      j++
    ENDWHILE
    NUMBER = j-1
;    print, "read_ascii: number of new elements for x: ", NUMBER
    new_pData_x       = STRARR((SIZE(*pData[0]))(2) + NUMBER+1)
; load new_pData_x
   FOR j=0, NUMBER DO BEGIN
     new_pData_x[j] = new[j]
;     print, "read_ascii: j, new_pData_x[j]: ", j, "  ",new_pData_x[j]
   ENDFOR
; now load the rest of the x values from original array
   FOR j=0, (SIZE(*pData[0]))(2)-1 DO BEGIN
    k = j+1+NUMBER
    new_pData_x[k]    = (*pData[i])[0,j] ;retrieve x-array
;    print, "read_ascii: k, new_pData_x[k]: ", k, "  ",new_pData_x[k]
   ENDFOR
; define new data arrays
    new_pData_y       = FLTARR(N_ELEMENTS(pData), (SIZE(*pData[0]))(2)+NUMBER+1)
    new_pData_y_error = FLTARR(N_ELEMENTS(pData), (SIZE(*pData[0]))(2)+NUMBER+1)

; now move the y and error data over by the same amount, inserting zeros
  FOR l=0,(N_ELEMENTS(pData)-1) DO BEGIN ;retrieve y_array and error_y_array
     FOR j=0, NUMBER DO BEGIN        
       new_pData_y[l,j] = 0.
       new_pData_y_error[l,j] = 0.
;   IF (l EQ 12) THEN BEGIN
;          print, "read_ascii: j, new_pData_y_error: l=12,j=",j, "  ",new_pData_y_error[l,j]
;   ENDIF
     ENDFOR
     FOR j=0, (SIZE(*pData[0]))(2)-1 DO BEGIN
       k = j+1+NUMBER
       new_pData_y[l,k]    =  (*pData[l])[1,j]  ;retrieve y-array
       new_pData_y_error[l,k]    =  (*pData[l])[2,j]  ;retrieve y-array
;    IF (l EQ 12) THEn BEGIN
;         print, "read_ascii: k, new_pData_y_error: l=12,k=",k, "  ",new_pData_y_error[l,k]
;    ENDIF
     ENDFOR
  ENDFOR 

    *final_new_pData[i]         = new_pData_y
    *final_new_pData_y_error[i] = new_pData_y_error
    *final_new_pData_x[i]       = new_pData_x
    ++i
  ENDWHILE
  (*(*global).pData_y)         = final_new_pData
  (*(*global).pData_y_error)   = final_new_pData_y_error
  (*(*global).pData_x)         = final_new_pData_x
  (*global).plot_realign_data = 0
  
END

