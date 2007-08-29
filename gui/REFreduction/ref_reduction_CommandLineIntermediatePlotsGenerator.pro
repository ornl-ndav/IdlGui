;Populate an array that list the intermediate plots the user wants to see
PRO PopulateIntermPLotsArray, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IntermPlots = (*global).IntermPlots

;get status of all buttons
InterPlotsStatus = getCWBgroupValue(Event, 'intermediate_plot_list')

;Data Specular Intermediate Plot
if (InterPlotsStatus[0] EQ 1) then begin
    IntermPlots[0] = 1
endif else begin
    IntermPlots[0] = 0
endelse

;Data Background Plot
if (isBaseMap(Event,'reduce_plot2_base') EQ 0 AND $
    InterPlotsStatus[1] EQ 1) then begin
    IntermPlots[1] = 1
endif else begin
    IntermPlots[1] = 0
endelse

;Data Sub Plot
if (isBaseMap(Event,'reduce_plot3_base') EQ 0 AND $
    InterPlotsStatus[2] EQ 1) then begin
    IntermPlots[2] = 1
endif else begin
    IntermPlots[2] = 0
endelse

;Normalization Specular Intermediate Plot
if (isBaseMap(Event,'reduce_plot4_base') EQ 0 AND $
    InterPlotsStatus[3] EQ 1) then begin
    IntermPlots[3] = 1
endif else begin
    IntermPlots[3] = 0
endelse

;Normalization Background Plot
if (isBaseMap(Event,'reduce_plot5_base') EQ 0 AND $
    InterPlotsStatus[4] EQ 1) then begin
    IntermPlots[4] = 1
endif else begin
    IntermPlots[4] = 0
endelse

;Normalization Sub Plot
if (isBaseMap(Event,'reduce_plot6_base') EQ 0 AND $
    InterPlotsStatus[5] EQ 1) then begin
    IntermPlots[5] = 1
endif else begin
    IntermPlots[5] = 0
endelse

;Combine plot
if (InterPlotsStatus[6] EQ 1) then begin
    IntermPlots[6] = 1
endif else begin
    IntermPlots[6] = 0
endelse

(*global).IntermPlots = IntermPlots

END




;This function creates the Intermediate Plots part of the command line
FUNCTION RefReduction_CommandLineIntermediatePlotsGenerator, Event

;get status of all buttons
InterPlotsStatus = getCWBgroupValue(Event, 'intermediate_plot_list')

IP_cmd = ''
;Data and Normalization Specular Intermediate Plot
if (InterPlotsStatus[0] EQ 1) then begin
    IP_cmd += ' --dump-specular'
endif 

;Data and Normalization Background Plot
if (isBaseMap(Event,'reduce_plot2_base') EQ 0 OR $
    isBaseMap(Event,'reduce_plot5_base') EQ 0) then begin ;plot available
    if (InterPlotsStatus[1] EQ 1 OR $
        InterPlotsStatus[4] EQ 1) then begin
        IP_cmd += ' --dump-bkg'
    endif
endif

;Data and Normalization Sub Plot
if (isBaseMap(Event,'reduce_plot3_base') EQ 0 OR $
    isBaseMap(Event,'reduce_plot6_base') EQ 0) then begin ;plot available
    if (InterPlotsStatus[2] EQ 1 OR $
        InterPlotsStatus[5] EQ 1) then begin
        IP_cmd += ' --dump-sub'
    endif
endif

;Combine plot
if (InterPlotsStatus[6] EQ 1) then begin
    IP_cmd += ' --dump-rtof'
endif

;create array of Intermediate files to plot
PopulateIntermPLotsArray, Event

return, IP_cmd
END

