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

PRO make_gui_options, REDUCE_TAB, tab_size, TabTitles, global

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'options_tab_base',$
             title: TabTitles.options}

;Shifting base ----------------------------------------------------------------
XYoff = [10,15] ;base
sShiftingBase = { size: [XYoff[0],$
                         XYoff[1],$
                         350,100],$
                  uname: 'shifting_base_options',$
                  frame: 1}

XYoff = [15,-8] ;label
sShiftingLabel = { size: [sShiftingBase.size[0]+XYoff[0],$
                          sShiftingBase.size[1]+XYoff[1]],$
                   value: '3/ Shifting'}

;Transparency coefficient -----------------------------------------------------
sTransparencyCWfield = { size: [5,1],$
                         value: 10,$
                         uname: 'transparency_shifting_options',$
                         title: 'Transparency coefficient (%)     '}

;Reference pixel selection ----------------------------------------------------
sRefPixelSelection = { list: ['Y  ','X and Y'],$
                       title:   'Reference Pixel Selection        ',$
                       uname: 'reference_pixel_shifting_options'}

;******************************************************************************
;            BUILD GUI
;******************************************************************************

BaseTab = WIDGET_BASE(REDUCE_TAB,$
                      UNAME     = sBaseTab.uname,$
                      XOFFSET   = sBaseTab.size[0],$
                      YOFFSET   = sBaseTab.size[1],$
                      SCR_XSIZE = sBaseTab.size[2],$
                      SCR_YSIZE = sBaseTab.size[3],$
                      TITLE     = sBaseTab.title)

;Shifting base and label ------------------------------------------------------
wShiftingLabel = WIDGET_LABEL(BaseTab,$
                              XOFFSET = sShiftingLabel.size[0],$
                              YOFFSET = sShiftingLabel.size[1],$
                              VALUE   = sShiftingLabel.value)

wShiftingBase = WIDGET_BASE(BaseTab,$
                            XOFFSET   = sShiftingBase.size[0],$
                            YOFFSET   = sShiftingBase.size[1],$
                            SCR_XSIZE = sShiftingBase.size[2],$
                            SCR_YSIZE = sShiftingBase.size[3],$
                            UNAME     = sShiftingBase.uname,$
                            FRAME     = sShiftingBase.frame,$
                            /COLUMN)

;Transparency coefficient -----------------------------------------------------
wTransCWfield = CW_FIELD(wShiftingBase,$
                         XSIZE   = sTransparencyCWfield.size[0],$
                         YSIZE   = sTransparencyCWfield.size[1],$
                         UNAME   = sTransparencyCWfield.uname,$
                         VALUE   = sTransparencyCWfield.value,$
                         TITLE   = sTransparencyCWfield.title,$
                         /FLOATING,$
                         /ROW)
                         
;Reference pixel selection ----------------------------------------------------
wRefPixelSelection = CW_BGROUP(wShiftingBase,$
                               sRefPixelSelection.list,$
                               LABEL_LEFT = sRefPixelSelection.title,$
                               UNAME      = sRefPixelSelection.uname,$
                               /ROW,$
                               /EXCLUSIVE)



                              

END
