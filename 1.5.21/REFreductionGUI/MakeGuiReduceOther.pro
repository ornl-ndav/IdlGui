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

;output path and file name
XYoff    = [15,30]
OPFlabel = { size  : [5+XYoff[0],$ $
                      OIGlabelSize[1]+d_vertical_L_L+XYoff[1]],$
             value : 'Output'}
XYoff    = [60,-5]
OPbutton = { size  : [XYoff[0],$
                      OPFlabel.size[1]+XYoff[1],$
                      300,35],$
             value : '~/results/',$
             uname : 'of_button'}
XYoff    = [10,0]
OFlabel  = { size  : [OPbutton.size[0]+OPbutton.size[2]+XYoff[0],$
                      OPFlabel.size[1]],$
             value : 'File Name:'}
XYoff    = [70,-5]
OFtext   = { size  : [OFlabel.size[0]+XYoff[0],$
                      OFlabel.size[1]+XYoff[1],$
                      270,35],$
             value : '',$
             uname : 'of_text'}

;START data reduction button
XYoff = [720,0]
StartDRButtonSize = [XYoff[0], $
                     OIGlabelSize[1]+d_vertical_L_L+30,$
                     462, $
                     40]
StartDRButtonTitle = '  >  > >> S T A R T    D A T A   ' + $
  ' R E D U C T I O N << <  <'

;command line preview/generator
d_vertical_L_L_2       = d_vertical_L_L + 10
CLpreviewLabelSize     = [5, $
                          StartDRButtonSize[1]+d_vertical_L_L_2]
CLpreviewLabelTitle    = 'Preview of the Command Line (CL)'
d_vertical_L_L_3       = 15
cmdLinePreviewTextSize = [5, $
                          CLpreviewLabelSize[1]+d_vertical_L_L_3,$
                          1180, $
                          100]
cmdLinePreviewTextUname = 'reduce_cmd_line_preview'

;OUTPUT COMMAND LINE INTO A FILE
BDbutton = { size  : [cmdLinePreviewTextSize[0],$
                      cmdLinePreviewTextSize[1]+cmdLinePreviewTextSize[3],$
                      120,35],$
             uname : 'cl_directory_button',$
             value : 'CL DIRECTORY ... '}
XYoff   = [BDbutton.size[2],10]
BDorLabel = { size   : [BDbutton.size[0]+XYoff[0],$
                        BDbutton.size[1]+XYoff[1]],$
              value  : 'OR'}
XYoff   = [18,1]
BDtext = { size  : [BDorLabel.size[0]+XYoff[0],$
                    BDbutton.size[1]+XYoff[1],$
                    350,35],$
           uname : 'cl_directory_text',$
           value : ''}
XYoff   = [BDtext.size[2],10]
BDandLabel = { size  : [BDtext.size[0]+XYoff[0],$
                        BDtext.size[1]+XYoff[1]],$
               value : 'AND'}
XYoff   = [22,0]
BFbutton = { size  : [BDandLabel.size[0]+XYoff[0],$
                      BDbutton.size[1],$
                      100,35],$
             uname : 'cl_file_button',$
             value : 'CL FILE ... '}
XYoff   = [BFbutton.size[2],10]
BForLabel = { size   : [BFbutton.size[0]+XYoff[0],$
                        BFbutton.size[1]+XYoff[1]],$
              value  : 'OR'}
XYoff = [18,1]
BFtext = { size  : [BForLabel.size[0]+XYoff[0],$
                    BDtext.size[1],$
                    BDtext.size[2],$
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
                          181,35],$
             uname     : 'output_cl_button',$
             value     : 'CREATE COMMAND LINE FILE',$
             sensitive : 1}

;******************************************************************************
;BUILD GUI

;filtering data
FilteringDataLabel = WIDGET_LABEL(REDUCE_BASE,$
                                  XOFFSET = FDLsize[0],$
                                  YOFFSET = FDLsize[1],$
                                  VALUE   = FDLtitle,$
                                  UNAME = 'reduce_label1')

FilteringDataCWBgroup = CW_BGROUP(REDUCE_BASE,$
                                  cwbgroup_list,$
                                  XOFFSET   = FDLcwbGroupSize[0],$
                                  YOFFSET   = FDLcwbGroupSize[1],$
                                  ROW       = 1,$
                                  SET_VALUE = 0,$
                                  UNAME     = 'filtering_data_cwbgroup',$
                                  /EXCLUSIVE)

;beamdivergence correction
beamdiv = widget_base(reduce_base,$
  xoffset = 415,$
  yoffset = 540,$
  /column,$
  frame=1)
  
  row1 = widget_base(beamdiv,$
  /row)
  label = widget_label(row1,$
  value = 'Beam divergence:')
  row1b = widget_base(row1,$
  /exclusive,$
  /row)
  yes = widget_button(row1b,$
  value = 'Yes',$
  uname = 'beamdiv_corr_yes')
  no = widget_button(row1b,$
  value = 'No',$
  uname = 'beamdiv_corr_no')
  widget_control, no, /set_button
  settings = widget_button(row1,$
  value = 'Settings...',$
  uname = 'beamdiv_settings',$
  sensitive = 0)
  
  
  
;store deltaT/T
DeltaToverTLabel = WIDGET_LABEL(REDUCE_BASE,$
                                XOFFSET = DTTsize[0],$
                                YOFFSET = DTTsize[1],$
                                VALUE   = DTTtitle,$
                                UNAME   = 'reduce_label2')

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
               VALUE   = OIGlabelTitle,$
               UNAME   = 'reduce_label3')

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
                     VALUE   = NormIGlabel.title,$
                     UNAME   = 'reduce_label4')

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

;output path and file name
label = WIDGET_LABEL(REDUCE_BASE,$
                     XOFFSET = OPFlabel.size[0],$
                     YOFFSET = OPFlabel.size[1],$
                     VALUE   = OPFlabel.value,$
                     UNAME   = 'reduce_label5')

button = WIDGET_BUTTON(REDUCE_BASE,$
                       XOFFSET   = OPbutton.size[0],$
                       YOFFSET   = OPbutton.size[1],$
                       SCR_XSIZE = OPbutton.size[2],$
                       SCR_YSIZE = OPbutton.size[3],$
                       VALUE     = OPbutton.value,$
                       UNAME     = OPbutton.uname)

label = WIDGET_LABEL(REDUCE_BASE,$
                     XOFFSET = OFlabel.size[0],$
                     YOFFSET = OFlabel.size[1],$
                     VALUE   = OFlabel.value,$
                     UNAME   = 'reduce_label6')

text = WIDGET_TEXT(REDUCE_BASE,$
                   XOFFSET = OFtext.size[0],$
                   YOFFSET = OFtext.size[1],$
                   SCR_XSIZE = OFtext.size[2],$
                   SCR_YSIZE = OFtext.size[3],$
                   VALUE     = OFtext.value,$
                   UNAME     = OFtext.uname,$
                   /ALL_EVENTS,$
                   /EDITABLE,$
                   /ALIGN_LEFT)

;Start data reduction button
StartDataReductionButton = WIDGET_BUTTON(REDUCE_BASE,$
                                         UNAME     = $
                                         'start_data_reduction_button',$
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
                                   VALUE   = CLpreviewLabelTitle,$
                                   UNAME   = 'reduce_label9')

cmdLinePreviewText = WIDGET_TEXT(REDUCE_BASE,$
                                 UNAME     = cmdLinePreviewTextUname,$
                                 XOFFSET   = cmdLinePreviewTextSize[0],$
                                 YOFFSET   = cmdLinePreviewTextSize[1],$
                                 SCR_XSIZE = cmdLinePreviewTextSize[2],$
                                 SCR_YSIZE = cmdLinePreviewTextSize[3],$
                                 VALUE     = '',$
                                 /SCROLL,$
;                                 /ALL_EVENTS,$
;                                 /CONTEXT_EVENTS,$
                                 /WRAP)

;contextBase = WIDGET_BASE(REDUCE_BASE,$
;                          /CONTEXT_MENU)
;button1 = WIDGET_BUTTON(contextBase, value='LOAD...')
;button2 = WIDGET_BUTTON(contextBase, value='CANCEL')

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
                      VALUE   = BDandLabel.value,$
                      UNAME   = 'reduce_label10')
                              
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
                      VALUE   = BForLabel.value,$
                      UNAME   = 'reduce_label11')
                              
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
                      VALUE   = BDBFLabel.value,$
                      UNAME   = 'reduce_label12')
                              
button3 = WIDGET_BUTTON(REDUCE_BASE,$
                        UNAME     = OGbutton.uname,$
                        XOFFSET   = OGbutton.size[0],$
                        YOFFSET   = OGbutton.size[1],$
                        SCR_XSIZE = OGbutton.size[2],$
                        SCR_YSIZE = OGbutton.size[3],$
                        VALUE     = OGbutton.value,$
                        SENSITIVE = OGbutton.sensitive)


                    

END
