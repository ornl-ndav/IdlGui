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

return, IP_cmd
END

