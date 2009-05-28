PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  cd, current=current_folder
  
  APPLICATION = 'plotInstrument'
  VERSION     = '1.0'
  
  ;define initial global values - these could be input via external file or other
  ;means
  
  ;get ucams of user if running on linux
  ;ucams = get_ucams()
  
  ;get hostname
  spawn, 'hostname', hostname
  CASE (hostname) OF
    'heater'       : instrumentIndex = 0
    'bac.sns.gov'  : instrumentIndex = 1
    'bac2'         : instrumentIndex = 1
    'snap'         : instrumentIndex = 2
    'lrac'         : instrumentIndex = 3
    'mrac'         : instrumentIndex = 4
    'arcs1'        : instrumentIndex = 5
    'arcs2'        : instrumentIndex = 5
  ELSE           : instrumentIndex = 0
ENDCASE

ListOFInstruments = ['BSS',$
  'SNAP',$
  'REF_L',$
  'REF_M',$
  'ARCS',$
  'LENS']
  
;define global variables
global = ptr_new ({ ListOfInstruments     : ListOfInstruments,$
  LogBookPath           : '/SNS/users/LogBook/',$
  DeployedVersion       : 1,$
  InstrumentSelected    : instrumentIndex,$
  ;ucams                 : ucams,$
  processing            : '(PROCESSING)',$
  ok                    : 'OK',$
  failed                : 'FAILED',$
  RunNumber             : '',$
  BrowseNexusDefaultExt : '.nxs',$
  BrowseDefaultPath     : '~/',$
  BrowseFilter          : '*.nxs',$
  BrowseROIExt          : '.dat',$
  BrowseROIPath         : '~/',$
  BrowseROIFilter       : '*.dat',$
  ValidNexus            : 0,$
  version               : VERSION })
  
;IF (ucams EQ 'dfp') THEN BEGIN
;  MainBaseSize  = [30,25,540,700]
;ENDIF ELSE BEGIN
;  MainBaseSize  = [30,25,540,445]
;ENDELSE

MainBaseSize  = [30,25,540,700]

MainBaseTitle = 'PlotInstrument'

MainBaseTitle += ' - ' + VERSION

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

;confirmation base
MakeGuiMainBase, MAIN_BASE, global

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK


;logger message
logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
logger_message += APPLICATION + '_' + VERSION + ' ' ;+ ucams
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
  CATCH,/CANCEL
ENDIF ELSE BEGIN
  spawn, logger_message
ENDELSE

END

; Empty stub procedure used for autoloading.
pro plot_Instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





