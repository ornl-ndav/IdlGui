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

PRO MakeGuiReduceTab, MAIN_TAB, $
                      MainTabSize, $
                      ReduceTabTitle, $
                      PlotsTitle, $
                      global

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
ReduceTabSize  = [0,0,MainTabSize[2],MainTabSize[3]]
IndividualBaseWidth = 720

;Build widgets
REDUCE_BASE = WIDGET_BASE(MAIN_TAB,$
                          UNAME     = 'reduce_base',$
                          TITLE     = ReduceTabTitle,$
                          XOFFSET   = ReduceTabSize[0],$
                          YOFFSET   = ReduceTabSize[1],$
                          SCR_XSIZE = ReduceTabSize[2],$
                          SCR_YSIZE = ReduceTabSize[3])

;background turned off message ------------------------------------------------
XYoff = [250,130]
sBackMessageBase = { size: [XYoff[0],$
                            XYoff[1],$
                            430,$
                            43],$
                     frame: 5,$
                     map: 0,$
                     uname: 'background_message_uname' }

sBackMessageLabel = { label1: '<-- You can not run Empty Cell and Data' + $
                      ' Background in the same time.',$
                      label2: '>>> Background has been' + $
                      ' turned off <<<'}

;background turned off message
wBackMessageBase = WIDGET_BASE(REDUCE_BASE,$
                               XOFFSET   = sBackMessageBase.size[0],$
                               YOFFSET   = sBackMessageBase.size[1],$
                               SCR_XSIZE = sBackMessageBase.size[2],$
                               SCR_YSIZE = sBackMessageBase.size[3],$
                               UNAME     = sBackMessageBase.uname,$
                               FRAME     = sBackMessageBase.frame,$
                               MAP       = sBackMessageBase.map,$
                               /COLUMN)

wBackMessageLabel1 = WIDGET_LABEL(wBackMessageBase,$
                                 VALUE = sBackMessageLabel.label1)

wBackMessageLabel2 = WIDGET_LABEL(wBackMessageBase,$
                                  VALUE = sBackMessageLabel.label2)

;------------------------------------------------------------------------------

;base that contain widgets for auto cleaning
auto_cleaning_base_gui, Event, REDUCE_BASE

;create data base
MakeGuiReduceDataBase, Event, REDUCE_BASE, IndividualBaseWidth

;create normalization base
MakeGuiReduceNormalizationBase, Event, REDUCE_BASE, IndividualBaseWidth

;create Q base
MakeGuiReduceQBase, Event, REDUCE_BASE, IndividualBaseWidth

;create detector angle
MakeGuiReduceDetectorBase, Event, REDUCE_BASE, IndividualBaseWidth

;create intermediate plot base
MakeGuiReduceIntermediatePlotBase, Event, REDUCE_BASE, IndividualBaseWidth, $
  PlotsTitle

;create other component of base
MakeGuiReduceOther, Event, REDUCE_BASE, IndividualBaseWidth, global

;create GeneralInfoTextField
MakeGuiReduceInfo, Event, REDUCE_BASE

END
