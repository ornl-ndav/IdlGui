function get_output_directory, instrument, runnumber

  beamtimeinfo_file = get_beamtimeinfo_filename(instrument, runnumber)
  
  proposal = getProposalfromPreNeXus(beamtimeinfo_file)
  
  output_directory  = '/SNS/' + STRUPCASE(STRCOMPRESS(string(instrument),/REMOVE_ALL))
  output_directory += '/' + STRCOMPRESS(string(proposal),/REMOVE_ALL)
  output_directory += '/shared/' +  get_ucams()
  
  return, output_directory
end