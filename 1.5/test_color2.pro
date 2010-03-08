PRO test_color2
;TVLCT, 255, 255, 0, 100 
data = FINDGEN(100) 
data = SIN(data/5) / EXP(data/50)
PLOT, data, COLOR='00FF00'x, BACKGROUND = '000000'x ; curve is green
moredata = 0.5*data
OPLOT, moredata, COLOR='0000FF'x; curve is blue
moremoredata = 0.25*data
OPLOT, moremoredata, COLOR='FF0000'x; curve is red
END
