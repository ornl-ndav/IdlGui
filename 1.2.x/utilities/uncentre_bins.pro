function uncentre_bins, array

  ; First lets estimate the halfwidth
  halfWidth=(array[1]-array[0])/2.0
  ;print, 'UNCENTRE_BINS: Using an (estimated) halfwidth of '+STRTRIM(halfWidth,2)
  
  result = array[0:(N_ELEMENTS(array)-2)] + halfWidth
  
  return, result
end