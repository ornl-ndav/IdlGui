PRO REFreduction_ReduceNormalizationUpdateGui, Event

;check status of with or without normalization
isWithNormalizeFile = getCWBgroupValue(Event, 'yes_no_normalization_bgroup')
if (~isWithNormalizefile) then begin ;with normalization
    MapStatus = 1
endif else begin ;without normalization
    MapStatus = 0
endelse
MapBase, Event, 'normalization_base', MapStatus
END
