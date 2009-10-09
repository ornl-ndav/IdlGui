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

;This function will take an array as input and will remove all the
;rows that have a y column duplicate value
; ex:
; input_table = [['4753','field1_1','field2_1'],$
;                ['4754','field2_1','field2_2'],$
;                ['4755','field3_1','fiedl3_2'],$
;                ['4754','field4_1','field4-2']]
;
; output_table = [['4753','field1_1','field2_1'],$
;                ['4754','field2_1','field2_2'],$
;                ['4755','field3_1','fiedl3_2']]
;
; Input parameters of the function are:
;             table : the initial table
;             col   : column you want to check for duplicates
;
; Output parameters of the function is:
;             new table without duplicate values in column 'col'
;
FUNCTION uniq_element_table, INPUT_TABLE = input_table,$
                             COL         = col

working_table = INPUT_TABLE

;get nbr_row of input table
nbr_row = (size(WORKING_TABLE))(2)
nbr_col = (size(WORKING_TABLE))(1)

;Clear 'col' element if duplicate of this element was found
left_index = 0
WHILE (left_index LE nbr_row-2) DO BEGIN
    left = WORKING_TABLE[0,left_index]
    right_index = left_index + 1
    WHILE (right_index LE nbr_row-1) DO BEGIN
        right = WORKING_TABLE[0,right_index]
        IF (left EQ right) THEN BEGIN
            WORKING_TABLE[0,right_index] = ''
        ENDIF
        right_index++
    ENDWHILE
left_index++
ENDWHILE

;Remove form the table the rows where the 'col' element is an empty string
array_ele_to_keep = WHERE(WORKING_TABLE[0,*] NE '', count)
NEW_FINAL = STRARR(nbr_col, count)

index = 0
WHILE (index LT count) DO BEGIN
    NEW_FINAL[*,index] = WORKING_TABLE[*,array_ele_to_keep[index]]
    index++
ENDWHILE
RETURN, NEW_FINAL
END

