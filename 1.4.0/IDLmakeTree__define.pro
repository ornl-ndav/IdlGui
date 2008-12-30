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
PRO make_main_tree_FOR_make_tree, Event, wTree
WIDGET_CONTROL,Event.top,GET_UVALUE=global
IF (WIDGET_INFO((*global).TreeID,/VALID_ID)) THEN BEGIN
    WIDGET_CONTROL, (*global).TreeID, /DESTROY
ENDIF
wTree = WIDGET_TREE((*global).TreeBase,$
                    UNAME     = 'job_status_tree',$
                    XOFFSET   = 0,$
                    YOFFSET   = 0,$
                    SCR_XSIZE = 500,$
                    SCR_YSIZE = 590)
(*global).TreeID = wTree
END

;------------------------------------------------------------------------------
PRO make_root_FOR_make_tree, Event, wTree, wRoot, date, uname, expanded
wRoot = WIDGET_TREE(wTree,$
                    /FOLDER,$
                    EXPANDED = expanded,$
                    VALUE = date,$
                    UNAME = uname)
END

;------------------------------------------------------------------------------
PRO make_leaf_FOR_make_tree, Event, wRoot, file_name, uname, full_file_name
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
FUNCTION IDLmakeTree::init, Event, pMetadata
WIDGET_CONTROL,Event.top,GET_UVALUE=global

nbr_jobs = (size(*pMetadata))(1)
IF (nbr_jobs GT 0) THEN BEGIN
    make_main_tree_FOR_make_tree, Event, wTree
ENDIF

job_status_uname       = STRARR(nbr_jobs)
job_status_root_id     = INTARR(nbr_jobs)

;this strarr will keep record of all the uname of the various folders
job_status_root_status              = INTARR(nbr_jobs)
job_status_root_status[0]           = 1
(*global).job_status_first_plot     = 0
(*(*global).job_status_root_status) = job_status_root_status
absolute_leaf_index                 = INTARR(nbr_jobs)
absolute_leaf_index_offset          = 0

index = 0
WHILE (index LT nbr_jobs) DO BEGIN ;create a tree for each job
    
;date[0] = (*pMetadata)[0].date
;date[1] = (*pMetadata)[1].date
;list_of_files = (*(*pMetadata)[0].files)
    
    job_status_uname[index]   = $
      STRCOMPRESS((*pMetadata)[index].date,/REMOVE_ALL)
    
    make_root_FOR_make_tree, Event, $
      wTree, $
      wRoot, $
      (*pMetadata)[index].date, $
      job_status_uname[index],$
      job_status_root_status[index]
    
    job_status_root_id[index] = wRoot
    
    IF (job_status_root_status[index]) THEN BEGIN
; create a leaf for each file
        nbr_files = N_ELEMENTS(*(*pMetadata)[index].files)
        
;keep only the name of the output file (remove the stdout and stderr files)
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
            aMetadataValue = (*(*(*global).pMetadataValue))
            path = aMetadataValue[index+1,7]
            full_file_name = path + file_name
            make_leaf_FOR_make_tree, Event, $
              wRoot, $
              file_name, $
              leaf_uname, $
              full_file_name
            i++
        ENDWHILE
        absolute_leaf_index[index] = i + absolute_leaf_index_offset
        absolute_leaf_index_offset = absolute_leaf_index[index]
    ENDIF
        index++
ENDWHILE

(*(*global).job_status_uname)    = job_status_uname
(*(*global).job_status_root_id)  = job_status_root_id
(*(*global).leaf_uname_array)    = leaf_uname_array
(*(*global).absolute_leaf_index) = absolute_leaf_index

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


;(*(*global).absolute_leaf_index) = absolute_leaf_index
;if there are 4 leaves in the first folder, 3 in the next one....
;absolute_leaf_index = [0,4]
;leaf_index of 7 will -> 4, that means index 1
;real_leaf_index = 7 - absolute_leaf_index[1] = 3 (real leaf index)
