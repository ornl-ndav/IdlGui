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
FUNCTION get_file_name, file_name_full
file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
RETURN, file_name
END

;------------------------------------------------------------------------------
PRO make_main_tree, Event, wTree
WIDGET_CONTROL,Event.top,GET_UVALUE=global
wTree = WIDGET_TREE((*global).TreeBase,$
                    UNAME     = 'job_status_tree',$
                    XOFFSET   = 0,$
                    YOFFSET   = 0,$
                    SCR_XSIZE = 500,$
                    SCR_YSIZE = 630)
(*global).TreeID = wTree
END

;------------------------------------------------------------------------------
PRO make_root, Event, wTree, wRoot, date, uname, $
               EXPANDED_STATUS=expanded_status
IF (expanded_status) THEN BEGIN
    wRoot = WIDGET_TREE(wTree,$
                        /FOLDER,$
                        /EXPANDED,$
                        VALUE = date,$
                        UNAME = uname)
ENDIF ELSE BEGIN
    wRoot = WIDGET_TREE(wTree,$
                        /FOLDER,$
                        VALUE = date,$
                        UNAME = uname)
ENDELSE
END

;------------------------------------------------------------------------------
PRO make_leaf, Event, wRoot, file_name, uname, full_file_name
WIDGET_CONTROL,Event.top,GET_UVALUE=global
IF (FILE_TEST(full_file_name)) THEN BEGIN
    icon = (*(*global).icon_ok)
ENDIF ELSE BEGIN
    icon = (*(*global).icon_failed)
ENDELSE
wTree = WIDGET_TREE(wRoot,$
                    VALUE  = file_name,$
                    UNAME  = uname,$
                    BITMAP = icon)
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLrefreshTree::init, Event, pMetadata
WIDGET_CONTROL,Event.top,GET_UVALUE=global

WIDGET_CONTROL, (*global).TreeID, /DESTROY

nbr_jobs = (size(*pMetadata))(1)
IF (nbr_jobs GT 0) THEN BEGIN
    make_main_tree, Event, wTree
ENDIF

job_status_uname           = (*(*global).job_status_uname)
job_status_root_id         = (*(*global).job_status_root_id)
leaf_uname_array           = (*(*global).leaf_uname_array)
absolute_leaf_index        = INTARR(nbr_jobs)
absolute_leaf_index_offset = 0

sz = N_ELEMENTS(job_status_uname)
index = 0
job_status_root_status = (*(*global).job_status_root_status)
WHILE (index LT sz) DO BEGIN
    uname = job_status_uname[index]
    expanded_status = job_status_root_status[index]
    
    make_root, Event, $
      wTree, $
      wRoot, $
      (*pMetadata)[index].date, $
      job_status_uname[index],$
      EXPANDED_STATUS = expanded_status
    
;    IF (expanded_status) THEN BEGIN
    
    nbr_files = N_ELEMENTS(*(*pMetadata)[index].files)
    i = 0
    WHILE (i LT nbr_files) DO BEGIN
        file_name_full  = (*(*pMetadata)[index].files)[i]
        file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
        file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
;associate a uname to each leaf
        leaf_uname = job_status_uname[index] + '|' + file_name
        IF ((index + i) EQ 0) THEN BEGIN
            leaf_uname_array = [leaf_uname]
        ENDIF ELSE BEGIN
            leaf_uname_array = [leaf_uname_array,leaf_uname]
        ENDELSE
        IF (expanded_status) THEN BEGIN
            file_name = get_file_name((*(*pMetadata)[index].files)[i])
            aMetadataValue = (*(*(*global).pMetadataValue))
            path = aMetadataValue[index+1,7]
            full_file_name = path + file_name
            make_leaf, Event, wRoot, $
              file_name, $
              leaf_uname_array[index+i], $
              full_file_name
        ENDIF
        i++
    ENDWHILE
    absolute_leaf_index[index] = i + absolute_leaf_index_offset
    absolute_leaf_index_offset = absolute_leaf_index[index]
;ENDIF
    job_status_root_id[index] = wRoot
    
    index++
ENDWHILE

(*(*global).leaf_uname_array)    = leaf_uname_array
(*(*global).job_status_root_id)  = job_status_root_id
(*(*global).absolute_leaf_index) = absolute_leaf_index

RETURN, 1

END


;******************************************************************************
;******  Class Define *********************************************************
PRO IDLrefreshTree__define
struct = {IDLrefreshTree,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
