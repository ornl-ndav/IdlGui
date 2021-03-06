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

;+
; :Description:
;    this procedure display the description text on the right of tab1 when the
;    mouse is over such or such button
;
; :Keywords:
;    MAIN_BASE
;    EVENT
;    button
;    status
;
; :Author: j35
;-
PRO display_descriptions_buttons, MAIN_BASE=main_base, EVENT=event, $
    button=button, status=status
    
  case (button) of
    'faq': begin
      text = ['Frequently Asked Question','',$
        'All the questions you are afraid to ask.']
    end
    'orbiter': text = 'orbiter description'
    'sns': begin
      text = ['Neutron Science web site','','Web site of the SNS and HFIR']
    end
    'portal': text = 'portal description'
    'neutronsr_us': begin
      text = ['Neutron Science portal web site',$
        '',' - Service provided',' - Contacts',' - Resources']
    end
    'translation': begin
      text = ['Translation Monitor','','To monitor live the translation of the ' + $
        'NeXus files.']
    end
    'how_to': text = 'how_to description'
    else: text = 'Move the mouse over a button to get a description of its link.'
  endcase
  
  putValue, Event, 'tab1_preview_button', text
  
END
