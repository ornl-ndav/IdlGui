; IDL Version des FORTRAN Programms x-ray ; ; Input:
;         Q: Q-Werte an denen die Formfaktoren berechnet werden sollen
;         E: Energie der verwendeten Strahlung in keV
;         Formel: Ordnungszahlen der Atome die in der Probe
;          vorhanden sind, z. B: C2H5NO: formel=[6,6,1,1,1,1,1,7,8]
;
; Output :
;           Iso: Isotroper Streuanteil der Probe
;           Modi: Modifikationsfunktion= 1/(sum f)^2
;             iso0= Nicht mit der Effektivit"at des Ge-Detektors gewichteter
;      isotroper Streubeitrag
;
;        Benutzt eine Liste der Formfaktoren und COmptonintensit"aten
;      aus: J. H. Hubbell et al.
;          /*J. Physical and Chemical Ref. Data 4,471(1975)*/

pi=3.141592654
cge=236.
dge=84.05
lge=1.5
rhoge=5.323
        pi4=4.*pi
        E=E*1E3
        QE=1.6021773349e-19
        HPLANCK=6.636075540e-34
        CLICHT=2.99797458e08
        MEEV=510999.0615

        einlamda=1d10/(qe/hplanck/clicht)
        XLAM=einlamda/e
openr,1,'../idl/coh.liste'
readf,1,nats
;  nats: Anzahl Atome die im Moment in der Liste stehen
oz=intarr(nats)
readf,1,oz
; oz: Ordnungszahlen der Atome die gespeichert sind

natm=n_elements(formel)
locoz=intarr(natm)
for i=0,natm-1 do begin
locoz(i)=where(formel(i) eq oz,c)
if (c ne 1) then  begin
print,'Schwierigkeiten Atom mit Ordnungszahl ',formel(i),' zu finden'
return
end
endfor
readf,1,nq1
; nq1 Anzahl der Q Stuetzstellen
q1=dblarr(nq1)
; q1 : DIe Stuetzstellen

readf,1,q1
f=dblarr(nq1,nats)
s=dblarr(nq1,nats)
; f:Die elastischen Formfaktoren an den Stuetzstellen ; s: Comptonstreuamplitude readf,1,f
close,1
nq=n_elements(q)
fin=dblarr(nq,natm)
dummy=min(abs(4*!pi*q1-max(q)),m)
for i=0,natm-1 do begin&spline_p,q1(0:m+1)*4*pi,f(0:m+1,locoz(i)),q2,temp,inter=.05&fin(*,i)=interpol(temp,q2,q)&end
sumf=dblarr(nq)
iso=dblarr(nq)
for i=0,nq-1 do sumf(i)=total(fin(i,*))
for i=0,nq-1 do iso(i)=total(fin(i,*)^2)
modi=1./sumf^2
openr,2,'../idl/incoh.liste'
readf,2,s
close,2
sint=dblarr(nq,natm)
for i=0,natm-1 do begin&spline_p,q1(0:m+1)*4*pi,s(0:m+1,locoz(i)),q2,temp,inter=.05&sint(*,i)=interpol(temp,q2,q)&end
sums=dblarr(nq)
for i=0,nq-1 do sums(i)=total(sint(i,*))
        aB=e/MEEV
        xmu0=(cge*xlam^3-dge*xlam^4)*rhoge
        eff0=1.-exp(-lge*xmu0)
        winkel=q/PI4
        WINKEL=WINKEL*XLAM
        WINKEL=ASIN(WINKEl)
        Xkn4=COS(WINKEL*2.)
        XKN4=1.-XKN4
        XKN4=AB*XKN4
        XKN4=1.+XKN4
        ec=(e/xkn4)
        xlc=einlamda/ec
        xmuc=rhoge*(cge*xlc^3-dge*xlc^4)
        effc=1.-exp(-lge*xmuc)
        eff=effc/eff0
        XKN4=XKN4*XKN4
        XKN4=1./XKN4
        iso0=iso+sums*xkn4
        iso=iso+sums*xkn4*eff
        incoh=sums*xkn4
return
end
