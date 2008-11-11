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
PRO make_main_tree, Event, wTree
  WIDGET_CONTROL,Event.top,GET_UVALUE=global

  wTree = WIDGET_TREE((*global).TreeBase,$
                      XOFFSET   = 0,$
                      YOFFSET   = 0,$
                      SCR_XSIZE = 500,$
                      SCR_YSIZE = 660)
  (*global).TreeID = wTree
END

;------------------------------------------------------------------------------
PRO make_root, Event, wTree, wRoot, date
  wRoot = WIDGET_TREE(wTree,$
                      /FOLDER,$
;                      /EXPANDED,$
                      VALUE = date,$
                      uname = date)
END

;------------------------------------------------------------------------------
PRO make_leaf, Event, wRoot, file_name
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
IF (FILE_TEST(file_name)) THEN BEGIN
   file = (*global).ok_bmp
ENDIF ELSE BEGIN
   file = (*global).failed_bmp
ENDELSE
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[2,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[0,*,*]
wTree = WIDGET_TREE(wRoot,$
                    value = file_name,$
                    BITMAP = myIcon2)
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLmakeTree::init, Event, pMetadata
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nbr_jobs = (size(*pMetadata))(1)
  IF (nbr_jobs GT 0) THEN BEGIN
     make_main_tree, Event, wTree
     WIDGET_CONTROL, /REALIZE, Event.top
  ENDIF

;this strarr will keep record of all the uname of the various folders
  job_status_uname   = STRARR(nbr_jobs)
  job_status_root_id = INTARR(nbr_jobs)

  index = 0
  WHILE (index LT nbr_jobs) DO BEGIN ;create a tree for each job
    
;date[0] = (*pMetadata)[0].date
;date[1] = (*pMetadata)[1].date
;list_of_files = (*(*pMetadata)[0].files)
     
     make_root, Event, wTree, wRoot, (*pMetadata)[index].date
     WIDGET_CONTROL, /REALIZE, Event.top     
     job_status_uname[index]   = (*pMetadata)[index].date
     job_status_root_id[index] = wRoot
     
;create a leaf for each file
;     nbr_files = N_ELEMENTS(*(*pMetadata)[index].files)
     
;     i = 0
;     WHILE (i LT nbr_files) DO BEGIN
;         file_name_full  = (*(*pMetadata)[index].files)[i]
;         file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
;         file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
;         make_leaf, Event, wRoot, file_name
;         WIDGET_CONTROL, /REALIZE, Event.top
;        i++
;     ENDWHILE
     
     index++
  ENDWHILE

(*(*global).job_status_uname)   = job_status_uname
(*(*global).job_status_root_id) = job_status_root_id

;  WIDGET_CONTROL, /REALIZE, Event.top

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLmakeTree__define
struct = {IDLmakeTree,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
