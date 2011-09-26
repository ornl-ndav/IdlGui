;+
; :Description:
;    using the left and right values, create the sequence
;
; :Keywords:
;    from   first number of sequence
;    to     last number of sequence
;
; :Author: j35
;-
function getSequence, from=left, to=right
  compile_opt idl2
  
  catch, no_error
  if (no_error ne 0) then begin
    catch,/cancel
    return, ['']
  endif else begin
    on_ioerror, done
    iLeft  = long(left)
    iRight = long(right)
    sequence = indgen(iRight-iLeft+1)+iLeft
    return, strcompress(string(sequence),/remove_all)
    done:
    return, [strcompress(left,/remove_all)]
  ENDELSE
END

;+
; :Description:
;    Parse the run numbers text field and create the list of
;    run numbers
;    
; :Keywords:
;   run_number_string
;
; :Author: j35
;-
function parse_run_numbers, run_number_string=run_number_string
  compile_opt idl2

  list_of_runs = !null
  
  if (run_number_string eq '') then begin
    return, list_of_runs
  endif
  
  split1 = strsplit(run_number_string,',',/extract,/regex)
  sz1 = n_elements(split1)
  index1 = 0
  while (index1 lt sz1) do begin
  
    split2 = strsplit(split1[index1],'-',/extract,/regex)
    sz2 = n_elements(split2)
    if (sz2 eq 1) then begin
      list_of_runs = [list_of_runs,strcompress(split2[0],/remove_all)]
    endif else begin
      new_runs = getSequence(from=split2[0], to=split2[1])
      list_of_runs = [list_of_runs, new_runs]
    endelse
    index1++
  endwhile
  
  return, list_of_runs
  
end

;+
; :Description:
;    Main procedure
;
; :Author: j35
;-
pro idl_bin
  compile_opt idl2
  
  file = OBJ_NEW('idlxmlparser', 'idl_bin.cfg')
  
  ;read config file
  restore_file = file->getValue(tag=['configuration','restore_file_name'])
  number = file->getValue(tag=['configuration','dqtbinning','number'])
  calfile = file->getValue(tag=['configuration','dqtbinning','calfile'])
  binary_file = file->getValue(tag=['configuration','dqtbinning','binary_file'])
  path_to_event_file = file->getValue(tag=['configuration','dqtbinning','path_to_event_file'])
  back_file = file->getValue(tag=['configuration','creategr','back_file'])
  
  obj_destroy, file
  
  ;parse number
  list_number = parse_run_numbers(run_number_string=number)

  ;restore the wherebad array
  restore, restore_file
  
  nbr_files = n_elements(list_number)
  index=0
  
  while (index lt nbr_files) do begin
  
    number = list_number[index]
    
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
      
    index++
  endwhile
  
end