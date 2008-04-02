;this function updates the droplist according to the intermediate
;plots selected
PRO RefReduction_updatePlotsDropList, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get list of intermediate plots selected
IntermPlots = (*global).IntermPlots
;get title of intermediate plots
PlotsTitle = (*(*global).PlotsTitle)
;get title of main data reduction plot
MainPlotTitle = (*global).MainPlotTitle

;initial droplist
DropListArray = strarr(1)
DropListArray[0] = MainPlotTitle

;check the max number of intermediate plot we can have
sz = size(IntermPlots)
InterPlotsNbr = sz(1)

for i=0,(InterPlotsNbr-1) do begin
    if (IntermPlots[i] EQ 1) then begin
        DropListArray = [DropListArray,PlotsTitle[i]]
    endif
endfor

putPlotsDropListContain, event, DropListArray

END



;This function enables or not the droplist of the PLOTS tab
PRO RefReduction_UpdatePlotsGui, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

IF ((*global).DataReductionStatus EQ 'OK') then begin ;data reduction was successful
    dropListStatus = 1
ENDIF ELSE BEGIN
    dropListStatus = 0
ENDELSE

ActivateWidget, Event, 'plots_droplist', dropListStatus


END
