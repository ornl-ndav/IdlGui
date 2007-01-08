;this function reorder two numbers
function  reorder, x1, x2, y1, y2 

X=[x1,x2]
xmin = min(X, max=xmax)

Y=[y1,y2]
ymin = min(Y, max=ymax)

return, [xmin, xmax, ymin, ymax]
end




;Create the output array for signal selection
pro create_signal_pid_array_file, XY, file_name

xmin = XY[0]
xmax = XY[1]
ymin = XY[2]
ymax = XY[3]

openw, 1, file_name

i=0
for x=xmin, xmax do begin
    for y=ymin, ymax do begin
        text = '1_' + strcompress(x,/remove_all)
        text += '_' + strcompress(y,/remove_all)
        printf, 1,text
        ++i
    endfor
endfor

close, 1
free_lun, 1

end







;Create the output array for background selection
pro create_background_pid_array_file, XYsignal, XYbackground, file_name

xmin_signal = XYsignal[0]
xmax_signal = XYsignal[1]
ymin_signal = XYsignal[2]
ymax_signal = XYsignal[3]

xmin_back = XYbackground[0]
xmax_back = XYbackground[1]
ymin_back = XYbackground[2]
ymax_back = XYbackground[3]

openw, 1, file_name

i=0
for x=xmin_back, xmax_back do begin
    for y=ymin_back, ymax_back do begin
        if (x GE xmin_signal AND $
            x LE xmax_signal AND $
            y GE ymin_signal AND $
            y LE ymax_signal) then begin
            ;pass
        endif else begin
            text = '1_' + strcompress(x,/remove_all)
            text += '_' + strcompress(y,/remove_all)
            printf, 1,text
            ++i
        endelse
    endfor
endfor

close, 1
free_lun, 1

end









function get_signal_background_pid_file_name, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_folder = (*global).tmp_folder
pid_file_extension = (*global).pid_file_extension
first_part = tmp_folder + (*global).instrument
first_part += "_" + (*global).run_number

signal_pid_file_name = first_part + "_signal_" + pid_file_extension
background_pid_file_name = first_part + "_background_" + pid_file_extension

signal_background_pid_file_names = [signal_pid_file_name,$
                                    background_pid_file_name]

return, signal_background_pid_file_names
end






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

;reset file_opened
(*global).file_opened = 0

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;retrieve run_number
id_run_number = widget_info(Event.top, FIND_BY_UNAME='nexus_run_number_box')
widget_control, id_run_number, get_value=run_number

;erase all displays
reset_and_erase_displays, Event    

if (run_number EQ '') then begin

    text = "!!! Please specify a run number !!! " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text
    widget_control, full_view_info, set_value=text
    
endif else begin
    
;indicate reading data with hourglass icon
    widget_control,/hourglass

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
        read_and_plot_nexus_file, Event         ;remove_comments

;tell the program that data are displayed
        (*global).file_opened = 1

    endelse
    
endelse

end




pro reset_and_erase_displays, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).selection_signal = 0
(*global).selection_background = 0

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
(*global).tmp_folder = tmp_folder
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
	
DEVICE, DECOMPOSED = 0
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

;now turn hourglass back off
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$








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
tvscl,(*(*global).img_ptr)

selection_value = (*global).selection_value
selection_signal = (*global).selection_signal
selection_background = (*global).selection_background
selection_background_2 = (*global).selection_background_2

if (selection_value EQ 0) then begin

    if (selection_background EQ 1) then begin
    
        color_line = (*global).color_line_background
        
        x1 = (*global).x1_back
        x2 = (*global).x2_back
        y1 = (*global).y1_back
        y2 = (*global).y2_back
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

    if (selection_background_2 EQ 1) then begin

        color_line = (*global).color_line_background_2

        x1 = (*global).x1_back_2
        x2 = (*global).x2_back_2
        y1 = (*global).y1_back_2
        y2 = (*global).y2_back_2
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line

    endif

endif

if (selection_value EQ 1) then begin

    if (selection_signal EQ 1) then begin
    
        color_line = (*global).color_line_signal
        
        x1 = (*global).x1_signal
        x2 = (*global).x2_signal
        y1 = (*global).y1_signal
        y2 = (*global).y2_signal
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

    if (selection_background_2 EQ 1) then begin

        color_line = (*global).color_line_background_2

        x1 = (*global).x1_back_2
        x2 = (*global).x2_back_2
        y1 = (*global).y1_back_2
        y2 = (*global).y2_back_2
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line

    endif

endif

if (selection_value EQ 2) then begin

    if (selection_background EQ 1) then begin
    
        color_line = (*global).color_line_background
        
        x1 = (*global).x1_back
        x2 = (*global).x2_back
        y1 = (*global).y1_back
        y2 = (*global).y2_back
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

    if (selection_signal EQ 1) then begin
    
        color_line = (*global).color_line_signal
        
        x1 = (*global).x1_signal
        x2 = (*global).x2_signal
        y1 = (*global).y1_signal
        y2 = (*global).y2_signal
        
        plots, X1, Y1, /device, color=color_line
        plots, X1, Y2, /device, /continue, color=color_line
        plots, X2, Y2, /device, /continue, color=color_line
        plots, X2, Y1, /device, /continue, color=color_line
        plots, X1, Y1, /device, /continue, color=color_line
        
    endif 

endif

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





pro selection_list_group_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, FIND_BY_UNAME='selection_list_group')
WIDGET_CONTROL, id, GET_VALUE = value

(*global).selection_value = value

end







;--------------------------------------------------------------------------
; \brief 
;
; \argument event (INPUT) 
;--------------------------------------------------------------------------
pro selection, event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file_opened = (*global).file_opened

view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

;working on signal or background ? (0 for signal, 1 for background_1
;and 2 for background_2)
signal_or_background = (*global).selection_value

;left mouse button
IF ((event.press EQ 1) AND (file_opened EQ 1)) then begin
    
                                ;get data
    img = (*(*global).img_ptr)
                                ;data = (*(*global).data_ptr)
    tmp_tof = (*(*global).data_assoc)
    Nx = (*global).Nx
    
    x = Event.x
    y = Event.y
                                    ;set data
    
    text = " x= " + strcompress(x,/remove_all)
    text += " y= " + strcompress(y,/remove_all)
    
;put number of counts in number_of_counts label position
    text += " counts= " + strcompress(img(x,y))
    full_text = "PixelID infos : " + text
    widget_control, view_info, set_value=text, /append
    widget_control, full_view_info, set_value=full_text, /append
endif

;right mouse button
IF ((event.press EQ 4) AND (file_opened EQ 1)) then begin
    
                                ;get window numbers
    id_draw = widget_info(Event.top, find_by_uname='display_data_base')
    WIDGET_CONTROL, id_draw, GET_VALUE = id
    wset, id
    
                                ;from the rubber_band program
    getvals = 0 ;while getvals is GT 0, continue to check mouse down clicks
    
                                ;continue to loop getting values while mouse clicks occur within the image window
    
    Nx = (*global).Nx
    Ny = (*global).Ny
;   window_counter = (*global).window_counter
    
    x = lonarr(2)
    y = lonarr(2)
    
    first_round=0
    
    cursor, x,y,/down,/device
    display_info =0	
    click_outside = 0
    
    while (getvals EQ 0) do begin
        
        cursor,x,y,/nowait,/device
        
        if ((x LT 0) OR (x GT Ny) OR (y LT 0) OR (y GT Nx)) then begin
            
            click_outside = 1
            getvals = 1
            
        endif else begin
            
            if (first_round EQ 0) then begin
                
                X1=x
                Y1=y
                
                if (signal_or_background EQ 0) then begin
                    
                    (*global).x1_signal = x
                    (*global).y1_signal = y
                    
                endif 
                    
                if (signal_or_background EQ 1) then begin
                    
                    (*global).x1_back = x
                    (*global).y1_back = y
                        
                endif 
                      
                if (signal_or_background EQ 2) then begin

                    (*global).x1_back_2 = x
                    (*global).y1_back_2 = y
                        
                endif
                    
                id_save_selection = widget_info(Event.top, find_by_uname='clear_selection_button')
                widget_control, id_save_selection, sensitive=1
                
                first_round = 1
                text = " Rigth click to select other corner"		
                
            endif else begin
                
                X2=x
                Y2=y
                SHOW_DATA_REF_L,event
                
                if (signal_or_background EQ 0) then begin
                    color_line = (*global).color_line_signal
                    (*global).selection_signal = 1
                endif 
                
                if (signal_or_background EQ 1) then begin
                    color_line = (*global).color_line_background
                    (*global).selection_background = 1
                endif
                
                if (signal_or_background EQ 2) then begin
                    color_line = (*global).color_line_background_2
                    (*global).selection_background_2 = 1
                endif
                
;validate save_selection button if signal and background region are there
                
                if ((*global).selection_signal EQ 1 AND $
                    (*global).selection_background EQ 1 AND $
                    (*global).selection_background_2 EQ 1) then begin
                    id_save_selection = widget_info(Event.top, find_by_uname='save_selection_button')
                    widget_control, id_save_selection, sensitive=1
                endif
                
                plots, X1, Y1, /device, color=color_line
                plots, X1, Y2, /device, /continue, color=color_line
                plots, X2, Y2, /device, /continue, color=color_line
                plots, X2, Y1, /device, /continue, color=color_line
                plots, X1, Y1, /device, /continue, color=color_line
                
                if (signal_or_background EQ 0) then begin
                    
                    (*global).x2_signal = x
                    (*global).y2_signal = y
                    
                endif 
                
                if (signal_or_background EQ 1) then begin
                    
                    (*global).x2_back = x
                    (*global).y2_back = y
                    
                endif 
                        
                if (signal_or_background EQ 2) then begin      

                    (*global).x2_back_2 = x
                    (*global).y2_back_2 = y
                    
                endif    

                if (!mouse.button EQ 4) then begin ;stop the process
                    
                    getvals = 1
                    display_info = 1
                    
                endif
                
            endelse
            
        endelse
        
    endwhile
    
    if (click_outside EQ 1) then begin
        
;       if (display_info EQ 1) then begin
        
        x=lonarr(2)
        y=lonarr(2)
        
;        if ((*global).selection_signal EQ 1) then begin
            
            if (signal_or_background EQ 0) then begin

                x[0]=(*global).x1_signal
                x[1]=(*global).x2_signal
                y[0]=(*global).y1_signal
                y[1]=(*global).y2_signal
                
            endif 
        
            if (signal_or_background EQ 1) then begin
                
                x[0]=(*global).x1_back
                x[1]=(*global).x2_back
                y[0]=(*global).y1_back
                y[1]=(*global).y2_back
                
            endif
            
            if (signal_or_background EQ 2) then begin
    
                x[0]=(*global).x1_back_2
                x[1]=(*global).x2_back_2
                y[0]=(*global).y1_back_2
                y[1]=(*global).y2_back_2
                
            endif
            
                                ;*Initialization of text boxes
            full_text_selection_1 = ''
            full_text_selection_2 = 'The two corners are defined by:'
            
            y_min = min(y)
            y_max = max(y)
            x_min = min(x)
            x_max = max(x)
            
            y12 = y_max-y_min
            x12 = x_max-x_min
            total_pixel_inside = x12*y12
            total_pixel_outside = Nx*Ny - total_pixel_inside
            
            simg = (*(*global).img_ptr)
            
            starting_id = (y_min*304+x_min)
            starting_id_string = strcompress(starting_id)
;          (*global).starting_id_x = x_min
;          (*global).starting_id_y = y_min
            
            ending_id = (y_max*304+x_max)
            ending_id_string = strcompress(ending_id)
;          (*global).ending_id_x = x_max
;          (*global).ending_id_y = y_max
            
            full_text_selection_3 = '    Bottom left corner:  '
            full_text_selection_3_1 = '      pixelID#: ' + starting_id_string + $
              ' (x= '+strcompress(x_min,/rem) + $
              '; y= '+strcompress(y_min,/rem) + $
              ' intensity= ' + strcompress(simg[x_min,y_min],/rem)+')'
            
            full_text_selection_4 = '    Top right corner:  '
            full_text_selection_4_1 = '      pixelID#: ' + ending_id_string + $
              ' (x= '+strcompress(x_max,/rem) + $
              '; y= '+strcompress(y_max,/rem) + $
              ' intensity= ' + strcompress(simg[x_max,y_max],/rem)+')'
            
                                ;calculation of inside region total counts
            inside_total = total(simg(x_min:x_max, y_min:y_max))
            outside_total = total(simg)-inside_total
            inside_average = inside_total/total_pixel_inside
            outside_average = outside_total/total_pixel_outside
            
            full_text_selection_5 = ""
            full_text_selection_6 = 'General infos about selection: '
            full_text_selection_7 = "   - Number of pixelIDs inside the surface: " + $
              strcompress(x12*y12,/rem)
            full_text_selection_8 = "   - Selection width: " + strcompress(x12,/rem) + $
              ' pixels'
            full_text_selection_9 = "   - Selection height: " + strcompress(y12,/rem) + $
              ' pixels
            full_text_selection_10 = "   - Total inside selection counts: " + $
              strcompress(inside_total,/rem)
            full_text_selection_11 = ""
            full_text_selection_12 = "   - Total outside selection counts: " + $
              strcompress(outside_total,/rem)
            full_text_selection_13 = "   - Average inside selection counts: " + $
              strcompress(inside_average,/rem)
            full_text_selection_14 = "   - Average outside selection counts: " + $
              strcompress(outside_average,/rem) 
            
            value_group = [full_text_selection_2,$
                           full_text_selection_1,$
                           full_text_selection_3,$
                           full_text_selection_3_1,$
                           full_text_selection_4,$
                           full_text_selection_4_1,$
                           full_text_selection_5,$
                           full_text_selection_6,$
                           full_text_selection_1,$
                           full_text_selection_7,$
                           full_text_selection_8,$
                           full_text_selection_9,$
                           full_text_selection_10,$
                           full_text_selection_11,$
                           full_text_selection_12,$
                           full_text_selection_13,$
                           full_text_selection_14]
            
;check if selection is for signal of for background
            if (signal_or_background EQ 0) then begin
                view_info = widget_info(Event.top,FIND_BY_UNAME='signal_info')
                WIDGET_CONTROL, view_info, SET_VALUE=value_group
                    view_info_tab = widget_info(Event.top, find_by_uname='signal_tab_base')
                    widget_control, view_info_tab, base_set_title="Signal (white)"
            endif else begin
                if (signal_or_background EQ 1) then begin
                    view_info = widget_info(Event.top,FIND_BY_UNAME='background_info')
                    WIDGET_CONTROL, view_info, SET_VALUE=value_group
                    view_info_tab = widget_info(Event.top, find_by_uname='background_1_tab_base')
                    widget_control, view_info_tab, base_set_title="Background #1 (blue)"
                endif else begin
                    view_info = widget_info(Event.top,FIND_BY_UNAME='background_2_info')
                    WIDGET_CONTROL, view_info, SET_VALUE=value_group
                    view_info_tab = widget_info(Event.top, find_by_uname='background_2_tab_base')
                    widget_control, view_info_tab, base_set_title="Background #2 (red)"
                endelse
                
            endelse        
            
;        endif
        
    endif else begin
        
    endelse
    
endif

end






pro clear_selection_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

value = (*global).selection_value

if (value EQ 0) then begin
    (*global).selection_signal = 0
    text = "Clear signal selection"
    full_text = "Clear signal selection"
    selection_info = widget_info(Event.top,FIND_BY_UNAME='signal_info')
    view_info_tab = widget_info(Event.top, find_by_uname='signal_tab_base')
endif else begin
    if (value EQ 1) then begin
        (*global).selection_background = 0 
        text = "Clear background selection"
        full_text = "Clear background selection"
        selection_info = widget_info(Event.top,FIND_BY_UNAME='background_info')
        view_info_tab = widget_info(Event.top, find_by_uname='background_1_tab_base')
    endif else begin
        (*global).selection_background_2 = 0
        text = "Clear background selection #2"
        full_text = "Clear background selection #2"
        selection_info = widget_info(Event.top,FIND_BY_UNAME='background_2_info')
        view_info_tab = widget_info(Event.top, find_by_uname='background_2_tab_base')
    endelse
endelse

id_save_selection = widget_info(Event.top, find_by_uname='save_selection_button')
widget_control, id_save_selection, sensitive=0

if ((*global).selection_signal EQ 0 AND $
    (*global).selection_background EQ 0 AND $
    (*global).selection_background_2 EQ 0) then begin
    
    id_save_selection = widget_info(Event.top, find_by_uname='clear_selection_button')
    widget_control, id_save_selection, sensitive=0
    
endif

widget_control, view_info, set_value=text, /append
widget_control, full_view_info, set_value=full_text, /append
widget_control, selection_info, set_value=''
widget_control, view_info_tab, base_set_title=''
SHOW_DATA_REF_L,event

end




pro save_selection_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;info_box id
view_info = widget_info(Event.top, FIND_BY_UNAME='info_text')
full_view_info = widget_info(Event.top, find_by_uname='log_book_text')

signal_background_pid_file_names = get_signal_background_pid_file_name(Event)
signal_pid_file_name = signal_background_pid_file_names[0]
background_pid_file_name = signal_background_pid_file_names[1]

signal_id = widget_info(Event.top, find_by_uname='signal_pid_text')
background_id = widget_info(Event.top, find_by_uname='background_pid_text')

full_text = "Signal and background selection have been saved"
text = "Signal & background selection - SAVED"
widget_control, view_info, set_value=text, /append
widget_control, full_view_info, set_value=full_text, /append

;produce the ascii files of the selection
produce_pid_files, Event, signal_pid_file_name, background_pid_file_name

;populate signal and backgound pid file name in data reduction tab
widget_control, signal_id, set_value=signal_pid_file_name
widget_control, background_id, set_value=background_pid_file_name

;populate signal and backgound pid file name in data reduction tab
widget_control, background_id, set_value=background_pid_file_name

end





pro produce_pid_files, Event, signal_pid_file_name, background_pid_file_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;signal selection
x1_signal = (*global).x1_signal
x2_signal = (*global).x2_signal
y1_signal = (*global).y1_signal
y2_signal = (*global).y2_signal

XYsignal = reorder(x1_signal, x2_signal, y1_signal, y2_signal)

;create output file
create_signal_pid_array_file, XYsignal, signal_pid_file_name

;background selection
x1_back = (*global).x1_back
x2_back = (*global).x2_back
y1_back = (*global).y1_back
y2_back = (*global).y2_back

XYbackground = reorder(x1_back, x2_back, y1_back, y2_back)

;create output file
create_background_pid_array_file, XYsignal, XYbackground, background_pid_file_name

end








pro background_list_group_eventcb, Event

;check value of selection
id = widget_info(Event.top, FIND_BY_UNAME='background_list_group')
WIDGET_CONTROL, id, GET_VALUE = value

back_info = widget_info(Event.top, find_by_uname='background_file_base')

if (value EQ 0) then begin 
    widget_control, back_info, map=1
endif else begin
    widget_control, back_info, map=0
endelse

end



pro background_list_group_eventcb_REF_M, Event

;check value of selection
id = widget_info(Event.top, FIND_BY_UNAME='background_list_group_REF_M')
WIDGET_CONTROL, id, GET_VALUE = value

back_info = widget_info(Event.top, find_by_uname='background_file_base_REF_M')

if (value EQ 0) then begin 
    widget_control, back_info, map=1
endif else begin
    widget_control, back_info, map=0
endelse

end





pro intermediate_file_output_list_group_eventcb, Event

;check value of intermediate file output
id = widget_info(Event.top, find_by_uname='intermediate_file_output_list_group')
widget_control, id, get_value = value

if (value EQ 0) then begin ;display other plots

endif else begin ;remove other plots 

endelse

end 








pro EXIT_PROGRAM_REF_L, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;remove temporary file
tmp_folder = (*global).tmp_folder
if (tmp_folder NE '') then begin
    cmd_remove = "rm -r " + tmp_folder
    spawn, cmd_remove
endif

widget_control,Event.top,/destroy

end


pro EXIT_PROGRAM_REF_M, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;remove temporary file
tmp_folder = (*global).tmp_folder
if (tmp_folder NE '') then begin
    cmd_remove = "rm -r " + tmp_folder
    spawn, cmd_remove
endif

widget_control,Event.top,/destroy

end





pro start_data_reduction_button_REF_L_eventcb, Event

print, "in start_data_reduction for REF_L"

end






pro start_data_reduction_button_REF_M_eventcb, Event

print, "in start_data_reduction for REF_M"

end
