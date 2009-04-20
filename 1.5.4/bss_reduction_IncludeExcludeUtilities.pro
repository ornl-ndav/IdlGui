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

FUNCTION StringSplit, delimiter, text
  RETURN, strsplit(text, delimiter,/extract)
END

;------------------------------------------------------------------------------
FUNCTION CreateList, text2
  ON_IOERROR, L1 ;in case one of the variable can't be converted
  ;into an int
  FixText2 = FIX(Text2)
  min = MIN(FixText2,MAX=max)
  list = LONARR(1)
  list[0] = min
  FOR i=1,(max-min) DO BEGIN
    list = [list,min+i]
  ENDFOR
  RETURN, list
  RETURN, [val1,val2]
  L1: RETURN, ''
END

;------------------------------------------------------------------------------
FUNCTION RetrieveList, text
  ;parse according to ','
  text1 = StringSplit(',',text)
  ;parse accordint to '-'
  sz = (SIZE(text1))(1)
  FOR i=0,(sz-1) DO BEGIN
    text2 = StringSplit('-',text1[i])
    sz = (SIZE(text2))(1)
    IF (sz GT 1) THEN BEGIN ;'10-15'
      list_to_add = CreateList(text2)
      IF (list_to_add NE [''] OR $
        list_to_add[0] EQ 0) THEN BEGIN
        list_to_add = STRING(list_to_add)
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
  RETURN, List
END

;------------------------------------------------------------------------------
PRO AddListToExcludeList, Event, PixelidListInt
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  pixel_excluded = (*(*global).pixel_excluded)
  TotalPixels = (*global).TotalPixels
  
  sz = (SIZE(PixelidListInt))(1)
  FOR i=0,(sz-1) DO BEGIN
    IF (PixelidListInt[i] LE (TotalPixels)) THEN BEGIN
      pixel_excluded[PixelidListInt[i]] = 1
    ENDIF
  ENDFOR
  (*(*global).pixel_excluded) = pixel_excluded
  (*(*global).pixel_excluded_base) = pixel_excluded
END

;------------------------------------------------------------------------------
PRO RemoveListToExcludeList, Event, PixelidListInt
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  pixel_excluded = (*(*global).pixel_excluded)
  TotalPixels = (*global).TotalPixels
  
  sz = (SIZE(PixelidListInt))(1)
  FOR i=0,(sz-1) DO BEGIN
    IF (PixelidListInt[i] LT (TotalPixels)) THEN BEGIN
      pixel_excluded[PixelidListInt[i]] = 0
    ENDIF
  ENDFOR
  (*(*global).pixel_excluded) = pixel_excluded
  (*(*global).pixel_excluded_base) = pixel_excluded
END

;------------------------------------------------------------------------------
PRO AddRowToExcludeList, Event, RowListInt
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  pixel_excluded = (*(*global).pixel_excluded)
  TotalRows = (*global).TotalRows
  
  sz = (SIZE(RowListInt))(1)
  FOR i=0,(sz-1) DO BEGIN
  
    IF (RowListINT[i] LT TotalRows) THEN BEGIN
    
      IF (RowListINT[i] GT 63) THEN BEGIN
        offset = 4096-64
      ENDIF ELSE BEGIN
        offset = 0
      ENDELSE
      FOR j=0,55 DO BEGIN
        pixel_excluded[(RowListInt[i])+j*64+offset] = 1
      ENDFOR
    ENDIF
    
  ENDFOR
  (*(*global).pixel_excluded) = pixel_excluded
  (*(*global).pixel_excluded_base) = pixel_excluded
END

;------------------------------------------------------------------------------
PRO RemoveRowToExcludeList, Event, RowListInt
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  pixel_excluded = (*(*global).pixel_excluded)
  TotalRows = (*global).TotalRows
  
  sz = (SIZE(RowListInt))(1)
  FOR i=0,(sz-1) DO BEGIN
  
    IF (RowListINT[i] LT TotalRows) THEN BEGIN
    
      IF (RowListINT[i] GT 63) THEN BEGIN
        offset = 4096
      ENDIF ELSE BEGIN
        offset = 0
      ENDELSE
      
      FOR j=0,56 DO BEGIN
        pixel_excluded[RowListInt[i]+j*64+offset] = 0
      ENDFOR
      
    ENDIF
    
  ENDFOR
  (*(*global).pixel_excluded) = pixel_excluded
  (*(*global).pixel_excluded_base) = pixel_excluded
END

;------------------------------------------------------------------------------
PRO AddTubeToExcludeList, Event, TubeListInt
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  pixel_excluded = (*(*global).pixel_excluded)
  TotalTubes = (*global).TotalTubes
  
  sz = (SIZE(TubeListInt))(1)
  FOR i=0,(sz-1) DO BEGIN
  
    IF (TubeListInt[i] LT TotalTubes) THEN BEGIN
    
      FOR j=0,63 DO BEGIN
        pixel_excluded[TubeListInt[i]*64+j] = 1
      ENDFOR
      
    ENDIF
    
  ENDFOR
  (*(*global).pixel_excluded) = pixel_excluded
  (*(*global).pixel_excluded_base) = pixel_excluded
END

;------------------------------------------------------------------------------
PRO RemoveTubeToExcludeList, Event, TubeListInt
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  pixel_excluded = (*(*global).pixel_excluded)
  TotalTubes = (*global).TotalTubes
  
  sz = (SIZE(TubeListInt))(1)
  FOR i=0,(sz-1) DO BEGIN
  
    IF (TubeListInt[i] LT TotalTubes) THEN BEGIN
    
      FOR j=0,63 DO BEGIN
        pixel_excluded[TubeListInt[i]*64+j] = 0
      ENDFOR
      
    ENDIF
    
  ENDFOR
  (*(*global).pixel_excluded)      = pixel_excluded
  (*(*global).pixel_excluded_base) = pixel_excluded
END

;------------------------------------------------------------------------------
PRO AddPixelsToExcludedList, Event, low_counts, high_counts
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  pixel_excluded = (*(*global).pixel_excluded_base)
  
  ;check value that are <= Counts in bank1
  bank1_integrated_counts = (*(*global).bank1_sum)
  bank2_integrated_counts = (*(*global).bank2_sum)
  sz_1 = (SIZE(bank1_integrated_counts))(1) * (SIZE(bank1_integrated_counts))(2)
  FOR i=0,(sz_1-1) DO BEGIN
  
    IF ((bank1_integrated_counts[i] LE low_counts)) THEN BEGIN
      pixel_excluded[i]=1
    ENDIF
    
    IF ((bank2_integrated_counts[i] LE low_counts)) THEN BEGIN
      pixel_excluded[i+4096] = 1
    ENDIF
    
    IF (high_counts NE 0) THEN BEGIN
      IF (bank1_integrated_counts[i] GE high_counts) THEN BEGIN
        pixel_excluded[i]=1
      ENDIF
    ENDIF
    
    IF (high_counts NE 0) THEN BEGIN
      IF (bank2_integrated_counts[i] GE high_counts) THEN BEGIN
        pixel_excluded[i+4096]=1
      ENDIF
    ENDIF
    
  ENDFOR
  
   (*(*global).pixel_excluded) = pixel_excluded
   
  ;check value that are <= Counts in bank2
;  bank2_integrated_counts = (*(*global).bank2_sum)
;  sz_2 = (SIZE(bank2_integrated_counts))(1) * (SIZE(bank2_integrated_counts))(2)
;  FOR i=0,(sz_2-1) DO BEGIN
;    IF ((bank2_integrated_counts[i] LE low_counts) OR $
;      (bank2_integrated_counts[i] GE high_counts)) THEN BEGIN
;      pixel_excluded[i+4096] = 1
;    ENDIF
;  ENDFOR
;  (*(*global).pixel_excluded) = pixel_excluded
  
END
