;
; Copyright (c) 1997-2007, ITT Visual Information Solutions. All
;       rights reserved. Unauthorized reproduction is prohibited.
;
image = bytarr(768, 512)
openr, 1, FILEPATH(SUB=['examples','data'], 'nyny.dat')
readu, 1, image
close, 1
