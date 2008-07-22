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

PRO make_gui_tab1, MAIN_TAB, MainTabSize, TabTitles

;- base -----------------------------------------------------------------------
sTab1Base = { size  : MainTabSize,$
              title : TabTitles.tab1,$
              uname : 'base_tab1'}

;- draw -----------------------------------------------------------------------
sDraw = { size  : [0,0,640,640],$
          uname : 'draw_uname'}


;- selection ------------------------------------------------------------------
XYoff = [5,0]
sSelection = { size: [sDraw.size[0]+sDraw.size[2]+XYoff[0],$
                      XYoff[1],$
                      360,$
                      35],$
               value: 'ADVANCED SELECTION TOOL',$
               uname: 'selection_tool_button',$
               sensitive: 0}

;- Load Selection -------------------------------------------------------------
XYoff = [0,15] ;frame
sSelectionFrame = { size:  [sSelection.size[0]+XYoff[0],$
                            sSelection.size[1]+sSelection.size[3]+XYoff[1],$
                            sSelection.size[2],105],$
                    frame: 1}
XYoff = [10,-8] ;title
sSelectionLabel = { size: [sSelectionFrame.size[0]+XYoff[0],$
                           sSelectionFrame.size[1]+XYoff[1]],$
                    value: 'Load Selection',$
                    uname: 'load_selection_label',$
                    sensitive: 0}
XYoff = [5,10] ;browse button
sSelectionBrowse = { size: [sSelectionFrame.size[0]+XYoff[0],$
                            sSelectionFrame.size[1]+XYoff[1],$
                            250],$
                     value: 'BROWSE ...',$
                     uname: 'selection_browse_button',$
                     sensitive: 0}
XYoff = [0,0] ;preview button
sSelectionPreview = { size: [sSelectionBrowse.size[0]+$
                             sSelectionBrowse.size[2]+XYoff[0],$
                             sSelectionBrowse.size[1]+XYoff[1],$
                             102],$
                      value: 'PREVIEW',$
                      uname: 'selection_preview_button',$
                      sensitive: 0}
XYoff = [0,30] ;file name text field
sSelectionFileName = { size: [sSelectionBrowse.size[0]+XYoff[0],$
                              sSelectionBrowse.size[1]+XYoff[1],$
                              352],$
                       value: '',$
                       uname: 'selection_file_name_text_field'}
XYoff = [0,35] ;load selection button
sSelectionLoad = { size: [sSelectionBrowse.size[0]+XYoff[0],$
                          sSelectionFileName.size[1]+XYoff[1],$
                          sSelectionFileName.size[2]],$
                   uname: 'selection_load_button',$
                   value: 'L O A D  /  P L O T',$
                   sensitive: 0 }
                       
;- Clear Selection ------------------------------------------------------------
XYoff = [0,250]
sClearSelection = { size: [sSelection.size[0]+XYoff[0],$
                           sSelection.size[1]+sSelection.size[3]+XYoff[1],$
                           sSelection.size[2]],$
                    value: 'RESET SELECTION',$
                    uname: 'clear_selection_button',$
                    sensitive: 0}
                           
;- nexus input ----------------------------------------------------------------
sNexus = { size : [0,$
                   sDraw.size[1]+sDraw.size[3]+15]}
          
;==============================================================================
;= BUILD GUI ==================================================================
;==============================================================================

;- base -----------------------------------------------------------------------
wTab1Base = WIDGET_BASE(MAIN_TAB,$
                        UNAME     = sTab1Base.uname,$
                        XOFFSET   = sTab1Base.size[0],$
                        YOFFSET   = sTab1Base.size[1],$
                        SCR_XSIZE = sTab1Base.size[2],$
                        SCR_YSIZE = sTab1Base.size[3],$
                        TITLE     = sTab1Base.title)

;- draw -----------------------------------------------------------------------
wDraw = WIDGET_DRAW(wTab1Base,$
                    UNAME     = sDraw.uname,$
                    XOFFSET   = sDraw.size[0],$
                    YOFFSET   = sDraw.size[1],$
                    SCR_XSIZE = sDraw.size[2],$
                    SCR_YSIZE = sDraw.size[3])

;- Selection tool -------------------------------------------------------------
wSelection = WIDGET_BUTTON(wTab1Base,$
                           XOFFSET   = sSelection.size[0],$
                           YOFFSET   = sSelection.size[1],$
                           SCR_XSIZE = sSelection.size[2],$
                           SCR_YSIZE = sSelection.size[3],$
                           VALUE     = sSelection.value,$
                           UNAME     = sSelection.uname,$
                           SENSITIVE = sSelection.sensitive)

;- Load Selection -------------------------------------------------------------
;Title
wSelectionLabel = WIDGET_LABEL(wTab1Base,$
                               XOFFSET   = sSelectionLabel.size[0],$
                               YOFFSET   = sSelectionLabel.size[1],$
                               VALUE     = sSelectionLabel.value,$
                               SENSITIVE = sSelectionLabel.sensitive,$
                               UNAME     = sSelectionLabel.uname)

;Browse button
wSelectionBrowse = WIDGET_BUTTON(wTab1Base,$
                                 XOFFSET   = sSelectionBrowse.size[0],$
                                 YOFFSET   = sSelectionBrowse.size[1],$
                                 SCR_XSIZE = sSelectionBrowse.size[2],$
                                 VALUE     = sSelectionBrowse.value,$
                                 UNAME     = sSelectionBrowse.uname,$
                                 SENSITIVE = sSelectionBrowse.sensitive)

;Preview button
wSelectionPreview = WIDGET_BUTTON(wTab1Base,$
                                  XOFFSET   = sSelectionPreview.size[0],$
                                  YOFFSET   = sSelectionPreview.size[1],$
                                  SCR_XSIZE = sSelectionPreview.size[2],$
                                  VALUE     = sSelectionPreview.value,$
                                  UNAME     = sSelectionPreview.uname,$
                                  SENSITIVE = sSelectionPreview.sensitive)

;Selection File Name
wSelectionFileName = WIDGET_TEXT(wTab1Base,$
                                 XOFFSET   = sSelectionFileName.size[0],$
                                 YOFFSET   = sSelectionFileName.size[1],$
                                 SCR_XSIZE = sSelectionFileName.size[2],$
                                 UNAME     = sSelectionFileName.uname,$
                                 VALUE     = sSelectionFileName.value,$
                                 /EDITABLE,$
                                 /ALIGN_LEFT,$
                                 /ALL_EVENTS)

;Load Button
wSelectionLoad = WIDGET_BUTTON(wTab1Base,$
                               XOFFSET   = sSelectionLoad.size[0],$
                               YOFFSET   = sSelectionLoad.size[1],$
                               SCR_XSIZE = sSelectionLoad.size[2],$
                               VALUE     = sSelectionLoad.value,$
                               UNAME     = sSelectionLoad.uname,$
                               SENSITIVE = sSelectionLoad.sensitive)
;Frame
wSelectionFrame = WIDGET_LABEL(wTab1Base,$
                               XOFFSET   = sSelectionFrame.size[0],$
                               YOFFSET   = sSelectionFrame.size[1],$
                               SCR_XSIZE = sSelectionFrame.size[2],$
                               SCR_YSIZe = sSelectionFrame.size[3],$
                               FRAME     = sSelectionFrame.frame,$
                               VALUE     = '')

;- Clear Selection ------------------------------------------------------------
wClearSelection = WIDGET_BUTTON(wTab1Base,$
                                XOFFSET   = sClearSelection.size[0],$
                                YOFFSET   = sClearSelection.size[1],$
                                SCR_XSIZE = sClearSelection.size[2],$
                                VALUE     = sClearSelection.value,$
                                UNAME     = sClearSelection.uname,$
                                SENSITIVE = sClearSelection.sensitive)

;------------------------------------------------------------------------------
;- nexus input ----------------------------------------------------------------
sNexus = {MainBase:    wTab1Base,$
          xoffset:     sNexus.size[0],$
          yoffset:     sNexus.size[1],$
          instrument:  'SANS',$
          facility:    'LENS'}
nexus_instance = OBJ_NEW('IDLloadNexus', sNexus)


END
