PRO REFreduction_LoadDataBackgroundSelection, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;define filter
instrument = (*global).instrument
data_back_roi_ext = (*global).data_back_roi_ext
filter = instrument + '_*_' + data_back_roi_ext

;get default path 
WorkingPath = (*global).working_path

title = instrument + ' Data Background Selection File' ;title of pickfile

;open file
BackROIFullFileName = dialog_pickfile(path=WorkingPath,$
                                      get_path=path,$
                                      title=title,$
                                      filter=filter,$
                                      default_extension='.dat',$
                                      /fix_filter)

;if (IGFullFileName EQ '') then begin ;desactivate overwrite instrument geometry'
;    SetCWBgroup, Event, 'overwrite_instrument_geometry_cwbgroup', 1
;    MapBase, Event, 'overwrite_instrument_geometry_base', 0
;endif else begin
;    (*global).InstrumentGeometryFileName = IGFullFileName
;endelse

print, BackROIFullFileName


END



PRO REFreduction_LoadNormBackgroundSelecton, Event

print, 'here1'

END
