function get_ucams

cmd_pwd = "pwd"
spawn, cmd_pwd, listening
print, "listening is: ", listening
array_listening=strsplit(listening,'/',count=length,/extract)
ucams = array_listening[2]
return, ucams
end





FUNCTION get_name_of_tmp_output_file, Event, tmp_working_path, instr

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

run_number = (*global).run_number

(*global).nexus_file_name_only = instr + "_" + $
  strcompress(run_number,/remove_all) + $
  ".nxs"

tmp_output_file_name = tmp_working_path
tmp_output_file_name += instr + "_" + strcompress(run_number,/remove_all)
tmp_output_file_name += "_neutron_histo_mapped.dat"

return, tmp_output_file_name

end




FUNCTION find_full_nexus_name, Event, run_number, instrument    

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -i" + instrument + " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name

;check if nexus exists
result = strmatch(full_nexus_name,"ERROR*")

if (result GE 1) then begin
    find_nexus = 0
endif else begin
    find_nexus = 1
endelse

(*global).find_nexus = find_nexus

return, full_nexus_name

end









function check_access, Event, instrument, ucams

list_of_instrument = ['REF_L', 'REF_M']

;0:j35:jean / 1:pf9:pete / 2:2zr:michael / 3:mid:steve / 4:1qg:rick / 5:ha9:haile / 6:vyi:frank / 7:vuk:john 
;8:x4t:xiadong / 9:ele:eugene
list_of_ucams = ['j35','pf9','2zr','mid','1qg','ha9','vyi','vuk','x4t','ele']

;check if ucams is in the list
ucams_index=-1
for i =0, 9 do begin
   if (ucams EQ list_of_ucams[i]) then begin
     ucams_index = i
     break 
   endif
endfor

;check if user is autorized for this instrument
CASE instrument OF		
   ;REF_L
   0: CASE  ucams_index OF
        -1:
	0: 		;authorized
	1: 		;authorized
	2: 		;authorized
	3: 		;authorized
	4: ucams_index=-1	;unauthorized
	5: ucams_index=-1	;unauthorized
	6: ucams_index=-1	;unauthorized
	7: 		;authorized
	8: 		;authorized
	9: ucams_index=-1	;unauthorized
      ENDCASE
   ;REF_M
   1: CASE ucams_index OF
	-1:
	0: 
	1: 
	2: 
	3: 
	4: 
	5: 
	6: 
	7: ucams_index=-1
	8: ucams_index=-1
	9: ucams_index=-1
      ENDCASE
ENDCASE	 
	
RETURN, ucams_index
 
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


;main_realize of the front door interface (instrument selection)
pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/DataReduction/data_reduction_gui_logo.bmp"
id = widget_info(wWidget,find_by_uname="logo_message_draw")
WIDGET_CONTROL, id, GET_VALUE=id_value
wset, id_value
image = read_bmp(image_logo)
tv, image,0,0,/true

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;main_realize of main data_reduction display
pro MAIN_REALIZE_data_reduction, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






; \brief Empty stub procedure used for autoloading.
;
pro data_reduction_eventcb
end


pro wTLB_REALIZE, wWidget
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end



;OPEN NEXUS FILE
pro open_nexus_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;retrieve run_number
id_run_number = widget_info(Event.top, FIND_BY_UNAME='nexus_run_number_box')
widget_control, id_run_number, get_value=run_number

;erase all displays
erase_displays, Event

if (run_number EQ '') then begin

    text = "!!! Please specify a run number !!! " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text
    
endif else begin
    
    (*global).run_number = run_number
    
    text = "Searching for NeXus file of run number " + strcompress(run_number,/remove_all)
    text += "..."
    WIDGET_CONTROL, full_view_info, SET_VALUE=text
    text = "Openning/plotting Run # " + strcompress(run_number,/remove_all) + "..."
    WIDGET_CONTROL, view_info, SET_VALUE=text

;get path to nexus run #
    instrument=(*global).instrument
    full_nexus_name = find_full_nexus_name(Event, run_number, instrument)
    
;check result of search
    find_nexus = (*global).find_nexus
    if (find_nexus EQ 0) then begin
        text_nexus = "Warning! NeXus file does not exist"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
        WIDGET_CONTROL, full_view_info, SET_VALUE=text_nexus,/append
    endif else begin
        text_nexus = "NeXus file has been localized: "
        (*global).full_nexus_name = full_nexus_name
        text_nexus += full_nexus_name
        WIDGET_CONTROL, full_view_info, SET_VALUE=text_nexus,/append
        
;dump binary data of NeXus file into tmp_working_path
        text = " - dump binary data......."
        WIDGET_CONTROL, full_view_info, SET_VALUE=text,/append
        dump_binary_data, Event, full_nexus_name
        text = " - dump binary data.......done" 
        WIDGET_CONTROL, full_view_info, SET_VALUE=text,/append

;read and plot nexus file
        read_and_plot_nexus_file, Event
    endelse
    
endelse

end




pro erase_displays, Event

id_draw = widget_info(Event.top, find_by_uname='display_data_base')
widget_control, id_draw, get_value=id_value
wset,id_value
erase

end


PRO dump_binary_data, Event, full_nexus_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;create tmp_working_path
;get global structure
tmp_working_path = (*global).tmp_working_path
tmp_working_path += "_" + (*global).instrument + "/"

tmp_folder = (*global).output_path + tmp_working_path
cmd_create = "mkdir " + tmp_folder

text= " [ " + cmd_create + "..."
widget_control, full_view_info, set_value=text, /append
spawn, cmd_create
text= "   ...done ]"
widget_control, full_view_info, set_value=text, /append

cmd_dump = "nxdir " + full_nexus_name
cmd_dump += " -p /entry/bank1/data/ --dump "

;get tmp_output_file_name
instr=(*global).instrument
tmp_output_file_name = get_name_of_tmp_output_file(Event, tmp_folder, instr)
cmd_dump += tmp_output_file_name

(*global).full_histo_mapped_name = tmp_output_file_name

;display command
text= " [ " + cmd_dump + "..."
widget_control, full_view_info, set_value=text, /append
spawn, cmd_dump, listening

;display result of command
;text= listening
text= "   ...done ]"
widget_control, full_view_info, set_value=text, /append

end




;--------------------------------------------------------------------------
; \brief
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro read_and_plot_nexus_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;;first close previous file if there is one
;if (N_ELEMENTS(U)) NE 0 then begin
;    close, u
;    free_lun,u
;endif 

;retrieve data parameters
Nx = (*global).Nx
Ny = (*global).Ny

;indicate reading data with hourglass icon
widget_control,/hourglass

file = (*global).full_histo_mapped_name
nexus_file_name_only = (*global).nexus_file_name_only

full_view_info = widget_info(Event.top, find_by_uname='log_book_text')
text = " - plot NeXus file: " + nexus_file_name_only + "..."
WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND

;determine path	
path = (*global).tmp_folder
cd, path
        
WIDGET_CONTROL, full_view_info, SET_VALUE=' [ - reading in data...', /APPEND
strtime = systime(1)

openr,u,file,/get
;find out file info
fs = fstat(u)
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)
(*global).Ntof = Ntof           ;set back in global structure

data_assoc_tof = assoc(u,lonarr(Ntof,Nx))
data_assoc = assoc(u,lonarr(Ntof))

;make the image array
img = lonarr(Nx,Ny)
for i=0L,Nimg-1 do begin
    x = i MOD Nx   ;Nx=304
    y = i/Nx
    img[x,y] = total(data_assoc[i])
endfor			

img=transpose(img)

;load data up in global ptr array
(*(*global).img_ptr) = img
(*(*global).data_assoc) = data_assoc
	
;now turn hourglass back off
widget_control,hourglass=0

if (*global).pass EQ 0 then begin
;load the default color table on first pass thru SHOW_DATA
    loadct,(*global).ct
    (*global).pass = 1          ;clear the flag...
endif

;put image data in main draw window
id_draw = widget_info(Event.top, find_by_uname='display_data_base')
widget_control, id_draw, get_value=id_value
wset,id_value
tvscl,img

endtime = systime(1)
tt_time = string(endtime - strtime)
text = 'Done in ' + strcompress(tt_time,/remove_all) + ' s'
WIDGET_CONTROL, full_view_info, SET_VALUE=text, /APPEND
	
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
text = "...Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


pro EXIT_PROGRAM_REF_L, Event

widget_control,Event.top,/destroy

end






pro CTOOL_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;xloadct,/MODAL,GROUP=id
xloadct,/modal,group=id

SHOW_DATA_REF_L,event

end





pro SHOW_DATA_REF_L,event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get window numbers
id_draw = widget_info(Event.top, find_by_uname='display_data_base')
WIDGET_CONTROL, id_draw, GET_VALUE = id

;Decomposed=0 causes the least-significant 8 bits of the color index value
	;to be interpreted as a PseudoColor index.
DEVICE, DECOMPOSED = 0

wset, id
erase
tvscl,(*(*global).img_ptr)
print, "I'm here"

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



