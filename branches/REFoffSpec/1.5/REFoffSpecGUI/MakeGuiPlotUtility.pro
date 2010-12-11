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

PRO make_gui_plot_utility, MAIN_TAB, MainTabSize, TabTitles, global
  path = (*global).ascii_path

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

;- base -----------------------------------------------------------------------
sPlotUtilityBase = { size  : MainTabSize,$
                 title : TabTitles.plot_utility,$
                 uname : 'base_plot_utility'}

;- plot utility text -----------------------------------------------------------
sPlotUtility = { size  : [0,0,MainTabSize[2]-10,300],$
             uname : 'plot_utility_text'} 
                                                  
;******************************************************************************
;            BUILD GUI
;******************************************************************************

;- base -----------------------------------------------------------------------
wPlotUtilityBase = WIDGET_BASE(MAIN_TAB,$
                           UNAME     = sPlotUtilityBase.uname,$
                           XOFFSET   = sPlotUtilityBase.size[0],$
                           YOFFSET   = sPlotUtilityBase.size[1],$
                           SCR_XSIZE = sPlotUtilityBase.size[2],$
                           SCR_YSIZE = sPlotUtilityBase.size[3],$
                           TITLE     = sPlotUtilityBase.title,$
                           ROW = 3)

;- plot utility text ----------------------------------------------------------
wPlotUtilityText = WIDGET_TEXT(wPlotUtilityBase,$
                           UNAME     = sPlotUtility.uname,$
                           XOFFSET   = sPlotUtility.size[0],$
                           YOFFSET   = sPlotUtility.size[1],$
                           SCR_XSIZE = sPlotUtility.size[2],$
                           SCR_YSIZE = sPlotUtility.size[3],$
                           /SCROLL,$
                           /WRAP)

row1 = WIDGET_BASE(wPlotUtilityBase,/ROW)
row1col1 = WIDGET_BASE(row1,/COLUMN)
wPlotUtilityButton1 = WIDGET_BUTTON(row1col1,$
                          VALUE = ' Plot Reflectivity vs Q ',$
                          UNAME = 'launch_plotRvsQ')

wPlotUtilityButton2 = WIDGET_BUTTON(row1col1,$
                          VALUE = 'Plot Scaled 2D Results',$
                          UNAME = 'launch_plotScaled2D')

new_path = WIDGET_TEXT(row1col1,$
                    SCR_XSIZE = 220,$
                    UNAME     = 'new_reduce_step_path',$
                    VALUE     = path,$
                    /EDITABLE,$
                    /ALIGN_LEFT)

ReduceStepPathGoButton = WIDGET_BUTTON(row1col1,$
                    SCR_XSIZE = 20,$
                    SCR_YSIZE = 25,$
                    VALUE     = 'Proceed',$
                    UNAME     = 'update_reduce_step_path')

END
