@idlstart
; restore,'fmatrix523n.dat'
restore,'mask2584to2644.dat'
dqtbinning,h9999,fmatrix,use=1,option=1,dq=1,maxd=50,filen='../../IPTS-5911/0/9999/preNeXus/NOM_9999_neutron_event.dat',pseudov=0,calfile='nomad2432.calfile',sil=1
;save,h9999,filen='h2430.dat
grouping,h9999,a9999,b9999,p9999,t9999,wherebad=wherebad
save,p9999,a9999,b9999,filen='all9999.dat'
creategr,a9999,b9999,back='back2446.dat',hydro=0,qmin=30,qmax=30,sc=9999,inter=0
exit





























