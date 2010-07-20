function get_preNeXus_directory, instrument, runnumber

  ; just use findnexus to get the preNeXus directory
  findnexus_cmd = 'findnexus --prenexus -i ' + instrument + ' ' + strcompress(string(runnumber), /REMOVE_ALL)
  spawn, findnexus_cmd, listening
  prenexus = listening[0]
  
  return, prenexus
end