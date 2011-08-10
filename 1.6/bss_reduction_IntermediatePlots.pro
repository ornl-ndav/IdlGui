;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO BSSreduction_PlotIntermediateFile, Event, X, Y, Error
  draw_id = widget_info(Event.top, find_by_uname='output_file_plot')
  WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
  wset,view_plot_id
  
  DEVICE, DECOMPOSED = 0
  loadct,5, /SILENT
  
  err_plot = 0
  CATCH, err_plot
  if (err_plot NE 0) then begin
    CATCH,/cancel
  endif else begin
    plot,X,Y
    errplot, X,Y-Error,Y+Error
  endelse
END

;------------------------------------------------------------------------------
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
  
  ;Write out Linearly Interpolated Direct Scattering Back. Info. Summed
  ;over all Pixels
  IF (isButtonSelected(Event,'wolidsb_button') AND $
    isBaseMapped(Event, 'na_wolidsbbase') EQ 0) THEN BEGIN
    wolidsb_status = 1
  ENDIF ELSE BEGIN
    wolidsb_status = 0
  ENDELSE
  
  ;Write out Solid Angle Distribution from S(Q,E) Rebinning
  ButtonValue = getButtonValue(Event,'mtha_button')
  IF (isButtonSelected(Event,'sad') AND $
    ButtonValue EQ 0) THEN BEGIN
    sad_status = 1
  ENDIF ElSE BEGIN
    sad_status = 0
  ENDELSE
  
  ;update ListOfOutputPlots structure
  ListOfOutputPlots = (*global).ListOfOutputPlots
  ListOfOutputPlots.woctib_button   = woctib_status
  ListOfOutputPlots.wopws_button    = wopws_status
  ListOfOutputPlots.womws_button    = womws_status
  ListOfOutputPlots.womes_button    = womes_status
  ListOfOutputPlots.worms_button    = worms_status
  ListOfOutputPlots.wocpsamn_button = wocpsamn_status
  ListOfOutputPlots.wolidsb_button  = wolidsb_status
  ListOfOutputPlots.sad_button = sad_status
  (*global).ListOfOutputPlots = ListOfOutputPlots
  
  NameOfOutputPlots = (*global).NameOfOutputPlots
  OutputPlotsExt    = (*global).OutputPlotsExt
  FinalOutputPlotsList = ['Sq(E)']
  output_file_name     = getIntermediateFileName(Event, $
    (*global).MainDRPlotsExt.sqe)
  FullNameOutputPlots  = [output_file_name]
  
  ;create droplist list and name of output files
  sz = N_TAGS(ListOfOutputPlots)
  FOR I=0,(sz-1) DO BEGIN
    IF (ListOfOutputPlots.(i) EQ 1) THEN BEGIN
      FinalOutputPlotsList = [FinalOutputPlotsList,NameOfOutputPlots.(i)]
      output_file_name     = getIntermediateFileName(Event, $
        outputPlotsExt.(i))
      FullNameOutputPlots  = [FullNameOutputPlots,output_file_name]
    ENDIF
  ENDFOR
  
  ;update droplist of output tab
  id = widget_info(event.top,find_by_uname='output_file_name_droplist')
  widget_control, id, set_value=FinalOutputPlotsList
  
  (*(*global).FullNameOutputPlots) = FullNameOutputPlots
  
END

;------------------------------------------------------------------------------
;This procedure display the current selected plot as well as the data
;file and the metadata.
PRO BSSreduction_DisplayOutputFiles, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get reduce status message
  DRstatusText = getTextFieldValue(Event, 'data_reduction_status_text')
  
  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  
  IF (DRstatusText EQ (*global).DRstatusOK) THEN BEGIN
    read_error = 0
    CATCH, read_error
    IF (read_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      activate_plot_button_status = 0
    ENDIF ELSE BEGIN
      ;get full name of output files
      FullNameOutputPlots = (*(*global).FullNameOutputPlots)
      
      ;get selected index
      index_selected = getDropListSelectedIndex(Event, $
        'output_file_name_droplist')
      ;get selected file name
      SelectedFileName = FullNameOutputPlots[index_selected]
      
      ;put name of file label file name
      putTextinTextField, Event, 'output_plot_file_name', selectedFileName
      
      ;create instance of data file
      iData = OBJ_NEW('IDL3columnsASCIIparser', SelectedFileName)
      
      ;get preview of file
      preview = iData->getFullFile()
      OBJ_DESTROY, iData
      
      ;put data in preview text_field
      putTextFieldValue, Event, 'output_file_data_text', preview, 0
      
      activate_plot_button_status = 1
      
    ENDELSE
    
    ;activate or not plot button
    activate_base, Event, 'output_plot_data_base', activate_plot_button_status
    
  ENDIF ;end of if(DRstatusText EQ 'Data Reduction ...
  ;ERROR! (-> Check Log Book)')
  ;turn off hourglass
  widget_control,hourglass=0
  
END

;------------------------------------------------------------------------------
PRO PlotOutputData, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;get selected index
  index_selected = getDropListSelectedIndex(Event, $
    'output_file_name_droplist')
  output_file_name = getTextFieldValue(Event,'output_plot_file_name')
  ;get file extension
  file_ext = getFileExt(output_file_name)
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  ;output_file_name = '~/result/BSS_638_200811m5_133300_data.mxl' ;REMOVE_ME
  ;index_selected = 1 ;REMOVE_ME
  
  plot_error = 0
  CATCH, plot_error
  IF (plot_error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    IF (file_ext EQ 'txt') THEN BEGIN ;'.txt'
    
      iASCII = OBJ_NEW('IDL3columnsASCIIparser', $
        output_file_name,$
        TYPE = 'Sq(E)')
      sData = iASCII->getDataQuickly(ERange,QRange)
      OBJ_DESTROY, iASCII
      fData = getValueOnly(sData) ;_get
      
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
      base_geometry = WIDGET_INFO(id,/GEOMETRY)
      
      ERange = FLOAT(ERange)
      QRange = FLOAT(QRange)
      
      sStructure = PTR_NEW({ base_geometry: base_geometry,$
        fData: fData,$
        ERange: ERange,$
        QRange: QRange,$
        sys_color_face_3d: INTARR(3),$
        output_file_name: output_file_name })
        
      iPlot = OBJ_NEW('IDLplotTxt', sStructure)
      
    ENDIF ELSE BEGIN            ;other cases
    
      iASCII = OBJ_NEW('IDL3columnsASCIIparser',output_file_name)
      sData = iASCII->getDataQuickly()
      sAxis = iASCII->get1Daxis()
      OBJ_DESTROY, iASCII
      
      nbr_row = DOUBLE(N_ELEMENTS(sData) / 3.)
      
      ;try to keep the number of row below 2000
      IF (nbr_row GT 2000.) THEN BEGIN
        new_nbr_row = 2000.
        factor = FIX(double(nbr_row) / double(new_nbr_row))
        i = 0.
        new_sData = STRARR(3,new_nbr_row)
        WHILE (i*factor LT nbr_row) DO BEGIN
          new_sData[*,i] = sData[*,i*factor]
          i++
        ENDWHILE
        sData = new_sData
        nbr_row = new_nbr_row
      ENDIF
      
      newDataArray = REFORM(sData,3,nbr_row)
      
      title = getDropListSelectedValue(Event, 'output_file_name_droplist')
      
      IPLOT, newDataArray[0,*], $
        newDataArray[1,*],$
        /DISABLE_SPLASH_SCREEN,$
        TITLE = title,$
        SYM_INDEX = 1,$
        XTITLE = sAxis[0],$
        YTITLE = sAxis[1]
      VIEW_TITLE = title
      
    ENDELSE
    
  ENDELSE ;end of CATCH statement
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END

;------------------------------------------------------------------------------
PRO display_metadata, Event, file_name
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  read_error = 0
  CATCH, read_error
  IF (read_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    activate_plot_button_status = 0
  ENDIF ELSE BEGIN
  
    ;get selected file name
    SelectedFileName = file_name
    
    ;put name of file label file name
    putTextinTextField, Event, 'output_plot_file_name', selectedFileName
    
    ;create instance of data file
    iData = OBJ_NEW('IDL3columnsASCIIparser', SelectedFileName)
    
    ;get preview of file
    preview = iData->getFullFile()
    OBJ_DESTROY, iData
    
    ;put data in preview text_field
    putTextFieldValue, Event, 'output_file_data_text', preview, 0
    
    activate_plot_button_status = 1
    
  ENDELSE
  
  ;activate or not plot button
  activate_base, Event, 'output_plot_data_base', activate_plot_button_status
  
END

;------------------------------------------------------------------------------

PRO BrowseOutputPlot, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  default_path = (*global).output_plot_path
  title         = 'Select a file to plot ... '
  
  file_name = DIALOG_PICKFILE(PATH  = default_path,$
    TITLE = title,$
    /READ,$
    /MUST_EXIST)
    
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  IF (file_name NE '') THEN BEGIN
    ;put name of file in label box
    putTextInTextField, Event, 'output_plot_file_name', file_name
    ;display metadata of selected file
    display_metadata, Event, file_name
  ENDIF
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END
