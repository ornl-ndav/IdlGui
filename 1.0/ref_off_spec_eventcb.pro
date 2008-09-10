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
;Preview of selected ascii file(s)
PRO  preview_ascii_file, Event ;_eventcb
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

list_OF_files = (*(*global).list_OF_ascii_files)
index = getAsciiSelectedIndex(Event)
IF (index[0] NE -1) THEN BEGIN
    sz = N_ELEMENTS(index)
    CASE (sz) OF
        1: XDISPLAYFILE, list_OF_files[index[0]]
        ELSE: BEGIN
            FOR i=0,(sz-1) DO BEGIN
                XDISPLAYFILE, list_OF_files[index[i]]
            ENDFOR
        END
    ENDCASE
ENDIF
END

 ;-----------------------------------------------------------------------------
;this function is trigerred each time the user changes tab
PRO tab_event, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='main_tab')
CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
PrevTabSelect = (*global).PrevTabSelect

IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF

    0: BEGIN ;step1 (reduction)
    END

    1: BEGIN ;load
        IF((*global).something_to_plot) THEN BEGIN
            xaxis = (*(*global).x_axis)
            contour_plot, Event, xaxis
            plotAsciiData, Event, TYPE='replot' ;_plot
        ENDIF
    END

    2: BEGIN ;shifting
        display_shifting_help, Event, ''
        IF((*global).something_to_plot) THEN BEGIN
            ActiveFileDroplist, Event ;_shifting
            xaxis = (*(*global).x_axis)
            contour_plot_shifting, Event, xaxis
            plotAsciiData_shifting, Event
            plotReferencedPixels, Event ;_shifting
            refresh_plot_selection_OF_2d_plot_mode, Event
        ENDIF
        CheckShiftingGui, Event ;_gui
    END

    3: BEGIN ;OPTIONS
    END

    4: BEGIN ;log book        
    END

    ELSE:
    ENDCASE
    (*global).PrevTabSelect = CurrTabSelect
ENDIF
END

;------------------------------------------------------------------------------
PRO initialize_arrays, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global
list_OF_files = (*(*global).list_OF_ascii_files)
sz = N_ELEMENTS(list_OF_files)
ref_pixel_list = INTARR(sz)
ref_x_list     = INTARR(sz)
(*(*global).ref_pixel_list)        = ref_pixel_list
(*(*global).ref_pixel_offset_list) = ref_pixel_list
(*(*global).ref_x_list)            = ref_x_list
END


;------------------------------------------------------------------------------
PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS
;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
PRO ref_off_spec_eventcb, event
END

;------------------------------------------------------------------------------

