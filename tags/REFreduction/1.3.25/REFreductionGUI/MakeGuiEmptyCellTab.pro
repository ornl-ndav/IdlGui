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

PRO MakeGuiEmptyCellTab, DataNormalizationTab,$
    DataNormalizationTabSize,$
    EmptyCellTitle,$
    D_DD_TabSize,$
    NexusListSizeGlobal,$
    NexusListLabelGlobal,$
    MAIN_BASE
    
  ;******************************************************************************
  ;Define structures ************************************************************
  ;******************************************************************************
    
  ;main base --------------------------------------------------------------------
  sBase = { size: [0,0,DataNormalizationTabSize[2:3]],$
    uname: 'empty_cell_base'}
    
  ;SF calculation base ----------------------------------------------------------
  sSFcalculationBase = { size: sBase.size,$
    uname: 'empty_cell_scaling_factor_calculation_base',$
    map: 0}
  ;data base --------------------------------------------------------------------
  XYoff = [0,15]
  yoff = 15
  sDataBase = { size: [XYoff[0],$
    XYoff[1],$
    575, $
    350+yoff],$
    frame: 1}
  ;data title
  XYoff = [20,-8]
  sDataTitle = { size: [sDataBase.size[0]+XYoff[0],$
    sDatabase.size[1]+XYoff[1]],$
    value: 'Data File: I vs TOF'}
    
  XYoff = [0,yoff]
  sDataDraw = { size: [XYoff[0],$
    XYoff[1],$
    sDataBase.size[2],$
    306],$
    uname: 'empty_cell_scaling_factor_base_data_draw'}
    
  XYoff = [0,20]
  sDataRowBase = { size: [sDataDraw.size[0]+XYoff[0],$
    sDataDraw.size[1]+$
    sDataDraw.size[3]+$
    XYoff[1],$
    sDataDraw.size[2],$
    40],$
    frame: 0 }
    
  sDataLabel = { x : { value: 'X (TOF in microS):',$
    uname: 'empty_cell_data_draw_x_value',$
    xsize:  50},$
    y : { value: 'Y (Pixel #):',$
    uname: 'empty_cell_data_draw_y_value',$
    xsize: 20},$
    counts : { value: 'Nbr Counts:',$
    uname: 'empty_cell_data_draw_counts_value',$
    xsize: 50}}
    
  ;end of data base/draw ........................................................
    
  ;Empty Cell base --------------------------------------------------------------
  XYoff = [0,25]
  sEmptyCellBase = { size: [sDataBase.size[0]+XYoff[0],$
    sDataBase.size[1]+$
    sDataBase.size[3]+XYoff[1],$
    sDataBase.size[2], $
    sDataBase.size[3]],$
    frame: 1}
  ;EmptyCell title
  XYoff = [20,-8]
  sEmptyCellTitle = { size: [sEmptyCellBase.size[0]+XYoff[0],$
    sEmptyCellbase.size[1]+XYoff[1]],$
    value: 'Empty Cell File: I vs TOF'}
    
  XYoff = [0,yoff]
  sEmptyCellDraw = { size: [XYoff[0],$
    XYoff[1],$
    sEmptyCellBase.size[2],$
    306],$
    uname: 'empty_cell_scaling_factor_base_empty_cell_draw'}
    
  XYoff = [0,20]
  sEmptyCellRowBase = { size: [sEmptyCellDraw.size[0]+XYoff[0],$
    sEmptyCellDraw.size[1]+$
    sEmptyCellDraw.size[3]+$
    XYoff[1],$
    sEmptyCellDraw.size[2],$
    40],$
    frame: 0 }
    
  sEmptyCellLabel = { x: { value: 'X (TOF in microS):',$
    uname: 'empty_cell_empty_cell_draw_x_value',$
    xsize:  50},$
    y: { value: 'Y (Pixel #):',$
    uname: 'empty_cell_empty_cell_draw_y_value',$
    xsize: 20},$
    counts: { value: 'Nbr Counts:',$
    uname: $
    'empty_cell_empty_cell_draw_counts_value',$
    xsize: 50}}
  ;end of empty cell base/draw ..................................................
    
  ;lin/log switch -------------------------------------------------------------
  XYoff = [0,20]
  sLinLogBase = { size: [sEmptyCellBase.size[0]+XYoff[0],$
    sEmptyCellBase.size[1]+$
    sEmptyCellBase.size[3]+$
    XYoff[1],$
    sEmptyCellBase.size[2],$
    40]}
    
  XYoff = [200]
  sLinLogGroup = { list: ['Lin','Log'],$
    size: [XYoff[0]],$
    label: 'Z axis: ',$
    uname: 'empty_cell_sf_z_axis'}
    
  ;SF equation label and text field .............................................
  XYoff = [630,80]
  sSFequationLabel = { size: [XYoff[0],$
    XYoff[1]],$
    value: 'Scaling Factor, C = '}
  XYoff = [760,-51]
  sSFequationDraw = { size: [XYoff[0],$
    sSFequationLabel.size[1]+XYoff[1],$
    415,$
    133],$
    uname: 'scaling_factor_equation_draw' }
    
  XYoff = [0,110]
  sSFequationLabel2 = { size: [sSFequationLabel.size[0]+XYoff[0],$
    sSFequationLabel.size[1]+XYoff[1]],$
    value: sSFequationLabel.value}
    
  XYoff = [125,-8] ;widget_text
  sSFequationTextField = { size: [sSFequationLabel2.size[0]+XYoff[0],$
    sSFequationLabel2.size[1]+XYoff[1],$
    10],$
    value: '1',$
    uname: 'scaling_factor_equation_value'}
    
  ;end of SF equation label and text field ......................................
    
  ;recap base -------------------------------------------------------------------
  XYoff = [20,-130]
  yoff = 15
  sRecapBase = { size: [sDataBase.size[0]+$
    sDataBase.size[2]+XYoff[0],$
    sDataBase.size[1]+$
    sDatabase.size[3]+XYoff[1],$
    sDatabase.size[2], $
    sDataBase.size[3]],$
    frame: 1}
  ;recap title
  XYoff = [20,-8]
  sRecapTitle = { size: [sRecapBase.size[0]+XYoff[0],$
    sRecapBase.size[1]+XYoff[1]],$
    value: 'Recap. Plot (Data - SF * EC)'}
    
  XYoff = [0,yoff]
  sRecapDraw = { size: [XYoff[0],$
    XYoff[1],$
    sRecapBase.size[2],$
    306],$
    uname: 'empty_cell_scaling_factor_base_recap_draw'}
    
  XYoff = [0,20]
  sRecapRowBase = { size: [sRecapDraw.size[0]+XYoff[0],$
    sRecapDraw.size[1]+$
    sRecapDraw.size[3]+$
    XYoff[1],$
    sRecapDraw.size[2],$
    40],$
    frame: 0 }
    
  sRecapLabel = { x : { value: 'X (TOF in microS):',$
    uname: 'empty_cell_recap_draw_x_value',$
    xsize:  50},$
    y : { value: 'Y (Pixel #):',$
    uname: 'empty_cell_recap_draw_y_value',$
    xsize: 20},$
    counts : { value: 'Nbr Counts:',$
    uname: 'empty_cell_recap_draw_counts_value',$
    xsize: 50}}
    
  ;end of recap base/draw .......................................................
    
  ;output recap data in rtof file base ..........................................
  XYoff = [0,55]
  sOutputBase = { size: [sRecapBase.size[0]+XYoff[0],$
    sRecapBase.size[1]+$
    sRecapBase.size[3]+XYoff[1],$
    sRecapbase.size[2],$
    95],$
    frame: 1,$
    uname: 'empty_cell_output_base',$
    sensitive:1}
    
  XYoff = [20,-8] ;title
  sOutputTitle = { size: [sOutputBase.size[0]+XYoff[0],$
    sOutputBase.size[1]+XYoff[1]],$
    value: 'Output Recap Data into ASCII file'}
    
  XYoff = [5,8]
  sOutputFolder = { size: [XYoff[0],$
    XYoff[1],$
    sOutputBase.size[2]-10],$
    value: '~/results/',$
    uname: 'empty_cell_output_folder_button'}
    
  XYoff = [0,25] ;name of file
  sOutputFile = { size: [sOutputFolder.size[0]+XYoff[0],$
    sOutputFolder.size[1]+XYoff[1],$
    465],$
    value: '',$
    uname: 'empty_cell_output_file_name_text_field'}
    
  XYoff = [0,0] ;button to create output file
  sOutputButton = { size: [sOutputFile.size[0]+$
    sOutputFile.size[2]+XYoff[0],$
    sOutputFile.size[1]+XYoff[1],$
    100,30],$
    value: 'CREATE FILE',$
    uname: 'empty_cell_create_output_file_button',$
    sensitive: 0}
    
  XYoff = [0,1] ;preview button
  sOutputPreview = { size: [sOutputFile.size[0]+XYoff[0],$
    sOutputButton.size[1]+$
    sOutputButton.size[3]+XYoff[1],$
    sOutputFolder.size[2]],$
    value: 'PREVIEW of ASCII FILE',$
    uname: 'empty_cell_preview_of_ascii_button',$
    sensitive: 0}
    
  ;end of output recap base/draw ................................................
    
  XYoff = [-615,-80]
  sSFcancel = { size: [sBase.size[2]+XYoff[0],$
    sBase.size[3]+XYoff[1],$
    300],$
    value: 'CANCEL',$
    uname: 'empty_cell_sf_base_cancel'}
    
  XYoff = [0,0]
  sSFok = { size: [sSFcancel.size[0]+$
    sSFcancel.size[2]+XYoff[0],$
    sSFcancel.size[1]+XYoff[1],$
    sSFcancel.size[2]],$
    value: 'OK',$
    uname: 'empty_cell_sf_base_ok'}
    
  ;nexus (browse, widget_text....etc) -------------------------------------------
  XYoff = [5,10] ;base
  sNexusBase = { size: [XYoff[0],$
    XYoff[1],$
    600,30],$
    frame: 0,$
    uname: 'empty_cell_nexus_base'}
    
  XYoff = [0,0] ;browse button
  sNexusBrowseButton = { size: [XYoff[0],$
    XYoff[1],$
    120],$
    uname: 'browse_empty_cell_nexus_button',$
    value: 'BROWSE NeXus ...'}
    
  ;empty cell run number
  sEmptyCellRunNumberLabel = { value: 'Empty Cell Run Number:'}
  
  ;Empty cell run number text field
  sEmptyCellTextfield = { value: '',$
    uname: 'empty_cell_nexus_run_number'}
    
  ;Archived/List All
  sEmptyCellArchivedListAll = { list: ['Archived','All NeXus'],$
    uname: 'empty_cell_archived_or_all_uname'}
    
  ;JPEG button
  sEmptyCellJPEGbutton = { value: 'REFreduction_images/SaveAsJpeg.bmp',$
    uname: 'empty_cell_save_as_jpeg_button',$
    tooltip: 'Create a JPEG of the plot' ,$
    sensitive: 0}
    
  ;plot button
  sPlotButton = { uname: 'empty_cell_advanced_plot_button'}
  
  ;with or without proposal folder in findnexus
  sEmptyCell_proposal_button = { uname : 'with_empty_cell_proposal_button'}
  sEmptyCell_proposal_folder_droplist = { uname: 'empty_cell_proposal_folder_droplist'}
  sEmpty_cell_proposal_base = { uname: 'empty_cell_proposal_base_uname'}
  
  ;Y vs TOF (2d) and Y vs X (2D)
  XYoff = [40,55]
  sTab = { size: [XYoff[0], $
    XYoff[1], $
    304*2, $
    304*2],$
    uname: 'empty_cell_d_dd_tab',$
    location: 1 }
    
  ;Y vs TOF (2D) ................................................................
  sBase1 = { value: 'Y vs TOF (2D)'}
  sDraw1 = { size: [5,5,sTab.size[2:3]],$
    uname: 'empty_cell_draw1_uname',$
    scroll: [590,570] }
    
  ;Y vs X (2D) ..................................................................
  sBase2 = { value: 'Y vs X (2D)'}
  sDraw2 = { size: [5,5,sTab.size[2:3]],$
    uname: 'empty_cell_draw2_uname',$
    scroll: sDraw1.scroll }
    
  ;NXsummary --------------------------------------------------------------------
  XYoff = [10,0]
  sNXsummary = { size: [sTab.size[0]+$
    sTab.size[2]+$
    XYoff[0],$
    sTab.size[1]+$
    XYoff[1],$
    520,500],$
    uname: 'empty_cell_nx_summary'}
    
  XYoff = [200,-15] ;label
  sNXsummaryLabel = { size: [sNXsummary.size[0]+XYoff[0],$
    sNXsummary.size[1]+XYoff[1]],$
    value: 'N X s u m m a r y'}
    
  ;status -----------------------------------------------------------------------
  XYoff = [0,30]
  sStatus = { size: [sNXsummary.size[0]+$
    XYoff[0],$
    sNXsummary.size[1]+$
    sNXsummary.size[3]+$
    XYoff[1],$
    sNXsummary.size[2], $
    80],$
    uname: 'empty_cell_status'}
    
  XYoff = [200,-20] ;label
  sStatusLabel = { size: [sStatus.size[0]+XYoff[0],$
    sStatus.size[1]+XYoff[1]],$
    value: 'S t a t u s'}
    
  ;Nexus list base --------------------------------------------------------------
  ;base
  sNexusListBase = { size: [NexusListSizeGlobal[0:3]],$
    frame: 2,$
    uname: 'empty_cell_list_nexus_base',$
    map: 0}
  ;label
  XYoff = [0,0]
  sNexusListLabel = { size: [XYoff[0],$
    XYoff[1],$
    sNexusListBase.size[2]-4],$
    value: NexusListLabelGlobal[0],$
    frame: 1 }
    
  ;droplist value
  XYoff = [0,25]
  sNexusDroplist = { size: [XYoff[0],$
    XYoff[1]],$
    value: ['                                        ' + $
    '                                 '],$
    uname: 'empty_cell_nexus_droplist' }
    
  ;widget_text
  XYoff = [0,38]
  sNexusText = { size: [XYoff[0],$
    sNexusDroplist.size[1]+XYoff[1],$
    sNexusListBase.size[2]-2,$
    400],$
    uname: 'empty_cell_list_nexus_nxsummary_text_field' }
    
  ;cancel button
  XYoff = [2,5]
  sNexusCancelButton = { size: [XYoff[0],$
    sNexusText.size[1]+$
    sNexusText.size[3]+$
    XYoff[1],$
    245],$
    value: 'CANCEL',$
    uname: 'empty_cell_list_cancel_button' }
    
  ;load button
  XYoff = [5,0]
  sNexusLoadButton = { size: [sNexusCancelButton.size[0]+ $
    sNexusCancelButton.size[2]+ $
    XYoff[0],$
    sNexusCancelButton.size[1]+XYoff[1],$
    sNexusCancelButton.size[2]],$
    value: 'LOAD SELECTED NEXUS',$
    uname: 'empty_cell_list_load_button' }
    
  ;Substrate Transmission Equation ----------------------------------------------
  XYoff = [0,20]
  sSubBase = { size: [sTab.size[0]+XYoff[0],$
    sTab.size[1]+$
    sTab.size[3]+$
    XYoff[1],$
    1135,135],$
    uname: 'empty_cell_substrate_base',$
    sensitive: 0,$
    frame: 1}
    
  XYoff = [20,-8] ;title
  sSubTitle = { size: [sSubBase.size[0]+XYoff[0],$
    sSubBase.size[1]+XYoff[1]],$
    title: 'Substrate Transmission Equation '}
    
  ;equation label ...............................................................
  sSubEquation = {value: 'T = C * exp[-(A + B * Lambda) * D]         '}
  
  ;substrate type ...............................................................
  WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global
  substrate_type = (*(*global).substrate_type)
  
  sz = (SIZE(substrate_type))(1)
  type_array = STRARR(sz)
  FOR i=0,(sz-1) DO BEGIN
    type_array[i] = substrate_type[i].type_name
  ENDFOR
  sSubList = { list: type_array,$
    uname: 'empty_cell_substrate_list',$
    title: 'Substrate Type:'}
    
  fa = FLOAT(substrate_type[0].a) * 100
  fb = FLOAT(substrate_type[0].b) * 10000
  fd = FLOAT(substrate_type[0].d) * 0.01
  
  ;a and b coefficient ..........................................................
  sAcoeff = { uname: 'empty_cell_substrate_a',$
    title: 'A =',$
    value: STRCOMPRESS(substrate_type[0].a,/REMOVE_ALL)}
  sAunits = { value: 'cm^-1' }
  
  sBcoeff = { uname: 'empty_cell_substrate_b',$
    title: 'B =',$
    value: STRCOMPRESS(substrate_type[0].b,/REMOVE_ALL)}
  sBunits = { value: 'cm^-2' }
  
  ;substrate diameter ...........................................................
  sDiameterLabel = { title: '         Substrate Diameter' }
  sDiameterField = { title: ' D =',$
    uname: 'empty_cell_diameter',$
    value: STRCOMPRESS(substrate_type[0].d,/REMOVE_ALL)}
  sDiameterUnits = { title: 'cm' }
  
  ;scaling factor ..-...........................................................
  sScalingFactorLabel = { title: '             Scaling Factor' }
  sScalingFactorField = { title: '   C =',$
    uname: 'empty_cell_scaling_factor',$
    value: STRCOMPRESS(1,/REMOVE_ALL)}
  sScalingFactorButton = { value: 'CALCULATE SCALING FACTOR',$
    uname: 'empty_cell_scaling_factor_button'}
    
  ;final equation ...............................................................
  Equation  = 'T = exp[-(' + STRCOMPRESS(fa,/REMOVE_ALL)
  Equation += ' + ' + STRCOMPRESS(fb,/REMOVE_ALL)
  Equation += ' * Lambda) * ' + STRCOMPRESS(fd,/REMOVE_ALL)
  Equation += ']'
  sFinalEquation = { uname: 'empty_cell_substrate_equation',$
    value: Equation,$
    frame: 1}
    
  ;******************************************************************************
  ;Define widgets ***************************************************************
  ;******************************************************************************
  wBase = WIDGET_BASE(DataNormalizationTab,$
    UNAME     = sBase.uname,$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = EmptyCellTitle)
    
  ;Base that will contain the Scaling Factor calculation ------------------------
  wSFcalculationBase = WIDGET_BASE(wBase,$
    UNAME     = sSFcalculationBase.uname,$
    XOFFSET   = sSFcalculationBase.size[0],$
    YOFFSET   = sSFcalculationBase.size[1],$
    SCR_XSIZE = sSFcalculationBase.size[2],$
    SCR_YSIZE = sSFcalculationBase.size[3],$
    MAP       = sSFcalculationBase.map)
    
  ;Data base ....................................................................
  wDataTitle = WIDGET_LABEL(wSFcalculationBase,$
    XOFFSET = sDataTitle.size[0],$
    YOFFSET = sDataTitle.size[1],$
    VALUE   = sDataTitle.value)
    
  wDataBase = WIDGET_BASE(wSFcalculationBase,$
    XOFFSET   = sDataBase.size[0],$
    YOFFSET   = sDataBase.size[1],$
    SCR_XSIZE = sDataBase.size[2],$
    SCR_YSIZE = sDataBase.size[3]+12,$
    FRAME     = sDataBase.frame)
    
  ;Draw
  wDataDraw = WIDGET_DRAW(wDatabase,$
    XOFFSET       = sDataDraw.size[0],$
    YOFFSET       = sDataDraw.size[1],$
    Y_SCROLL_SIZE = sDataDraw.size[3],$
    X_SCROLL_SIZE = sDataDraw.size[2],$
    XSIZE         = sDataDraw.size[2],$
    YSIZE         = 304,$
    RETAIN        = 2,$
    /SCROLL,$
    UNAME         = sDataDraw.uname,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS)
    
  ;X(label/value), Y(label/value) and I(label/value)
  wDataRowBase = WIDGET_BASE(wDatabase,$
    XOFFSET = sDataRowBase.size[0],$
    YOFFSET = sDataRowBase.size[1],$
    SCR_XSIZE = sDataRowBase.size[2],$
    SCR_YSIZE = sDataRowBase.size[3],$
    FRAME     = sDataRowBase.frame,$
    /ROW)
    
  xlabel = WIDGET_LABEL(wDataRowBase,$
    VALUE = sDataLabel.x.value)
  xValue = WIDGET_LABEL(wDataRowBase,$
    VALUE = 'N/A',$
    XSIZE = sDataLabel.x.xsize,$
    /ALIGN_LEFT,$
    UNAME = sDataLabel.x.uname)
  label = WIDGET_LABEL(wDataRowBase,$
    VALUE = '  ')
  ylabel = WIDGET_LABEL(wDataRowBase,$
    VALUE = sDataLabel.y.value)
  yValue = WIDGET_LABEL(wDataRowBase,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    XSIZE = sDataLabel.y.xsize,$
    UNAME = sDataLabel.y.uname)
  label = WIDGET_LABEL(wDataRowBase,$
    VALUE = '      ')
  Ilabel = WIDGET_LABEL(wDataRowBase,$
    VALUE = sDataLabel.counts.value)
  IValue = WIDGET_LABEL(wDataRowBase,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    XSIZE = sDataLabel.counts.xsize,$
    UNAME = sDataLabel.counts.uname)
    
  ;end of data base .............................................................
    
  ;EmptyCell base ...............................................................
  wEmptyCellTitle = WIDGET_LABEL(wSFcalculationBase,$
    XOFFSET = sEmptyCellTitle.size[0],$
    YOFFSET = sEmptyCellTitle.size[1],$
    VALUE   = sEmptyCellTitle.value)
    
  wEmptyCellBase = WIDGET_BASE(wSFcalculationBase,$
    XOFFSET   = sEmptyCellBase.size[0],$
    YOFFSET   = sEmptyCellBase.size[1],$
    SCR_XSIZE = sEmptyCellBase.size[2],$
    SCR_YSIZE = sEmptyCellBase.size[3]+12,$
    FRAME     = sEmptyCellBase.frame)
    
  ;Draw
  wEmptyCellDraw = WIDGET_DRAW(wEmptyCellbase,$
    XOFFSET       = sEmptyCellDraw.size[0],$
    YOFFSET       = sEmptyCellDraw.size[1],$
    Y_SCROLL_SIZE = sEmptyCellDraw.size[3],$
    X_SCROLL_SIZE = sEmptyCellDraw.size[2],$
    XSIZE         = sEmptyCellDraw.size[2],$
    YSIZE         = 304,$
    RETAIN        = 2,$
    /SCROLL,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    UNAME         = sEmptyCellDraw.uname)
    
  ;X(label/value), Y(label/value) and I(label/value)
  wEmptyCellRowBase = WIDGET_BASE(wEmptyCellbase,$
    XOFFSET = sEmptyCellRowBase.size[0],$
    YOFFSET = sEmptyCellRowBase.size[1],$
    SCR_XSIZE = sEmptyCellRowBase.size[2],$
    SCR_YSIZE = sEmptyCellRowBase.size[3],$
    FRAME     = sEmptyCellRowBase.frame,$
    /ROW)
    
  xlabel = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = sEmptyCellLabel.x.value)
  xValue = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = 'N/A',$
    XSIZE = sEmptyCellLabel.x.xsize,$
    /ALIGN_LEFT,$
    UNAME = sEmptyCellLabel.x.uname)
  label = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = '  ')
  ylabel = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = sEmptyCellLabel.y.value)
  yValue = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    XSIZE = sEmptyCellLabel.y.xsize,$
    UNAME = sEmptyCellLabel.y.uname)
  label = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = '      ')
  Ilabel = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = sEmptyCellLabel.counts.value)
  IValue = WIDGET_LABEL(wEmptyCellRowBase,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    XSIZE = sEmptyCellLabel.counts.xsize,$
    UNAME = sEmptyCellLabel.counts.uname)
    
  ;end of empty cell base .......................................................
    
  ;lin/log axis
  wLinLogBase = WIDGET_BASE(wSFcalculationBase,$
    XOFFSET = sLinLogBase.size[0],$
    YOFFSET = sLinLogBase.size[1],$
    SCR_XSIZE = sLinLogBase.size[2],$
    SCR_YSIZE = sLinLogBase.size[3])
    
  group = CW_BGROUP(wLinLogBase,$
    XOFFSET = sLinLogGroup.size[0],$
    sLinLogGroup.list,$
    UNAME = sLinLogGroup.uname,$
    /EXCLUSIVE,$
    /NO_RELEASE,$
    /ROW,$
    LABEL_LEFT = sLinLogGroup.label,$
    SET_VALUE = 0.0)
    
  ;SF equation label and text field .............................................
  wSFequationDraw = WIDGET_DRAW(wSFcalculationBase,$
    XOFFSET = sSFequationDraw.size[0],$
    YOFFSET = sSFequationDraw.size[1],$
    SCR_XSIZE = sSFequationDraw.size[2],$
    SCR_YSIZE = sSFequationDraw.size[3],$
    UNAME     = sSFequationDraw.uname)
    
  wSFequationLabel = WIDGET_LABEL(wSFcalculationBase,$
    XOFFSET = sSFequationLabel.size[0],$
    YOFFSET = sSFequationLabel.size[1],$
    VALUE   = sSFequationLabel.value)
    
  wSFequation = WIDGET_TEXT(wSFcalculationBase,$
    XOFFSET = sSFequationTextField.size[0],$
    YOFFSET = sSFequationTextField.size[1],$
    XSIZE   = sSFequationTextField.size[2],$
    UNAME   = sSFequationTextField.uname,$
    VALUE   = sSFequationTextField.value,$
    /EDITABLE)
    
  wSFequationLabel = WIDGET_LABEL(wSFcalculationBase,$
    XOFFSET = sSFequationLabel2.size[0],$
    YOFFSET = sSFequationLabel2.size[1],$
    VALUE   = sSFequationLabel2.value)
    
  ;end of SF equation label and text field ......................................
    
  ;Recap base ...................................................................
  wRecapTitle = WIDGET_LABEL(wSFcalculationBase,$
    XOFFSET = sRecapTitle.size[0],$
    YOFFSET = sRecapTitle.size[1],$
    VALUE   = sRecapTitle.value)
    
  wRecapBase = WIDGET_BASE(wSFcalculationBase,$
    XOFFSET   = sRecapBase.size[0],$
    YOFFSET   = sRecapBase.size[1],$
    SCR_XSIZE = sRecapBase.size[2],$
    SCR_YSIZE = sRecapBase.size[3]+12,$
    FRAME     = sRecapBase.frame)
    
  ;Draw
  wRecapDraw = WIDGET_DRAW(wRecapbase,$
    XOFFSET       = sRecapDraw.size[0],$
    YOFFSET       = sRecapDraw.size[1],$
    Y_SCROLL_SIZE = sRecapDraw.size[3],$
    X_SCROLL_SIZE = sRecapDraw.size[2],$
    XSIZE         = sRecapDraw.size[2],$
    YSIZE         = 304,$
    RETAIN        = 2,$
    /SCROLL,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    UNAME         = sRecapDraw.uname)
    
  ;X(label/value), Y(label/value) and I(label/value)
  wRecapRowBase = WIDGET_BASE(wRecapbase,$
    XOFFSET = sRecapRowBase.size[0],$
    YOFFSET = sRecapRowBase.size[1],$
    SCR_XSIZE = sRecapRowBase.size[2],$
    SCR_YSIZE = sRecapRowBase.size[3],$
    FRAME     = sRecapRowBase.frame,$
    /ROW)
    
  xlabel = WIDGET_LABEL(wRecapRowBase,$
    VALUE = sRecapLabel.x.value)
  xValue = WIDGET_LABEL(wRecapRowBase,$
    VALUE = 'N/A',$
    XSIZE = sRecapLabel.x.xsize,$
    /ALIGN_LEFT,$
    UNAME = sRecapLabel.x.uname)
  label = WIDGET_LABEL(wRecapRowBase,$
    VALUE = '  ')
  ylabel = WIDGET_LABEL(wRecapRowBase,$
    VALUE = sRecapLabel.y.value)
  yValue = WIDGET_LABEL(wRecapRowBase,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    XSIZE = sRecapLabel.y.xsize,$
    UNAME = sRecapLabel.y.uname)
  label = WIDGET_LABEL(wRecapRowBase,$
    VALUE = '      ')
  Ilabel = WIDGET_LABEL(wRecapRowBase,$
    VALUE = sRecapLabel.counts.value)
  IValue = WIDGET_LABEL(wRecapRowBase,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    XSIZE = sRecapLabel.counts.xsize,$
    UNAME = sRecapLabel.counts.uname)
    
  ;end of Recap base ............................................................
    
  ;output base ..................................................................
  ;title
  label = WIDGET_LABEL(wSFcalculationBase,$
    XOFFSET = sOutputTitle.size[0],$
    YOFFSET = sOutputTitle.size[1],$
    VALUE   = sOutputTitle.value)
    
  output_base = WIDGET_BASE(wSFcalculationBase,$
    XOFFSET   = sOutputBase.size[0],$
    YOFFSET   = sOutputBase.size[1],$
    SCR_XSIZE = sOutputBase.size[2],$
    SCR_YSIZE = sOutputBase.size[3],$
    FRAME     = sOutputBase.frame,$
    UNAME     = sOutputBase.uname,$
    SENSITIVE = sOutputBase.sensitive)
    
  ;output folder button
  button = WIDGET_BUTTON(output_base,$
    XOFFSET   = sOutputFolder.size[0],$
    YOFFSET   = sOutputFolder.size[1],$
    SCR_XSIZE = sOutputFolder.size[2],$
    VALUE     = sOutputFolder.value,$
    UNAME     = sOutputFolder.uname)
    
  ;name of file
  text = WIDGET_TEXT(output_base,$
    XOFFSET   = sOutputFile.size[0],$
    YOFFSET   = sOutputFile.size[1],$
    SCR_XSIZE = sOutputFile.size[2],$
    UNAME     = sOutputFile.uname,$
    VALUE     = sOutputFile.value,$
    /ALL_EVENTS,$
    /EDITABLE)
    
  ;create output file button
  button = WIDGET_BUTTON(output_base,$
    XOFFSET = sOutputButton.size[0],$
    YOFFSET = sOutputButton.size[1],$
    SCR_XSIZE = sOutputButton.size[2],$
    SCR_YSIZE = sOutputButton.size[3],$
    VALUE     = sOutputButton.value,$
    UNAME     = sOutputButton.uname,$
    SENSITIVE = sOutputButton.sensitive)
    
  ;preview button
  button = WIDGET_BUTTON(output_base,$
    XOFFSET   = sOutputPreview.size[0],$
    YOFFSET   = sOutputPreview.size[1],$
    SCR_XSIZE = sOutputPreview.size[2],$
    VALUE     = sOutputPreview.value,$
    UNAME     = sOutputPreview.uname,$
    SENSITIVE = sOutputPreview.sensitive)
    
  ;end of output base ...........................................................
    
  wSFcancel = WIDGET_BUTTON(wSFcalculationBase,$
    XOFFSET   = sSFcancel.size[0],$
    YOFFSET   = sSFcancel.size[1],$
    SCR_XSIZE = sSFcancel.size[2],$
    UNAME     = sSFcancel.uname,$
    VALUE     = sSFcancel.value)
    
  wSFok = WIDGET_BUTTON(wSFcalculationBase,$
    XOFFSET   = sSFok.size[0],$
    YOFFSET   = sSFok.size[1],$
    SCR_XSIZE = sSFok.size[2],$
    UNAME     = sSFok.uname,$
    VALUE     = sSFok.value)
    
  ;end of scaling factor calculation ............................................
    
  ;******************* loading nexus interface **********************************
  NexusInterface, BASE_UNAME = wBase,$
    BROWSE_BUTTON_UNAME = sNexusBrowseButton.uname,$
    RUN_NBR_UNAME       = sEmptyCellTextField.uname,$
    ARCHIVED_ALL_UNAME  = sEmptyCellArchivedListAll.uname,$
    PROPOSAL_BUTTON_UNAME = sEmptyCell_proposal_button.uname,$
    PROPOSAL_BASE_UNAME = sEmpty_cell_proposal_base.uname,$
    PROPOSAL_FOLDER_DROPLIST_UNAME = $
    sEmptyCell_proposal_folder_droplist.uname,$
    SAVE_AS_JPEG_UNAME = sEmptyCellJPEGbutton.uname,$
    PLOT_BUTTON_UNAME = sPlotButton.uname
    
  ;------------------------------------------------------------------------------
    
  ;base
  wNexusListBase = WIDGET_BASE(wBase,$
    UNAME     = sNexusListBase.uname,$
    XOFFSET   = sNexusListBase.size[0],$
    YOFFSET   = sNexusListBase.size[1],$
    SCR_XSIZE = sNexusListBase.size[2],$
    SCR_YSIZE = sNexusListBase.size[3],$
    FRAME     = sNexusListBase.frame,$
    MAP       = sNexusListBase.map)
    
  ;label
  wNexusListLabel = WIDGET_LABEL(wNexusListBase,$
    XOFFSET   = sNexusListLabel.size[0],$
    YOFFSET   = sNexusListLabel.size[1],$
    SCR_XSIZE = sNexusListLabel.size[2],$
    VALUE     = sNexusListLabel.value,$
    FRAME     = sNexusListLabel.frame)
    
  ;droplist value
  wNexusDroplist = WIDGET_DROPLIST(wNexusListBase,$
    UNAME   = sNexusDroplist.uname,$
    XOFFSET = sNexusDroplist.size[0],$
    YOFFSET = sNexusDroplist.size[1],$
    VALUE   = sNexusDroplist.value,$
    /TRACKING_EVENTS)
    
  ;nxsummary text
  wNexusText = WIDGET_TEXT(wNexusListBase,$
    XOFFSET   = sNexusText.size[0],$
    YOFFSET   = sNexusText.size[1],$
    SCR_XSIZE = sNexusText.size[2],$
    SCR_YSIZE = sNexusText.size[3],$
    UNAME     = sNexusText.uname,$
    /WRAP,$
    /SCROLL)
    
  ;cancel button
  wNexusCancelButton = WIDGET_BUTTON(wNexusListBase,$
    UNAME     = sNexusCancelButton.uname,$
    XOFFSET   = sNexusCancelButton.size[0],$
    YOFFSET   = sNexusCancelButton.size[1],$
    SCR_XSIZE = sNexusCancelButton.size[2],$
    VALUE     = sNexusCancelButton.value)
    
  ;load button
  wNexusLoadButton = WIDGET_BUTTON(wNexusListBase,$
    UNAME     = sNexusLoadButton.uname,$
    XOFFSET   = sNexusLoadButton.size[0],$
    YOFFSET   = sNexusLoadButton.size[1],$
    SCR_XSIZE = sNexusLoadButton.size[2],$
    VALUE     = sNexusLoadButton.value)
    
  ;Plot Tabs ....................................................................
  wTab = WIDGET_TAB(wBase,$
    XOFFSET   = sTab.size[0],$
    YOFFSET   = sTab.size[1],$
    SCR_XSIZE = sTab.size[2],$
    SCR_YSIZE = sTab.size[3],$
    UNAME     = sTab.uname,$
    LOCATION  = sTab.location,$
    /TRACKING_EVENTS)
    
  ;Y vs TOF (2D) ________________________________________________________________
  wBase1 = WIDGET_BASE(wTab,$
    TITLE = sBase1.value)
    
  wDraw1 = WIDGET_DRAW(wBase1,$
    XOFFSET       = sDraw1.size[0],$
    YOFFSET       = sDraw1.size[1],$
    ;                     X_SCROLL_SIZE = sDraw1.scroll[0],$
    ;                     Y_SCROLL_SIZE = sDraw1.scroll[1],$
    SCR_XSIZE     = sDraw1.scroll[0],$
    SCR_YSIZE     = sDraw1.scroll[1],$
    UNAME         = sDraw1.uname,$
    RETAIN        = 2,$
    ;                     /SCROLL,$
    /MOTION_EVENTS)
    
  ;Y vs TOF (2D) ________________________________________________________________
  wBase2 = WIDGET_BASE(wTab,$
    TITLE = sBase2.value)
    
  wDraw2 = WIDGET_DRAW(wBase2,$
    XOFFSET       = sDraw2.size[0],$
    YOFFSET       = sDraw2.size[1],$
    ;                     X_SCROLL_SIZE = sDraw2.scroll[0],$
    ;                     Y_SCROLL_SIZE = sDraw2.scroll[1],$
    SCR_XSIZE     = sDraw2.scroll[0],$
    SCR_YSIZE     = sDraw2.scroll[1],$
    UNAME         = sDraw2.uname,$
    RETAIN        = 2,$
    ;                     /SCROLL,$
    /MOTION_EVENTS)
    
  ;NXsummary --------------------------------------------------------------------
  wNXsummary = WIDGET_TEXT(wBase,$
    XOFFSET   = sNXsummary.size[0],$
    YOFFSET   = sNXsummary.size[1],$
    SCR_XSIZE = sNXsummary.size[2],$
    SCR_YSIZE = sNXsummary.size[3],$
    UNAME     = sNXsummary.uname,$
    /WRAP,$
    /SCROLL)
    
  wNXsummaryLabel = WIDGET_LABEL(wBase,$
    XOFFSET = sNXsummaryLabel.size[0],$
    YOFFSET = sNXsummaryLabel.size[1],$
    VALUE   = sNXsummaryLabel.value)
    
  ;Status -----------------------------------------------------------------------
  wStatus = WIDGET_TEXT(wBase,$
    XOFFSET   = sStatus.size[0],$
    YOFFSET   = sStatus.size[1],$
    SCR_XSIZE = sStatus.size[2],$
    SCR_YSIZE = sStatus.size[3],$
    UNAME     = sStatus.uname,$
    /WRAP,$
    /SCROLL)
    
  wStatusLabel = WIDGET_LABEL(wBase,$
    XOFFSET = sStatusLabel.size[0],$
    YOFFSET = sStatusLabel.size[1],$
    VALUE   = sStatusLabel.value)
    
    
  ;Substrate Transmission Equation ----------------------------------------------
  ;title
  wSubTitle = WIDGET_LABEL(wBase,$
    XOFFSET = sSubTitle.size[0],$
    YOFFSET = sSubTitle.size[1],$
    VALUE   = sSubTitle.title)
    
  ;frame
  wSubBase = WIDGET_BASE(wBase,$
    XOFFSET   = sSubBase.size[0],$
    YOFFSET   = sSubBase.size[1],$
    SCR_XSIZE = sSubBase.size[2],$
    SCR_YSIZE = sSubBase.size[3],$
    UNAME     = sSubBase.uname,$
    FRAME     = sSubBase.frame,$
    SENSITIVE = sSubBase.sensitive,$
    /ROW)
    
  ;equation .....................................................................
  wSpace = WIDGET_LABEL(wSubBase,$
    VALUE = '  ')
  wSubEquation = WIDGET_LABEL(wSubBase,$
    VALUE = sSubEquation.value)
  wSpace = WIDGET_LABEL(wSubBase,$
    VALUE = '  ')
    
  ;Type .........................................................................
  wTypeBase = WIDGET_BASE(wSubBase,$
    /COLUMN)
  list = WIDGET_DROPLIST(wTypeBase,$
    UNAME = sSubList.uname,$
    VALUE = sSubList.list,$
    TITLE = sSubList.title)
    
  ;a and b coefficient ..........................................................
  wBase1 = WIDGET_BASE(wTypeBase,$
    /ROW)
  wAcoeff = CW_FIELD(wBase1,$
    VALUE = sAcoeff.value,$
    UNAME = sAcoeff.uname,$
    TITLE = sAcoeff.title,$
    ;                   /FLOATING,$
    /ALL_EVENTS)
  wAunits = WIDGET_LABEL(wBase1,$
    VALUE = sAunits.value)
    
  wBase2 = WIDGET_BASE(wTypeBase,$
    /ROW)
  wBcoeff = CW_FIELD(wBase2,$
    VALUE = sBcoeff.value,$
    UNAME = sBcoeff.uname,$
    TITLE = sBcoeff.title,$
    ;                   /FLOATING,$
    /ALL_EVENTS)
  wBunits = WIDGET_LABEL(wBase2,$
    VALUE = sBunits.value)
    
    
  ;space
  wSpace = WIDGET_LABEL(wSubBase,$
    VALUE = '   ')
    
  ;diameter label/units, Scaling Factor and equation ............................
  wBaseColumn = WIDGET_BASE(wSubBase,$
    /COLUMN,$
    /BASE_ALIGN_CENTER)
    
  ;diameter and scaling factor
  wBaseRow1 = WIDGET_BASE(wBaseColumn,$
    /ROW)
    
  ;diameter
  wBaseColumn1_1 = WIDGET_BASE(wBaseRow1,$
    /COLUMN,$
    /BASE_ALIGN_LEFT)
    
  wDiameterLabel = WIDGET_LABEL(wBaseColumn1_1,$
    VALUE = sDiameterLabel.title)
  wBaseColumn1_1_row1 = WIDGET_BASE(wBaseColumn1_1,$
    /ROW)
  wDiameterValue = CW_FIELD(wBaseColumn1_1_row1,$
    TITLE = sDiameterField.title,$
    VALUE = sDiameterField.value,$
    UNAME = sDiameterField.uname,$
    ;                          /FLOATING,$
    /ALL_EVENTS)
  wDiameterUnits = WIDGET_LABEL(wBaseColumn1_1_row1,$
    VALUE = sDiameterUnits.title)
    
  ;Scaling Factor
  wBaseColumn1_2 = WIDGET_BASE(wBaseRow1,$
    /COLUMN,$
    /BASE_ALIGN_LEFT)
  wSFLabel = WIDGET_LABEL(wBaseColumn1_2,$
    VALUE = sScalingFactorLabel.title)
  wBaseColumn1_2_row1 = WIDGET_BASE(wBaseColumn1_2,$
    /ROW)
  wSFValue = CW_FIELD(wBaseColumn1_2_row1,$
    TITLE = sScalingFactorField.title,$
    VALUE = sScalingFactorField.value,$
    UNAME = sScalingFactorField.uname,$
    ;                    /FLOATING,$
    /ALL_EVENTS)
  wSFbutton = WIDGET_BUTTON(wBaseColumn1_2_row1,$
    VALUE = sScalingFactorButton.value,$
    UNAME = sScalingFactorButton.uname)
    
  ;space
  wSpace = WIDGET_LABEL(wBaseColumn,$
    VALUE = '')
  wSpace = WIDGET_LABEL(wBaseColumn,$
    VALUE = '')
    
  ;final equation
  wBaseColumn2_1 = WIDGET_BASE(wBaseColumn,$
    /ROW)
  wSpace = WIDGET_LABEL(wBaseColumn2_1,$
    VALUE = '  ')
  wEquation = WIDGET_LABEL(wBaseColumn2_1, $
    VALUE = sFinalEquation.value,$
    UNAME = sFinalEquation.uname,$
    XSIZE = 500,$
    FRAME = sFinalEquation.frame)
    
END

