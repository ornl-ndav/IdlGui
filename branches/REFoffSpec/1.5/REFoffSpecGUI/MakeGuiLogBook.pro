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

PRO make_gui_log_book, MAIN_TAB, MainTabSize, TabTitles

;******************************************************************************
;            DEFINE STRUCTURE
;******************************************************************************

;- base -----------------------------------------------------------------------
sLogBookBase = { size  : MainTabSize,$
                 title : TabTitles.log_book,$
                 uname : 'base_log_book'}

;- log book text --------------------------------------------------------------
sLogBook = { size  : [0,0,MainTabSize[2]-10,700],$
             uname : 'log_book_text'} 

;- Log Book instance ----------------------------------------------------------
sLogBookInstance = { size : [0,$
                             sLogBook.size[3]+10,$
                             MainTabSize[2]-15],$
                     uname : 'log_book_text',$
                     frame : 5,$
                     title : 'Send To Geek'}
                                                  
;******************************************************************************
;            BUILD GUI
;******************************************************************************

;- base -----------------------------------------------------------------------
wLogBookBase = WIDGET_BASE(MAIN_TAB,$
                           UNAME     = sLogBookBase.uname,$
                           XOFFSET   = sLogBookBase.size[0],$
                           YOFFSET   = sLogBookBase.size[1],$
                           SCR_XSIZE = sLogBookBase.size[2],$
                           SCR_YSIZE = sLogBookBase.size[3],$
                           TITLE     = sLogBookBase.title)

;- log book text --------------------------------------------------------------
wLogBookText = WIDGET_TEXT(wLogBookBase,$
                           UNAME     = sLogBook.uname,$
                           XOFFSET   = sLogBook.size[0],$
                           YOFFSET   = sLogBook.size[1],$
                           SCR_XSIZE = sLogBook.size[2],$
                           SCR_YSIZE = sLogBook.size[3],$
                           /SCROLL,$
                           /WRAP)
                       
;- Send To Geek ---------------------------------------------------------------
LogBookInstace = OBJ_NEW('IDLsendToGeek',$
                         XOFFSET   = sLogBookInstance.size[0],$
                         YOFFSET   = sLogBookInstance.size[1],$
                         XSIZE     = sLogBookInstance.size[2],$
                         FRAME     = sLogBookInstance.frame,$
                         TITLE     = sLogBookInstance.title,$
                         MAIN_BASE = wLogBookBase)


END
