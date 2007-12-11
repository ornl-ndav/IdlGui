PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
cd, current=current_folder

VERSION = 'VERSION: GG1.0.0'

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;Which version to load
;1 is for version that never shows the base #2. It only allows user to
;load the xml files and create the geometry file
versionLight = 1  
;0 is for full version that displays the base #2.

;get hostname
spawn, 'hostname', hostname
CASE (hostname) OF
    'heater': instrumentIndex = 0
    'lrac'  : instrumentIndex = 2
    'mrac'  : instrumentIndex = 3
    'bac1'  : instrumentIndex = 1
    'bac2'  : instrumentIndex = 1
    else    : instrumentIndex = 0
ENDCASE 

;define global variables
global = ptr_new ({ instrumentShortList   : ptr_new(0L),$
                    RunNumber             : '',$
                    output_geometry_ext   : '_geom',$
                    cvinfo_default_path   : '~/',$
                    geometry_default_path : '~/',$
                    geometry_xml_filtering: '*.xml',$
                    cvinfo_xml_filtering  : '*_cvinfo.xml',$
                    default_extension     : 'xml',$
                    version : VERSION })

InstrumentList = ['',$
                  'Backscattering',$
                  'Liquids Reflectometer',$
                  'Magnetism Reflectometer',$
                  'ARCS']
                  
instrumentShortList = ['',$
                       'BSS',$
                       'REF_L',$
                       'REF_M',$
                       'ARCS']
(*(*global).instrumentShortList) = instrumentShortList

images_structure = { images_path : [current_folder,$
                                    'images'],$
                     images : ['numbers.bmp',$
                               'angles.bmp',$
                               'lengths.bmp',$
                               'wavelength.bmp',$
                               'other.bmp']}

MainBaseSize  = [30,25,700,500]
MainBaseTitle = 'Geometry Generator'
        
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

;BASE #2
MakeGuiInputGeometry, $ 
  MAIN_BASE, $
  MainBaseSize, $
  images_structure
;add version to program
VersionLength = strlen(VERSION)
version_label = widget_label(MAIN_BASE,$
                             XOFFSET = MainBaseSize[2]-VersionLength*6.5,$
                             YOFFSET = 2,$
                             VALUE   = VERSION,$
                             FRAME   = 0)

;BASE #1
MakeGuiLoadingGeometry, $
  MAIN_BASE, $
  MainBaseSize, $
  InstrumentList, $
  InstrumentIndex, $
  versionLight

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;populate geometry droplist
GeoArray = getGeometryList(instrumentShortList(instrumentIndex))
id = widget_info(MAIN_BASE, find_by_uname='geometry_droplist')
widget_control, id, set_value=GeoArray
id = widget_info(MAIN_BASE, find_by_uname='geometry_text_field')
widget_control, id, set_value=GeoArray[0]

;????????????????????????? FOR DEVELOPMENT ONLY ??????????????????????????
;;default tabs shown
;id1 = widget_info(MAIN_BASE, find_by_uname='main_tab')
;widget_control, id1, set_tab_current = 1 ;reduce

;;tab #7
;id1 = widget_info(MAIN_BASE, find_by_uname='reduce_input_tab')
;widget_control, id1, set_tab_current = 6
;?????????????????????????????????????????????????????????????????????????

END


; Empty stub procedure used for autoloading.
pro gg, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





