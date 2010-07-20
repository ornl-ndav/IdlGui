function calcei_python, instrument, run, guess


  cmd = 'source /SNS/users/lj7/drchops.sh && dgsmoncalc.py '
  cmd += instrument + ' ' + STRCOMPRESS(STRING(run),/REMOVE_ALL) 
  cmd += ' ' + STRCOMPRESS(STRING(guess),/REMOVE_ALL) 
  
  ;print, 'CMD=',cmd
  
  spawn, cmd, output
  
  result = {Ei:output[1], Tzero:output[2]}

  return, result
end
