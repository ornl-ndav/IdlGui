pro run

  ;///////////////////////////////////////////
  ;SNS OFF SPECULAR ANALYSIS
  ;READ IN A NEXUS FILE AND CONVERT TO QXvsQZ SPACE
  ;ERIK WATKINS 9/21/2010
  ;//////////////////////////////////////////
  ;goto, skip1

  ;path = 'C:\Users\Erik\Documents\LIPID MULTILAYERS\PEAKS NEXUS\'
  path = '~/IDLWorkspace80/SNS_offspec/NeXus/'
  ;path = '~/results/'
  ;savepath = 'C:\Users\Erik\Documents\LIPID MULTILAYERS\NEXUS\'
  savepath = path
  
  ;spec_path = 'C:\Users\Erik\Documents\LIPID MULTILAYERS\NEXUS\'
  spec_path = '~/IDLWorkspace80/SNS_offspec/'
  
  ;norm
  spec_file = 'Al_can_spectrum.dat'   ;FIXME what is this Al_can_spectrum
  
  QXbins=500
  QZbins=500
  
  QXrange=[-0.004, 0.004]
  QZrange=[0.00,0.3]
  
  TOFmin=9.75    ;ms
  TOFmax=22.0     ;ms
  
  ;full on
  PIXmin=0
  PIXmax=255
  
  ;for slits out geometry
  PIXmin=60
  PIXmax=190
  
  ;for slits in and open geometry
  PIXmin=102
  PIXmax=165
  
  Center_pixel=133.5      ;center pixel value
  Pixel_size=0.7       ;mm
  
  ;SD_d=1350.0     ;mm    sample to detector from John
  
  SD_d=1430.0     ;mm    sample to detector from my RB measurements
  MD_d=14910.0    ;mm   moderator to detector
  
  convertion_tof_lambda_flag = 0b ;1b to see the conversion: TOF->Lambda, Pixel->Theta
  
  ;normalization file
  SPECTRUM=xcr_direct(spec_path+spec_file, 2)
  
  ;trim the spec to the relevant TOF ranges
  list=where(SPECTRUM[0,*] ge TOFmin and SPECTRUM[0,*] le TOFmax)
  SPECTRUM=SPECTRUM[*,list]
  SPECTRUM[1,*]=SPECTRUM[1,*]/max(SPECTRUM[1,*]) ;normalize spectrum to 1
  
  ;//////////////////////////////////////////////////////////
  ;LOAD ALL NEXUS FILE
  ;/////////////////////////////////////////////////////////
  fname=DIALOG_PICKFILE(path=path,/multiple_files,/READ)
  if (fname[0] eq '') then return ;no files loaded, we are done here !
  file_num=size(fname,/dim)
  file_num=file_num[0]
  ;get the file number
  fdig=make_array(file_num)
  
  ;//////////////////////////////////////////////////////////
  ;DETERMINE THE NEXUS FILE(S) WHICH INCLUDES THE CRITICAL REFLECTION
  ;all other tiles will be normalized to these...
  ;/////////////////////////////////////////////////////////
  
  file_angles=make_array(3,file_num) ;[file_index, theta, twotheta]
  for read_loop=0,file_num-1 do begin
    ;check to see if the theta value is the same as CE_theta
    DATA=SNS_read_NEXUS(fname[read_loop], TOFmin, TOFmax, PIXmin, PIXmax)
    ;round the angles to the nearset 100th of a degree
    file_angles[0,read_loop]=read_loop
    file_angles[1,read_loop]=round(DATA.theta*100.0)/100.0
    file_angles[2,read_loop]=round(DATA.twotheta*100.0)/100.0
  endfor
  
  ;sort the angles (theta and twoTheta in increasing order)
  list1=sort(file_angles[1,*])
  list2=sort(file_angles[2,*])
  
  ;create arrays of increasing uniq list of angles (theat and twotheta)
  theta_angles=reform(file_angles[1,list1[uniq(file_angles[1,list1])]])
  twotheta_angles=reform(file_angles[2,list2[uniq(file_angles[2,list2])]])
  
  si1=size(theta_angles,/dim)
  si2=size(twotheta_angles,/dim)
  
  ;loop through all theta and twotheta combinations and count those that exist
  count=0
  for loop1=0, si1[0]-1 do begin
    for loop2=0, si2[0]-1 do begin
      check=where((file_angles[1,*] eq theta_angles[loop1]) and (file_angles[2,*] eq twotheta_angles[loop2]))
      if check[0] ne -1 then count++
    endfor
  endfor
  
  ;loop through again and make a list of unique angle geometries
  angles=make_array(4,count)
  count=0
  for loop1=0, si1[0]-1 do begin
    for loop2=0, si2[0]-1 do begin
      check=where((file_angles[1,*] eq theta_angles[loop1]) and (file_angles[2,*] eq twotheta_angles[loop2]))
      if check[0] ne -1 then begin
        angles[0,count]=theta_angles[loop1]
        angles[1,count]=twotheta_angles[loop2]
        count++
      endif
    endfor
  endfor
  
  ;the # of tiles
  si=size(angles,/dim)
  num=si[1]
  
  
  ;INFOS
  ;THLAM is an array containing all the data (for all angle measurements) converted to THETA vs LAMBDA.
  ;It is a 3-d array where the 1st dimension is the measurement #, 2nd dimension is LAMBDA, and 3rd dimension is THETA.
  ;Also, THLAM_lamvec and THLAM_thvec are 2-d arrays of the vectors to index THLAM_array
  ;
  ;So the 5th angle can be plotted using :
  ;'contour, THLAM_array[4,*,*], THLAM_lamvec[4,*], THLAM_thvec[4,*]'
  ;
  ;THLAM is later converted to Qx vs Qz and is stored in a similar combination of all measurement called QXQZ_array.
  ;
  ;SNS_divide_spectrum was my method to normalize the data to the incident beam spectrum. I know there already exists a way
  ;to do this but it was easier for me to write my own quick-and-dirty code than find what already exists.
  ;Basically, I created a 2 column LAMBDA vs INTENSITY file for the direct beam, load that in and then divide all the data by it.
  
  ;create an array to hold all THLAM
  THLAM_array=make_array(num,floor((TOFmax-TOFmin)*5)+1,PIXmax-PIXmin+1)
  THLAM_lamvec=make_array(num,floor((TOFmax-TOFmin)*5)+1)
  THLAM_thvec=make_array(num,PIXmax-PIXmin+1)
  
  for read_loop=0,file_num-1 do begin
  
    RAW_DATA=SNS_read_NEXUS(fname[read_loop], TOFmin, TOFmax, PIXmin, PIXmax)
    ;RAW_DATA is a structure
    ;   {data, theta, twotheta, tof, pixels}
    
    NORM_DATA=SNS_divide_spectrum(RAW_DATA, SPECTRUM)
    
    ;SD_d : sample to detector distance
    ;MD_d : moderator to detector
    THLAM=SNS_convert_THLAM(NORM_DATA, SD_d, MD_d, center_pixel, pixel_size)
    ;THLAM is a structure
    ;   { data, lambda, theta}  with lambda in Angstroms and theta in radians
    
    ;round the angles to the nearset 100th of a degree
    theta_val=round(RAW_DATA.theta*100.0)/100.0
    twotheta_val=round(RAW_DATA.twotheta*100.0)/100.0
    theta_val=theta_val[0]
    twotheta_val=twotheta_val[0]
    
    tilenum=where((angles[0,*] eq theta_val) and (angles[1,*] eq twotheta_val))
    
    THLAM_array[tilenum,*,*]=THLAM_array[tilenum,*,*]+THLAM.data
    THLAM_thvec[tilenum,*]=THLAM.theta
    THLAM_lamvec[tilenum,*]=THLAM.lambda
    
    if (convertion_tof_lambda_flag) then begin
      window,0, title = "Convertion: TOF->Lambda, Pixel->Theta"
      shade_surf, smooth(thlam.data,3), thlam.lambda, thlam.theta, ax=70, charsi=2, xtitle='LAMBDA (' + string("305B) + ')', ytitle='THETA (rad)'
      wait,.1
      wshow
    endif
    
  endfor
  
  ;/////////////////////////////////
  ;NOW CONVERT TO QXQZ
  ;/////////////////////////////////
  
  ;qxbins and qzbins have been defined at the beginning
  
  QXQZ_array=make_array(num, qxbins, qzbins)
  QXQZ_angles=make_array(num,2)
  
  ;Initialize the range of steps for x and z axis
  ;will go from -0.004 to 0.004 with 500steps (qxbins)
  qxvec=(findgen(qxbins)/(qxbins-1))*(qxrange[1]-qxrange[0])+qxrange[0]
  ;will go from 0 to 0.3 with 500steps
  qzvec=(findgen(qzbins)/(qzbins-1))*(qzrange[1]-qzrange[0])+qzrange[0]
  
  ;THLAM_array: 2D vector of data
  ;THLAM_thvec: theta vector axis
  ;THLAM_lamvec: lambda vector axis
  ;angles[theta,twotheta]
  for loop=0,num-1 do begin
    print, 'QXQZ convert loop', loop
    QXQZ_array[loop,*,*]=SNS_convert_QXQZ(THLAM_array[loop,*,*], THLAM_thvec[loop,*], THLAM_lamvec[loop,*], angles[0,loop], QXvec, QZvec)
  endfor
  
  device, decomposed=0
  loadct, 5
  
;  a = contour( [[0,0],[100,0]], [qxrange[0],qxrange[1]], [qzrange[0],qzrange[1]],/nodata, charsi=1.5, xtitle='QX', ytitle='QZ')
  contour, [[0,0],[100,0]], [qxrange[0],qxrange[1]], [qzrange[0],qzrange[1]],/nodata, charsi=1.5, xtitle='QX', ytitle='QZ'
  for loop=0,num-1 do begin
;    _QXQZ_array = reform(QXQZ_array[loop,*,*])
;    b= contour(_QXQZ_array,Qxvec,Qzvec, /fill,nlev=200,/overplot,RGB_TABLE=5)
    contour, QXQZ_array[loop,*,*],Qxvec,Qzvec, /fill,nlev=200,/overplot

    wait,.01
  endfor

  

  ;extract the specular reflections
  qxwidth=0.00005
  specular=make_array(num, qxbins)
  trim=specular
  scale=make_array(num)
  
  for loop=0,num-1 do begin
    data=reform(QXQZ_array[loop,*,*])
    result=SNS_extract_specular(data, qxvec, qxwidth)
    specular[loop,*]=result
    if loop eq 0 then scale[0]=1/max(result)
  endfor
  
  ;trimmer
  tnum=3
  trim=specular*0.0
  for loop=0,num-1 do begin
    list=where(specular[loop,*] ne 0)
    si=size(list,/dim)
    si=si[0]
    cut=list[tnum:si-tnum]
    trim[loop,cut]=specular[loop,cut]
  endfor
  
  
  specular=trim
  
  ;autoscale
  step=0
  
  plot, QZvec, specular[0,*]*scale[0],/ylog, yrange=[1e-8,100], psym=1, charsi=1.5, xtitle='QZ', ytitle='R'
  
  for loop=1,num-1 do begin
  
    overlap=where(specular[loop-1,*] ne 0 and specular[loop,*] ne 0)
    si=size(overlap,/dim)
    si=si[0]
    ratio=specular[loop-1,overlap]/specular[loop,overlap]
    r2=total(specular[loop-1,overlap])/total(specular[loop,overlap])
    scale[loop]=(total(ratio)/si)*scale[loop-1]
    ;scale[loop]=r2*scale[loop-1]
    oplot, QZvec, specular[loop,*]*scale[loop]
    
  endfor
  wait,1
  
  nscale=scale/min(scale)
  
  for loop=0,num-1 do begin
    QXQZ_array[loop,*,*]=QXQZ_array[loop,*,*]*nscale[loop]
  endfor
  
  skip1:print, 'skipped it'
  
  qxqz4=qxqz_array
  for loop1=0,num-1 do begin
    for loop2=0,qzbins-1 do begin
      qxqz4[loop1,*,loop2]=qxqz_array[loop1,*,loop2]*qzvec[loop2]^4
    endfor
  endfor
  ;
  ;contour, [[0,0],[20000,0]], [qxrange[0],qxrange[1]], [qzrange[0],qzrange[1]],/nodata, charsi=1.5, xtitle='QX', ytitle='QZ'
  ;for loop=0,num-1 do begin
  ;    contour, QXQZ_array[loop,*,*],Qxvec,Qzvec, /fill,nlev=200,/overplot
  ;    wait,.05
  ;endfor
  
  countarray=make_array(qxbins,qzbins)
  ;count where the tiles have data
  for loop=0,num-1 do begin
    for xloop=0,qxbins-1 do begin
      for zloop=0,qzbins-1 do begin
        if qxqz_array[loop,xloop,zloop] ne 0 then countarray[xloop,zloop]=countarray[xloop,zloop]+1
      endfor
    endfor
  endfor
  
  
  totarray=make_array(qxbins,qzbins)
  totarray4=make_array(qxbins,qzbins)
  ;total up the tiles
  for loop=0,num-1 do begin
    totarray=QXQZ_array[loop,*,*]+totarray
    totarray4=QXQZ4[loop,*,*]+totarray4
  endfor
  
  totarray=reform(totarray)
  countarray=reform(countarray)
  
  ;this division leads to nans so clean them up
  divarray=totarray/countarray
  list=where(finite(divarray) ne 1)
  divarray[list]=0
  
  divarray4=totarray4/countarray
  list=where(finite(divarray4) ne 1)
  divarray4[list]=0
  
  contour, countarray,Qxvec,Qzvec,/fill, nlev=100
  wait, 1
  
  contour, smooth(alog(divarray+1),5),Qxvec,Qzvec, /fill,nlev=200, charsi=1.5, xtitle='QX', ytitle='QZ'

  create_ascii_output_file, data=smooth(alog(divarray+1),5),$
  Qx = Qxvec, $
  Qz = Qzvec
  
end

