pro idl_bin

  file = OBJ_NEW('idlxmlparser', 'idl_bin.cfg')
  
  ;read config file
  restore_file = file->getValue(tag=['configuration','restore_file_name'])
  number = file->getValue(tag=['configuration','dqtbinning','number'])
  calfile = file->getValue(tag=['configuration','dqtbinning','calfile'])
  binary_file = file->getValue(tag=['configuration','dqtbinning','binary_file'])
  path_to_event_file = file->getValue(tag=['configuration','dqtbinning','path_to_event_file'])
  back_file = file->getValue(tag=['configuration','creategr','back_file'])
  
  obj_destroy, file
  
  ;restore the wherebad array
  restore, restore_file
  
  ;perform Q binning
  histo = 'h' + number
  dqtbinning,histo,fmatrix,use=1,option=1,dq=1,maxd=50,$
    filen=binary_file,$
    pseudov=0,$
    calfile=calfile,$
    sil=1, $
    path_to_event_file=path_to_event_file
    
  ;save,h9999,filen='h2430.dat
    
  sumall = 'a' + number
  ibank = 'b' + number
  ipacks = 'p' + number
  itubes = 't' + number
  
  output_file = 'all' + number + '.dat'
  
  grouping,histo, sumall, ibank, ipacks, itubes, wherebad=wherebad
  save,ipacks, sumall, ibank, filen=output_file
  creategr,sumall, ibank, back=back_file, $
    hydro=0,$
    qmin=30,$
    qmax=30,$
    sc=fix(number),$
    inter=0
    
end