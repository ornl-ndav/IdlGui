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







pro create_local_copy_of_histo_mapped, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_nexus_name = (*global).full_nexus_name

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')

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

text= cmd_dump_top
widget_control, view_info, set_value=text, /append
text= "Processing....."
widget_control, view_info, set_value=text, /append
spawn, cmd_dump_top, listening

text= cmd_dump_bottom
widget_control, view_info, set_value=text, /append
text= "Processing....."
widget_control, view_info, set_value=text, /append

spawn, cmd_dump_bottom, listening

;display result of command
;text= listening
text="Done"
widget_control, view_info, set_value=text, /append

end









pro create_tmp_folder, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
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
look_up=lonarr((*global).Nx,(*global).Ny_scat)
for tube=0,31 do begin
    for pixel=0,63 do begin
        look_up[pixel,tube]=(63-pixel)+tube*128
    endfor
    for pixel=64,127 do begin
        look_up[pixel,tube]=pixel+tube*128
    endfor
endfor

for tube=32,63 do begin
    for pixel=0,63 do begin
        look_up[pixel,tube]=(pixel+tube*128)
    endfor
    for pixel=64,127 do begin
        look_up[pixel,tube]=(191-pixel)+tube*128
    endfor
endfor

(*(*global).look_up) = look_up

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

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

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

if ((*global).swap_endian EQ 1) then begin
    
    image1=swap_endian(image1)
    diff=swap_endian(diff)
    text = "true"
    
endif else begin
    
    text = "false"
    
endelse

text1 = "  - Swap endian : " + text
WIDGET_CONTROL, view_info, SET_VALUE=text1, /APPEND

text = "  - Number of Tbins : " + strcompress(Nt,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

PLOT_HISTO_FILE, Event, image1

end




pro PLOT_HISTO_FILE, Event, image1

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

image_2d_1 = total(image1,1)

tmp = image_2d_1[0:63,0:31]
tmp = reverse(tmp,1)
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

draw_info= widget_info(Event.top, find_by_uname='map_plot_draw')
widget_control, draw_info, get_value=draw_id
wset, draw_id
erase

ctool_id = widget_info(Event.top, find_by_uname='CTOOL_MENU_realign')
widget_control, ctool_id, sensitive=0

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










;--------------------------------------------------------------------------------
pro plot_mapped_data, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text="Plotting mapped data....."
widget_control, view_info, set_value=text,/append

i1=(*(*global).i1)
i2=(*(*global).i2)
i3=(*(*global).i3)
i4=(*(*global).i4)
i5=(*(*global).i5)

len1 = (*(*global).len1)
len2 = (*(*global).len2)

Npix = (*global).Nx
Ntubes = (*global).Ny_scat
mid = Npix/2                    ;64

Npad = 10
pad = lonarr(Npad)

image_2d_1 = (*(*global).image_2d_1)

;Define Ranges of tube responses
    
;first tube in the pair
t0 = 2
t1 = 61
length_tube0 = t1 - t0
    
;second tube in the pair
t2 = 66
t3 = 125
length_tube1 = t3 - t2

;new remap array(Npix, Ntubes)
remap = dblarr(Npix,Ntubes)     ;Nx=128, Ny=64

tube_removed = (*(*global).tube_removed)

error_status = 0 ;remove_me
CATCH, error_status

if (error_status NE 0) then begin

    text="ERROR !"
    widget_control, view_info, set_value=text,/append
    text="Warning ! Objects plotted are messier than they appear!"
    widget_control, view_info, set_value=text,/append

endif else begin

for i=0,Ntubes-1 do begin

    if (tube_removed[i] EQ 0) then begin

        tube_pair = image_2d_1[*,i]
        tube_pair_pad = [pad,tube_pair,pad] ;lonarr of 147 elements
        
        indx_cntr = 64+Npad     ;74            
        
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
        d0_0 = findgen(i1[i])/(i1[i])*t0

;remap (rebin) tube end data (junk)
        d0_1 = float(mid-t1)*findgen((i5[i]-i2[i]))/((i5[i]-i2[i])) + t1
;new tube remapped
        tube0_new = [d0_0,d0,d0_1]
        mn0 = min(d0)                     ;always 2
        mx0 = min([max(d0),Npix-1])       ;max(d0) or 127 
        del0 = 59
;        rindx1 = indgen(del0-1)+mn0
        rindx1 = indgen(del0)+mn0
;        dat = congrid(image_2d_1[i1[i]:i2[i],i],del0-1,/interp) ;steve
;        dat = congrid(image_2d_1[i1[i]:i2[i],i],del0,/interp)   ;jean
        dat = congrid(image_2d_1[i1[i]:i2[i],i],del0,/interp)
        remap[rindx1,i] = dat   ;new array of the middle section
;remap endpoints and middle section
;one end
        mn0 = min(d0_0)                   ; always 0
        mx0 = min([max(d0_0),Npix-1])     ; always max(d0_0)
        del0 = fix(mx0 - mn0) + 1

;        rindx0 = indgen(del0)+mn0
        rindx0 = indgen(2)

        dat = congrid(image_2d_1[0:i1[i],i],del0,/interp)
        
        scl = float(2)/i1[i]
        remap[rindx0,i] = dat * scl
        
;finally the middle
        mn0 = t1+1
        mx0 = t2-1
        del0 = (mx0 - mn0) + 1
        rindx0 = indgen(del0)+mn0
        dat = congrid(image_2d_1[i2[i]:i3[i],i],del0,/interp)
        scl = float(del0)/(i3[i] - i2[i])
        remap[rindx0,i] = dat * scl
        
;REMAP TUBE1
        
;remap tube1 data
        len_meas_tube1 = i4[i] - i3[i]
        d1 = float(length_tube1) * findgen(len_meas_tube1)/(len_meas_tube1-1) + t2
        
;remap tube start data (junk)
        d1_0 = abs(float(t2 - i5[i]))*findgen(abs(i3[i]-i5[i]))/(i3[i]-i5[i]+1) + mid
        
;remap tube end data
        d1_1 = float(Npix-t3)*findgen(Npix-i4[i])/(Npix-i4[i]+1) + (t3+1)
        
;now the other tube end
        mn0 = min(d1_1)
        mx0 = min([max(d1_1),Npix-1])
        del0 = (mx0 - mn0) + 1
        rindx0 = indgen(del0)+mn0
        dat = congrid(image_2d_1[i4[i]:*,i],del0,/interp)
        scl = float(del0)/(Npix-i4[i])
        remap[rindx0,i] = dat * scl
        
        mn1 = min(d1)
        mx1 = min([max(d1),Npix-1])
        del1 = mx1 - mn1 + 1
        rindx1 = indgen(del1)+mn1
        dat = congrid(image_2d_1[i3[i]:i4[i],i],del1,/interp)
        remap[rindx1,i] = dat

    endif

endfor

(*(*global).remap) = remap
plot_realign_data, Event

endelse

end







;----------------------------------------------------------------
pro plot_realign_data, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')

Ntubes = (*global).Ny_scat
Npix = (*global).Nx
remap = (*(*global).remap)

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

text="DONE"
widget_control, view_info, set_value=text,/append

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
pro IDENTIFICATION_GO_cb, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

text_id=widget_info(Event.top, FIND_BY_UNAME='IDENTIFICATION_TEXT')
WIDGET_CONTROL, text_id, GET_VALUE=character_id
(*global).character_id = character_id

;check 3 characters id
ucams=(*global).ucams


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

if (name EQ '') then begin

;put a message saying that it's an invalid 3 character id

   error_message = "INVALID UCAMS"
   view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_LEFT')
   WIDGET_CONTROL, view_id, set_value= error_message	
   view_id = widget_info(Event.top,FIND_BY_UNAME='ERROR_IDENTIFICATION_RIGHT')
   WIDGET_CONTROL, view_id, set_value= error_message	

endif else begin

   (*global).name = name
   working_path = (*global).working_path

   ;working path is set
   CATCH, change_directory

   if (change_directory ne 0) then begin ;there is a problem with the permission

       view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
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
       view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
       WIDGET_CONTROL, view_id, base_set_title= welcome	
       
       view_id = widget_info(Event.top,FIND_BY_UNAME='IDENTIFICATION_BASE')
       WIDGET_CONTROL, view_id, destroy=1
       
                                ;activate open_mapped_histo
       view_id = widget_info(Event.top,FIND_BY_UNAME='OPEN_MAPPED_HISTOGRAM')
       WIDGET_CONTROL, view_id, sensitive=1
       
;   view_id = widget_info(Event.top,FIND_BY_UNAME='OUTPUT_PATH_NAME')
;   WIDGET_CONTROL, view_id, set_value=working_path
       
       
;    view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
;    text = "LOGIN parameters:"
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "User id           : " + ucams
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "Name              : " + name
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "Working directory : " + working_path
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
       
                                ;only for administrator 
       if (ucams EQ 'j35') then begin
           
           id = widget_info(Event.top, find_by_uname='OPEN_NEXUS_menu')
           widget_control, id, sensitive=1
           
       endif 
       
;create temporary folder for nxdir
       create_tmp_folder, Event
       
   endelse

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

path_to_findnexus = "~/SVN/ASGIntegration/trunk/utilities/"
cmd = path_to_findnexus + "findnexus -iBSS " + $
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

; get path to NeXus file
path_to_preNeXus = get_path_to_prenexus(run_number)

;remove last part of path_name (to get only the path)
string_to_remove = "BSS_"+strcompress(run_number,/remove_all)+"_cvinfo.xml"
path=strsplit(path_to_preNeXus,string_to_remove,/regex,/extract)
path_to_preNeXus=path[0]
(*global).path_to_preNeXus = path_to_preNeXus

;get proposal number
proposal_number_array=strsplit(path_to_preNeXus,'/',/regex,/extract)
proposal_number = proposal_number_array[2]
(*global).proposal_number = proposal_number

; create inst_run# folder into own space
working_path = (*global).working_path
folder_to_create = "BSS/" + proposal_number + "/" + $
  strcompress(run_number,/remove_all) 

(*global).path_up_to_proposal_number = working_path + folder_to_create

folder_to_create += "/preNeXus"

full_folder_name_to_create = working_path + folder_to_create
(*global).full_output_folder_name  = full_folder_name_to_create
cmd_check = "ls -d " + full_folder_name_to_create
spawn, cmd_check, listening

if (listening NE '') then begin
;remove it
    cmd_remove = 'rm -r '+ full_folder_name_to_create
    spawn, cmd_remove
endif

cmd = "mkdir -p " + full_folder_name_to_create
spawn, cmd

end






;--------------------------------------------------------------------------
pro output_new_histo_mapped_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;determine name of output file according to input file
file = (*global).file

file_name_only = get_file_name_only(file)
working_path = (*global).working_path
;output_file_name = modified_file_name(Event, file_name_only)
output_file_name = file_name_only

;create folder that will contain output_remapped file
create_output_folder, Event

run_number = (*global).run_number
full_output_folder_name = (*global).full_output_folder_name

full_output_file_name = full_output_folder_name + "/" + output_file_name
(*global).full_output_file_name = full_output_file_name
(*global).full_output_folder_name = full_output_folder_name

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = "Create output histogram file: " + full_output_file_name
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

data = (*(*global).remap)
;add 8*128 '0' of the diffraction tube to have same format of histo
;files

output_data = lonarr(128L,72L)
output_data(*,0:63L) = data(*,*)

look_up = (*(*global).look_up)

reorder_data, Event, output_data
new_output_data = (*(*global).reorder_array)

reshape_data = lonarr(64L,144L)
reshape_data(*,*)=new_output_data

;write out data
openw,u1,full_output_file_name,/get
writeu,u1,new_output_data

;close it up...
close,u1
free_lun,u1

text = "...Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

create_nexus_file, Event

end






;-------------------------------------------------------------------------
pro create_nexus_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

path_to_preNeXus = (*global).path_to_preNeXus
full_output_file_name = (*global).full_output_file_name
full_output_folder_name = (*global).full_output_folder_name
working_path = (*global).working_path

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text="Create NeXus file....."
widget_control, view_info, set_value=text,/append

;copy data
files_to_copy = ["*.xml","*.nxt"]
for i=0,1 do begin
    cmd_copy = "cp " + path_to_preNeXus + files_to_copy[i] + " " + $
      full_output_folder_name
    spawn, cmd_copy
endfor


run_number = (*global).run_number
;create timemap file "Create_Tbin_file -l 150000 -M 150000 -o
; full_output_folder_name + "BSS_" + run_number + "_neutron_timemap.dat"
cmd = "Create_Tbin_File -l 150000 -M 150000 -o "
cmd += full_output_folder_name + "/BSS_" + $
  strcompress(run_number,/remove_all)
cmd += "_neutron_timemap.dat"

spawn, cmd

;import geometry and mapping file into same directory
cmd_copy = "cp " + (*global).mapping_file 
cmd_copy += " " + (*global).geometry_file
cmd_copy += " " + full_output_folder_name

spawn, cmd_copy

;merge files
cmd_merge = "TS_merge_preNeXus.sh " + (*global).translation_file
cmd_merge += " " + full_output_folder_name

spawn, cmd_merge

;create nexus file
cd, (*global).full_output_folder_name

cmd_translate = "nxtranslate " + full_output_folder_name
cmd_translate += "/BSS_" + strcompress(run_number,/remove_all)
cmd_translate += ".nxt"

spawn, cmd_translate

;create nexus folder and copy nexus file into new folder
path_up_to_proposal_number = (*global).path_up_to_proposal_number

path_up_to_nexus_folder = path_up_to_proposal_number + "/NeXus"
cmd_nexus_folder = "mkdir -p " + path_up_to_nexus_folder
spawn, cmd_nexus_folder

name_of_nexus_file = full_output_folder_name + "/BSS_" 
name_of_nexus_file += strcompress(run_number,/remove_all)
name_of_nexus_file += ".nxs"

cmd_copy = "mv " + name_of_nexus_file + " " + path_up_to_nexus_folder

full_nexus_filename = path_up_to_nexus_folder + "/BSS_" 
full_nexus_filename += strcompress(run_number,/remove_all)
text="Name of NeXus file: " + full_nexus_filename
widget_control, view_info, set_value=text,/append

spawn, cmd_copy

text="Done"
widget_control, view_info, set_value=text,/append

end












;--------------------------------------------------------------------------
pro reorder_data, Event, data

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Nx=(*global).Nx
Ny=(*global).Ny_scat
Ny_diff=(*global).Ny_diff

look_up=(*(*global).look_up)

size_reorder_array = (Nx * (Ny + (*global).Ny_diff))
reorder_pixelids = lonarr(size_reorder_array)

for i=0,Nx-1 do begin
    for j=0,Ny-1 do begin
        reorder_pixelids(look_up(i, j))=data(i,j)
    endfor
endfor

(*(*global).reorder_array) = reorder_pixelids

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

pro OPEN_NEXUS, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

(*global).file_type='nexus'

;indicate initialization with hourglass icon
widget_control,/hourglass

;initialized arrays
initialization_of_arrays, Event

;hide open_nexus interface
open_nexus_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_NEXUS_BASE')
widget_control, open_nexus_id, map=0

;retrieve run_number
run_number_id = widget_info(Event.top, FIND_BY_UNAME='OPEN_RUN_NUMBER_TEXT')
widget_control, run_number_id, get_value=run_number

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')

if (run_number EQ '') then begin
    
    text = "!!! Please specify a run number !!! " + strcompress(run_number,/remove_all)
    WIDGET_CONTROL, view_info, SET_VALUE=text,/append
    
endif else begin
    
    (*global).run_number = run_number
    
    text = "Opening NeXus file # " + strcompress(run_number,/remove_all) + "....."
    WIDGET_CONTROL, view_info, SET_VALUE=text
    
;get path to nexus run #
    instrument="BSS"
    full_nexus_name = find_full_nexus_name(Event, run_number, instrument)

;check result of search
    find_nexus = (*global).find_nexus
    if (find_nexus EQ 0) then begin
        text_nexus = "Warning! NeXus file does not exist"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
    endif else begin
        (*global).full_nexus_name = full_nexus_name
        text_nexus = "(" + full_nexus_name + ")"
        WIDGET_CONTROL, view_info, SET_VALUE=text_nexus,/append
        
;dump binary data of NeXus file into tmp_working_path
        create_local_copy_of_histo_mapped, Event
        
;read and plot nexus file
        READ_NEXUS_FILE, Event

;procedure to enable most of the buttons/text boxes..
        ENABLED_PROCEDURE, Event
        
        generate_look_up_table_of_real_pixelid_value, Event

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

(*(*global).tube_removed) = removed_tube
run_number = (*global).run_number

;reinitialize DATA_REMOVED box
refresh_data_removed_text, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = "- Opening and Reading run # " + strcompress(run_number,/remove_all)
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

file = "/BSS_" + strcompress(run_number, /remove_all)
file += "_neutron_histo_mapped.dat"
(*global).file = file

;global parameters
Nx = (*global).Nx
Ny_scat = (*global).Ny_scat
Ny_scat_bank = Ny_scat / 2

;opening top part
file_top = (*global).file_to_plot_top
openr,u,file_top,/get

fs=fstat(u)
file_size=fs.size

Nbytes = (*global).nbytes
N = long(file_size) / Nbytes    ;number of elements

Nt = long(N)/(long(Nx*(Ny_scat_bank)))
(*global).Nt = Nt
image_top = ulonarr(Nt, Nx, Ny_scat_bank)

readu,u,image_top
close,u

;opening bottom part
file_bottom = (*global).file_to_plot_bottom
openr,u,file_bottom,/get

fs=fstat(u)
file_size=fs.size

image_bottom = ulonarr(Nt, Nx, Ny_scat_bank)

readu,u,image_bottom
close,u

;combining image_top and image_bottom into image1

image1 = ulonarr(Nt,Nx,Ny_scat)
image1(*,*,0:Ny_scat_bank-1) = image_top
image1(*,*,Ny_scat_bank:Ny_scat-1) = image_bottom

PLOT_HISTO_FILE, Event, image1

text = "...done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

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

