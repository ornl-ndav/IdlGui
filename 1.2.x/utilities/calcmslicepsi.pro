function calcMslicePsi,  rotationangle, seblock

  ; Get the value for SEBlock from either the NeXus or CVINFO file
  seblock_value = 0.0
  
  ;psi = - (180 - seblock_value - rotationangle) / 2.0
  
  psi = seblock_value + rotationangle_offset
  
  return, psi
end
