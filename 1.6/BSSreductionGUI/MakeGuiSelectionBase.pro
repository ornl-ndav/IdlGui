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

PRO MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

;******************************************************************************
;                                Build GUI
;******************************************************************************

SelectionTabBase = WIDGET_BASE(NeXusRoiSelectionTab,$
                               XOFFSET   = 0,$
                               YOFFSET   = 0,$
                               SCR_XSIZE = OpenNeXusSelectionTab[2]-5,$
                               SCR_YSIZE = OpenNeXusSelectionTab[3],$
                               TITLE     = title)

cw_field_xsize = 35
yoffset = 40

;Pixel id base
fbase = WIDGET_BASE(SelectionTabBase,$
                    UNAME        = 'fbase',$
                    XOFFSET      = 0,$
                    YOFFSET      = 0,$
                    /BASE_ALIGN_CENTER,$
                    SENSITIVE    = 0,$
                    ROW          = 1)

text   = CW_FIELD(fbase,$
                  UNAME          = 'pixelid',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Pixel ID:',$
                  ROW            = 1,$
                  XSIZE          = cw_field_xsize)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'EXCLUDE',$
                       UNAME     = 'exclude_pixelid',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(fbase,$
                       VALUE     = 'INCLUDE',$
                       UNAME     = 'include_pixelid',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)


;Row of pixels
abase = WIDGET_BASE(SelectionTabBase,$
                    UNAME        = 'abase',$
                    XOFFSET      = 0,$
                    YOFFSET      = yoffset,$
                    /BASE_ALIGN_CENTER,$
                    SENSITIVE    = 0,$
                    ROW          = 1)

text   = CW_FIELD(abase,$
                  UNAME          = 'pixel_row',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Row (Y): ',$
                  ROW            = 1,$
                  XSIZE          = cw_field_xsize)

button = WIDGET_BUTTON(abase,$
                       VALUE     = 'EXCLUDE',$
                       UNAME     = 'exclude_pixel_row',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(abase,$
                       VALUE     = 'INCLUDE',$
                       UNAME     = 'include_pixel_row',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)


;Tube base
sbase = WIDGET_BASE(SelectionTabBase,$
                    /BASE_ALIGN_CENTER,$
                    XOFFSET      = 0,$
                    YOFFSET      = 2*yoffset,$
                    UNAME        = 'sbase',$
                    SENSITIVE    = 0,$
                    ROW          = 1)

text   = CW_FIELD(sbase,$
                  UNAME          = 'tube',$
                  RETURN_EVENTS  = 1,$
                  TITLE          = 'Tube #:  ',$
                  ROW            = 1,$
                  XSIZE          = cw_field_xsize)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'EXCLUDE',$
                       UNAME     = 'exclude_tube',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)

button = WIDGET_BUTTON(sbase,$
                       VALUE     = 'INCLUDE',$
                       UNAME     = 'include_tube',$
                       SCR_XSIZE = 55,$
                       SCR_YSIZE = 30,$
                       SENSITIVE = 0)


;Excluded type (full or empty box)
base = WIDGET_BASE(SelectionTabBase,$
                   XOFFSET   = 0,$
                   YOFFSET   = 3*yoffset,$
                   /BASE_ALIGN_CENTER,$
                   UNAME     = 'symbol_base',$
                   SENSITIVE = 0,$
                   ROW       = 1)
ExcludedTypeLabel = WIDGET_LABEL(base,$
                                VALUE = 'Excluded Pixel Symbol:')

excludedTypeList = ['Empty Box', 'Full Box']
ExcludedType = CW_BGROUP(base, $
                         excludedTypeList, $
                         /EXCLUSIVE, $
                         SET_VALUE = 0, $
                         UNAME     = 'excluded_pixel_type', $
                         ROW       = 1)

button = WIDGET_BUTTON(base,$
                       UNAME     = 'select_everything_button',$
                       SCR_XSIZE = 100,$
                       SCR_YSIZE = 30,$
                       VALUE     = 'SELECT ALL')


;excluded pixel that have value LE than ... and full reset
ExclusionBase = WIDGET_BASE(SelectionTabBase,$
                            UNAME     = 'exclusion_base',$
                            XOFFSET   = 0,$
                            YOFFSET   = 4*yoffset,$
                            SCR_XSIZE = 310,$
                            SCR_YSIZE = 45,$
                            ROW       = 1,$
                            SENSITIVE = 0)

eBase = WIDGET_BASE(ExclusionBase,$
                    /BASE_ALIGN_CENTER,$
                    SENSITIVE = 1,$
                    UNAME     = 'ebase',$
                    ROW       = 1)

text = CW_FIELD(ExclusionBase,$
                UNAME         = 'counts_exclusion',$
                RETURN_EVENTS = 1,$
                TITLE         = 'Exclude Pixel with I <= ',$
                ROW           = 1,$
                XSIZE         = 3,$
                /LONG)

text = CW_FIELD(ExclusionBase,$
                UNAME         = 'counts_exclusion_2',$
                RETURN_EVENTS = 1,$
                TITLE         = 'and >= ',$
                ROW           = f1,$
                XSIZE         = 5,$
                /LONG)

button = WIDGET_BUTTON(SelectionTabBase,$
                       XOFFSET   = 310,$
                       YOFFSET   = 4*yoffset+5,$
                       UNAME     = 'reset_button',$
                       VALUE     = 'FULL RESET',$
                       SCR_XSIZE = 95,$
                       SCR_YSIZE = 33,$
                       SENSITIVE = 0)
               

END
