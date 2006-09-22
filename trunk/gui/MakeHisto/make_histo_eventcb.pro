pro open_plot_data_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve data parameters
Ny = (*global).Nx_REF_L
Nx = (*global).Ny_REF_L

;indicate reading data with hourglass icon
widget_control,/hourglass

;file to open
file = (*global).histo_event_filename

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
	y = i MOD Ny
	x = i/Ny
	img[x,y] = total(data_assoc[i])
   endfor

   img=transpose(img)

   ;load data up in global ptr array
   (*(*global).img_ptr) = img
   (*(*global).data_assoc) = data_assoc
	
   ;now turn hourglass back off
   widget_control,hourglass=0

   ;put image data in the display window
   id = widget_info(Event.top, FIND_BY_UNAME="DISPLAY_WINDOW")
   WIDGET_CONTROL, id, GET_VALUE = view_plot   
   wset,view_plot
   tvscl,img

   close, u
   free_lun, u
	
endif;valid file

end


pro DISPLAY_BUTTON, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global


instrument =  (*global).instrument

if (Event.select EQ 1) then begin 	;if button is pressed

   id=widget_info(Event.top,FIND_BY_UNAME="HISTOGRAM_STATUS")
   text = "Plotting......"
   widget_control, id, set_value = text, /append 

   ;plot data according to instrument type

   case instrument of

   
      "REF_L": begin
		  (*global).xsize_display = (*global).xsize_dislay_REF_L
		  id = widget_info(Event.top, find_by_uname="MAIN_BASE")
		  widget_control, id, scr_xsize=(*global).xsize_display

		  id1 = widget_info(Event.top, find_by_uname="DISPLAY_WINDOW")
		  widget_control, id1, scr_xsize=(*global).NX_REF_L
		  widget_control, id1, scr_ysize=(*global).NY_REF_L

		  open_plot_data_REF_L, event
	       end
      "REF_M": begin
	 	 (*global).xsize_display = (*global).xsize_display_REF_M
	      	 open_plot_data_REF_M, event      
	       end
      "BSS"  : begin
		 (*global).xsize_display = (*global).xsize_display_BSS
                 open_plot_data_BSS, event
	       end
   endcase

   id=widget_info(Event.top,FIND_BY_UNAME="HISTOGRAM_STATUS")
   text = "done"
   widget_control, id, set_value = text, /append 
  
endif else begin			;if button released

   id = widget_info(Event.top, find_by_uname="MAIN_BASE")
   widget_control, id, scr_xsize=(*global).xsize

endelse


end







pro open_plot_data_REF_M, Event


end





pro open_plot_data_BSS, Event

end






pro CLOSE_COMPLETE_XML_DISPLAY_TEXT_event, Event

print, "in close_complete....."

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize

end


pro COMPLETE_RUNINFO_FILE_event, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument =  (*global).instrument

id = widget_info(Event.top, find_by_uname="MAIN_BASE")
widget_control, id, scr_ysize=(*global).ysize_display
   
cmd = "less " + (*global).runinfo_xml_filename
spawn, cmd, listening
  
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
spawn, cmd, listening
  
id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_XML_DISPLAY_TEXT")
widget_control, id, set_value = listening

end



;____________________________________________________________________________________

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



;---------------------------------------------------------------------------------
pro USER_TEXT_cb, Event   ;for REF_M

view_id = widget_info(Event.top,FIND_BY_UNAME='LEFT_TOP_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='RIGHT_TOP_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='LEFT_BOTTOM_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='RIGHT_BOTTOM_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




function check_access, Event, instrument, user

list_of_instrument = ['REF_L', 'REF_M', 'BSS']

;0:j35:jean / 1:pf9:pete / 2:2zr:michael / 3:mid:steve / 4:1qg:rick / 5:ha9:haile / 6:vyi:frank / 7:vuk:john 
;8:x4t:xiadong / 9:ele:eugene
list_of_users = ['j35','pf9','2zr','mid','1qg','ha9','vyi','vuk','x4t','ele']

;check if ucams is in the list
user_index=-1
for i =0, 9 do begin
   if (user EQ list_of_users[i]) then begin
     user_index = i
     break 
   endif
endfor

;check if user is autorized for this instrument
CASE instrument OF		
   ;REF_L
   0: CASE user_index OF
        -1:
	0: 		;authorized
	1: 		;authorized
	2: 		;authorized
	3: 		;authorized
	4: user_index=-1	;unauthorized
	5: user_index=-1	;unauthorized
	6: user_index=-1	;unauthorized
	7: 		;authorized
	8: 		;authorized
	9: user_index=-1	;unauthorized
      ENDCASE
   ;REF_M
   1: CASE user_index OF
	-1:
	0: 
	1: 
	2: 
	3: 
	4: 
	5: 
	6: 
	7: user_index=-1
	8: user_index=-1
	9: user_index=-1
      ENDCASE
   ;BSS
   2: CASE user_index OF
	-1:
	0: 
	1: 
	2: 
	3: 
	4: user_index=-1
	5: user_index=-1
	6: user_index=-1
	7: user_index=-1
	8: user_index=-1
	9: 
      ENDCASE
ENDCASE	 
	
RETURN, user_index

end


;------------------------------------------------------------------------------------------
; \brief function to obtain the top level base widget given an arbitrary widget ID.
;
; \argument wWidget (INPUT)
;------------------------------------------------------------------------------------------
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





;--------------------------------------------------------------------------------
; \brief main function that plot the window
;
; \argument wWidget (INPUT) 
;--------------------------------------------------------------------------------
pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



; \brief Empty stub procedure used for autoloading.
;
pro make_histo_eventcb
end

pro REBINNING_TYPE_GROUP_CP, Event

id = widget_info(Event.top, FIND_BY_UNAME='REBINNING_TYPE_GROUP')
WIDGET_CONTROL, id, GET_VALUE = value

if (value EQ 1) then begin
	WIDGET_CONTROL, id, SET_VALUE=0
	view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
	text = "!!!Logarithmic rebinning not supported yet!!!"
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
endif	
	

end

pro OPEN_HISTO_EVENT_FILE_CB, event

;indicate reading data with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

rb_id=widget_info(Event.top, FIND_BY_UNAME='CREATE_NEXUS')
widget_control,rb_id,sensitive=0

;open file
filter = (*global).filter_histo_event

;use first statement on mac, second one on heater...
if (!cpu.hw_vector EQ 0) then begin
   path = "/"+(*global).instrument+"-DAS-FS/"
endif else begin
   path = (*global).path				
endelse

file = dialog_pickfile(path=path,get_path=path,title='Select input file',filter=filter)

;only read data if valid file given
if file NE '' then begin

	(*global).histo_event_filename = file ; store input filename
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
	text = "File selected: "
	WIDGET_CONTROL, view_info, SET_VALUE=text
	text = strcompress(file,/remove_all)
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;get only the last part of the file (its name)
	file_list=strsplit(file,'/',/extract,count=length)     ;to get only the last part of the name
	filename_only=file_list[length-1]	
	(*global).histo_event_filename_only = filename_only    ;store only name of the file (without the path)

	;check if histo or event file
	print, "filename_only= " , filename_only
	is_file_histo = strmatch(filename_only,'*histo*')       ;1: yes        0: no

	(*global).das_mount_point = file_list[0]
	;print, "das_mount_point= ", das_mount_point

	proposal_number = file_list[1]
	(*global).proposal_number = proposal_number
	;print, "proposal_number= ", proposal_number

	instrument_run_number = file_list[2]
	(*global).instrument_run_number = instrument_run_number
	;print, "instrument_run_number= ", instrument_run_number
		
	instrument = (*global).instrument
	run_number = strsplit(instrument_run_number,instrument,/extract)
	(*global).run_number = run_number
	;print, "run_number is ", run_number

	view_info = widget_info(Event.top,FIND_BY_UNAME='HISTO_EVENT_FILE_LABEL_tab1')
	WIDGET_CONTROL, view_info, SET_VALUE=filename_only

	;determine path	
	path_list=strsplit(file,filename_only,/reg,/extract)
	path=path_list[0]
	cd, path
	(*global).path = path

	;display path
	view_info = widget_info(Event.top,FIND_BY_UNAME='DEFAULT_FINAL_PATH_tab2')
	WIDGET_CONTROL, view_info, SET_VALUE=path

	;###########################################
	;for BSS   -> BSS-DAS-FS
	;for REF_L -> REF_L-DAS-FS
	;for REF_M -> REF_M-DAS-FS
	;ex: /BSS-DAS-FS/2006_1_2_SCI/BSS_23/....
	;###########################################

	;location where to look for run already archived or not
	archive_run_number_location = "/SNS/" + instrument + "/" + proposal_number + "/" + run_number
	command = "ls -d " + archive_run_number_location	
	spawn, command, listening ;listening ="" when not found

	id=widget_info(Event.top,FIND_BY_UNAME='ARCHIVE_LABEL')
	;check if file has already been archived, if no, show archive or not label box
	if (listening EQ '') then begin
	   WIDGET_CONTROL, id, map=0
	endif else begin	;if yes, do the following one
 	   WIDGET_CONTROL, id, map=1
	   WIDGET_CONTROL, id, SET_VALUE= '** ALREADY ARCHIVED **'
	endelse

	;get info from xml files that go with histo/event file
	;determine name of xml file (cvinfo)	

	general_xml_filename = path + instrument + "_" + run_number + "_"
	cvinfo_xml_filename = general_xml_filename + "cvinfo.xml"
	runinfo_xml_filename = general_xml_filename + "runinfo.xml"
	
	runinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_RUNINFO_FILE")
	widget_control, runinfo_id, sensitive=1

	cvinfo_id = widget_info(Event.top, FIND_BY_UNAME="COMPLETE_CVINFO_FILE")
	widget_control, cvinfo_id, sensitive=1

	(*global).cvinfo_xml_filename = cvinfo_xml_filename
	(*global).runinfo_xml_filename = runinfo_xml_filename

	;name of xml file
	id = widget_info(Event.top, FIND_BY_UNAME = "XML_FILE_TEXT")
	text = runinfo_xml_filename
	widget_control, id, set_value=text	

	;Title
	id = widget_info(Event.top, FIND_BY_UNAME = "TITLE_TEXT")
	text = read_xml_file(runinfo_xml_filename, "Title")
	widget_control, id, set_value=text
	
	;Notes
	id = widget_info(Event.top, FIND_BY_UNAME = "NOTES_TEXT")
	text = read_xml_file(runinfo_xml_filename, "Notes")
	widget_control, id, set_value=text

	;SpecialDesignation
	id = widget_info(Event.top, FIND_BY_UNAME = "SPECIAL_DESIGNATION")
	text = read_xml_file(runinfo_xml_filename, "SpecialDesignation")
	widget_control, id, set_value=text

	;Script ID
	id = widget_info(Event.top, FIND_BY_UNAME = "SCRIPT_ID_TEXT")
	text = read_xml_file(runinfo_xml_filename, "SCRIPTID")
	widget_control, id, set_value=text

	;if file is an event file, we activate the  "GO_HISTOGRAM" part
	if (is_file_histo NE 1) then begin

	   id = widget_info(Event.top, FIND_BY_UNAME="HISTO_INFO_BASE")
	   widget_control, id, map=0

	   ;get number of pixels
	   pixel_number = read_xml_file(runinfo_xml_filename, "MaxScatPixelID")
	   id = widget_info(Event.top, FIND_BY_UNAME="NUMBER_PIXELIDS_TEXT_tab1")
	   widget_control, id, set_value=pixel_number	

	   item_value = display_xml_info(runinfo_xml_filename, "startbin")
	   id = widget_info(Event.top, FIND_BY_UNAME="MIN_TIME_BIN_TEXT_wT1")
	   widget_control, id, set_value=item_value

	   item_value = display_xml_info(runinfo_xml_filename, "endbin")
	   id = widget_info(Event.top, FIND_BY_UNAME="MAX_TIME_BIN_TEXT_wT1")
	   widget_control, id, set_value=item_value
	
	   id = widget_info(Event.top, FIND_BY_UNAME="HIDE_HISTO_BASE")
	   widget_control, id, map=0

	   ;desactivate display button
	   id_display = widget_info(Event.top, FIND_BY_UNAME="DISPLAY_BUTTON")
	   widget_control, id_display, sensitive=0

 	endif else begin   ;if file is an histogram
	
	   ;get number of pixels and number of tof from file

	   case (*global).instrument of
	      "REF_L": 	begin
			   Nimg = (*global).Nimg_REF_L
			end
	      "REF_M": 	begin
			   Nimg = (*gloabl).Nimg_REF_M
			end
	      "BSS": 	Nimg = (*global).Nimg_BSs
	   endcase

           openr,u,file,/get
           ;find out file info
           fs = fstat(u)
           Ntof = fs.size/(Nimg*4L)
 	   close, u
	   free_lun, u

	   id = widget_info(Event.top, FIND_BY_UNAME = "HISTO_INFO_NUMBER_PIXELIDS_TEXT")
	   widget_control, id, set_value = strcompress(Nimg,/remove_all)

	   id = widget_info(Event.top, FIND_BY_UNAME = "HISTO_INFO_NUMBER_BINS_TEXT")
	   widget_control, id, set_value = strcompress(NTOF,/remove_all)

	   ;activate histo_file_infos main_base
	   id = widget_info(Event.top, FIND_BY_UNAME="HIDE_HISTO_BASE")
	   widget_control, id, map=1

	   ;hide event file interaction box
	   id = widget_info(Event.top, FIND_BY_UNAME="HISTO_INFO_BASE")
	   widget_control, id, map=1
		
	   ;activate display button
	   id_display = widget_info(Event.top, FIND_BY_UNAME="DISPLAY_BUTTON")
	   widget_control, id_display, sensitive=1

	endelse
	
  endif

;activate GO_NEXUS button
rb_id=widget_info(Event.top, FIND_BY_UNAME='CREATE_NEXUS')
widget_control,rb_id,sensitive=1

end

pro NUMBER_PIXEL_IDS_CB, event
print,'NUMBER_PIXEL_IDS_CB'
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers

end

pro REBINNING_TEXT_CB, event
print,'REBINNING_TEXT_CB'
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers

end

pro MAX_TIME_BIN_TEXT_CB, event
print,'MAX_TIME_BIN_TEXT_CB'
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers

end

pro  OPEN_MAPPING_FILE_BUTTON_CB, event

;indicate reading data with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;open file
filter = (*global).filter_mapping
path = (*global).path_mapping
file = dialog_pickfile(path=path,get_path=path,title='Select mapping file',filter=filter)

;only read data if valid file given
if file NE '' then begin

	(*global).mapping_filename = file ; store input filename
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
	text = "Mapping file selected: "
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	text = strcompress(file,/remove_all)
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;display path
	view_info = widget_info(Event.top,FIND_BY_UNAME='MAPPING_FILE_LABEL_tab1')
	WIDGET_CONTROL, view_info, SET_VALUE=path

  endif

print,'OPEN_MAPPING_FILE_BUTTON_CB'

end

pro  DEFAULT_PATH_BUTTON_CB, event
print,'DEFAULT_PATH_BUTTON_CB'

end

pro  GO_HISTOGRAM_CB, event

wWidget = event.top

;get the global data structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

txt = "*** HISTOGRAMMING ***"
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=txt, /APPEND

;in GO_HISTOGRAM, we need to get widget values of tab 1 to do our work

id_0 = Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TYPE_GROUP')
	WIDGET_CONTROL, id_0, GET_VALUE = lin_log

id_1 = Widget_Info(wWidget, FIND_BY_UNAME='NUMBER_PIXEL_IDS')
	WIDGET_CONTROL, id_1, GET_VALUE =number_pixels

id_2 = Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TEXT')
	WIDGET_CONTROL, id_2, GET_VALUE =rebinning_text

id_3 = Widget_Info(wWidget, FIND_BY_UNAME='MAX_TIME_BIN_TEXT')
	WIDGET_CONTROL, id_3, GET_VALUE =max_time_bin

(*global).lin_log = lin_log
(*global).number_pixels = number_pixels
(*global).rebinning = rebinning_text
(*global).max_time_bin = max_time_bin

event_filename = (*global).event_filename
path = (*global).path

cmd_line = "Event_to_Histo "
cmd_line += "-l " + strcompress(rebinning_text,/remove_all)
cmd_line += " -M " + strcompress(max_time_bin,/remove_all)
cmd_line += " -p " + strcompress(number_pixels,/remove_all)
cmd_line += " " + event_filename

cmd_line_displayed = "> " + cmd_line

WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch histogramming
str_time = systime(1)
text = "Processing....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;determine name of histo file
event_filename = (*global).event_filename
file_list=strsplit(event_filename,'event.dat$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
histo_filename = filename_short + 'histo.dat'
(*global).histo_filename = histo_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = histo_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

rb_id=widget_info(Event.top, FIND_BY_UNAME='CREATE_NEXUS')
widget_control,rb_id,sensitive=1

end

pro CREATE_NEXUS_CB, event

wWidget = event.top

;activate GO_NEXUS button
rb_id=widget_info(Event.top, FIND_BY_UNAME='CREATE_NEXUS')
widget_control,rb_id,sensitive=0

;get the global data structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

txt = "*** TRANSLATION SERVICE ***"
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=txt, /APPEND

;retrieve constant
number_pixels = (*global).number_pixels
rebinning_text = (*global).rebinning
max_time_bin = (*global).max_time_bin
number_tbin = max_time_bin / rebinning_text
mapping_filename = (*global).mapping_filename
histo_filename = (*global).histo_filename
path = (*global).path

cmd_line = "Map_Data "
cmd_line += "-m " + mapping_filename
cmd_line += " -n " + histo_filename
cmd_line += " -p " + strcompress(number_pixels, /remove_all)
cmd_line += " -t " + strcompress(number_tbin, /remove_all)

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch mapping
str_time = systime(1)
text = "Processing mapping....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;determine name of histo_mapped file
file_list=strsplit(histo_filename,'histo.dat$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
histo_mapped_filename = filename_short + 'histo_mapped.dat'
(*global).histo_mapped_filename = histo_mapped_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = histo_mapped_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;making translation file now
translation_filename = (*global).translation_filename
cmd_line = "TS_merge_preNeXus.sh "
cmd_line += translation_filename

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch merging
str_time = systime(1)
text = "Processing merging....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;determine name of merge file
file_list=strsplit(histo_filename,'_neutron_histo.dat$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
new_translation_filename = filename_short + '.nxt'
(*global).new_translation_filename = new_translation_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = new_translation_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND


;making NeXus file now
new_translation_filename = (*global).new_translation_filename
cmd_line = "nxtranslate "
cmd_line += new_translation_filename

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch translation
str_time = systime(1)
text = "Processing translation....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;determine name of nexus file
file_list=strsplit(new_translation_filename,'t$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
nexus_filename = filename_short + 's'
(*global).nexus_filename = nexus_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = nexus_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end


pro  tmp1, event

end


pro wTLB_REALIZE, wWidget

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end



