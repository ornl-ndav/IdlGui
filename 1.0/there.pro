pro there,nthere,dthere,eightpacks,banks,old=old

if not var_defined(old) then old=0

if old then begin
nthere=34l
dthere=fltarr(nthere*8*128l)
eightpacks=[3,7,8,9,10,11,19,20,26,28,30,31,32,34,36,40,44,45,46, 47, 48,49,50,54,57,58,59,60,61,62,72,73,90,91]
banks=fltarr(6,20)+99
banks(0,0:5)=[3,7,8,9,10,11]
banks(1,0:8)=[19,20,26,28,30,31,32,34,36]
banks(2,0:7)=[40,44,45,46,47,48,49,50]
banks(3,0:6)=[54,57,58,59,60,61,62]
banks(4,0:1)=[72,73]
banks(5,0:1)=[90,91]
for i=0,nthere-1 do dthere(i*8*128l:(i+1)*8*128l-1)=eightpacks(i)*8*128l+findgen(8*128l)
endif
if not old then begin 
nthere=38l 
dthere=fltarr(nthere*8*128l)
eightpacks=[3,7,8,9,10,11,19,20,26,28,30,31,32,34,36,40,44,45,46, 47, 48,49,50,54,57,58,59,60,61,62,73,74,75,76,91,92,93,94]
banks=fltarr(6,20)+99
banks(0,0:5)=[3,7,8,9,10,11]
;             0 1 2 3 4  5
banks(1,0:8)=[19,20,26,28,30,31,32,34,36]
;             6  7  8  9  10 11 12 13 14
banks(2,0:7)=[40,44,45,46,47,48,49,50]
;             15 16 17 18 19 20 21 22
banks(3,0:6)=[54,57,58,59,60,61,62]
;             23 24 25 26 27 28 29
banks(4,0:3)=[73,74,75,76]
;             30 31 32 33
banks(5,0:3)=[91,92,93,94]
;             34 35 36 37
for i=0,nthere-1 do dthere(i*8*128l:(i+1)*8*128l-1)=eightpacks(i)*8*128l+findgen(8*128l) 
endif

return
end
