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

PRO MakeGuiReduceInfo, Event, REDUCE_BASE

;general info and xml preview tab
GeneralInfoAndXmlBaseSize = [725,305,450,230]
GeneralInfoTabSize = [0,0,GeneralInfoAndXmlBaseSize[2],$
                      GeneralInfoAndXmlBaseSize[3]]
ReduceTab1BaseSize = [0,0,GeneralInfoTabSize[2],$
                      GeneralInfoTabSize[3]]
ReduceTab1BaseTitle = 'COMMAND  LINE  GENERATOR  STATUS'
ReduceTab2BaseSize = [0,0,GeneralInfoTabSize[2],$
                      GeneralInfoTabSize[3]]
ReduceTab2BaseTitle = 'REDUCTION XML FILE'

;general info label frame
GeneralInfoTextFieldSize = [0,0,443,205]

DataReductionStatusFrameSize = [725,605,450,40]
DataReductionStatusLabelSize = [740,605-12]
DataReductionStatusLabelTitle = 'R E D U C T I O N   S T A T U S'
DataReductionStatusTextFieldSize = [730,605+5,440,30]

;makeGuI
GeneralInfoAndXmlBase = widget_base(REDUCE_BASE,$
                                    xoffset=GeneralInfoAndXmlBaseSize[0],$
                                    yoffset=GeneralInfoAndXmlBaseSize[1],$
                                    scr_xsize=GeneralInfoAndXmlBaseSize[2],$
                                    scr_ysize=GeneralInfoAndXmlBaseSize[3],$
                                    uname='general_info_and_xml_base')

GeneralInfoTab = widget_tab(GeneralInfoAndXmlBase,$
                            uname='GeneralInfoTab',$
                            location=0,$
                            xoffset=GeneralInfoTabSize[0],$
                            yoffset=GeneralInfoTabSize[1],$
                            scr_xsize=GeneralInfoTabSize[2],$
                            scr_ysize=GeneralInfoTabSize[3],$
                            sensitive=1)

;tab1
reduce_tab1_base = widget_base(GeneralInfoTab,$
                               uname='reduce_tab1_base',$
                               title=ReduceTab1BaseTitle,$
                               xoffset=ReduceTab1BaseSize[0],$
                               yoffset=ReduceTab1BaseSize[1],$
                               scr_xsize=ReduceTab1BaseSize[2],$
                               scr_ysize=ReduceTab1BaseSize[3])
                               
;Text field
GeneralInfoTextField = widget_text(reduce_tab1_base,$
                                   xoffset=GeneralInfoTextFieldSize[0],$
                                   yoffset=GeneralInfoTextFieldSize[1],$
                                   scr_xsize=GeneralInfoTextFieldSize[2],$
                                   scr_ysize=GeneralInfoTextFieldSize[3],$
                                   /wrap,$
                                   /scroll,$
                                   uname='reduction_status_text_field')

;tab2
reduce_tab2_base = widget_base(GeneralInfoTab,$
                               uname='reduce_tab2_base',$
                               title=ReduceTab2BaseTitle,$
                               xoffset=ReduceTab2BaseSize[0],$
                               yoffset=ReduceTab2BaseSize[1],$
                               scr_xsize=ReduceTab2BaseSize[2],$
                               scr_ysize=ReduceTab2BaseSize[3])


;Text field
XmlTextField = widget_text(reduce_tab2_base,$
                           xoffset=GeneralInfoTextFieldSize[0],$
                           yoffset=GeneralInfoTextFieldSize[1],$
                           scr_xsize=GeneralInfoTextFieldSize[2],$
                           scr_ysize=GeneralInfoTextFieldSize[3],$
                           /wrap,$
                           /scroll,$
                           uname='xml_text_field')


;Data reduction status label
DataReductionStatusLabel = $
  WIDGET_LABEL(REDUCE_BASE,$
               xoffset=DataReductionStatusLabelSize[0],$
               yoffset=DataReductionStatusLabelSize[1],$
               value=DataReductionStatusLabelTitle,$
               uname='reduce_label7')

;text field
DataReductionStatusTextField = $
  WIDGET_TEXT(REDUCE_BASE,$
              xoffset=DataReductionStatusTextFieldSize[0],$
              yoffset=DataReductionStatusTextFieldSize[1],$
              scr_xsize=DataReductionStatusTextFieldSize[2],$
              scr_ysize=DataReductionStatusTextFieldSize[3],$
              uname='data_reduction_status_text_field',$
              /align_left)


;Data Reduction status frame
DataReductionStatusFrame = $
  WIDGET_LABEL(REDUCE_BASE,$
               frame=1,$
               xoffset=DataReductionStatusFrameSize[0],$
               yoffset=DataReductionStatusFrameSize[1],$
               scr_xsize=DataReductionStatusFrameSize[2],$
               scr_ysize=DataReductionStatusFrameSize[3],$
               value='')


END
