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

PRO MakeGuiPlotsMainIntermediatesBases, PLOTS_BASE, PlotsTitle

;define widgets variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
PlotsDropListSize         = [190,0]

PlotsErrorMessageBaseSize = [500, $
                             2, $
                             481, $
                             30]

PlotsErrorMessageSize     = [0, $
                             0, $
                             481, $
                             30]

MainPlotBaseSize          = [200, $
                             40, $
                             780, $
                             800]

MainPlotDrawSize          = [0, $
                             0, $
                             MainPlotBaseSize[2], $
                             MainPlotBasesize[3]-190]

PlotTextFieldSize         = [0, $
                             MainPlotDrawSize[1]+MainPlotDrawSize[3],$
                             MainPlotBaseSize[2], $
                             190]

;############### BUILD WIDGETS ##########################################
MainPlotBase = Widget_base(PLOTS_BASE,$
                           UNAME     = 'main_plot_base',$
                           XOFFSET   = MainPlotBaseSize[0],$
                           YOFFSET   = MainPlotBaseSize[1],$
                           SCR_XSIZE = MainPlotBaseSize[2],$
                           SCR_YSIZE = MainPlotBaseSize[3],$
                           FRAME     = 3)
                          
;drawing region
MainPlotDraw = widget_draw(MainPlotBase,$
                           UNAME     = 'main_plot_draw',$
                           XOFFSET   = MainPlotDrawSize[0],$
                           YOFFSET   = MainPlotDrawSize[1],$
                           SCR_XSIZE = MainPlotDrawSize[2],$
                           SCR_YSIZE = MainPlotDrawSize[3])

;text field
PlotTextField = widget_text(MainPlotBase,$
                            XOFFSET   = PlotTextFieldSize[0],$
                            YOFFSET   = PlotTextFieldSize[1],$
                            SCR_XSIZE = PlotTextFieldSize[2],$
                            SCR_YSIZE = PlotTextFieldSize[3],$
                            UNAME     ='plots_text_field',$
                            /SCROLL,$
                            /WRAP)

;droplist
PlotsDropList = widget_droplist(PLOTS_BASE,$
                                UNAME     = 'plots_droplist',$
                                XOFFSET   = PlotsDropListSize[0],$
                                YOFFSET   = PlotsDropListSize[1],$
                                VALUE     = PlotsTitle,$
                                SENSITIVE = 0)

;error message base/label
PLOTS_ERROR_BASE = WIDGET_BASE(PLOTS_BASE,$
                               XOFFSET   = PlotsErrorMessageBaseSize[0],$
                               YOFFSET   = PlotsErrorMessageBaseSize[1],$
                               SCR_XSIZE = PlotsErrorMessageBaseSize[2],$
                               SCR_YSIZE = PlotsErrorMessageBaseSize[3],$
                               UNAME     = 'plots_error_base',$
                               MAP       = 0,$
                               FRAME     = 1)

PlotsErrorMessage = WIDGET_LABEL(PLOTS_ERROR_BASE,$
                                 XOFFSET   = PlotsErrorMessageSize[0],$
                                 YOFFSET   = PlotsErrorMessageSize[1],$
                                 SCR_XSIZE = PlotsErrorMessageSize[2],$
                                 SCR_YSIZE = PlotsErrorMessageSize[3],$
                                 VALUE     = 'ERROR: not enough data to plot',$
                                 FRAME     = 0,$
                                 UNAME     = 'plots_error_message')
                                                            
END
