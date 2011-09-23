pro gsasbinning,histo,h1,fmatrix,filen=file,deltad=deltad,maxd=maxd,use_focus=use_focus,option_focus=option_focus,tweak=tweak,norm_beam=norm_beam,old=old,pseudov=pseudov,sILENT=silent,calfile=calfile,maxtime=maxtime,newgeo=newgeo,detail=detail,bad=bad

; ##################################################################################
; ###################### API for IDL (event Data) ##################################
; ##################################################################################


; dq: flag to determine if d or q binning, default: qbinning (1)

;use mantid style calfile
if (not var_defined(option_focus)) then option_focus=1

if (not var_defined(use_focus)) then use_focus=0
if (not var_defined(fmatrix) and option_focus eq 0) then use_focus=0
if (not var_defined(detail)) then detail=0
; detail=0 only one back is generated
if not var_defined(silent) then silent=0
if not var_defined(tweak) then tweak=0
if not var_defined(calfile) then calfile='nomad.calfile'
if not var_defined(newgeo) then newgeo=0

print, 'logbinning in d' 

if use_focus then print,' Using the focussing table'
detpos,tt,phi,rr,x,y,z,tweak=newgeo
there,nthere,dthere,eightpacks,bs,old=old
ng=n_elements(bs)/20
if not var_defined(bad) then bad=[nthere+1]

if not var_defined(norm_beam) then norm_beam=1
; default use beam current for normalization
if not var_defined(pulse_group) then pulse_group=60
; default: average over 1s

if not var_defined(old) then old=0
; use a pseudo Vana to normalize the data
if not var_defined(pseudov) then pseudov=1

; INPUT 

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
pseudovfile='pseudvd.dat'
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
normf(wn1)=normf(wn1)/float(n_elements(wn1))

; final histogram is per micro Amp
endif
if var_defined(maxtime) then begin
if n_elements(wn1) gt maxtime then wn1=wn1(0:maxtime)
end
openr,1,file

fs=fstat(1)
N=fs.size   ; length of the file in bytes

Nbytes = 4  ; data are Uint32 = 4 bytes
N = fs.size/Nbytes
Npixel=(19l+19l+63l)*128l*8l
ntofbin=16700
if (not var_defined(deltad)) then begin
 deltad=0.0004
; for log binning 
endif
dd2=deltad/2.
if not var_defined(mind) then mind=-2.3023878 
if not var_defined(nmaxd) then nmaxd=9782

 Npixel=(19l+19l+63l)*128l*8l
ndbin=nmaxd
toftoq=fltarr(nthere*8*128l)
rthere=fltarr(nthere*8*128l)
ttthere=fltarr(nthere*8*128l)
i=1l
for i=0l,nthere-1 do begin&for j=0,7 do  rthere((i*8+j)*128l:(i*8+j+1)*128l-1)=rr(eightpacks(i)*8+j,*)&endfor
for i=0l,nthere-1 do begin&for j=0,7 do  ttthere((i*8+j)*128l:(i*8+j+1)*128l-1)=tt(eightpacks(i)*8+j,*)&endfor

if not use_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(ttthere(i)/2.)
if use_focus and (not option_focus) then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(fmatrix(i)/2.)
if use_focus and option_focus then for i=0l,nthere*8*128l-1 do toftoq(i)=0.1*.003955/2./(19.5+rthere(i))/sin(ttthere(i)/2.)*corrf(i)


histo=lonarr(nthere*128l*8.,ndbin)
if detail eq 0 then h1=fltarr(ndbin,1)
if detail eq 1 then h1=fltarr(ndbin,ng)
if detail eq 2 then h1=fltarr(ndbin,nthere)
if norm_beam then histo=fltarr(nthere*128l*8.,ndbin)
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
if i eq nslices then begin natatime=n-nslices*natatime& data = lonarr(Natatime)&end
if norm_beam then data=lindgen(2*d1(wn1(i)))
if norm_beam then natatime=d1(wn1(i))
t1=systime(1)
readu,1,data
t2=systime(1)
w=where(data(lindgen(Natatime/2)*2)-shift(data(lindgen(natatime/2)*2),-1) gt 160000,n1)
laseron=0
if total((data(lindgen(Natatime/2)*2+1)>0)/(npixel)/float(natatime/2)) gt .9 then laseron=1
if not laseron then a=histogram(data(lindgen(Natatime/2)*2+1),min=0,max=npixel-1,reverse_indices=r)&$
if laseron then a=histogram(data(lindgen(Natatime/2)*2+1)-npixel+2*1024l,min=0,max=npixel-1,reverse_indices=r)

for j=0l,nthere*128l*8.-1 do begin&$
if R[dthere(j)] le R[dthere(j)+1]-1 then begin&$
pack=j/1024l
group=where(eightpacks(pack) eq bs)-(where(eightpacks(pack) eq bs)/ng)*ng
group=group(0)
w=where(pack eq bad,n3)
if n3 ne 1 then begin
;if j eq 30*1024l+50 then stop
	d=long((alog(toftoq(j)*data(2*r(R[dthere(j)] : R[dthere(j)+1]-1)))$
       -mind+dd2)/deltad)&$
       ww=where(d gt 0,nn) 
   if nn gt 0 then begin
  	d=d(ww)
       	d=d(sort(d))
        w=where(d-shift(d,1) eq 0,n2)
       	w1=where(d lt nmaxd and d gt 0,n1)
       	 if n2 gt 0 and n_elements(d) gt 1  then begin
       		 if detail eq 0 then begin
		for kk=0,n1-1 do h1(d(kk),0)=h1(d(kk),0)+normf(wn1(i))
		endif
       		 if detail eq 1 then begin
		for kk=0,n1-1 do h1(d(kk),group)=h1(d(kk),group)+normf(wn1(i))
		endif
       		 if detail eq 2 then begin
		for kk=0,n1-1 do h1(d(kk),pack)=h1(d(kk),pack)+normf(wn1(i))
		endif	
       		 if detail eq 3 then begin
		for kk=0,n1-1 do histo(j,d(kk),0)=histo(j,d(kk))+normf(wn1(i))
		endif
       		 endif else begin
                	if n1 gt 0 then begin&$
               		 d=d(w1)&$
			 if detail eq 0 then h1(d,0)=h1(d,0)+normf(wn1(i))&$
			 if detail eq 1 then h1(d,group)=h1(d,group)+normf(wn1(i))&$
			 if detail eq 2 then h1(d,pack)=h1(d,pack)+normf(wn1(i))&$
			 if detail eq 3 then histo(j,d)=histo(j,d)+normf(wn1(i))&$
                	endif&$
        	endelse&$
	endif
endif
endif&$
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
