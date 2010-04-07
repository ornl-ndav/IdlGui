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

PRO MakeGuiLoadTab, MAIN_TAB, $
                    MainTabSize, $
                    LoadTabTitle, $
                    instrument, $
                    MAIN_BASE

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

;RunNumber label and inside CW_FIELD
RunNumberBaseSize    = [140,0,250,35]
RunNumberCWFieldSize = [10,0]
GlobalRunNumber      = [RunNumberBaseSize,$
                        RunNumberCWFieldSize]
RunNumberTitles      =  ['DATA RUN NUMBER:',$
                         'NORMALIZATION RUN NUMBER:']

;1D and 2D tabs
LoadTabSize   = [0,$
                 0,$
                 MainTabSize[2],$
                 MainTabSize[3]]
D_DD_TabSize  = [30,$
                 35,$
                 MainTabSize[2]-570,$
                 MainTabSize[3]-85]
D_DD_BaseSize = [5,$
                 5,$
                 D_DD_TabSize[2],$
                 D_DD_TabSize[3]]

if (instrument EQ 'REF_L') then begin
    DTitle = 'Y vs TOF (2D)'
    D3DTitle = 'Y vs TOF (3D)'
endif else begin
    DTitle = 'X vs TOF'
    D3DTitle = 'X vs TOF (3D)'
endelse

D_DD_TabTitle = [DTitle,$
                 'Y vs X (2D)',$
                 D3DTitle,$
                 'Y vs X (3D)']

;Size of 1D and 2D graphs
Nx = 256
Ny = 304
if (instrument EQ 'REF_L') then begin
    xoff = 49
    yoff = 0
    xsize = 2*Nx
    ysize = 2*Ny
endif else begin
    xoff = 5
    yoff = 40
    xsize = 2*Ny
    ysize = 2*Nx
endelse

LoadDataNormalization1DGraphSize    = [5,0,608,608]
LoadDataNormalization2DRefGraphSize = [xoff,yoff,xsize,ysize]
GlobalLoadDataGraphs = [LoadDataNormalization1DGraphSize,$
                        LoadDataNormalization2DRefGraphSize]

;NXsummary and Zoom tab
NxsummaryZoomTabSize = [D_DD_TabSize[2]+50,$
                        15,$
                        495,$
                        395]
NxsummaryZoomTitle = ['  N X  s u m m a r y  ',' Z  O  O  M ']

ZoomScaleBaseSize = [380,0,110,35]
ZoomScaleTitle = 'Zoom factor'

;File info hudge label (empty for now)
;top label
FileInfoSize_1 = [0,$
                  0,$
                  489,$
                  370] ;393

;help text box to explain what is going on on the left
LeftInteractionHelpMessageBaseSize = [D_DD_TabSize[2]+50,$
                                      425,$
                                      495,$
                                      190+100]
LeftInteractionHelpMessageLabelSize = [5,5]
LeftInteractionHelpMessageLabelTitle = 'I N F O'
LeftInteractionHelpTextSize = [5,25,485,160+100]
LeftInteractionHelpSize = [LeftInteractionHelpMessageBaseSize,$
                           LeftInteractionHelpMessageLabelSize,$
                           LeftInteractionHelpTextsize]
                           
;bottom text field
FileInfoSize_2 = [NxsummaryZoomTabSize[0],$
                  625+100,$
                  498,$
                  190-100]

FileInfoSize = [FileInfoSize_1,FileInfoSize_2]

;----Build widgets-----
LOAD_BASE = WIDGET_BASE(MAIN_TAB,$
                        UNAME='load_base',$
                        TITLE=LoadTabTitle,$
                        XOFFSET=LoadTabSize[0],$
                        YOFFSET=LoadTabSize[1],$
                        SCR_XSIZE=LoadTabSize[2],$
                        SCR_YSIZE=LoadTabSize[3])

;Build DATA and NORMALIZATION tabs
MakeGuiLoadDataNormalizationTab,$
  LOAD_BASE,$
  MainTabSize,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles,$
  GlobalLoadDataGraphs,$
  FileInfoSize,$
  LeftInteractionHelpsize,$
  LeftInteractionHelpMessageLabeltitle,$
  NxsummaryZoomTabSize,$
  NxsummaryZoomTitle,$
  ZoomScaleBaseSize,$
  ZoomScaleTitle,$
  MAIN_BASE
  
END
