;reads x column data

function xcr_direct, input_file, x
f=0
g=0

;open reduced data file and count lines of data

GET_LUN, unit
openr, unit, input_file

while (not EOF(unit)) do begin
    readf, unit, FORMAT = '(E,:)'
    g = g+1
    endwhile


array = MAKE_ARRAY(x, g, /float)

POINT_LUN, unit, 0

readf, unit, array


FREE_LUN, unit

return, array
END