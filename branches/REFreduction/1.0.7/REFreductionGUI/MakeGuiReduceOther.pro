PRO MakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth

;Dimension
cwbgroup_list  = [' Yes    ',' No    ']
cwbgroup2_list = [' Yes '   ,' No '   ]

;filtering data
yoff            = -15
FDLsize         = [20, 550+yoff]
FDLtitle        = 'Filtering Data:'
FDLcwbGroupSize = [220, FDLsize[1]-5]

d_vertical_L_L = 35
yoff = -5
;Store dt/t
DTTsize         = [FDLsize[0],$
                   FDLsize[1]+d_vertical_L_L+yoff]
DTTtitle        = 'dt/t:'
DTTcwbGroupSize = [FDLcwbGroupSize[0],$
                   DTTsize[1]-5]

;overwrite data instrument geometry
OIGlabelSize    = [FDLsize[0],DTTsize[1]+d_vertical_L_L+yoff]
OIGlabelTitle   = 'Overwrite Data Instrument Geometry:'
xoff            = 20
OIGcwbGroupSize = [FDLcwbGroupSize[0]+xoff+50,OIGlabelSize[1]-5]
d_group_base    = 125
OIGbaseSize     = [OIGcwbGroupSize[0]+$
                   d_group_base-15,$
                   OIGcwbGroupSize[1]-5,$
                   320, $
                   40]

OIGbuttonSize  = [5,5,310,30]
OIGbuttonTitle = 'Select a Data Instrument Geometry File'

;overwrite norm instrument geometry
yoff += 3
NormIGlabel = { size  : [FDLsize[0],$
                         OIGlabelSize[1]+ $
                         d_vertical_L_L+yoff],$
                title : 'Overwrite Normalization Instrument Geometry:'}
NormIGgroup = { size  : [NormIGlabel.size[0]+270,$
                         NormIGLabel.size[1]-5],$
                uname : 'overwrite_norm_instrument_geometry_cwbgroup'}
NormIGbase = {  size  : [NormIGgroup.size[0]+d_group_base-15,$
                         NormIGgroup.size[1]-5,320,40],$
                uname : 'overwrite_norm_instrument_geometry_base'}
NormIGbutton = {size  : [5,5,310,30],$
                title : 'Select a Normalization Instrument Geometry File',$
                uname : 'overwrite_norm_instrument_geometry_button'}

;START data reduction button
StartDRButtonSize = [5, $
                     OIGlabelSize[1]+d_vertical_L_L+30,$
                     1180, $
                     40]
StartDRButtonTitle =  '>          >         >        >       >      >     >    > '
StartDRButtonTitle += '  >  > >> S T A R T    D A T A    R E D U C T I O N << < '
StartDRButtonTitle += ' <   <    <     <      <       <        <         <      '
StartDRButtonTitle += '    < '

;command line preview/generator
d_vertical_L_L_2       = d_vertical_L_L + 20
CLpreviewLabelSize     = [5, $
                          StartDRButtonSize[1]+d_vertical_L_L_2]
CLpreviewLabelTitle    = 'Preview of the Command Line'
d_vertical_L_L_3       = 20
cmdLinePreviewTextSize = [5, $
                          CLpreviewLabelSize[1]+d_vertical_L_L_3,$
                          1180, $
                          100]

;************************************************************************************
;BUILD GUI

;filtering data
FilteringDataLabel = WIDGET_LABEL(REDUCE_BASE,$
                                  XOFFSET = FDLsize[0],$
                                  YOFFSET = FDLsize[1],$
                                  VALUE   = FDLtitle)

FilteringDataCWBgroup = CW_BGROUP(REDUCE_BASE,$
                                  cwbgroup_list,$
                                  XOFFSET   = FDLcwbGroupSize[0],$
                                  YOFFSET   = FDLcwbGroupSize[1],$
                                  ROW       = 1,$
                                  SET_VALUE = 0,$
                                  UNAME     = 'filtering_data_cwbgroup',$
                                  /EXCLUSIVE)

;store deltaT/T
DeltaToverTLabel = WIDGET_LABEL(REDUCE_BASE,$
                                XOFFSET = DTTsize[0],$
                                YOFFSET = DTTsize[1],$
                                VALUE   = DTTtitle)

DeltaToverTCWBgroup = CW_BGROUP(REDUCE_BASE,$
                                cwbgroup_list,$
                                XOFFSET   = DTTcwbGroupSize[0],$
                                YOFFSET   = DTTcwbGroupSize[1],$
                                ROW       = 1,$
                                SET_VALUE = 1,$
                                UNAME     = 'delta_t_over_t_cwbgroup',$
                                /EXCLUSIVE)

;overwrite instrument geometry
OverwriteInstrumentGeometryLabel = $
  WIDGET_LABEL(REDUCE_BASE,$
               XOFFSET = OIGlabelSize[0],$
               YOFFSET = OIGlabelSize[1],$
               VALUE   = OIGlabelTitle)

OverwriteInstrumentGeometryCWBgroup = $
  CW_BGROUP(REDUCE_BASE,$
            cwbgroup2_list,$
            XOFFSET   = OIGcwbGroupSize[0],$
            YOFFSET   = OIGcwbGroupSize[1],$
            ROW       = 1,$
            SET_VALUE = 1,$
            UNAME     = 'overwrite_data_instrument_geometry_cwbgroup',$
            /EXCLUSIVE)

OverwriteInstrumentGeometryBase = $
  WIDGET_BASE(REDUCE_BASE,$
              XOFFSET   = OIGbaseSize[0],$
              YOFFSET   = OIGbaseSize[1],$
              SCR_XSIZE = OIGbaseSize[2],$
              SCR_YSIZE = OIGbaseSize[3],$
              MAP       = 0,$
              UNAME     = 'overwrite_data_instrument_geometry_base')

OverwriteInsrumentGeometryButton = $
  WIDGET_BUTTON(OverwriteInstrumentGeometryBase,$
                UNAME     = 'overwrite_data_intrument_geometry_button',$
                XOFFSET   = OIGbuttonSize[0],$
                YOFFSET   = OIGbuttonSize[1],$
                SCR_XSIZE = OIGbuttonSize[2],$
                SCR_YSIZE = OIGbuttonSize[3],$
                VALUE     = OIGbuttonTitle)

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
                  SET_VALUE = 1,$
                  UNAME     = NormIGgroup.uname,$
                  /EXCLUSIVE)

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
StartDataReductionButton = WIDGET_BUTTON(REDUCE_BASE,$
                                         UNAME     = 'start_data_reduction_button',$
                                         XOFFSET   = StartDRButtonSize[0],$
                                         YOFFSET   = StartDRButtonSize[1],$
                                         SCR_XSIZE = StartDRButtonSize[2],$
                                         SCR_YSIZE = StartDRButtonSize[3],$
                                         VALUE     = StartDRButtonTitle,$
                                         SENSITIVE = 0)

;command line preview
cmdLinePreviewLabel = WIDGET_LABEL(REDUCE_BASE,$
                                   XOFFSET = CLpreviewLabelSize[0],$
                                   YOFFSET = CLpreviewLabelSize[1],$
                                   VALUE   = CLpreviewLabelTitle)

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
