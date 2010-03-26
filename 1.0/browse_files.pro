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
 
 ;+
 ; :Description:
 ;    append the new file(s) to the current list of files
 ;
 ; :Params:
 ;    event
 ;    new_files_to_add
 ;
 ;
 ; :Author: j35
 ;-
 pro add_files_to_list, event, new_files_to_add
   compile_opt idl2
   
   widget_control, event.top, get_uvalue=global
   list_of_files = (*(*global).list_of_files)
   if (list_of_files[0] eq '') then begin
     (*(*global).list_of_files) = new_files_to_add
   endif else begin
     list_of_files = [list_of_files,new_files_to_add]
     (*(*global).list_of_files) = list_of_files
   endelse
   
 end
 
 ;+
 ; :Description:
 ;    this will refresh the table of step2 with the new list of files
 ;
 ; :Params:
 ;    event
 ;
 ;
 ;
 ; :Author: j35
 ;-
 pro update_list_of_files_table, event
   compile_opt idl2
   
   widget_control, event.top, get_uvalue=global
   list_of_files = (*(*global).list_of_files)
   
   putValue, Event, 'table_uname', transpose(list_of_files)
   
 end
 
 ;+
 ; :Description:
 ;    Enabled the remove file button of tab 2
 ;
 ; :Params:
 ;    event
 ;
 ;
 ;
 ; :Author: j35
 ;-
 pro activate_remove_files_button, event
   compile_opt idl2
   
   activate_widget, Event, 'remove_file', 1
   
 end

 ;+
 ; :Description:
 ;    This procedure will activate the dialog_pickfile and will gives the
 ;    user the possibility to select one or more files at a time
 ;
 ; :Params:
 ;    event
 ;;
 ; :Author: j35
 ;-
 pro browse_files, event
   compile_opt idl2
   
   widget_control, event.top, get_uvalue=global
   
   path = (*global).default_path
   dialog_parent = widget_info(event.top, find_by_uname='MAIN_BASE')
   title = 'Select the file(s) your want to add to your message'
   
   new_files_to_add = dialog_pickfile(dialog_parent=dialog_parent,$
     /must_exist,$
     /multiple_files,$
     path=path,$
     title=title)
     
   if (new_files_to_add[0] ne '') then begin ;add new files to list
     add_files_to_list, event, new_files_to_add
     update_list_of_files_table, event
     activate_remove_files_button, event
   endif
   
 end
 