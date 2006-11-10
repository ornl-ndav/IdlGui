;--------------------------------------------------------------------
function give_real_pixelid_value, Event, pixel_number, tube_number

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
        look_up[pixel,tube]=(63-pixel)+tube*128
    endfor
endfor

return, look_up[pixel_number,tube_number]

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






;---------------------------------------------------------------
;value=0 means do not removed 1 means removed me
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

print, "where(pixel_removed GT 0): ", where(pixel_removed GT 0)

    (*(*global).pixel_removed) = pixel_removed

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






;----------------------------------------------------------------------------
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;----------------------------------------------------------------------------
pro RealignGUI_eventcb
end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;----------------------------------------------------------------------------
pro MAIN_REALIZE, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$








;---------------------------------------------------------------------------
pro OPEN_MAPPED_HISTOGRAM, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tube_removed = lonarr((*global).Ny_scat)
(*(*global).tube_removed) = tube_removed
(*(*global).pixel_removed) = lonarr((*global).Ny_scat * (*global).Nx)
OPEN_FILE, Event

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;--------------------------------------------------------------------------------
pro OPEN_FILE, Event

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

spawn, "pwd",listening

if ((*global).path EQ '') then begin
   path = listening
endif else begin
   path = (*global).working_path
endelse

path = "/SNS/users/j35/" ;REMOVE_ME
file = dialog_pickfile(/must_exist,$
	title="Select a histogram file for BSS",$
	filter= (*global).filter_histo,$
	path = path,$
	get_path = path)

;check if there is really a file
if (file NE '') then begin

(*global).file = file

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')

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

PLOT_HISTO_FILE, Event

;enable background buttons/draw/text/labels
id_list=['reset_all_button',$
         'pixelid_new_counts_reset',$
         'save_changes_button',$
         'save_pixelid_changes_button',$
         'draw_tube_pixels_slider',$
         'pixels_slider',$
         'pixelid_new_counts_value',$
         'remove_tube_group',$
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

endif else begin

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = " No new file loaded "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

endelse

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;------------------------------------------------------------------------
pro PLOT_HISTO_FILE, Event

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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



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
;CATCH, error_status

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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






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
        text = strcompress(i) + ': ' + strcompress(image_2d_1[i,tube_number],/remove_all)
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;----------------------------------------------------------------------------
pro plot_tubes_pixels, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

remove_tube_group_id = widget_info(Event.top, $
                                   find_by_uname='remove_tube_group')
widget_control, remove_tube_group_id, set_value=1

slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



;----------------------------------------------------------------------------
;save tubes changes
pro save_changes, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

; 0 means tube has to be removed
; 1 means tube must stay in place
remove_tube_group_id = widget_info(Event.top, $
                                   find_by_uname='remove_tube_group')
widget_control, remove_tube_group_id, get_value=tube_removed_boolean

;value of actif tube
slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

tube_removed_array = (*(*global).tube_removed)

if (tube_removed_boolean EQ 0) then begin
    
    tube_removed_array[tube_number]=1

endif else begin

    tube_removed_array[tube_number]=0

endelse

(*(*global).tube_removed) = tube_removed_array

;update text box of tubes and pixel to be removed
refresh_data_removed_text, Event
refresh_pixel_removed_text, Event

(*global).new_tube = 1 
display_ix, Event, tube_number

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;-------------------------------------------------------------------
pro save_pixelid_changes, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;update number of counts for that pixel
image_2d_1 = (*(*global).image_2d_1)

pixel_slider_id = widget_info(Event.top, find_by_uname='pixels_slider')
widget_control, pixel_slider_id, get_value=pixel_number

new_pixel_counts_id = widget_info(Event.top, $
                                  find_by_uname='pixelid_new_counts_value')
widget_control, new_pixel_counts_id, get_value=new_pixel_counts

slider_id = widget_info(Event.top, find_by_uname='draw_tube_pixels_slider')
widget_control, slider_id, get_value=tube_number

new_pixel_counts = float(new_pixel_counts[0])

real_pixelid =  give_real_pixelid_value(Event, pixel_number, tube_number)
update_list_of_pixelid_to_removed, Event,real_pixelid, 1

;add this pixel to the list of pixels to removed
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
















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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





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

;initialize removed_tube (removed #28,29,30,31,60-67)
tube_to_remove=[indgen(4)+28,indgen(4)+60]
size=size(tube_to_remove)
removed_tube=lonarr((*global).Ny_scat)
print, "tube to removed are: "
for i=0, (size[1]-1) do begin
    print, tube_to_remove[i]
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

value_displayed = strcompress(image_2d_1_untouched[pixel_number,tube_number],/remove_all)

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


end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$







;-------------------------------------------------------------------------
pro pixelid_new_counts_reset, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------------------------------------------------
pro ABOUT_MENU, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='general_infos')
text = "" 
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "**** realignBSS (v.110806)****"
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;--------------------------------------------------------------------------------
pro EXIT_PROGRAM, Event

widget_control,Event.top,/destroy

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;---------------------------------------------------------------------------------
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
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;--------------------------------------------------------------------------------------------
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

   welcome = "Welcome " + strcompress(name,/remove_all)
   welcome += "  (working directory: " + strcompress(working_path,/remove_all) + ")"	
   view_id = widget_info(Event.top,FIND_BY_UNAME='MAIN_BASE')
   WIDGET_CONTROL, view_id, base_set_title= welcome	

   view_id = widget_info(Event.top,FIND_BY_UNAME='IDENTIFICATION_BASE')
   WIDGET_CONTROL, view_id, destroy=1

;   view_id = widget_info(Event.top,FIND_BY_UNAME='OUTPUT_PATH_NAME')
;   WIDGET_CONTROL, view_id, set_value=working_path

   ;working path is set
   cd, working_path
 
;    view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
;    text = "LOGIN parameters:"
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "User id           : " + ucams
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "Name              : " + name
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;    text = "Working directory : " + working_path
;    WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
; 
  
endelse

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





;----------------------------------------------------------------------------------------
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

view_info = widget_info(Event.top,FIND_BY_UNAME='GENERAL_INFOS')
text = "Working directory set to:"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = working_path
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

view_info = widget_info(Event.top,FIND_BY_UNAME="OUTPUT_PATH_NAME")
WIDGET_CONTROL, view_info, set_value=working_path

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




;--------------------------------------
pro output_new_histo_mapped_file, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

file = (*global).file
working_path = (*global).working_path

print, "file is: ", file
print, "working path: ", working_path

;determine name of output file according to input file


;    tmp = byte(file)
;    Nbytes = n_elements(tmp)
;    if Nbytes GT 5 then begin
;        tmp = tmp[0:Nbytes-1-4]
;        outfile = string([tmp,byte('_aligned_1.dat')])
;        tube_file = string([tmp,byte('_tube_points.txt')])
;    endif else begin
;        outfile = 'tmp.dat'
;        tube_file = 'tube_points.txt'
;        print,'Using default output filename: ',outfile
;    endelse
;    
;;write out aligned, mapped data
;    openw,u1,outfile,/get
;    writeu,u1,align
;    
;;close it up...
;    close,u1
;    free_lun,u1
;    
;;now write out tube endpoints data
;    openw,u2,tube_file,/get
;    for i=0,Ntubes-1 do begin
;        printf,u2,format='(5I8)',i1[i],i2[i],i5[i],i3[i],i4[i]
;    endfor                      ;i
;    close,u2
;    free_lun,u2
;    
;    
;endif                           ;dosave

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
