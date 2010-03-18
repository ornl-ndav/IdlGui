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

PRO miniMakeGuiReduceInfo, Event, REDUCE_BASE

;general info and xml preview tab
GeneralInfoAndXmlBaseSize = [580,265,315,170]
GeneralInfoTabSize = [0, $
                      0, $
                      GeneralInfoAndXmlBaseSize[2],$
                      GeneralInfoAndXmlBaseSize[3]]
ReduceTab1BaseSize = [0, $
                      0, $
                      GeneralInfoTabSize[2],$
                      GeneralInfoTabSize[3]]
ReduceTab1BaseTitle = 'COMMAND LINE STATUS'
ReduceTab2BaseSize = [0, $
                      0, $
                      GeneralInfoTabSize[2],$
                      GeneralInfoTabSize[3]]
ReduceTab2BaseTitle = 'REDUCTION XML FILE'

;general info label frame
GeneralInfoTextFieldSize = [0,0,445,GeneralInfoAndXmlBaseSize[3]-25] 

XYoff = [0,-5]
DataReductionStatusFrameSize = [580,500+XYoff[1],310,40]
DataReductionStatusLabelSize = [585,493+XYoff[1]]
DataReductionStatusLabelTitle = 'R E D U C T I O N   S T A T U S'
DataReductionStatusTextFieldSize = [585,509+XYoff[1],305,30]

;##############################################################################
;############################## Create GUI ####################################
;##############################################################################

GeneralInfoAndXmlBase = WIDGET_BASE(REDUCE_BASE,$
                                    XOFFSET   = GeneralInfoAndXmlBaseSize[0],$
                                    YOFFSET   = GeneralInfoAndXmlBaseSize[1],$
                                    SCR_XSIZE = GeneralInfoAndXmlBaseSize[2],$
                                    SCR_YSIZE = GeneralInfoAndXmlBaseSize[3],$
                                    UNAME     = 'general_info_and_xml_base')

GeneralInfoTab = WIDGET_TAB(GeneralInfoAndXmlBase,$
                            UNAME     = 'GeneralInfoTab',$
                            LOCATION  = 0,$
                            XOFFSET   = GeneralInfoTabSize[0],$
                            YOFFSET   = GeneralInfoTabSize[1],$
                            SCR_XSIZE = GeneralInfoTabSize[2],$
                            SCR_YSIZE = GeneralInfoTabSize[3],$
                            SENSITIVE = 1)

;tab1
reduce_tab1_base = WIDGET_BASE(GeneralInfoTab,$
                               UNAME     = 'reduce_tab1_base',$
                               TITLE     = ReduceTab1BaseTitle,$
                               XOFFSET   = ReduceTab1BaseSize[0],$
                               YOFFSET   = ReduceTab1BaseSize[1],$
                               SCR_XSIZE = ReduceTab1BaseSize[2],$
                               SCR_YSIZE = ReduceTab1BaseSize[3])
                               
;Text field
GeneralInfoTextField = WIDGET_TEXT(reduce_tab1_base,$
                                   XOFFSET   = GeneralInfoTextFieldSize[0],$
                                   YOFFSET   = GeneralInfoTextFieldSize[1],$
                                   SCR_XSIZE = GeneralInfoTextFieldSize[2],$
                                   SCR_YSIZE = GeneralInfoTextFieldSize[3],$
                                   UNAME     = 'reduction_status_text_field',$
                                   /WRAP,$
                                   /SCROLL)

;tab2
reduce_tab2_base = WIDGET_BASE(GeneralInfoTab,$
                               UNAME     = 'reduce_tab2_base',$
                               TITLE     = ReduceTab2BaseTitle,$
                               XOFFSET   = ReduceTab2BaseSize[0],$
                               YOFFSET   = ReduceTab2BaseSize[1],$
                               SCR_XSIZE = ReduceTab2BaseSize[2],$
                               SCR_YSIZE = ReduceTab2BaseSize[3])

;Text field
XmlTextField = WIDGET_TEXT(reduce_tab2_base,$
                           XOFFSET   = GeneralInfoTextFieldSize[0],$
                           YOFFSET   = GeneralInfoTextFieldSize[1],$
                           SCR_XSIZE = GeneralInfoTextFieldSize[2],$
                           SCR_YSIZE = GeneralInfoTextFieldSize[3],$
                           UNAME     ='xml_text_field',$
                           /WRAP,$
                           /SCROLL)

;Data reduction status label
DataReductionStatusLabel = $
  WIDGET_LABEL(REDUCE_BASE,$
               XOFFSET = DataReductionStatusLabelSize[0],$
               YOFFSET = DataReductionStatusLabelSize[1],$
;               FONT    = 'lucidasans-10',$
               VALUE   = DataReductionStatusLabelTitle,$
                 UNAME = 'reduce_label7')

;text field
DataReductionStatusTextField = $
  WIDGET_TEXT(REDUCE_BASE,$
              XOFFSET   = DataReductionStatusTextFieldSize[0],$
              YOFFSET   = DataReductionStatusTextFieldSize[1],$
              SCR_XSIZE = DataReductionStatusTextFieldSize[2],$
              SCR_YSIZE = DataReductionStatusTextFieldSize[3],$
              UNAME     = 'data_reduction_status_text_field',$
              /ALIGN_LEFT)

;Data Reduction status frame
DataReductionStatusFrame = $
  WIDGET_LABEL(REDUCE_BASE,$
               FRAME     = 1,$
               XOFFSET   = DataReductionStatusFrameSize[0],$
               YOFFSET   = DataReductionStatusFrameSize[1],$
               SCR_XSIZE = DataReductionStatusFrameSize[2],$
               SCR_YSIZE = DataReductionStatusFrameSize[3],$
               VALUE     = '')

END
