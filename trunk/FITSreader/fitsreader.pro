PRO FITSreader

  file2 = '~/results/121009_2.fits'
  file3 = '~/results/121009_3.fits'
  file4 = '~/results/121009_4.fits'
  file5 = '~/results/121609_1'
  file6 = '~/results/121609_2'
  file7 = '~/results/121609_3'
  file8 = '~/results/121609_4'
  file9 = '~/results/121609_5'
  file10 = '~/results/121609_6'
  
  file = file4
  
  ;;get info about file
  ;get_fits_info, file
  
  ;;read file
  read_fits_file, file, data
  
  ;;write fits file
  print, 'create the fits file ...'
  fits_write, '~/results/my_first_fits_file.fits', data
  print, '... done'
  
END

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
PRO read_fits_file, file, data

  print, 'Reading file and extracting data .... '
  a = mrdfits(file, 1, header, status=status)
  print, '... done'
  help, a,/structure
  
  print, 'Plotting Y vs X ...'
  WINDOW, 0, xsize = 500, ysize = 500, title = 'Y vs X'
  PLOT, a.x, a.y, psym=1, XSTYLE=1, YSTYLE=1
  print, '... done'
  
  time = a.count
  x = a.x     ;help, x ;500,000
  y = a.y     ;help, y ;500,000
  pulse = a.p ;help, pulse ;500,000
  
  print, 'Plotting P vs C ...'
  WINDOW, 1, title='P vs C'
  plot, time, pulse, psym=1
  print, '... done'
  
  data = [x[0:100],y[0:100],pulse[0:100]]
  
;big_table = FLTARR(x_dimension, y_dimension, tof_dimension-1)
;big_table = INTARR(x_dimension, tof_dimension)
;  index = 0
;  WHILE (index LT N_ELEMENTS(x)) DO BEGIN
;  big_table = [x[index],y[index],time[index]]
;  index++
;  ENDWHILE
  
END