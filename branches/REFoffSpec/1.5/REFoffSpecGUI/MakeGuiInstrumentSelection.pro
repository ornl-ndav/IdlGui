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

;+
; :Description:
;    GUI builder of portal base of main application, where the user
;    select the version (desktop/laptop) and the instrument (REF_L/REF_M)
;
;
;
; :Keywords:
;    version
;    GROUP_LEADER
;    _EXTRA
;
; :Author: j35
;-
PRO MakeGuiInstrumentSelection, version=version, $
GROUP_LEADER=wGroup, $
_EXTRA=_VWBExtra_
compile_opt idl2

; Change code (RC Ward, 3 Aug 2010): Change title of this front GUI
MainBaseTitle = 'REFoffSpec ' + version

InstrumentSelectionBaseSize = [400,300,240,300]
InstrumentSelectioncwbgroupSize = [10,5]
InstrumentSelectioncwbgroupTitle = 'SELECT YOUR INSTRUMENT'

InstrumentList = ['Liquids Reflectometer (REF_L)',$
                  'Magnetism Reflectometer (REF_M)']

InstrumentSelectionGoButtonSize = [10,100,220,30]
; Change code (RC Ward, 3 Aug 2010): Change title of this front GUI
InstrumentSelectionGoButtontitle = 'VALIDATE INSTRUMENT'
InstrumentSelectionGoButtontitle = 'Proceed'

ResolutioncwbgroupTitle = 'SELECT RESOLUTION'
ResolutionList = ['Desktop','Laptop']

SplicingAlternativecwbgroupTitle = 'SELECT SPLICING ALTERNATIVE'
SplicingAlternativeList = ['Use Max Value','Higher Q Overrides']

;Build GUI
MAIN_BASE = widget_base(GROUP_LEADER=wGroup,$
                        xoffset=InstrumentSelectionBaseSize[0],$
                        yoffset=InstrumentSelectionBaseSize[1],$
                        scr_xsize=InstrumentSelectionBaseSize[2],$
                        scr_ysize=InstrumentSelectionBaseSize[3],$
                        Title = MainBaseTitle,$
                        SPACE=0,$
                        XPAD=0,$
                        YPAD=0,$
                        uname='MAIN_BASE',$
                        frame=2)

;global = ptr_new()

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

InstrumentCWBgroup = cw_bgroup(MAIN_BASE,$
                               InstrumentList,$
                               /exclusive,$
                               xoffset=InstrumentSelectioncwbgroupSize[0],$
                               yoffset=InstrumentSelectioncwbgroupSize[1],$
                               set_value=1,$
                               uname='instrument_selection_cw_bgroup',$
                               column=1,$
                               label_top=InstrumentSelectioncwbgroupTitle)
                               
; CHANGE CODE (RC WARD, 22 June 2010): Add selection for resolution so code can run on laptop or desktop
ResolutionCWBgroup = cw_bgroup(MAIN_BASE,$
                               ResolutionList,$
                               /exclusive,$
                               xoffset=InstrumentSelectioncwbgroupSize[0],$
                               yoffset=InstrumentSelectioncwbgroupSize[1]+90,$
                               set_value=0,$
                               uname='resolution_selection_cw_bgroup',$
                               column=1, $
                               label_top=ResolutioncwbgroupTitle)

; Change code (RC Ward, 13 Aug 2010): This was removed from the FRONT screen - code left in place
; in case we might return to this approach. Use a overall window size of 400.
; CHANGE CODE (RC WARD, 3 Aug 2010): Add selection for splicing alternative
; [0] is use Max value in overlap range (default); [1] is let the higher Q curve override lower Q
; default is set to [1]
;SplicingAlternativeCWBgroup = cw_bgroup(MAIN_BASE,$
;                               SplicingAlternativeList,$
;                               /exclusive,$
;                               xoffset=InstrumentSelectioncwbgroupSize[0],$
;                               yoffset=InstrumentSelectioncwbgroupSize[1]+175,$
;                               set_value=1,$
;                               uname='splicing_alternative_cw_bgroup',$
;                               column=1, $
;                               label_top=SplicingAlternativecwbgroupTitle)

; CHANGE CODE (RC WARD, 23 July 2010): Add ability for user to change location of reduce step files
;label
path_label = 'PATH FOR REDUCE STEP FILES'
    label = WIDGET_LABEL(MAIN_BASE,$
                    xoffset=InstrumentSelectioncwbgroupSize[0],$
                    yoffset=InstrumentSelectioncwbgroupSize[1]+190,$
                    VALUE   = path_label)

path = '~/results/'
new_path = WIDGET_TEXT(MAIN_BASE,$
                    xoffset=InstrumentSelectioncwbgroupSize[0],$
                    yoffset=InstrumentSelectioncwbgroupSize[1]+210,$
                    SCR_XSIZE = 220,$
                    UNAME = 'reduce_step_path',$
                    VALUE = path,$
                    /EDITABLE,$
                    /ALIGN_LEFT)

InstrumentSelectionGoButton = $
   widget_button(MAIN_BASE,$
                 xoffset=InstrumentSelectionGoButtonSize[0],$
                 yoffset=InstrumentSelectionGoButtonSize[1]+160,$
                 scr_xsize=InstrumentSelectionGoButtonSize[2],$
                 scr_ysize=InstrumentSelectionGoButtonSize[3],$
                 value=InstrumentSelectionGoButtonTitle,$
                 uname='instrument_selection_validate_button')

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

END
