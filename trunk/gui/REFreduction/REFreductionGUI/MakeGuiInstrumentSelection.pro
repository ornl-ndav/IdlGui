PRO MakeGuiInstrumentSelection, MAIN_BASE
InstrumentSelectionBaseSize = [400,300,240,140]
InstrumentSelectioncwbgroupSize = [10,5]
InstrumentSelectioncwbgroupTitle = 'SELECT YOUR INSTRUMENT'
InstrumentList = ['Liquids Reflectometer (REF_L)',$
                  'Magnetism Reflectometer (REF_M)']
InstrumentSelectionGoButtonSize = [10,100,220,30]
InstrumentSelectionGoButtontitle = 'VALIDATE INSTRUMENT'

;Build GUI
InstrumentSelectionBase = widget_base(MAIN_BASE,$
                                      xoffset=InstrumentSelectionBaseSize[0],$
                                      yoffset=InstrumentSelectionBaseSize[1],$
                                      scr_xsize=InstrumentSelectionBaseSize[2],$
                                      scr_ysize=InstrumentSelectionBaseSize[3],$
                                      map=1,$
                                      uname='instrument_selection_base',$
                                      frame=2)

InstrumentCWBgroup = cw_bgroup(InstrumentSelectionBase,$
                               InstrumentList,$
                               /exclusive,$
                               xoffset=InstrumentSelectioncwbgroupSize[0],$
                               yoffset=InstrumentSelectioncwbgroupSize[1],$
                               set_value=0,$
                               uname='instrument_selection_cw_bgroup',$
                               column=1,$
                               label_top=InstrumentSelectioncwbgroupTitle)

InstrumentSelectionGoButton = $
   widget_button(InstrumentSelectionBase,$
                 xoffset=InstrumentSelectionGoButtonSize[0],$
                 yoffset=InstrumentSelectionGoButtonSize[1],$
                 scr_xsize=InstrumentSelectionGoButtonSize[2],$
                 scr_ysize=InstrumentSelectionGoButtonSize[3],$
                 value=InstrumentSelectionGoButtonTitle,$
                 uname='instrument_selection_validate_button')

END
