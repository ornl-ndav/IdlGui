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

PRO make_gui_fitting, MAIN_TAB, MainTabSize, TabTitles, global

;- base -----------------------------------------------------------------------
sTabBase = { size  : MainTabSize,$
              title : TabTitles.fitting,$
              uname : 'base_fitting'}

;- Plot -----------------------------------------------------------------------
XYoff = [0,0]
sDraw = { size: [XYoff[0],$
                 XYoff[1],$
                 MainTabSize[2], $
                 630],$
          uname: 'fitting_draw_uname'}

;Loading Wavelength file ------------------------------------------------------
XYoff = [5,15]
sInputFileLabel = { size: [XYoff[0],$
                           sDraw.size[1]+sDraw.size[3]+XYoff[1]],$
                    value: 'Input File Name:'}
XYoff = [115,-5]
sInputBrowse = { size: [XYoff[0],$
                        sInputFileLabel.size[1]+XYoff[1],$
                        105,30],$
                 value: 'BROWSE ...',$
                 uname: 'input_file_browse_button'}
XYoff = [0,-5]
sInputFileTextField = { size: [sInputBrowse.size[0]+ $
                               sInputBrowse.size[2]+ XYoff[0],$
                               sInputFileLabel.size[1]+XYoff[1],$
                               570],$
                        uname: 'input_file_text_field',$
                        value: ''}
XYoff = [5,0]
sInputFileSaveButton = { size: [sInputFileTextField.size[0]+$
                                sInputFileTextField.size[2]+XYoff[0],$
                                sInputFileTextField.size[1]+XYoff[1],$
                                105,30],$
                         value: 'LOAD FILE',$
                         uname: 'input_file_load_button',$
                         sensitive: 0}
XYoff = [0,0]
sInputFilePreviewButton = { size: [sInputFileSaveButton.size[0]+$
                                   sInputFileSaveButton.size[2]+XYoff[0],$
                                   sInputFileSaveButton.size[1]+XYoff[1],$
                                   sInputFileSaveButton.size[2:3]],$
                            value: 'PREVIEW',$
                            uname: 'input_file_preview_button',$
                            sensitive: 0}

;- Fitting Degree group -------------------------------------------------------
XYoff = [3,35]
sDegreeGroup = { size:  [XYoff[0],$
                         sInputFileLabel.size[1]+ $
                         XYoff[1]],$
                 list:  ['1 (y=A+Bx)','2 (y=A+Bx+Cx^2)'],$
                 value: 0.0,$
                 uname: 'fitting_polynomial_degree_cw_group',$
                 title: 'Polynomial Fitting Degree: '}

;- Automatic Fitting Button ---------------------------------------------------
XYoff = [390,5]
sAutoFittingButton = { size: [XYoff[0],$
                              sDegreeGroup.size[1]+XYoff[1],$
                              510,30],$
                       uname: 'auto_fitting_button',$
                       value: 'A U T O M A T I C   F I T T I N G    ' + $
                       'with    Y = A + BX'}

;- Settings -------------------------------------------------------------------
XYoff = [0,0]
sSettingsButton = { size: [sAutoFittingButton.size[0]+$
                           sAutoFittingButton.size[2]+XYoff[0],$
                           sAutoFittingButton.size[1]+XYoff[1],$
                           105,30],$
                    value: 'SETTINGS ...',$
                    uname: 'settings_button'}

;- Settings Base --------------------------------------------------------------
XYoff = [0,-10]
sSettingsBase = { size: [sAutoFittingButton.size[0]+XYoff[0],$
                         sAutoFittingButton.size[1]+XYoff[1],$
                         sAutoFittingButton.size[2]+sSettingsButton.size[2],$
                         30],$
                  uname: 'settings_base',$
                  frame: 1,$
                  map:   0}

;- Fitting with error bars group ----------------------------------------------
sErrorBarsFitting = { uname: 'fitting_error_bars_group',$
                      list:  ['YES','NO'],$
                      value: 1.0,$
                      title: 'Fit using Error Bars:'}

;- Plot with error bars group -------------------------------------------------
sErrorBarsPlot = { uname: 'plot_error_bars_group',$
                   list:  ['YES','NO'],$
                   value: 0.0,$
                   title: 'Show Error Bars in Plot:'}

;- close settings button ------------------------------------------------------
sCloseSettings = { uname: 'close_fitting_settings_button',$
                   xsize: 105,$
                   value: 'CLOSE SETTINGS'}

;- Result of Auto fitting (base and widgets)
XYOff = [0,35] ;base
sResultFitBase = { size: [XYoff[0],$
                          sAutoFittingButton.size[1]+XYoff[1],$
                          380,$
                          40],$
                   frame: 0,$
                   map:   1,$
                   uname: 'result_fitting_base_uname'}
XYoff = [5,10] ;label
sResultFitLabel = { size: [XYoff[0],$
                           XYoff[1]],$
                    value: '=> Y =                +                X +    ' + $
                    '            X^2'}
XYOff = [45,-6] ;A text field
sResultFitA = { size: [XYoff[0],$
                       sResultFitLabel.size[1]+XYoff[1],$
                       90],$
                value: '',$
                uname: 'result_fit_a_text_field'}
XYOff = [102,0] ;B text field
sResultFitB = { size: [sResultFitA.size[0]+XYoff[0],$
                       sResultFitA.size[1:2]],$
                value: '',$
                uname: 'result_fit_b_text_field'}
XYOff = [115,0] ;C text field
sResultFitC = { size: [sResultFitB.size[0]+XYoff[0],$
                       sResultFitB.size[1:2]],$
                value: '',$
                uname: 'result_fit_c_text_field'}

;Manual fitting button
XYoff = [0,5]
sManualFittingButton = { size: [sAutoFittingButton.size[0]+XYoff[0],$
                                sResultFitBase.size[1]+XYoff[1],$
                                sAutoFittingButton.size[2],30],$
                         uname: 'manual_fitting_button',$
                         value: 'M A N U A L  F I T T I N G'}

;Alternate Wavelength Axis ----------------------------------------------------
XYoff = [3,45]
sAxisGroup = { size:  [XYoff[0],$
                      sResultFitBase.size[1]+XYoff[1]],$
               list:  ['YES','NO'],$
               value: 1.0,$
               uname: 'alternate_wavelength_axis_cw_group',$
               title: 'Alternate Wavelength Axis: '}

;alternate base
XYoff = [270,0]
sAltBase = { size: [XYoff[0],$
                    sAxisGroup.size[1]+XYoff[1],$
                    730,35],$
             uname: 'alternate_base',$
             frame: 1,$
             map:   0}

;Wavelengthmin
XYoff = [25,8]
sWavelengthminLabel = { size:  [XYoff[0],$
                                XYoff[1]],$
                        value: 'Min:'}
XYoff = [30,-6]
sWavelengthminText = {  size:  [sWavelengthminLabel.size[0]+XYoff[0],$
                                sWavelengthminLabel.size[1]+XYoff[1],$
                                100],$
                        value: '',$
                        uname: 'alternate_wave_min_text_field'}

;Wavelengthmax
XYoff = [25,0]
sWavelengthmaxLabel = { size:  [sWavelengthminText.size[0]+$
                                sWavelengthminText.size[2]+XYoff[0],$
                                sWavelengthminLabel.size[1]+XYoff[1]],$
                        value: 'Max:'}
XYoff = [30,0]
sWavelengthmaxText = {  size:  [sWavelengthmaxLabel.size[0]+XYoff[0],$
                                sWavelengthminText.size[1]+XYoff[1],$
                                sWavelengthminText.size[2]],$
                        value: '',$
                        uname: 'alternate_wave_max_text_field'}

;Wavelengthwidth
XYoff = [25,0]
sWavelengthwidthLabel = { size:  [sWavelengthmaxText.size[0]+$
                                  sWavelengthminText.size[2]+XYoff[0],$
                                  sWavelengthminLabel.size[1]+XYoff[1]],$
                          value: 'Width:'}
XYoff = [45,0]
sWavelengthwidthText = {  size:  [sWavelengthwidthLabel.size[0]+XYoff[0],$
                                  sWavelengthminText.size[1]+XYoff[1],$
                                  sWavelengthminText.size[2]],$
                          value: '',$
                          uname: 'alternate_wave_width_text_field'}

;Wavelength scale
XYoff = [25,0]
sWavelengthscaleGroup = { size:  [sWavelengthwidthText.size[0]+$
                                  sWavelengthwidthText.size[2]+XYoff[0],$
                                  sWavelengthwidthText.size[1]+XYoff[1]],$
                          list:  ['Linear','Logarithmic'],$
                          value: 0.0,$
                          uname: 'alternate_wave_scale_group'}

;output file name -------------------------------------------------------------
XYoff = [5,50]
sOutputFileLabel = { size: [XYoff[0],$
                            sAxisGroup.size[1]+XYoff[1]],$
                     value: 'Output File Name:'}
XYoff = [115,-5]
sOutputFolderButton = { size: [XYoff[0],$
                               sOutputFileLabel.size[1]+XYoff[1],$
                               380,30],$
                        value: '',$
                        sensitive: 1,$
                        uname: 'output_folder_button'}
XYoff = [0,0]
sOutputFileTextField = { size: [sOutputFolderButton.size[0]+$
                                sOutputFolderButton.size[2]+XYoff[0],$
                                sOutputFolderButton.size[1]+XYoff[1],$
                                215],$
                         uname: 'output_file_text_field',$
                         value: ''}
XYoff = [5,0]
sOutputFileSaveButton = { size: [sOutputFileTextField.size[0]+$
                                 sOutputFileTextField.size[2]+XYoff[0],$
                                 sOutputFileTextField.size[1]+XYoff[1],$
                                 105,30],$
                          value: 'CREATE FILE',$
                          uname: 'output_file_save_button',$
                          sensitive: 0}
XYoff = [5,0]
sOutputFileEditSaveButton = { size: [sOutputFileSaveButton.size[0]+$
                                     sOutputFileSaveButton.size[2]+XYoff[0],$
                                     sOutputFileSaveButton.size[1],$
                                     180,$
                                     sOutputFileSaveButton.size[3]],$
                              value: 'PREVIEW/EDIT/CREATE FILE',$
                              uname: 'output_file_edit_save_button',$
                              sensitive: 0}
                          
;==============================================================================
;= BUILD GUI ==================================================================
;==============================================================================

;- base -----------------------------------------------------------------------
wTabBase = WIDGET_BASE(MAIN_TAB,$
                        UNAME     = sTabBase.uname,$
                        XOFFSET   = sTabBase.size[0],$
                        YOFFSET   = sTabBase.size[1],$
                        SCR_XSIZE = sTabBase.size[2],$
                        SCR_YSIZE = sTabBase.size[3],$
                        TITLE     = sTabBase.title)

;- Draw -----------------------------------------------------------------------
wDraw = WIDGET_DRAW(wTabBase,$
                    XOFFSET   = sDraw.size[0],$
                    YOFFSET   = sDraw.size[1],$
                    SCR_XSIZE = sDraw.size[2],$
                    SCR_YSIZE = sDraw.size[3],$
                    UNAME     = sDraw.uname)

;input file name -------------------------------------------------------------
;label
wLabel = WIDGET_LABEL(wTabBase,$
                      XOFFSET = sInputFileLabel.size[0],$
                      YOFFSET = sInputFileLabel.size[1],$
                      VALUE   = sInputFileLabel.value)

;browse button
wButton = WIDGET_BUTTON(wTabBase,$
                        XOFFSET   = sInputBrowse.size[0],$
                        YOFFSET   = sInputBrowse.size[1],$
                        SCR_XSIZE = sInputBrowse.size[2],$
                        SCR_YSIZE = sInputBrowse.size[3],$
                        VALUE     = sInputBrowse.value,$
                        UNAME     = sInputBrowse.uname)

;file name input
wTextField = WIDGET_TEXT(wTabBase,$
                         XOFFSET   = sInputFileTextField.size[0],$
                         YOFFSET   = sInputFileTextField.size[1],$
                         SCR_XSIZE = sInputFileTextField.size[2],$
                         VALUE     = sInputFileTextField.value,$
                         UNAME     = sInputFileTextField.uname,$
                         /ALL_EVENTS,$
                         /EDITABLE)
;save button
wSaveButton = WIDGET_BUTTON(wTabBase,$
                            XOFFSET   = sInputFileSaveButton.size[0],$
                            YOFFSET   = sInputFileSaveButton.size[1],$
                            SCR_XSIZE = sInputFileSaveButton.size[2],$
                            SCR_YSIZE = sInputFileSaveButton.size[3],$
                            VALUE     = sInputFileSaveButton.value,$
                            UNAME     = sInputFileSaveButton.uname,$
                            SENSITIVE = sInputFileSaveButton.sensitive)

;preview button
wPreviewButton = WIDGET_BUTTON(wTabBase,$
                               XOFFSET   = sInputFilePreviewButton.size[0],$
                               YOFFSET   = sInputFilePreviewButton.size[1],$
                               SCR_XSIZE = sInputFilePreviewButton.size[2],$
                               SCR_YSIZE = sInputFilePreviewButton.size[3],$
                               VALUE     = sInputFilePreviewButton.value,$
                               UNAME     = sInputFilePreviewButton.uname,$
                               SENSITIVE = sInputFilePreviewButton.sensitive)

;- Fitting Degree group -------------------------------------------------------
wDegreegroup = CW_BGROUP(wTabBase,$
                         sDegreeGroup.list,$
                         XOFFSET    = sDegreeGroup.size[0],$
                         YOFFSET    = sDegreeGroup.size[1],$
                         ROW        = 1,$
                         SET_VALUE  = sDegreeGroup.value,$
                         UNAME      = sDegreeGroup.uname,$
                         LABEL_LEFT = sDegreeGroup.title,$
                         /EXCLUSIVE)

;- Settings Base --------------------------------------------------------------
wSettingsBase = WIDGET_BASE(wTabBase,$
                            XOFFSET = sSettingsBase.size[0],$
                            YOFFSET = sSettingsBase.size[1],$
                            SCR_XSIZE = sSettingsBase.size[2],$
                            UNAME     = sSettingsBase.uname,$
                            FRAME     = sSettingsBase.frame,$
                            MAP       = sSettingsBase.map,$
                            /ROW)

;- Fitting with error bars group ----------------------------------------------
wErrorBarsFitting = CW_BGROUP(wSettingsBase,$
                              sErrorBarsFitting.list,$
                              ROW        = 1,$
                              SET_VALUE  = sErrorBarsFitting.value,$
                              UNAME      = sErrorBarsFitting.uname,$
                              LABEL_LEFT = sErrorBarsFitting.title,$
                              /NO_RELEASE,$
                              /EXCLUSIVE)

;- white space
wSpace = WIDGET_LABEL(wSettingsBase,$
                      VALUE = '  ')

;- Plot with error bars group ----------------------------------------------
wErrorBarsPlot = CW_BGROUP(wSettingsBase,$
                              sErrorBarsPlot.list,$
                              ROW        = 1,$
                              SET_VALUE  = sErrorBarsPlot.value,$
                              UNAME      = sErrorBarsPlot.uname,$
                              LABEL_LEFT = sErrorBarsPlot.title,$
                              /NO_RELEASE,$
                              /EXCLUSIVE)

;- white space
wSpace = WIDGET_LABEL(wSettingsBase,$
                      VALUE = '')

;- Close settings Button ------------------------------------------------------
wCloseSettings = WIDGET_BUTTON(wSettingsBase,$
                               SCR_XSIZE = sCloseSettings.xsize,$
                               UNAME = sCloseSettings.uname,$
                               VALUE = sCloseSettings.value)

;- Automatic Fitting Button ---------------------------------------------------
wButton = WIDGET_BUTTON(wTabBase,$
                        XOFFSET   = sAutoFittingButton.size[0],$
                        YOFFSET   = sAutoFittingButton.size[1],$
                        SCR_XSIZE = sAutoFittingButton.size[2],$
                        SCR_YSIZE = sAutoFittingButton.size[3],$
                        VALUE     = sAutoFittingButton.value,$
                        UNAME     = sAutoFittingButton.uname)

;- Settings -------------------------------------------------------------------
wSettingsButton = WIDGET_BUTTON(wTabBase,$
                                XOFFSET   = sSettingsButton.size[0],$
                                YOFFSET   = sSettingsButton.size[1],$
                                SCR_XSIZE = sSettingsButton.size[2],$
                                SCR_YSIZE = sSettingsButton.size[3],$
                                VALUE     = sSettingsButton.value,$
                                UNAME     = sSettingsButton.uname)

;- Result of Auto fitting (base and widgets) ----------------------------------
wBase = WIDGET_BASE(wTabBase,$
                    XOFFSET   = sResultFitBase.size[0],$
                    YOFFSET   = sResultFitBase.size[1],$
                    SCR_XSIZE = sResultFitBase.size[2],$
                    SCR_YSIZE = sResultFitBase.size[3],$
                    UNAME     = sResultFitBase.uname,$
                    FRAME     = sResultFitBase.frame)

;A text field
wA = WIDGET_TEXT(wBase,$
                 XOFFSET   = sResultFitA.size[0],$
                 YOFFSET   = sResultFitA.size[1],$
                 SCR_XSIZE = sResultFitA.size[2],$
                 VALUE     = sResultFitA.value,$
                 UNAME     = sResultFitA.uname,$
                 /EDITABLE,$
                 /ALIGN_LEFT)

;B text field
wB = WIDGET_TEXT(wBase,$
                 XOFFSET   = sResultFitB.size[0],$
                 YOFFSET   = sResultFitB.size[1],$
                 SCR_XSIZE = sResultFitB.size[2],$
                 VALUE     = sResultFitB.value,$
                 UNAME     = sResultFitB.uname,$
                 /EDITABLE,$
                 /ALIGN_LEFT)

;C text field
wC = WIDGET_TEXT(wBase,$
                 XOFFSET   = sResultFitC.size[0],$
                 YOFFSET   = sResultFitC.size[1],$
                 SCR_XSIZE = sResultFitC.size[2],$
                 VALUE     = sResultFitC.value,$
                 UNAME     = sResultFitC.uname,$
                 /EDITABLE,$
                 /ALIGN_LEFT)
;label
wLabel = WIDGET_LABEL(wBase,$
                      XOFFSET = sResultFitLabel.size[0],$
                      YOFFSET = sResultFitLabel.size[1],$
                      VALUE   = sResultFitLabel.value)

;- Manual Fitting Button ------------------------------------------------------
wButton = WIDGET_BUTTON(wTabBase,$
                        XOFFSET   = sManualFittingButton.size[0],$
                        YOFFSET   = sManualFittingButton.size[1],$
                        SCR_XSIZE = sManualFittingButton.size[2],$
                        SCR_YSIZE = sManualFittingButton.size[3],$
                        VALUE     = sManualFittingButton.value,$
                        UNAME     = sManualFittingButton.uname)


;Alternate Wavelength Axis ----------------------------------------------------
wGroup = CW_BGROUP(wTabBase,$
                   sAxisGroup.list,$
                   XOFFSET    = sAxisGroup.size[0],$
                   YOFFSET    = sAxisGroup.size[1],$
                   ROW        = 1,$
                   SET_VALUE  = sAxisGroup.value,$
                   UNAME      = sAxisGroup.uname,$
                   LABEL_LEFT = sAxisGroup.title,$
                   /EXCLUSIVE)

wWaveBase = WIDGET_BASE(wTabBase,$
                    XOFFSET   = sAltBase.size[0],$
                    YOFFSET   = sAltBase.size[1],$
                    SCR_XSIZE = sAltBase.size[2],$
                    SCR_YSIZE = sAltBase.size[3],$
                    UNAME     = sAltBase.uname,$
                    MAP       = sAltBase.map,$
                    FRAME     = sAltBase.frame)
;Wavelengthmin
wWavelengthminLabel = WIDGET_LABEL(wWaveBase,$
                          XOFFSET = sWavelengthminLabel.size[0],$
                          YOFFSET = sWavelengthminLabel.size[1],$
                          VALUE   = sWavelengthminLabel.value)

wWavelengthminText = WIDGET_TEXT(wWaveBase,$
                        XOFFSET   = sWavelengthminText.size[0],$
                        YOFFSET   = sWavelengthminText.size[1],$
                        SCR_XSIZE = sWavelengthminText.size[2],$
                        VALUE     = sWavelengthminText.value,$
                        UNAME     = sWavelengthminText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Wavelengthmax
wWavelengthmaxLabel = WIDGET_LABEL(wWaveBase,$
                          XOFFSET = sWavelengthmaxLabel.size[0],$
                          YOFFSET = sWavelengthmaxLabel.size[1],$
                          VALUE   = sWavelengthmaxLabel.value)

wWavelengthmaxText = WIDGET_TEXT(wWaveBase,$
                        XOFFSET   = sWavelengthmaxText.size[0],$
                        YOFFSET   = sWavelengthmaxText.size[1],$
                        SCR_XSIZE = sWavelengthmaxText.size[2],$
                        VALUE     = sWavelengthmaxText.value,$
                        UNAME     = sWavelengthmaxText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Wavelengthwidth
wWavelengthwidthLabel = WIDGET_LABEL(wWaveBase,$
                          XOFFSET = sWavelengthwidthLabel.size[0],$
                          YOFFSET = sWavelengthwidthLabel.size[1],$
                          VALUE   = sWavelengthwidthLabel.value)

wWavelengthwidthText = WIDGET_TEXT(wWaveBase,$
                        XOFFSET   = sWavelengthwidthText.size[0],$
                        YOFFSET   = sWavelengthwidthText.size[1],$
                        SCR_XSIZE = sWavelengthwidthText.size[2],$
                        VALUE     = sWavelengthwidthText.value,$
                        UNAME     = sWavelengthwidthText.uname,$
                        /ALL_EVENTS,$
                        /EDITABLE,$
                        /ALIGN_LEFT)

;Wavelength scale
wWavelengthscaleGroup =  CW_BGROUP(wWaveBase,$
                          sWavelengthscaleGroup.list,$
                          XOFFSET    = sWavelengthscaleGroup.size[0],$
                          YOFFSET    = sWavelengthscaleGroup.size[1],$
                          ROW        = 1,$
                          SET_VALUE  = sWavelengthscaleGroup.value,$
                          UNAME      = sWavelengthscaleGroup.uname,$
                          /EXCLUSIVE)

;output file name -------------------------------------------------------------
;label
wLabel = WIDGET_LABEL(wTabBase,$
                      XOFFSET = sOutputFileLabel.size[0],$
                      YOFFSET = sOutputFileLabel.size[1],$
                      VALUE   = sOutputFileLabel.value)
;output folder button
wOutputFolderButton = WIDGET_BUTTON(wTabBase,$
                                    XOFFSET = sOutputFolderButton.size[0],$
                                    YOFFSET = sOutputFolderButton.size[1],$
                                    SCR_XSIZE = sOutputFolderButton.size[2],$
                                    SCR_YSIZE = sOutputFolderButton.size[3],$
                                    UNAME     = sOutputFolderButton.uname,$
                                    VALUE     = sOutputFolderButton.value,$
                                    SENSITIVE = sOutputFolderButton.sensitive)

;file name input
wTextField = WIDGET_TEXT(wTabBase,$
                         XOFFSET   = sOutputFileTextField.size[0],$
                         YOFFSET   = sOutputFileTextField.size[1],$
                         SCR_XSIZE = sOutputFileTextField.size[2],$
                         VALUE     = sOutputFileTextField.value,$
                         UNAME     = sOutputFileTextField.uname,$
                         /EDITABLE)
;save button
wSaveButton = WIDGET_BUTTON(wTabBase,$
                            XOFFSET   = sOutputFileSaveButton.size[0],$
                            YOFFSET   = sOutputFileSaveButton.size[1],$
                            SCR_XSIZE = sOutputFileSaveButton.size[2],$
                            SCR_YSIZE = sOutputFileSaveButton.size[3],$
                            VALUE     = sOutputFileSaveButton.value,$
                            UNAME     = sOutputFileSaveButton.uname,$
                            SENSITIVE = sOutputFileSaveButton.sensitive)

;preview button
wOutputFileEditSaveButton = WIDGET_BUTTON(wTabBase,$
                               XOFFSET   = sOutputFileEditSaveButton.size[0],$
                               YOFFSET   = sOutputFileEditSaveButton.size[1],$
                               SCR_XSIZE = sOutputFileEditSaveButton.size[2],$
                               SCR_YSIZE = sOutputFileEditSaveButton.size[3],$
                               VALUE     = sOutputFileEditSaveButton.value,$
                               UNAME     = sOutputFileEditSaveButton.uname,$
                               SENSITIVE = sOutputFileEditSaveButton.sensitive)

END
