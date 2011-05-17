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

PRO MakeGuiReduceQBase, Event, REDUCE_BASE, IndividualBaseWidth, global

  ;size of Q base
  QBaseSize   = [0,400,IndividualBaseWidth, 55]
  
  QLabelSize  = [20,2]
  ;QLabelTitle = 'Q ' 
  QLabelTitle = 'Q (1/' + string("305B) + ')'
  QFrameSize  = [10,10,IndividualBaseWidth-30,40]
  
  ;Auto/manual mode
  XYoff = [15,18]
  sModeGroup = {size:  [XYoff[0],$
    XYoff[1]],$
    uname: 'q_mode_group',$
    value: 1,$
    list:  ['Auto.','Manual']}
    
  ;Qmanual base
  XYoff = [145,13]
  sQmanualBase = {size: [XYoff[0],$
    XYoff[1],$
    553,35],$
    frame: 1,$
    uname: 'q_manual_base'}
    
  ;Qmin
  XYoff = [20,8] ;label
  QminLabelSize     = [XYoff[0],XYoff[1]]
  QminLabelTitle    = 'Min:'
  
  XYoff = [27,-5] ;text_field
  QminTextFieldSize = [QminLabelSize[0]+XYoff[0],$
    QminLabelSize[1]+XYoff[1], $
    70, $
    30]
    
  ;Qmax
  XYoff = [20,0] ;label
  QmaxLabelSize     = [QminTextFieldSize[0]+ $
    QminTextFieldSize[2]+ $
    XYoff[0],$
    QminLabelSize[1]+XYoff[1]]
  QmaxLabelTitle    = 'Max:'
  XYoff = [27,0] ;text field
  QmaxTextFieldSize = [QmaxLabelSize[0]+XYoff[0],$
    QminTextFieldSize[1],$
    QminTextFieldSize[2],$
    QminTextFieldSize[3]]
    
  ;Qwidth
  XYoff = [20,0]
  QwidthLabelSize     = [QmaxTextFieldSize[0]+QmaxTextFieldSize[2]+XYoff[0],$
    QmaxLabelSize[1]+XYoff[1]]
  QwidthLabelTitle    = 'Width:'
  XYoff = [45,0]
  QwidthTextFieldSize = [QwidthLabelSize[0]+XYoff[0],$
    QminTextFieldSize[1],$
    QminTextFieldSize[2],$
    QminTextFieldSize[3]]
    
  ;Qscale
  QScaleBGroupList = ['linear ','log' ]
  XYOff = [25,0]
  QScaleBGroupSize = [QwidthTextFieldSize[0]+QwidthTextFieldSize[2]+XYoff[0],$
    QminTextFieldSize[1]]
    
    if ((*global).Q_scale_type eq 'linear') then begin
  qscale_type =0
  endif else begin
  qscale_type = 1
  endelse
    
  ;*********************************************************
  ;Create GUI
  map_status = 1
  if ((*global).instrument eq 'REF_M') then begin
  
    label = widget_label(REDUCE_BASE,$
      xoffset = QBaseSize[0]+20,$
      yoffset = QBaseSize[1]+15,$
      value = 'Q axis : AUTOMATIC')
   
    map_status = 0
    
   ;base
  Q_base = widget_base(REDUCE_BASE,$
    ;xoffset=QBaseSize[0],$
    xoffset = 0,$
    yoffset=QBaseSize[1],$
    scr_xsize=QBaseSize[2],$
    scr_ysize=QBaseSize[3],$
    map=map_status,$
    UNAME='reduce_q_base')
    
  ;label that goes on top of frame
  QLabel = widget_label(Q_base,$
    xoffset=QLabelSize[0],$
    yoffset=QLabelSize[1],$
    value=QLabelTitle)
    
    set_value = 1
    sensitive = 0
  
  ;sQmanual base
  wBase = WIDGET_BASE(Q_base,$
  ;  XOFFSET   = sQmanualBase.size[0],$
  xoffset = 20,$
    YOFFSET   = sQmanualBase.size[1],$
    ;SCR_XSIZE = sQmanualBase.size[2],$
    SCR_YSIZE = sQmanualBase.size[3],$
    UNAME     = sQmanualBase.uname,$
    /row,$
    FRAME     = 0)

    ;qmin label
    qminlabel = widget_label(wBase,$
    value = QMinLabelTitle)
;    qminvalue = widget_text(wBase,$
;    /align_left,$
;    /all_events, $
;    /editable,$
;    uname='q_min_text_field',$
;    scr_xsize = QMinTextFieldSize[2])
    qminvalue = widget_label(wBase,$
    /align_left,$
    value=' ',$
    uname='q_min_text_field',$
    frame=1,$
    scr_xsize = QMinTextFieldSize[2])
    
    ;qmax label
    qmaxlabel = widget_label(wBase,$
    value = '   ' + QMaxLabelTitle)
;    qmaxvalue = widget_text(wBase,$
;    /align_left,$
;    /all_events, $
;    /editable,$
;    uname='q_max_text_field',$
;    scr_xsize = QMaxTextFieldSize[2])
    qmaxvalue = widget_label(wBase,$
    /align_left,$
    uname='q_max_text_field',$
    value=' ',$
    frame=1,$
    scr_xsize = QMaxTextFieldSize[2])
    
    ;qwidth label
    qwidthlabel = widget_label(wBase,$
    value = '   ' + QWidthLabelTitle)
    qwidthvalue = widget_text(wBase,$
    /align_left,$
    /all_events, $
    /editable,$
    uname='q_width_text_field',$
    scr_xsize = QwidthTextFieldSize[2])
    
;'or Nbins'
  or_label = widget_label(wBase,$
  value = 'or  Number bins:')
  ;value
  Nbins = widget_text(wBase,$
  /align_left, $
  xsize=4,$
    value = (*global).q_number_bins, $
  /editable,$
  /all_events, $
  uname = 'q_nbins_text_field')
    
    space = widget_label(wBase,$
    value =  '    ')
    
  ;QScale label
  QScaleBGroup = cw_bgroup(wBase,$
    QScaleBGroupList,$
    /exclusive,$
    /row,$
    set_value=qscale_type,$
    uname='q_scale_b_group')
    
  ;frame
  QFrame = widget_label(q_base,$
    xoffset=QFrameSize[0],$
    yoffset=QFrameSize[1],$
    scr_xsize=QFrameSize[2],$
    scr_ysize=QFrameSize[3],$
    frame=1,$
    value='')
    
  endif else begin
  
  ;base
  Q_base = widget_base(REDUCE_BASE,$
    xoffset=QBaseSize[0],$
    yoffset=QBaseSize[1],$
    scr_xsize=QBaseSize[2],$
    scr_ysize=QBaseSize[3],$
    map=map_status,$
    UNAME='reduce_q_base')
    
  ;label that goes on top of frame
  QLabel = widget_label(Q_base,$
    xoffset=QLabelSize[0],$
    yoffset=QLabelSize[1],$
    value=QLabelTitle)
    
    set_value = sModeGroup.value
    sensitive = 1
  
  ;Auto/Manual mode
  _base = widget_base(Q_base,$
    xoffset=sModeGroup.size[0],$
    yoffset=sModeGroup.size[1],$
    uname = 'q_range_selection_base',$
    map=map_status)
  wPeakBackGroup = CW_BGROUP(_base,$
    sModeGroup.list,$
    UNAME     = sModeGroup.uname,$
    SET_VALUE = set_value,$
    ROW       = 1,$
    /EXCLUSIVE,$
    /RETURN_NAME,$
    /NO_RELEASE)
    
  ;sQmanual base
  wBase = WIDGET_BASE(Q_base,$
    XOFFSET   = sQmanualBase.size[0],$
    YOFFSET   = sQmanualBase.size[1],$
    SCR_XSIZE = sQmanualBase.size[2],$
    SCR_YSIZE = sQmanualBase.size[3],$
    UNAME     = sQmanualBase.uname,$
    FRAME     = sQmanualBase.frame)
    
  ;Qmin label
  QMinLabel = widget_label(wBase,$
    xoffset=QMinLabelSize[0],$
    yoffset=QMinLabelSize[1],$
    value=QMinLabelTitle)
    
  ;Qmin Text Field
  QMinTextField = widget_text(wBase,$
    xoffset=QMinTextFieldSize[0],$
    yoffset=QMinTextFieldSize[1],$
    scr_xsize=QMinTextFieldSize[2],$
    scr_ysize=QMinTextFieldSize[3],$
    /align_left,$
    /all_events,$
    /editable,$
    uname='q_min_text_field')
    
  ;Qmax label
  QMaxLabel = widget_label(wBase,$
    xoffset=QMaxLabelSize[0],$
    yoffset=QMaxLabelSize[1],$
    value=QMaxLabelTitle)
    
  ;Qmax Text Field
  QMaxTextField = widget_text(wBase,$
    xoffset=QMaxTextFieldSize[0],$
    yoffset=QMaxTextFieldSize[1],$
    scr_xsize=QMaxTextFieldSize[2],$
    scr_ysize=QMaxTextFieldSize[3],$
    /align_left,$
    /editable,$
    /all_events,$
    uname='q_max_text_field')
    
  ;Qwidth label
  QwidthLabel = widget_label(wBase,$
    xoffset=QwidthLabelSize[0],$
    yoffset=QwidthLabelSize[1],$
    value=QwidthLabelTitle)
    
  ;Qwidth Text Field
  QwidthTextField = widget_text(wBase,$
    xoffset=QwidthTextFieldSize[0],$
    yoffset=QwidthTextFieldSize[1],$
    scr_xsize=QwidthTextFieldSize[2],$
    scr_ysize=QwidthTextFieldSize[3],$
    /align_left,$
    /editable,$
    /all_events,$
    uname='q_width_text_field')
    
  ;QScale label
  QScaleBGroup = cw_bgroup(wBase,$
    QScaleBGroupList,$
    /exclusive,$
    xoffset=QScaleBGroupSize[0],$
    yoffset=QScaleBGroupSize[1],$
    set_value=qscale_type,$
    uname='q_scale_b_group',$
    row=1)
    
  ;frame
  QFrame = widget_label(q_base,$
    xoffset=QFrameSize[0],$
    yoffset=QFrameSize[1],$
    scr_xsize=QFrameSize[2],$
    scr_ysize=QFrameSize[3],$
    frame=1,$
    value='')
    
    endelse
    
end
