;+
; :Description:
;    This routine will ask the user to select a background tif file and then 
;    will subtract all the other file selected from this background file
;
;
;
;
;
; :Author: j35
;-
pro subtract_tif_files
compile_opt idl2

bPreview = 1b

;path = '/Volumes/h2b/h2b/Data_Analysis/2010/2010 EGR/cycle432/November23_2010/November23_2010_tif/Octopus/Octogood/reconstructed'
path = '/Volumes/h2b/Pour_JC/EGR3_5_July8_2010/'
filter = '*.tif'
output_path = '/Volumes/h2b/Pour_JC/subtracted/'

background_file_name = dialog_pickfile(path=path, $
filter=filter, title='Select the background file', $
/multiple_files)

if (background_file_name[0] eq '') then return

sz = n_elements(background_file_name)
_index = 0
while (_index lt sz) do begin
_back_data = read_tiff(background_file_name[_index])
if (_index eq 0) then begin
back_data = _back_data
endif else begin
back_data += _back_data
back_data /= back_data/2.
endelse
_index++
endwhile
;help, back_data

;preview background file
if (bPreview) then begin
sz = size(back_data,/dim)
new_xsize = sz[0]/2
new_ysize = sz[1]/2
window, 0, xsize=new_xsize, ysize=new_ysize, title='background data'
cData = congrid(back_data, new_xsize, new_ysize)
tvscl, cData
endif

all_files = dialog_pickfile(path=path, $
filter=filter, title='Select all the other files',$
/multiple_files)

if (all_files[0] eq '') then return

sz = n_elements(all_files)
for i=0,sz-1 do begin
  short_file_name = file_basename(all_files[i])
  ;remove ext
  _tmp = strsplit(short_file_name,'.',/extract)
  short_without_ext = _tmp[0]
  output_file_name = output_path + short_without_ext + '_sub.tif'

  _data = read_tiff(all_files[i])
  _new_data = _data - back_data

   write_tiff, output_file_name, _new_data
endfor

end