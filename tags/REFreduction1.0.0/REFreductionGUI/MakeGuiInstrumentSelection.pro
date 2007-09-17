PRO MakeGuiInstrumentSelection, wGroup

InstrumentSelectionBaseSize = [400,300,240,140]
InstrumentSelectioncwbgroupSize = [10,5]
InstrumentSelectioncwbgroupTitle = 'SELECT YOUR INSTRUMENT'
InstrumentList = ['Liquids Reflectometer (REF_L)',$
                  'Magnetism Reflectometer (REF_M)']
InstrumentSelectionGoButtonSize = [10,100,220,30]
InstrumentSelectionGoButtontitle = 'VALIDATE INSTRUMENT'

;Build GUI
MAIN_BASE = widget_base(GROUP_LEADER=wGroup,$
                       xoffset=InstrumentSelectionBaseSize[0],$
                       yoffset=InstrumentSelectionBaseSize[1],$
                       scr_xsize=InstrumentSelectionBaseSize[2],$
                       scr_ysize=InstrumentSelectionBaseSize[3],$
                       Title = 'Instument Selection',$
                       SPACE=0,$
                       XPAD=0,$
                       YPAD=0,$
                       uname='MAIN_BASE',$
                       frame=2)
global = ptr_new ()

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

InstrumentCWBgroup = cw_bgroup(MAIN_BASE,$
                               InstrumentList,$
                               /exclusive,$
                               xoffset=InstrumentSelectioncwbgroupSize[0],$
                               yoffset=InstrumentSelectioncwbgroupSize[1],$
                               set_value=0,$
                               uname='instrument_selection_cw_bgroup',$
                               column=1,$
                               label_top=InstrumentSelectioncwbgroupTitle)

InstrumentSelectionGoButton = $
   widget_button(MAIN_BASE,$
                 xoffset=InstrumentSelectionGoButtonSize[0],$
                 yoffset=InstrumentSelectionGoButtonSize[1],$
                 scr_xsize=InstrumentSelectionGoButtonSize[2],$
                 scr_ysize=InstrumentSelectionGoButtonSize[3],$
                 value=InstrumentSelectionGoButtonTitle,$
                 uname='instrument_selection_validate_button')

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

END
