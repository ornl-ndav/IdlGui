PRO miniMakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth

;Dimension
cwbgroup_list  = [' Yes    ',' No    ']
cwbgroup2_list = [' Yes '   ,' No'    ]

;filtering data
FDLsize        = [15,455]
FDLtitle       = 'Filtering Data:'
FDCWBgroupSize = [220,FDLsize[1]-5]

d_vertical_L_L = 30
;Store dt/t
DToTLsize        = [FDLsize[0],$
                    FDLsize[1]+d_vertical_L_L]
DToTLtitle       = 'dt/t:'
DToTCWBgroupSize = [FDCWBgroupSize[0],$
                    DToTLsize[1]-5]

;overwrite data instrument geometry
yoff = 0
OIGLsize        = [FDLsize[0],$
                   DToTLsize[1]+d_vertical_L_L+yoff]
OIGLtitle       = 'Overwrite Data Instrument Geometry:'
xoff = 20
OIGCWBgroupSize = [FDCWBgroupSize[0]+15,$
                   OIGLsize[1]-5]
d_group_base = 130
OIGBsize     = [OIGCWBgroupSize[0]+$
                d_group_base-25,$
                OIGCWBgroupSize[1]-5,$
                230,30]

OIGButtonsize  = [0,5,230,25]
OIGButtontitle = 'Select a Data Instr. Geometry File'

;overwrite norm instrument geometry
yoff += 3
NormIGlabel = { size : [FDLsize[0],$
                        OIGLsize[1]+d_vertical_L_L+yoff],$
                title : 'Overwrite Norm. Instrument Geometry:'}
NormIGgroup = { size : [NormIGlabel.size[0]+220,$
                        NormIGLabel.size[1]-5],$
                uname : 'overwrite_norm_instrument_geometry_cwbgroup'}
NormIGbase = { size : [NormIGgroup.size[0]+d_group_base-25,$
                       NormIGgroup.size[1]-5,230,30],$
               uname : 'overwrite_norm_instrument_geometry_base'}
NormIGbutton = {size : [0,5,230,25],$
                title : 'Select a Norm. Instr. Geometry File',$
                uname : 'overwrite_norm_instrument_geometry_button'}

;START data reduction button
XYoff= [570,d_vertical_L_L-5]
StartDRButtonSize = [5+XYoff[0],$
                     OIGLsize[1]+XYoff[1],$
                     300, $
                     30]
StartDRButtonTitle = 'S T A R T    D A T A    R E D U C T I O N'

;command line preview/generator
d_vertical_L_L_2 = d_vertical_L_L + 8
cmdLinePreviewLabelSize = [5,StartDRButtonSize[1]+d_vertical_L_L_2]
cmdLinePreviewLabelTitle = 'Preview of the Command Line'
d_vertical_L_L_3 = -5
cmdLinePreviewTextSize = [5, $
                          cmdLinePreviewLabelSize[1]+d_vertical_L_L_3,$
                          865, $
                          55]
           
;OUTPUT COMMAND LINE INTO A FILE
BDbutton = { size  : [cmdLinePreviewTextSize[0],$
                      cmdLinePreviewTextSize[1]+cmdLinePreviewTextSize[3],$
                      75,35],$
             uname : 'cl_directory_button',$
             value : 'CL PATH...'}
XYoff   = [BDbutton.size[2],10]
BDorLabel = { size   : [BDbutton.size[0]+XYoff[0],$
                        BDbutton.size[1]+XYoff[1]],$
              value  : 'OR'}
XYoff   = [18,1]
BDtext = { size  : [BDorLabel.size[0]+XYoff[0],$
                    BDbutton.size[1]+XYoff[1],$
                    200,35],$
           uname : 'cl_directory_text',$
           value : ''}
XYoff   = [BDtext.size[2],10]
BDandLabel = { size  : [BDtext.size[0]+XYoff[0],$
                        BDtext.size[1]+XYoff[1]],$
               value : 'AND'}
XYoff   = [22,0]
BFbutton = { size  : [BDandLabel.size[0]+XYoff[0],$
                      BDbutton.size[1],$
                      75,35],$
             uname : 'cl_file_button',$
             value : 'CL FILE...'}
XYoff   = [BFbutton.size[2],10]
BForLabel = { size   : [BFbutton.size[0]+XYoff[0],$
                        BFbutton.size[1]+XYoff[1]],$
              value  : 'OR'}
XYoff = [18,1]
BFtext = { size  : [BForLabel.size[0]+XYoff[0],$
                    BDtext.size[1],$
                    300,$
                    BDtext.size[3]],$
           uname : 'cl_file_text',$
           value : ''}
XYoff   = [BFtext.size[2],10]
BDBFLabel = { size   : [BFtext.size[0]+XYoff[0],$
                        BFtext.size[1]+XYoff[1]],$
              value  : '==>'}
XYoff   = [22,0]
OGbutton = { size      : [BDBFLabel.size[0]+XYoff[0],$
                          BDbutton.size[1],$
                          135,35],$
             uname     : 'output_cl_button',$
             value     : 'CREATE CL FILE',$
             sensitive : 1}
    
;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

;filtering data
FilteringDataLabel = WIDGET_LABEL(REDUCE_BASE,$
                                  XOFFSET = FDLsize[0],$
                                  YOFFSET = FDLsize[1],$
                                  VALUE   = FDLtitle)

FilteringDataCWBgroup = CW_BGROUP(REDUCE_BASE,$
                                  CWBGROUP_list,$
                                  XOFFSET   = FDCWBgroupSize[0],$
                                  YOFFSET   = FDCWBgroupSize[1],$
                                  ROW       = 1,$
                                  SET_VALUE = 0,$
                                  UNAME     = 'filtering_data_cwbgroup',$
                                  /EXCLUSIVE)

;store deltaT/T
DeltaToverTLabel = WIDGET_LABEL(REDUCE_BASE,$
                                XOFFSET = DToTLsize[0],$
                                YOFFSET = DToTLsize[1],$
                                VALUE   = DToTLtitle)

DeltaToverTCWBgroup = CW_BGROUP(REDUCE_BASE,$
                                CWBGROUP_list,$
                                XOFFSET   = DToTCWBgroupSize[0],$
                                YOFFSET   = DToTCWBgroupSize[1],$
                                ROW       = 1,$
                                SET_VALUE = 1,$
                                UNAME     = 'delta_t_over_t_cwbgroup',$
                                /EXCLUSIVE)

;overwrite data instrument geometry
OverwriteInstrumentGeometryLabel = $
  WIDGET_LABEL(REDUCE_BASE,$
               XOFFSET = OIGLsize[0],$
               YOFFSET = OIGLsize[1],$
               VALUE   = OIGLtitle)

OverwriteInstrumentGeometryCWBgroup = $
  CW_BGROUP(REDUCE_BASE,$
            cwbgroup2_list,$
            XOFFSET   = OIGCWBgroupSize[0],$
            YOFFSET   = OIGCWBgroupSize[1],$
            ROW       = 1,$
            SET_VALUE = 1,$
            UNAME     = 'overwrite_data_instrument_geometry_cwbgroup',$
            /EXCLUSIVE)

OverwriteInstrumentGeometryBase = $
  WIDGET_BASE(REDUCE_BASE,$
              XOFFSET   = OIGBsize[0],$
              YOFFSET   = OIGBsize[1],$
              SCR_XSIZE = OIGBsize[2],$
              SCR_YSIZE = OIGBsize[3],$
              MAP       = 0,$
              UNAME     = 'overwrite_data_instrument_geometry_base')

OverwriteInsrumentGeometryButton = $
  WIDGET_BUTTON(OverwriteInstrumentGeometryBase,$
                UNAME     = 'overwrite_data_intrument_geometry_button',$
                XOFFSET   = OIGButtonsize[0],$
                YOFFSET   = OIGButtonsize[1],$
                SCR_XSIZE = OIGButtonsize[2],$
                SCR_YSIZE = OIGButtonsize[3],$
                VALUE     = OIGButtontitle)

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

;Command Line Preview
cmdLinePreviewText = WIDGET_TEXT(REDUCE_BASE,$
                                 UNAME     = 'reduce_cmd_line_preview',$
                                 XOFFSET   = cmdLinePreviewTextSize[0],$
                                 YOFFSET   = cmdLinePreviewTextSize[1],$
                                 SCR_XSIZE = cmdLinePreviewTextSize[2],$
                                 SCR_YSIZE = cmdLinePreviewTextSize[3],$
                                 VALUE     = '',$
                                 /SCROLL,$
                                 /WRAP)
;output command line into a file
button1 = WIDGET_BUTTON(REDUCE_BASE,$
                        UNAME     = BDbutton.uname,$
                        XOFFSET   = BDbutton.size[0],$
                        YOFFSET   = BDbutton.size[1],$
                        SCR_XSIZE = BDbutton.size[2],$
                        SCR_YSIZE = BDbutton.size[3],$
                        VALUE     = BDbutton.value)

label1 = WIDGET_LABEL(REDUCE_BASE,$
                      XOFFSET = BDorLabel.size[0],$
                      YOFFSET = BDorLabel.size[1],$
                      VALUE   = BDorLabel.value)
                              
text1 = WIDGET_TEXT(REDUCE_BASE,$
                    XOFFSET   = BDtext.size[0],$
                    YOFFSET   = BDtext.size[1],$
                    SCR_XSIZE = BDtext.size[2],$
                    SCR_YSIZE = BDtext.size[3],$
                    UNAME     = BDtext.uname,$
                    VALUE     = BDtext.value,$
                    /ALL_EVENTS,$
                    /EDITABLE)

label2 = WIDGET_LABEL(REDUCE_BASE,$
                      XOFFSET = BDandLabel.size[0],$
                      YOFFSET = BDandLabel.size[1],$
                      VALUE   = BDandLabel.value)
                              
button2 = WIDGET_BUTTON(REDUCE_BASE,$
                        UNAME     = BFbutton.uname,$
                        XOFFSET   = BFbutton.size[0],$
                        YOFFSET   = BFbutton.size[1],$
                        SCR_XSIZE = BFbutton.size[2],$
                        SCR_YSIZE = BFbutton.size[3],$
                        VALUE     = BFbutton.value)

label3 = WIDGET_LABEL(REDUCE_BASE,$
                      XOFFSET = BForLabel.size[0],$
                      YOFFSET = BForLabel.size[1],$
                      VALUE   = BForLabel.value)
                              
text2 = WIDGET_TEXT(REDUCE_BASE,$
                    XOFFSET   = BFtext.size[0],$
                    YOFFSET   = BFtext.size[1],$
                    SCR_XSIZE = BFtext.size[2],$
                    SCR_YSIZE = BFtext.size[3],$
                    UNAME     = BFtext.uname,$
                    VALUE     = BFtext.value,$
                    /ALL_EVENTS,$
                    /EDITABLE)

label4 = WIDGET_LABEL(REDUCE_BASE,$
                      XOFFSET = BDBFLabel.size[0],$
                      YOFFSET = BDBFLabel.size[1],$
                      VALUE   = BDBFLabel.value)
                              
button3 = WIDGET_BUTTON(REDUCE_BASE,$
                        UNAME     = OGbutton.uname,$
                        XOFFSET   = OGbutton.size[0],$
                        YOFFSET   = OGbutton.size[1],$
                        SCR_XSIZE = OGbutton.size[2],$
                        SCR_YSIZE = OGbutton.size[3],$
                        VALUE     = OGbutton.value,$
                        SENSITIVE = OGbutton.sensitive)


                               
END
