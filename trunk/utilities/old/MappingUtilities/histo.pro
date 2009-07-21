PRO histo

  event_file = "~/EQSANS/EQSANS_33/EQSANS_33_neutron_event.dat"
  ;event_file = "~/402/preNeXus/CNCS_402_neutron_event.dat"
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5
  
  ;read fileDAS
  OPENR,u,event_file,/get
  fs=FSTAT(u)
  N = fs.size
  N /= 4
  
  data = LONARR(N)
  READU,u,data
  CLOSE, u
  FREE_LUN,u
  
  array = LONARR(4L*48L*256L)
  
  FOR i=1L,N_ELEMENTS(data)-1L,2L DO BEGIN
    IF (data[i] GE 0) THEN array[data[i]]++
  ENDFOR
  
  new_array = reform(array,256L,4L*48L)
  window,0
  t_new_array = transpose(new_array)
  rt_new_array = rebin(t_new_array,5L*4L*48L, 2*256L)
  
  window,0
  tvscl, rt_new_array
  
  ;we gonna switch the 8-packs now
  s_array = LONARR(4L*48L,256L)
  index = 0
  for i=0,(48L*4L)-9,8 DO BEGIN
  print, index
    s_array[index,*] = t_new_array[index+7,*]
    s_array[index+1,*] = t_new_array[index+6,*]
    s_array[index+2,*] = t_new_array[index+5,*]
    s_array[index+3,*] = t_new_array[index+4,*]
    s_array[index+4,*] = t_new_array[index+3,*]
    s_array[index+5,*] = t_new_array[index+2,*]
    s_array[index+6,*] = t_new_array[index+1,*]
    s_array[index+7,*] = t_new_array[index+0,*]
    index = index+8
  ENDFOR
  window,1, title='after switching 8packs'
  rt_s_array = rebin(s_array, 5L*4L*48L, 2*256L)
  tvscl, rt_s_array
  
  END