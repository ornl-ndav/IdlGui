function get_beamtimeinfo_filename, instrument, runnumber

  ; use find nexus to get the preNeXus directory
  prenexus_dir = get_preNeXus_directory(instrument, runnumber)
  
  ; Check to see if this directory is there?
  IF FILE_TEST(prenexus_dir, /DIRECTORY) EQ 0 THEN return, 'ERROR'
  
  ; TODO: Check that the preNeXus directory exists and is readable.
  
  runinfo = prenexus_dir + '/'
  runinfo += STRUPCASE((strcompress(string(instrument), /REMOVE_ALL)))
  runinfo += '_beamtimeinfo.xml'
  
  ; TODO: check that the file exists before returning the filename.
  
  return, runinfo
end