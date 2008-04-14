;===============================================================================
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
;===============================================================================

PRO make_gui_tab1, MAIN_TAB, MainTabSize, TabTitles

;- base ------------------------------------------------------------------------
sTab1Base = { size  : MainTabSize,$
              title : TabTitles.tab1,$
              uname : 'base_tab1'}

;- draw ------------------------------------------------------------------------
sDraw = { size  : [0,0,320,320],$
          uname : 'draw_uname'}

;- nexus input -----------------------------------------------------------------
sNexus = { size : [0,$
                   sDraw.size[1]+sDraw.size[3]+15]}
          
;===============================================================================
;= BUILD GUI ===================================================================
;===============================================================================

;- base ------------------------------------------------------------------------
wTab1Base = WIDGET_BASE(MAIN_TAB,$
                        UNAME     = sTab1Base.uname,$
                        XOFFSET   = sTab1Base.size[0],$
                        YOFFSET   = sTab1Base.size[1],$
                        SCR_XSIZE = sTab1Base.size[2],$
                        SCR_YSIZE = sTab1Base.size[3],$
                        TITLE     = sTab1Base.title)

;- draw ------------------------------------------------------------------------
wDraw = WIDGET_DRAW(wTab1Base,$
                    UNAME     = sDraw.uname,$
                    XOFFSET   = sDraw.size[0],$
                    YOFFSET   = sDraw.size[1],$
                    SCR_XSIZE = sDraw.size[2],$
                    SCR_YSIZE = sDraw.size[3])

;- nexus input -----------------------------------------------------------------
sNexus = {MainBase   : wTab1Base,$
          xoffset    : sNexus.size[0],$
          yoffset    : sNexus.size[1],$
          instrument : 'sans'}
nexus_instance = OBJ_NEW('IDLloadNexus', sNexus)


END
