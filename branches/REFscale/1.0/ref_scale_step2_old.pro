
















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




;Manual scaling of CE file using SF parameters
PRO manualCEScaling, Event

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get the scaling factor
SF=getTextFieldValue(Event,'step2_sf_text_field')
SFnumeric = getNumeric(SF)

if (SFnumeric) then begin ;SF is a valid float

    (*global).CE_scaling_factor = SFnumeric
    
    flt0_ptr = (*global).flt0_ptr
    flt1_ptr = (*global).flt1_ptr
    flt2_ptr = (*global).flt2_ptr
    
;retrieve particular flt0, flt1 and flt2 (CE file)
    flt0 = *flt0_ptr[0]
    flt1 = *flt1_ptr[0]
    flt2 = *flt2_ptr[0]
    
;divide by scaling factor
    flt1 = flt1/SFnumeric
    flt2 = flt2/SFnumeric
    
;save new values
    flt0_rescale_ptr = (*global).flt0_rescale_ptr
    *flt0_rescale_ptr[0] = flt0
    (*global).flt0_rescale_ptr = flt0_rescale_ptr
    
    flt1_rescale_ptr = (*global).flt1_rescale_ptr
    *flt1_rescale_ptr[0] = flt1
    (*global).flt1_rescale_ptr = flt1_rescale_ptr
    
    flt2_rescale_ptr = (*global).flt2_rescale_ptr
    *flt2_rescale_ptr[0] = flt2
    (*global).flt2_rescale_ptr = flt2_rescale_ptr
    
    steps_tab, Event, 1
    
endif

END












