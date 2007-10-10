function parse_string, first_line

result_array = strsplit(first_line,"_",/extract)
result = [strcompress(result_array[1]),$
          strcompress(result_array[2])]
return, result
end



function GET_SIGNAL_XY_MIN_MAX, full_file_name

;to get only the first line of the file
cmd = "head " + full_file_name + " -n 1"
spawn, cmd, first_line

;to get only the last line of the file
cmd = "tail " + full_file_name + " -n 1"
spawn, cmd, last_line

Min = parse_string(first_line)
Max = parse_string(last_line)

xmin = Min[0]
ymin = Min[1]
xmax = Max[0]
ymax = Max[1]

;return xmin, ymin, xmax, ymax
return, [strcompress(xmin),$
         strcompress(ymin),$
         strcompress(xmax),$
         strcompress(ymax)]
end
