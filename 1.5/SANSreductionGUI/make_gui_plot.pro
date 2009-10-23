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

PRO make_gui_plot, MAIN_TAB, MainTabSize, TabTitles

;- base -----------------------------------------------------------------------
sTabBase = { size  : MainTabSize,$
              title : TabTitles.plot,$
              uname : 'base_plot'}

;- Refresh Plot ---------------------------------------------------------------
sRefreshButton = { size: [10,10,150],$
                   uname: 'plot_refresh_plot_ascii_button',$
                   value: 'REFRESH PLOT',$
                   sensitive: 0}

;- Advanced Plot --------------------------------------------------------------
sAdvancedButton = { size: [750,10,250],$
                   uname: 'plot_advanced_plot_ascii_button',$
                   value: 'ADVANCED PLOT',$
                   sensitive: 0}

;- Plot -----------------------------------------------------------------------
XYoff = [0,0]
sDraw = { size: [XYoff[0],$
                 XYoff[1],$
                 MainTabSize[2], $
                 MainTabSize[3]-80],$
          uname: 'plot_draw_uname'}

;Loading ascii file -----------------------------------------------------------
XYoff = [5,15]
sInputFileLabel = { size: [XYoff[0],$
                           sDraw.size[1]+sDraw.size[3]+XYoff[1]],$
                    value: 'Input File Name:'}
XYoff = [115,-5]
sInputBrowse = { size: [XYoff[0],$
                        sInputFileLabel.size[1]+XYoff[1],$
                        105,30],$
                 value: 'BROWSE ...',$
                 uname: 'plot_input_file_browse_button'}
XYoff = [0,-5]
sInputFileTextField = { size: [sInputBrowse.size[0]+ $
                               sInputBrowse.size[2]+ XYoff[0],$
                               sInputFileLabel.size[1]+XYoff[1],$
                               570],$
                        uname: 'plot_input_file_text_field',$
                        value: ''}
XYoff = [5,0]
sInputFileSaveButton = { size: [sInputFileTextField.size[0]+$
                                sInputFileTextField.size[2]+XYoff[0],$
                                sInputFileTextField.size[1]+XYoff[1],$
                                105,30],$
                         value: 'LOAD FILE',$
                         uname: 'plot_input_file_load_button',$
                         sensitive: 0}
XYoff = [0,0]
sInputFilePreviewButton = { size: [sInputFileSaveButton.size[0]+$
                                   sInputFileSaveButton.size[2]+XYoff[0],$
                                   sInputFileSaveButton.size[1]+XYoff[1],$
                                   sInputFileSaveButton.size[2:3]],$
                            value: 'PREVIEW',$
                            uname: 'plot_input_file_preview_button',$
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

;- Refresh Button -------------------------------------------------------------
wRefresh = WIDGET_BUTTON(wTabBase,$
                         XOFFSET   = sRefreshButton.size[0],$
                         YOFFSET   = sRefreshButton.size[1],$
                         SCR_XSIZE = sRefreshButton.size[2],$
                         VALUE     = sRefreshButton.value,$
                         UNAME     = sRefreshButton.uname,$
                         SENSITIVE = sRefreshButton.sensitive)

;- advanced Button -------------------------------------------------------------
wadvanced = WIDGET_BUTTON(wTabBase,$
                         XOFFSET   = sadvancedButton.size[0],$
                         YOFFSET   = sadvancedButton.size[1],$
                         SCR_XSIZE = sadvancedButton.size[2],$
                         VALUE     = sadvancedButton.value,$
                         UNAME     = sadvancedButton.uname,$
                         SENSITIVE = sadvancedButton.sensitive)

;- Draw -----------------------------------------------------------------------
wDraw = WIDGET_DRAW(wTabBase,$
                    XOFFSET   = sDraw.size[0],$
                    YOFFSET   = sDraw.size[1],$
                    SCR_XSIZE = sDraw.size[2],$
                    SCR_YSIZE = sDraw.size[3],$
                    /MOTION_EVENTS, $
                    /BUTTON_EVENTS, $
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


END
