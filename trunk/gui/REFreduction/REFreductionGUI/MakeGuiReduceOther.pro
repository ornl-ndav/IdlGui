PRO MakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth

;Dimension
cwbgroup_list = [' Yes    ',' No    ']

;filtering data
FilteringDataLabelSize    = [20,550]
FilteringDataLabelTitle   = 'Filtering Data:'
FilteringDataCWBgroupSize = [220,FilteringDataLabelSize[1]-5]

d_vertical_L_L = 35
;Store dt/t
DeltaToverTLabelSize    = [FilteringDataLabelSize[0],$
                           FilteringDataLabelSize[1]+d_vertical_L_L]
DeltaToverTLabelTitle   = 'dt/t:'
DeltaToverTCWBgroupSize = [FilteringDataCWBgroupSize[0],$
                           DeltaToverTLabelSize[1]-5]

;overwrite instrument geometry
OverwriteInstrumentGeometryLabelSize    = [FilteringDataLabelSize[0],$
                                           DeltaToverTLabelSize[1]+d_vertical_L_L]
OverwriteInstrumentGeometryLabelTitle   = 'Overwrite Instrument Geometry:'
OverwriteInstrumentGeometryCWBgroupSize = [FilteringDataCWBgroupSize[0],$
                                           OverwriteInstrumentGeometryLabelSize[1]-5]

;************************************************************************************
;BUILD GUI

;filtering data
FilteringDataLabel = widget_label(REDUCE_BASE,$
                                  xoffset=FilteringDataLabelSize[0],$
                                  yoffset=FilteringDataLabelSize[1],$
                                  value=FilteringDataLabelTitle)

FilteringDataCWBgroup = cw_bgroup(REDUCE_BASE,$
                                  cwbgroup_list,$
                                  xoffset=FilteringDataCWBgroupSize[0],$
                                  yoffset=FilteringDataCWBgroupSize[1],$
                                  row=1,$
                                  /exclusive,$
                                  set_value=0,$
                                  uname='filtering_data_cwbgroup')


;store deltaT/T
DeltaToverTLabel = widget_label(REDUCE_BASE,$
                                xoffset=DeltaToverTLabelSize[0],$
                                yoffset=DeltaToverTLabelSize[1],$
                                value=DeltaToverTLabelTitle)

DeltaToverTCWBgroup = cw_bgroup(REDUCE_BASE,$
                                cwbgroup_list,$
                                xoffset=DeltaToverTCWBgroupSize[0],$
                                yoffset=DeltaToverTCWBgroupSize[1],$
                                row=1,$
                                /exclusive,$
                                set_value=0,$
                                uname='delta_t_over_t_cwbgroup')

;overwrite instrument geometry
OverwriteInstrumentGeometryLabel = widget_label(REDUCE_BASE,$
                                  xoffset=OverwriteInstrumentGeometryLabelSize[0],$
                                  yoffset=OverwriteInstrumentGeometryLabelSize[1],$
                                  value=OverwriteInstrumentGeometryLabelTitle)

OverwriteInstrumentGeometryCWBgroup = cw_bgroup(REDUCE_BASE,$
                                  cwbgroup_list,$
                                  xoffset=OverwriteInstrumentGeometryCWBgroupSize[0],$
                                  yoffset=OverwriteInstrumentGeometryCWBgroupSize[1],$
                                  row=1,$
                                  /exclusive,$
                                  set_value=0,$
                                  uname='overwrite_instrument_geometry_cwbgroup')





END
