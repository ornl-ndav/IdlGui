PRO BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

Resolve_Routine, 'ref_reduction_eventcb',$
  /COMPILE_FULL_FILE            ; Load event callback routines

;build the Instrument Selection base
MakeGuiInstrumentSelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

END



PRO BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

VERSION = ' (version: 1.0.18)'
loadct,5

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin


if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
   debugger = 1
endif else begin
   ucams = get_ucams()
   debugger = 0
   SWITCH (ucams) OF
       'j35':
       '2zr':
       'pf9':
       'mid':
       'ceh':
       'vuk':
       'ks6':
       'oswader':
       'jfb': debugger = 1
       ELSE :
   ENDSWITCH
endelse

;define global variables
global = ptr_new ({instrument : strcompress(instrument,/remove_all),$ 
;name of the current selected REF instrument
                  debugger : debugger,$
                  PrevBatchRowSelected : 0,$
                    BatchDefaultPath : '~/',$
                    BatchDefaultFileFilter : '*_Batch_Run*.txt',$
                    BatchFileName : '',$
                    PreviousRunReductionValidated : 0,$  
                    BatchTable : ptr_new(0L),$ ;big array of batch table
                    isHDF5format : 1,$
                    DataRunNumber : '',$
                    NormRunNumber : '',$
                    archived_data_flag : 1,$
                    archived_norm_flag : 1,$
                    dr_output_path : '~/',$
;output path define in the REDUCE tab
  cl_output_path : '~/REFreduction_CL/',$
;default path where to put the command line output file
  cl_file_ext1    : 'REFreduction_CL_',$
;default first part of output command line file
  cl_file_ext2    : '.txt',$
;default extension of output command line file
  cl_file_ext3    : '*-04:00.txt',$
;default extension of output command line used in dialog_pickfile
                   cl_output_name : '',$
;name of file that will contain a copy of the command line 
                   nexus_bank1_path : '/entry/bank1/data',$ ;nxdir path to bank1 data
                     bank1_data : ptr_new(0L),$ ;
                     bank1_norm : ptr_new(0L),$ ;
                     miniVersion : 0,$
;1 if this is the miniVersion and 0 if it's not
                   FilesToPlotList : ptr_new(0L),$ 
;list of files to plot (main,rmd and intermediate files)
                   PreviewFileNbrLine : 40,$ 
;nbr of line to get from intermediates files
                   DataReductionStatus : 'ERROR',$ 
; status of the data reduction 'OK' or 'ERROR'
                   PlotsTitle : ptr_new(0L),$ 
;title of all the plots (main and intermediate)
                   MainPlotTitle : '',$ 
;title of main data reduction
                   IntermPlots : intarr(8),$ 
;0 for inter. plot no desired, 1 for desired
                   CurrentPlotsFullFileName:ptr_new(0L),$ 
;full path name of the plot currently plotted
                   OutputFileName : '',$ 
; ex: REF_L_2000_2007-08-31T09:28:59-04:00.txt
                   IsoTimeStamp : '',$ 
; ex: 2007-08-31T09:28:59-04:00
                   ExtOfAllPlots : ptr_new(0L),$ 
;extension of all the files created
                   PrevTabSelect : 0,$ 
;name of previous main tab selected
                   PrevDataZoomTabSelect: 0,$
;name of previous zoom/NXsummary tab selected (data)
                   PrevNormZoomTabSelect: 0,$
;name of previous zoom/NXsummary tab selected (normalization)
                   DataNeXusFound : 0, $ 
;no data nexus found by default
                   NormNeXusFound : 0, $ 
;no norm nexus found by default
                   data_full_nexus_name : '',$ 
;full path to data nexus file
                   norm_full_nexus_name : '',$ 
;full path to norm nexus file
                   xsize_1d_draw : 2*304L,$ 
;size of 1D draw (should be Ntof)
                   REF_L : 'REF_L',$ 
;name of REF_L instrument
                   REF_M : 'REF_M',$ 
;name of REF_M instrument
                   Nx_REF_L : 256L,$ 
;Nx for REF_L instrument
                   Ny_REF_L : 304L,$ 
;Ny for REF_L instrument
                   Nx_REF_M : 304L,$ 
;Nx for REF_M instrument
                   Ny_REF_M : 256L,$ 
;Ny for REF_M instrument
                   Ntof_DATA : 0L, $ 
;TOF for data file
                   Ntof_NORM : 0L, $ 
;TOF for norm file
                   failed : 'FAILED',$
;failed message to display
                   processing_message : '(PROCESSING)',$ 
;processing message to display
                   data_tmp_dat_file : 'tmp_data.dat',$ 
;default name of tmp binary data file
                   full_data_tmp_dat_file : '',$ 
;full path of tmp .dat file for data
                   norm_tmp_dat_file : 'tmp_norm.dat',$ 
;default name of tmp binary norm file
                   full_norm_tmp_dat_file : '',$ 
;full path of tmp .dat file for normalization
                   working_path : '~/local/',$ 
;where the tmp file will be created
                   ucams : ucams, $ 
;ucams of the current user
                   data_run_number: 0L,$ 
;run number of the data file loaded and plotted
                   norm_run_number: 0L,$ 
;run number of the norm. file loaded and plotted
                   DATA_DD_ptr : ptr_new(0L),$ 
;detector view of DATA (2D)
                   DATA_D_ptr : ptr_new(0L),$ 
;(ntot,Ny,Nx) array of DATA
                   DATA_D_Total_ptr : ptr_new(0L),$
;img=total(img,x) x=2 for REF_M and x=3 for REF_L
                   NORM_D_Total_ptr : ptr_new(0L),$
;img=total(img,x) x=2 for REF_M and x=3 for REF_L
                   NORM_DD_ptr : ptr_new(0L),$ 
;detector view of NORMALIZATION (2D)
                   NORM_D_ptr : ptr_new(0L),$ 
;(Ntof,Ny,Nx) array of NORMALIZATION
                   tvimg_data_ptr : ptr_new(0L),$ 
;rebin data img
                   tvimg_norm_ptr : ptr_new(0L),$ 
;rebin norm img
                   back_selection_color : 250L,$ 
;color of background selection
                   peak_selection_color : 100L,$
;color of peak exclusion
                   data_back_selection : ptr_new(0L),$ 
;Ymin and Ymax for data background
                   norm_back_selection : ptr_new(0L),$ 
;Ymin and Ymax for norm background
                   data_peak_selection : ptr_new(0L),$ 
;Ymin and Ymax for data peak
                   norm_peak_selection : ptr_new(0L),$
;Ymin and Ymax for norm peak
                   data_back_roi_ext : '_data_roi.dat',$ 
;extension file name of back data ROI
                   norm_back_roi_ext : '_norm_roi.dat',$
;extension file name of back norm ROI
                   load_back_roi_ext : '_roi.dat',$
;filter used to load background ROI files for data and norm
                   roi_file_preview_nbr_line : 20L,$ 
;nbr of line to display in preview
                   select_data_status : 0,$ 
;Status of the data selection (see below)
                   select_norm_status : 0,$ 
;Status of the norm selection (see below)
                   select_zoom_status : 0,$
;Status of the zoom (0=no zoom; 1=zoom)
                   flt0_ptr : ptrarr(8,/allocate_heap),$ 
;arrays of all the x-axis
                   flt1_ptr : ptrarr(8,/allocate_heap),$ 
;arrays of all the y-axis
                   flt2_ptr : ptrarr(8,/allocate_heap),$ 
;arrays of all the y-error data
                   fltPreview_ptr : ptrarr(8,/allocate_heap),$
;metadata of all files
                   InstrumentGeometryPath : '',$
;default path where to get the instrument geometry to overwrite
                   InstrumentDataGeometryFileName : '',$
;full path to instrument geometry to overwrite
                   InstrumentNormGeometryFileName : '',$
;full path to instrument geometry to overwrite
                   DataZoomFactor: 2L,$
;scale factor for zoom of 1D Data
                   NormalizationZoomFactor: 2L,$
;scale factor for zoom of 1D Normalization
                   DataX : 0L,$
;last x position of cursor in data 1d drawfor zoom                     
                   DataY : 0L,$
;last y position of cursor in data 1d drawfor zoom                     
                   NormX : 0L,$
;last x position of cursor in norm. 1d draw for zoom                     
                   NormY : 0L,$
;last x position of cursor in norm 1d draw for zoom                     
                   LogBookPath : '/SNS/users/LogBook/',$
;path where to put the log book
                   MacNexusFile : '~/SNS/REF_L/IPTS-231/1/4146/NeXus/REF_L_4146.nxs',$
;full path to NeXus file on the mac
                   MacNXsummary : '~/local/nxsummary_4146.txt',$
;full path to NXsummary file that will be read on Mac (instead of
;using NXsummary)
                   PreviousDataNexusListSelected: 0,$
;previous element selected in data nexus droplist
                   PreviousNormNexusListSelected: 0,$
;previous element selected in normalization nexus droplist
                   InitialDataContrastDropList: 5,$
;initial value of the contrast data droplist
                   PreviousDataContrastDroplistIndex: 5,$
;previous value of data contrast droplist
                   PreviousDataContrastBottomSliderIndex : 0,$
;previous value of data contrast bottom color slider
                   PreviousDataContrastNumberSliderIndex : 255,$
;previous value of data contrast number of color slider
                   InitialNormContrastDropList: 5,$
;initial value of the contrast norm droplist
                   PreviousNormContrastDroplistIndex: 5,$
;previous value of norm contrast droplist
                   PreviousNormContrastBottomSliderIndex : 0,$
;previous value of norm contrast bottom color slider
                   PreviousNormContrastNumberSliderIndex : 255,$
;previous value of norm contrast number of color slider
                   DataXYZminmaxArray : ptr_new(0L),$
;xmin, xmax, ymin, ymax, zmin, zmax of data (loaded in
;Plot1DDdataFile.pro
                   NormXYZminmaxArray : ptr_new(0L),$
;xmin, xmax, ymin, ymax, zmin, zmax of data (loaded in
;Plot1DDNormalizationFile.pro
                   PrevData1D3DAx : 30L,$
;previous Ax value of Data 1D_3D plot
                   PrevData1D3DAz : 30L,$
;previsou Az value of data 1D_3D plot
                   PrevData2D3DAx : 30L,$
;previous Ax value of Data 2D_3D plot
                   PrevData2D3DAz : 30L,$
;previsou Az value of data 2D_3D plot
                   DefaultData1D3DAx : 30L, $
;default Ax vlaue of data 1D_3D plot
                   DefaultData1D3DAz : 30L, $
;default Az value of data 1D_3D plot
                   DefaultData2D3DAx : 30L, $
;default Ax vlaue of data 2D_3D plot
                   DefaultData2D3DAz : 30L, $
;default Az value of data 2D_3D plot
                   PrevNorm1D3DAx : 30L,$
;previous Ax value of norm 1D_3D plot
                   PrevNorm1D3DAz : 30L,$
;previsou Az value of norm 1D_3D plot
                   PrevNorm2D3DAx : 30L,$
;previous Ax value of NORM 2D_3D plot
                   PrevNorm2D3DAz : 30L,$
;previsou Az value of NORM 2D_3D plot
                   DefaultNorm1D3DAx : 30L, $
;default Ax vlaue of norm 1D_3D plot
                   DefaultNorm1D3DAz : 30L, $
;default Az value of norm 1D_3D plot
                   DefaultNorm2D3DAx : 30L, $
;default Ax vlaue of norm 2D_3D plot
                   DefaultNorm2D3DAz : 30L, $
;default Az value of norm 2D_3D plot
                   InitialData1d3dContrastDropList : 5,$
;default value of the data loadct 1d_3d plot
                   InitialData2d3dContrastDropList : 5,$
;default value of the data loadct 2d_3d plot
                   PrevData1d3dContrastDropList : 5,$
;previous value of the data loadct 1d_3d plot
                   PrevData2d3dContrastDropList : 5,$
;previous value of the data loadct 2d_3d plot
                   InitialNorm1d3dContrastDropList : 5,$
;default value of the norm loadct 1d_3d plot
                   InitialNorm2d3dContrastDropList : 5,$
;default value of the norm loadct 2d_3d plot
                   PrevNorm1d3dContrastDropList : 5,$
;previous value of the norm loadct 1d_3d plot
                   PrevNorm2d3dContrastDropList : 5,$
;previous value of the norm loadct 2d_3d plot
                   Data_1d_3d_min_max : ptr_new(0L),$
;[min,max] values of the data img array (used to reset z in 1d_3d)
                   Data_2d_3d_min_max : ptr_new(0L),$
;[min,max] values of the data img array (used to reset z in 2d_3d)
                   Normalization_1d_3d_min_max : ptr_new(0L),$
;[min,max] values of the normalization img array (used to reset z in 1d_3d)
                   Normalization_2d_3d_min_max : ptr_new(0L),$
;[min,max] values of the normalization img array (used to reset z in
;2d_3d)
                   DataXMouseSelection : 0L,$
;Previous x position of data left click
                   NormXMouseSelection : 0L,$
;Previous x position of normalization left click
                   DataHiddenWidgetTextId : 0L, $
;ID of Data Hidden Widget Text
                   DataHiddenWidgetTextUname : '',$
;uname of data hidden widget text
                   NormHiddenWidgetTextId : 0L,$
;ID of Norm Hidden Widget Text
                   NormHiddenWidgetTextUname : '',$
;uname of Norm hidden widget text
                   UpDownMessage : '',$
;Message to display when left click main plot
                   REFreductionVersion : ''$
;Version of REFreduction Tool
                   })
                   
BatchTable = strarr(8,20)
(*(*global).BatchTable) = BatchTable
                   
;------------------------------------------------------------------------
;explanation of the select_data_status and select_norm_status
;0 nothing has been done yet
;1 user left click first and is now in back selection 1st border
;2 user release click and is done with back selection 1st border
;3 user right click and is now entering the back selection of 2nd border
;4 user left click and is now selecting the 2nd border
;5 user release click and is done with selection of 2nd border
;------------------------------------------------------------------------
                   
full_data_tmp_dat_file = (*global).working_path + (*global).data_tmp_dat_file 
(*global).full_data_tmp_dat_file = full_data_tmp_dat_file
full_norm_tmp_dat_file = (*global).working_path + (*global).norm_tmp_dat_file
(*global).full_norm_tmp_dat_file = full_norm_tmp_dat_file
(*(*global).data_back_selection) = [-1,-1]
(*(*global).data_peak_selection) = [-1,-1]
(*(*global).norm_back_selection) = [-1,-1]
(*(*global).norm_peak_selection) = [-1,-1]

(*global).UpDownMessage = 'Use U(up) or D(down) to move selection vertically pixel per pixel.' 
(*global).REFreductionVersion = VERSION

PlotsTitle = ['Data Combined Specular TOF Plot',$
              'Data Combined Background TOF Plot',$
              'Data Combined Subtracted TOF Plot',$
              'Normalization Combined Specular TOF Plot',$
              'Normalization Combined Background TOF Plot',$
              'Normalization Combined Subtracted TOF Plot',$
              'R vs TOF Plot',$
              'R vs TOF Combined Plot',$
              'XML output file']
(*(*global).PlotsTitle) = PlotsTitle
MainPlotTitle = 'Main Data Reduction Plot'
(*global).MainPlotTitle = MainPlotTitle

;instrument geometry
if (instrument EQ 'REF_L') then begin ;REF_L
    InstrumentGeometryPath = '/SNS/REF_L/2006_1_4B_CAL/calibrations/'
endif else begin
    InstrumentGeometryPath = '/SNS/REF_M/2006_1_4A_CAL/calibrations/'
endelse
(*global).InstrumentGeometryPath = InstrumentGeometryPath

ExtOfAllPlots = ['.txt',$
                 '.rmd',$
                 '_data.sdc',$
                 '_data.bkg',$
                 '_data.sub',$
                 '_norm.sdc',$
                 '_norm.bkg',$
                 '_norm.sub',$
                 '.rtof',$
                 '.crtof']
(*(*global).ExtOfAllPlots) = ExtOfAllPlots

;define Main Base variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

MainBaseSize  = [50,50,1200,885]
MainBaseTitle = 'Reflectometer Data Reduction Package'
MainBaseTitle += VERSION

;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME='MAIN_BASE',$
                         SCR_XSIZE=MainBaseSize[2],$
                         SCR_YSIZE=MainBaseSize[3],$
                         XOFFSET=MainBaseSize[0],$
                         YOFFSET=MainBaseSize[1],$
                         TITLE=MainBaseTitle,$
                         SPACE=0,$
                         XPAD=0,$
                         YPAD=2)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;; Build LOAD-REDUCE-PLOTS-LOGBOOK-SETTINGS tab
; SWITCH (listening) OF
;     'lrac':
;     'mrac': REF
;     'heater': BEGIN
;         MakeGuiMainTab, MAIN_BASE, MainBaseSize, instrument, PlotsTitle
;         Break
;     END
;     else: BEGIN
;         miniMakeGuiMainTab, MAIN_BASE, MainBaseSize, instrument, PlotsTitle
;     END
; ENDSWITCH

MakeGuiMainTab, MAIN_BASE, $
  MainBaseSize, $
  instrument, $
  PlotsTitle, $
  debugger

;hidden widget_text
DataHiddenWidgetText = WIDGET_TEXT(MAIN_BASE,$
                                   XOFFSET = 1,$
                                   YOFFSET = 1,$
                                   /ALL_EVENTS,$
                                   UNAME='data_hidden_widget_text')
(*global).DataHiddenWidgetTextId = DataHiddenWidgetText
(*global).DataHiddenWidgetTextUname = 'data_hidden_widget_text'

NormHiddenWidgetText = WIDGET_TEXT(MAIN_BASE,$
                                   XOFFSET = 1,$
                                   YOFFSET = 1,$
                                   /ALL_EVENTS,$
                                   UNAME='norm_hidden_widget_text')
(*global).NormHiddenWidgetTextId = NormHiddenWidgetText
(*global).NormHiddenWidgetTextUname = 'norm_hidden_widget_text'

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;initialize contrast droplist
id = widget_info(Main_base,Find_by_Uname='data_contrast_droplist')
widget_control, id, set_droplist_select=(*global).InitialDataContrastDropList
id = widget_info(Main_base,Find_by_Uname='normalization_contrast_droplist')
widget_control, id, set_droplist_select=(*global).InitialNormContrastDropList
id = widget_info(Main_base,Find_by_Uname='data_loadct_1d_3d_droplist')
widget_control, id, set_droplist_select=(*global).InitialData1d3DContrastDropList
id = widget_info(Main_base,Find_by_Uname='normalization_loadct_1d_3d_droplist')
widget_control, id, set_droplist_select=(*global).InitialNorm1d3DContrastDropList
id = widget_info(Main_base,Find_by_Uname='data_loadct_2d_3d_droplist')
widget_control, id, set_droplist_select=(*global).InitialData2d3DContrastDropList
id = widget_info(Main_base,Find_by_Uname='normalization_loadct_2d_3d_droplist')
widget_control, id, set_droplist_select=(*global).InitialNorm2d3DContrastDropList

;initialize CommandLineOutput widgets (path and file name)
id = widget_info(Main_base, find_by_uname='cl_directory_text')
widget_control, id, set_value=(*global).cl_output_path
time = RefReduction_GenerateIsoTimeStamp()
file_name = (*global).cl_file_ext1 + time + (*global).cl_file_ext2
id = widget_info(Main_Base, find_by_uname='cl_file_text')
widget_control, id, set_value=file_name

IF (ucams EQ 'j35' OR $
    ucams EQ '2zr') THEN BEGIN
    id = widget_info(MAIN_BASE,find_by_uname='reduce_cmd_line_preview')
    widget_control, id, /editable
ENDIF

; default tabs shown
id1 = widget_info(MAIN_BASE, find_by_uname='main_tab')
widget_control, id1, set_tab_current = 0 ;batch mode

; id2 = widget_info(MAIN_BASE, find_by_uname='data_normalization_tab')
; widget_control, id2, set_tab_current = 1  ;NORMALIZATION

; id3 = widget_info(MAIN_BASE, find_by_uname='load_data_d_dd_tab')
; widget_control, id3, set_tab_current = 3  ;Y vs X (2D)

;id4 = widget_info(MAIN_BASE, find_by_uname='data_back_peak_rescale_tab')
;widget_control, id4, set_tab_current = 3 ;ouput ascii file

;populate batch table for debugging only
; BatchTable[*,0] = ['YES', $
;                    '5225,5454', $
;                    '3443', $
;                    '0.345', $
;                    '0.15', $
;                    '0.15', $
;                    '2008y_02m_19d_01h_15mn', $
;                    'reflect_reduction 5225 5454 --norm=3443']
; BatchTable[*,1] = ['NO', $
;                    '7545,5225,5454', $
;                    '3443', $
;                    '0.345', $
;                    '0.15', $
;                    '0.15', $
;                    '2008y_02m_19d_01h_15mn', $
;                    'reflect_reduction 5225 5454 --norm=3443']
; BatchTable[*,2] = ['NO', $
;                    '6000,7000,5225,5454', $
;                    '3443', $
;                    '0.345', $
;                    '0.15', $
;                    '0.15', $
;                    '2008y_02m_19d_01h_15mn', $
;                    'reflect_reduction 5225 5454 --norm=3443']
; BatchTable[*,3] = ['> YES <', $
;                    '5225,10000,5454', $
;                    '3443', $
;                    '0.345', $
;                    '0.15', $
;                    '0.15', $
;                    '2008y_02m_19d_01h_15mn', $
;                    'reflect_reduction 5225 5454 --norm=3443']
; (*(*global).BatchTable) = BatchTable

; id = widget_info(Main_base,find_by_uname='batch_table_widget')
; widget_control, id, set_value=BatchTable
 
; id = widget_info(Main_base,find_by_uname='save_as_file_name')
; widget_control, id, set_value='REF_L_Batch_Run4000_2008y_02m_26d.txt'

END


; Empty stub procedure used for autoloading.
pro ref_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;check instrument here
spawn, 'hostname',listening
CASE (listening) OF
    'lrac': instrument = 'REF_L'
    'mrac': instrument = 'REF_M'
    'heater': instrument = 'UNDEFINED'
    else: instrument = 'UNDEFINED'
ENDCASE

if (instrument EQ 'UNDEFINED') then begin
    BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
endif else begin
    BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument
endelse
end





