PRO BSSreduction_IntermediatePlotsUpdateDroplist, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;Write out Calculated Time-Independent Background
IF (isButtonSelected(Event,'woctib_button') AND $
    isBaseMapped(Event, 'na_woctibbase') EQ 0) THEN BEGIN
    woctib_status = 1
ENDIF ELSE BEGIN
    woctib_status = 0
ENDELSE

;Write out Pixel Wavelength Spectra
IF (isButtonSelected(Event,'wopws_button')) THEN BEGIN
    wopws_status = 1
ENDIF ELSE BEGIN
    wopws_status = 0
ENDELSE

;Write out Monitor Wavelength Spectrum
IF (isButtonSelected(Event,'womws_button') AND $
    isBaseMapped(Event, 'na_womwsbase') EQ 0) THEN BEGIN
    womws_status = 1
ENDIF ELSE BEGIN
    womws_status = 0
ENDELSE

;Write out Monitor Efficiency Spectrum
IF (isButtonSelected(Event,'womes_button') AND $
    isBaseMapped(Event, 'na_womesbase') EQ 0) THEN BEGIN
    womes_status = 1
ENDIF ELSE BEGIN
    womes_status = 0
ENDELSE

;Write out Rebinned Monitor Spectra
IF (isButtonSelected(Event,'worms_button') AND $
    isBaseMapped(Event, 'na_wormsbase') EQ 0) THEN BEGIN
    worms_status = 1
ENDIF ELSE BEGIN
    worms_status = 0
ENDELSE

;Write out Combined Pixel Spectrum After Monitor Normalization
IF (isButtonSelected(Event,'wocpsamn_button') AND $
    isBaseMapped(Event, 'na_wocpsamnbase') EQ 0) THEN BEGIN
    wocpsamn_status = 1
ENDIF ELSE BEGIN
    wocpsamn_status = 0
ENDELSE

;Write out Pixel Initial Energy Spectra
IF (isButtonSelected(Event,'wopies_button')) THEN BEGIN
    wopies_status = 1
ENDIF ELSE BEGIN
    wopies_status = 0
ENDELSE

;Write out Pixel Energy Transfer Spectra
IF (isButtonSelected(Event,'wopets_button')) THEN BEGIN
    wopets_status = 1
ENDIF ELSE BEGIN
    wopets_status = 0
ENDELSE

;Write out Linearly Interpolated Direct Scattering Back. Info. Summed
;over all Pixels
IF (isButtonSelected(Event,'wolidsb_button') AND $
    isBaseMapped(Event, 'na_wolidsbbase') EQ 0) THEN BEGIN
    wolidsb_status = 1
ENDIF ELSE BEGIN
    wolidsb_status = 0
ENDELSE

;update ListOfOutputPlots structure
ListOfOutputPlots = (*global).ListOfOutputPlots
ListOfOutputPlots.woctib_button   = woctib_status
ListOfOutputPlots.wopws_button    = wopws_status
ListOfOutputPlots.womws_button    = womws_status
ListOfOutputPlots.womes_button    = womes_status
ListOfOutputPlots.worms_button    = worms_status
ListOfOutputPlots.wocpsamn_button = wocpsamn_status
ListOfOutputPlots.wopies_button   = wopies_status
ListOfOutputPlots.wopets_button   = wopets_status
ListOfOutputPlots.wolidsb_button  = wolidsb_status
(*global).ListOfOutputPlots = ListOfOutputPlots

NameOfOutputPlots = (*global).NameOfOutputPlots
FinalOutputPlotsList = ['S(E)','sigma(E)']

sz = N_TAGS(ListOfOutputPlots)
FOR I=0,(sz-1) DO BEGIN
    IF (ListOfOutputPlots.(i) EQ 1) THEN BEGIN
        FinalOutputPlotsList = [FinalOutputPlotsList,NameOfOutputPlots.(i)]
    ENDIF
ENDFOR

;update droplist of output tab
id = widget_info(event.top,find_by_uname='output_file_name_droplist')
widget_control, id, set_value=FinalOutputPlotsList

END


;This procedure display the current selected plot as well as the data
;file and the metadata.
PRO BSSreduction_DisplayOutputFiles, Event
;get selected file name
SelectedFileName = getOutputDroplistFileName(Event)
;create instance of the IDLoutputFile class
SelectedFile = obj_new('IDLoutputFile', Event, SelectedFileName)
;display metadata
IF (SelectedFile->getErrorStatus() NE 1) THEN BEGIN
    Metadata = SelectedFile->GetMetadata()
    PutUncompressedTextInTextField, Event, 'output_file_header_text', Metadata
;create data array for display
    X     = SelectedFile->GetX()
    Y     = SelectedFile->GetY()
    Error = SelectedFile->GetError()
    sz    = (size(x))(1)
    data  = strarr(sz)
    FOR i=0,(sz-1) DO BEGIN
        str = strcompress(X[i],/remove_all)
        str += '  ' + strcompress(Y[i],/remove_all)
        str += '  ' + strcompress(Error[i],/remove_all)
        data[i]=str
    ENDFOR
    PutUncompressedTextInTextField, Event, 'output_file_data_text', data
ENDIF ELSE BEGIN
    PutUncompressedTextInTextField, Event, 'output_file_header_text', 'FILE NOT FOUND'
    PutUncompressedTextInTextField, Event, 'output_file_data_text', 'FILE NOT FOUND'
ENDELSE

END
