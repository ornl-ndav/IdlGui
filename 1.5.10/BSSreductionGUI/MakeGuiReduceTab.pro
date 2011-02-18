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

PRO MakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceBaseTitle

;******************************************************************************
;                             Define size arrays
;******************************************************************************
ReduceInputTabSettings       = {size : [0, $
                                        0, $
                                        750, $
                                        575],$
                                title : ['1) Input', $
                                         '3) Setup', $
                                         '4) Time-Indep. Back.', $ 
                                         '7) Data Control', $
                                         '8) Output',$
                                         '2) Input',$
                                         '6) Scaling Cst.',$
                                         '5) Lambda-Dep. Back.'], $
                                tab1 : {size : [0, $
                                                0, $
                                                750, $
                                                575]}}
xoff = 5
yoff = 48
ReduceClgXmlTabSettings = {Size : [ReduceInputTabSettings.Size[0]+$
                                   ReduceInputTabSettings.Size[2]+xoff, $
                                   ReduceInputTabSettings.Size[1], $
                                   440, $
                                   ReduceInputTabSettings.size[3]+yoff-70],$
                           title : ['Command Line Generator Status', $
                                    'XML Reduce File']}

;Create file of Command Line --------------------------------------------------
XYoff = [5,10]
sCLframe = { size: [ReduceClgXmlTabSettings.size[0]+XYoff[0],$
                    ReduceClgXmlTabSettings.size[1]+ $
                    ReduceClgXmlTabSettings.size[3]+XYoff[1],$
                    ReduceClgXmlTabSettings.size[2]-15,$
                    65],$
             frame: 1}

XYoff = [20,-8]
sCLtitle = { size: [sCLframe.size[0]+XYoff[0],$
                    sCLframe.size[1]+XYoff[1]],$
             value: 'Create File of Command Line'}

XYoff = [5,10]
sCLpath = { size: [sCLframe.size[0]+XYoff[0],$
                   sCLframe.size[1]+XYoff[1],$
                   sCLframe.size[2]-6],$
            value: '~/results/',$
            uname: 'command_line_path_button'}

XYoff = [0,25]
sCLfile = { size: [sCLpath.size[0]+XYoff[0],$
                   sCLpath.size[1]+XYoff[1],$
                   300],$
            value: '',$
            uname: 'command_line_file_text_field'}

XYoff = [3,0]
sCLbutton = { size: [sCLfile.size[0]+$
                     sCLfile.size[2]+$
                     XYoff[0],$
                     sCLfile.size[1]+$
                     XYoff[1],$
                     115,$
                     30],$
              value: 'CREATE FILE',$
              uname: 'command_line_file_button'}

;------------------------------------------------------------------------------
XYoff = [0,5]
SubmitButtonBatch = { size: [XYoff[0],$
                             ReduceInputTabSettings.size[1]+$
                             ReduceInputTabSettings.size[3]+XYoff[1],$
                             200,45],$
                      sensitive: 0,$
                      title: 'RUN REDUCTION IN BACKGROUND',$
                      uname: 'submit_batch_button'}
XYoff = [5,0]
SubmitButton = { size: [SubmitButtonBatch.size[0]+$
                        SubmitButtonBatch.size[2]+$
                        XYoff[0],$
                        SubmitButtonBatch.size[1]+$
                        XYoff[1],$
                        SubmitButtonBatch.size[2:3]],$
                 sensitive: 0,$
                 title: 'RUN REDUCTION LIVE', $
                 uname: 'submit_button'}

XYoff = [0,28]
sCheckStatus = { size: [SubmitButtonBatch.size[0]+XYoff[0],$
                        SubmitButtonBatch.size[1]+$
                        XYoff[1],$
                        SubmitButtonBatch.size[2]*2+5],$
                 title: 'Check Status of the Jobs Submitted',$
                 uname: 'check_status_of_jobs'}
                 
;------------------------------------------------------------------------------
xoff  = 5
xoff1 = 10
yoff  = -7
yoff1 = 10
status = {frame : {size : [SubmitButton.size[0] +$
                           SubmitButton.size[2] + xoff, $
                           SubmitButton.size[1], $
                           340, $
                           40]}, $
          label : {size : [500, $
                           SubmitButton.size[1] + yoff],$
                   title : 'Data Reduction Status'}, $
          text : {size: [SubmitButton.size[0] +$
                         SubmitButton.size[2] + xoff1, $
                         SubmitButton.size[1] + yoff1, $
                         330],$
                  uname : 'data_reduction_status_text'}}

yoff  = 10
xoff  = 498
yoff1 = 0 
clg = {text : {size : [0,$
                       SubmitButton.size[1]+$
                       SubmitButton.size[3] + yoff,$
                       ReduceInputTabSettings.size[2]+$
                       ReduceClgXmlTabSettings.size[2],$
                       63],$
               uname : 'command_line_generator_text'},$
       label : {size : [xoff,$
                        SubmitButton.size[1]+$
                        SubmitButton.size[3] + yoff1],$
                title : 'COMMAND LINE GENERATOR'}}

;******************************************************************************
;                                Build GUI
;******************************************************************************
ReduceBase = WIDGET_BASE(MAIN_TAB,$
                         XOFFSET   = 0,$
                         YOFFSET   = 0,$
                         SCR_XSIZE = MainTabSize[2],$
                         SCR_YSIZE = MainTabSize[3],$
                         TITLE     = ReduceBaseTitle,$
                         UNAME     = 'reduce_base')

;Create file of Command Line --------------------------------------------------
;title 
wCLtitle = WIDGET_LABEL(ReduceBase,$
                        XOFFSET = sCLtitle.size[0],$
                        YOFFSET = sCLtitle.size[1],$
                        VALUE   = sCLtitle.value)

wCLpath = WIDGET_BUTTON(ReduceBase,$
                        XOFFSET   = sCLpath.size[0],$
                        YOFFSET   = sCLpath.size[1],$
                        SCR_XSIZE = sCLpath.size[2],$
                        UNAME     = sCLpath.uname,$
                        VALUE     = sCLpath.value)

wCLfile = WIDGET_TEXT(ReduceBase,$
                      XOFFSET   = sCLfile.size[0],$
                      YOFFSET   = sCLfile.size[1],$
                      SCR_XSIZE = sCLfile.size[2],$
                      UNAME     = sCLfile.uname,$
                      VALUE     = sCLfile.value,$
                      /EDITABLE)
                      
wCLbutton = WIDGET_BUTTON(ReduceBase,$
                          XOFFSET = sCLbutton.size[0],$
                          YOFFSET = sCLbutton.size[1],$
                          SCR_XSIZE = sCLbutton.size[2],$
                          SCR_YSIZE = sCLbutton.size[3],$
                          UNAME     = sCLbutton.uname,$
                          VALUE     = sCLbutton.value)

wCLframe = WIDGET_LABEL(ReduceBase,$
                        XOFFSET   = sCLframe.size[0],$
                        YOFFSET   = sCLframe.size[1],$
                        SCR_XSIZE = sCLframe.size[2],$
                        SCR_YSIZE = sCLframe.size[3],$
                        VALUE     = '',$
                        FRAME     = sCLframe.frame)

;------------------------------------------------------------------------------

;tabs of 'input data setup', 'process setup' ....
MakeGuiReduceInputTab, ReduceBase, ReduceInputTabSettings

;tabs of 'CLG status' and 'XML reduce file'
MakeGuiReduceClgXmlTab, ReduceBase, ReduceClgXmlTabSettings

;------------------------------------------------------------------------------
;Submit Batch Button
buttonBatch = WIDGET_BUTTON(ReduceBase,$
                            XOFFSET   = SubmitButtonBatch.size[0],$
                            YOFFSET   = SubmitButtonBatch.size[1],$
                            SCR_XSIZE = SubmitButtonBatch.size[2],$
;                            SCR_YSIZE = SubmitButtonBatch.size[3],$
                            VALUE     = SubmitButtonBatch.title,$
                            SENSITIVE = SubmitButtonBatch.sensitive,$
                            UNAME     = SubmitButtonBatch.uname)

;Submit Button
button = WIDGET_BUTTON(ReduceBase,$
                       XOFFSET   = SubmitButton.size[0],$
                       YOFFSET   = SubmitButton.size[1],$
                       SCR_XSIZE = SubmitButton.size[2],$
;                       SCR_YSIZE = SubmitButton.size[3],$
                       VALUE     = SubmitButton.title,$
                       SENSITIVE = SubmitButton.sensitive,$
                       UNAME     = SubmitButton.uname)

;Check Status button
buttonStatus = WIDGET_BUTTON(ReduceBase,$
                             XOFFSET   = sCheckStatus.size[0],$
                             YOFFSET   = sCheckStatus.size[1],$
                             SCR_XSIZE = sCheckStatus.size[2],$
                             UNAME     = sCheckStatus.uname,$
                             VALUE     = sCheckStatus.title)

;------------------------------------------------------------------------------

;Data Reduction status
label = WIDGET_LABEL(ReduceBase,$
                     XOFFSET   = Status.label.size[0],$
                     YOFFSET   = Status.label.size[1],$
                     VALUE     = Status.label.title)
                     
text = WIDGET_TEXT(ReduceBase,$
                   XOFFSET   = Status.text.size[0],$
                   YOFFSET   = Status.text.size[1],$
                   SCR_XSIZE = Status.text.size[2],$
                   UNAME     = Status.text.uname,$
                   /ALIGN_LEFT)

frame = WIDGET_LABEL(ReduceBase,$
                     XOFFSET   = Status.frame.size[0],$
                     YOFFSET   = Status.frame.size[1],$
                     SCR_XSIZE = Status.frame.size[2],$
                     SCR_YSIZE = Status.frame.size[3],$
                     FRAME     = 1,$
                     VALUE     = '')

;Command Line Generator
label = WIDGET_LABEL(ReduceBase,$
                     XOFFSET = clg.label.size[0],$
                     YOFFSET = clg.label.size[1],$
                     VALUE   = clg.label.title)

text = WIDGET_TEXT(ReduceBase,$
                   XOFFSET = clg.text.size[0],$
                   YOFFSET = clg.text.size[1],$
                   SCR_XSIZE = clg.text.size[2],$
                   SCR_YSIZE = clg.text.size[3],$
                   UNAME = clg.text.uname,$
                   /ALIGN_LEFT,$
                   /WRAP,$
                   /SCROLL)


END
