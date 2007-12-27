PRO miniMakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth

;Dimension
cwbgroup_list = [' Yes    ',' No    ']
cwbgroup2_list = [' Yes ',' No']

;filtering data
FilteringDataLabelSize    = [15,455]
FilteringDataLabelTitle   = 'Filtering Data:'
FilteringDataCWBgroupSize = [220,FilteringDataLabelSize[1]-5]

d_vertical_L_L = 30
;Store dt/t
DeltaToverTLabelSize    = [FilteringDataLabelSize[0],$
                           FilteringDataLabelSize[1]+d_vertical_L_L]
DeltaToverTLabelTitle   = 'dt/t:'
DeltaToverTCWBgroupSize = [FilteringDataCWBgroupSize[0],$
                           DeltaToverTLabelSize[1]-5]

;overwrite data instrument geometry
yoff = 0
OverwriteInstrumentGeometryLabelSize    = [FilteringDataLabelSize[0],$
                                           DeltaToverTLabelSize[1]+d_vertical_L_L+yoff]
OverwriteInstrumentGeometryLabelTitle   = 'Overwrite Data Instrument Geometry:'
xoff = 20
OverwriteInstrumentGeometryCWBgroupSize = [FilteringDataCWBgroupSize[0]+15,$
                                           OverwriteInstrumentGeometryLabelSize[1]-5]

d_group_base = 130
OverwriteInstrumentGeometryBaseSize = [OverwriteInstrumentGeometryCWBgroupSize[0]+$
                                       d_group_base-25,$
                                       OverwriteInstrumentGeometryCWBgroupSize[1]-5,$
                                       230,30]

OverwriteInstrumentGeometryButtonSize = [0,5,230,25]
OverwriteInstrumentGeometryButtonTitle = 'Select a Data Instr. Geometry File'

;overwrite norm instrument geometry
yoff += 3
NormIGlabel = { size : [FilteringDataLabelSize[0],$
                        OverwriteInstrumentGeometryLabelSize[1]+d_vertical_L_L+yoff],$
                title : 'Overwrite Norm. Instrument Geometry:'}
NormIGgroup = { size : [NormIGlabel.size[0]+220,$
                        NormIGLabel.size[1]-5],$
                uname : 'overwrite_norm_instrument_geometry_cwbgroup'}
NormIGbase = { size : [NormIGgroup.size[0]+d_group_base-25,$
                       NormIGgroup.size[1]-5,230,40],$
               uname : 'overwrite_norm_instrument_geometry_base'}
NormIGbutton = {size : [0,5,230,25],$
                title : 'Select a Norm. Instr. Geometry File',$
                uname : 'overwrite_norm_instrument_geometry_button'}

;START data reduction button
StartDRButtonSize = [5, $
                     OverwriteInstrumentGeometryLabelSize[1]+d_vertical_L_L+33,$
                     865, $
                     35]
StartDRButtonTitle = $
  '>        >       >      >     >    >   >  > >> S T A R T    D A T A    R E D U C T I O N << <  <   <    <     <      <       <        <'

;command line preview/generator
d_vertical_L_L_2 = d_vertical_L_L + 8
cmdLinePreviewLabelSize = [5,StartDRButtonSize[1]+d_vertical_L_L_2]
cmdLinePreviewLabelTitle = 'Preview of the Command Line'
d_vertical_L_L_3 = -5
cmdLinePreviewTextSize = [5, $
                          cmdLinePreviewLabelSize[1]+d_vertical_L_L_3,$
                          865, $
                          55]
                           
;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

;filtering data
FilteringDataLabel = WIDGET_LABEL(REDUCE_BASE,$
                                  XOFFSET = FilteringDataLabelSize[0],$
                                  YOFFSET = FilteringDataLabelSize[1],$
                                  VALUE   = FilteringDataLabelTitle)

FilteringDataCWBgroup = CW_BGROUP(REDUCE_BASE,$
                                  CWBGROUP_list,$
                                  XOFFSET   = FilteringDataCWBgroupSize[0],$
                                  YOFFSET   = FilteringDataCWBgroupSize[1],$
                                  ROW       = 1,$
                                  SET_VALUE = 0,$
                                  UNAME     = 'filtering_data_cwbgroup',$
                                  /EXCLUSIVE)

;store deltaT/T
DeltaToverTLabel = WIDGET_LABEL(REDUCE_BASE,$
                                XOFFSET = DeltaToverTLabelSize[0],$
                                YOFFSET = DeltaToverTLabelSize[1],$
                                VALUE   = DeltaToverTLabelTitle)

DeltaToverTCWBgroup = CW_BGROUP(REDUCE_BASE,$
                                CWBGROUP_list,$
                                XOFFSET   = DeltaToverTCWBgroupSize[0],$
                                YOFFSET   = DeltaToverTCWBgroupSize[1],$
                                ROW       = 1,$
                                SET_VALUE = 1,$
                                UNAME     = 'delta_t_over_t_cwbgroup',$
                                /EXCLUSIVE)

;overwrite instrument geometry
OverwriteInstrumentGeometryLabel = $
  WIDGET_LABEL(REDUCE_BASE,$
               XOFFSET = OverwriteInstrumentGeometryLabelSize[0],$
               YOFFSET = OverwriteInstrumentGeometryLabelSize[1],$
               VALUE   = OverwriteInstrumentGeometryLabelTitle)

OverwriteInstrumentGeometryCWBgroup = $
  CW_BGROUP(REDUCE_BASE,$
            cwbgroup2_list,$
            XOFFSET   = OverwriteInstrumentGeometryCWBgroupSize[0],$
            YOFFSET   = OverwriteInstrumentGeometryCWBgroupSize[1],$
            ROW       = 1,$
            SET_VALUE = 1,$
            UNAME     = 'overwrite_data_instrument_geometry_cwbgroup',$
            /EXCLUSIVE)

OverwriteInstrumentGeometryBase = $
  WIDGET_BASE(REDUCE_BASE,$
              XOFFSET   = OverwriteInstrumentGeometryBaseSize[0],$
              YOFFSET   = OverwriteInstrumentGeometryBaseSize[1],$
              SCR_XSIZE = OverwriteInstrumentGeometryBaseSize[2],$
              SCR_YSIZE = OverwriteInstrumentGeometryBaseSize[3],$
              MAP       = 0,$
              UNAME     = 'overwrite_data_instrument_geometry_base')

OverwriteInsrumentGeometryButton = $
  WIDGET_BUTTON(OverwriteInstrumentGeometryBase,$
                UNAME     = 'overwrite_data_intrument_geometry_button',$
                XOFFSET   = OverwriteInstrumentGeometryButtonSize[0],$
                YOFFSET   = OverwriteInstrumentGeometryButtonSize[1],$
                SCR_XSIZE = OverwriteInstrumentGeometryButtonSize[2],$
                SCR_YSIZE = OverwriteInstrumentGeometryButtonSize[3],$
                VALUE     = OverwriteInstrumentGeometryButtonTitle)

;overwrite norm instrument geometry
label = WIDGET_LABEL(REDUCE_BASE,$
                     XOFFSET = NormIGlabel.size[0],$
                     YOFFSET = NormIGlabel.size[1],$
                     VALUE   = NormIGlabel.title)

group = CW_BGROUP(REDUCE_BASE,$
                  cwbgroup2_list,$
                  XOFFSET   = NormIGgroup.size[0],$
                  YOFFSET   = NormIGgroup.size[1],$
                  ROW       = 1,$
                  /EXCLUSIVE,$
                  SET_VALUE = 1,$
                  UNAME     = NormIGgroup.uname)

 base = WIDGET_BASE(REDUCE_BASE,$
                    XOFFSET   = NormIGbase.size[0],$
                    YOFFSET   = NormIGbase.size[1],$
                    SCR_XSIZE = NormIGbase.size[2],$
                    SCR_YSIZE = NormIGbase.size[3],$
                    MAP       = 0,$
                    UNAME     = NormIGbase.uname)

 button = WIDGET_BUTTON(base,$
                        UNAME     = NormIGbutton.uname,$
                        XOFFSET   = NormIGbutton.size[0],$
                        YOFFSET   = NormIGbutton.size[1],$
                        SCR_XSIZE = NormIGbutton.size[2],$
                        SCR_YSIZE = NormIGbutton.size[3],$
                        VALUE     = NormIGbutton.title)


;Start data reduction button
StartDataReductionButton = $
  WIDGET_BUTTON(REDUCE_BASE,$
                UNAME='start_data_reduction_button',$
                XOFFSET   = StartDRButtonSize[0],$
                YOFFSET   = StartDRButtonSize[1],$
                SCR_XSIZE = StartDRButtonSize[2],$
                SCR_YSIZE = StartDRButtonSize[3],$
                VALUE     = StartDRButtonTitle,$
                SENSITIVE = 0)

;command line preview
; cmdLinePreviewLabel = WIDGET_LABEL(REDUCE_BASE,$
;                                    XOFFSET = cmdLinePreviewLabelSize[0],$
;                                    YOFFSET = cmdLinePreviewLabelSize[1],$
;                                    VALUE   = cmdLinePreviewLabelTitle)

cmdLinePreviewText = WIDGET_TEXT(REDUCE_BASE,$
                                 UNAME     = 'reduce_cmd_line_preview',$
                                 XOFFSET   = cmdLinePreviewTextSize[0],$
                                 YOFFSET   = cmdLinePreviewTextSize[1],$
                                 SCR_XSIZE = cmdLinePreviewTextSize[2],$
                                 SCR_YSIZE = cmdLinePreviewTextSize[3],$
                                 VALUE     = '',$
                                 /SCROLL,$
                                 /WRAP)
                               
END
