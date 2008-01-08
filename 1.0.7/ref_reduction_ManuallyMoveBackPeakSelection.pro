PRO REFreduction_ManuallyMoveDataBackPeakUp, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveDataBackPeak, Event, coefficient
END

PRO REFreduction_ManuallyMoveDataBackPeakDown, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveDataBackPeak, Event, -coefficient
END

PRO REFreduction_ManuallyMoveNormBackPeakUp, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveNormBackPeak, Event, coefficient
END

PRO REFreduction_ManuallyMoveNormBackPeakDown, Event
coefficient = getUDCoefficient(Event)
REFreduction_ManuallyMoveNormBackPeak, Event, -coefficient
END



;############# D A T A #########################################
PRO REFreduction_ManuallyMoveDataBackPeak, Event, coefficient
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

MiniVersion = (*global).miniVersion ;1 for miniVersion, 0 for normal version

if ((*global).DataNeXusFound) then begin ;only if there is a NeXus loaded
    
;check what we need to move

;Back or Peak
    BackSignalZoomStatus = isDataBackPeakZoomSelected(Event)
    CASE (BackSignalZoomStatus) OF
        0: begin                ;back
            type = 'back_'
        end
        1: begin                ;signal
            type = 'peak_'
        end
        2: begin                ;zoom
            type = 'zoom'
        end
        ELSE:
    ENDCASE
    
;Ymin or Ymax
    YminStatus = isDataYminSelected(Event)
    CASE (YminStatus) OF
        0: begin
            type += 'ymax'
        end
        1: begin
            type += 'ymin'
        end
    else:
    ENDCASE
    
;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event,'data_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event,'data_d_selection_background_ymax_cw_field')

    if (BackYmin EQ '') then begin
        BackYmin = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            BackYmin *= 2
        ENDIF
    endelse
    if (BackYmax EQ '') then begin
        BackYmax = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            BackYmax *= 2
        ENDIF
    endelse

;get Peak Ymin, Ymax
    PeakYmin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextfieldValue(Event,'data_d_selection_peak_ymax_cw_field')
    
    if (PeakYmin EQ '') then begin
        PeakYmin = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            PeakYmin *= 2
        ENDIF
    endelse

    if (PeakYmax EQ '') then begin
        PeakYmax = -1
    endif else begin
        IF (MiniVersion EQ 0) THEN BEGIN
            PeakYmax *= 2
        ENDIF
    endelse

    CASE (TYPE) OF
        'back_ymin' : begin
            DataYMouseSelection = BackYmin
            BackYmin += coefficient
        end
        'back_ymax' : begin
            DataYMouseSelection = BackYmax
            BackYmax += coefficient
        end
        'peak_ymin' : begin
            DataYMouseSelection = PeakYmin
            PeakYmin += coefficient
        end
        'peak_ymax' : begin
            DataYMouseSelection = PeakYmax
            PeakYmax += coefficient
        end
        else        : DataYMouseSelection = 0
    ENDCASE

    BackSelection = [BackYmin,BackYmax]
    (*(*global).data_back_selection) = BackSelection

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).data_peak_selection) = PeakSelection

    putDataBackgroundPeakYMinMaxValueInTextFields, Event

    ReplotDataBackPeakSelection, Event, BackSelection, PeakSelection

;display zoom if zomm tab is selected
    if (isDataZoomTabSelected(Event)) then begin

        DataXMouseSelection = (*global).DataXMouseSelection
        
        RefReduction_zoom, $
          Event, $
          MouseX=DataXMouseSelection, $
          MouseY=DataYMouseSelection, $
          fact=(*global).DataZoomFactor,$
          uname='data_zoom_draw'

    endif
    
endif

END




;############# N O R M A L I Z A T I O N #########################
PRO REFreduction_ManuallyMoveNormBackPeak, Event, coefficient
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).NormNeXusFound) then begin ;only if there is a NeXus loaded

;check what we need to move

;Back or Peak
    BackSignalZoomStatus = isNormBackPeakZoomSelected(Event)
    CASE (BackSignalZoomStatus) OF
        0: begin                ;back
            type = 'back_'
        end
        1: begin                ;signal
            type = 'peak_'
        end
        2: begin                ;zoom
            type = 'zoom'
        end
        ELSE:
    ENDCASE
    
;Ymin or Ymax
    YminStatus = isNormYminSelected(Event)
    CASE (YminStatus) OF
        0: begin
            type += 'ymax'
        end
        1: begin
            type += 'ymin'
        end
    else:
    ENDCASE

;get Background Ymin, Ymax
    BackYmin = getTextFieldValue(Event,'normalization_d_selection_background_ymin_cw_field')
    BackYmax = getTextFieldValue(Event,'normalization_d_selection_background_ymax_cw_field')

    if (BackYmin EQ '') then begin
        BackYmin = -1
    endif else begin
        BackYmin *= 2
    endelse

    if (BackYmax EQ '') then begin
        BackYmax = -1
    endif else begin
        BackYmax *= 2
    endelse
    
;get Peak Ymin and Ymax
    PeakYmin = getTextFieldValue(Event,'normalization_d_selection_peak_ymin_cw_field')
    PeakYmax = getTextFieldValue(Event,'normalization_d_selection_peak_ymax_cw_field')

    if (PeakYmin EQ '') then begin
        PeakYmin = -1
    endif else begin
        PeakYmin *= 2
    endelse

    if (PeakYmax EQ '') then begin
        PeakYmax = -1
    endif else begin
        PeakYmax *= 2
    endelse

    CASE (TYPE) OF
        'back_ymin' : begin
            NormYMouseSelection = BackYmin
            BackYmin += coefficient
        end
        'back_ymax' : begin
            NormYMouseSelection = BackYmax
            BackYmax += coefficient
        end
        'peak_ymin' : begin
            NormYMouseSelection = PeakYmin
            PeakYmin += coefficient
        end
        'peak_ymax' : begin
            NormYMouseSelection = PeakYmax
            PeakYmax += coefficient
        end
        else        : NormYMouseSelection = 0
    ENDCASE

    BackSelection = [BackYmin,BackYmax]
    (*(*global).norm_back_selection) = BackSelection

    PeakSelection = [PeakYmin,PeakYmax]
    (*(*global).norm_peak_selection) = PeakSelection
    
    putNormBackgroundPeakYMinMaxValueInTextFields, Event
    ReplotNormBackPeakSelection, Event, BackSelection, PeakSelection

;display zoom if zomm tab is selected
    if (isNormZoomTabSelected(Event)) then begin

        NormXMouseSelection = (*global).NormXMouseSelection
                
        RefReduction_zoom, $
          Event, $
          MouseX=NormXMouseSelection, $
          MouseY=NormYMouseSelection, $
          fact=(*global).NormalizationZoomFactor,$
          uname='normalization_zoom_draw'
    endif

endif

END















