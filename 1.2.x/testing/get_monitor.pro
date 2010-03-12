function get_monitor, filename, number, Entry=entry

  ; open the file
  status=nxopen(filename, "NXACC_READ", fileid)

  if not KEYWORD_SET(Entry) then begin
    entry="entry"
  endif

  ; Open the NXentry
  status=nxopengroup(fileid, entry, "NXentry")

  ; Check to see if NXentry was opened ok.
  if (status EQ 0) then begin
    print, "ERROR: The specified NXentry '"+entry+"' doesn't exist!"
  endif
  
  ; Try to open the NXmonitor
  monitor_group = "monitor"+STRTRIM(number, 2)
  status=nxopengroup(fileid, monitor_group, "NXmonitor")
  
  ; Make sure the NXmonitor was opened ok.
  if (status EQ 0) then begin
    print, "ERROR: The specified Monitor '"+monitor_group+"' doesn't exist!"
  endif
  
  ; Read the data
  status=nxopendata(fileid, "data")
  status=nxgetdata(fileid, data)
  status=nxclosedata(fileid)
  
  ; Read the distance
  status=nxopendata(fileid, "distance")
  status=nxgetdata(fileid, distance)
  status=nxclosedata(fileid)
  
  status=nxopendata(fileid, "time_of_flight")
  status=nxgetdata(fileid, time_of_flight)
  status=nxclosedata(fileid)
  
  ; close the file
  status=nxclose(fileid)

  return, { data:data, $
            distance:distance, $
            tof:time_of_flight }
end