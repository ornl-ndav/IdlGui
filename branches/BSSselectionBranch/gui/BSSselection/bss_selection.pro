PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

VERSION = 'VERSION: BSSselection1.0.3'

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({ $
                    nexus_full_path : '/Users/j35/SVN/HistoTool/branches/BSSselectionBranch/NeXus/BSS/BSS_246.nxs',$
  processing : 'PROCESSING',$
  PrevLinLogValue : 0,$ 
;previously saved lin or log counts vs tof scale
  PrevFullLinLogValue : 0,$ 
;previously saved lin or log full counts vs tof scale
  full_counts_vs_tof_data : ptr_new(0L),$ 
;counts vs tof of full selected pixels
  output_full_counts_vs_tof_legend : '#TOF(microS) Counts errCounts',$
  CountsVsTofAsciiArray : ptr_new(0L),$
  PreviewCountsVsTofAsciiArray : ptr_new(0L),$   
  OutputMessageToAdd : '',$ ;message to add in output counts vs tof ascii file
  PrevExcludedSymbol : 0,$
  ColorSelectedPixel : 100,$
  ColorVerticalGrid : 85,$
  ColorHorizontalGrid : 85,$
  ColorExcludedPixels : 150,$
  LoadctMainPlot : 5,$
  DefaultColorVerticalGrid : 85,$
  DefaultColorHorizontalGrid : 85,$
  DefaultColorExcludedPixels : 150,$
  DefaultLoadctMainPlot : 5,$
  BSSselectionVersion : version,$ ;version of current program
  ucams : ucams,$               ;ucams of user
  previous_tab : 0,$            ;default tab is 0 (Selection big tab)
  previous_counts_vs_tof_tab : 0,$ ;default counts vs tof tab is 0
  RunNumber : 0L, $             ;NeXus run number
  NexusFullName : '',$          ;Full nexus file name
  roi_path : '~/local/',$       ;path where to save the ROI file
  counts_vs_tof_path : '~/local/',$ 
;path where to save the counts vs tof ascii file
  roi_ext : '_ROI.dat' ,$         ;extension of ROI files
  counts_vs_tof_ext : '_IvsTOF.txt' ,$ ;extension of ROI files
  roi_default_file_name : '',$  ;default roi file name
  ROI_error_status : 0,$        ;error status of the ROI process
  RoiPreviewArray : [0,10,50,100],$ ;roi array
  counts_vs_tof_x : 0L,$        ;x of actual counts vs tof plotted
  counts_vs_tof_y : 0L,$        ;y of actual counts vs tof plotted
  counts_vs_tof_bank : 0,$      ;bank of actual counts vs tof plotted
  true_x_min : 0.0000001,$      ;tof min for counts vs tof zoom plot
  true_x_max : 0.0000001,$      ;tof max for counts vs tof zoom plot
  true_full_x_min : 0.0000001,$ 
;tof min for full counts vs tof zoom plot
  true_full_x_max : 0.0000001,$ 
;tof max for full counts vs tof zoom plot
  NbTOF : 0L,$                    ;number of tof for counts vs tof plot
  NeXusFound : 0,$ 
;0: nexus has not been found, 1 nexus has been found
  ok : 'OK',$
  failed : 'FAILED',$
  bank1: ptr_new(0L),$          ;array of bank1 data (Ntof, Nx, Ny)
  bank1_sum: ptr_new(0L),$      ;array of bank1 data (Nx, Ny)
  bank2: ptr_new(0L),$          ;array of bank2 data (Ntof, Nx, Ny)
  bank2_sum: ptr_new(0L),$      ;array of bank2 data (Nx, Ny)
  pixel_excluded : ptr_new(0L),$ ;list of pixel excluded 
  pixel_excluded_size : 64*2*64L,$ ; total number of pixels
  TotalPixels : 8192L,$         ;Total number of pixels
  TotalRows   : 128L,$          ;total number of rows
  TotalTubes  : 128L,$          ;total number of tubes
  nexus_bank1_path : '/entry/bank1/data',$ ;nxdir path to bank1 data
  nexus_bank2_path : '/entry/bank2/data',$ ;nxdir path to bank2 data
  tof_path : '/entry/bank1/time_of_flight',$ nxdir path to tof data
  Nx : 56,$
  Ny : 64,$
  Xfactor : 13,$          ;coefficient in X direction for rebining img
  Yfactor : 5,$          ; coefficient in Y direction for rebining img
  LogBookPath : '/SNS/users/j35/IDL_LogBook/',$ ;path where to put the log book
  DefaultPath : '~/local/BSS/',$ ;default path where to look for the file
  DefaultFilter : '*.nxs'$      ;default filter for the nexus file

  })

Device, /decomposed
loadct, (*global).DefaultLoadctMainPlot

XYfactor                    = {Xfactor:(*global).Xfactor, Yfactor:(*global).Yfactor}
pixel_excluded              = intarr((*global).pixel_excluded_size)
(*(*global).pixel_excluded) = pixel_excluded

MainBaseSize  = [50,200,1200,730]
MainBaseTitle = 'BSS selection tool'
        
;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER = wGroup,$
                         UNAME        = 'MAIN_BASE',$
                         SCR_XSIZE    = MainBaseSize[2],$
                         SCR_YSIZE    = MainBaseSize[3],$
                         XOFFSET      = MainBaseSize[0],$
                         YOFFSET      = MainBaseSize[1],$
                         TITLE        = MainBaseTitle,$
                         SPACE        = 0,$
                         XPAD         = 0,$
                         YPAD         = 2)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;add version to program
version_label = widget_label(MAIN_BASE,$
                             XOFFSET = 1035,$
                             YOFFSET = 2,$
                             VALUE   = VERSION,$
                             FRAME   = 0)

MakeGuiMainTab, MAIN_BASE, MainBaseSize, XYfactor

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

; initialize slider (Grid: Vertical Lines)
id = widget_info(Main_base,Find_by_Uname='color_slider')
widget_control, id, set_value = (*global).ColorVerticalGrid

;default tabs shown
id1 = widget_info(MAIN_BASE, find_by_uname='main_tab')
widget_control, id1, set_tab_current = 1 ;reduce

;tab #4
id1 = widget_info(MAIN_BASE, find_by_uname='reduce_input_tab')
widget_control, id1, set_tab_current = 3

END


; Empty stub procedure used for autoloading.
pro bss_selection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





