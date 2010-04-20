;returns the last up to date geometry file
FUNCTION getLastGeometryFile, Event, IGpath

  cmd = 'ls -t ' + IGpath + '*.nxs'
  spawn, cmd, fileList
  defaultFile = fileList[0]
  
  return, defaultFile
END




;return the filter used for the instrument geometry selection file
FUNCTION getIGfilter, Event, instrument
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  filter = instrument + '_geom_*'
  return, filter
END





;*MAIN PROCEDURE ***************************************************************
PRO RefReduction_OverwriteDataInstrumentGeometry, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get default path to Instrument Geometry
  IGpath = (*global).InstrumentGeometryPath
  
  instrument = (*global).instrument
  title = instrument + ' Data Instrument Geometry' ;title of pickfile
  
  ;determine filter
  filter = getIGfilter(Event, instrument)
  
  ;default_file_name
  defaultFile = getLastGeometryFile(Event, IGpath)
  
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  ;open file
  IGFullFileName = dialog_pickfile(path=IGpath,$
    get_path=path,$
    title=title,$
    dialog_parent=widget_id,$
    filter=filter,$
    default_extension='nxs',$
    /fix_filter,$
    file=defaultFile)
    
  if (IGFullFileName EQ '') then begin ;desactivate overwrite instrument geometry'
    SetCWBgroup, Event, 'overwrite_data_instrument_geometry_cwbgroup', 1
    MapBase, Event, 'overwrite_data_instrument_geometry_base', 0
  endif else begin
    (*global).InstrumentDataGeometryFileName = IGFullFileName
  endelse
  
  ;refresh command line
  REFreduction_CommandLineGenerator, Event
  
  
END



PRO RefReduction_OverwriteNormInstrumentGeometry, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;get default path to Instrument Geometry
  IGpath = (*global).InstrumentGeometryPath
  
  instrument = (*global).instrument
  title = instrument + ' Normalization Instrument Geometry' ;title of pickfile
  
  ;determine filter
  filter = getIGfilter(Event, instrument)
  
  ;default_file_name
  defaultFile = getLastGeometryFile(Event, IGpath)
  
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  ;open file
  IGFullFileName = dialog_pickfile(path=IGpath,$
    get_path=path,$
    dialog_parent = widget_id,$
    title=title,$
    filter=filter,$
    default_extension='nxs',$
    /fix_filter,$
    file=defaultFile)
    
  if (IGFullFileName EQ '') then begin ;desactivate overwrite instrument geometry'
    SetCWBgroup, Event, 'overwrite_norm_instrument_geometry_cwbgroup', 1
    MapBase, Event, 'overwrite_norm_instrument_geometry_base', 0
  endif else begin
    (*global).InstrumentNormGeometryFileName = IGFullFileName
  endelse
  
  ;refresh command line
  REFreduction_CommandLineGenerator, Event
  
END
