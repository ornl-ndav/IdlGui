function produce_pixels_offset, i1, i2, i3, i4, i5, tube_removed, bank

offset_text_array = strarr(2)
start_position = -.075
tube_length_m = 0.15

offset_text_array[0]= ''
offset_text_array[1]= ''

if (tube_removed EQ 1) then begin

;    increment_offset = 0.00234375    
    increment_offset = 0.002380952   

    for i=0,63 do begin
        coeff = float(start_position + i*increment_offset)
        offset_text_array[0] += strcompress(coeff,/remove_all) + ' '
    endfor
    offset_text_array[1] = offset_text_array[0]
    
endif else begin

    case bank of
        1: begin ;bank #1
            
            i1=63-i1
            i2=63-i2
            tube_length_pixel = i1-i2
            increment_offset = tube_length_m / tube_length_pixel
            start_position_local = start_position - i2 * increment_offset

            for k=0,63 do begin
                coeff = float(start_position_local + k*increment_offset)
                offset_text_array[0] += strcompress(coeff,/remove_all) + ' '
            endfor

            i3=i3-63
            i4=i4-63
            tube_length_pixel = i4-i3
            increment_offset = tube_length_m / tube_length_pixel
            start_position_local = start_position - i3 * increment_offset

            for k=0,63 do begin
                coeff = float(start_position_local + k*increment_offset)
                offset_text_array[1] += strcompress(coeff,/remove_all) + ' '
            endfor

        end
        2: begin ;bank #2

            tube_length_pixel = i2-i1
            increment_offset = tube_length_m / tube_length_pixel
            start_position_local = start_position - i1 * increment_offset
            
            for k=0,63 do begin
                coeff = float(start_position_local + k*increment_offset)
                offset_text_array[0] += strcompress(coeff,/remove_all) + ' '
            endfor

            i3=63-(i3-63)
            i4=63-(i4-63)
            tube_length_pixel = i3-i4
            increment_offset = tube_length_m / tube_length_pixel
            start_position_local = start_position - i4 * increment_offset

            for k=0,63 do begin
                coeff = float(start_position_local + k*increment_offset)
                offset_text_array[1] += strcompress(coeff,/remove_all) + ' '
            endfor

        end
        else:

    endcase

endelse

return, offset_text_array
end





function reverse_array, data

tmp = data[0:63,0:31]
tmp = reverse(tmp,1) 

data[0:63,0:31] = tmp

tmp = data[64:*,32:*]
tmp = reverse(tmp,1)
data[64:*,32:*] = tmp

reverse_data = temporary(data)
return, reverse_data
end




function reverse_3d_array, data

tmp = data[*,0:63,0:31]
tmp = reverse(tmp,2) 

data[*,0:63,0:31] = tmp

tmp = data[*,64:*,32:*]
tmp = reverse(tmp,2)
data[*,64:*,32:*] = tmp

reverse_data = temporary(data)
return, reverse_data
end






function get_ucams

cd , "~/"
cmd_pwd = "pwd"
spawn, cmd_pwd, listening
;print, "listening is: ", listening
array_listening=strsplit(listening,'/',count=length,/extract)
ucams = array_listening[2]
return, ucams
end






;---------------------------------------------------------------------
function get_file_name_only, file

;to remove the part_to_remove part of the name
part_to_remove="/"
file_name = strsplit(file,part_to_remove,/extract,/regex,count=length) 
file_name_only = file_name[length-1]

return, file_name_only

end







;---------------------------------------------------------------------
function modified_file_name, Event, file_name_only

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

remapped_file_name = (*global).remapped_file_name

part_to_remove = '_mapped.dat'
first_part_of_file_name = strsplit(file_name_only,$
                                   part_to_remove,$
                                   /extract,$
                                   /regex,$
                                   count=length)
output_file_name = first_part_of_file_name[0] + '.dat'

return, output_file_name

end






;--------------------------------------------------------------------
function give_real_pixelid_value, Event, pixel_number, tube_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

look_up = (*(*global).look_up)

return, look_up[pixel_number,tube_number]

end







pro OPEN_NEXUS_INTERFACE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display open_nexus interface
open_nexus_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_NEXUS_BASE')
widget_control, open_nexus_id, map=1

end







pro OPEN_LOCAL_NEXUS_INTERFACE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display open_local_nexus interface
open_local_nexus_id = widget_info(Event.top, find_by_uname='open_local_nexus_base')
widget_control, open_local_nexus_id, map=1

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




FUNCTION find_full_local_nexus_name, Event, run_number, instrument    

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cmd = "findnexus -i" + instrument 
cmd += " --prefix " + (*global).working_path
cmd += " " + strcompress(run_number,/remove_all)
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


 









pro create_tmp_folder, wWidget

;get global structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_nxdir_folder = (*global).tmp_nxdir_folder
full_tmp_nxdir_folder_path = (*global).working_path + tmp_nxdir_folder
(*global).full_tmp_nxdir_folder_path = full_tmp_nxdir_folder_path

cmd_check = "ls -d " + full_tmp_nxdir_folder_path
spawn, cmd_check, listening

if (listening NE '') then begin
    cmd_remove = "rm -r " + full_tmp_nxdir_folder_path
    spawn, cmd_remove
endif

;now create tmp folder
cmd_create = "mkdir " + full_tmp_nxdir_folder_path
spawn, cmd_create,  listening

end





pro CANCEL_OPEN_NEXUS, Event

;hide open_nexus interface
open_nexus_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_NEXUS_BASE')
widget_control, open_nexus_id, map=0

end




pro CANCEL_LOCAL_OPEN_NEXUS, Event

;hide open_nexus interface
open_nexus_id = widget_info(Event.top, FIND_BY_UNAME='open_local_nexus_base')
widget_control, open_nexus_id, map=0

end




pro initialization_of_arrays, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Ny_scat = (*global).Ny_scat
Nx = (*global).Nx
tube_removed = lonarr(Ny_scat)
(*(*global).tube_removed) = tube_removed
(*(*global).pixel_removed) = lonarr(Ny_scat * Nx)
(*(*global).IDL_pixelid_removed) = lonarr(Ny_scat, Nx)

end














;--------------------------------------------------------------------
pro generate_look_up_table_of_real_pixelid_value, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create look-up table
Nx = (*global).Nx
Ny = (*global).Ny_scat
Nt = (*global).Nt

look_up=lonarr(Nx,Ny)
look_up_histo = lonarr(Nt, Nx, Ny)
for tube=0,31 do begin
    for pixel=0,63 do begin
        look_up[pixel,tube]=(63-pixel)+tube*128
        looK_up_histo[*,pixel,tube] = (63-pixel)+tube*128
    endfor
    for pixel=64,127 do begin
        look_up[pixel,tube]=pixel+tube*128
        look_up_histo[*,pixel,tube] = pixel+tube*128
    endfor
endfor

for tube=32,63 do begin
    for pixel=0,63 do begin
        look_up[pixel,tube]=(pixel+tube*128)
        look_up_histo[*,pixel,tube] = pixel+tube*128
    endfor
    for pixel=64,127 do begin
        look_up[pixel,tube]=(191-pixel)+tube*128
        look_up_histo[*,pixel,tube]=(191-pixel)+tube*128
    endfor
endfor

(*(*global).look_up) = look_up
(*(*global).look_up_histo) = look_up_histo

end






;value = 1 means removed
;value = 0 means do not removed
pro update_list_of_IDL_pixelid_to_removed, Event, pixelid, tube, value

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IDL_pixelid_removed = (*(*global).IDL_pixelid_removed)
IDL_pixelid_removed(tube, pixelid) = value
(*(*global).IDL_pixelid_removed) = IDL_pixelid_removed

end








;---------------------------------------------------------------
;value=0 means do not removed
;value=1 means removed
pro update_list_of_pixelid_to_removed, Event, real_pixelid, value

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_removed = (*(*global).pixel_removed)

if (value EQ 0) then begin

    pixel_removed[real_pixelid]=0

endif else begin

    pixel_removed[real_pixelid]=1

endelse

(*(*global).pixel_removed) = pixel_removed

end









;--------------------------------------------------------------------
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







;--------------------------------------------------------------------
pro RealignGUI_eventcb

end









;----------------------------------------------------------------------------
pro MAIN_REALIZE, wWidget

;get global structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

ucams = get_ucams()
(*global).ucams = ucams

IDENTIFICATION_GO_cb, wWidget

end




;--------------------------------------------------------------------------
; \brief 
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro CTOOL_DAS, Event

	;get global structure
	id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
	widget_control,id,get_uvalue=global

	xloadct,/MODAL,GROUP=id

	plot_das,event

end







;--------------------------------------------------------------------------
; \brief 
;
; \argument Event (INPUT)
;--------------------------------------------------------------------------
pro CTOOL_realign, Event

	;get global structure
	id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
	widget_control,id,get_uvalue=global

	xloadct,/MODAL,GROUP=id

        plot_realign_data, Event

end














pro ENABLED_PROCEDURE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;enabled background buttons/draw/text/labels
id_list=['reset_all_button',$
         'remove_pixelid',$
         'draw_tube_pixels_slider',$
         'pixels_slider',$
         'nt_histo_draw_tube_pixels_slider',$
         'histo_draw_tube_pixels_slider',$
         'remove_tube_button',$
         'removed_tube_text',$
         'tube0_left_minus',$
         'tube0_left_text',$
         'tube0_left_plus',$
         'tube0_right_minus',$
         'tube0_right_text',$
         'tube0_right_plus',$
         'center_minus',$
         'center_text',$
         'center_plus',$
         'tube1_left_minus',$
         'tube1_left_text',$
         'tube1_left_plus',$
         'tube1_right_minus',$
         'tube1_right_text',$
         'tube1_right_plus',$
         'plot_mapped_data',$
         'CTOOL_MENU_DAS']

id_list_size = size(id_list)
for i=0,(id_list_size[1]-1) do begin
    id = widget_info(Event.top,FIND_BY_UNAME=id_list[i])
    Widget_Control, id, sensitive=1
endfor

id = widget_info(Event.top,FIND_BY_UNAME='output_new_histo_mapped_file')
Widget_Control, id, sensitive=0

end








;------------------------------------------------------------------------
pro READ_HISTO_FILE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file = (*global).file 

;initialize removed_tube (removed #28,29,30,31,60-67)
removed_tube = (*(*global).tube_removed)
tube_to_remove=[indgen(4)+28,indgen(4)+60]
size=size(tube_to_remove)

for i=0, (size[1]-1) do begin
    removed_tube[tube_to_remove[i]]=1
endfor

(*(*global).tube_removed) = removed_tube

;reinitialize DATA_REMOVED box
refresh_data_removed_text, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = " Opening/Reading file.......... "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = file
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

openr,u,file,/get

;to get the size of the file
fs=fstat(u)
file_size=fs.size

text = "Infos about file:" 
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "  - Size of file : " + strcompress(file_size,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

Nbytes = (*global).nbytes
N = long(file_size) / Nbytes    ;number of elements

text = "  - Nbre of elements : " + strcompress(N,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

Nx = (*global).Nx
Ny_diff = (*global).Ny_diff
Ny_scat = (*global).Ny_scat

Nt = long(N)/(long(Nx*(Ny_diff + Ny_scat)))
(*global).Nt = Nt

image1 = ulonarr(Nt,Nx,Ny_scat)
readu,u,image1
diff = ulonarr(Nt,Nx,Ny_diff)
readu,u,diff
close,/all

(*(*global).image1) = image1

text = "  - Number of Tbins : " + strcompress(Nt,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

PLOT_HISTO_FILE, Event, image1


end




pro PLOT_HISTO_FILE, Event, image1

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

text = ''
output_into_log_book, event, text
text = 'Plot histo file:'
output_into_log_book, event, text

image_2d_1 = total(image1,1)

tmp = image_2d_1[0:63,0:31]

;window,1
;plot,total(tmp,2),title='in plot_histo_file before reversing, top bank'
tmp = reverse(tmp,1) 

;window,2
;plot, total(tmp,2), title='in plot_histo after reversing, top bank'
image_2d_1[0:63,0:31] = tmp

tmp = image_2d_1[64:*,32:*]
tmp = reverse(tmp,1)
image_2d_1[64:*,32:*] = tmp

(*(*global).image_2d_1) = image_2d_1 
(*(*global).image_2d_1_untouched) = image_2d_1

draw_info= widget_info(Event.top, find_by_uname='draw_tube_pixels_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

;calculate i1,i2,i3,i4 and i5 for all the tubes
calculate_ix, Event

;display i1,i2,i3,i4 and i5 for tube 0
display_ix, Event, 0

;fill pixelids counts in right table
pixelIDs_info_id = widget_info(Event.top, FIND_BY_UNAME='pixels_counts_values')
text = ' 0: ' + strcompress(image_2d_1[0,0],/remove_all)
widget_control, pixelIDs_info_id, set_value=text
for i=1,127 do begin
    text = strcompress(i) + ': ' + strcompress(image_2d_1[i,0],/remove_all)
    widget_control, pixelIDs_info_id, set_value=text, /append
endfor

text = ' Plot data using DAS representation'
output_into_log_book, event, text
plot_das, Event

;plot on DAS'plot an indication of the position of the tube
das_plot_id = widget_info(Event.top, find_by_uname='DAS_plot_draw')
widget_control, das_plot_id, get_value=das_id
wset, das_id
x_coeff = (*global).x_coeff
y_coeff = (*global).y_coeff
for i=0, 63 do begin
    plots, i*x_coeff, 0, /device, color=200
    plots, i*x_coeff, 64*y_coeff, /device, /continue, color=200
endfor

plot_tube_box, Event, 0

ctool_id = widget_info(Event.top, find_by_uname='CTOOL_MENU_realign')
widget_control, ctool_id, sensitive=0

text = '...done'
output_into_log_book, event, text

end










;--------------------------------------------------------------------------
pro plot_das, EVEnt

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;color
DEVICE, DECOMPOSED = 0
;loadct,5

;plot DAS'plot
das_plot_id = widget_info(Event.top, find_by_uname='DAS_plot_draw')
widget_control, das_plot_id, get_value=das_id
wset, das_id

image_2d_1 = (*(*global).image_2d_1)

xoff=5
yoff=5
x_size=400
y_size=100
New_Nx = 530
New_Ny = 200
image_2d_1 = transpose(image_2d_1)
tvimg = congrid(image_2d_1,New_Nx,New_Ny,/interp)
tvscl, tvimg, xoff, yoff, /device, xsize=x_size, ysize=y_size

DEVICE, DECOMPOSED = 1

end









;--------------------------------------------------------------------------
pro plot_tube_box, Event, tube_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;color
DEVICE, DECOMPOSED = 0
loadct,5

;plot DAS'plot
das_plot_id = widget_info(Event.top, find_by_uname='DAS_plot_draw')
widget_control, das_plot_id, get_value=das_id
wset, das_id

xoff=5
yoff=5
x_size=400
y_size=100
New_Nx = 530
New_Ny = 200
image_2d_1 =(*(*global).image_2d_1)
image_2d_1 = transpose(image_2d_1)
tvimg = congrid(image_2d_1,New_Nx,New_Ny,/interp)
tvscl, tvimg, xoff, yoff, /device, xsize=x_size, ysize=y_size

DEVICE, DECOMPOSED = 1

;plot on DAS'plot
das_plot_id = widget_info(Event.top, find_by_uname='DAS_plot_draw')
widget_control, das_plot_id, get_value=das_id
wset, das_id
x_coeff = (*global).x_coeff
y_coeff = (*global).y_coeff
plots, tube_number*x_coeff, 0, /device, color=200
plots, tube_number*x_coeff, 64*y_coeff, /device, /continue, color=200


end









;--------------------------------------------------------------------------
pro calculate_ix, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

image_2d_1 = (*(*global).image_2d_1)
Ntubes = (*global).Ny_scat      ;Number of tubes

i1 = intarr(Ntubes)             ;first part of tube start
i2 = intarr(Ntubes)             ;first part of tube end
i3 = intarr(Ntubes)             ;second part of tube start
i4 = intarr(Ntubes)             ;second part of tube end
i5 = intarr(Ntubes)             ;central position between the two parts

len1 = intarr(Ntubes)           ;length of first part of tube
len2 = intarr(Ntubes)           ;length of second part of tube

off1 = 25                       ;max position of first part tube start
off2 = 50                       ;min position of first part tube end 
off3 = 80                 ;max position of second part tube start     
off4 = 110                      ;min position of second part tube end

for i=0,Ntubes-1 do begin
    
    sum_tube = total(image_2d_1[*,i]) ;check if there are counts for that tube
    
    if (sum_tube EQ 0) then begin ;if there is no data in tube
        
        indx1=0
        indx2=62
        cntr=63
        indx3=65
        indx4=127
        
    endif else begin
        
        tube_pair = image_2d_1[*,i] ; - smooth(0.75*image_2d_1[*,i],5)
        
                                ;place where I'm going to remove counts in file
        
        diff_rise = tube_pair - shift(tube_pair,1)
        diff_fall = tube_pair - shift(tube_pair,-1)
        
        tmp0 = min(image_2d_1[off2:off3,i],cntr)
        cntr += off2
        
        tmp1 = max(diff_rise[0:off1],indx1)
        tmp2 = max(diff_fall[off2:cntr],indx2)
        indx2 += off2
        tmp3 = max(diff_rise[cntr:off3],indx3)
        indx3 += cntr
        tmp4 = max(diff_fall[off4:*],indx4)
        indx4 += off4
        
    endelse
        
;store the indexes in an array i
    i1[i] = indx1
    i2[i] = indx2
    i3[i] = indx3
    i4[i] = indx4
    i5[i] = cntr
    
;store the size of each size of the tube in len1 and len2
    len1[i] = i2[i] - i1[i]
    len2[i] = i4[i] - i3[i]
    
endfor

(*(*global).i1) = i1
(*(*global).i2) = i2
(*(*global).i3) = i3
(*(*global).i4) = i4
(*(*global).i5) = i5

(*(*global).len1) = len1
(*(*global).len2) = len2

end













;----------------------------------------------------------------
pro plot_realign_data, Event, remap_histo_local

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')

Ntubes = (*global).Ny_scat
Npix = (*global).Nx

remap = temporary(total(remap_histo_local,1))

;get id of drawing region for remap data
draw_info= widget_info(Event.top, find_by_uname='map_plot_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

Ninterp = 1
;window,4,xsize = Ninterp*Npix, ysize = Ninterp*Ntubes
tmp0 = remap
tmp1 = rebin(tmp0,Ninterp*Npix,Ninterp*Ntubes,/samp)
tmp1 = transpose(tmp1)

;if dolog EQ 1 then begin
;    tvscl,(alog10(tmp1>1))
;endif else begin

DEVICE, DECOMPOSED = 0
;loadct,5

xoff=5
yoff=5
x_size=400
y_size=100
New_Nx=530
New_Ny=200
tvimg = congrid(hist_equal(tmp1), New_Nx, New_Ny,/interp)
tvscl, tvimg, xoff, yoff, /device, xsize=x_size, ysize=y_size
;tvscl,hist_equal(tmp1)
;endelse

DEVICE, DECOMPOSED = 1

id = widget_info(Event.top,FIND_BY_UNAME='output_new_histo_mapped_file')
Widget_Control, id, sensitive=1

ctool_id = widget_info(Event.top, find_by_uname='CTOOL_MENU_realign')
widget_control, ctool_id, sensitive=1

end









;--------------------------------------------------------------------------------
pro display_ix, Event, i

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

image_2d_1 = (*(*global).image_2d_1)

i1=(*(*global).i1)
i2=(*(*global).i2)
i3=(*(*global).i3)
i4=(*(*global).i4)
i5=(*(*global).i5)

indx1 = i1[i]
indx2 = i2[i]
indx3 = i3[i]
indx4 = i4[i]
cntr = i5[i]

draw_info= widget_info(Event.top, find_by_uname='draw_tube_pixels_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

;loadct,0
plot, image_2d_1[*,i]
oplot,image_2d_1[*,i],psym=4,color=255
plots,[indx1,image_2d_1[indx1,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx2,image_2d_1[indx2,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[cntr,image_2d_1[cntr,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx3,image_2d_1[indx3,i]],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx4,image_2d_1[indx4,i]],psym=4,color=255+(256*0)+(150*256),thick=3

tube_number = i

if ((*global).new_tube EQ 1) then begin

    (*global).new_tube = 0
    pixelIDs_info_id = widget_info(Event.top, $
                                   FIND_BY_UNAME='pixels_counts_values')
    text = ' 0: ' + strcompress(image_2d_1[0,tube_number],/remove_all)
    widget_control, pixelIDs_info_id, set_value=text
    for i=1,127 do begin
        text = strcompress(i) + ': ' + strcompress(image_2d_1[i,tube_number],$
                                                   /remove_all)
        widget_control, pixelIDs_info_id, set_value=text, /append
    endfor

endif

;show the values of indx1, indx2....etc into their own spaces
indx1_id = widget_info(Event.top, find_by_uname="tube0_left_text")
indx2_id = widget_info(Event.top, find_by_uname="tube0_right_text")
cntr_id = widget_info(Event.top, find_by_uname="center_text")
indx3_id = widget_info(Event.top, find_by_uname="tube1_left_text")
indx4_id = widget_info(Event.top, find_by_uname="tube1_right_text")

widget_control, indx1_id, set_value=strcompress(indx1,/remove_all)
widget_control, indx2_id, set_value=strcompress(indx2,/remove_all)
widget_control, cntr_id, set_value=strcompress(cntr,/remove_all)
widget_control, indx3_id, set_value=strcompress(indx3,/remove_all)
widget_control, indx4_id, set_value=strcompress(indx4,/remove_all)

end









;----------------------------------------------------------------------------
pro plot_tubes_pixels, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

;check if tube_number is in the list of tube removed
;if yes, validate ADD button and unvalidate REMOVE button
tube_removed = (*(*global).tube_removed)
remove_id = widget_info(Event.top, find_by_uname='remove_tube_button')
add_id = widget_info(Event.top, find_by_uname='cancel_remove_tube_button')

if (tube_removed(tube_number) EQ 1) then begin

    ;validate ADD and unvalidate REMOVE
    widget_control, remove_id, sensitive=0
    widget_control, add_id, sensitive=1

endif else begin

    ;validate REMOVE and unvalidate ADD
    widget_control, remove_id, sensitive=1
    widget_control, add_id, sensitive=0

endelse

pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
widget_control, pixel_slider_id, get_value=pixel_number

real_pixelid = give_real_pixelid_value(Event, pixel_number, tube_number)

pixel_value_info_id = widget_info(Event.top, find_by_uname='pixel_value')
real_pixelid_text = strcompress(real_pixelid,/remove_all)
widget_control, pixel_value_info_id, set_value=real_pixelid_text

tube_number_info_id = widget_info(Event.top, find_by_uname='tube_value')
text = strcompress(tube_number,/remove_all)
widget_control, tube_number_info_id, $
  set_value=text

bank_info_id = widget_info(Event.top, find_by_uname='bank_value')
if (tube_number LE 31) then begin
    bank_number = strcompress(1,/remove_all)
endif else begin
    bank_number = strcompress(2,/remove_all)
endelse

widget_control, bank_info_id, set_value=bank_number

pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
initialization_pixel = 0
widget_control, pixel_slider_id, set_value=initialization_pixel

my_tube_number = tube_number
(*global).new_tube = 1
plot_tube_box, Event, my_tube_number
display_ix, Event, tube_number

end





pro update_tube_removed_array, Event, tube_number, value

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tube_removed_array = (*(*global).tube_removed)
tube_removed_array[tube_number]=value
(*(*global).tube_removed) = tube_removed_array

end







;----------------------------------------------------------------------------
;save tubes changes
pro save_changes, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;unvalidate REMOVE button and validate ADD
remove_id = widget_info(Event.top, find_by_uname='cancel_remove_tube_button')
widget_control, remove_id, sensitive=1
add_id = widget_info(Event.top, find_by_uname='remove_tube_button')
widget_control, add_id, sensitive=0

;value of actif tube
slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

update_tube_removed_array, Event, tube_number, 1

;update text box of tubes and pixel to be removed
refresh_data_removed_text, Event
refresh_pixel_removed_text, Event

(*global).new_tube = 1 
display_ix, Event, tube_number

end



;bring back to life tube
pro add_tube, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;unvalidate REMOVE button and validate ADD
remove_id = widget_info(Event.top, find_by_uname='cancel_remove_tube_button')
widget_control, remove_id, sensitive=0
add_id = widget_info(Event.top, find_by_uname='remove_tube_button')
widget_control, add_id, sensitive=1

;value of actif tube
slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

update_tube_removed_array, Event, tube_number, 0

;update text box of tubes and pixel to be removed
refresh_data_removed_text, Event
refresh_pixel_removed_text, Event

(*global).new_tube = 1 
display_ix, Event, tube_number

end






;-------------------------------------------------------------------------
pro save_pixelid_changes, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;unvalidate REMOVE button and validate ADD
remove_id = widget_info(Event.top, find_by_uname='remove_pixelid')
widget_control, remove_id, sensitive=0
add_id = widget_info(Event.top, find_by_uname='pixelid_new_counts_reset')
widget_control, add_id, sensitive=1

;update number of counts for that pixel
image_2d_1 = (*(*global).image_2d_1)

pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
widget_control, pixel_slider_id, get_value=pixel_number

new_pixel_counts = 0

;new_pixel_counts_id = widget_info(Event.top, $
;                                  find_by_uname='pixelid_new_counts_value')
;widget_control, new_pixel_counts_id, get_value=new_pixel_counts

slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

new_pixel_counts = float(new_pixel_counts[0])

real_pixelid =  give_real_pixelid_value(Event, pixel_number, tube_number)
update_list_of_pixelid_to_removed, Event,real_pixelid, 1
update_list_of_IDL_pixelid_to_removed, Event, pixel_number, tube_number, 1

;add this pixel to the list of pixel to removed
if (new_pixel_counts NE image_2d_1[pixel_number,tube_number]) then begin
    image_2d_1[pixel_number,tube_number]=new_pixel_counts
    (*(*global).image_2d_1)=image_2d_1

    removed_tube_text_id = widget_info(Event.top, $
                                       FIND_BY_UNAME="removed_tube_text")
    
    text = "Pix:" + strcompress(real_pixelid,/remove_all)
    widget_control, removed_tube_text_id, set_value=text,/append

endif

pixelid_counts_value_id = widget_info(Event.top, $
                                      find_by_uname='pixelid_counts_value')
text = strcompress(new_pixel_counts, /remove_all)
widget_control, pixelid_counts_value_id, set_value=text

(*global).new_tube = 1 
display_ix, Event, tube_number

end













;-------------------------------------------------------------------------
;update list of tubes removed
pro refresh_data_removed_text, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

removed_tube = (*(*global).tube_removed)
removed_tube_text_id = widget_info(Event.top, $
                                   FIND_BY_UNAME="removed_tube_text")
first_update = 0
for i=0,((*global).Ny_scat-1) do begin
    if (removed_tube[i] EQ 1) then begin
        text = "Tub:" + strcompress(i,/remove_all)
        if (first_update EQ 0) then begin
            widget_control, removed_tube_text_id, set_value=text        
            first_update=1
        endif else begin
            widget_control, removed_tube_text_id, set_value=text,/append
        endelse
    endif
endfor

end








;-------------------------------------------------------------------------
;update list of pixels removed
pro refresh_pixel_removed_text, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_removed = (*(*global).pixel_removed)
removed_tube_text_id = widget_info(Event.top, find_by_uname="removed_tube_text")

pixel_to_removed_indeces = where(pixel_removed GT 0, nbr)

if (nbr GT 0) then begin
    for i=0,nbr-1 do begin
        text = "Pix:"+strcompress(pixel_to_removed_indeces[i],/remove_all)
        widget_control, removed_tube_text_id, set_value=text,/append
    endfor
endif

end












;--------------------------------------------------------------------------
pro reset_all_changes, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, find_by_uname='reset_all_button_validate_yes')
widget_control, id, map=0

file_type = (*global).file_type

if (file_type EQ 'nexus') then begin
    
    OPEN_NEXUS, Event

endif else begin

    OPEN_FILE_STEP_2, Event

endelse

end








pro old_reset_all_changes, Event

;initialize removed_tube (removed #28,29,30,31,60-67)
tube_to_remove=[indgen(4)+28,indgen(4)+60]
size=size(tube_to_remove)
removed_tube=lonarr((*global).Ny_scat)

;tube to removed are
for i=0, (size[1]-1) do begin
    removed_tube[tube_to_remove[i]]=1
endfor

(*(*global).tube_removed) = removed_tube

;reinitialize DATA_REMOVED box
refresh_data_removed_text, Event

;reset pixelid counts
image_2d_1_untouched = (*(*global).image_2d_1_untouched)
image_2d_1 = image_2d_1_untouched
(*(*global).image_2d_1) = image_2d_1

;get tube_number
tube_slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, tube_slider_id, get_value=tube_number

;get pixel_value
pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
widget_control, pixel_slider_id, get_value=pixel_number

value_displayed = strcompress(image_2d_1_untouched[pixel_number,tube_number],$
                              /remove_all)

pixelid_counts_value_id = widget_info(Event.top, find_by_uname='pixelid_counts_value')
widget_control, pixelid_counts_value_id, set_value=value_displayed

get_pixels_infos, Event

;fill pixelids counts in right table
pixelIDs_info_id = widget_info(Event.top, FIND_BY_UNAME='pixels_counts_values')
text = ' 0: ' + strcompress(image_2d_1[0,0],/remove_all)
widget_control, pixelIDs_info_id, set_value=text
for i=1,127 do begin
    text = strcompress(i) + ': ' + strcompress(image_2d_1[i,0],/remove_all)
    widget_control, pixelIDs_info_id, set_value=text, /append
endfor


End








;-------------------------------------------------------------------------
pro pixelid_new_counts_reset, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;unvalidate REMOVE button and validate ADD
remove_id = widget_info(Event.top, find_by_uname='remove_pixelid')
widget_control, remove_id, sensitive=1
add_id = widget_info(Event.top, find_by_uname='pixelid_new_counts_reset')
widget_control, add_id, sensitive=0

image_2d_1 = (*(*global).image_2d_1)
image_2d_1_untouched = (*(*global).image_2d_1_untouched)
tube_removed = (*(*global).tube_removed)
pixel_removed = (*(*global).pixel_removed)

;refresh DATA_REMOVED (that will removed the current pixel_number)
refresh_data_removed_text, Event

;get tube_number
tube_slider_id = widget_info(Event.top, $
                             find_by_uname='draw_tube_pixels_slider')
widget_control, tube_slider_id, get_value=tube_number

;get pixel_value
pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
widget_control, pixel_slider_id, get_value=pixel_number

;update list of IDL pixelid to removed
update_list_of_IDL_pixelid_to_removed, Event, pixel_number, tube_number, 0

;determine real pixelID number
real_pixelid =  give_real_pixelid_value(Event, pixel_number, tube_number)

;update list of PIXELID_removed
;check if realpixelID is in list of pixelid to removed (if yes,
;removed it from the list)
update_list_of_pixelid_to_removed, Event,real_pixelid, 0
pixel_removed = (*(*global).pixel_removed)

;removed pixel that are no longer removed from the list of Tubes and Pixels
refresh_pixel_removed_text, Event

image_2d_1[pixel_number,tube_number]=$
  image_2d_1_untouched[pixel_number,tube_number]
(*(*global).image_2d_1) = image_2d_1

get_pixels_infos, Event

;fill pixelids counts in the table on the right
pixelIDs_info_id = widget_info(Event.top, FIND_BY_UNAME='pixels_counts_values')
text = ' 0: ' + strcompress(image_2d_1[0,0],/remove_all)
widget_control, pixelIDs_info_id, set_value=text
for i=1,127 do begin
    text = strcompress(i) + ': ' + strcompress(image_2d_1[i,0],/remove_all)
    widget_control, pixelIDs_info_id, set_value=text, /append
endfor

end









;---------------------------------------------------------------------------
pro get_pixels_infos, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
widget_control, pixel_slider_id, get_value=pixel_number

tube_slider_id = widget_info(Event.top, $
                             find_by_uname='draw_tube_pixels_slider')
widget_control, tube_slider_id, get_value=tube_number

;check if pixel_number of that tube_number is in the list of pixelid
;to removed, if yes, validate ADD button and unvalidate REMOVE button
IDL_pixelid_removed = (*(*global).IDL_pixelid_removed)
remove_id = widget_info(Event.top, find_by_uname='remove_pixelid')
add_id = widget_info(Event.top, find_by_uname='pixelid_new_counts_reset')

if (IDL_pixelid_removed(tube_number, pixel_number) EQ 1) then begin

    ;validate ADD and unvalidate REMOVE
    widget_control, remove_id, sensitive=0
    widget_control, add_id, sensitive=1

endif else begin

    ;validate REMOVE and unvalidate ADD
    widget_control, remove_id, sensitive=1
    widget_control, add_id, sensitive=0

endelse

pixel_info_id = widget_info(Event.top, find_by_uname='pixel_value')
real_pixel_value = strcompress(give_real_pixelid_value(Event, pixel_number, $
                                                       tube_number),$
                               /remove_all)
widget_control, pixel_info_id, set_value=real_pixel_value

;update number of counts for that pixel
image_2d_1 = (*(*global).image_2d_1)

pixelid_counts_value_id = widget_info(Event.top, $
                                      find_by_uname='pixelid_counts_value')
value = image_2d_1[pixel_number,tube_number]

widget_control, pixelid_counts_value_id, $
  set_value = strcompress(value,/remove_all)

draw_info= widget_info(Event.top, find_by_uname='draw_tube_pixels_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

display_ix, Event, tube_number

plots,[pixel_number,image_2d_1[pixel_number,tube_number]],psym=4,$
  color=(0*256)+(256*0)+(150*256),thick=3

end







;---------------------------------------------------------------------------
pro move_tube_edges, Event, tube_side, left_right, minus_plus

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

case tube_side of
    0: begin
        if (left_right EQ "left") then begin
            i1=(*(*global).i1)
            if (minus_plus EQ "minus") then begin
                if (i1[tube_number] GT 0) then begin
                    i1[tube_number]-=1
                endif
            endif else begin
                i1[tube_number]+=1
            endelse
            (*(*global).i1)=i1
            id=widget_info(Event.top,find_by_uname="tube0_left_text")
            widget_control, id, set_value=strcompress(i1[tube_number],$
                                                      /remove_all)
        endif else begin
            i2=(*(*global).i2)
            if (minus_plus EQ "minus") then begin
                i2[tube_number]-=1
            endif else begin
                i2[tube_number]+=1
            endelse
            (*(*global).i2)=i2
            id=widget_info(Event.top,find_by_uname="tube0_right_text")
            widget_control, id, set_value=strcompress(i2[tube_number],$
                                                      /remove_all)
        endelse
    end
    1: begin
        if (left_right EQ "left") then begin
            i3=(*(*global).i3)
            if (minus_plus EQ "minus") then begin
                i3[tube_number]-=1
            endif else begin
                i3[tube_number]+=1
            endelse
            (*(*global).i3)=i3
            id=widget_info(Event.top,find_by_uname="tube1_left_text")
            widget_control, id, set_value=strcompress(i3[tube_number],$
                                                      /remove_all)
        endif else begin
            i4=(*(*global).i4)
            if (minus_plus EQ "minus") then begin
                i4[tube_number]-=1
            endif else begin
                if (i4[tube_number] LT 126) then begin
                    i4[tube_number]+=1
                endif
            endelse
            (*(*global).i4)=i4
            id=widget_info(Event.top,find_by_uname="tube1_right_text")
            widget_control, id, set_value=strcompress(i4[tube_number],$
                                                      /remove_all)
        endelse
    end
    "center": begin
            i5=(*(*global).i5)
            if (minus_plus EQ "minus") then begin
                i5[tube_number]-=1
            endif else begin
                i5[tube_number]+=1
            endelse
            (*(*global).i5)=i5
            id=widget_info(Event.top,find_by_uname="center_text")
            widget_control, id, set_value=strcompress(i5[tube_number],$
                                                      /remove_all)
        end
endcase

;display i1,i2,i3,i4 and i5 for given tube (tube_number) 
display_ix, Event, tube_number

end







;-----------------------------------------------------------------------
pro ABOUT_MENU, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = "" 
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "**** RealignBSS (v.120106)****"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = ""
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Developers:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Steve Miller (millersd@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Peter Peterson (petersonpf@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Michael Reuter (reuterma@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = " Jean Bilheux (bilheuxjm@ornl.gov)"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end







;-------------------------------------------------------------------------
pro EXIT_PROGRAM, Event

widget_control,Event.top,/destroy

end








;--------------------------------------------------------------------------
pro IDENTIFICATION_TEXT_cb, Event  

view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_LEFT')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_RIGHT')
WIDGET_CONTROL, view_id, set_value= ''	

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_path = (*global).default_path

text_id=widget_info(Event.top, FIND_BY_UNAME='IDENTIFICATION_TEXT')
WIDGET_CONTROL, text_id, GET_VALUE=ucams

(*global).ucams = ucams

working_path = default_path + strcompress(ucams,/remove_all)+ '/'
(*global).working_path = working_path

text_id=widget_info(Event.top, FIND_BY_UNAME='DEFAULT_PATH_TEXT')
WIDGET_CONTROL, text_id, SET_VALUE=working_path

end








;-------------------------------------------------------------------------
pro IDENTIFICATION_GO_cb, wWidget

;get global structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ucams = (*global).ucams

name = ''
case ucams of
	'ele': name = 'Eugene Mamontov'
	'eg9': name = 'Stephanie Hammons'
	'2zr': name = 'Michael Reuter'
	'pf9': name = 'Peter Peterson'
	'j35': name = 'Zizou'
	'mid': name = 'Steve Miller'
	else : name = ''
endcase

(*global).name = name
working_path = (*global).default_path + ucams + '/'
(*global).working_path = working_path

;working path is set
CATCH, change_directory

if (change_directory ne 0) then begin ;there is a problem with the permission
    
    view_info = widget_info(wWidget,FIND_BY_UNAME='general_infos')
    Message = "Unable to change current directory to "
    Message += workingPath
    widget_control, view_info, set_value=Message, /append
    Message = "Permission denied"
    widget_control, view_info, set_value=Message, /append
    
    catch, /cancel
    
endif else begin

    cd, working_path

    welcome = "Welcome " + strcompress(name,/remove_all)
    welcome += "  (working directory: " $
      + strcompress(working_path,/remove_all) + ")"	
    view_id = widget_info(wWidget,FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL, view_id, base_set_title= welcome	
    
                                ;activate open_mapped_histo
    view_id = widget_info(wWidget,FIND_BY_UNAME='OPEN_MAPPED_HISTOGRAM')
    WIDGET_CONTROL, view_id, sensitive=1
    
    id = widget_info(wWidget, find_by_uname='OPEN_NEXUS_menu')
    widget_control, id, sensitive=1
           
    create_tmp_folder, wWidget
       
    
endelse

end







;-----------------------------------------------------
pro OUTPUT_PATH_cb, Event 

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

working_path = (*global).working_path
working_path = dialog_pickfile(path=working_path,/directory)
(*global).working_path = working_path

name = (*global).name

welcome = "Welcome " + strcompress(name,/remove_all)
welcome += "  (working directory: " + strcompress(working_path,/remove_all) + $
  ")"	
view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, view_id, base_set_title= welcome	

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = "Working directory set to:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = working_path
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

view_info = widget_info(Event.top,FIND_BY_UNAME="OUTPUT_PATH_NAME")
WIDGET_CONTROL, view_info, set_value=working_path

end








;--------------------------------------------------------------------------
function get_path_to_prenexus, run_number

;path_to_findnexus = "~/SVN/ASGIntegration/trunk/utilities/"
;cmd = path_to_findnexus + "findnexus -iBSS " + $
cmd = "findnexus -iBSS " + $
  strcompress(run_number,/remove_all) + " --prenexus"
spawn, cmd, path

return, path

end




;-------------------------------------------------------------------------
function isolate_run_number, file

part_1 = '/'
first_part = strsplit(file,part_1,/extract,/regex,count=length)

part_2 = '_neutron_histo_mapped.dat'
second_part = strsplit(first_part[length-1],part_2,/extract,/regex,count=length)

part_3 = 'BSS_'
run_number = strsplit(second_part[length-1],part_3,/extract,/regex)

return, run_number[0]

end







;-------------------------------------------------------------------------
pro create_output_folder, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file=(*global).file

if ((*global).file_type eq 'histo') then begin
    run_number = isolate_run_number(file)
    (*global).run_number = run_number
endif else begin
    run_number = (*global).run_number
endelse

text = ''
output_into_log_book, event, text

; get path to NeXus file
path_to_preNeXus = get_path_to_prenexus(run_number)
text = ' -> Path to NeXus file: ' + path_to_preNeXus
output_into_log_book, event, text

;remove last part of path_name (to get only the path)
string_to_remove = "BSS_" + strcompress(run_number,/remove_all) + "_cvinfo.xml"
text = '   string_to_remove: ' + string_to_remove
output_into_log_book, event, text

path=strsplit(path_to_preNeXus,string_to_remove,/regex,/extract)
text = '   path: ' + path
output_into_log_book, event, text
path_to_preNeXus=path[0]
text = '   path_to_preNeXus: ' + path_to_preNeXus
output_into_log_book, event, text

(*global).path_to_preNeXus = path_to_preNeXus

;get proposal number
text = ' -> Get proposal Number:'
output_into_log_book, event, text
proposal_number_array=strsplit(path_to_preNeXus,'/',/regex,/extract)
text = '   proposal_number_array: ' + proposal_number_array
output_into_log_book, event, text
proposal_number = proposal_number_array[2]
text = '   proposal_number: ' + proposal_number
output_into_log_book, event, text
(*global).proposal_number = proposal_number

; create inst_run# folder into own space
text = ' -> Create inst_run # folde into own space'
output_into_log_book, event, text

working_path = (*global).working_path

folder_to_create = "BSS/" + proposal_number + "/" + $
  strcompress(run_number,/remove_all) 
text = '    folder to create (up to run #): ' + folder_to_create
output_into_log_book, event, text

(*global).path_up_to_proposal_number = working_path + folder_to_create

folder_to_create += "/preNeXus"
text = '    folder to create (up to preNeXus): ' + folder_to_create
output_into_log_book, event, text

full_folder_name_to_create = working_path + folder_to_create
(*global).full_output_folder_name  = full_folder_name_to_create
cmd_check = "ls -d " + full_folder_name_to_create
text = ' >' + cmd_check
output_into_log_book, event, text
spawn, cmd_check, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

cd, working_path

if (listening NE '') then begin ;if folder already exists, remove it
    cmd_remove = 'rm -rf '+ full_folder_name_to_create
    text = ' >' + cmd_remove
    output_into_log_book, event, text
    spawn, cmd_remove, listening, err_listening
    output_into_log_book, event, listening
    output_error, event, err_listening
endif

cmd = "mkdir -p " + full_folder_name_to_create
text = ' >' + cmd
output_into_log_book, event, text
spawn, cmd, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

end






;--------------------------------------------------------------------------
pro output_new_histo_mapped_file, Event, data

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;determine name of output file according to input file
file = (*global).file

text = ''
output_into_log_book, event,text

text = 'Create new NeXus file...'
output_into_general_infos, event, text
text = 'Create new NeXus file:'
output_into_log_book, event,text

file_name_only = get_file_name_only(file)
working_path = (*global).working_path
;output_file_name = modified_file_name(Event, file_name_only)
output_file_name = file_name_only
text = '  * file_name_only: ' + file_name_only
output_into_log_book, event,text
text = '  * working path: ' + working_path
output_into_log_book, event,text

;create folder that will contain output_remapped file
text = ' -> Create output folder'
output_into_log_book, event,text
create_output_folder, Event

run_number = (*global).run_number
full_output_folder_name = (*global).full_output_folder_name

full_output_file_name = full_output_folder_name + "/" + output_file_name
(*global).full_output_file_name = full_output_file_name
(*global).full_output_folder_name = full_output_folder_name

;data = (*(*global).remap_histo) 

;add 8*128 '0' of the diffraction tube to have same format of histo
;files

;;for old case with only 1 time bin
;    output_data = lonarr(128L,72L)
;     output_data(*,0:63L) = data(*,*)
    
;     look_up = (*(*global).look_up)
    
;     reorder_data, Event, output_data
;     new_output_data = (*(*global).reorder_array)
    
;     reshape_data = lonarr(64L,144L)
;     reshape_data(*,*)=new_output_data

;new_output_data = ulonarr((*global).Nt,128L,72L,/NOZERO)

data = reverse_3d_array(data)
new_output_data = ulonarr((*global).Nt,128L,72L)
new_output_data(*,*,0:63L) = temporary(data(*,*,*))
look_up_histo = (*(*global).look_up_histo)
reorder_data, Event, new_output_data

;write out data
text = 'Create histo_mammed file name: ' + full_output_file_name
output_into_log_book, event,text

openw,u1,full_output_file_name,/get
writeu,u1,new_output_data

;close it up...
close,u1
free_lun,u1

;create_nexus_file, Event

end






;-------------------------------------------------------------------------
pro create_nexus_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;refresh map_data
plot_realign_data, Event, (*(*global).remap_histo)

path_to_preNeXus = (*global).path_to_preNeXus
full_output_file_name = (*global).full_output_file_name
full_output_folder_name = (*global).full_output_folder_name
working_path = (*global).working_path

;nt, nx, ny and n
Nt=(*global).Nt
Nx=(*global).Nx
Ny=(*global).Ny_scat
N=(*global).N
full_nexus_name=(*global).full_nexus_name
run_number = (*global).run_number

;name of neutron timemap file
full_timemap_filename = full_output_folder_name + "/BSS_" + $
  strcompress(run_number,/remove_all)
full_timemap_filename += "_neutron_timemap.dat"

;copy data
files_to_copy = ["*.xml","*.nxt"]
for i=0,1 do begin
    cmd_copy = "cp " + path_to_preNeXus + files_to_copy[i] + " " + $
      full_output_folder_name
    text = ' >' + cmd_copy
    output_into_log_book, event, text
    spawn, cmd_copy, listening, err_listening
    output_into_log_book, event, listening
    output_error, event, err_listening
endfor

run_number = (*global).run_number

;Retrieve timemap from NeXus file
cmd_timemap = "nxdir " + full_nexus_name
cmd_timemap += " -p /entry/bank1/time_of_flight/ --dump "
cmd_timemap += full_timemap_filename
text = ' >' + cmd_timemap
output_into_log_book, event, text
spawn, cmd_timemap, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;import geometry and mapping file into same directory
cmd_copy = "cp " + (*global).mapping_file 
cmd_copy += " " + (*global).geometry_file
cmd_copy += " " + full_output_folder_name

text = ' >' + cmd_copy
output_into_log_book, event, text
spawn, cmd_copy, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;merge files
cmd_merge = "TS_merge_preNeXus.sh " + (*global).translation_file
cmd_merge += " " + full_output_folder_name

text = ' >' + cmd_merge
output_into_log_book, event, text
spawn, cmd_merge, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;create nexus file
cd, (*global).full_output_folder_name

cmd_translate = "nxtranslate " + full_output_folder_name
cmd_translate += "/BSS_" + strcompress(run_number,/remove_all)
cmd_translate += ".nxt"

text = ' >' + cmd_translate
output_into_log_book, event, text
spawn, cmd_translate, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;create nexus folder and copy nexus file into new folder
path_up_to_proposal_number = (*global).path_up_to_proposal_number

path_up_to_nexus_folder = path_up_to_proposal_number + "/NeXus"
cmd_nexus_folder = "mkdir -p " + path_up_to_nexus_folder

text = ' >' + cmd_nexus_folder
output_into_log_book, event, text
spawn, cmd_nexus_folder, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

name_of_nexus_file = full_output_folder_name + "/BSS_" 
name_of_nexus_file += strcompress(run_number,/remove_all)
name_of_nexus_file += ".nxs"

cmd_copy = "mv " + name_of_nexus_file + " " + path_up_to_nexus_folder

full_nexus_filename = path_up_to_nexus_folder + "/BSS_" 
full_nexus_filename += strcompress(run_number,/remove_all)
text=" Name of NeXus file: " + full_nexus_filename
output_into_log_book, event, text

spawn, cmd_copy, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;create_offset_xml_file, Event

text="...done"
output_into_general_infos, event, text

end







;--------------------------------------------------------------------------
pro reorder_data, Event, data

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Nt=(*global).Nt
Nx=(*global).Nx
Ny=(*global).Ny_scat
Ny_diff=(*global).Ny_diff

;if ((*global).debug EQ 0) then begin

;     look_up=(*(*global).look_up)
    
;     size_reorder_array = (Nx*(Ny+Ny_diff))
;     reorder_pixelids = lonarr(size_reorder_array)
    
;     for i=0,Nx-1 do begin
;         for j=0,Ny-1 do begin
;             reorder_pixelids(look_up(i, j))=data(i,j)
;         endfor
;     endfor
    
;     (*(*global).reorder_array) = reorder_pixelids

; endif else begin

look_up_histo = (*(*global).look_up_histo)

size_reorder_array = Nt*(Nx*(Ny+Ny_diff))
reorder_pixelids = lonarr(size_reorder_array)

for i=0,Nx-1 do begin
    for j=0,Ny-1 do begin
        reorder_pixelids(look_up_histo(*,i,j)) = data(*,i,j)
    endfor
endfor

;endelse

end






pro cancel_reset_all, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, find_by_uname='RESET_ALL_BUTTON_VALIDATE_BASE')
widget_control, id, map=0

end






pro validate_reset_all_changes, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

id = widget_info(Event.top, find_by_uname='RESET_ALL_BUTTON_VALIDATE_BASE')
widget_control, id, map=1

end


;========================OPEN NEXUS============================

pro OPEN_NEXUS, Event, local

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).file_type='nexus'
(*global).realign_plot = 0 ;histo has not been realigned yet

;indicate initialization with hourglass icon
widget_control,/hourglass

;initialized arrays
initialization_of_arrays, Event

;hide open_nexus interface
if (n_elements(local) EQ 0) then begin
    open_nexus_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_NEXUS_BASE')
    widget_control, open_nexus_id, map=0
    run_number_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_RUN_NUMBER_TEXT')
    widget_control, run_number_id, get_value=run_number
endif else begin
    open_local_nexus_id = widget_info(Event.top, FIND_BY_UNAME='open_local_nexus_base')
    widget_control, open_local_nexus_id, map=0
    run_number_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_LOCAL_RUN_NUMBER_TEXT')
    widget_control, run_number_id, get_value=run_number
endelse

if (run_number EQ '') then begin
    
    text = "!!! Please specify a run number !!! " + strcompress(run_number,/remove_all)
    output_into_general_infos, event, text, 0
    output_into_log_book, event, text, 0
    
    (*global).nexus_open = 0
    
endif else begin
    
    ;erase main plots
    draw_tube_pixels_draw_id = $
      widget_info(Event.top,find_by_uname='draw_tube_pixels_draw')
    widget_control, draw_tube_pixels_draw_id, get_value=draw_id
    wset, draw_id
    erase

    ;erase remap plots
    draw_info= widget_info(Event.top, find_by_uname='map_plot_draw')
    widget_control, draw_info, get_value=draw_id
    wset, draw_id
    erase

    ;DAS plots
    DAS_plot_draw_id = widget_info(Event.top,find_by_uname='DAS_plot_draw')
    widget_control, DAS_plot_draw_id, get_value=draw_id
    wset, draw_id
    erase

    (*global).nexus_open = 1
    (*global).run_number = run_number
    
    if (n_elements(local) EQ 0) then begin

        text = "Opening NeXus file # " + $
          strcompress(run_number,/remove_all) + "....."
        output_into_general_infos, event, text, 0
        output_into_log_book, event, text, 0
    
;get path to nexus run #
        instrument="BSS"
        full_nexus_name = find_full_nexus_name(Event, run_number, instrument)
    
    endif else begin

        text = "Opening local NeXus file # " + $
          strcompress(run_number,/remove_all) + "....."
        output_into_general_infos, event, text, 0
        output_into_log_book, event, text, 0
    
;get path to local nexus run #
        instrument="BSS"
        full_nexus_name = find_full_local_nexus_name(Event, run_number, instrument)

    endelse

;check result of search
    find_nexus = (*global).find_nexus
    
    if (find_nexus EQ 0) then begin
        
        text_nexus = "Warning! NeXus file does not exist"
        output_into_general_infos, event, text_nexus
        output_into_log_book, event, text_nexus
        
    endif else begin
        
        (*global).full_nexus_name = full_nexus_name
        text_nexus = "(" + full_nexus_name + ")"
        output_into_log_book, event, text_nexus 
        output_into_general_infos, event, text_nexus
        
;dump binary data of NeXus file into tmp_working_path
        create_local_copy_of_histo_mapped, Event
        
;read and plot nexus file
        READ_NEXUS_FILE, Event

;procedure to enable most of the buttons/text boxes..
        ENABLED_PROCEDURE, Event
        
        generate_look_up_table_of_real_pixelid_value, Event

        text = '...done'
        output_into_general_infos, event, text

    endelse

endelse

;turn off hourglass
widget_control,hourglass=0

end




pro READ_NEXUS_FILE, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;initialize removed_tube (removed #28,29,30,31,60-67)
removed_tube = (*(*global).tube_removed)
tube_to_remove=[indgen(4)+28,indgen(4)+60]
size=size(tube_to_remove)

for i=0, (size[1]-1) do begin
    removed_tube[tube_to_remove[i]]=1
endfor

(*(*global).tube_removed) = temporary(removed_tube)
run_number = (*global).run_number

;reinitialize DATA_REMOVED box
refresh_data_removed_text, Event

text = "Opening and reading NeXus file (run # " + $
  strcompress(run_number,/remove_all) + ')'
output_into_log_book, event, text

file = "/BSS_" + strcompress(run_number, /remove_all)
file += "_neutron_histo_mapped.dat"
(*global).file = file

;global parameters
Nx = (*global).Nx
Ny_scat = (*global).Ny_scat
Ny_scat_bank = Ny_scat / 2

;opening top part
text = ' Opening top bank binary file: '
output_into_log_book, event, text
file_top = (*global).file_to_plot_top
output_into_log_book, event, ' ->' + file_top
openr,u,file_top,/get

fs=fstat(u)
file_size=fs.size

Nbytes = (*global).nbytes
N = long(file_size) / Nbytes    ;number of elements

(*global).N = 2*N

Nt = long(N)/(long(Nx*(Ny_scat_bank)))
(*global).Nt = Nt
image_top = temporary(ulonarr(Nt, Nx, Ny_scat_bank))

readu,u,image_top
close,u

;opening bottom part
text = ' Opening bottom bank binary file: '
output_into_log_book, event, text
file_bottom = (*global).file_to_plot_bottom
output_into_log_book, event, ' ->' + file_bottom
openr,u,file_bottom,/get

fs=fstat(u)
file_size=fs.size

image_bottom = ulonarr(Nt, Nx, Ny_scat_bank)

readu,u,image_bottom
close,u

;combining image_top and image_bottom into image1
text = ' Combining top and bottom banks into one array'
output_into_log_book, event, text
image1 = ulonarr(Nt,Nx,Ny_scat)
image1(*,*,0:Ny_scat_bank-1) = temporary(image_top)
image1(*,*,Ny_scat_bank:Ny_scat-1) = temporary(image_bottom)

(*(*global).image_nt_nx_ny) = image1

PLOT_HISTO_FILE, Event, image1

;update Nt of nt_histo_draw_tube_pixels_slider
if ((*global).ucams EQ (*global).nt_tab) then begin
    nt_histo_draw_tube_pixels_slider_id = $
      widget_info(Event.top, $
                  find_by_uname='nt_histo_draw_tube_pixels_slider')
    widget_control, nt_histo_draw_tube_pixels_slider_id, set_slider_max=(Nt-1)
endif

end


;=================OPEN HISTO========================



;---------------------------------------------------------------------------
pro OPEN_MAPPED_HISTOGRAM, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;initialized arrays
initialization_of_arrays, Event

OPEN_FILE, Event

end







;--------------------------------------------------------------------
pro OPEN_FILE, Event

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).file_type='histo'

spawn, "pwd",listening

if ((*global).path EQ '') then begin
   path = listening
endif else begin
   path = (*global).working_path
endelse

(*global).working_path = path

file = dialog_pickfile(/must_exist,$
	title="Select a histogram file for BSS",$
	filter= (*global).filter_histo,$
	path = path,$
	get_path = path)

;check if there is really a file
if (file NE '') then begin

    (*global).file = file
    OPEN_FILE_STEP_2, EVENT

endif else begin

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = " No new file loaded "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

;turn off hourglass
widget_control,hourglass=0

end






pro OPEN_FILE_STEP_2, EVENT

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')

file = (*global).file
path = (*global).working_path

if (path NE '') then begin
   (*global).path = path
   text = "File: " 
   WIDGET_CONTROL, view_info, SET_VALUE=text
   text = file
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

   (*global).file_already_opened = 1

endif else begin

   text = "No file openned"
   WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

READ_HISTO_FILE, Event

;procedure to enable most of the buttons/text boxes..
ENABLED_PROCEDURE, Event

generate_look_up_table_of_real_pixelid_value, Event

end







pro output_into_general_infos, event, text, do_not_append_it

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display what is going on
full_view_info = widget_info(event.top,find_by_uname='general_infos')
if (n_elements(do_not_append_it) EQ 0) then begin
    widget_control, full_view_info, set_value=text,/append
endif else begin
    widget_control, full_view_info, set_value=text
endelse

end




pro output_into_log_book, event, full_text, do_not_append_it

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display what is going on
full_view_info = widget_info(event.top,find_by_uname='log_book')
if (n_elements(do_not_append_it) EQ 0) then begin
    widget_control, full_view_info, set_value=full_text,/append
endif else begin
    widget_control, full_view_info, set_value=full_text
endelse

if ((*global).ucams EQ (*global).debugger) then begin

    file_name = (*global).debug_output_file_name
    openu, 1, file_name, /append
    text = full_text
    printf, 1,text
    close, 1
    free_lun, 1

endif

end




pro output_error, event, err_listening

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;display what is going on
full_view_info = widget_info(event.top,find_by_uname='log_book')

if (err_listening NE '' OR err_listening NE ['']) then begin
    full_text = 'ERROR: ' + err_listening
    widget_control, full_view_info, set_value=full_text,/append
endif

end







pro histo_plot_tubes_pixels, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

nt_id = widget_info(Event.top, find_by_uname='nt_histo_draw_tube_pixels_slider')
widget_control, nt_id, get_value=Nt

tube_number_id = widget_info(Event.top,find_by_uname='histo_draw_tube_pixels_slider')
widget_control, tube_number_id, get_value=tube_number

;retrieve value of time_offset, time_bin and time_max
nt_display_time_offset_text_id = $
  widget_info(Event.top,find_by_uname='nt_display_time_offset_text')
widget_control, nt_display_time_offset_text_id, get_value=time_offset

nt_display_time_bin_text_id = $
  widget_info(Event.top,find_by_uname='nt_display_time_bin_text')
widget_control, nt_display_time_bin_text_id, get_value=time_bin

;nt_display_max_time_text_id = $
;    widget_info(Event.top,find_by_uname='nt_display_max_time_text')
;widget_control, nt_display_max_time_text_id, get_value=time_max

bin_min = long(float(Nt)*float(time_bin) + float(time_offset))
bin_max = long(float(Nt+1)*float(time_bin) + float(time_offset))
text = strcompress(bin_min) + '-' + strcompress(bin_max) + ' microS'

nt_display_configure_label_id = widget_info(Event.top,find_by_uname='nt_display_configure_label')
widget_control, nt_display_configure_label_id, set_value=text[0]

image_nt_nx_ny = (*(*global).image_nt_nx_ny)
image_nt_nx_ny = reverse_3d_array(image_nt_nx_ny)

i1=(*(*global).i1)
i2=(*(*global).i2)
i3=(*(*global).i3)
i4=(*(*global).i4)
i5=(*(*global).i5)

indx1 = i1[tube_number]
indx2 = i2[tube_number]
indx3 = i3[tube_number]
indx4 = i4[tube_number]
cntr = i5[tube_number]

draw_info= widget_info(Event.top, find_by_uname='histo_draw_tube_pixels_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id

;loadct,0
plot, image_nt_nx_ny[Nt,*,tube_number]
oplot, image_nt_nx_ny[Nt,*,tube_number],psym=4,color=220

plots,[indx1,0],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx2,0],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[cntr,0],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx3,0],psym=4,color=255+(256*0)+(150*256),thick=3
plots,[indx4,0],psym=4,color=255+(256*0)+(150*256),thick=3

if ((*global).realign_plot EQ 1) then begin

    image_remap_nt_nx_ny = (*(*global).remap_histo)
    oplot, image_remap_nt_nx_ny[Nt,*,tube_number]
    oplot, image_remap_nt_nx_ny[Nt,*,tube_number],psym=1,color=255+(256*50)+(150*256)
    
endif
    
end








pro  draw_tube_pixels_base_eventcb, Event

;get the global data structure
id=widget_info(event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).nexus_open EQ 1) then begin

    image1 = (*(*global).image_nt_nx_ny)
    histo_plot_tubes_pixels, Event
    PLOT_HISTO_FILE, Event, image1

    nt_histo_draw_tube_pixels_slider_id = $
      widget_info(Event.top,find_by_uname='nt_histo_draw_tube_pixels_slider')
    widget_control, nt_histo_draw_tube_pixels_slider_id, set_slider_max=(*global).Nt-1

endif

end







;--------------------------------------------------------------------------------
pro plot_mapped_data, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate initialization with hourglass icon
widget_control,/hourglass

;remove sensibility on button
plot_mapped_data_id = widget_info(Event.top, find_by_uname='plot_mapped_data')
widget_control, plot_mapped_data_id, sensitive=0

;show processing base
processing_base_id = widget_info(Event.top,$
                                 find_by_uname='processing_base')
widget_control, processing_base_id, map=1

text = ''
output_into_log_book, event,text

text="Realign and plot data..."
output_into_general_infos, event, text
text="Realign data..."
output_into_log_book, event,text

i1=(*(*global).i1)
i2=(*(*global).i2)
i3=(*(*global).i3)
i4=(*(*global).i4)
i5=(*(*global).i5)

len1 = (*(*global).len1)
len2 = (*(*global).len2)

Npix = (*global).Nx
Ntubes = (*global).Ny_scat
mid = Npix/2              
Nt = (*global).Nt

text = '* Npix: ' + strcompress(Npix)
output_into_log_book, event,text
text = '* Ntubes: '+ strcompress(Ntubes)
output_into_log_book, event,text
text = '* Nt: ' + strcompress(Nt)
output_into_log_book, event,text

Npad = 10
pad = lonarr(Npad)

image_2d_1 = (*(*global).image_2d_1)
image_nt_nx_ny = (*(*global).image_nt_nx_ny)

;Define Ranges of tube responses
    
;first tube in the pair
t0 = 2
t1 = 61
length_tube0 = t1 - t0
    
;second tube in the pair
t2 = 66
t3 = 125
length_tube1 = t3 - t2

;new remap array(Npix, Ntubes) and remap_histo(Nt, Npix, Ntubes)
;remap = dblarr(Npix,Ntubes)     ;Nx=128, Ny=64
remap_histo = intarr(Nt, Npix, Ntubes) 
temp_remap_histo = intarr(Npix,Ntubes)

del = lonarr(5)

tube_removed = (*(*global).tube_removed)

error_status = 0 
;CATCH, error_status

if (error_status NE 0) then begin
    
    text="ERROR !"
    output_into_general_infos, event, text
    output_into_log_book, event,text
    
    text="Warning ! Objects plotted are messier than they appear!"
    output_into_general_infos, event, text
    output_into_log_book, event,text
    
endif else begin
    
    for i=0,Ntubes-1 do begin
        
        if (tube_removed[i] EQ 0) then begin

            tube_pair = image_2d_1[*,i]
            tube_pair_pad = [pad,tube_pair,pad] ;lonarr of 147 elements
            
            indx_cntr = 64+Npad ;74            
            
;cntr offset relative to cntr
            cntr_offset = indx_cntr - (Npad+i5[i]) ;74 - (10 + cntr) 
            
;dial out center offset
            tube_pair_pad_shft = shift(tube_pair_pad,cntr_offset)
            
;REMAP TUBE0
;remap tube end data
            len_meas_tube0 = i2[i] - i1[i] ;DAS length of first tube
            
;remap (rebin) tube0 data 
;size of DAS_length of first tube
            d0 = float(length_tube0) * findgen(len_meas_tube0)/(len_meas_tube0) + t0 
            
;remap (rebin) first part of tube (less than i2) (junk)
            if (i1[i] EQ 0) then i1[i]=1
            d0_0 = findgen(i1[i])/(i1[i])*t0
            
;remap (rebin) tube end data (junk)
            d0_1 = float(mid-t1)*findgen((i5[i]-i2[i]))/((i5[i]-i2[i])) + t1
;new tube remapped
            tube0_new = [d0_0,d0,d0_1]
            mn0 = min(d0)       ;always 2
            mx0 = min([max(d0),Npix-1]) ;max(d0) or 127 

            del0 = 59
            del[0] = del0
            rindx1 = indgen(del0)+mn0
            rindx_0 = rindx1

;;            dat = congrid(image_2d_1[i1[i]:i2[i],i],del0,/interp)
;;            remap[rindx1,i] = dat ;new array of the middle section

;remap endpoints and middle section
;one end
            mn0 = min(d0_0)     ; always 0
            mx0 = min([max(d0_0),Npix-1]) ; always max(d0_0)

            del0 = fix(mx0 - mn0) + 1
            del[1] = del0
            rindx0 = indgen(2)
            rindx_1 = rindx0

;            dat = congrid(image_2d_1[0:i1[i],i],del0,/interp)
;            scl = float(2)/i1[i]
;            remap[rindx0,i] = dat * scl
            
;finally the middle
            mn0 = t1+1
            mx0 = t2-1

            del0 = (mx0 - mn0) + 1
            del[2] = del0
            rindx0 = indgen(del0)+mn0
            rindx_2 = rindx0

 ;           dat = congrid(image_2d_1[i2[i]:i3[i],i],del0,/interp)
 ;           scl = float(del0)/(i3[i] - i2[i])
 ;           remap[rindx0,i] = dat * scl
;REMAP TUBE1
            
;remap tube1 data
            len_meas_tube1 = i4[i] - i3[i]
            d1 = $
              float(length_tube1) * findgen(len_meas_tube1)/(len_meas_tube1-1) + t2
            
;remap tube start data (junk)
            d1_0 = $
              abs(float(t2 - i5[i]))*findgen(abs(i3[i]-i5[i]))/(i3[i]-i5[i]+1) + mid
            
;remap tube end data
            d1_1 = float(Npix-t3)*findgen(Npix-i4[i])/(Npix-i4[i]+1) + (t3+1)
            
;now the other tube end
            mn0 = min(d1_1)
            mx0 = min([max(d1_1),Npix-1])

            del0 = (mx0 - mn0) + 1
            del[3] = del0
            rindx0 = indgen(del0)+mn0
            rindx_3 = rindx0
            
;            dat = congrid(image_2d_1[i4[i]:*,i],del0,/interp)
;            scl = float(del0)/(Npix-i4[i])
;            remap[rindx0,i] = dat * scl

            mn1 = min(d1)
            mx1 = min([max(d1),Npix-1])

            del1 = mx1 - mn1 + 1
            del[4] = del1
            rindx1 = indgen(del1)+mn1
            rindx_4 = rindx1

;            dat = congrid(image_2d_1[i3[i]:i4[i],i],del1,/interp)
;            remap[rindx1,i] = dat
            

            processing_draw_id = $
              widget_info(Event.top,find_by_uname='processing_draw_id')
                
            temp_histo_dat = intarr(Npix,Ntubes)
            
            for j=0,(Nt-1) do begin

                temp_histo_dat(*,*) = image_nt_nx_ny[j,*,*]
                temp_histo_dat = reverse_array(temp_histo_dat)

;linear interpolation
                if ((*global).linear_interpolation EQ 1) then begin 

                    remap_histo[j,rindx_0,i] = $
                      congrid(temp_histo_dat[i1[i]:i2[i],i],del[0],/interp)
                    
                    remap_histo[j,rindx_1,i] = $
                      congrid(temp_histo_dat[0:i1[i],i],del[1],/interp) * $
                      float(2)/i1[i]
                    
                    remap_histo[j,rindx_2,i] = $
                      congrid(temp_histo_dat[i2[i]:i3[i],i],del[2],/interp) * $
                      (float(del[2])/(i3[i]-i2[i]))
                    
                    remap_histo[j,rindx_3,i] = $
                      congrid(temp_histo_dat[i4[i]:*,i],del[3],/interp) * $
                      (float(del[3])/(Npix-i4[i]))
                    
                    remap_histo[j,rindx_4,i] = $
                      congrid(temp_histo_dat[i3[i]:i4[i],i],del[4],/interp)

                endif else begin  ;nearest-neighbor sampling

                    remap_histo[j,rindx_0,i] = $
                      congrid(temp_histo_dat[i1[i]:i2[i],i],del[0])
                    
                    remap_histo[j,rindx_1,i] = $
                      congrid(temp_histo_dat[0:i1[i],i],del[1]) * $
                      float(2)/i1[i]
                    
                    remap_histo[j,rindx_2,i] = $
                      congrid(temp_histo_dat[i2[i]:i3[i],i],del[2]) * $
                      (float(del[2])/(i3[i]-i2[i]))
                    
                    remap_histo[j,rindx_3,i] = $
                      congrid(temp_histo_dat[i4[i]:*,i],del[3]) * $
                      (float(del[3])/(Npix-i4[i]))
                    
                    remap_histo[j,rindx_4,i] = $
                      congrid(temp_histo_dat[i3[i]:i4[i],i],del[4])

                endelse

            endfor
            
                                ;evaluate size of processing bar
            size_coeff = float(i)/(Ntubes-1)
            size_bar = 220*size_coeff
            processing_draw_id = widget_info(Event.top,$
                                             find_by_uname='processing_draw')
            widget_control, processing_draw_id, scr_xsize=size_bar
            processing_label_id = widget_info(Event.top, $
                                              find_by_uname='processing_label')
            text = 'Processing...... ' 
            pro_percentage = fix(size_coeff*100)
            text += strcompress(pro_percentage,/remove_all)
            text += '%'
            widget_control, processing_label_id, $
              set_value=text
            
        endif
        
    endfor
    
    size_bar = 220
    processing_draw_id = widget_info(Event.top,$
                                     find_by_uname='processing_draw')
    widget_control, processing_draw_id, scr_xsize=size_bar
    processing_label_id = widget_info(Event.top, $
                                      find_by_uname='processing_label')
    text = 'Processing...... 100%' 
    widget_control, processing_label_id, $
      set_value=text

    text = '...done'
    output_into_log_book, event,text
    
    (*(*global).remap_histo) = remap_histo
    (*global).realign_plot = 1

    text = 'Plot data...'
    output_into_log_book, event,text
    
;    print, "before plot_realign_data"
;    help, /memory
    plot_realign_data, Event, remap_histo
;    print, "After plot_realign_data"
;    help, /memory

    text = '...done'
    output_into_log_book, event,text
    
endelse

text="...done"
output_into_general_infos, event, text

widget_control, processing_base_id, map=0
;processing_draw_id = widget_info(Event.top,$
;                                 find_by_uname='processing_draw')
widget_control, processing_draw_id, scr_xsize=1
;processing_label_id = widget_info(Event.top, $
;                                  find_by_uname='processing_label')
text = 'Processing......0%' 
widget_control, processing_label_id, $
  set_value=text

widget_control, plot_mapped_data_id, sensitive=1

output_new_histo_mapped_file, Event, remap_histo

;turn off hourglass
widget_control,hourglass=0

end




pro create_local_copy_of_histo_mapped, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_nexus_name = (*global).full_nexus_name

cmd_dump = "nxdir " + full_nexus_name
cmd_dump_top = cmd_dump + " -p /entry/bank1/data/ --dump "
cmd_dump_bottom = cmd_dump + " -p /entry/bank2/data/ --dump "

;get name of output_file
tmp_output_file = (*global).full_tmp_nxdir_folder_path 
tmp_output_file += "/BSS"
tmp_output_file += "_" + strcompress((*global).run_number,/remove_all)

tmp_output_file_top = tmp_output_file + "_top.dat"
tmp_output_file_bottom = tmp_output_file + "_bottom.dat"
(*global).file_to_plot_top = tmp_output_file_top
(*global).file_to_plot_bottom = tmp_output_file_bottom

cmd_dump_top += tmp_output_file_top 
cmd_dump_bottom += tmp_output_file_bottom

;display command
text = 'Create binary file of data from top bank:'
output_into_log_book, event, text
text= cmd_dump_top
output_into_log_book, event, '> ' + text
spawn, cmd_dump_top, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

text = 'Create binary file of data from bottom bank:'
output_into_log_book, event, text
text= cmd_dump_bottom
output_into_log_book, event, '> ' + text
spawn, cmd_dump_bottom, listening
output_into_log_book, event, listening
output_error, event, err_listening

end


pro rebinGUI_button_eventcb, Event

spawn, '/SNS/users/j35/IDL/RebinNeXus/rebinBSSNeXus &'

end






pro display_interactive_window, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

interactive_cmd_line_base_id = $
  widget_info(Event.top, find_by_uname='interactive_cmd_line_base')
widget_control, interactive_cmd_line_base_id, map=1

end









pro interactive_ok_button_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;remove interactive window
interactive_cmd_line_base_id = $
  widget_info(Event.top, find_by_uname='interactive_cmd_line_base')
widget_control, interactive_cmd_line_base_id, map=0

;refresh map_data
plot_realign_data, Event, (*(*global).remap_histo)

path_to_preNeXus = (*global).path_to_preNeXus
full_output_file_name = (*global).full_output_file_name
full_output_folder_name = (*global).full_output_folder_name
working_path = (*global).working_path

;copy data
files_to_copy = ["*.xml","*.nxt"]
for i=0,1 do begin
    cmd_copy = "cp " + path_to_preNeXus + files_to_copy[i] + " " + $
      full_output_folder_name
    text = ' >' + cmd_copy
    output_into_log_book, event, text
    spawn, cmd_copy, listening, err_listening
    output_into_log_book, event, listening
    output_error, event, err_listening
endfor

run_number = (*global).run_number

; full_output_folder_name + "BSS_" + run_number + "_neutron_timemap.dat"

; full_nexus_name = (*global).full_nexus_name
; cmd_nxdir = "nxdir " + full_nexus_name
; cmd_nxdir += " -p /entry/bank1/time_of_flight -o"
; print, "cmd_nxdir: " + cmd_nxdir

; spawn, cmd_nxdir, listening, error_listening

;retrieve Create_tbin_file command
interactive_create_tbin_file_text_id = $
  widget_info(Event.top,$
              find_by_uname='interactive_create_tbin_file_text')
widget_control, interactive_create_tbin_file_text_id, get_value=cmd
text = ' >' + cmd
output_into_log_book, event, text
spawn, cmd, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;import geometry and mapping file into same directory
cmd_copy = "cp " + (*global).mapping_file 
cmd_copy += " " + (*global).geometry_file
cmd_copy += " " + full_output_folder_name

text = ' >' + cmd_copy
output_into_log_book, event, text
spawn, cmd_copy, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;merge files
cmd_merge = "TS_merge_preNeXus.sh " + (*global).translation_file
cmd_merge += " " + full_output_folder_name

text = ' >' + cmd_merge
output_into_log_book, event, text
spawn, cmd_merge, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;create nexus file
cd, (*global).full_output_folder_name

cmd_translate = "nxtranslate " + full_output_folder_name
cmd_translate += "/BSS_" + strcompress(run_number,/remove_all)
cmd_translate += ".nxt"

text = ' >' + cmd_translate
output_into_log_book, event, text
spawn, cmd_translate, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;create nexus folder and copy nexus file into new folder
path_up_to_proposal_number = (*global).path_up_to_proposal_number

path_up_to_nexus_folder = path_up_to_proposal_number + "/NeXus"
cmd_nexus_folder = "mkdir -p " + path_up_to_nexus_folder

text = ' >' + cmd_nexus_folder
output_into_log_book, event, text
spawn, cmd_nexus_folder, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

name_of_nexus_file = full_output_folder_name + "/BSS_" 
name_of_nexus_file += strcompress(run_number,/remove_all)
name_of_nexus_file += ".nxs"

cmd_copy = "mv " + name_of_nexus_file + " " + path_up_to_nexus_folder

full_nexus_filename = path_up_to_nexus_folder + "/BSS_" 
full_nexus_filename += strcompress(run_number,/remove_all)
text=" Name of NeXus file: " + full_nexus_filename
output_into_log_book, event, text

spawn, cmd_copy, listening, err_listening
output_into_log_book, event, listening
output_error, event, err_listening

;create_offset_xml_file, Event

text="...done"
output_into_general_infos, event, text

end




pro interactive_cancel_button_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

interactive_cmd_line_base_id = $
  widget_info(Event.top, find_by_uname='interactive_cmd_line_base')
widget_control, interactive_cmd_line_base_id, map=0

;refresh map_data
plot_realign_data, Event, (*(*global).remap_histo)

end





pro nt_display_configure_button_eventcb, Event


;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

nt_display_configure_base_id = $
  widget_info(Event.top,find_by_uname='nt_display_configure_base')
widget_control, nt_display_configure_base_id, map=1

end




pro nt_display_configure_validate_eventcb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

nt_display_configure_base_id = $
  widget_info(Event.top,find_by_uname='nt_display_configure_base')
widget_control, nt_display_configure_base_id, map=0	

nt_id = widget_info(Event.top, find_by_uname='nt_histo_draw_tube_pixels_slider')
widget_control, nt_id, get_value=Nt

;retrieve value of time_offset, time_bin and time_max
nt_display_time_offset_text_id = $
  widget_info(Event.top,find_by_uname='nt_display_time_offset_text')
widget_control, nt_display_time_offset_text_id, get_value=time_offset

nt_display_time_bin_text_id = $
  widget_info(Event.top,find_by_uname='nt_display_time_bin_text')
widget_control, nt_display_time_bin_text_id, get_value=time_bin

;nt_display_max_time_text_id = $
;      widget_info(Event.top,find_by_uname='nt_display_max_time_text')
;widget_control, nt_display_max_time_text_id, get_value=time_max

bin_min = long(float(Nt)*float(time_bin) + float(time_offset))
bin_max = long(float(Nt+1)*float(time_bin) + float(time_offset))
text = strcompress(bin_min) + '-' + strcompress(bin_max) + ' microS'

nt_display_configure_label_id = $
  widget_info(Event.top,find_by_uname='nt_display_configure_label')
widget_control, nt_display_configure_label_id, set_value=text[0]

end




pro create_offset_xml_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

i1=(*(*global).i1)
i2=(*(*global).i2)
i3=(*(*global).i3)
i4=(*(*global).i4)
i5=(*(*global).i5)

len1 = (*(*global).len1)
len2 = (*(*global).len2)

tube_removed = (*(*global).tube_removed)
Npix = (*global).Nx
Ntubes = (*global).Ny_scat

path_up_to_prenexus = (*global).path_up_to_proposal_number + '/preNeXus/'
run_number = (*global).run_number
xml_offset_extension = (*global).xml_offset_extension
xml_offset_filename = 'BSS_' + strcompress(run_number,/remove_all) $
  + xml_offset_extension
full_xml_offset_filename = path_up_to_prenexus + xml_offset_filename

;display infos
text="Create offset file..."
output_into_general_infos, event, text
text="Create offset XML file:"
output_into_log_book, event, text
text = 'xml offset file: ' + full_xml_offset_filename
output_into_log_book, event, text

nbr_xml_lines = 3+4+(6*Ntubes)
lines = strarr(nbr_xml_lines)
;xml framework

lines[0] = '<?xml version="1.0"?>'
lines[1] = '<Instrument name="BSS" valid="true" version="3.0">'
j=2
for i=0,(Ntubes-1) do begin

    case i of
        0: begin
            lines[j] = ' <bank number="1">'
            ++j
            bank=1
        end
        32: begin
            lines[j] = ' <bank number="2">'
            ++j
            bank=2
        end
        else:
    endcase

    offset_text_array = produce_pixels_offset(i1[i],i2[i],i3[i],i4[i],i5[i],tube_removed[i],bank)

;    lines[j] = offset_text
;    ++j

    lines[j] = '  <tube number="' + strcompress(2*i,/remove_all) + $
      '" units="metre" type="Float64">'
    ++j

    lines[j] = offset_text_array[0]
    ++j

    lines[j] = '  </tube>'
    ++j

    lines[j] = '  <tube number="' + strcompress(2*i+1,/remove_all) + $
      '" units="metre" type="Float64">'
    ++j

    lines[j] = offset_text_array[1]
    ++j

    lines[j] = '  </tube>'
    ++j

    case i of
        31: begin
            lines[j] = ' </bank>'
            ++j
        end
        63: begin
            lines[j] = ' </bank>'
            ++j
        end
        else:
    endcase
    
endfor

lines[j] = '</Instrument>'
++j

nbr_xml_lines = j

text="...done"
output_into_general_infos, event, text

write_xml_file, Event, full_xml_offset_filename, lines, nbr_xml_lines

;;just for debugging - remove_me after debugging phase
;write_i_file, Event, '/SNS/users/j35/BSS_60_indeces.txt', i1,i2,i3,i4,i5, Ntubes
end






pro write_xml_file, Event, full_xml_offset_filename, lines, nbr_lines

openu, 1,full_xml_offset_filename,/append
for i=0,(nbr_lines-1) do begin
    printf,1, lines[i]
endfor

;close it up...
close,1
free_lun,1

end





pro write_i_file, Event, file_name, i1,i2,i3,i4,i5, Ntubes

openu, 1,file_name,/append
for i=0,(Ntubes-1) do begin
    text = 'tube # ' + strcompress(i) + '   i1: ' + strcompress(i1[i])
    text += ' i2: ' + strcompress(i2[i])
    text += ' i3: ' + strcompress(i3[i])
    text += ' i4: ' + strcompress(i4[i])
    text += ' i5: ' + strcompress(i5[i])
    printf,1, text
endfor

;close it up...
close,1
free_lun,1

end
