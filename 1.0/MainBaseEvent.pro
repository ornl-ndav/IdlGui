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

PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): BEGIN
        tab_event, Event ;_eventcb
    END

;222222222222222222222222222222222222222222222222222222222222222222222222222222

;Browse ASCII file button
    Widget_Info(wWidget, FIND_BY_UNAME='browse_ascii_file_button'): BEGIN
        browse_ascii_file, Event ;_browse_ascii
    END

;Ascii File list
    Widget_Info(wWidget, FIND_BY_UNAME='ascii_file_list'): BEGIN
    END
    
;Preview ASCII file selected
    Widget_Info(wWidget, FIND_BY_UNAME='ascii_preview_button'): BEGIN
        preview_ascii_file, Event ;_eventcb
    END

;Draw
    Widget_Info(wWidget, FIND_BY_UNAME='step2_draw'): BEGIN
        current_list_OF_files = (*(*global).list_OF_ascii_files)
        IF (current_list_OF_files[0] NE '') THEN BEGIN
            delta_x = (*global).delta_x
            x = Event.x
            x1 = FLOAT(delta_x) * FLOAT(x)
            y = Event.y
            y1 = y / 2
            text  = 'x: ' + STRCOMPRESS(x1,/REMOVE_ALL)
            text += '  |  y: ' + STRCOMPRESS(y1,/REMOVE_ALL)
            putTextFieldValue, Event, 'xy_display_step2', text
            total_array = (*(*global).total_array)
;            print, total_array(x,y)
        ENDIF
    END

;RefreshPlot
    Widget_Info(wWidget, FIND_BY_UNAME='refresh_step2_plot'): BEGIN
        xaxis = (*(*global).x_axis)
        contour_plot, Event, xaxis ;_plot
        plotASCIIdata, Event, TYPE='replot' ;_plot
    END

;transparency list of files droplist
    Widget_Info(wWidget, FIND_BY_UNAME='transparency_file_list'): BEGIN
        update_transparency_coeff_display, Event ;_gui
    END

;transparency percentage text box
    Widget_Info(wWidget, FIND_BY_UNAME='transparency_coeff'): BEGIN
        changeTransparencyCoeff, Event ;_plot
    END

;Transparency Full Reset
    Widget_Info(wWidget, FIND_BY_UNAME='trans_full_reset'): BEGIN
        changeTransparencyFullReset, Event ;_plot
    END

;lin/log z-azis scale
    Widget_Info(wWidget, FIND_BY_UNAME='z_axis_linear_log'): BEGIN
        current_list_OF_files = (*(*global).list_OF_ascii_files)
        IF (current_list_OF_files[0] NE '') THEN BEGIN
            plotASCIIdata, Event, TYPE='replot' ;_plot
        ENDIF
    END

;less x-axis ticks
    Widget_Info(wWidget, FIND_BY_UNAME='x_axis_less_ticks'): BEGIN
        change_xaxis_ticks, Event, type='less' ;_plot
    END
    
;more x-axis ticks
    Widget_Info(wWidget, FIND_BY_UNAME='x_axis_more_ticks'): BEGIN
        change_xaxis_ticks, Event, type='more' ;_plot
    END

;- LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK 
    Widget_Info(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
        SendToGeek, Event ;_IDLsendToGeek
    END

    ELSE:
    
ENDCASE

END
