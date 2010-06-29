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

PRO reduce_jk_tab3_tab2_time_label, Event, TYPE=type

  CASE (type) OF
    'time': BEGIN
      help_label  = '  (If no limit on t2 is needed, give t2=0)'
      label1      = '  t1:'
      label1_unit = 's'
      label2      = '       t2:'
      label2_unit = 's'
      label3      = '       dt:'
      label3_unit = 's'
    END
    'pulse': BEGIN
      help_label  = '  (If no limit on p2 is needed, give p2=0)'
      label1 = '  p1:'
      label1_unit = ' '
      label2 = '       p2:'
      label2_unit = ' '
      label3 = '       dp:'
      label3_unit = ' '
    END
  ENDCASE
  
  putTextFieldValue, Event, 'reduce_jk_tab3_tab2_time_pulse_help', help_label
  putTextFieldValue, Event, 'reduce_jk_tab3_tab2_label1', label1
  putTextFieldValue, Event, 'reduce_jk_tab3_tab2_label1_unit', label1_unit
  putTextFieldValue, Event, 'reduce_jk_tab3_tab2_label2', label2
  putTextFieldValue, Event, 'reduce_jk_tab3_tab2_label2_unit', label2_unit
  putTextFieldValue, Event, 'reduce_jk_tab3_tab2_label3', label3
  putTextFieldValue, Event, 'reduce_jk_tab3_tab2_label3_unit', label3_unit
  
END