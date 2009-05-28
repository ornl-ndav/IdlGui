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

PRO MakeGuiMainPlot, wBase

;********************************************************************************
;                           Define size arrays
;********************************************************************************

MainPlotBase = { size  : [200,50,1865,268],$
                 uname : 'main_plot_base',$
                 title : 'Real View of Instrument (Y vs X integrated over TOF)'}

MainDraw     = { size  : [0,0,MainPlotBase.size[2],$
                          MainPlotBase.size[3]],$
                 uname : 'main_plot'}

PSbutton     = { uname : 'plot_selection_button_mbar',$
                 value : 'PLOT SELECTION'}

PDVbutton    = { uname : 'plot_das_view_button_mbar',$
                 value : 'DAS view (Y vs X integrated over TOF)'}

PtofVbutton  = { uname : 'plot_tof_view_button_mbar',$
                 value : 'TOF view (tof vs X integrated over Y)'}

PtofScaleButton = { value     : 'TOF scale (* 1)',$
                    uname     : 'tof_scale_button',$
                    sensitive : 0}
PtofScale      = { uname : ['tof_scale_d9',$
                            'tof_scale_d8',$
                            'tof_scale_d7',$
                            'tof_scale_d6',$
                            'tof_scale_d5',$
                            'tof_scale_d4',$
                            'tof_scale_d3',$
                            'tof_scale_d2',$
                            'tof_scale_reset',$
                            'tof_scale_m2',$
                            'tof_scale_m3',$
                            'tof_scale_m4',$
                            'tof_scale_m5',$
                            'tof_scale_m6',$
                            'tof_scale_m7',$
                            'tof_scale_m8',$
                            'tof_scale_m9'],$
                   value : ['   / 9   ',$
                            '   / 8   ',$
                            '   / 7   ',$
                            '   / 6   ',$
                            '   / 5   ',$
                            '   / 4   ',$
                            '   / 3   ',$
                            '   / 2   ',$
                            '  Reset  ',$
                            '   * 2   ', $
                            '   * 3   ', $
                            '   * 4   ', $
                            '   * 5   ', $
                            '   * 6   ', $
                            '   * 7   ', $
                            '   * 8   ', $
                            '   * 9   ']}

;********************************************************************************
;                                Build GUI
;********************************************************************************
ourGroup = WIDGET_BASE()
wBase = WIDGET_BASE(TITLE        = MainPlotBase.title,$
                    UNAME        = MainPlotBase.uname,$
                    XOFFSET      = MainPlotBase.size[0],$
                    YOFFSET      = MainPlotBase.size[1],$
                    SCR_XSIZE    = MainPlotBase.size[2],$
                    SCR_YSIZE    = MainPlotBase.size[3],$
                    MAP          = 1,$
                    GROUP_LEADER = ourGroup,$
                    MBAR         = MBAR)

wMainDraw = WIDGET_DRAW(wBase,$
                        XOFFSET   = MainDraw.size[0],$
                        YOFFSET   = MainDraw.size[1],$
                        SCR_XSIZE = MainDraw.size[2],$
                        SCR_YSIZE = MainDraw.size[3],$
                        UNAME     = MainDraw.uname,$
                        /BUTTON_EVENTS,$
                        /MOTION_EVENTS)

plot_selection_button = WIDGET_BUTTON(MBAR,$
                                      UNAME = PSbutton.uname,$
                                      VALUE = PSbutton.value,$
                                      /MENU)

plot_das_view_button = WIDGET_BUTTON(plot_selection_button,$
                                     UNAME = PDVbutton.uname,$
                                     VALUE = PDVbutton.value)

plot_tof_view_button = WIDGET_BUTTON(plot_selection_button,$
                                     UNAME = PtofVbutton.uname,$
                                     VALUE = PtofVbutton.value)

scale_button_menu = WIDGET_BUTTON(MBAR,$
                                  UNAME     = PtofScaleButton.uname,$
                                  VALUE     = PtofScaleButton.value,$
                                  SENSITIVE = PtofScaleButton.sensitive,$
                                  /MENU)

sz = (size(PtofScale.uname))(1)
FOR i=0,(sz-1) DO BEGIN
    scale_button = WIDGET_BUTTON(scale_button_menu,$
                                 UNAME = PtofScale.uname[i],$
                                 VALUE = PtofScale.value[i])
ENDFOR

WIDGET_CONTROL, wBase, /REALIZE

END
