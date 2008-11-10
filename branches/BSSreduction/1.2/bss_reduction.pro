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

PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;==============================================================================
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
APPLICATION        = 'BSSreduction'
VERSION            = '1.2.20'
DeployedVersion    = 'yes'
DEBUGGING_VERSION  = 'yes'
CHECKING_PACKAGES  = 'yes'
PACKAGE_REQUIRED_BASE = { driver:           '',$
                          version_required: '',$
                          found: 0,$
                          sub_pkg_version:   ''}

;DEBUGGING (enter the tab you want to see)
;(main_tab): 0: Selection
;            1: Reduce (reduce_input_tab)
;               0: 1) Input
;               1: 2) Input
;               2: 3) Setup
;               3: 4) Time-Index. Back.
;               4: 5) Lambda-Dep. Back.
;               5: 6) Scaling Cst.
;               6: 7) Data Control
;               7: 8) Output
;            2: Output
;            3: Log Book 

sDEBUGGING = { tab: {main_tab: 2,$
                     reduce_input_tab: 4},$
               reduce: {input1: { uname: 'rsdf_list_of_runs_text',$
                                  value: $
                                  '/SNS/BSS/IPTS-493/7/638/' + $
                                  'NeXus/BSS_638.nxs'},$
                        input2: { uname: 'proif_text',$
                                  value: $
                                  '/SNS/users/j35/BASIS_350_2008y_10m_30d_'+$
                                  '16h_43mn_ROI.dat'},$
                        input3: { uname: 'eha_min_text',$ ;7)Data Control
                                  value: '-200'},$
                        input4: { uname: 'eha_max_text',$
                                  value: '200'},$
                        input5: { uname: 'eha_bin_text',$
                                  value: '.4'},$
                        input6: { uname: 'mtha_min_text',$
                                  value: '0'},$
                        input7: { uname: 'mtha_max_text',$
                                  value: '2'},$
                        input8: { uname: 'mtha_bin_text',$
                                  value: '.1'},$
                        input9: { uname: 'pte_min_text',$
                                  value: '180'},$
                        input10: { uname: 'pte_max_text',$
                                   value: '200'},$
                        input11: { uname: 'pte_bin_text',$
                                   value: '0.4'},$
                        input12: { uname: $
                                   'detailed_balance_temperature_value',$
                                   value: '300'},$
                        input13: { uname: 'ratio_tolerance_value',$
                                   value: '0.001'},$
                        input14: { uname: 'max_wave_dependent_back',$
                                   value: '1E-10'},$
                        input15: { uname: 'chopper_frequency_value',$
                                   value: '30'},$
                        input16: { uname: 'chopper_wavelength_value',$
                                   value: '6.4'},$
                        input17: { uname: 'tof_least_background_value',$
                                   value: '154000'}}}

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
;==============================================================================

;define initial global values - these could be input via external file or
;other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({ $
                    TreeBase: 0L,$
                    TreeID: 0L,$
                    RootID: 0L,$
                    config_file_name: '~/.bss_reduction.cfg',$
                    lds_mode: 0,$
                    output_plot_path: '~/result/',$ 
                    findlivenexus: '/SNS/software/sbin/findlivenexus',$
                    default_output_path: '~/result/',$
                    negative_cosine_polar_array: STRARR(3),$
                    momentum_transfer_array:     STRARR(3),$
                    DeployedVersion: DeployedVersion,$
                    DriverName: 'amorphous_reduction_sqe',$
                    iterative_background_DriverName: 'find_ldb',$
                    DRstatusOK: 'Data Reduction ... DONE',$
                    DRstatusFAILED: 'Data Reduction ... ERROR! ' + $
                    '(-> Check Log Book)',$
                    unit: 0,$
                    BSSreductionVersion: VERSION,$
                    DR_xml_config_ext: '.rmd',$
                    DR_xml_config_file: '',$
                    ListOfOutputPlots: {woctib_button: 0,$
                                         wopws_button: 0,$
                                         womws_button: 0,$
                                         womes_button: 0,$
                                         worms_button: 0,$
                                         wocpsamn_button: 0,$
                                         wolidsb_button: 0},$
                    NameOfOutputPlots: {woctib_button: $
                                         'Calculated Time-Independent' + $
                                         ' Background', $
                                         wopws_button: $
                                         'Pixel Wavelength Spectrum',$
                                         womws_button: $
                                         'Monitor Wavelength Spectrum',$
                                         womes_button: $
                                         'Monitor Efficiency Spectrum',$
                                         worms_button: $
                                         'Rebinned Monitor Spectrum',$
                                         wocpsamn_button: $
                                         'Combined Pixel Spectrum' + $
                                         ' After Monitor Normalization',$
                                         wopies_button: $
                                         'Pixel Initial Energy Spectrum',$
                                         wopets_button: $
                                         'Pixel Energy Transfer Spectrum',$
                                         wolidsb_button: $
                                         'linearly Interpolated Direct' + $
                                         ' Scattering Back. Info. ' + $
                                         'Summed over all Pixels'},$
                    OutputPlotsExt: {woctib: '_data.tib',$
                                     wopws: '_data.pxl',$
                                     womws: '_data.mxl',$
                                     womes: '_data.mel',$
                                     worms: '_data.mrl',$
                                     wocpsamn: '_data.pml',$
                                     wopies: '_data.ixl',$
                                     wopets: '_data.exl',$
                                     wolidsb: '_data.lin'},$
                    MainDRPlotsExt: { sqe: '.txt'},$
                    FullNameOutputPlots: ptr_new(0L),$
                    WidgetsToActivate: ptr_new(0L),$
                    LoadingConfig: 1,$ ;will be 1 after loading config file
                    DefaultConfigFileName: '~/.bss_reduction.cfg',$ 
                    instrument: 'BSS',$
                    nexus_path: '/SNS/BSS/',$
                    nexus_geometry_path: '/SNS/BSS/2006_1_2_CAL/' + $
                    'calibrations/',$
                    nexus_ext: '.nxs',$
                    nexus_full_path: $
                    '/Users/j35/SVN/HistoTool/branches/' + $
                    'BSSreductionBranch/NeXus/BSS/BSS_246.nxs',$
                    processing: 'PROCESSING',$
                    PrevLinLogValue: 0,$ ;previously saved lin
                                ;or log counts vs tof scale
                    PrevFullLinLogValue: 0,$       ;previously saved
                                ;lin or log full counts vs tof scale
                    full_counts_vs_tof_data: ptr_new(0L),$ ;counts vs
                                ;tof of full selected pixels
                    output_full_counts_vs_tof_legend: '#TOF(microS) ' + $
                      'Counts errCounts',$
                    CountsVsTofAsciiArray: ptr_new(0L),$
                    PreviewCountsVsTofAsciiArray: ptr_new(0L),$   
                      OutputMessageToAdd: '',$ ;message to add in
                                ;output counts vs tof ascii file
                    PrevExcludedSymbol: 0,$
                    ColorSelectedPixel: 100,$
                    ColorVerticalGrid: 85,$
                    ColorHorizontalGrid: 85,$
                    ColorExcludedPixels: 150,$
                    LoadctMainPlot: 5,$
                    DefaultColorVerticalGrid: 85,$
                    DefaultColorHorizontalGrid: 85,$
                    DefaultColorExcludedPixels: 150,$
                    DefaultLoadctMainPlot: 5,$
                    BSSselectionVersion: version,$ ;version of current program
                    ucams: ucams,$ ;ucams of user
                    previous_tab: 0,$ ;default tab is 0 (Selection big tab)
                      previous_counts_vs_tof_tab: 0,$ ;default counts
                                ;vs tof tab is 0
                    RunNumber: 0L, $ ;NeXus run number
                    NexusFullName: '',$ ;Full nexus file name
                    roi_path: '~/result/',$ ;path where to save the ROI file
                    SavedRoiFullFileName: '',$ ;full file name of ROI file
                      counts_vs_tof_path: '~/result/',$ ;path where to
                                ;save the counts vs tof ascii file
                    roi_ext: '_ROI.dat' ,$ ;extension of ROI files
                      counts_vs_tof_ext: '_IvsTOF.txt' ,$ ;extension of
                                ;ROI files
                    roi_default_file_name: '',$ ;default roi file name
                    ROI_error_status: 0,$ ;error status of the ROI process
                    RoiPreviewArray: [0,10,50,100],$ ;roi array
                    counts_vs_tof_x: 0L,$ ;x of actual counts vs tof plotted
                    counts_vs_tof_y: 0L,$ ;y of actual counts vs tof plotted
                      counts_vs_tof_bank: 0,$ ;bank of actual counts vs
                                ;tof plotted
                    true_x_min: 0.0000001,$ ;tof min for counts vs tof
                                ;zoom plot
                    true_x_max: 0.0000001,$ ;tof max for counts vs tof
                                ;zoom plot
                    true_full_x_min: 0.0000001,$ ;tof min for full counts
                                ;vs tof zoom plot
                    tmp_true_full_x_min: 0.00000001, $
                      true_full_x_max: 0.0000001,$ ;tof max for full counts
                                ;vs tof zoom plot
                    NbTOF: 0L,$ ;number of tof for counts vs tof plot
                      NeXusFound: 0,$ ;0: nexus has not been found, 1 nexus
                                ;has been found
                    NeXusFormatWrong: 0,$ ;if we are trying to open using hdf4
                    ok: 'OK',$
                    failed: 'FAILED',$
                    bank1: ptr_new(0L),$ ;array of bank1 data (Ntof, Nx, Ny)
                    bank1_sum: ptr_new(0L),$ ;array of bank1 data (Nx, Ny)
                    bank2: ptr_new(0L),$ ;array of bank2 data (Ntof, Nx, Ny)
                    bank2_sum: ptr_new(0L),$ ;array of bank2 data (Nx, Ny)
                    pixel_excluded: ptr_new(0L),$ ;list of pixel excluded 
                    pixel_excluded_base: ptr_new(0L),$
 ;list of pixel excluded without counts removing
                    default_pixel_excluded: ptr_new(0L),$
                    pixel_excluded_size: 64*2*64L,$ ; total number of pixels
                    TotalPixels: 8192L,$ ;Total number of pixels
                    TotalRows: 128L,$ ;total number of rows
                    TotalTubes: 128L,$ ;total number of tubes
                      nexus_bank1_path: '/entry/bank1/data',$ ;nxdir path
                                ;to bank1 data
                    nexus_bank2_path: '/entry/bank2/data',$ ;nxdir path
                                ;to bank2 data
                    tof_path: '/entry/bank1/time_of_flight',$ ;nxdir path $
                      ;to tof data
                    Nx: 56,$
                    Ny: 64,$
                    Xfactor: 13,$ ;coefficient in X direction for rebining img
                    Yfactor: 5,$ ; coefficient in Y direction for rebining img
                      LogBookPath: '/SNS/users/LogBook/',$ ;path where
                                ;to put the log book
                    DefaultPath: '~/local/BSS/',$ ;default path where
                                ;to look for the file
                    DefaultFilter: '*.nxs',$ ;default filter for the
                                ;nexus file
                    Configuration: { Input: {nexus_run_number: '',$
                                               ColorVerticalGrid: 85,$
                                               ColorHorizontalGrid: 85,$
                                               ColorExcludedPixels: 150,$
                                               ColorSelectedPixel: 100,$
                                               loadct_droplist: 5,$
                                               excluded_pixel_type: 0},$
                                      Reduce: $
                                      {tab1: { rsdf_list_of_runs_text: '',$
                                                rsdf_multiple_runs_button: 0,$
                                                bdf_list_of_runs_text: '',$
                                                ndf_list_of_runs_text: '',$
                                                ecdf_list_of_runs_text: '',$
                                                dsb_list_of_runs_text: ''},$
                                       tab2: { proif_text: '',$
                                                aig_list_of_runs_text: '',$
                                                of_list_of_runs_text: ''},$
                                       tab3: { rmcnf_button: 0,$
                                                verbose_button: 0,$
                                                absm_button: 0,$
                                                nmn_button: 0,$
                                                nmec_button: 0,$
                                                niw_button: 0,$
                                                nisw_field: '',$
                                                niew_field: '',$
                                                te_button: 0,$
                                                te_low_field: '',$
                                                te_high_field: ''},$
                                       tab4: { tib_tof_button: 0,$
                                                tibtof_channel1_text: '',$
                                                tibtof_channel2_text: '',$
                                                tibtof_channel3_text: '',$
                                                tibtof_channel4_text: '',$
                                                tibc_for_sd_button: 0,$
                                                tibc_for_sd_value_text: '',$
                                                tibc_for_sd_error_text: '',$
                                                tibc_for_bd_button: 0,$
                                                tibc_for_bd_value_text: '',$
                                                tibc_for_bd_error_text: '',$
                                                tibc_for_nd_button: 0,$
                                                tibc_for_nd_value_text: '',$
                                                tibc_for_nd_error_text: '',$
                                                tibc_for_ecd_button: 0,$
                                                tibc_for_ecd_value_text: '',$
                                                tibc_for_ecd_error_text: '',$
                                                tibc_for_scatd_button : 0,$
                                                tibc_for_scatd_value_text: '',$
                                                tibc_for_scatd_error_text: ''},$
                                       tab5: {a:0},$
                                       tab6: { csbss_button: 0,$
                                                csbss_value_text: '',$
                                                csbss_error_text: '',$
                                                csn_button: 0,$
                                                csn_value_text: '',$
                                                csn_error_text: '',$
                                                bcs_button: 0,$
                                                bcs_value_text: '',$
                                                bcs_error_text: '',$
                                                bcn_button: 0,$
                                                bcn_value_text: '',$
                                                bcn_error_text: '',$
                                                cs_button: 0,$
                                                cs_value_text: '',$
                                                cs_error_text: '',$
                                                cn_button: 0,$
                                                cn_value_text: '',$
                                                cn_error_text: ''},$
                                       tab7: { tzsp_button: 0,$ ;Data Control
                                                tzsp_value_text: '',$
                                                tzsp_error_text: '',$
                                                tzop_button: 0,$
                                                tzop_value_text: '',$
                                                tzop_error_text: '',$
                                                eha_min_text: '',$
                                                eha_max_text: '',$
                                                eha_bin_text: '',$
                                                gifw_button: 0,$
                                                gifw_value_text: '',$
                                                gifw_error_text: '',$
                                                mtha_min_text: '',$
                                                mtha_max_text:'',$
                                                mtha_bin_text:'',$
                                                tof_cutting_button: 0,$
                                                tof_cutting_min_text: '',$
                                                tof_cutting_max_text: ''},$
                                       tab8: { waio_button: 0,$
                                                woctib_button: 0,$
                                                wopws_button: 0,$
                                                womws_button: 0,$
                                                womes_button: 0,$
                                                worms_button: 0,$
                                                wocpsamn_button: 0,$
                                                wa_min_text: '',$
                                                wa_max_text: '',$
                                                wa_bin_width_text: '',$
                                                wopies_button: 0,$
                                                wopets_button: 0,$
                                                wolidsb_button: 0,$
                                                wodwsm_button: 0}}}$
                      })
                    
;sub_pkg_version: python program that gives pkg v. of common libraries...etc
my_package = REPLICATE(PACKAGE_REQUIRED_BASE,3);number of packages we need to check
my_package[0].driver           = 'findnexus'
my_package[0].version_required = '1.5'
my_package[1].driver           = (*global).DriverName
my_package[1].version_required = '1.0'
my_package[1].sub_pkg_version  = './drversion'
my_package[2].driver           = (*global).iterative_background_DriverName
my_package[2].version_required = '1.0'

(*global).negative_cosine_polar_array = ['-1.0','1.0','0.5']

Device, /decomposed
loadct, (*global).DefaultLoadctMainPlot

XYfactor               = {Xfactor:(*global).Xfactor, $
                          Yfactor:(*global).Yfactor}
default_pixel_excluded = intarr((*global).pixel_excluded_size)

;Define Default Exclusion ROI file
FOR j=0,1 DO BEGIN ;bank1 and bank2
;Exclude tubes 56-63 and 120-127
    FOR i=3584L,4095L DO BEGIN
        default_pixel_excluded[i+j*4096L]=1
    ENDFOR
ENDFOR

list1 = indgen(6)               ;row 0-6
list2 = indgen(63-48)+49        ;row 49-63
list3 = indgen(15)+4096L        ;row 64-78
list4 = indgen(63-57)+58+4096L  ;row 122-127

FOR i=1,55 DO BEGIN
    list1 = [list1, indgen(6) + i*64]
    list2 = [list2, indgen(63-48)+49 + i*64]
    list3 = [list3, indgen(15)+4096L + i*64]
    list4 = [list4, indgen(63-57)+58+4096L + i*64]
ENDFOR

default_pixel_excluded[[list1,list2,list3,list4]] = 1
    
(*(*global).default_pixel_excluded) = default_pixel_excluded
(*(*global).pixel_excluded)         = default_pixel_excluded
(*(*global).pixel_excluded_base)    = default_pixel_excluded

(*(*global).WidgetsToActivate) = ['load_roi_file_button',$
                                  'save_roi_file_button',$
                                  'roi_path_button',$
                                  'roi_file_name_generator',$
                                  'xbase',$
                                  'ybase',$
                                  'bank_base',$
                                  'tube_base',$
                                  'row_base',$
                                  'pixelid_base',$
                                  'counts_base',$
                                  'color_index_base',$
                                  'color_slider_base',$
                                  'color_base',$
                                  'counts_vs_tof_tab2',$
                                  'counts_vs_tof_tab1',$
                                  'fbase',$
                                  'sbase',$
                                  'abase',$
                                  'symbol_base',$
                                  'ebase',$
                                  'exclusion_base',$
                                  'reset_button']
    
if (!VERSION.os EQ 'darwin') then begin
    MainBaseSize  = [30,25,1200,730]
endif else begin
    MainBaseSize  = [50,200,1200,730]
endelse

MainBaseTitle = 'BSS reduction tool - ' + VERSION
        
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

MakeGuiMainTab, MAIN_BASE, MainBaseSize, XYfactor

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='BSSreduction_Cleanup' 

; initialize slider (Grid: Vertical Lines)
id = widget_info(Main_base,Find_by_Uname='color_slider')
widget_control, id, set_value = (*global).ColorVerticalGrid

;??????????????????????????????????????????????????????????????????????????????
IF (DEBUGGING_VERSION EQ 'yes' ) THEN BEGIN
;tab to show (main_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')    
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.main_tab
;tab to show (pixel_range_selection/scaling_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_input_tab')    
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.reduce_input_tab

;refill gui with information
    nbr = N_TAGS(sDebugging.reduce)
    index =  0
    WHILE (index LT nbr) DO BEGIN
        putTextFieldValue_from_MainBase, MAIN_BASE, $
          sDebugging.reduce.(index).uname,$
          sDebugging.reduce.(index).value
        index++
    ENDWHILE

ENDIF
;??????????????????????????????????????????????????????????????????????????????

;give extra power to j35, 2zr, ele, z3i, eg9
IF (ucams EQ 'j35' OR $
    ucams EQ '2zr' OR $
    ucams EQ 'ele' OR $
    ucams EQ 'z3i' OR $
    ucams EQ 'eg9' OR $
    ucams EQ 'mid') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME= 'command_line_generator_text')
    WIDGET_CONTROL, id, /EDITABLE
ENDIF

;==============================================================================
; Date and Checking Packages routines =========================================
;==============================================================================
;Put date/time when user started application in first line of log book
time_stamp = GenerateIsoTimeStamp()
message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book', $
  message

IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
;Check that the necessary packages are present
    message = '> Checking For Required Software: '
    IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, 'log_book', $
      message
    
    PROCESSING = (*global).processing
    OK         = (*global).ok
    FAILED     = (*global).failed
    NbrSpc     = 25             ;minimum value 4
    
    sz = (size(my_package))(1)
    
    IF (sz GT 0) THEN BEGIN
        max = 0                ;find the longer required software name
        pack_list = STRARR(sz)  ;initialize the list of driver
        missing_packages = STRARR(sz) ;initialize the list of missing packages
        nbr_missing_packages = 0
        FOR k=0,(sz-1) DO BEGIN
            pack_list[k] = my_package[k].driver
            length = STRLEN(pack_list[k])
            IF (length GT max) THEN max = length
        ENDFOR
        
        first_sub_packages_check = 1
        FOR i=0,(sz-1) DO BEGIN
            message = '-> ' + pack_list[i]
;this part is to make sure the PROCESSING string starts at the same column
            length = STRLEN(message)
            str_array = MAKE_ARRAY(NbrSpc+max-length,/STRING,VALUE='.')
            new_string = STRJOIN(str_array)
            message += ' ' + new_string + ' ' + PROCESSING
            
            IDLsendToGeek_addLogBookText_fromMainBase, $
              MAIN_BASE, $
              'log_book', $
              message

            cmd = pack_list[i] + ' --version'
            spawn, cmd, listening, err_listening
            IF (err_listening[0] EQ '') THEN BEGIN ;found
                IDLsendToGeek_ReplaceLogBookText_fromMainBase, $
                  MAIN_BASE, $
                  'log_book', $
                  PROCESSING,$
                  OK + ' (Current Version: ' + $
                  listening[N_ELEMENTS(listening)-1] + ')'
;              ' / Minimum Required Version: ' + $
;              my_package[i].version_required + ')'
                my_package[i].found = 1
                IF (my_package[i].sub_pkg_version NE '') THEN BEGIN
                    IF (first_sub_packages_check EQ 1) THEN BEGIN
                        first_sub_packages_check = 0
                        cmd = my_package[i].sub_pkg_version
                        spawn, cmd, listening, err_listening
                        IF (err_listening[0] EQ '') THEN BEGIN ;worked
                            cmd_txt = '-> ' + cmd + ' ... OK'
                            IDLsendToGeek_addLogBookText_fromMainBase, $
                              MAIN_BASE, $
                              'log_book', $
                              cmd_text
                            IDLsendToGeek_addLogBookText_fromMainBase, $
                              MAIN_BASE, $
                              'log_book', $
                              '--> ' + listening
;tell the structure that the correct version has been found
                            my_package[i].found = 1
                        ENDIF ELSE BEGIN
                            cmd_txt = '-> ' + cmd + ' ... FAILED'
                            IDLsendToGeek_addLogBookText_fromMainBase, $
                              MAIN_BASE, $
                              'log_book', $
                              cmd_text
;tell the structure that the correct version has been found
                            my_package[i].found = 0
                        ENDELSE
                    ENDIF
                ENDIF
            ENDIF ELSE BEGIN    ;missing program
                IDLsendToGeek_ReplaceLogBookText_fromMainBase, $
                  MAIN_BASE, $
                  'log_book', $
                  PROCESSING,$
                  FAILED
;              + ' (Minimum Required Version: ' + $
;              my_package[i].version_required + ')'
                missing_packages[i] = my_package[i].driver
;tell the structure that the correct version has been found
                my_package[i].found = 0
                ++nbr_missing_packages
             ENDELSE
        ENDFOR

        IF (nbr_missing_packages GT 0) THEN BEGIN
;pop up window that show that they are missing packages
            message = ['They are ' + $
                       STRCOMPRESS(nbr_missing_packages,/REMOVE_ALL) + $
                       ' missing package(s) you need to ' + $
                       'fully used this application.']
            message = [message,'Check Log Book For More Information !']
            result = DIALOG_MESSAGE(message, $
                                    /INFORMATION, $
                                    DIALOG_PARENT=MAIN_BASE)
        ENDIF
        
     ENDIF                      ;end of 'if (sz GT 0)'

     message = '=================================================' + $
       '========================'
     IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, $
       'log_book', message
     
 ENDIF

;===============================================================================
;logger message
logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
ENDIF ELSE BEGIN
    spawn, logger_message
ENDELSE

END


; Empty stub procedure used for autoloading.
pro bss_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





