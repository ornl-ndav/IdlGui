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

PRO miniMakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth, global

  ;Dimension
  cwbgroup_list  = ['Y','N']
  cwbgroup2_list = ['Y','N']
  
  ;filtering data
  FDLsize        = [15,455]
  FDLtitle       = 'Filtering Data:'
  x_group_off  = 15
  FDCWBgroupSize = [220+x_group_off,FDLsize[1]-5]
  
  d_vertical_L_L = 30
  ;Store dt/t
  DToTLsize        = [FDLsize[0],$
    FDLsize[1]+d_vertical_L_L]
  DToTLtitle       = 'dt/t:'
  DToTCWBgroupSize = [FDCWBgroupSize[0],$
    DToTLsize[1]-5]
    
  ;OUTPUT PATH AND FILE NAME
  XYoff    = [130,10]
  OPFlabel = { size  : [FDCWBgroupSize[0]+XYoff[0],$ $
    FDCWBgroupSize[1]+XYoff[1]],$
    value : 'Output path:'}
  XYoff    = [80,-5]
  OPbutton = { size  : [OPFlabel.size[0]+XYoff[0],$
    OPFlabel.size[1]+XYoff[1],$
    120,30],$
    value : '~/results/',$
    uname : 'of_button'}
  XYoff    = [0,30]
  OFlabel  = { size  : [OPFlabel.size[0]+XYoff[0],$
    OPFlabel.size[1]+XYoff[1]],$
    value : 'File Name:'}
  XYoff    = [80,-5]
  OFtext   = { size  : [OFlabel.size[0]+XYoff[0],$
    OFlabel.size[1]+XYoff[1],$
    120,30],$
    value : '',$
    uname : 'of_text'}
    
  ;overwrite data instrument geometry
  yoff = 0
  OIGLsize        = [FDLsize[0],$
    DToTLsize[1]+d_vertical_L_L+yoff]
  OIGLtitle       = 'Overwrite Data Instrument Geometry:'
  xoff = 20
  OIGCWBgroupSize = [FDCWBgroupSize[0],$
    OIGLsize[1]-5]
  d_group_base = 130
  OIGBsize     = [OIGCWBgroupSize[0]+$
    d_group_base-25,$
    OIGCWBgroupSize[1]+5,$
    230,30]
    
  OIGButtonsize  = [0,0,230,25]
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
    320, $
    30]
  StartDRButtonTitle = 'S T A R T    D A T A    R E D U C T I O N'
  
  ;command line preview/generator
  d_vertical_L_L_2 = d_vertical_L_L + 8
  cmdLinePreviewLabelSize = [5,StartDRButtonSize[1]+d_vertical_L_L_2]
  cmdLinePreviewLabelTitle = 'Preview of the Command Line'
  d_vertical_L_L_3 = -5
  cmdLinePreviewTextSize = [5, $
    cmdLinePreviewLabelSize[1]+d_vertical_L_L_3,$
    885, $
    45]
    
  ;OUTPUT COMMAND LINE INTO A FILE
  BDbutton = { size  : [cmdLinePreviewTextSize[0],$
    cmdLinePreviewTextSize[1]+cmdLinePreviewTextSize[3],$
    75,30],$
    uname : 'cl_directory_button',$
    value : 'CL PATH...'}
  XYoff   = [BDbutton.size[2],10]
  BDorLabel = { size   : [BDbutton.size[0]+XYoff[0],$
    BDbutton.size[1]+XYoff[1]],$
    value  : 'OR'}
  XYoff   = [18,1]
  BDtext = { size  : [BDorLabel.size[0]+XYoff[0],$
    BDbutton.size[1]+XYoff[1],$
    200,$
    BDbutton.size[3]],$
    uname : 'cl_directory_text',$
    value : ''}
  XYoff   = [BDtext.size[2],10]
  BDandLabel = { size  : [BDtext.size[0]+XYoff[0],$
    BDtext.size[1]+XYoff[1]],$
    value : 'AND'}
  XYoff   = [22,0]
  BFbutton = { size  : [BDandLabel.size[0]+XYoff[0],$
    BDbutton.size[1],$
    75, $
    BDbutton.size[3]],$
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
    155, $
    BDbutton.size[3]],$
    uname     : 'output_cl_button',$
    value     : 'CREATE CL FILE',$
    sensitive : 1}
    
  ;##############################################################################
  ;############################## Create GUI ####################################
  ;##############################################################################
    
  ;beam divergence correction
  beamdiv = widget_base(reduce_base,$
    xoffset = 180,$
    yoffset = 450,$
    frame = 1,$
    /column)
  label = widget_label(beamdiv,$
    value = 'Beam divergence correction')
  row2 = widget_base(beamdiv,$
    /row)
  part1 = widget_base(row2,$
    /row,$
    /exclusive)
  yes = widget_button(part1,$
    value = 'Yes',$
    uname = 'beamdiv_corr_yes')
  no = widget_button(part1,$
    value = 'No',$
    uname = 'beamdiv_corr_no')
  widget_control, yes, /set_button
  
  if ((*global).is_ucams_super_user) then begin
    config = widget_button(row2,$
      value = 'Config...',$
      sensitive = 1,$
      uname = 'beamdiv_settings')
  endif
  
  ;filtering data
  FilteringDataLabel = WIDGET_LABEL(REDUCE_BASE,$
    XOFFSET = FDLsize[0],$
    YOFFSET = FDLsize[1],$
    VALUE   = FDLtitle,$
    UNAME   = 'reduce_label1')
    
  FilteringDataCWBgroup = CW_BGROUP(REDUCE_BASE,$
    cwbgroup2_list,$
    XOFFSET   = FDCWBgroupSize[0]-125,$
    YOFFSET   = FDCWBgroupSize[1],$
    ROW       = 1,$
    SET_VALUE = 0,$
    UNAME     = 'filtering_data_cwbgroup',$
    /EXCLUSIVE)
    
  ;store deltaT/T
  DeltaToverTLabel = WIDGET_LABEL(REDUCE_BASE,$
    XOFFSET = DToTLsize[0],$
    YOFFSET = DToTLsize[1],$
    VALUE   = DToTLtitle,$
    UNAME   = 'reduce_label2')
    
  DeltaToverTCWBgroup = CW_BGROUP(REDUCE_BASE,$
    cwbgroup2_list,$
    XOFFSET   = DToTCWBgroupSize[0]-125,$
    YOFFSET   = DToTCWBgroupSize[1],$
    ROW       = 1,$
    SET_VALUE = 1,$
    UNAME     = 'delta_t_over_t_cwbgroup',$
    /EXCLUSIVE)
    
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
    /EDITABLE,$
    /ALIGN_LEFT)
    
  ;overwrite data instrument geometry
  OverwriteInstrumentGeometryLabel = $
    WIDGET_LABEL(REDUCE_BASE,$
    XOFFSET = OIGLsize[0],$
    YOFFSET = OIGLsize[1],$
    VALUE   = OIGLtitle,$
    UNAME   = 'reduce_label3')
    
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
    VALUE   = NormIGlabel.title,$
    UNAME   = 'reduce_label4')
    
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
    VALUE   = BDorLabel.value,$
    UNAME   = 'reduce_label5')
    
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
