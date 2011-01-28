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
                         702,200],$
                  uname: 'shifting_base_options',$
                  frame: 4}

XYoff = [15,-8] ;label
sShiftingLabel = { size: [sShiftingBase.size[0]+XYoff[0],$
                          sShiftingBase.size[1]+XYoff[1]],$
                   value: '3/ SHIFTING'}

;Use or not transparency coefficient ------------------------------------------
IF ((*global).ucams EQ 'j35') THEN BEGIN
    sens_value = 1
    value      = 0.0
ENDIF ELSE BEGIN
    sens_value = 0
    value      = 0.0
ENDELSE

sBase1 = { size: [sShiftingBase.size[2],$
                 30],$
          sensitive: sens_value}
sTransparencyGroup = { list: ['NO','YES'],$
                       title: 'Use non-active file attenuator     ',$
                       value: value,$
                       uname: 'transparency_attenuator_shifting_options'}

;Transparency coefficient -----------------------------------------------------
sBase2 = { size: [300,30],$
           uname: 'transparency_coeff_base',$
           sensitive: 0}
sTransparencyCWfield = { size: [5,1],$
                         value: 10,$
                         uname: 'transparency_shifting_options',$
                         title: ' -> Transparency coefficient (%)     '}

;Reference pixel selection ----------------------------------------------------
sRefPixelSelection = { list: ['Y  ','X and Y'],$
                       title: 'Reference Pixel Selection          ',$
                       uname: 'reference_pixel_shifting_options',$
                       value: 1.0}

;Fast selection mode ----------------------------------------------------------
sFastSelectionMode = { list: ['YES','NO'],$
                       title: 'Fast Reference Pixel Selection Mode',$
                       uname: 'fast_selection_pixel_selection_mode',$
                       value: 1.0}
sFastSelectionModeLabel = { value: '-> User is in charge of changing ' + $
                            'the active file.            ',$
                            uname: 'fast_active_file_options_label'}

;Type of Selection lines ------------------------------------------------------
sTypeOfSelection = { list: ['_____  ','.  .  .  ','- - -  ',' -.-.-  ', $
                            '--...--  ','--  -- '],$
                     uname: 'plot_2d_selection_type',$
                     value: 4.0,$
                     title: 'Plot2D Selection Style              '}

;Scaling base ----------------------------------------------------------------
XYoff = [0,18] ;base
sScalingBase = { size: [sShiftingBase.size[0]+XYoff[0],$
                        sShiftingBase.size[1]+$
                        sShiftingBase.size[3]+XYoff[1],$
                        702,200],$
                 uname: 'scaling_base_options',$
                 frame: sShiftingBase.frame}

XYoff = [15,-8]                 ;label
sScalingLabel = { size: [sScalingBase.size[0]+XYoff[0],$
                         sScalingBase.size[1]+XYoff[1]],$
                  value: '4/ SCALING'}

;main horizontal base ---------------------------------------------------------
sBaseHorizontal = { size: [sScalingBase.size[2],$
                           30]}

;Plot data with or without error bars -----------------------------------------
sBase = { size: [sScalingBase.size[2],$
                 30]}
sErrorGroup = { list: ['YES','NO'],$
                title: 'Plot data with error bars ',$
                value: 1.0,$
                uname: 'plot_error_scaling_options'}

;Coverage of the selection ----------------------------------------------------
sSelectionCoverage = { size: [2,1],$
                       value: 5,$
                       uname: 'selection_coverage_step4_step1',$
                       title: 'Precision in pixel of mouse click ' + $
                       'selection (move/resize) '}

;Type of plot symbols ---------------------------------------------------------
sPlotSymbols = { list: ['Plus sign (+)','Asterisk (*)','Period (.)','Diamond', $
                        'Triange','Square','X'],$
                 uname: 'plot_2d_symbol',$
                 value: 0.0,$
                 title: 'Plot2D Symbols       '}

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
                            /BASE_ALIGN_LEFT,$
                            /COLUMN)

;Use or not transparency coefficient ------------------------------------------
label = WIDGET_LABEL(wShiftingBase,$ ;just to make a vertical space
                     value = '')

sBase1 = WIDGET_BASE(wShiftingBase,$
                     FRAME = 1,$
                     SENSITIVE = sBase1.sensitive,$
                     /ROW)

wTransparencyGroup = CW_BGROUP(sBase1,$
                               sTransparencyGroup.list,$
                               LABEL_LEFT = sTransparencyGroup.title,$
                               UNAME      = sTransparencyGroup.uname,$
                               SET_VALUE  = sTransparencyGroup.value,$
                               /NO_RELEASE,$
                               /ROW,$
                               /EXCLUSIVE)

;Transparency coefficient -----------------------------------------------------
wBase2 = WIDGET_BASE(sBase1,$
                     UNAME     = sBase2.uname,$
                     SENSITIVE = sBase2.sensitive)

wTransCWfield = CW_FIELD(wBase2,$
                         XSIZE     = sTransparencyCWfield.size[0],$
                         YSIZE     = sTransparencyCWfield.size[1],$
                         UNAME     = sTransparencyCWfield.uname,$
                         VALUE     = sTransparencyCWfield.value,$
                         TITLE     = sTransparencyCWfield.title,$
                         /FLOATING,$
                         /ROW)
                         
;Reference pixel selection ----------------------------------------------------
wBase3 = WIDGET_BASE(wShiftingBase,$
                     FRAME = 1)
wRefPixelSelection = CW_BGROUP(wBase3,$
                               sRefPixelSelection.list,$
                               LABEL_LEFT = sRefPixelSelection.title,$
                               UNAME      = sRefPixelSelection.uname,$
                               SET_VALUE  = sRefPixelSelection.value,$
                               /ROW,$
                               /EXCLUSIVE)

;Fast selection mode ----------------------------------------------------------
wBase4 = WIDGET_BASE(wShiftingBase,$
                     FRAME = 1,$
                     /ROW)
wFastSelectionMode = CW_BGROUP(wBase4,$
                               sFastSelectionMode.list,$
                               LABEL_LEFT = sFastSelectionMode.title,$
                               UNAME      = sFastSelectionMode.uname,$
                               SET_VALUE  = sFastSelectionMode.value,$
                               /ROW,$
                               /EXCLUSIVE)

wLabel = WIDGET_LABEL(wBase4,$
                      UNAME = sFastSelectionModeLabel.uname,$
                      VALUE = sFastSelectionModeLabel.value,$
                      /ALIGN_LEFT)

;Type of Selection lines ------------------------------------------------------
wBase5 = WIDGET_BASE(wShiftingBase,$
                     FRAME = 1)
wTypeOfSelection = CW_BGROUP(wBase5,$
                             sTypeOfSelection.list,$
                             LABEL_LEFT = sTypeOfSelection.title,$
                             UNAME      = sTypeOfSelection.uname,$
                             SET_VALUE  = sTypeOfSelection.value,$
                             /ROW,$
                             /EXCLUSIVE)

;==============================================================================
;Scaling base and label -------------------------------------------------------
wScalingLabel = WIDGET_LABEL(BaseTab,$
                              XOFFSET = sScalingLabel.size[0],$
                              YOFFSET = sScalingLabel.size[1],$
                              VALUE   = sScalingLabel.value)

wScalingBase = WIDGET_BASE(BaseTab,$
                            XOFFSET   = sScalingBase.size[0],$
                            YOFFSET   = sScalingBase.size[1],$
                            SCR_XSIZE = sScalingBase.size[2],$
                            SCR_YSIZE = sScalingBase.size[3],$
                            UNAME     = sScalingBase.uname,$
                            FRAME     = sScalingBase.frame,$
                            /BASE_ALIGN_LEFT,$
                            /COLUMN)

label = WIDGET_LABEL(wScalingBase,$
                     value = '')

;main horizontal base ---------------------------------------------------------
wBaseHorizontal = WIDGET_BASE(wScalingBase,$
                              XOFFSET = sBaseHorizontal.size[0],$
                              YOFFSET = sBaseHorizontal.size[1],$
                              /ROW)

;Plot data with or without error bars -----------------------------------------
sBase1 = WIDGET_BASE(wBaseHorizontal,$
                     FRAME = 1,$
                     /ROW)

wErrorGroup = CW_BGROUP(sBase1,$,$
                        sErrorGroup.list,$
                        LABEL_LEFT = sErrorGroup.title,$
                        UNAME      = sErrorGroup.uname,$
                        SET_VALUE  = sErrorGroup.value,$
                        /NO_RELEASE,$
                        /ROW,$
                        /EXCLUSIVE)

;Coverage of the selection ----------------------------------------------------
wBase2 = WIDGET_BASE(wBaseHorizontal,$
                     FRAME = 1,$
                     /ROW)

wSelectionCoverage = CW_FIELD(wBase2,$
                         XSIZE     = sSelectionCoverage.size[0],$
                         YSIZE     = sSelectionCoverage.size[1],$
                         UNAME     = sSelectionCoverage.uname,$
                         VALUE     = sSelectionCoverage.value,$
                         TITLE     = sSelectionCoverage.title,$
                         /INTEGER,$
                         /ROW)

;Type of Plot symbols ---------------------------------------------------------
wBase3 = WIDGET_BASE(wScalingBase,$
                     FRAME = 1)
wPlotSymbols = CW_BGROUP(wBase3,$
                         sPlotSymbols.list,$
                         LABEL_LEFT = sPlotSymbols.title,$
                         UNAME      = sPlotSymbols.uname,$
                         SET_VALUE  = sPlotSymbols.value,$
                         /ROW,$
                         /EXCLUSIVE)

END
