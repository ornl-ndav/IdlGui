FUNCTION convert_rgb, rgb
COMPILE_OPT idl2, HIDDEN
RETURN, rgb[0] + (rgb[1] * 2L^8) + (rgb[2]*2L^16)
END

PRO test_color
x    = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110]
data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110]
xtitle = 'x value'
ytitle = 'y value'
color = [0, 50, 75, 100, 125, 150, 175, 200, 225, 250, 255] 
PlotBackground = [255,255,255]
xmin = 0
xmax = 300
ymin = 0
ymax = 300
psym = [0, 1, 2, 3, 4, 5, 6, 7]
i = 0
                plot, x, $
                 data, $
                 XTITLE = xtitle, $
                 YTITLE = ytitle,$
                 COLOR  = color[0],$
                 BACKGROUND = convert_rgb(PlotBackground),$
                 XRANGE = [xmin,xmax],$
                 YRANGE = [ymin,ymax],$
                 XSTYLE = 1,$
                 SYMSIZE = 2, $
                 PSYM   = psym[2]
              FOR i = 1, 10  DO BEGIN
                oplot, x, $
                 data + 10 * i, $
                 COLOR  = color[i],$
                 SYMSIZE = 2, $
                 PSYM   = psym[2]
              ENDFOR
END
