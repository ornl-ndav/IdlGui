

pro my_read_tiff
  compile_opt idl2
  
  widget_control, /hourglass
  
  path = '/Volumes/h2b/h2b/Data_Analysis/2011/2011 Forensic/Cycle 433/Feb1_2011/Overnight_muscle/Despeckled/Normalized/'
  filter = ['N_D*.tif']
  output_path = '~/Desktop/'
  output_file_name = output_path + 'Feb1_2011_selections.txt'
  
  bCheckSelection = 0b
  bDoCalculation = 1b
  
  selection = [[592,876,592+148,876+158],$
    [1034,1048,1034+218,1048+248],$
    [958,1558,958+224,1558+252],$
    [1658,1280,1658+228,1280+222],$
    [1536,1778,1536+312,1778+266],$
    [2072,1388,2072+254,1388+250],$
    [2572,1480,2572+128,1480+122],$
    [2130,2222,2130+64,2222+64],$
    [2324,2186,2324+66,2186+70],$
    [1994,2288,1994+80,2288+62],$
    [2264,2262,2264+72,2262+74],$
    [2154,2336,2154+68,2336+62]]
    
  sz = size(selection,/dim)
  nbr_selection = sz[1]
  
  list_file = dialog_pickfile(path=path,/multiple_files,filter=filter)
  nbr_files = n_elements(list_file)
  
  ;check if selection is right for all files
  if (bCheckSelection) then begin
  
    device, decomposed=0
    loadct,5
    
    for i=0,(n_elements(list_file)-1) do begin
      _file = list_file[i]
      data = read_tiff(_file)
      sz = size(data,/dim)
      
      new_xsize = sz[0]/2
      new_ysize = sz[1]/2
      
      window, 0, xsize=new_xsize, ysize=new_ysize, title=_file
      
      cData = congrid(data,new_xsize, new_ysize)
      
      tvscl, cData
      
      for j=0,nbr_selection-1 do begin
        x0=selection[0,j]/2
        y0=selection[1,j]/2
        x1=selection[2,j]/2
        y1=selection[3,j]/2
        plots, [x0,x1,x1,x0,x0],[y0,y0,y1,y1,y0],color=fsc_color('blue'), $
          /device
        xyouts, x0+5,y0+5, '#' + strcompress(j,/remove_all),/device, $
          color=fsc_color("black")
      endfor
      
      wait,1
      
    endfor
  endif
  
  if (bDoCalculation) then begin
  
    ;do the calculation
  
    SumArea = dblarr(nbr_files, nbr_selection)
    
    for i=0,nbr_files-1 do begin
    
      _file = list_file[i]
      data = read_tiff(_file)
      
      for j=0,nbr_selection-1 do begin
      
        x0 = selection[0,j]
        y0 = selection[1,j]
        x1 = selection[2,j]
        y1 = selection[3,j]
        
        _data = data[x0:x1,y0:y1]
        _sum = total(_data)
        
        SumArea[i,j] = _sum
        
      endfor
    endfor
    
  endif
  
  ;create output file of result
  openw, 1 , output_file_name
  
  ;info
  printf, 1, '# xaxis: selections'
  printf, 1, '# yaxis: files'
  
  ;selection
  for j=0,nbr_selection-1 do begin
    _selection = strjoin(selection[*,j],',')
    printf, 1, '# selection: ' + strcompress(_selection,/remove_all)
  endfor
  
  ;add list of files
  sz = n_elements(list_file)
  for i=0,sz-1 do begin
    printf, 1, '# File: ' + list_file[i]
  endfor
  printf, 1, '# number of files: ' + strcompress(sz,/remove_all)
  printf, 1, '# number of selection: ' + strcompress(nbr_selection,/remove_all)
  printf, 1, ''
  
  for k=0, sz-1 do begin
  
    _area = SumArea[k,*]
    _row = strjoin(' ' + strjoin(_area,','),',')
    printf, 1, _row
    
  endfor
  
  close, 1
  free_lun, 1

  widget_control, hourglass=0
  
end





;'(data-df)/(OB-df))'


PRO fits_reader

  device, decompose=0
  loadct, 11
  
  file1 = '/Volumes/h2b//h2b/HFIR_Cycle_434/March2_2011/Cell_1.2V_300s0_0000_0030.fits'
  dF1 = '/Volumes/h2b//h2b/HFIR_Cycle_434/March2_2011/DF_300s_0095.fits'
  dF2 = '/Volumes/h2b//h2b/HFIR_Cycle_434/March2_2011/DF_300s_0096.fits'
  dF3 = '/Volumes/h2b//h2b/HFIR_Cycle_434/March2_2011/DF_300s_0097.fits'
  dF4 = '/Volumes/h2b//h2b/HFIR_Cycle_434/March2_2011/DF_300s_0098.fits'
  dF5 = '/Volumes/h2b//h2b/HFIR_Cycle_434/March2_2011/DF_300s_0099.fits'
  ob1 = '/Volumes/h2b//h2b/HFIR_Cycle_434/March2_2011/OB_300s44_0000_0101.fits'
  
  data_file  = file1
  dark_field = df1
  open_beam  = ob1
  
  ;;get info about file
  ;get_fits_info, file
  
  ;****************************************************************************
  print, 'working with data_file'
  _read_fits_file, data_file, data1
  
  ;     new_data = congrid(data1, 1000, 1000)
  ;    window, 0, xsize=1000, ysize=1000, title='test file before rotation'
  ;    tvscl, data1
  ;
  
  ;   rot_new_data = rot(new_data, 180)
  ;  window, 1, xsize=1000, ysize=1000, title='test file after rotation'
  ;  tvscl, rot_new_data
  
  gamma_cleaner, data1
  
  ;left and right selection of data file
  xl1 = 129
  xr1 = 600
  yt = 2048-453
  yb = 2048-1878
  
  help, data1
  
  cut_data_file_left = data1[xl1:xr1,yb:yt]
  
  xl2 = 1305
  xr2 = 1941
  cut_data_file_right = data1[xl2:xr2,yb:yt]
  
  ;  new_data = congrid(data1, 1000, 1000)
  ;  window, 1, xsize=1000, ysize=1000, title='test file after gamma cleaner'
  ;  tvscl, new_data
  
  ;  new_data = congrid(data1, 1000, 1000)
  ;  window, 0, xsize=1000, ysize=1000, title='test file'
  ;  tvscl, new_data
  
  ;  new_data = congrid(data1, 1000, 1000)
  ;  window, 1, xsize=1000, ysize=1000, title='test file wihout gammas'
  ;  tvscl, new_data
  
  ;****************************************************************************
  print, 'working with dark field'
  _read_fits_file, df1, data2
  
  ;new_data = congrid(data2, 1000, 1000)
  ;window, 1, xsize=1000, ysize=1000, title='dark field'
  ;tvscl, new_data
  
  ;;  print, 'working with dark field'
  ;  read_fits_file, df1, data2_1
  ;  ;  print, 'working with dark field'
  ;  read_fits_file, df2, data2_2
  ;;  print, 'working with dark field'
  ;  read_fits_file, df3, data2_3
  ;;  print, 'working with dark field'
  ;  read_fits_file, df4, data2_4
  ;;  print, 'working with dark field'
  ;  read_fits_file, df5, data2_5
  ;
  ;data2 = (data2_1 + data2_2 + data2_3 + data2_4 + data2_5) / 5.
  
  ;****************************************************************************
  ;find out which coeff we need to apply to data2 to match background
  ;of data test
  
  ;****************************************************************************
  print, 'working with open beam'
  _read_fits_file, open_beam, data3
  
  gamma_cleaner, data3
  
  ;left and right selection of data file
  cut_open_beam_left = data3[xl1:xr1,yb:yt]
  cut_open_beam_right = data3[xl2:xr2,yb:yt]
  
  ;new_data = congrid(data3, 1000, 1000)
  ;window, 3, xsize=1000, ysize=1000, title='open beam'
  ;tvscl, new_data
  
  print, 'mean_left_data: ', mean(cut_data_file_left)
  print, 'mean_left_df: ' , mean(cut_open_beam_left)
  
  print, 'min left_data: ' , min(cut_data_file_left)
  print, 'min left_df: ' ,  min(cut_open_beam_left)
  
  print, 'max left_data: ' , max(cut_data_file_left)
  print, 'max left_df: ' ,  max(cut_open_beam_left)
  
  mean_ratio_left = mean(cut_data_file_left/cut_open_beam_left)
  mean_ratio_right = mean(cut_data_file_right/cut_open_beam_right)
  
  print, 'mean_ratio_left: ' , mean_ratio_left
  print, 'mean_ratio_right: ' , mean_ratio_right
  
  data3 *= mean([mean_ratio_left, mean_ratio_right])
  
  ;****************************************************************************
  
  num = data1 - data2
  den = data3 - data2
  
  norm_data = num/den
  
  ;code to plot in color
  new_data = congrid(norm_data, 1000, 1000)
  window, 0, xsize=1000, ysize=1000, title='before using above_1_cleaner'
  tvscl, new_data
  
  ;remove all points above 1 to the average of the surrounding points
  above_1_cleaner, norm_data
  
  below_1_cleaner, norm_data
  
  ;to put the sample upside down
  norm_data = transpose(norm_data)
  norm_data = rot(norm_data, 90)
  
  ;code to plot in color
  new_data = congrid(norm_data, 1000, 1000)
  window, 1, xsize=1000, ysize=1000, title='without smooth'
  tvscl, new_data
  
  ;smooth final data set ----------
  smooth_norm_data = smooth(norm_data,2,/edge_mirror)
  ;code to plot in color
  new_data = congrid(smooth_norm_data, 1000, 1000)
  window, 2, xsize=1000, ysize=1000, title='with smooth'
  tvscl, new_data
  
  ;use median of all picture of surrounding 8 points
  median_neighbors, norm_data
  new_data = congrid(norm_data, 1000, 1000)
  window, 3, xsize=1000, ysize=1000, title='after using median_neighbor'
  tvscl, new_data
  
  ;  ;create tiff file of final plot
  ;  print, 'writting tif file'
  ;  write_tiff, '/Users/j35/Desktop/remove_me.tif', tvrd()
  ;    print, 'done writting file'
  
  ;create bmp file
  ;window, 2, title='using tv', xsize=1000, ysize=1000
  byte_new_data = bytscl(new_data)
  ;tv, byte_new_data
  ;write_bmp, '/Users/j35/Desktop/remove_me.bmp', byte_new_data
  
  ;create tiff file
  write_tiff, '/Users/j35/Desktop/remove_me.tiff', byte_new_data
  
  full_file_name = '/Users/j35/Desktop/remove_me.fits'
  fits_write, full_file_name, new_data
  
END


pro below_1_cleaner, norm_data

  index = where(norm_data lt 0.)
  norm_data[index] = 0
  
end


;+
; :Description:
;    This routine cleans the gamma data.
;    This is done by averaging the data found with a value above a given
;    thresold by the surrounding neighbors
;
; :Params:
;    data
;
; :Author: j35
;-
pro _gamma_cleaner, data
  compile_opt idl2
  
  threshold = 10000.
  
  sz = size(data)
  nbr_row = sz[0]
  nbr_column = sz[1]
  
  index_gammas = array_indices(data, where(data ge threshold))
  
  nbr_pt = (size(index_gammas,/dim))[1]
  for i=0,(nbr_pt-1) do begin
  
    x = index_gammas[0,i]
    y = index_gammas[1,i]
    if (x eq 0 or x eq nbr_row) then continue
    if (y eq 0 or y eq nbr_column) then continue
    
    y_tl = data[x-1,y+1]
    y_t  = data[x,y+1]
    y_tr = data[x+1,y+1]
    y_l  = data[x-1,y]
    y_r  = data[x+1,y]
    y_bl = data[x-1,y-1]
    y_b  = data[x,y-1]
    y_br = data[x+1,y-1]
    
    mean_y = (y_tl + y_t + y_tr + y_l + y_r + y_bl + y_b + y_br) / 8.
    data[x,y] = mean_y
    
  endfor
  
end

;+
; :Description:
;    This routine cleans all the counts above 1
;    This is done by averaging the data found with a value above a given
;    thresold by the surrounding neighbors
;
; :Params:
;    data
;
; :Author: j35
;-
pro above_1_cleaner, data
  compile_opt idl2
  
  threshold = 1.
  
  sz = size(data,/dim)
  nbr_row = sz[0]
  nbr_column = sz[1]
  
  index_gammas = array_indices(data, where(data ge threshold))
  
  nbr_pt = (size(index_gammas,/dim))[1]
  for i=0,(nbr_pt-1) do begin
  
    x = index_gammas[0,i]
    y = index_gammas[1,i]
    if (x eq 0 or x eq (nbr_row-1)) then continue
    if (y eq 0 or y eq (nbr_column-1)) then continue
    
    ;print, '(x,y)=(',x,',',y,')'
    
    y_tl = data[x-1,y+1]
    y_t  = data[x,y+1]
    y_tr = data[x+1,y+1]
    y_l  = data[x-1,y]
    y_r  = data[x+1,y]
    y_bl = data[x-1,y-1]
    y_b  = data[x,y-1]
    y_br = data[x+1,y-1]
    
    mean_y = (y_tl + y_t + y_tr + y_l + y_r + y_bl + y_b + y_br) / 8.
    data[x,y] = mean_y
    
  endfor
  
end

;+
; :Description:
;    This routine will average each point by replacing its value by the
;    median of all the neighbors
;
; :Params:
;    norm_data
;
;
;
; :Author: j35
;-
pro median_neighbors, norm_data
  compile_opt idl2
  
  nbr_points = n_elements(norm_data)
  _index_ij = array_indices(norm_data, dindgen(nbr_points))
  help, _index_ij
  
  return
  
  index=0
  while (index lt nbr_points) do begin
  
  
  
  
  
  
  
  
    index++
  endwhile
  
  
  
;    x = index_gammas[0,i]
;    y = index_gammas[1,i]
;    if (x eq 0 or x eq (nbr_row-1)) then continue
;    if (y eq 0 or y eq (nbr_column-1)) then continue
;
;    ;print, '(x,y)=(',x,',',y,')'
;
;    y_tl = data[x-1,y+1]
;    y_t  = data[x,y+1]
;    y_tr = data[x+1,y+1]
;    y_l  = data[x-1,y]
;    y_r  = data[x+1,y]
;    y_bl = data[x-1,y-1]
;    y_b  = data[x,y-1]
;    y_br = data[x+1,y-1]
;
;    mean_y = (y_tl + y_t + y_tr + y_l + y_r + y_bl + y_b + y_br) / 8.
;    data[x,y] = mean_y
  
end

;------------------------------------------------------------------------------
PRO get_fits_info, file
  ;fits_info, file, TEXTOUT=1
  fits_help, file
  
;;;;;;output produced with fits_help
;    XTENSION  EXTNAME    EXTVER EXTLEVEL BITPIX GCOUNT  PCOUNT NAXIS  NAXIS*
;
;   0                                        8      0      0     0
;   1 BINTABLE XYPCLIST.TAB                  8      1      0     2  10 x 10000000
  
END

;------------------------------------------------------------------------------
PRO _read_fits_file, file, data

  print, file_test(file)
  
  print, 'Reading file and extracting data .... '
  ;a = mrdfits(file, 1, header, status=status)
  a = mrdfits(file,0,header,/fscale)
  data=a
  
;print, header
  
  
  
  
  
;;code to plot in color
;device, decompose=0
;loadct, 5
;tvscl, a
  
;print, 'Plotting Y vs X ...'
;WINDOW, 0, xsize = 500, ysize = 500, title = 'Y vs X'
;PLOT, a.x, a.y, psym=1, XSTYLE=1, YSTYLE=1
;print, '... done'
  
;  time = a.count
;  x = a.x     ;help, x ;500,000
;  y = a.y     ;help, y ;500,000
;  pulse = a.p ;help, pulse ;500,000
;
;  print, 'Plotting P vs C ...'
;  WINDOW, 1, title='P vs C'
;  plot, time, pulse, psym=1
;  print, '... done'
;
;  data = [x[0:100],y[0:100],pulse[0:100]]
  
;big_table = FLTARR(x_dimension, y_dimension, tof_dimension-1)
;big_table = INTARR(x_dimension, tof_dimension)
;  index = 0
;  WHILE (index LT N_ELEMENTS(x)) DO BEGIN
;  big_table = [x[index],y[index],time[index]]
;  index++
;  ENDWHILE
  
END