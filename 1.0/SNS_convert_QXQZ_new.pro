;///////////////////////////////////////////
;SNS OFF SPECULAR ANALYSIS
;CONVERT Theta vs Lambda TO QXvsQZ SPACE
;ERIK WATKINS 9/21/2010
;//////////////////////////////////////////

function SNS_convert_QXQZ, THLAM, thvec, lamvec, theta_in, qxvec, qzvec


lambda_vec=reform(lamvec)
lambda_bin_vec=reform(lamvec)
lambda_step=lambda_vec[1]-lambda_vec[0]
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

QXQZ_values=make_array(5,data_size[0]*data_size[1],/float)

count = 0.0


for i=0, data_size[0]-1 do begin ; loop over wavelength values
    for j=0, data_size[1]-1 do begin ; loop over theta values
    lambdaval=lambda_vec[i]

    if data[i,j] gt 0 then begin

    lambdalo=lambda_bin_vec[i]-(lambda_step/2)
    lambdahi=lambdalo+lambda_step

    if j ne data_size[1]-1 then theta_step=abs(theta_vec[j+1]-theta_vec[j])
    thetahi = theta_vec[j]+theta_step/2
    thetalo = theta_vec[j]-theta_step/2

    Qx_lo = (2.0*!pi/lambdahi) * (cos(thetahi*!pi/180)-cos(theta_in*!pi/180))
    Qx_hi = (2.0*!pi/lambdalo) * (cos(thetalo*!pi/180)-cos(theta_in*!pi/180))

    Qz_lo= (2.0*!pi/lambdahi) * (sin(thetalo*!pi/180)+sin(theta_in*!pi/180))
    Qz_hi= (2.0*!pi/lambdalo) * (sin(thetahi*!pi/180)+sin(theta_in*!pi/180))

    QXQZ_values[0,count] = Qx_lo
    QXQZ_values[1,count] = Qx_hi
    QXQZ_values[2,count] = Qz_lo
    QXQZ_values[3,count] = Qz_hi
    QXQZ_values[4,count] = data[i,j]

    count++

;    endif
    endif
    endfor
endfor

si=size(QXQZ_values,/dim)
si=si[1]

QXQZ_ARRAY=make_array(qx_bins,qz_bins,/float)
QXQZ_count=make_array(qx_bins,qz_bins,/float)


;below is the binning method
ok=0
count=0.0
fullcount=0.0
tecount=0.0
becount=0.0
recount=0.0
lecount=0.0

total_area = 0.0


while ok eq 0 do begin

QX_lo=QXQZ_values[0,count]
QX_hi=QXQZ_values[1,count]

QZ_lo=QXQZ_values[2,count]
QZ_hi=QXQZ_values[3,count]

int=QXQZ_values[4,count]


QX_lo_pos=max(where(QX_lo ge QXvec))
QX_hi_pos=min(where(QX_hi le QXvec))

QZ_lo_pos=max(where(QZ_lo ge QZvec))
QZ_hi_pos=min(where(QZ_hi le QZvec))

if QZ_lo_pos eq -1 then QZ_lo_pos=0
if QZ_hi_pos eq -1 then QZ_hi_pos=qz_bins-1
if Qx_lo_pos eq -1 then Qx_lo_pos=0
if Qx_hi_pos eq -1 then Qx_hi_pos=qx_bins-1

totalbins=(QX_hi_pos-QX_lo_pos+1)*(QZ_hi_pos-QZ_lo_pos+1)


;below crudely splits the intensity equally among all bins
totalbins=(QX_hi_pos-QX_lo_pos+1)*(QZ_hi_pos-QZ_lo_pos+1)

for loopx=QX_lo_pos,QX_hi_pos do begin
    for loopy=QZ_lo_pos,QZ_hi_pos do begin
       QXQZ_ARRAY[loopx,loopy]=QXQZ_ARRAY[loopx,loopy]+(int/totalbins)
       QXQZ_count[loopx,loopy]=QXQZ_count[loopx,loopy]+1.0;+(1.0/totalbins)
    endfor
endfor

if count eq si-1 then ok=1
count++
endwhile



;multiply *QZ^4
qxqz4=qxqz_array
for loop=0,qz_bins-1 do begin
    qxqz4[*,loop]=qxqz_array[*,loop]*qzvec[loop]^4
endfor

qxqz_norm=qxqz_count*0.0

for loopx=0, qx_bins-1 do begin
for loopz=0,qz_bins-1 do begin
    qxqz_norm[loopx,loopz]=qxqz_array[loopx,loopz]/qxqz_count[loopx,loopz]
endfor
endfor

norm=qxqz_array/qxqz_count
badlist=where(finite(norm) eq 0)
norm[badlist]=0.0

return, norm
end