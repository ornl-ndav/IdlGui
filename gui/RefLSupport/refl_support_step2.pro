;This function save Q1, Q2 and SF of the Critical Edge file selected
PRO ReflSupportStep2_SaveQofCE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get long name of CE file
CE_LongFileName = (*global).full_CE_name

;get Q1 and Q2
Q1Q2SF = getQ1Q2SF(Event, 'STEP2')
Q1 = float(Q1Q2SF[0])
Q2 = float(Q1Q2SF[1])

;fit CE file and get scaling factor
LoadCEFile, Event, CE_LongFileName, Q1, Q2

END




PRO LoadCEFile, Event, CE_file_name, Q1, Q2
;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

error_plot_status = 0
catch, error_plot_status
if (error_plot_status NE 0) then begin

    text = 'Not enough data to plot'
    CATCH,/cancel

endif else begin
    
    openr,u,CE_file_name,/get
    fs = fstat(u)
    
;define an empty string variable to hold results from reading the file
    tmp  = ''
    tmp0 = ''
    tmp1 = '' 
    tmp2 = ''
    
    flt0 = -1.0
    flt1 = -1.0
    flt2 = -1.0
    
    Nelines  = 0L    ;number of lines that does not start with a number
    Nndlines = 0L
    Ndlines  = 0L
    onebyte  = 0b
    
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
                    
                    readf,u,tmp0,tmp1,tmp2,format='(3F0)'
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

;check if input is TOF or Q
    isTOFvalidated = getButtonValidated(Event,'InputFileFormat')
    if(isTOFvalidated eq '0') then begin ;input file is in TOF
        
;Converts the data from TOF to Q
        (*(*global).flt0_xaxis) = flt0
        
        angle_value_deg_array = (*(*global).angle_array)
        angle_value_deg = angle_value_deg_array[0]  ;because CE file only here
        convert_TOF_to_Q, Event, angle_value_deg
        
        flt0 = (*(*global).flt0_xaxis)
        
    endif
    
;determine the working flt0, flt1 and flt2
    RangeIndexes = getArrayRangeFromQ1Q2(flt0, Q1, Q2)
    left_index = RangeIndexes[0]
    right_index = RangeIndexes[1]

    flt0_new = flt0[left_index:right_index]
    flt1_new = flt1[left_index:right_index]
    flt2_new = flt2[left_index:right_index]

;remove the non defined and inf values from flt0, flt1 and flt2
    RangeIndexes = getArrayRangeOfNotNanValues(flt1_new)

    flt0_new = flt0_new(RangeIndexes)
    flt1_new = flt1_new(RangeIndexes)
    flt2_new = flt2_new(RangeIndexes)

    (*(*global).flt0_CE_range) = flt0_new

;Start function that will calculate the Fit function
    FitCEFunction, Event, flt0_new, flt1_new, flt2_new
    LongFileNameArray = [CE_file_name]
    plot_loaded_file, Event,LongFileNameArray

;display the value of the coeff in the A and B text boxes
    cooef = (*(*global).CEcooef)
    putValueInTextField, Event, 'step2_fitting_equation_a_text_field', strcompress(cooef[1])
    putValueInTextField, Event, 'step2_fitting_equation_b_text_field', strcompress(cooef[0])

endelse    
END



;Manual fitting of CE file using loaded parameters
PRO manualCEfitting, Event
;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

cooef1 = getValue(Event, 'step2_fitting_equation_a_text_field')
cooef0 = getValue(Event, 'step2_fitting_equation_b_text_field')

cooef1 = getNumeric(cooef1)
cooef0 = getNumeric(cooef0)

(*(*global).CEcooef) = [cooef0,cooef1]

plot_loaded_file, Event, (*global).full_CE_name

END
