PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  CD, CURRENT = current_folder
  
  ;******************************************************************************
  ;******************************************************************************
  APPLICATION        = 'plotInstrument'
  VERSION            = '1.0.0'
  UCAMS              = "dfp"
  FASCILITY          = 'SNS'
  TESTING            = 1
  pathInstrumentList = '/SNS/software/etc/instrumentlist.xml'
  
  spawn, 'hostname', hostname
  
  
  ;edit hostname to address
  hostname = "computer = " + STRTRIM(hostname, 2) + ".sns.gov"
  ;make an instance of xmlparser
  xmlParser = OBJ_NEW('idlxmlparser', pathInstrumentList)
  ;get the instrument list
  instrumentList = xmlParser -> getValue(location = $
    ['name = ' + fascility, 'instrument'], searchTag = 'shortname')
  ;get the cpuName
  cpuName =  xmlParser -> getValue(location = $
    ['name = ' + fascility, 'instrument'], searchTag = 'shortname', condition = hostname)
    
  ;print, cpuName
    
  ; instConst =  {X: 0,$
  ;  Y: 0,$
  ;    rebinBy: 0}
    
  ;define global variables
  global = PTR_NEW ({path: "", $
    work_path:      "~/",$
    graphed:        0, $
    data:           ptr_new(), $
    fascility:      fascility, $
    application:    APPLICATION,$
    version:        VERSION,$
    ucams:          UCAMS, $
    testing:        testing, $
    cpuName:        cpuName,$
    instConst:      {X: 0, Y: 0, rebinBy: 0}, $
    instrumentList: instrumentList, $
    MainBaseSize:   [30,25,500,250]})
    
  IF testing THEN BEGIN
    (*global).WORK_path = '~/IdlGui/trunk/plotInstrument/NeXus'
  ENDIF
  
  MainBaseSize   = (*global).MainBaseSize
  MainBaseTitle  = APPLICATION + ' - ' + VERSION
  
  ;Build Main Base
  MAIN_BASE = Widget_Base(GROUP_LEADER = wGroup,$
    UNAME        = 'MAIN_BASE',$
    TITLE        = MainBaseTitle,$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    SCR_XSIZE    = MainBaseSize[2],$
    SCR_YSIZE    = MainBaseSize[3],$
    SPACE        = 0,$
    XPAD         = 0,$
    YPAD         = 2)
    
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  ;confirmation base
  MakeGuiMainBase, MAIN_BASE, global
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  
  
  
END

;-----------------------------------------------------------------------------
; Empty stub procedure used for autoloading.
PRO plotInstrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END
