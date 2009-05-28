PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  ;cd, current=current_folder

  APPLICATION = 'plotCNCS'
  VERSION     = '1.0.0'
  DEBUGGING   = 'yes'
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  if (!VERSION.os EQ 'darwin') then begin
    ucams = 'j35'
  endif else begin
    ucams = get_ucams()
  endelse
  
  ;get hostname
  SPAWN, 'hostname', hostname
  
  ;define global variables
  global = ptr_new ({ ucams                   : ucams,$
    HistoNexusTabSelected   : 0,$
    browse_nexus_path       : '/SNS/CNCS/',$
    browse_OR_list_all_flag : 0,$
    bin_width               : '200',$
    runinfoFileName         : '',$
    img                     : PTR_NEW(0L),$
    nbr_pixel               : 117760L,$
    version                 : VERSION,$
    LogBookPath             : '/SNS/users/LogBook/',$
    staging_folder          : '~/.plotCNCS_tmp/',$
    mapping_list_mac        : ['./mapping/CNCS_TS_2007_10_10.dat'],$
    event_file_filter       : '*_neutron_event.dat',$
    histo_map_filter        : '*_neutron_histo_mapped.dat',$
    default_extension       : '.dat',$
    event_filter            : '*neutron_event.dat',$
    mac_arcs_folder         : './MAC-DAS-FS/CNCS_1/',$
    ;for mac use only
    processing              : '(PROCESSING)',$
    ok                      : 'OK',$
    failed                  : 'FAILED',$
    status                  : 'STATUS: ',$
    neutron_event_dat_ext   : '_neutron_event.dat',$
    debugger                : 'j35'})
    
  IF (ucams EQ (*global).debugger) THEN BEGIN
    MainBaseSize  = [30,25,700,740]
  ENDIF ELSE BEGIN
    MainBaseSize  = [30,25,700,560]
  ENDELSE
  MainBaseTitle = 'Plot CNCS'
  MainBaseTitle += ' - ' + VERSION
  
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
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
  WIDGET_CONTROL, MAIN_BASE, set_uvalue=global
  
  ;Create main base
  MakeGuiInputBase, MAIN_BASE, MainBaseSize
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  ;XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='gg_Cleanup'
  
  ;if it's on mac, fill up run number with 1
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    id = WIDGET_INFO(Main_base,find_by_uname='run_number')
    WIDGET_CONTROL, id, set_value = '1'
  ENDIF
  
  ;populate mapping droplist
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    MapArray = (*global).mapping_list_mac
  ENDIF ELSE BEGIN
    MapArray = getMappingFileList()
  ENDELSE
  id = WIDGET_INFO(MAIN_BASE, find_by_uname='mapping_droplist')
  WIDGET_CONTROL, id, set_value=MapArray
  
  IF (DEBUGGING EQ 'yes') THEN BEGIN
    (*global).browse_nexus_path = '~/402/NeXus/'
  ENDIF
  
  ;logger message
  logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
  logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    SPAWN, logger_message
  ENDELSE
  
END


; Empty stub procedure used for autoloading.
pro plot_cncs, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





