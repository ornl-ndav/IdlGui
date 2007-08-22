PRO REFreduction_ReduceNormalizationUpdateGui, Event

;check status of with or without normalization
isWithNormalizeFile = getCWBgroupValue(Event, 'yes_no_normalization_bgroup')
if (~isWithNormalizefile) then begin ;without normalization
    MapStatus = 1
endif else begin ;with normalization
    MapStatus = 0
endelse
MapBase, Event, 'normalization_base', MapStatus
END


PRO REFreduction_ReduceIntermediatePlotUpdateGui, Event

;check status of with or without intermediate plots
isWithIntermediatePlot = getCWBgroupValue(Event, 'intermediate_plot_cwbgroup')
if (~isWithIntermediatePlot) then begin ;without intermediate plots
    MapStatus = 1
endif else begin ;with intermediate
    MapStatus = 0
endelse
MapBase, Event, 'intermediate_base', MapStatus
END

