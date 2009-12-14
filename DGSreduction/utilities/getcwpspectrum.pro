function GetCWPspectrum, nexusfile

  ; Let's first check to see if the NeXus file has been produced with the
  ; integrated views.
  
  ; TODO: We could do this by just looking for the array or check the 
  ; version of TranslationService that was used? 
  
  event2histo_nxl_exe = '/SNS/software/TESTING/bin/event2histo_nxl'

  

  x = fltarr(1000)
  y = fltarr(1000)

  return, { x:x, y:y }
end
