pro dqttwostate,histo,fmatrix,filen=file,dq=dq,deltad=deltad,maxd=maxd,use_focus=use_focus,option_focus=option_focus,tweak=tweak,norm_beam=norm_beam,old=old,pseudov=pseudov,sILENT=silent,calfile=calfile,maxtime=maxtime,newgeo=newgeo,timebin=timebin

; ##################################################################################
; ###################### API for IDL (event Data) ##################################
; ##################################################################################


; dq: flag to determine if d or q binning, default: qbinning (1)
if (not var_defined(dq)) then dq=1

;use mantid style calfile
if (not var_defined(option_focus)) then option_focus=1

if (not var_defined(use_focus)) then use_focus=0
if (not var_defined(fmatrix) and option_focus eq 0) then use_focus=0
if not var_defined(silent) then silent=0
if not var_defined(tweak) then tweak=0
if not var_defined(calfile) then calfile='nomad.calfile'
if not var_defined(newgeo) then newgeo=0

if (dq gt 0) then print, 'Binning in Q' 
if (dq eq 0) then print, 'Binning in d'
if (dq lt 0) then print, 'Binning in TOF'
if use_focus then print,' Using the focussing table'
if not var_defined(norm_beam) then norm_beam=1
; default use beam current for normalization
if not var_defined(pulse_group) then pulse_group=60
; default: average over 1s

if not var_defined(old) then old=0
; use a pseudo Vana to normalize the data
if not var_defined(pseudov) then pseudov=1

; INPUT 

detpos,tt,phi,rr,x,y,z,tweak=newgeo
there,nthere,dthere,eightpacks,old=old
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

if pseudov then begin
if dq lt 1 then pseudovfile='pseudvd.dat'
if dq eq 1 then pseudovfile='pseudvQ.dat'
openr,3,peudovfile,err=err
close,3
if err eq 0 then restore,pseudovfile
if err ne 0 then begin
w2c2,result,lambda,spectrum,inthisdir,scattpower,normf1,dq=dq,deltad=deltad,maxd=maxd,fmatrix=fmatrix,option_focus=option_focus,old=old,use_focus=use_focus
save,result,file=pseudovfile
end
end

path = "/SNS/NOM/2010_2_1B_SCI/1/"  ;path to event file

if var_defined(file) then file=path+file

; ******* Pickup Dialog Box **************
if not var_defined(file) then begin
 file = dialog_pickfile(/must_exist, $
 title = 'Select an event file', $
 filter = ['*.dat'], $
 path = path,$
 get_path = Path)
; ****************************************

; to get only the last part of the name
file_list = strsplit(file,'\',/extract, count=length)
file_name = file_list[length-1]
endif
if norm_beam then begin
sublength=strpos(file,'neutron')
file_pid=strmid(file,0,sublength)+'pulseid.dat'
read_pulsid,plow,phigh,evid,char,filename=file_pid
n_pulseg=n_elements(char)/pulse_group
normf=fltarr(n_pulseg)
onesecev=fltarr(n_pulseg)
for i=0l,n_pulseg-1 do begin
normf(i)=total(char(i*60l:(i+1)*60l-1))
onesecev(i)=evid((i+1)*60l-1)
end
ww=where(normf gt 0,nw)
if nw eq 0 then return
normf(ww)=1e6/normf(ww)
m=median(normf(ww))
wn1=where((normf lt 1.2*m) and (normf gt 0.8*m))
 d1=onesecev-shift(onesecev,1)
d1(0)=onesecev(0)
if silent eq 0 then plot,wn1,normf(wn1),/yno
if var_defined(maxtime) then begin
if n_elements(wn1) gt maxtime then wn1=wn1(0:maxtime)
end
normf(wn1)=normf(wn1)/float(n_elements(wn1))

; final histogram is per micro Amp
endif
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
 Npixel=(19l+19l+63l)*128l*8l
nmaxd=fix(maxd/deltad)
ndbin=fix(maxd/deltad)
toftoq=fltarr(nthere*8*128l)
rthere=fltarr(nthere*8*128l)
ttthere=fltarr(nthere*8*128l)
i=1l
for i=0l,nthere-1 do begin&for j=0,7 do  rthere((i*8+j)*128l:(i*8+j+1)*128l-1)=rr(eightpacks(i)*8+j,*)&endfor
for i=0l,nthere-1 do begin&for j=0,7 do  ttthere((i*8+j)*128l:(i*8+j+1)*128l-1)=tt(eightpacks(i)*8+j,*)&endfor
if dq gt 0 then begin
if not use_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=10*4*!pi/.003955*(19.5+rthere(i))*sin(ttthere(i)/2.)
if use_focus and (not option_focus) then for i=0l,nthere*8*128l-1 do toftoq(i)=10*4*!pi/.003955*(19.5+rthere(i))*sin(fmatrix(i)/2.)
if use_focus and option_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=10*4*!pi/.003955*(19.5+rthere(i))*sin(ttthere(i)/2.)/corrf(i)
end
if dq eq 0 then begin
if not use_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(ttthere(i)/2.)
if use_focus and (not option_focus) then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(fmatrix(i)/2.)
if use_focus and option_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(ttthere(i)/2.)*corrf(i)

end

histo=lonarr(nthere*128l*8.,ndbin,timebin)
if norm_beam then histo=fltarr(nthere*128l*8.,ndbin,timebin)
natatime=long(1e7)
Nslices=n/natatime
if not norm_beam then normf=intarr(nslices+1)+1
if not norm_beam then wn1=findgen(nslices+1)

if norm_beam then nslices=n_elements(wn1)-1
notc=0

;print,nslices
if (n lt natatime) then natatime=n
data = lonarr(Natatime)    ; create a longword integer array of N tatime elements
for i=0l,nslices do begin&$
if i eq nslices then begin natatime=n-nslices*natatime&natatime=natatime<1e7& data = lonarr(Natatime)&end
if norm_beam then data=lindgen(2*d1(wn1(i)))
if norm_beam then natatime=d1(wn1(i))
t1=systime(1)
readu,1,data
t2=systime(1)
w=where(data(lindgen(Natatime/2)*2)-shift(data(lindgen(natatime/2)*2),-1) gt 160000,n1)
won=where(data(lindgen(Natatime/2)*2+1) eq 2l^30+2l^28+2,nnon)
woff=where(data(lindgen(Natatime/2)*2+1) eq 2l^30+2l^28+3,noff)
minon=min(won,mminon)
maxon=max(won,mmaxon)


wtime=lonarr((maxon-minon)/timebin,timebin)
off=0
for jjj=0,mmaxon-1 do begin&$
nonoff=won(jjj+1)-won(jjj)&$
for jjjj=0,timebin-1 do begin&wtime(findgen(nonoff/timebin)+off,jjjj)=findgen(nonoff/timebin)+won(jjj)+(nonoff/timebin)*jjjj&end&$
off=off+nonoff/timebin&$
end
stop
laseron=0
for llt=0,timebin-1 do begin
tdata=lindgen(2*(maxon-minon)/timebin))
for i=0,1 do tdata(i+2*lindgen(maxon-minon)/timebin))=DATA(WTIME);;;;;; to be continued
if total((data(lindgen(Natatime/2)*2+1)>0)/(npixel)/float(natatime/2)) gt .9 then laseron=1
if not laseron then a=histogram(data(lindgen(Natatime/2)*2+1),min=0,max=npixel-1,reverse_indices=r)&$
if laseron then a=histogram(data(lindgen(Natatime/2)*2+1)-npixel+2*1024l,min=0,max=npixel-1,reverse_indices=r)
if (dq gt 0) then begin                      ;Q binning
for j=0l,nthere*128l*8.-1 do begin&$
if R[dthere(j)] le R[dthere(j)+1]-1 then begin&$
	d=long((toftoq(j)/data(2*r(R[dthere(j)] : R[dthere(j)+1]-1))+dd2)/deltad)&$
;	h=histogram(d,min=0,max=ndbin-1)
;	if norm_beam then h=h*normf(w1(i))
        d=d(sort(d))
	w=where(d-shift(d,1) eq 0,n2)
        w1=where(d lt nmaxd and d gt 0,n1)
	if n2 gt 0 and n_elements(d) gt 1  then	begin 
	for kk=0,n1-1 do histo(j,d(kk),llt)=histo(j,d(kk),llt)+normf(wn1(i))
;;histo(j,*)=histo(j,*)+histogram(d,min=0,max=ndbin-1)*normf(wn1(i))
;;histo(j,*)=histo(j,*)+histogram(d,min=0,max=ndbin-1)*normf(wn1(i))
;if n2 gt 0 and n_elements(d) gt 1 then begin&print,i,j,d&stop&end
	endif else begin
		if n1 gt 0 then begin&$
		d=d(w1)&$
		histo(j,d,llt)=histo(j,d,llt)+normf(wn1(i))&$
;		u=uniq(d,sort(d))&$
;		if n_elements(d)-n_elements(u) gt 0 then begin&$
;			u1=u(sort(u))-shift(u(sort(u)),1)-1&$
;			w=where(u1 gt 0,n1)&$
;			if n1 gt 0 then histo(d(w),lt)=histo(d(w),lt)+u1(w)&$
;			if min(u) gt 0 then histo(d(0),lt)=histo(d(0),lt)+min(u)&$
		endif&$
	endelse&$
endif&$
endfor&$
endif
if (dq eq 0) then begin                     ; d binning
for j=0l,nthere*128l*8.-1 do begin&$
if R[dthere(j)] le R[dthere(j)+1]-1 then begin&$
	d=long((toftoq(j)*data(2*r(R[dthere(j)] : R[dthere(j)+1]-1))+dd2)/deltad)&$
       d=d(sort(d))
        w=where(d-shift(d,1) eq 0,n2)
        w1=where(d lt nmaxd and d gt 0,n1)
        if n2 gt 0 and n_elements(d) gt 1  then begin
        for kk=0,n1-1 do histo(j,d(kk),llt)=histo(j,d(kk),llt)+normf(wn1(i))
        endif else begin
                if n1 gt 0 then begin&$
                d=d(w1)&$
                histo(j,d,llt)=histo(j,d,llt)+normf(wn1(i))&$
                endif&$
        endelse&$
endif&$
endfor&$
endif
if (dq lt 0) then begin                    ; TOF binning
for j=0l,nthere*128l*8.-1 do begin&$
if R[dthere(j)] le R[dthere(j)+1]-1 then begin&$
	d=long((data(2*r(R[dthere(j)] : R[dthere(j)+1]-1))+dd2)/deltad)&$
	w1=where(d lt nmaxd,n1)
	if n1 gt 0 then begin&$
		d=d(w1)&$
		histo(j,d,llt)=histo(j,d,llt)+1&$
		u=uniq(d,sort(d))&$
		if n_elements(d)-n_elements(u) gt 0 then begin&$
			u1=u(sort(u))-shift(u(sort(u)),1)-1&$
			w=where(u1 gt 0,n1)&$
			if n1 gt 0 then histo(d(w),llt)=histo(d(w),llt)+u1(w)&$
			if min(u) gt 0 then histo(d(0),llt)=histo(d(0),llt)+min(u)&$
		endif&$
	endif&$
endif&$
endfor&$
endif
endfor&$
;print,i&
t3=systime(1)
if silent eq 0 then print,i,t2-t1,t3-t2,natatime/1e6
endfor

close,1
if pseudov then histo(where(result ne 0))=histo(where(result ne 0))/result(where(result ne 0))>1e-7
help, data  ;give information about the flat array of event values (timestamp, pixelid)
return
end
