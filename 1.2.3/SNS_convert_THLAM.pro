;///////////////////////////////////////////
;SNS OFF SPECULAR ANALYSIS
;Convert nexus to theta vs lambda
;ERIK WATKINS 9/21/2010
;//////////////////////////////////////////

function SNS_convert_THLAM, data, SD_d, MD_d, cpix, pix_size

  TOF=data.TOF
  vel=MD_d/TOF         ;mm/ms = m/s
  
  h=6.626e-34   ;m^2 kg s^-1
  m=1.675e-27     ;kg
  
  lambda=h/(m*vel)  ;m
  lambda=lambda*1e10  ;angstroms
  
  theta_val=data.twotheta-data.theta
  
  ;theta_val=data.theta
  theta_val=theta_val[0]
  d_vec=(data.pixels-cpix)*pix_size
  thetavec=(atan(d_vec/SD_d)/!DTOR)+theta_val
  
  THLAM={data:data.data, lambda:lambda, theta:thetavec}
  
  return, THLAM
  
end