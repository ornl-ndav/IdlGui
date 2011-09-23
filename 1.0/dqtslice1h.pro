pro dqtslice1h,histo,h1,eventsthen,fmatrix,filen=file,dq=dq,deltad=deltad,maxd=maxd,onep=onep,use_focus=use_focus,bad=bad,detail=detail,option_focus=option_focus,tweak=tweak,old=old,calfile=calfile,maxevid=maxevid

; ##################################################################################
; ###################### API for IDL (event Data) ##################################
; ##################################################################################

; dq: flag to determine if d or q binning, default: qbinning (1)
if (not var_defined(dq)) then dq=1

; singlep flag for analyzing a single pulse
if (not var_defined(onep)) then onep=0

if (not var_defined(use_focus)) then use_focus=0
if (not var_defined(fmatrix) and option_focus eq 0) then use_focus=0
if (not var_defined(detail)) then detail=0
if (not var_defined(option_focus)) then option_focus=1
if not var_defined(tweak) then tweak=0
if not var_defined(calfile) then calfile='nomad.calfile'
if (not var_defined(old)) then old=0

if (dq gt 0) then print, 'Binning in Q' 
if (dq eq 0) then print, 'Binning in d'
if (dq lt 0) then print, 'Binning in TOF'

if use_focus then print,' Using the focussing table'
there,nthere,there,eightpacks,bs,old=old

path = "/SNS/NOM"  ;path to event file
if var_defined(file)then file=path+'/'+file
pulses=0


; ******* Pickup Dialog Box **************
if not var_defined(file) then begin
 file = dialog_pickfile(/must_exist, $
 title = 'Select a binary file', $
 filter = ['*.dat'], $
 path = path,$
 get_path = Path)
; ****************************************

; to get only the last part of the name
file_list = strsplit(file,'\',/extract, count=length)
file_name = file_list[length-1]
endif
nslices=n_elements(eventsthen)

sublength=strpos(file,'neutron')
file_pid=strmid(file,0,sublength)+'pulseid.dat'
read_pulsid,plow,phigh,evid,char,filename=file_pid
w=where(evid gt 2.^60,n1)
if n1 ne 0 then begin
print,'Thats odd'
print,evid(w),w
evid (w)=0
end
if not var_defined(maxevid) then maxevid=max(evid)-1
if use_focus and option_focus then begin&$
read_calfile,corrf,file=calfile&$
if n_elements(corrf) ne 1024l*nthere then begin
print,'Not the correct number of elements in the calfile'
print,'FULL STOP'
return
end
end
if use_focus and tweak then begin&$
read_calfile,tweakf,file='nomad.tweakfile'&$
corrf=corrf*tweakf
if n_elements(tweakf) ne 1024l*nthere then begin
print,'Not the correct number of elements in the tweakfile'
print,'FULL STOP'
return
end
end

; INPUT 

normf=fltarr(nslices)
onesecev=fltarr(nslices)
for i=0,nslices-1 do begin
if i ne nslices-1 then w=where(evid ge eventsthen(i) and evid lt eventsthen(i+1))
if i ne nslices-1 then normf(i)=total(char(w))
onesecev(i)=evid(max(w))
end
normf(nslices-1)=total(char(where(evid ge eventsthen(nslices-1))))
normf(where(normf gt 0))=1e6/normf(where(normf gt 0))
;m=median(normf(where(normf gt 0)))
;wn1=where((normf lt 1.2*m) and (normf gt 0.8*m))
wn1=findgen(nslices)
 d1=onesecev-shift(onesecev,1)
d1(0)=onesecev(0)
plot,wn1,normf(wn1),/yno

; final histogram is per micro Amp

openr,1,file
fs=fstat(1)
N=fs.size   ; length of the file in bytes

Nbytes = 4  ; data are Uint32 = 4 bytes
N = fs.size/Nbytes
Npixel=(19l+19l+63l)*128l*8l
ntofbin=16700
if (not var_defined(deltad)) then begin
if (dq gt 0) then deltad=0.02 
if (dq eq 0) then deltad=0.005
if (dq lt 0) then deltad=10.
endif
dd2=deltad/2.
if (not var_defined(maxd)) then begin
if (dq gt 0) then maxd=50. 
if (dq eq 0) then maxd=6.
if (dq lt 0) then maxd=166666. 
endif

nmaxd=maxd/deltad
ndbin=nmaxd

ng=n_elements(bs)/20
if not var_defined(bad) then bad=[nthere+1]
detpos,tt,phi,rr,x,y,z
toftoq=fltarr(nthere*8*128l)
rthere=fltarr(nthere*8*128l)
ttthere=fltarr(nthere*8*128l)
i=1l
for i=0l,nthere-1 do begin&for j=0,7 do  rthere((i*8+j)*128l:(i*8+j+1)*128l-1)=rr(eightpacks(i)*8+j,*)&endfor
for i=0l,nthere-1 do begin&for j=0,7 do  ttthere((i*8+j)*128l:(i*8+j+1)*128l-1)=tt(eightpacks(i)*8+j,*)&endfor
if dq eq 0 then begin
if not use_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(ttthere(i)/2.)
if use_focus and (not option_focus) then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(fmatrix(i)/2.)
if use_focus and option_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(ttthere(i)/2.)*corrf(i)

end
if dq gt 0 then begin
if not use_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=10*4*!pi/.003955*(19.5+rthere(i))*sin(ttthere(i)/2.)
if use_focus and (not option_focus) then for i=0l,nthere*8*128l-1 do toftoq(i)=10*4*!pi/.003955*(19.5+rthere(i))*sin(fmatrix(i)/2.)
if use_focus and option_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=10*4*!pi/.003955*(19.5+rthere(i))*sin(ttthere(i)/2.)/corrf(i)
end

histo=fltarr(ndbin)
if detail eq 0 then h1=fltarr(ndbin,1,nslices)
if detail eq 1 then h1=fltarr(ndbin,ng,nslices)
if detail eq 2 then h1=fltarr(ndbin,nthere,nslices)

hslice=h1(*,*,0)
natatime=n/nslices/2*2
notc=0
print,nslices
if (n lt natatime) then natatime=n
if onep then nslices=0
for i=0,nslices-1 do begin&$
if i ne nslices-1 then Natatime=(eventsthen(i+1)-eventsthen(i)-1)*2
if i eq nslices-1 then Natatime=(maxevid-eventsthen(i)-1)*2
print,natatime
help,natatime
data = lonarr(Natatime)    ; create a longword integer array of N tatime elements
t1=systime(1)
readu,1,data
t2=systime(1)
w=where(data(lindgen(Natatime/2l)*2l)-shift(data(lindgen(natatime/2l)*2l),-1) gt 160000,n1)
pulses=pulses+n1
a=histogram(data(lindgen(Natatime/2l)*2l+1l),min=0,max=npixel-1,reverse_indices=r)&$
hslice=hslice*0

if (dq gt 0) then begin                      ;Q binning
for j=0l,nthere*128l*8.-1 do begin&$
pack=j/1024l
group=where(eightpacks(pack) eq bs)-(where(eightpacks(pack) eq bs)/ng)*ng
w=where(pack eq bad,n3)
if n3 ne 1 then begin
if R[there(j)] le R[there(j)+1]-1 then begin&$
	d=long((toftoq(j)/data(2*r(R[there(j)] : R[there(j)+1]-1))+dd2)/deltad)&$
        	
	if detail eq 0 then hslice(*,0)=hslice(*,0)+histogram(d,min=0,max=nmaxdi-1e-3)*normf(wn1(i))&$
        if detail eq 1 then hslice(*,group)=hslice(*,group)+histogram(d,min=0,max=nmaxd-1e-3)*normf(wn1(i))&$
        if detail eq 2 then hslice(*,pack)=hslice(*,pack)+histogram(d,min=0,max=nmaxd-1e-3)*normf(wn1(i))&$

;        d=d(sort(d))
;        w=where(d-shift(d,1) eq 0,n2)
;        w1=where(d lt nmaxd-1 and d gt 0,n1)
;        if n2 gt 0 and n_elements(d) gt 1  then begin
;        	for kk=0l,n1-1 do hslice(d(w1(kk)))=hslice(d(w1(kk)))+normf(wn1(i))
;        endif else begin
;                if n1 gt 0 then begin&$
;                d=d(w1)&$
;                hslice(d)=hslice(d)+normf(wn1(i))&$
;                endif&$
;        endelse&$
endif&$
endif&$
endfor&$
endif
if (dq eq 0) then begin                     ; d binning
for j=0l,nthere*128l*8.-1 do begin&$
pack=j/1024l
group=where(eightpacks(pack) eq bs)-(where(eightpacks(pack) eq bs)/ng)*ng
w=where(pack eq bad,n3)
if n3 ne 1 then begin
if R[there(j)] le R[there(j)+1]-1 then begin&$
	d=long((toftoq(j)*data(2*r(R[there(j)] : R[there(j)+1]-1))+dd2)/deltad)&$
        if detail eq 0 then hslice(*,0)=hslice(*,0)+histogram(d,min=0,max=nmaxdi-1e-3)*normf(wn1(i))&$
        if detail eq 1 then hslice(*,group)=hslice(*,group)+histogram(d,min=0,max=nmaxd-1e-3)*normf(wn1(i))&$
        if detail eq 2 then hslice(*,pack)=hslice(*,pack)+histogram(d,min=0,max=nmaxd-1e-3)*normf(wn1(i))&$
;        d=d(sort(d))
;        w=where(d-shift(d,1) eq 0,n2)
;        w1=where(d lt nmaxd-1 and d gt 0,n1)
;        if n2 gt 0 and n_elements(d) gt 1  then begin
;                for kk=0l,n1-1 do hslice(d(w1(kk)))=hslice(d(w1(kk)))+normf(wn1(i))
;        endif else begin
;                if n1 gt 0 then begin&$
;                d=d(w1)&$
;                hslice(d)=hslice(d)+normf(wn1(i))&$
;                endif&$
;        endelse&$
endif&$
endif&$
endfor&$
endif
if (dq lt 0) then begin                    ; TOF binning
for j=0l,nthere*128l*8.-1 do begin&$
w=where(j/1024l eq bad,n3)
if n3 ne 1 then begin
if R[there(j)] le R[there(j)+1]-1 then begin&$
	d=long((data(2*r(R[there(j)] : R[there(j)+1]-1))+dd2)/deltad)&$
	w1=where(d lt nmaxd,n1)
	if n1 gt 0 then begin&$
		d=d(w1)&$
		hslice(d)=hslice(d)+1&$
		u=uniq(d,sort(d))&$
		if n_elements(d)-n_elements(u) gt 0 then begin&$
			u1=u(sort(u))-shift(u(sort(u)),1)-1&$
			w=where(u1 gt 0,n1)&$
			if n1 gt 0 then hslice(d(w))=hslice(d(w))+u1(w)&$
			if min(u) gt 0 then hslice(d(0))=hslice(d(0))+min(u)&$
		endif&$
	endif&$
endif&$
endif&$
endfor&$
endif
h1(*,*,i)=hslice&$
plot,hslice&$
histo=histo+hslice&$
t3=systime(1)
print,i,t2-t1,t3-t2,natatime/1e6
endfor

close,1

help, data  ;give information about the flat array of event values (timestamp, pixelid)
return
end
