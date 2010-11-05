;///////////////////////////////////////////
;SNS OFF SPECULAR ANALYSIS
;READ IN A NEXUS FILE
;ERIK WATKINS 9/21/2010
;//////////////////////////////////////////

;note to self:
;this fuckin shit
;fuckin shit
;theta and two theta in the nexus is not real
;the ones i pulled from /instrument/bank1 are bullshit
;fuck that shit
;who does that shit
;where is the real shit
;shit.

function SNS_read_NEXUS, filename, TOFmin, TOFmax, PIXmin, PIXmax

file_id= H5F_OPEN(filename)

data_id= H5D_OPEN(file_id, '/entry/bank1/data_y_time_of_flight')
image= H5D_READ(data_id)

  print, 'file name is: ' , filename
  help, image
  
TOF_id= H5D_OPEN(file_id, '/entry/bank1/time_of_flight')
TOF= H5D_READ(TOF_id)
TOF=TOF/1000.0   ;convert to ms

Theta_id=H5D_OPEN(file_id, '/entry/sample/ths/average_value')
Theta= H5D_READ(theta_id)

TwoTheta_id=H5D_OPEN(file_id, '/entry/instrument/bank1/tthd/average_value')
TwoTheta= H5D_READ(TwoTheta_id)

Theta=theta+4.0
TwoTheta=TwoTheta+4.0

print, 'TOFmin: ' , TOFmin
print, 'TOFmax: ' , TOFmax


;Determine where is the first and last tof in the range
list=where(TOF ge TOFmin and TOF le TOFmax)
t1=min(where(TOF ge TOFmin)) 
t2=max(where(TOF le TOFmax))

pixels=findgen(256)
p1=min(where(pixels ge PIXmin)) 
p2=max(where(pixels le PIXmax))

  print, 't1,t2,p1,p2: ' , t1,t2,p1,p2

TOF=TOF[t1:t2]
PIXELS=pixels[p1:p2]
image=image[t1:t2,p1:p2]

help, image

H5D_CLOSE, data_id
H5D_CLOSE, TOF_id
H5D_CLOSE, Theta_id
H5D_CLOSE, TwoTheta_id
H5F_CLOSE, file_id

;image -> data (counts)
;tof   -> tof axis
;pixels -> list of pixels to keep in calculation
DATA={data:image, theta:theta, twotheta:twotheta, tof:tof, pixels:pixels}
return, DATA
end