;write 3 column data

function xcw_direct, array, output_file, x


GET_LUN, unit
openw, unit, output_file

tab = STRING(9b)

s=size(array,/dim)
xsize=s[0]
ysize=s[1]
sdata=strtrim(array,2)
sdata[0:xsize-1,*]=sdata[0:xsize-1,*] + tab
printf, unit, sdata


FREE_LUN, unit

END