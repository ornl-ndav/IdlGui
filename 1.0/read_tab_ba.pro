function read_tab_ba,dum
; Liest die Blech-Averbach Tabelle ein
openr,1,'~/public/tab_ba'
n=3
arr=fltarr(5,n)
readf,1,arr
close,1
return,arr
end
