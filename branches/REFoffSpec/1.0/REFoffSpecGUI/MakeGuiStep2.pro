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

PRO make_gui_step2, REDUCE_TAB, tab_size, TabTitles

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

sBaseTab = { size:  tab_size,$
             uname: 'step2_tab_base',$
             title: TabTitles.step2}

XYoff = [5,5] ;Browse button --------------------------------------------------
sBrowseButton = { size: [XYoff[0],$
                         XYoff[1],$
                         150],$
                  value: 'BROWSE ASCII ...',$
                  tooltip: 'Select an ASCII file to load',$
                  uname: 'browse_ascii_file_button'}
                  
XYoff = [0,0] ;List of ascii files --------------------------------------------
sAsciiList = { size: [sBrowseButton.size[0]+$
                      sBrowseButton.size[2]+XYoff[0],$
                      sBrowseButton.size[1]+XYoff[1],$
                      700,150],$
               uname: 'ascii_file_list',$
               sensitive: 1,$
               value: ['']}

XYoff = [0,0] ;Preview button -------------------------------------------------
sPreviewButton = { size: [sAsciiList.size[0]+$
                          sAsciiList.size[2]+XYoff[0],$
                          sAsciiList.size[1]+XYoff[1],$
                          220],$
                   value: 'PREVIEW OF SELECTED ASCII FILE ...',$
                   uname: 'ascii_preview_button',$
                   tooltip: 'Preview of selected ASCII file',$
                   sensitive: 1}

XYoff = [0,30] ;Delete ascii file button --------------------------------------
sDeleteButton = { size: [sPreviewButton.size[0]+XYoff[0],$
                         sPreviewButton.size[1]+XYoff[1],$
                         sPreviewButton.size[2]],$
                  value: 'DELETE SELECTED ASCII FILE ...',$
                  uname: 'ascii_delete_button',$
                  tooltip: 'Delete Selected ASCII file',$
                  sensitive: 1}

XYOff = [0,10] ;Draw ----------------------------------------------------------
sDraw = { size: [XYoff[0],$
                 sAsciiList.size[1]+$
                 sAsciiList.size[3]+XYoff[1],$
                 tab_size[2],$
                 304L*2],$
          scroll_size: [tab_size[2]-35,$
                        304L*2+2],$
          uname: 'step2_draw'}
          
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

;Browse button ----------------------------------------------------------------
wBrowseButton = WIDGET_BUTTON(BaseTab,$
                              XOFFSET   = sBrowseButton.size[0],$
                              YOFFSET   = sBrowseButton.size[1],$
                              SCR_XSIZE = sBrowseButton.size[2],$
                              VALUE     = sBrowseButton.value,$
                              TOOLTIP   = sBrowseButton.tooltip,$
                              UNAME     = sBrowseButton.uname)

;List of Ascii files ----------------------------------------------------------
wAsciiList = WIDGET_LIST(BaseTab,$
                         XOFFSET   = sAsciiList.size[0],$
                         YOFFSET   = sAsciiList.size[1],$
                         SCR_XSIZE = sAsciiList.size[2],$
                         SCR_YSIZE = sAsciiList.size[3],$
                         VALUE     = sAsciiList.value,$
                         UNAME     = sAsciiList.uname,$
                         SENSITIVE = sAsciiList.sensitive)

;Preview Button ---------------------------------------------------------------
wPreviewButton = WIDGET_BUTTON(BaseTab,$
                               XOFFSET   = sPreviewButton.size[0],$
                               YOFFSET   = sPreviewButton.size[1],$
                               SCR_XSIZE = sPreviewButton.size[2],$
                               VALUE     = sPreviewButton.value,$
                               UNAME     = sPreviewButton.uname,$
                               SENSITIVE = sPreviewButton.sensitive,$
                               TOOLTIP   = sPreviewButton.tooltip)

;Delete Button ----------------------------------------------------------------
wDeleteButton = WIDGET_BUTTON(BaseTab,$
                              XOFFSET   = sDeleteButton.size[0],$
                              YOFFSET   = sDeleteButton.size[1],$
                              SCR_XSIZE = sDeleteButton.size[2],$
                              VALUE     = sDeleteButton.value,$
                              UNAME     = sDeleteButton.uname,$
                              SENSITIVE = sDeleteButton.sensitive,$
                              TOOLTIP   = sDeleteButton.tooltip)

;Draw -------------------------------------------------------------------------
wDraw = WIDGET_DRAW(BaseTab,$
                    XOFFSET       = sDraw.size[0],$
                    YOFFSET       = sDraw.size[1],$
                    XSIZE         = sDraw.size[2],$
                    YSIZE         = sDraw.size[3],$
                    X_SCROLL_SIZE = sDraw.scroll_size[0],$
                    Y_SCROLL_SIZE = sDraw.scroll_size[1],$
                    UNAME         = sDraw.uname,$
;                    /MOTION_EVENTS,$
                    /SCROLL)


END
