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

pro putValue, event=event, base=base, uname=uname, value=value, id=id
  compile_opt idl2
  
  if (keyword_set(id)) then begin
  widget_control, id, set_value=value
  return
  endif
  
  if (keyword_set(event)) then begin
    uname_id = widget_info(event.top,find_by_uname=uname)
  endif else begin
    uname_id = widget_info(base,find_by_uname=uname)
  endelse
  widget_control, uname_id, set_value=value
  
end

PRO putValueInTextField, Event, uname, value
  uname_id = widget_info(Event.top,find_by_uname=uname)
  widget_control, uname_id, set_value=value
END

pro putTextFieldValue, event, uname, value
  putValueInTextField, event, uname, value
end

PRO putValueInTextField, Event, uname, value
  uname_id = widget_info(Event.top,find_by_uname=uname)
  widget_control, uname_id, set_value=value
END

pro putTextFieldValue, event, uname, value
  putValueInTextField, event, uname, value
end



;##############################################################################
;******************************************************************************

PRO putArrayInTextField, Event, uname, ArrayValue
  id = widget_info(Event.top,find_by_uname=uname)
  sz = (size(ArrayValue))(1)
  widget_control, id, set_value=ArrayValue[0]
  IF (sz GT 1) THEN BEGIN
    FOR i=1,(sz-1) DO BEGIN
      widget_control, id, set_value=ArrayValue[i],/append
    ENDFOR
  ENDIF
END

;##############################################################################
;******************************************************************************

;This function populates the x/y axis text boxes
PRO PopulateXYScaleAxis, Event, $
    min_xaxis, $
    max_xaxis, $
    min_yaxis, $
    max_yaxis
    
  ;min-xaxis
  XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
  widget_control, XminId, set_value=strcompress(min_xaxis,/remove_all)
  
  ;max-xaxis
  XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
  widget_control, XmaxId, set_value=strcompress(max_xaxis,/remove_all)
  
  ;min-yaxis
  YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
  widget_control, YminId, set_value=strcompress(min_yaxis,/remove_all)
  
  ;max-yaxis
  YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
  widget_control, YmaxId, set_value=strcompress(max_yaxis,/remove_all)
  
END

;##############################################################################
;******************************************************************************

;this function changes the value displays inside a label
PRO putValueInLabel, Event, uname, value
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, set_value=strcompress(value)
END

;##############################################################################
;******************************************************************************

;This function will put the values of Xmin/max and Ymin/max
;in their respectives boxes
PRO putXYMinMax, Event, XYMinMax

  ;Xmin = Number_Formatter(FLOAT(XYMinMax[0]))
  ;Xmax = Number_Formatter(FLOAT(XYMinMax[1]))
  ;Ymin = Number_Formatter(FLOAT(XYMinMax[2]))
  ;Ymax = Number_Formatter(FLOAT(XYMinMax[3]))

  Xmin = STRING(FLOAT(XYMinMax[0]))
  Xmax = STRING(FLOAT(XYMinMax[1]))
  Ymin = STRING(FLOAT(XYMinMax[2]))
  Ymax = STRING(FLOAT(XYMinMax[3]))
  
  ;min-xaxis
  XminId = widget_info(Event.top,find_by_uname='XaxisMinTextField')
  widget_control, XminId, set_value=strcompress(Xmin,/REMOVE_ALL)
  
  ;max-xaxis
  XmaxId = widget_info(Event.top,find_by_uname='XaxisMaxTextField')
  widget_control, XmaxId, set_value=strcompress(Xmax,/REMOVE_ALL)
  
  ;min-yaxis
  YminId = widget_info(Event.top,find_by_uname='YaxisMinTextField')
  widget_control, YminId, set_value=strcompress(Ymin,/REMOVE_ALL)
  
  ;max-yaxis
  YmaxId = widget_info(Event.top,find_by_uname='YaxisMaxTextField')
  widget_control, YmaxId, set_value=strcompress(Ymax,/REMOVE_ALL)
  
END

;##############################################################################
;******************************************************************************

PRO appendValueInTextField, Event, $
    uname, $
    value
  uname_id = widget_info(Event.top,find_by_uname=uname)
  widget_control, uname_id, set_value=strcompress(value),/append
END

;+
; :Description:
;   populates the droplist with the array (value) provided
;
; :Params:
;    event
;    uname
;    value
;
; :Author: j35
;-
pro putDroplistValue, event, uname, value
  id = widget_info(event.top, find_by_uname=uname)
  widget_control, id, set_value=value
end