;+
; :Description:
;    reads the file and returns a string array of its contain
;
; :Params:
;    file
;
; :Author: j35
;-
FUNCTION READ_DATA, file
compile_opt idl2

  ;Open the data file.
  openr, 1, file
  
  ;Set up variables
  line = strarr(1)
  tmp = ''
  i = 0
  
  while (~eof(1)) do begin
    nbr_lines = file_lines(file)
    my_array = strarr(1,nbr_lines)
    readf,1, my_array
  endwhile
          
  close,1
  
  return, my_array
end

;+
; :Description:
;    This procedure parse the ascii file and isolates all the data and metadata
;    needed
;
; :Author: j35
;-
function IDLASCIIparser::parseFile
compile_opt idl2

data = read_data(self.path)

structure = ptr_new({ T_range: ptr_new(0L), $
              nbrT: 0L, $
              Q_range: ptr_new(0L), $
              nbrQ: 0L, $
              Q_data: ptr_new(0L), $
              Q_data_error: ptr_new(0L) })

;retrieve the number of T values
T_nbr_tag_index = where(data eq '# Number of T values')
nbrT = fix(data[T_nbr_tag_index+1])
nbrT = nbrT[0]
(*structure).nbrT = nbrT

;retrieve the number of Q values
Q_nbr_tag_index = where(data eq '# Number of Q values')
nbrQ = fix(data[Q_nbr_tag_index+1])
nbrQ = nbrQ[0]
(*structure).nbrQ = nbrQ

;retrieve the range of T and Q
T_range_tag_index = where(data eq '# T (Kelvin) Values:')
Q_range_tag_index = where(data eq '# Q (1/Angstroms) Values:')
group0_range_tag_index = where(data eq '# Group 0')
T_range = data[T_range_tag_index+1:Q_range_tag_index-1]
(*(*structure).T_range) = T_range
Q_range = data[Q_range_tag_index+1:group0_range_tag_index-1]
(*(*structure).Q_range) = Q_range

;retrieve all the data (without the error value)
index = 0
_index_file = group0_range_tag_index[0]
Q_data = strarr(nbrT, NbrQ)
While (index lt nbrQ) do begin
  Q_data[*,index] = data[_index_file+1:_index_file+nbrT]
  _index_file += fix(nbrT)+1
  index++
endwhile

;separate data from error
Q_data_error = strarr(nbrT, NbrQ)
for i_t=0, nbrT-1 do begin
  for j_q=0, nbrQ-1 do begin
    data_error = strsplit(Q_data[i_t,j_q],' ',/extract)
;    data_error = strjoin(strcompress(data_error,/remove_all),';')
    Q_data[i_t,j_q] = strtrim(data_error[0],2)
    Q_data_error[i_t,j_q] = strtrim(data_error[1],2)
    endfor
endfor

(*(*structure).Q_data) = float(Q_data)
(*(*structure).Q_data_error) = float(Q_data_error)

return, structure
end

;+
; :Description:
;    init method of class. Returns 1 if the file has been found and can
;    be read
;
; :Params:
;    location ;full file name 
;
; :Author: j35
;-
function IDLASCIIparser::init, location
compile_opt idl2
  ;set up the path
  self.path = location
  return, file_test(location, /READ)
end

pro IDLASCIIparser__define
  struct = {IDLASCIIparser,$
            data: ptr_new(),$
            path: ''}

end
