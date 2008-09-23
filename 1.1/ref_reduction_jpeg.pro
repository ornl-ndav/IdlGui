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

PRO save_as_jpeg, Event

WIDGET_CONTROL,Event.top,GET_UVALUE=global

id = WIDGET_INFO(Event.top, FIND_BY_UNAME='data_normalization_tab')
DataNormalizationTab = WIDGET_INFO(id, /TAB_CURRENT)

IF (DataNormalizationTab EQ 0) THEN BEGIN
    uname     = 'load_data_d_dd_tab'
    RunNumber = STRCOMPRESS((*global).DataRunNumber,/REMOVE_ALL)
    tab       = 'Data'
ENDIF ELSE BEGIN
    uname     = 'load_normalization_d_dd_tab'
    RunNumber = STRCOMPRESS((*global).norm_run_number,/REMOVE_ALL)
    tab       = 'Normalization'
ENDELSE
id1 = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
PlotTab = WIDGET_INFO(id1, /TAB_CURRENT)

CASE (PlotTab) OF
    0: ext = 'Y_vs_TOF_2D'
    1: ext = 'Y_vs_TOF_3D'
    2: ext = 'Y_vs_X_2D'
    3: ext = 'Y_vs_X_3D'
ENDCASE

UnameId = (4*DataNormalizationTab + PlotTab)
uname_list = ['load_data_D_draw',$
              'load_data_d_3d_draw',$
              'load_data_DD_draw',$
              'load_data_dd_3d_draw',$
              'load_normalization_D_draw',$
              'load_normalization_d_3d_draw',$
              'load_normalization_DD_draw',$
              'load_normalization_dd_3d_draw']
              
;set the plot to the current activet widget_draw
draw_uname = uname_list[UnameId]
id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME=draw_uname)
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

FileName = '~/Screenshot_' + RunNumber + '_' + ext
image = TVREAD(FILENAME=Filename,/JPEG,/NODIALOG)

IF (image EQ -1) THEN BEGIN
    LogBookText = '> JPEG file of ' + tab + '/' + ext + ' tab (' + $
      Filename + ')'
    LogBookText += ' has been created'
    putLogBookMessage, Event, LogBookText, Append=1
    text  = 'JPEG file ' + FileName + ' has been created with success!'
    title = 'Screenshot of current plot displayed has been taken'
    result = DIALOG_MESSAGE(text,/INFORMATION,TITLE=title)
ENDIF

END
