function get_runinfo_filename, instrument, runnumber

  ; use find nexus to get the preNeXus directory
  prenexus_dir = get_preNeXus_directory(instrument, runnumber)
  
  runinfo = prenexus_dir + '/'
  runinfo += STRUPCASE((strcompress(string(instrument), /REMOVE_ALL)))
  runinfo += '_'
  runinfo += strcompress(string(runnumber), /REMOVE_ALL)
  runinfo += '_runinfo.xml'
  
  return, runinfo
end