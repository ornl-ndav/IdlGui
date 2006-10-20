;make 2D - program to do the following:
;
; * read the histo_mapped binary file
; * locate tube endpoints
; * remap 2D data to view quality
; * align 3D data set
; * save out tube endpoint values
; * restore tube endpoints for use with aligining data

;the primary result of this program is to create 5 arrays
;i1 - first tube starting pixel
;i2 - first tube ending pixel
;i3 - second tube starting pixel
;i4 - second tube ending pixel
;i5 - pixel location between the two tubes

;y_pixel_offset of pixelIDs
;y_pixel_offset_pixel_0 = -0.0738 meter
;y_pixel_offset_pixel_63 = 0.0738 meter
;it's up to us to figure out the position of the other ones
;distance from one border to the other is 0.1476m = 14.76cm
y_left_offset = -0.0738
y_right_offset = 0.0738

;processing flags
doread 	 = 1           ;read in BSS data - generally need to do this the first time thru
dogetep  = 0           ;get tube endpoints from text file
doplot 	 = 0           ;plot tube endpoints composite results (3 graphs)
dostop 	 = 0           ;stop to single step thru finding endpoints
dolog  	 = 1           ;show data in linear scale (0) or log scale (1)
dooffs 	 = 1           ;create 2D map of re-mapped data
doalign  = 1           ;align the full 3D data set
dosave 	 = 0           ;save tube endpoints to text file
debug    = 0           ;debug print statement
debug_map = 0          ;debug statement of remapping part of program (array_offset...)
verbose = 1            ;display position of start,end....
print_data_per_tube = 1 ;display counts for each tube, one at a time

;example use cases
; first pass: set doread, dooffs, doalign, and dosave = 1
; second pass: only set dogetep, doofs, doalign = 1 - should use saved results to align data

;global variables
Npix = 128L	 ;number of pixels per tube
Ntubes = 64L ;number of inelastic tubes
Ndtubes = 8L ;number of diffraction tubes

array_offset = fltarr(Ntubes+8,Npix)
!p.multi=[0,1,1]
;#######################################################################################

;read histo_mapped input file
if doread EQ 1 then begin

    print,'reading data...'
    
    file = '/SNS/users/j35/BSS_35_neutron_histo_mapped.dat'
;file = '~/CD4/BSS/BSS_37_neutron_histo_mapped.dat'
;file = '/SNS/users/j35/BSS_36_neutron_histo.dat'
;file = '/SNS/users/j35/BSS_31_neutron_histo_mapped.dat'
    
    openr,u,file,/get
;TOF_data = assoc(unit,uintarr(8000))
    
    fs = fstat(u)
    sz = fs.size
    
    Ntof = (sz)/(Npix*(Ntubes+Ndtubes)*4L) ;need to add Ntubes + 8 diffraction det tubes
    
    image1 = ulonarr(Ntof,128,64)
;image2 = ulonarr(Ntof, Npix/2, Ntubes)
    
    readu,u,image1
    
    diff = ulonarr(Ntof,128,8)
    readu,u,diff
;readu,u,image2
    
;close all open file units
    close,/all  
    
    image_2d_1 = total(image1,1)
    orig = image_2d_1
;image_2d_2 = total(image2,1)
    
    tmp = image_2d_1[0:63,0:31]
    tmp = reverse(tmp,1)
    image_2d_1[0:63,0:31] = tmp
    
    tmp = image_2d_1[64:*,32:*]
    tmp = reverse(tmp,1)
    image_2d_1[64:*,32:*] = tmp
    
endif                           ;doread





if dogetep EQ 1 then begin      ;get tube points saved previously.

    tube_file = 'BSS_31_neutron_histo_mapped_tube_points.txt'
    
    i1 = intarr(Ntubes)         ;tube 1 start values
    i2 = intarr(Ntubes)         ;tube 1 end values
    i3 = intarr(Ntubes)         ;tube 2 start values
    i4 = intarr(Ntubes)         ;tube 2 end values
    
    i5 = intarr(Ntubes)         ;midpoint between tubes
    
    openr,u3,tube_file,/get
    
;define temporary variables used for reading in data
    p1 = 0
    p2 = 0
    p3 = 0
    p4 = 0
    p5 = 0
    
    for i=0,Ntubes-1 do begin
        readf,u3,p1,p2,p5,p3,p4,format='(5i8)'
        i1[i] = p1
        i2[i] = p2
        i5[i] = p5
        i3[i] = p3
        i4[i] = p4
        
    endfor                     
    
endif else begin                ;calculate endpoints
    
    off1 = 25                   ;max position of first part tube start
    off2 = 50                   ;min position of first part tube end 
    off3 = 80                   ;max position of second part tube start     
    off4 = 110                  ;min position of second part tube end
    
    Npad = 10
    pad = lonarr(Npad)
    
    i1 = intarr(Ntubes)         ;first part of tube start
    i2 = intarr(Ntubes)         ;first part of tube end
    i3 = intarr(Ntubes)         ;second part of tube start
    i4 = intarr(Ntubes)         ;second part of tube end
    i5 = intarr(Ntubes)         ;central position between the two parts
    
    len1 = intarr(Ntubes)       ;length of first part of tube
    len2 = intarr(Ntubes)       ;length of second part of tube
    
;find rising edges
    
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

        ;Print indexes of extremities of tube and central position
        if (print_data_per_tube EQ 1) then begin
            text =   strcompress(indx1) + ", " + $
              strcompress(indx2)+ ", "+ $
              strcompress(cntr)+ ", "+ $
              strcompress(indx3)+ ", "+ $
              strcompress(indx4)
        
        ;This part displays the plot of each tube one by one
            stop_value = ""
            read, stop_value, prompt="continue (y/n): "

            if(stop_value EQ 'y') then begin 

                title = text + " | tube # " + strcompress(i)
                window, 0, xsize=500,ysize=400,xpos=550,ypos=250
                plot, image_2d_1[*,i], title=title
                plots,[indx1,image_2d_1[indx1,i]],psym=4,color=130,thick=3
                plots,[indx2,image_2d_1[indx2,i]],psym=4,color=130,thick=3
                plots,[cntr,image_2d_1[cntr,i]],psym=4,color=130,thick=3
                plots,[indx3,image_2d_1[indx3,i]],psym=4,color=130,thick=3
                plots,[indx4,image_2d_1[indx4,i]],psym=4,color=130,thick=3
                
            endif else begin
                stop
            endelse
            
        endif

        ;store the indexes in an array i
        i1[i] = indx1
	i2[i] = indx2
	i3[i] = indx3
	i4[i] = indx4
	i5[i] = cntr

        ;store the size of each size of the tube in len1 and len2
	len1[i] = i2[i] - i1[i]
	len2[i] = i4[i] - i3[i]
        
        ;offset of first part of tube0
        for j=0,i1[i]-1 do begin
            array_offset[i,j] = -1
        endfor
        
        delta_offset_tube0 = (2*y_right_offset)/(i2[i]-i1[i])

        ;offset of central part of tube0
        for j=i1[i],i2[i] do begin
            array_offset[i,j] = y_right_offset - (j-i1[i])*delta_offset_tube0
        endfor

        ;offset of part between tube0 and tube1
        for j=i2[i]+1,i3[i]-1 do begin
            array_offset[i,j] = -1
        endfor

        delta_offset_tube1 = (2*y_right_offset)/(i4[i]-i3[i])        
        
        ;offset of central part of tube1
        for j=i3[i],i4[i] do begin
            array_offset[i,j] = y_left_offset + (j-i3[i])*delta_offset_tube1
        endfor

        ;offset of last part of tube1
        for j=i4[i]+1, 127L do begin
            array_offset[i,j] = -1
        endfor        

        if (debug_map EQ 1) then begin
            
            for j=0,127 do begin
                print, "array_offset[",strcompress(i),",",strcompress(j),"]: ", $
                  array_offset[i,j]
            endfor
            
        endif
            
        





        if (debug EQ 1) then begin
            print, "len1[",strcompress(i),"]= ", strcompress(len1[i])
            print, "len2[",strcompress(i),"]= ", strcompress(len2[i])
        endif

        if doplot EQ 1 then begin
            
            stop_value = ""
            read, stop_value, prompt="continue (y/n): "
            
            if (stop_value EQ 'y') then begin
                
                print,'***********************************'
                print,'Tube # ',strcompress(i),'/',strcompress(Ntubes-1)
                
                wset,0
                !p.multi=[0,2,2]
                
                if i LT 32 then bank = 1 else bank = 2
                
                text =   strcompress(indx1) + ", " + $
                  strcompress(indx2)+ ", "+ $
                  strcompress(cntr)+ ", "+ $
                  strcompress(indx3)+ ", "+ $
                  strcompress(indx4)+ " (tube #" +$
                  strcompress(i,/remove_all) + "/" + "bank #" +$
                  strcompress(bank,/remove_all) + ")"
                xtitle='Pixel'
                ytitle='Magnitude - Linear'
                cs = 1.5
                
                plot,image_2d_1[*,i],title=text,xtitle=xtitle,ytitle=ytitle,$
                  charsize=cs,xrange=[0,128],xstyle=1
                oplot,image_2d_1[*,i],psym=4,color=255
                
                plots,[indx1,image_2d_1[indx1,i]],psym=4,color=255,thick=3
                plots,[indx2,image_2d_1[indx2,i]],psym=4,color=255,thick=3
                plots,[indx3,image_2d_1[indx3,i]],psym=4,color=255,thick=3
                plots,[indx4,image_2d_1[indx4,i]],psym=4,color=255,thick=3
                plots,[cntr,image_2d_1[cntr,i]],psym=4,color=200,thick=3
                
                                ;now show in log scale
                eps = 0.1
                ytitle='Magnitude - Log'
                plot,image_2d_1[*,i]+eps,/ylog,$
                  xtitle=xtitle,ytitle=ytitle,$
                  charsize=cs,xrange=[0,128],xstyle=1
                oplot,image_2d_1[*,i],psym=4,color=255
                plots,[indx1,image_2d_1[indx1,i]],psym=4,color=255,thick=3
                plots,[indx2,image_2d_1[indx2,i]],psym=4,color=255,thick=3
                plots,[indx3,image_2d_1[indx3,i]],psym=4,color=255,thick=3
                plots,[indx4,image_2d_1[indx4,i]],psym=4,color=255,thick=3            
                plots,[cntr,image_2d_1[cntr,i]],psym=4,color=200,thick=3
                
;pad and give ourselves some room to shift data (10 + 127 + 10)
                tube_pair_pad = [pad,tube_pair,pad]
                indx_cntr = 64+Npad ;74            
                                ;cntr offset relative to cntr
                cntr_offset = indx_cntr - (Npad+cntr) ;74 - (10 + cntr) 
                
                
;dial out center offset
                tube_pair_pad_shft = shift(tube_pair_pad,cntr_offset)
                
                plot,tube_pair_pad_shft+0.2
                
            endif else begin
                stop
            endelse

            if dostop EQ 1 then stop
            
        endif                   ;doplot
        











    endfor                      ;i
    

    if doplot EQ 1 then begin
;plot mean values of the first 16 tubes
        m1_1 = mean(i1[0:15])
        m2_1 = mean(i2[0:15])
        m3_1 = mean(i3[0:15])
        m4_1 = mean(i4[0:15])
        m5_1 = mean(i5[0:15])
        
        plot,i1 - m1_1
    endif     ;doplot
    
endelse       ;dogetep




;Create 2D map of re-mapped data
if dooffs EQ 1 then begin
    outfile = 'tmp.txt'
    


;define ranges of tube responses
    
;first tube in the pair
    t0 = 2
    t1 = 61
    length_tube0 = t1 - t0
    
;second tube in the pair
    t2 = 66
    t3 = 125
    length_tube1 = t3 - t2
    
;new remap array(Npix, Ntubes)
    remap = dblarr(Npix,Ntubes)
    
    for i=0,Ntubes-1 do begin

        if (debug_map EQ 1) then begin
            print, "#######################################"
            print, "Tube #", strcompress(i,/remove_all)
        endif






























































stop


        if ((i LT 16) OR ((i GT 32) AND (i LT 48))) then begin
            
            mid = Npix/2  ;64
            
;remap tube end data
            if (debug_map EQ 1) then begin
                txt = " (i1,i2,i3,i4,i5)= (" + strcompress(i1[i],/remove_all)
                txt += "," + strcompress(i2[i],/remove_all)
                txt += "," + strcompress(i3[i],/remove_all)
                txt += "," + strcompress(i4[i],/remove_all)
                txt += "," + strcompress(i5[i],/remove_all) + ")"
                print, txt
            endif
            
            len_meas_tube0 = i2[i] - i1[i]

            if (debug_map EQ 1) then begin
                print, " len_meas_tube0= ", strcompress(len_meas_tube0,/remove_all)
            endif

;remap (rebin) tube0 data
            d0 = float(length_tube0) * findgen(len_meas_tube0)/(len_meas_tube0) + t0 
            
;remap (rebin) tube start data (junk)
            d0_0 = findgen(i1[i])/(i1[i])*t0

;remap (rebin) tube end data (junk)
 
            d0_1 = float(mid-t1)*findgen((i5[i]-i2[i]))/((i5[i]-i2[i])) + t1

;new tube remapped
            tube0_new = [d0_0,d0,d0_1]

            if (debug_map EQ 1) then begin
                d0_size = size(d0)
                text_d0 = " d0=["
                for i=0, 5 do begin
                    text_d0 += strcompress(d0[i],/remove_all) + ","
                endfor
                text_d0 += "...,"
                for i=(d0_size[1]-6),(d0_size[1]-1)  do begin
                    text_d0 += strcompress(d0[i],/remove_all) + ","
                endfor
                text_d0 += + "]" + ": " + strcompress(d0_size[1],/remove_all) + $
                  " elements"

                d0_0_size = size(d0_0)
                text_d0_0 = " d0_0=["
                for i=0, (d0_0_size[1]-2) do begin
                    text_d0_0 += strcompress(d0_0[i],/remove_all) + ","
                endfor
                text_d0_0 += strcompress(d0_0[d0_0_size[1]-1],/remove_all) + $
                  "]" + ": " + strcompress(d0_0_size[1],/remove_all) + $
                  " elements"

                d0_1_size = size(d0_1)
                text_d0_1 = " d0_1=["
                for i=0, (d0_1_size[1]-2) do begin
                    text_d0_1 += strcompress(d0_1[i],/remove_all) + ","
                endfor
                text_d0_1 += strcompress(d0_1[d0_1_size[1]-1],/remove_all) + $
                  "]" + ": " + strcompress(d0_1_size[1],/remove_all) + $
                  " elements"
                  

                print, text_d0_0
                print, text_d0
                print, text_d0_1
                print
                
            endif
            
;reshape middle section of tube

             mn0 = min(d0) ;2
             mx0 = min([max(d0),Npix-1]) 
             del0 = mx0 - mn0 + 1
             rindx1 = indgen(del0-1)+mn0

            if (debug_map EQ 1) then begin             
                print, "--> Work on middle section of tube (d0_0)"
                print, " (min,max) = (", strcompress(mn0,/remove_all), $
                  "," , strcompress(mx0,/remove_all),")"
                rindx1_size = size(rindx1)
                text = "rindx1=["
                for i=0,5 do begin
                    text += strcompress(rindx1[i],/remove_all) + ","
                endfor
                text += "..."
                for i=(rindx1_size[1]-6),(rindx1_size[1]-2) do begin
                    text += strcompress(rindx1[i],/remove_all) + ","
                endfor
                text += strcompress(rindx1[rindx1_size[1]-1],/remove_all) + "]"
                print, text
            endif
            
            dat = congrid(image_2d_1[i1[i]:i2[i],i],del0-1,/interp)
;            dat = congrid(image_2d_1[i1[i]:i2[i],i],length_tube0,/interp)

            remap[rindx1,i] = dat ;new array of the middle section
;            plot, remap[rindx1,0]
            
stop




;remap endpoints and middle section
;one end

;            mn0 = min(d0_0); 0
;            mx0 = min([max(d0_0),Npix-1])
;            del0 = fix(mx0 - mn0) + 1
;            rindx0 = indgen(del0)+mn0
            rindx0 = indgen(2)
;            dat = congrid(image_2d_1[0:i1[i],i],del0,/interp)
            dat = congrid(image_2d_1[0:i1[i],i],2,/interp)
            print, image_2d_1[0:i1[i],0]
            print, dat[0]
            print, dat[1]
            scl = float(2)/i1[i]
            remap[rindx0,i] = dat * scl

stop
            
;print,'***',rindx0
            
;stop
              ;finally the middle
            mn0 = t1+1
            mx0 = t2-1
            del0 = (mx0 - mn0) + 1
            rindx0 = indgen(del0)+mn0
            dat = congrid(image_2d_1[i2[i]:i3[i],i],del0,/interp)
            scl = float(del0)/(i3[i] - i2[i])
            remap[rindx0,i] = dat * scl
;print,'***',rindx0
;stop
              ;remap tube1 data
            len_meas_tube1 = i4[i] - i3[i]
            d1 = float(length_tube1) * findgen(len_meas_tube1)/(len_meas_tube1-1) + t2
            
              ;remap tube start data (junk)
            d1_0 = abs(float(t2 - i5[i]))*findgen(abs(i3[i]-i5[i]))/(i3[i]-i5[i]+1) + mid
            
              ;remap tube end data
            d1_1 = float(Npix-t3)*findgen(Npix-i4[i])/(Npix-i4[i]+1) + (t3+1)
            
;stop
              ;now the other tube end
            mn0 = min(d1_1)
            mx0 = min([max(d1_1),Npix-1])
            del0 = (mx0 - mn0) + 1
            rindx0 = indgen(del0)+mn0
            dat = congrid(image_2d_1[i4[i]:*,i],del0,/interp)
            scl = float(del0)/(Npix-i4[i])
            remap[rindx0,i] = dat * scl
;print,'***',rindx0
            
            mn1 = min(d1)
            mx1 = min([max(d1),Npix-1])
            del1 = mx1 - mn1 + 1
            rindx1 = indgen(del1)+mn1
            dat = congrid(image_2d_1[i3[i]:i4[i],i],del1,/interp)
            remap[rindx1,i] = dat
            
;print,'***',rindx1
;stop
            
        endif
        
    endfor                      ;i
    
    Ninterp = 7
    window,4,xsize = Ninterp*Npix, ysize = Ninterp*Ntubes
    tmp0 = remap
    
    tmp1 = rebin(tmp0,Ninterp*Npix,Ninterp*Ntubes,/samp)
    
    if dolog EQ 1 then begin
        tvscl,(alog10(tmp1>1))
    endif else begin
        tvscl,hist_equal(tmp1)
    endelse
endif                           ;dooffs



;doalign
if doalign EQ 1 then begin
    
    print,'aligning data...'
    
    align = image1
    
    for j=0,Ntof-1 do begin
        
        if j MOD 100 EQ 0 then print,'***** ',systime(0),' Loop: ',j,' of ',Ntof-1
        
;get 2d image for this TOF plane
        image_2d = reform(image1[j,*,*])
        tmp = image_2d[0:63,0:31]
        tmp = reverse(tmp,1)
        image_2d[0:63,0:31] = tmp
        
        tmp = image_2d[64:*,32:*]
        tmp = reverse(tmp,1)
        image_2d[64:*,32:*] = tmp
        

        remap = dblarr(Npix,Ntubes)
        
        
        interp = 0
        
        for i=0,Ntubes-1 do begin
            
            
            if ((i LT 16) OR ((i GT 31) AND (i LT 48))) then begin
                
                
                mid = Npix/2
                
                                ;remap tube0 data
                len_meas_tube0 = i2[i] - i1[i]
                d0 = float(length_tube0) * findgen(len_meas_tube0)/(len_meas_tube0-1) + t0
                
                                ;remap tube start data (junk)
                d0_0 = findgen(i1[i])/(i1[i])*t0
                
                                ;remap tube end data
                d0_1 = float(mid-t1)*findgen(i5[i]-i2[i])/(i5[i]-i2[i]) + t1
                
                tube0_new = [d0_0,d0,d0_1]
                
                mn0 = min(d0)
                mx0 = min([max(d0),Npix-1])
                del0 = mx0 - mn0 + 1
                rindx1 = indgen(del0)+mn0
                dat = congrid(image_2d[i1[i]:i2[i],i],del0,interp=interp)
                scl1 = double(n_elements(image_2d[i1[i]:i2[i],i]))/double(n_elements(dat))
                scl = total(image_2d[i1[i]:i2[i],i])/total(dat)
                remap[rindx1,i] = double(dat) * scl1
                
;print,'A  scl: ',scl,'  scl1:  ',scl1
                
                                ;remap endpoints and middle section
                                ;one end
                mn0 = min(d0_0)
                mx0 = min([max(d0_0),Npix-1])
                del0 = fix(mx0 - mn0) + 1
                rindx0 = indgen(del0)+mn0
                dat = congrid(image_2d[0:i1[i],i],del0,interp=interp)
                scl = float(del0)/i1[i]
                remap[rindx0,i] = dat * scl
                
                                ;now the other
                mn0 = min(d1_1)
                mx0 = min([max(d1_1),Npix-1])
                del0 = (mx0 - mn0) + 1
                rindx0 = indgen(del0)+mn0
                dat = congrid(image_2d[i4[i]:*,i],del0,interp=interp)
                scl = float(del0)/(Npix-i4[i])
                remap[rindx0,i] = dat * scl
                
                                ;finally the middle
                mn0 = t1+1
                mx0 = t2-1
                del0 = (mx0 - mn0) + 1
                rindx0 = indgen(del0)+mn0
                dat = congrid(image_2d[i2[i]:i3[i],i],del0,interp=interp)
                scl = float(del0)/(i3[i] - i2[i])
                remap[rindx0,i] = dat * scl
                
                                ;remap tube1 data
                len_meas_tube1 = i4[i] - i3[i]
                d1 = float(length_tube1) * findgen(len_meas_tube1)/(len_meas_tube1-1) + t2
                
                                ;remap tube start data (junk)
                d1_0 = abs(float(t2 - i5[i]))*findgen(abs(i3[i]-i5[i]))/(i3[i]-i5[i]+1) + mid
                
                                ;remap tube end data
                d1_1 = float(Npix-t3)*findgen(Npix-i4[i])/(Npix-i4[i]+1) + (t3+1)
                
                mn1 = min(d1)
                mx1 = min([max(d1),Npix-1])
                del1 = mx1 - mn1 + 1
                rindx1 = indgen(del1)+mn1
                dat = congrid(image_2d[i3[i]:i4[i],i],del1,interp=interp)
                scl = total(image_2d[i3[i]:i4[i],i])/total(dat)
                scl1 = double(n_elements(image_2d[i3[i]:i4[i],i]))/double(n_elements(dat))
                
;print,'B  scl: ',scl,'  scl1:  ',scl1
                
                remap[rindx1,i] = double(dat) * scl1
                
;stop
            endif            ;((i LT 16) OR ((i GT 32) AND (i LT 48)))
            
        endfor                  ;i
        
        
;untangle the web of mapped 64 data into 128 pixel space...
        
        align[j,*,*] = remap
        
        
        
        tmp = remap[0:63,0:31]
        tmp = reverse(tmp,1)
        align[j,0:63,0:31] = tmp
        
        
        tmp = remap[64:*,32:*]
        tmp = reverse(tmp,1)
        align[j,64:*,32:*] = tmp
        
        
    endfor                      ;j
    
endif                           ;doalign

if dosave EQ 1 then begin
    
    print,'saving data...'
    
    tmp = byte(file)
    Nbytes = n_elements(tmp)
    if Nbytes GT 5 then begin
        tmp = tmp[0:Nbytes-1-4]
        outfile = string([tmp,byte('_aligned_1.dat')])
        tube_file = string([tmp,byte('_tube_points.txt')])
    endif else begin
        outfile = 'tmp.dat'
        tube_file = 'tube_points.txt'
        print,'Using default output filename: ',outfile
    endelse
    
;write out aligned, mapped data
    openw,u1,outfile,/get
    writeu,u1,align
    
;now write diffraction bank data
    
    writeu,u1,diff
    
;close it up...
    close,u1
    free_lun,u1
    
;now write out tube endpoints data
    openw,u2,tube_file,/get
    for i=0,Ntubes-1 do begin
        printf,u2,format='(5I8)',i1[i],i2[i],i5[i],i3[i],i4[i]
    endfor                      ;i
    close,u2
    free_lun,u2
    
    
endif                           ;dosave








end
