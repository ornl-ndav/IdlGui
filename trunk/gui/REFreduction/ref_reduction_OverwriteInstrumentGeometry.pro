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

filter = instrument + '_geom_*
return, filter
END





;*MAIN PROCEDURE ***************************************************************
PRO RefReduction_OverwriteInstrumentGeometry, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;get default path to Instrument Geometry
IGpath = (*global).InstrumentGeometryPath

instrument = (*global).instrument
title = instrument + ' Instrument Geometry' ;title of pickfile

;determine filter
filter = getIGfilter(Event, instrument)

;default_file_name
defaultFile = getLastGeometryFile(Event, IGpath)

;open file
IGFullFileName = dialog_pickfile(path=IGpath,$
                                 get_path=path,$
                                 title=title,$
                                 filter=filter,$
                                 default_extension='nxs',$
                                 /fix_filter,$
                                 file=defaultFile)

if (IGFullFileName EQ '') then begin ;desactivate overwrite instrument geometry'
    SetCWBgroup, Event, 'overwrite_instrument_geometry_cwbgroup', 1
    MapBase, Event, 'overwrite_instrument_geometry_base', 0
endif else begin
    (*global).InstrumentGeometryFileName = IGFullFileName
endelse

;refresh command line
REFreduction_CommandLineGenerator, Event


END
