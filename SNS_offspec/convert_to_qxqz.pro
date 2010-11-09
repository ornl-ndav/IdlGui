;+
; :Description:
;    convert the array into QxQz
;
; :Params:
;    THLAM
;    thvec
;    lamvec
;    theta_in
;    qxvec
;    qzvec
;    lambda_step
;
;-
function convert_to_QXQZ, THLAM, $
    thvec, $
    lamvec, $
    theta_in, $
    qxvec, $
    qzvec, $
    lambda_step
  compile_opt idl2
  
  ;two go from [1,n] to [n]
  lambda_vec=reform(lamvec)
  lambda_bin_vec=reform(lamvec)
  theta_vec=reform(thvec)
  data=reform(THLAM)
  
  data_size=size(data,/dim)
  
  si=size(qxvec,/dim)
  qx_bins=si[0]
  
  si=size(qzvec,/dim)
  qz_bins=si[0]
  
  
  ;*********************************************************
  ; REBIN TOF vs PIX MATRIX into QX vs QZ SPACE
  ;*********************************************************
  
  ;Create the map in the Qx and Qz space of the
  ;lambda and theta map
  
  ;QXQZ_values[Qx_lo, Qx_hi, Qz_lo, Qz_hi, data]
  QXQZ_values=make_array(5,data_size[0]*data_size[1],/float)
  
  index = 0
  for i=0, data_size[0]-1 do begin ; loop over wavelength values
    for j=0, data_size[1]-1 do begin ; loop over theta values
    
      lambdaval=lambda_vec[i]
      
      if data[i,j] gt 0 then begin
      
        lambdalo=lambda_bin_vec[i]
        lambdahi=lambdalo+lambda_step
        
        if j ne data_size[1]-1 then theta_step=abs(theta_vec[j+1]-theta_vec[j])
        thetahi = theta_vec[j]+theta_step/2
        thetalo = theta_vec[j]-theta_step/2
        
        Qx_lo = (2.0*!pi/lambdahi) * (cos(thetahi*!pi/180)-cos(theta_in*!pi/180))
        Qx_hi = (2.0*!pi/lambdalo) * (cos(thetalo*!pi/180)-cos(theta_in*!pi/180))
        
        Qz_lo= (2.0*!pi/lambdahi) * (sin(thetalo*!pi/180)+sin(theta_in*!pi/180))
        Qz_hi= (2.0*!pi/lambdalo) * (sin(thetahi*!pi/180)+sin(theta_in*!pi/180))
        
        QXQZ_values[0,index] = Qx_lo
        QXQZ_values[1,index] = Qx_hi
        QXQZ_values[2,index] = Qz_lo
        QXQZ_values[3,index] = Qz_hi
        QXQZ_values[4,index] = data[i,j]
        
        index++
        
      endif
    endfor
  endfor
  
  si=size(QXQZ_values,/dim)
  si=si[1]
  
  QXQZ_ARRAY=make_array(qx_bins,qz_bins,/float)
  
  ;below is the binning method
  ok=0
  count=0.0
  fullcount=0.0
  tecount=0.0
  becount=0.0
  recount=0.0
  lecount=0.0
  
  total_area = 0.0
  
  while (ok eq 0) do begin
  
    QX_lo=QXQZ_values[0,count]
    QX_hi=QXQZ_values[1,count]
    
    QZ_lo=QXQZ_values[2,count]
    QZ_hi=QXQZ_values[3,count]
    
    int=QXQZ_values[4,count]
    
    ;check where is the last index of data
    
    ;get the last index where QX_lo is smaller or equal to the QX axis
    QX_lo_pos=max(where(QX_lo ge QXvec, nbr_qx_lo_pos))
    
    ;get the first index where QX_hi is bigger or equal to the QX axis
    QX_hi_pos=min(where(QX_hi le QXvec, nbr_qx_hi_pos))
    
    QZ_lo_pos=max(where(QZ_lo ge QZvec, nbr_qz_lo_pos))
    QZ_hi_pos=min(where(QZ_hi le QZvec, nbr_qz_hi_pos))
    
    ;    if (count eq 0) then begin
    ;    help, QXvec
    ;    print, QXvec[250:260]
    ;    help, QX_lo
    ;    print, 'QX_lo_pos: ' , QX_lo_pos
    ;    print, where(QX_lo ge QXvec)
    ;    print
    ;    endif
    
    if nbr_qz_lo_pos eq 0 then QZ_lo_pos=0
    if nbr_qz_hi_pos eq 0 then QZ_hi_pos=qz_bins-1
    if nbr_qx_lo_pos eq 0 then Qx_lo_pos=0
    if nbr_qx_hi_pos eq 0 then Qx_hi_pos=qx_bins-1
    
    ;below crudely splits the intensity equally among all bins
    ;calculate the number of bins in each of the new box
    totalbins=(QX_hi_pos-QX_lo_pos+1)*(QZ_hi_pos-QZ_lo_pos+1)

    for loopx=QX_lo_pos,QX_hi_pos do begin
      for loopy=QZ_lo_pos,QZ_hi_pos do begin
        QXQZ_ARRAY[loopx,loopy]=QXQZ_ARRAY[loopx,loopy]+(int/totalbins)
      endfor
    endfor
    
    if count eq si-1 then ok=1
    count++
  endwhile
  
  ;????? why
  ;multiply *QZ^4
  qxqz4=qxqz_array
  for loop=0,qz_bins-1 do begin
    qxqz4[*,loop]=qxqz_array[*,loop]*qzvec[loop]^4
  endfor
  
  return, qxqz_array
end