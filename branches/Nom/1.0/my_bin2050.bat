@idlstart
restore,'/SNS/NOM/histo/histo1486.dat'
bad=[50]

dqtbinning,h2050,fmatrix,use=1,option=1,dq=1,filen='/SNS/NOM/IPTS-5470/0/2050/preNeXus/NOM_2050_neutron_event.dat',pseudov=0,calfile=ncal,sil=1
equivalent,h2050,e2050,p2050,a2050,b2050,bad=bad
save,e2050,p2050,a2050,b2050,filen='all2050.dat'
;save,h2050,file='/SNS/NOM/histo/histo2050.dat'

exit





























