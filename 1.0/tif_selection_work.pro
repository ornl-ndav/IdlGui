
;+
; :Description:
;    This routine calculate the total counts of the predefined ROI and
;    create an output file of all the counts of all the files
;
;
;
;
;
; :Author: j35
;-
pro tif_selection_work
  compile_opt idl2
  
;  path = '/Volumes/h2b/h2b/Data_Analysis/2011/2011 Forensic/Cycle 433/Feb1_2011/Overnight_muscle/Despeckled/Normalized/'
;  selection = [[592,876,592+148,876+158],$
;    [1034,1048,1034+218,1048+248],$
;    [958,1558,958+224,1558+252],$
;    [1658,1280,1658+228,1280+222],$
;    [1536,1778,1536+312,1778+266],$
;    [2072,1388,2072+254,1388+250],$
;    [2572,1480,2572+128,1480+122],$
;    [2130,2222,2130+64,2222+64],$
;    [2324,2186,2324+66,2186+70],$
;    [1994,2288,1994+80,2288+62],$
;    [2264,2262,2264+72,2262+74],$
;    [2154,2336,2154+68,2336+62]]
  
  path = '/Volumes/h2b/h2b/Data_Analysis/2011/2011 Forensic/Cycle 433/Feb2_2011/Overnight_muscle_5C/Despeckled/Normalized/'
  selection = [[274,748,274+64,748+79],$
  [828,722,828+132,722+188],$
  [370,972,370+107,972+89],$
  [399,582,399+86,582+94],$
  [717,372,717+89,372+89],$
  [659,580,659+160,580+147],$
  [626,819,626+155,819+129],$
  [395,765,395+92,765+81],$
  [636,1020,636+159,1020+103],$
  [914,1094,914+117,1094+92],$
  [970,429,970+56,429+198],$
  [1128,539,1128+45,539+212],$
  [1342,821,1342+39,821+192],$
  [1017,820,177+1017,151+820]]

  filter = ['N_D*.tif'] 
  output_path = '~/Desktop/'
  output_file_name = output_path + 'Feb2_2011_selections.txt'
  
  bCheckSelection = 1b
  bDoCalculation = 0b
  
    
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
      
      print, sz
      
      new_xsize = sz[0]/2
      new_ysize = sz[1]/2
      
      window, 0, xsize=new_xsize, ysize=new_ysize, title=_file
      
      cData = congrid(data,new_xsize, new_ysize)
      
      help, cData
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
      
      stop
      wait,2
      
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

  endif
  
end



