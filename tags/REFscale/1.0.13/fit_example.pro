; Define an 11-element vector of independent variable data:
X = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

; Define an 11-element vector of dependent variable data:
Y = [0.25, 0.16, 0.09, 0.04, 0.01, 0.00, 0.01, 0.04, 0.09, $
   0.16, 0.25]

; Define a vector of measurement errors:
measure_errors = REPLICATE(0.01, 11)

; Compute the second degree polynomial fit to the data:
cooef = POLY_FIT(X, Y, 2, MEASURE_ERRORS=measure_errors, $
   SIGMA=sigma)

; Print the coefficients:
;PRINT, 'Coefficients: ', cooef
;PRINT, 'Standard errors: ', sigma

;show original data
loadct,3
plot,x,y

;now calculate data on new coordinates
N_new = 100
x_new = findgen(N_new)/N_new

y_new = cooef(2)*x_new^2 + cooef(1)*x_new + cooef(0)

;overplot new data in red
oplot,x_new,y_new,color=200,thick=1.5
