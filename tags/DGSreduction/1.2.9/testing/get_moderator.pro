;+
; :Description:
;    Returns the parameters for the moderator from a given
;    NeXus file.
;
; :Params:
;    filename - The NeXus file to read
;
; :Keywords:
;    Entry - A string containing the name of the entry to 
;            read the moderator from.  If it is not specified
;            then we will use 'entry' as the name.
;
; :Author: scu
;-
function get_moderator, filename, Entry=entry

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
  
  ; Open the NXinstrument
  status = nxopengroup(fileid, "instrument", "NXinstrument")
  ; Open the NXmoderator
  status = nxopengroup(fileid, "moderator", "NXmoderator")
  
  ; Read the distance
  status=nxopendata(fileid, "distance")
  status=nxgetdata(fileid, distance)
  status=nxclosedata(fileid)
  
  status=nxopendata(fileid, "poison_depth")
  status=nxgetdata(fileid, poison_depth)
  status=nxclosedata(fileid)
  
  status=nxopendata(fileid, "poison_material")
  status=nxgetdata(fileid, poison_material)
  status=nxclosedata(fileid)
    
  status=nxopendata(fileid, "temperature")
  status=nxgetdata(fileid, temperature)
  status=nxclosedata(fileid)
  
  status=nxopendata(fileid, "type")
  status=nxgetdata(fileid, type)
  status=nxclosedata(fileid)
  
  ; close the file
  status=nxclose(fileid)

  return, { distance:distance, $
            poison_depth:poison_depth, $
            poison_material:poison_material, $
            temperature:temperature, $
            type:type }
end