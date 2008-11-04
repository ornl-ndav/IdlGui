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

;------------------------------------------------------------------------------
PRO plotTxt_build_gui, sStructure

xoffset = (*sStructure).base_geometry.xoffset
yoffset = (*sStructure).base_geometry.yoffset
xsize   = (*sStructure).base_geometry.xsize
ysize   = (*sStructure).base_geometry.ysize
title   = 'Sq(E) : ' + (*sStructure).output_file_name

main_base = WIDGET_BASE(XOFFSET   = xoffset,$
                        YOFFSET   = yoffset,$
                        SCR_XSIZE = xsize,$
                        SCR_YSIZE = ysize,$
                        TITLE     = title)



Widget_Control, /REALIZE, main_base
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK



END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLplotTxt::init, sStructure

;get number of X(E) and Y(Q) elements
;xsize = N_ELEMENTS((*sStructure).Edata)
;ysize = N_ELEMENTS((*sStructure).Qdata)

xsize = 1000 ;remove_me
ysize = 20 ;remove_me

;build gui
plotTxt_build_gui, sStructure


RETURN,1
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO IDLplotTxt__define
struct = {IDLplotTxt,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
