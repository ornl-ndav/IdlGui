PRO FitFunction, Event, Q1, Q2, flt0, flt1, flt2

print, flt0
print, '-------------------------------'
print, flt1


; Compute the second degree polynomial fit to the data:
cooef = POLY_FIT(flt0, flt1, 2, MEASURE_ERRORS=flt2, $
   SIGMA=sigma)

; Print the coefficients:
PRINT, 'Coefficients: ', cooef
PRINT, 'Standard errors: ', sigma

;show original data
loadct,3
window,0
plot,x,y

;now calculate data on new coordinates
N_new = 100
x_new = findgen(N_new)/N_new
y_new = cooef(2)*x_new^2 + cooef(1)*x_new + cooef(0)

;overplot new data in red
oplot,x_new,y_new,color=200,thick=1.5

END



PRO LoadDataFile, Event, LongFileName, Q1, Q2

print, 'LongFileName: ' + LongFileName

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

draw_id = widget_info(Event.top, find_by_uname='plot_window')
WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
wset,view_plot_id

error_plot_status = 0
catch, error_plot_status
if (error_plot_status NE 0) then begin

    text = 'Not enough data to plot'
    CATCH,/cancel

endif else begin
    
    openr,u,LongFileName,/get
    fs = fstat(u)
    
;define an empty string variable to hold results from reading the file
    tmp  = ''
    tmp0 = ''
    tmp1 = ''
    tmp2 = ''
    
    flt0 = -1.0
    flt1 = -1.0
    flt2 = -1.0
    
    Nelines = 0L    ;number of lines that does not start with a number
    Nndlines = 0L
    Ndlines = 0L
    onebyte = 0b
    
    while (NOT eof(u)) do begin
        
        readu,u,onebyte         ;,format='(a1)'
        fs = fstat(u)
                                ;print,'onebyte: ',onebyte
                                ;rewinded file pointer one character
        
        if fs.cur_ptr EQ 0 then begin 
            point_lun,u,0
        endif else begin
            point_lun,u,fs.cur_ptr - 1
        endelse
        
        true = 1
        case true of
            
            ((onebyte LT 48) OR (onebyte GT 57)): begin
                                ;case where we have non-numbers
                Nelines = Nelines + 1
                readf,u,tmp
            end
            
            else: begin
                                ;case where we (should) have data
                Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
                
                catch, Error_Status
                if Error_status NE 0 then begin
                    
                                ;you're done now...
                    CATCH, /CANCEL
                    
                endif else begin
                    
                    readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                    flt0 = [flt0,float(tmp0)] ;x axis
                    flt1 = [flt1,float(tmp1)] ;y axis
                    flt2 = [flt2,float(tmp2)] ;y_error axis
                    
                endelse
                
            end
        endcase
        
    endwhile
    
;strip -1 from beginning of each array
    flt0 = flt0[1:*]
    flt1 = flt1[1:*]
    flt2 = flt2[1:*]
    
    close,u
    free_lun,u

;get tab selected
    tabSelected = getTabSelected(Event)
    if (tabSelected EQ 1) then begin
       tabTitle = 'STEP2'
    endif else begin
       tabTitle = 'STEP3'
    endelse
    
;get Q1 and Q2
    Q1Q2SF = getQ1Q2SF(Event, tabTitle)
    Q1 = float(Q1Q2SF[0])
    Q2 = float(Q1Q2SF[1])

;remove NAN from flt1 and flt2 and update array flt0
    max_flt1 = max(flt1,/nan)
    min_flt1 = min(flt1,/nan)
    indx_flt1 = where(flt1 GT min_flt1 AND flt1 LT max_flt1)
    flt1_new = flt1(indx_flt1)
    flt0_new = flt0(indx_flt1)
    flt2_new = flt2(indx_flt1)

;Start function that will calculate the Fit function
    FitFunction, Event, Q1, Q2, flt0_new[0:20], flt1_new[0:20], flt2_new[0:20]

endelse    

END









