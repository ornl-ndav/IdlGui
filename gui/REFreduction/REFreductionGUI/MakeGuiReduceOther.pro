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

d_group_base = 145
OverwriteInstrumentGeometryBaseSize = [OverwriteInstrumentGeometryCWBgroupSize[0]+$
                                       d_group_base,$
                                       OverwriteInstrumentGeometryCWBgroupSize[1]-5,$
                                       340,40]

OverwriteInstrumentGeometryButtonSize = [5,5,320,30]
OverwriteInstrumentGeometryButtonTitle = 'Select the Geometry File'

;START data reduction button
StartDRButtonSize = [5,OverwriteInstrumentGeometryLabelSize[1]+d_vertical_L_L,$
                     1180,40]
StartDRButtonTitle = '>          >         >        >       >      >     >    >   >  > >> S T A R T    D A T A    R E D U C T I O N << <  <   <    <     <      <       <        <         <          < '

;command line preview/generator
d_vertical_L_L_2 = d_vertical_L_L + 20
cmdLinePreviewLabelSize = [5,StartDRButtonSize[1]+d_vertical_L_L_2]
cmdLinePreviewLabelTitle = 'Preview of the Command Line'
d_vertical_L_L_3 = 20
cmdLinePreviewTextSize = [5,cmdLinePreviewLabelSize[1]+d_vertical_L_L_3,$
                          1180,100]
                           

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
                                  set_value=1,$
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
                                set_value=1,$
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
                                                set_value=1,$
                                                uname='overwrite_instrument_geometry_cwbgroup')

OverwriteInstrumentGeometryBase = widget_base(REDUCE_BASE,$
                                              xoffset=OverwriteInstrumentGeometryBaseSize[0],$
                                              yoffset=OverwriteInstrumentGeometryBaseSize[1],$
                                              scr_xsize=OverwriteInstrumentGeometryBaseSize[2],$
                                              scr_ysize=OverwriteInstrumentGeometryBaseSize[3],$
                                              map=0,$
                                              uname='overwrite_instrument_geometry_base')

OverwriteInsrumentGeometryButton = widget_button(OverwriteInstrumentGeometryBase,$
                                                 xoffset=OverwriteInstrumentGeometryButtonSize[0],$
                                                 yoffset=OverwriteInstrumentGeometryButtonSize[1],$
                                                 scr_xsize=OverwriteInstrumentGeometryButtonSize[2],$
                                                 scr_ysize=OverwriteInstrumentGeometryButtonSize[3],$
                                                 value=OverwriteInstrumentGeometryButtonTitle)
                                                 
;Start data reduction button
StartDataReductionButton = widget_button(REDUCE_BASE,$
                                         uname='start_data_reduction_button',$
                                         xoffset=StartDRButtonSize[0],$
                                         yoffset=StartDRButtonSize[1],$
                                         scr_xsize=StartDRButtonSize[2],$
                                         scr_ysize=StartDRButtonSize[3],$
                                         value=StartDRButtonTitle,$
                                         sensitive=0)

;command line preview
cmdLinePreviewLabel = widget_label(REDUCE_BASE,$
                                   xoffset=cmdLinePreviewLabelSize[0],$
                                   yoffset=cmdLinePreviewLabelSize[1],$
                                   value=cmdLinePreviewLabelTitle)

cmdLinePreviewText = widget_text(REDUCE_BASE,$
                                 uname='reduce_cmd_line_preview',$
                                 xoffset=cmdLinePreviewTextSize[0],$
                                 yoffset=cmdLinePreviewTextSize[1],$
                                 scr_xsize=cmdLinePreviewTextSize[2],$
                                 scr_ysize=cmdLinePreviewTextSize[3],$
                                 value='',$
                                 /scroll,$
                                 /wrap)
                               
END
