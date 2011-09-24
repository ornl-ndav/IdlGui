
pro detpos,tt,phi,r,x,y,z,there,number,sa=sa

if not var_defined(sa) then sa=0
; default use nominal positons not survey&alignment

n_eight=63
n_eightf=38

tt=fltarr((n_eight+n_eightf)*8,128)
phi=fltarr((n_eight+n_eightf)*8,128)
r=fltarr((n_eight+n_eightf)*8,128)
x=fltarr((n_eight+n_eightf)*8,128)
; x = up
y=fltarr((n_eight+n_eightf)*8,128)
; y = right (in beam direction)
z=fltarr((n_eight+n_eightf)*8,128)
; z=  in beam direction
there=fltarr((n_eight+n_eightf)*8,128)
there([3,7,8,9,10,11,19],*)=1
number=fltarr((n_eight+n_eightf)*8,128)
for i=0,(n_eight+n_eightf)*8-1 do number(i,*)=findgen(128)+128l*i


N_first=14
z0_first=6.41/8.45*3.2
x0_first=1.31/8.45*3.2
z1_first=3.86/8.45*3.2
x1_first=1.44/8.45*3.2
dx_first=x1_first-x0_first
dz_first=z1_first-z0_first
section=360/float(n_first)

onehundredtwentyeight=findgen(128)

for i=0,n_first-1 do begin
angle=(360*(i+.5)/float(N_first))*!dtor
x0=-x0_first*cos(section*i*!dtor)
y0=x0_first*sin(section*i*!dtor)
x1=-x1_first*cos(section*i*!dtor)
y1=x1_first*sin(section*i*!dtor)

for j=0,7 do begin
x0j=x0+j*(.0254+0.001)*sin(section*(i+.5)*!dtor)
y0j=y0+j*(.0254+0.001)*cos(section*(i+.5)*!dtor)
x1j=x1+j*(.0254+0.001)*sin(section*(i+.5)*!dtor)
y1j=y1+j*(.0254+0.001)*cos(section*(i+.5)*!dtor)
x(i*8+j,*)=x0j+(x1j-x0j)*(1-onehundredtwentyeight/128.)
y(i*8+j,*)=y0j+(y1j-y0j)*(1-onehundredtwentyeight/128.)
z(i*8+j,*)=z0_first+dz_first*(1-onehundredtwentyeight/128.)
end
end
N_second=23
;z0_second=5.05/8.45*3.2
;x0_second=2.24/8.45*3.2
;z1_second=2.54/8.45*3.2
;x1_second=2.24/8.45*3.2
z0_second=5.09/7.06*2.7-0.0095
x0_second=2.22/7.06*2.7
z1_second=2.45/7.06*2.7+0.0095
x1_second=2.22/7.06*2.7
dx_second=x1_second-x0_second
dz_second=z1_second-z0_second
section=360/float(n_second)



for i=0,n_second-1 do begin
angle=(360*(i+.5)/float(N_second))*!dtor
x0=-x0_second*cos(section*i*!dtor)
y0=x0_second*sin(section*i*!dtor)
x1=-x1_second*cos(section*i*!dtor)
y1=x1_second*sin(section*i*!dtor)

for j=0,7 do begin
x0j=x0+j*(.0254+0.001)*sin(section*(i+.5)*!dtor)
y0j=y0+j*(.0254+0.001)*cos(section*(i+.5)*!dtor)
x1j=x1+j*(.0254+0.001)*sin(section*(i+.5)*!dtor)
y1j=y1+j*(.0254+0.001)*cos(section*(i+.5)*!dtor)
x((i+n_first)*8+j,*)=x0j+(x1j-x0j)*onehundredtwentyeight/128.
y((i+n_first)*8+j,*)=y0j+(y1j-y0j)*onehundredtwentyeight/128.
z((i+n_first)*8+j,*)=z0_second+dz_second*onehundredtwentyeight/128.
end
end
N_third=14
ii=[3,4,5,6,7,8,9,18,19,20,21,22,23,24]+.5
;z0_third=2.60/8.45*3.2
;x0_third=2.56/8.45*3.2
;z1_third=0/8.45*3.2
;x1_third=2.56/8.45*3.2
z0_third=2.59/7.06*2.7-0.0076
;x0_third=2.61/7.06*2.7
x0_third=1.00
z1_third=-0.04/7.06*2.7+.0076
;x1_third=2.61/7.06*2.7
x1_third=1.00
dx_third=x1_third-x0_third
dz_third=z1_third-z0_third
section=360/float(29)



for i=0,n_third-1 do begin
angle=(360*(ii(i)+.5)/float(N_third))*!dtor
x0=-x0_third*cos(section*ii(i)*!dtor)
y0=x0_third*sin(section*ii(i)*!dtor)
x1=-x1_third*cos(section*ii(i)*!dtor)
y1=x1_third*sin(section*ii(i)*!dtor)

for j=0,7 do begin
x0j=x0+j*(.0254+0.001)*sin(section*(ii(i)+.5)*!dtor)
y0j=y0+j*(.0254+0.001)*cos(section*(ii(i)+.5)*!dtor)
x1j=x1+j*(.0254+0.001)*sin(section*(ii(i)+.5)*!dtor)
y1j=y1+j*(.0254+0.001)*cos(section*(ii(i)+.5)*!dtor)
x((i+n_first+n_second)*8+j,*)=x0j+(x1j-x0j)*(1-onehundredtwentyeight/128.)
y((i+n_first+n_second)*8+j,*)=y0j+(y1j-y0j)*(1-onehundredtwentyeight/128.)
z((i+n_first+n_second)*8+j,*)=z0_third+dz_third*(1-onehundredtwentyeight/128.)
end
end
N_forth=12
ii=[2,3,4,5,6,7,13,14,15,16,17,18]+1
;z0_forth=-.2/8.45*3.2
;x0_forth=2.67/8.45*3.2
;z1_forth=-2.8/8.45*3.2
;x1_forth=2.08/8.45*3.2
z0_forth=-.28/7.06*2.7+.0016
x0_forth=2.66/7.06*2.7
z1_forth=-2.79/7.06*2.7-.0016
x1_forth=2.09/7.06*2.7
dx_forth=x1_forth-x0_forth
dz_forth=z1_forth-z0_forth
section=360/float(23)


for i=0,n_forth-1 do begin
angle=(360*(ii(i)+.5)/float(N_forth))*!dtor
x0=-x0_forth*cos(section*ii(i)*!dtor)
y0=x0_forth*sin(section*ii(i)*!dtor)
x1=-x1_forth*cos(section*ii(i)*!dtor)
y1=x1_forth*sin(section*ii(i)*!dtor)

for j=0,7 do begin
x0j=x0+j*(.0254+0.001)*sin(section*(ii(i)+.5)*!dtor)
y0j=y0+j*(.0254+0.001)*cos(section*(ii(i)+.5)*!dtor)
x1j=x1+j*(.0254+0.001)*sin(section*(ii(i)+.5)*!dtor)
y1j=y1+j*(.0254+0.001)*cos(section*(ii(i)+.5)*!dtor)
x((i+n_first+n_second+n_third)*8+j,*)=x0j+(x1j-x0j)*(1-onehundredtwentyeight/128.)
y((i+n_first+n_second+n_third)*8+j,*)=y0j+(y1j-y0j)*(1-onehundredtwentyeight/128.)
z((i+n_first+n_second+n_third)*8+j,*)=z0_forth+dz_forth*(1-onehundredtwentyeight/128.)
end
end
N_back=19
z0_back=-1.78/8.45*3.2
y0_back=1.32/8.45*3.2
for i=0,n_back-1 do begin

for j=0,7 do begin
ntube=i*8+j
x((i+n_first+n_second+n_third+n_forth)*8+j,*)=(1-onehundredtwentyeight/128.)-0.5
y((i+n_first+n_second+n_third+n_forth)*8+j,*)=y0_back-(.0254/2+.001)/2*ntube
z((i+n_first+n_second+n_third+n_forth)*8+j,*)=z0_back-((i/2)*2 eq i)*(.0254/2+.001)
end
end

N_forward=19
z0_forward=6.69/8.45*3.2
y0_forward=1.34/8.45*3.2
for i=0,n_back-1 do begin

for j=0,7 do begin
ntube=i*8+j
x((i+n_first+n_second+n_third+n_forth+n_back)*8+j,*)=(1-onehundredtwentyeight/128.)-0.5
y((i+n_first+n_second+n_third+n_forth+n_back)*8+j,*)=y0_forward-(.0254/2+.001)/2*ntube
z((i+n_first+n_second+n_third+n_forth+n_back)*8+j,*)=z0_forward-((i/2)*2 eq i)*(.0254/2+.001)
end
end

if sa eq 1 then begin
rstd,zz,yyxx,'BL1B\ Detector\ Asbuilt_m.txt',nz=3
yy=yyxx(*,0)
xx=yyxx(*,1)
there4=[54,57,58,59,60,61,62]
ixx=0
for i=0,6 do begin&$
x_u=xx(i*4:4*i+1)
y_u=-yy(i*4:4*i+1)
z_u=zz(i*4:4*i+1)
x_d=xx(i*4+2:4*i+3)
y_d=-yy(i*4+2:4*i+3)
z_d=zz(i*4+2:4*i+3)
for j=0,7 do begin
z(8*there4(i)+j,*)=z_u(0)-(z_u(0)-z_u(1))*j/8.-(z_u(0)-(z_u(0)-z_u(1))*j/8.-z_d(0)+(z_d(0)-z_d(1))*j/8.)*onehundredtwentyeight/128.
y(8*there4(i)+j,*)=y_u(0)-(y_u(0)-y_u(1))*j/8.-(y_u(0)-(y_u(0)-y_u(1))*j/8.-y_d(0)+(y_d(0)-y_d(1))*j/8.)*onehundredtwentyeight/128.
x(8*there4(i)+j,*)=x_u(0)-(x_u(0)-x_u(1))*j/8.-(x_u(0)-(x_u(0)-x_u(1))*j/8.-x_d(0)+(x_d(0)-x_d(1))*j/8.)*onehundredtwentyeight/128.
endfor
endfor
there3=[40,44,45,46,47,48,49,50]
for i=0,7 do begin&$
x_u=xx((i+6)*4:4*(i+6)+1)
y_u=-yy((i+6)*4:4*(i+6)+1)
z_u=zz((i+6)*4:4*(i+6)+1)
x_d=xx((i+6)*4+2:4*(i+6)+3)
y_d=-yy((i+6)*4+2:4*(i+6)+3)
z_d=zz((i+6)*4+2:4*(i+6)+3)
for j=0,7 do begin
z(8*there3(i)+j,*)=z_u(0)-(z_u(0)-z_u(1))*j/8.-(z_u(0)-(z_u(0)-z_u(1))*j/8.-z_d(0)+(z_d(0)-z_d(1))*j/8.)*onehundredtwentyeight/128.
y(8*there3(i)+j,*)=y_u(0)-(y_u(0)-y_u(1))*j/8.-(y_u(0)-(y_u(0)-y_u(1))*j/8.-y_d(0)+(y_d(0)-y_d(1))*j/8.)*onehundredtwentyeight/128.
x(8*there3(i)+j,*)=x_u(0)-(x_u(0)-x_u(1))*j/8.-(x_u(0)-(x_u(0)-x_u(1))*j/8.-x_d(0)+(x_d(0)-x_d(1))*j/8.)*onehundredtwentyeight/128.
endfor
endfor

there2=[19,20,26,28,30]
for i=0,4 do begin&$
x_u=xx((i+14)*4:4*(i+14)+1)
y_u=-yy((i+14)*4:4*(i+14)+1)
z_u=zz((i+14)*4:4*(i+14)+1)
x_d=xx((i+14)*4+2:4*(i+14)+3)
y_d=-yy((i+14)*4+2:4*(i+14)+3)
z_d=zz((i+14)*4+2:4*(i+14)+3)
for j=0,7 do begin
z(8*there2(i)+j,*)=z_u(0)-(z_u(0)-z_u(1))*j/8.-(z_u(0)-(z_u(0)-z_u(1))*j/8.-z_d(0)+(z_d(0)-z_d(1))*j/8.)*onehundredtwentyeight/128.
y(8*there2(i)+j,*)=y_u(0)-(y_u(0)-y_u(1))*j/8.-(y_u(0)-(y_u(0)-y_u(1))*j/8.-y_d(0)+(y_d(0)-y_d(1))*j/8.)*onehundredtwentyeight/128.
x(8*there2(i)+j,*)=x_u(0)-(x_u(0)-x_u(1))*j/8.-(x_u(0)-(x_u(0)-x_u(1))*j/8.-x_d(0)+(x_d(0)-x_d(1))*j/8.)*onehundredtwentyeight/128.
endfor
endfor

there1=[ 3 ,7 ,8 ,9 ,10 ,11 ]
for i=0,5 do begin&$
x_u=xx((i+19)*4:4*(i+14)+1)
y_u=-yy((i+19)*4:4*(i+14)+1)
z_u=zz((i+19)*4:4*(i+14)+1)
x_d=xx((i+19)*4+2:4*(i+14)+3)
y_d=-yy((i+19)*4+2:4*(i+14)+3)
z_d=zz((i+19)*4+2:4*(i+14)+3)
for j=0,7 do begin
z(8*there1(i)+j,*)=z_u(0)-(z_u(0)-z_u(1))*j/8.-(z_u(0)-(z_u(0)-z_u(1))*j/8.-z_d(0)+(z_d(0)-z_d(1))*j/8.)*onehundredtwentyeight/128.
y(8*there1(i)+j,*)=y_u(0)-(y_u(0)-y_u(1))*j/8.-(y_u(0)-(y_u(0)-y_u(1))*j/8.-y_d(0)+(y_d(0)-y_d(1))*j/8.)*onehundredtwentyeight/128.
x(8*there1(i)+j,*)=x_u(0)-(x_u(0)-x_u(1))*j/8.-(x_u(0)-(x_u(0)-x_u(1))*j/8.-x_d(0)+(x_d(0)-x_d(1))*j/8.)*onehundredtwentyeight/128.
endfor
endfor

thereb=[72,73]
for i=0,1 do begin&$
x_u=xx((i+19)*4:4*(i+14)+1)
y_u=-yy((i+19)*4:4*(i+14)+1)
z_u=zz((i+19)*4:4*(i+14)+1)
x_d=xx((i+19)*4+2:4*(i+14)+3)
y_d=-yy((i+19)*4+2:4*(i+14)+3)
z_d=zz((i+19)*4+2:4*(i+14)+3)
for j=0,7 do begin
z(8*there1(i)+j,*)=z_u(0)-(z_u(0)-z_u(1))*j/8.-(z_u(0)-(z_u(0)-z_u(1))*j/8.-z_d(0)+(z_d(0)-z_d(1))*j/8.)*onehundredtwentyeight/128.
y(8*there1(i)+j,*)=y_u(0)-(y_u(0)-y_u(1))*j/8.-(y_u(0)-(y_u(0)-y_u(1))*j/8.-y_d(0)+(y_d(0)-y_d(1))*j/8.)*onehundredtwentyeight/128.
x(8*there1(i)+j,*)=x_u(0)-(x_u(0)-x_u(1))*j/8.-(x_u(0)-(x_u(0)-x_u(1))*j/8.-x_d(0)+(x_d(0)-x_d(1))*j/8.)*onehundredtwentyeight/128.
endfor
endfor

endif


tt=atan(sqrt(x^2+y^2)/z)
tt(where(tt lt 0))=!pi+tt(where(tt lt 0))
r=sqrt(x^2+y^2+z^2)
return
end

