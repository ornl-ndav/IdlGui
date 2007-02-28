pro more_nexus_eventcb
end






pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/more_nexus_title.bmp"
id = widget_info(wWidget,find_by_uname="logo_message_draw")
WIDGET_CONTROL, id, GET_VALUE=id_value
wset, id_value
image = read_bmp(image_logo)
tv, image,0,0,/true
;turn off hourglass
widget_control,hourglass=0
end


pro Main_realize_2, wWidget
tlb = get_tlb(wWidget)
;get the global data structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
end







pro open_nexus_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DEVICE, DECOMPOSED = 0
loadct,5
widget_control,/hourglass

HISTO_EVENT_FILE_TEXT_BOX_id = widget_info(Event.top,$
                                           find_by_uname='HISTO_EVENT_FILE_TEXT_BOX')
widget_control, HISTO_EVENT_FILE_TEXT_BOX_id, get_value=run_number_text

;check if file is local or not
local = is_nexus_local(run_number_text)
(*global).local_nexus = local[0]
local_nexus = local[0]

;get run_number
run_number = remove_star_from_string(run_number_text)
(*global).run_number = run_number

instrument = (*global).instrument
;get full nexus path
full_nexus_name = find_full_nexus_name(Event,$
                                       local_nexus,$
                                       run_number,$
                                       instrument)

(*global).full_nexus_name = full_nexus_name

;first thing to do, reinitialize log_book and info box
nexus_name = instrument + '_' + run_number
text = 'Looking for ' + nexus_name + ' ...'
output_into_text_box, event, 'infos_text', text , 1
output_into_text_box, event, 'log_book_text', text , 1

find_nexus = (*global).find_nexus
reinitialize_interface, event, find_nexus, instrument

output_data_base_id = widget_info(event.top,find_by_uname='output_data_base')

if (find_nexus EQ 0 or full_nexus_name EQ '') then begin

    widget_control, output_data_base_id, map=0

    if (local_nexus EQ 0) then begin
        nexus_name = 'Archive '
    endif else begin
        nexus_name = 'Local '
    endelse
    nexus_name += instrument + '_' + strcompress(run_number,/remove_all)
    nexus_name += ' ..... does not exist'
    output_into_text_box, event, 'infos_text', nexus_name, 1
    output_into_text_box, event, 'log_book_text', nexus_name, 1
endif else begin
    
;create tmp folder
    return_text = create_tmp_folder(event, (*global).tmp_folder)
    
    if ((*global).activate_preview EQ 1) then begin
        display_data,$
          event,$
          instrument,$          ; instrument
          full_nexus_name,$     ; full nexus name
          (*global).tmp_folder ; where to create the histo_mapped file
    endif

    nexus_name = instrument + '_' + strcompress(run_number,/remove_all)
    nexus_name += ' has been found:'
    output_into_text_box, event, 'infos_text', nexus_name, 1
    output_into_text_box, event, 'log_book_text', nexus_name, 1
    output_into_text_box, event, 'infos_text', full_nexus_name, 1
    output_into_text_box, event, 'log_book_text', full_nexus_name, 1
    
    ;activate bottom base (output_data)
    widget_control, output_data_base_id, map=1

endelse

;turn off hourglass
widget_control,hourglass=0

end





pro display_data, event, instrument, full_nexus_name, tmp_folder
;first create local copy of histo_mapped
create_local_copy_of_histo_mapped, event, full_nexus_name, tmp_folder
;plot data
plot_data, event
end





pro create_local_copy_of_histo_mapped, Event, full_nexus_name, tmp_folder

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).instrument EQ "BSS") then begin
    
    cmd_dump = "nxdir " + full_nexus_name
    cmd_dump_top = cmd_dump + " -p /entry/bank1/data/ --dump "
    cmd_dump_bottom = cmd_dump + " -p /entry/bank2/data/ --dump "
;get name of output_file
    tmp_output_file = tmp_folder
    tmp_output_file += "/" + (*global).instrument
    tmp_output_file += "_" + (*global).run_number
    
    tmp_output_file_top = tmp_output_file + "_top.dat"
    tmp_output_file_bottom = tmp_output_file + "_bottom.dat"
    (*global).file_to_plot_top = tmp_output_file_top
    (*global).file_to_plot_bottom = tmp_output_file_bottom
        
    cmd_dump_top += tmp_output_file_top 
    cmd_dump_bottom += tmp_output_file_bottom
    
;display command
    full_text = 'Create local copy of the histo mapped data: '
    output_into_text_box, event, 'log_book_text', full_text
    full_text = '(top part) > ' + cmd_dump_top
    output_into_text_box, event, 'log_book_text', full_text
    spawn, cmd_dump_top, listening, err_listening
    output_into_text_box, event, 'log_book_text', listening
    output_error, event, 'log_book_text', err_listening
    text= "..done"
    output_into_text_box, event, 'log_book_text', text
    
    full_text = 'Create local copy of the histo mapped data: '
    output_into_text_box, event, 'log_book_text', full_text
    full_text = '(bottom part) > ' + cmd_dump_bottom
    output_into_text_box, event, 'log_book_text', full_text
    spawn, cmd_dump_bottom, listening, err_listening
    output_into_text_box, event, 'log_book_text', listening
    output_error, event, 'log_book_text', err_listening
    text= "..done"
    output_into_text_box, event, 'log_book_text', text
    
endif else begin
    
    cmd_dump = "nxdir " + full_nexus_name
    cmd_dump += " -p /entry/bank1/data/ --dump "
    
;get name of output_file
    tmp_output_file = tmp_folder
    tmp_output_file += "/" + (*global).instrument
    tmp_output_file += "_" + (*global).run_number
    
    tmp_output_file += ".dat"
    (*global).file_to_plot = tmp_output_file
    cmd_dump += tmp_output_file
    
;display command
    text= cmd_dump
    full_text = 'Create local copy of the histo mapped data: '
    output_into_text_box, event, 'log_book_text', full_text
    full_text = '> ' + cmd_dump
    output_into_text_box, event, 'log_book_text', full_text
    spawn, cmd_dump, listening, err_listening
    output_into_text_box, event, 'log_book_text', listening
    output_error, event, 'log_book_text', err_listening
    text= "..done"
    output_into_text_box, event, 'log_book_text', text

endelse
    
end





pro plot_data_REF_M, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve data parameters
Nx = (*global).Nx_REF_M
Ny = (*global).Ny_REF_M

;indicate reading data with hourglass icon
widget_control,/hourglass

;file to open
file = (*global).file_to_plot

;only read data if valid file given
if file NE '' then begin

   openr,u,file,/get
   ;find out file info
   fs = fstat(u)

   Nimg = Nx*Ny
   Ntof = fs.size/(Nimg*4L)
   (*global).Ntof = Ntof	;set back in global structure

   data_assoc = assoc(u,lonarr(Ntof))
	
   ;make the image array
   img = lonarr(Nx,Ny)
   for i=0L,Nimg-1 do begin
	x = i MOD Nx
	y = i/Nx
	img[x,y] = total(data_assoc[i])
   endfor

   img=transpose(img)

   ;load data up in global ptr array
;   (*(*global).img_ptr) = img
;   (*(*global).data_assoc) = data_assoc
	
   ;now turn hourglass back off
   widget_control,hourglass=0

   ;put image data in the display window
   id = widget_info(Event.top, FIND_BY_UNAME='drawing')
   WIDGET_CONTROL, id, GET_VALUE = view_plot   
   wset,view_plot
   tvscl,img

   close, u
   free_lun, u
	
endif;valid file

;now turn hourglass back off
widget_control,hourglass=0

end







pro plot_data_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve data parameters
Nx = (*global).Nx_REF_L
Ny = (*global).Ny_REF_L

;indicate reading data with hourglass icon
widget_control,/hourglass

;file to open
file = (*global).file_to_plot

;only read data if valid file given
if file NE '' then begin

   openr,u,file,/get
   ;find out file info
   fs = fstat(u)

   Nimg = Nx*Ny
   Ntof = fs.size/(Nimg*4L)
   (*global).Ntof = Ntof	;set back in global structure

   data_assoc = assoc(u,lonarr(Ntof))
	
   ;make the image array
   img = lonarr(Nx,Ny)
   for i=0L,Nimg-1 do begin
	x = i MOD Nx
	y = i/Nx
	img[x,y] = total(data_assoc[i])
   endfor

   img=transpose(img)

   ;load data up in global ptr array
;   (*(*global).img_ptr) = img
;   (*(*global).data_assoc) = data_assoc
	
   ;put image data in the display window
   id = widget_info(Event.top, FIND_BY_UNAME='drawing')
   WIDGET_CONTROL, id, GET_VALUE = view_plot   
   wset,view_plot
   tvscl,img

   close, u
   free_lun, u
	
endif;valid file

;now turn hourglass back off
widget_control,hourglass=0

end





pro plot_data_BSS, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

widget_control,/hourglass

Nx = 64L
Ny = 64L

;file = (*global).file_to_plot
file_top = (*global).file_to_plot_top
file_bottom = (*global).file_to_plot_bottom

;top_bank
file_name = [file_top, file_bottom]

for i=0,1 do begin
    
    openr,1,file_name[i]
    fs=fstat(1)
    file_size=fs.size
    N=long(file_size)/4L
    data=lonarr(N)
    readu,1,data
    close,1
    free_lun,1
    pixel_number = 64*64
    Nt=N/(pixel_number)
    
    indx1 = where(data GT 0,Ngt0)
    img=intarr(Nt,Nx,Ny)
    img(indx1) = data(indx1)
    
    simg = total(img,1)
    case i of 
        0: top_bank = img
        1: bottom_bank = img
        else:
    endcase
    
endfor

;work on top and bottom banks
top_bank = transpose(top_bank)
bottom_bank = transpose(bottom_bank)

x_coeff = 5
y_coeff = 2

New_Ny = y_coeff*Ny
New_Nx = x_coeff*Nx

xoff = 10
yoff = 10

;top bank
view_info = widget_info(Event.top,FIND_BY_UNAME='drawing_top')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

;tvimg = congrid(top_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(top_bank, New_Nx, New_Ny,/sample)
tvscl, tvimg, /device

;bottom bank
view_info = widget_info(Event.top,FIND_BY_UNAME='drawing_bottom')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

;tvimg = congrid(bottom_bank, New_Nx, New_Ny, /interp)
tvimg = rebin(bottom_bank, New_Nx, New_Ny,/sample) 
tvscl, tvimg, /device

;turn off hourglass
widget_control,hourglass=0

end












pro plot_data, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

text = "Plotting......"
output_into_text_box, event, 'log_book_text', text

;plot data according to instrument type
case (*global).instrument of        
    
    "REF_L": begin
        plot_data_REF_L, event
    end
    "REF_M": begin
        plot_data_REF_M, event      
    end
    "BSS"  : begin
        plot_data_BSS, event
    end
endcase

text = "..done"
output_into_text_box, event, 'log_book_text', text

end

  
  
  























  

pro COMPLETE_RUNINFO_FILE_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument =  (*global).instrument

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize_display
   
cmd = "less " + (*global).runinfo_xml_filename
spawn, cmd, listening, err_listening
output_error, Event, err_listening

id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_XML_DISPLAY_TEXT")
widget_control, id, set_value = listening

end







pro COMPLETE_CVINFO_FILE_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument =  (*global).instrument

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize_display
   
cmd = "less " + (*global).cvinfo_xml_filename
spawn, cmd, listening, err_listening
output_error, Event, err_listening

id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_XML_DISPLAY_TEXT")
widget_control, id, set_value = listening

end










function display_xml_info, filename, item_name

oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=filename)

oDocList = oDoc->GetElementsByTagName('DetectorInfo')
obj1 = oDocList->item(0)

obj2=obj1->GetElementsByTagName('Scattering')
obj3=obj2->item(0)

obj4=obj3->GetElementsByTagName('NumTimeChannels')
obj5=obj4->item(0)

obj5b=obj5->getattributes()
obj5c=obj5b->getnameditem(item_name)

return, obj5c->getvalue()

end







PRO xml_object_recurse, oNode, match, return_value

;check to see if this node matches the one we're looking for
if oNode->GetNodeName() EQ match then begin
;case where we find a match
;now we have to get the first child of this node to get the value
;for this node
   		oSibling = oNode->GetFirstChild()
;now that we found the sibling, save the result and pass it all the way back
;to the top
		if OBJ_VALID(oSibling) then return_value = oSibling->GetNodeValue()
end
   ; Visit children - process of recursing deeper into the object tree
   oSibling = oNode->GetFirstChild()
   WHILE OBJ_VALID(oSibling) DO BEGIN
      xml_object_recurse, oSibling, match, return_value
      oSibling = oSibling->GetNextSibling()
   ENDWHILE
END








;function that creates the XML object
function get_xml_value, NodeName, filename
;create XML object and load file
   oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=filename)
;now load it with our xml file of interest
;   oDoc->Load, filename
;initiate the variable that will contain the data we're interested in
   return_value = ''
;recurse the object tree and find what we're looking for
   xml_object_recurse, oDoc, NodeName, return_value
;	print,'Return Value: ',return_value
;send the findings back to the calling program
	return, return_value
;cleanup memory and destroy the object
   OBJ_DESTROY, oDoc
END








function read_xml_file, filename, nodename

filename = filename[0]
;and the nodename (xml key) for the data they want
;call the function to get the value we're looking for from the xml file
xml_node_value = get_xml_value(NodeName,filename)

return, xml_node_value

end








function get_tlb,wWidget

id = wWidget
cntr = 0
while id NE 0 do begin

	tlb = id
	id = widget_info(id,/parent)
	cntr = cntr + 1
	if cntr GT 10 then begin
		print,'Top Level Base not found...'
		tlb = -1
	endif
endwhile

return,tlb

end







function get_full_path_to_preNeXus_path, listening, instrument, run_number
string_to_remove = instrument + "_" + strcompress(run_number,/remove_all)
string_to_remove += "_cvinfo.xml"
full_path=strsplit(listening,string_to_remove,/extract,/regex)
return, full_path
end







;return 1 if file is an event file
;return 0 if file is a histogram file
;return -1 if there is no event of histogram file
function check_if_file_is_event, name_if_event, name_if_histogram

check_cmd = "ls " + name_if_event
spawn, check_cmd, listening

if (listening EQ '') then begin
    check_histo_cmd = "ls " + name_if_histogram
    spawn, check_histo_cmd, listening_histo
    if (listening_histo EQ '') then begin
        result = -1
    endif else begin
        result = 0
    endelse
endif else begin
    result = 1
endelse
return, result
end









pro sns_idl_button_eventcb, Event
spawn, '/SNS/users/j35/IDL/MainInterface/sns_idl_tools &'
end







pro wTab_eventcb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wTab_id = widget_info(event.top,find_by_uname='wTab')
index = widget_info(wTab_id, /tab_current)

activate_preview = (*global).activate_preview
instrument = (*global).instrument

case index of
    0:begin
        display_preview_message, event, instrument, activate_preview
    end
    1:begin

    end
    2:begin

    end
endcase
end



























pro display_preview_message, event, instrument, display_status

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

find_nexus = (*global).find_nexus

case instrument of

    'REF_L': begin

        id = widget_info(event.top,find_by_uname='drawing')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        wset, id_value
        
        if (display_status EQ 0) then begin
            no_preview=$
              "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_REF_L.bmp"
            image = read_bmp(no_preview)
            tv, image,0,0,/true
        endif else begin
            if (find_nexus EQ 0) then erase
        endelse
    end
    
    'REF_M': begin

         id = widget_info(event.top,find_by_uname='drawing')
         WIDGET_CONTROL, id, GET_VALUE=id_value
         wset, id_value

         if (display_status EQ 0) then begin
             no_preview=$
               "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_REF_M.bmp"
             image = read_bmp(no_preview)
             tv, image,0,0,/true
         endif else begin
            if (find_nexus EQ 0) then erase
         endelse

     end

     'BSS': begin
         id_top = widget_info(event.top,find_by_uname='drawing_top')
         WIDGET_CONTROL, id_top, GET_VALUE=id_top_value

         id_bottom = widget_info(event.top,find_by_uname='drawing_bottom')
         WIDGET_CONTROL, id_bottom, GET_VALUE=id_bottom_value
         
         if (display_status EQ 0) then begin
             no_preview=$
               "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_BSS_top.bmp"
             image = read_bmp(no_preview)
             wset, id_top_value
             tv, image,0,0,/true

             no_preview=$
               "/SNS/users/j35/SVN/HistoTool/trunk/gui/more_nexus/no_preview_BSS_bottom.bmp"
             image = read_bmp(no_preview)
             wset, id_bottom_value
             tv, image,0,0,/true
         endif else begin
            if (find_nexus EQ 0) then begin
                wset, id_top_value
                erase
                wset, id_bottom_value
                erase
            endif
         endelse

     end
endcase

end





pro activate_preview_button_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

widget_control,/hourglass
activate_preview_button_id = $
  widget_info(Event.top,find_by_uname='activate_preview_button')

if ((*global).activate_preview EQ 0) then begin
    
;desactivate button during plot
    activate_preview_button_id = $
      widget_info(event.top,find_by_uname='activate_preview_button')
    widget_control, activate_preview_button_id, sensitive=0
    text = 'DESACTIVATE PREVIEW'
    widget_control, activate_preview_button_id, set_value = text
    (*global).activate_preview = 1
    display_preview_message, event, (*global).instrument, 1
    if ((*global).find_nexus EQ 1) then begin
        display_data, event, (*global).instrument, $
          (*global).full_nexus_name, (*global).tmp_folder
    endif
;reactivate button after plot
    widget_control, activate_preview_button_id, sensitive=1
endif else begin
    text = 'ACTIVATE PREVIEW'
    widget_control, activate_preview_button_id, set_value = text
    (*global).activate_preview = 0
    display_preview_message, event, (*global).instrument, 0
endelse

;turn off hourglass
widget_control,hourglass=0

end






pro output_data_group_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

output_list_id = widget_info(Event.top,find_by_uname='output_data_group')
widget_control, output_list_id, get_value=selection

number_of_selection = 0 ;number of selection

;BSS case
if ((*global).instrument EQ 'BSS') then begin

;event output data
    event_id = widget_info(event.top,find_by_uname='event_text_base')
    if (selection[0] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, event_id, map=map_value
    
;histogram bank 1 output data
    histogram_id = widget_info(event.top,find_by_uname='histogram_bank1_text_base')
    if (selection[1] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, histogram_id, map=map_value
    
;histogram bank 2 output data
    histogram_id = widget_info(event.top,find_by_uname='histogram_bank2_text_base')
    if (selection[2] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, histogram_id, map=map_value

;histogram bank 3 output data
    histogram_id = widget_info(event.top,find_by_uname='histogram_bank3_text_base')
    if (selection[3] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, histogram_id, map=map_value

;timebins output data
    timebins_id = widget_info(event.top,find_by_uname='timebins_text_base')
    if (selection[4] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, timebins_id, map=map_value
    
;pulseid output data
    pulseid_id = widget_info(event.top,find_by_uname='pulseid_text_base')
    if (selection[5] EQ 1) then begin
        map_value = 1
        number_of_selection += 1	
    endif else begin
        map_value = 0
    endelse
    widget_control, pulseid_id, map=map_value
    
;infos output data
    infos_id = widget_info(event.top,find_by_uname='infos_text_base')
    if (selection[6] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, infos_id, map=map_value
    
    output_data_button_base_id = $
      widget_info(event.top,find_by_uname='output_data_button_base')
    if (number_of_selection GE 1) then begin ;display go button
        widget_control, output_data_button_base_id, map=1
    endif else begin
        widget_control, output_data_button_base_id, map=0
    endelse
    
;populate text boxes selected
    populate_text_boxes, event, selection

endif else begin

;event output data
    event_id = widget_info(event.top,find_by_uname='event_text_base')
    if (selection[0] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, event_id, map=map_value
    
;histogram output data
    histogram_id = widget_info(event.top,find_by_uname='histogram_text_base')
    if (selection[1] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, histogram_id, map=map_value
    
;timebins output data
    timebins_id = widget_info(event.top,find_by_uname='timebins_text_base')
    if (selection[2] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, timebins_id, map=map_value
    
;pulseid output data
    pulseid_id = widget_info(event.top,find_by_uname='pulseid_text_base')
    if (selection[3] EQ 1) then begin
        map_value = 1
        number_of_selection += 1	
    endif else begin
        map_value = 0
    endelse
    widget_control, pulseid_id, map=map_value
    
;infos output data
    infos_id = widget_info(event.top,find_by_uname='infos_text_base')
    if (selection[4] EQ 1) then begin
        map_value = 1
        number_of_selection += 1
    endif else begin
        map_value = 0
    endelse
    widget_control, infos_id, map=map_value
    
    output_data_button_base_id = $
      widget_info(event.top,find_by_uname='output_data_button_base')
    if (number_of_selection GE 1) then begin ;display go button
        widget_control, output_data_button_base_id, map=1
    endif else begin
        widget_control, output_data_button_base_id, map=0
    endelse
    
;populate text boxes selected
    populate_text_boxes, event, selection
    
endelse

end












pro reinitialize_interface, event, find_nexus, instrument

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).activate_preview EQ 1) then begin
    
;erase display
    case instrument of 
        'REF_L': begin
            drawing_id = widget_info(Event.top,find_by_uname='drawing')
            widget_control, drawing_id, get_value=id
            wset, id
            erase
        end
        'REF_M': begin
            drawing_id = widget_info(Event.top,find_by_uname='drawing')
            widget_control, drawing_id, get_value=id
            wset, id
            erase
        end
        'BSS':begin
            drawing_top_id = widget_info(Event.top,find_by_uname='drawing_top')
            widget_control, drawing_top_id, get_value=id_top
            wset, id_top
            erase
            drawing_bottom_id = widget_info(Event.top,find_by_uname='drawing_bottom')
            widget_control, drawing_bottom_id, get_value=id_bottom
            wset, id_bottom
            erase
        end
    endcase
    
endif

;reinitialize log_book
log_book_id = widget_info(Event.top,find_by_uname='log_book_text')
widget_control, log_book_id, set_value=''

end






pro create_full_output_name, event, file_name, output_format, text_box_uname

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

text_box_uname_id = widget_info(event.top,find_by_uname=text_box_uname)

if (file_name EQ '') then begin
    file_name = ''
endif else begin
    case output_format of
        'binary': begin
            ext = (*global).binary
        end
        'ascii': begin
            ext = (*global).ascii
        end
        'xml': begin
            ext = (*global).xml
        end
        else:
    endcase
    file_name += ext
endelse

widget_control, text_box_uname_id, set_value = file_name

end







pro populate_text_boxes, event, selection

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

working_path = (*global).working_path
run_number = (*global).run_number
instrument = (*global).instrument
first_part_of_name = working_path + instrument + '_' + strcompress(run_number)

;BSS case
if (instrument EQ 'BSS') then begin

;event filename
    if (selection[0] EQ 0) then begin
        create_full_output_name, event, '', '', 'event_text'
    endif else begin
        file_name=first_part_of_name+(*global).event_ext
        event_format_group_id = widget_info(event.top,find_by_uname='event_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'event_text'
    endelse
    
;histogram bank 1 filename
    if (selection[1] EQ 0) then begin
        create_full_output_name, event, '', '', 'histogram_bank1_text'
    endif else begin
        file_name=first_part_of_name+(*global).histo_bank1_ext
        event_format_group_id = widget_info(event.top,find_by_uname='histogram_bank1_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'histogram_bank1_text'
    endelse
    
;histogram bank 2 filename
    if (selection[2] EQ 0) then begin
        create_full_output_name, event, '', '', 'histogram_bank2_text'
    endif else begin
        file_name=first_part_of_name+(*global).histo_bank2_ext
        event_format_group_id = widget_info(event.top,find_by_uname='histogram_bank2_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'histogram_bank2_text'
    endelse

;histogram bank 3 filename
    if (selection[3] EQ 0) then begin
        create_full_output_name, event, '', '', 'histogram_bank3_text'
    endif else begin
        file_name=first_part_of_name+(*global).histo_bank3_ext
        event_format_group_id = widget_info(event.top,find_by_uname='histogram_bank3_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'histogram_bank3_text'
    endelse

;timebins filename
    if (selection[4] EQ 0) then begin
        create_full_output_name, event, '', '', 'timebins_text'
    endif else begin
        file_name=first_part_of_name+(*global).timebins_ext
        event_format_group_id = widget_info(event.top,find_by_uname='timebins_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'timebins_text'
    endelse
    
;pulseid filename
    if (selection[5] EQ 0) then begin
        create_full_output_name, event, '', '', 'pulseid_text'
    endif else begin
        file_name=first_part_of_name+(*global).pulseID_ext
        event_format_group_id = widget_info(event.top,find_by_uname='pulseid_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'pulseid_text'
    endelse
    
;infos filename
    if (selection[6] EQ 0) then begin
        create_full_output_name, event, '', '', 'infos_file_text'
    endif else begin
        file_name=first_part_of_name+(*global).infos_ext
        event_format_group_id = widget_info(event.top,find_by_uname='infos_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'ascii'
            1: output_format = 'xml'
        endcase
        create_full_output_name, event, file_name, output_format, 'infos_file_text'
    endelse

endif else begin

;event filename
    if (selection[0] EQ 0) then begin
        create_full_output_name, event, '', '', 'event_text'
    endif else begin
        file_name=first_part_of_name+(*global).event_ext
        event_format_group_id = widget_info(event.top,find_by_uname='event_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'event_text'
    endelse
    
;histogram filename
    if (selection[1] EQ 0) then begin
        create_full_output_name, event, '', '', 'histogram_text'
    endif else begin
        file_name=first_part_of_name+(*global).histo_ext
        event_format_group_id = widget_info(event.top,find_by_uname='histogram_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'histogram_text'
    endelse
    
;timebins filename
    if (selection[2] EQ 0) then begin
        create_full_output_name, event, '', '', 'timebins_text'
    endif else begin
        file_name=first_part_of_name+(*global).timebins_ext
        event_format_group_id = widget_info(event.top,find_by_uname='timebins_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'timebins_text'
    endelse
    
;pulseid filename
    if (selection[3] EQ 0) then begin
        create_full_output_name, event, '', '', 'pulseid_text'
    endif else begin
        file_name=first_part_of_name+(*global).pulseID_ext
        event_format_group_id = widget_info(event.top,find_by_uname='pulseid_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'binary'
            1: output_format = 'ascii'
        endcase
        create_full_output_name, event, file_name, output_format, 'pulseid_text'
    endelse
    
;infos filename
    if (selection[4] EQ 0) then begin
        create_full_output_name, event, '', '', 'infos_file_text'
    endif else begin
        file_name=first_part_of_name+(*global).infos_ext
        event_format_group_id = widget_info(event.top,find_by_uname='infos_format_group')
        widget_control, event_format_group_id, get_value=format_index
        case format_index of
            0: output_format = 'ascii'
            1: output_format = 'xml'
        endcase
        create_full_output_name, event, file_name, output_format, 'infos_file_text'
    endelse
    
endelse

end






pro output_format_group_cb, Event, uname

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

output_list_id = widget_info(Event.top,find_by_uname='output_data_group')
widget_control, output_list_id, get_value=selection

populate_text_boxes, event, selection

end






pro output_data_button_cb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;collect info from data group
output_data_group_id = widget_info(event.top,find_by_uname='output_data_group')
widget_control, output_data_group_id, get_value=selection

;event
if (selection[0] EQ 1) then begin
    output_file, event, 'event', 'event_text', 'event_format_group', 'data'
endif

;histogram
if (selection[1] EQ 1) then begin
    output_file, event, 'histogram', 'histogram_text', 'histogram_format_group', 'data'
endif

;timebins
if (selection[2] EQ 1) then begin
    output_file, event, 'timebins', 'timebins_text', 'timebins_format_group', 'data'
endif

;pulseid
if (selection[3] EQ 1) then begin
    output_file, event, 'pulseid', 'pulseid_text', 'pulseid_format_group', 'data'
endif

;infos
if (selection[4] EQ 1) then begin
    output_file, event, 'infos', 'infos_file_text', 'infos_format_group', 'text'
endif

;reinitialize file name
widget_control, output_data_group_id, set_value=[0,0,0,0,0]

;hide all text boxes
output_data_group_cb, Event

end




; data_type = event, histogram....etc
; type = 'data' or 'text'
pro output_file, event, data_type, output_text_uname, output_format_uname, type

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve value of text box = output file name
output_text_uname_id = widget_info(event.top,find_by_uname=output_text_uname)
widget_control, output_text_uname_id, get_value=output_file_name

;retrieve format 
output_format_id = widget_info(event.top,find_by_uname=output_format_uname)
widget_control, output_format_id, get_value=output_format

if (type eq 'data') then begin ;binary/ASCII or ASCII/XML
    case output_format of
        0: begin ;binary
            output_binary_data, event, data_type, output_text_uname, 'unix'
        end
        1: begin ;ASCII
            output_ascii_data, data_type, output_text_uname
        end
    endcase
endif else begin ;ASCII or XML
    case output_format of
        0: begin ;ASCII
            output_ascii_data, data_type, output_text_uname
        end
        1: begin ;XML
            output_xml_data, data_type, output_text_uname
        end
    endcase
endelse

end




;computer = 'unix'
pro output_binary_data, event, data_type, output_text_uname, computer

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

case data_type of 
    'event': begin
        ;copy event_file if event file
        
    end
    'histogram': begin
        
    end
    'timebins': begin

    end
    'pulseid': begin

    end
endcase
end




pro working_path_eventcb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

working_path = (*global).working_path
working_path = dialog_pickfile(path=working_path,/directory)

text = 'Output path is: ' + working_path
working_path_text_id = widget_info(event.top,find_by_uname='working_path_text')
widget_control, working_path_text_id, set_value=text

end



pro exit_button_eventcb, Event
widget_control,Event.top,/destroy
end
