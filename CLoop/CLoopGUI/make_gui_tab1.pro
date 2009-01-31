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

PRO make_gui_tab1, MAIN_TAB, MainTabSize, title

;Load button
XYoff = [5,5]
sLoad = { size: [XYoff[0],$
                 XYoff[1],$
                 150],$
          value: 'BROWSE CL FILE ...',$
          uname: 'load_cl_file_button'}

;Label (file name: and 'name of file')
XYoff = [10,6]
sLabel1 = { size: [sLoad.size[0]+sLoad.size[2]+XYoff[0],$
                   sLoad.size[1]+XYoff[1]],$
            value: 'CL File Loaded:' }
XYoff = [100,0]
sLabel2 = { size: [sLabel1.size[0]+XYoff[0],$
                   sLabel1.size[1]+XYoff[1],$
                   400],$
            value: 'N/A',$
            uname: 'cl_file_name_label'}

;==============================================================================

Base = WIDGET_BASE(MAIN_TAB,$
                   UNAME     = 'tab1_uname',$
                   XOFFSET   = MainTabSize[0],$
                   YOFFSET   = MainTabSize[1],$
                   SCR_XSIZE = MainTabSize[2],$
                   SCR_YSIZE = MainTabSize[3],$
                   TITLE     = title,$
                   map = 0)

;Load Button
wLoad = WIDGET_BUTTON(Base,$
                      XOFFSET   = sLoad.size[0],$
                      YOFFSET   = sLoad.size[1],$
                      SCR_XSIZE = sLoad.size[2],$
                      UNAME     = sLoad.uname,$
                      VALUE     = sLoad.value)

;File Name Labels
wLabel1 = WIDGET_LABEL(Base,$
                       XOFFSET = sLabel1.size[0],$
                       YOFFSET = sLabel1.size[1],$
                       VALUE   = sLabel1.value)
                       
wLabel2 = WIDGET_LABEL(Base,$
                       XOFFSET   = sLabel2.size[0],$
                       YOFFSET   = sLabel2.size[1],$
                       SCR_XSIZE = sLabel2.size[2],$
                       VALUE     = sLabel2.value,$
                       UNAME     = sLabel2.uname,$
                       /ALIGN_LEFT)     

END


