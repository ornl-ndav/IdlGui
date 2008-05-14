;===============================================================================
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
;===============================================================================

PRO MakeGui, MAIN_BASE, $
             MainBaseSize, $
             InstrumentList, $
             InstrumentIndex, $
             ArchivedUser

;******************************************************************************
;                           Define size arrays
;******************************************************************************
base = { size  : [0,0,MainBaseSize[2:3]],$
         uname : 'first_base'} 

;proposal droplist
XYoff = [5,0]
sProposalDroplist = { size:  [XYoff[0],$
                              XYoff[1]],$
                      list: ['      Proposal ?      '],$
                      uname: 'proposal_droplist'};

XYoff = [190,0]                      
run_number_base = { size  : [XYoff[0],$
                             XYoff[1],$
                             140,$
                             35],$
                    uname : 'run_number_cw_field',$
                    xsize : 14,$
                    title : 'Runs'}

XYOff = [137,0]
instrumentDroplist = { size : [run_number_base.size[0]+XYoff[0],$
                               run_number_base.size[1]+XYoff[1]],$
                       uname : 'instrument_droplist'}

;///////////////HISTOGRAMMING PARAMETERS BASE/////////////////////
XYoff = [10,40]
BinningBase = { size  : [base.size[0]+XYoff[0],$
                         run_number_base.size[1]+XYoff[1],$
                         430,40],$
                uname : 'binning_base',$
                frame : 1}
                         
XYoff = [5,10]
offsetLabel = { size  : [XYoff[0],$
                         XYoff[1]],$
                value : 'Time Min.:'}
XYoff = [65,-8]
offsetText = { size  : [offsetLabel.size[0]+XYoff[0],$
                        offsetLabel.size[1]+XYoff[1],$
                        60,35],$
               uname : 'time_offset',$
               value : ''}
XYoff = [5,0]
maxLabel = { size  : [offsetText.size[0]+offsetText.size[2]+XYoff[0],$
                      offsetLabel.size[1]],$
             value : 'Max.:'}
XYoff = [35,-8]
maxText = { size  : [maxLabel.size[0]+XYoff[0],$
                     maxLabel.size[1]+XYoff[1],$
                     60,35],$
            uname : 'time_max',$
            value : ''}
XYoff = [10,0]
binLabel = { size  : [maxText.size[0]+offsetText.size[2]+XYoff[0],$
                      offsetLabel.size[1]],$
             value : 'Size:'}
XYoff = [35,-8]
binText = { size  : [binLabel.size[0]+XYoff[0],$
                     binLabel.size[1]+XYoff[1],$
                     60,35],$
            uname : 'time_bin',$
            value : ''}
XYoff      = [5,-8]
binTypeDroplist = { size  : [binText.size[0]+binText.size[2]+XYoff[0],$
                             offsetLabel.size[1]+XYoff[1]],$
                    uname : 'bin_type_droplist',$
                    list  : ['Linear','Log.']}

;------------------------------------------------------------------------------

XYoff = [0,48]
output_button = { size  : [BinningBase.size[0]+XYoff[0],$
                           BinningBase.size[1]+XYoff[1],$
                           130,35],$
                  uname : 'output_button',$
                  value : 'Main Output path...'}

XYoff = [130,0]
output_text = { size  : [output_button.size[0]+XYoff[0],$
                         output_button.size[1]+XYoff[1],$
                         305,35],$
                uname : 'output_path_text',$
                value : '~/local/'}

XYoff = [0,40]
shared_base = { size : [output_button.size[0]+XYoff[0],$
                        output_button.size[1]+XYoff[1],$
                        460,35],$
                uname : 'shared_base'}
button_list = { list : ['Copy -> Instrument Shared Folder',$
                        'Copy -> Proposal Shared Folder  '],$
                uname : 'shared_button'}

;------------------------------------------------------------------------------

XYoff = [0,45]
IF (ArchivedUser) THEN BEGIN
    XSIZE = 300
ENDIF ELSE BEGIN
    XSIZE = 430
ENDELSE
go_button = { size  : [shared_base.size[0]+XYoff[0],$
                       shared_base.size[1]+XYoff[1],$
                       XSIZE,30],$
              uname : 'create_nexus_button',$
              value : 'C R E A T E   N E X U S'}

IF (ArchivedUser) THEN BEGIN
    XYoff = [0,0]
    sArchivedButton = { size:      [go_button.size[0]+$
                                    go_button.size[2]+$
                                    XYoff[0],$
                                    go_button.size[1]+XYoff[1],$
                                    135,30],$
                        uname:     'archived_button',$
                        value:     'ARCHIVED NEXUS',$
                        sensitive: 0}
ENDIF


;------------------------------------------------------------------------------

XYOFF = [0,45]
log_book = { size  : [go_button.size[0]+XYoff[0],$
                      go_button.size[1]+XYoff[1],$
                      430,150],$
             uname : 'log_book'}

XYoff = [0,Log_book.size[3]+10]
STGlabel = { size  : [log_book.size[0]+XYoff[0],$
                      log_book.size[1]+XYoff[1]],$
             value : 'Message:',$
             uname : 'send_to_geek_label'}
XYoff = [55,-5]
STGtext = { size  : [STGlabel.size[0]+XYoff[0],$
                     STGlabel.size[1]+XYoff[1],$
                     278,30],$
            uname : 'send_to_geek_text'}
XYoff = [STGtext.size[2],0]
STGbutton = { size  : [STGtext.size[0]+XYoff[0],$
                       STGtext.size[1]+XYoff[1],$
                       100,30],$
              uname : 'send_to_geek_button',$
              value : 'Send To Geek'}
                     
XYOFF = [0,log_book.size[3]+45]
my_log_book = { size  : [log_book.size[0]+XYoff[0],$
                         log_book.size[1]+XYoff[1],$
                         830,200],$
                uname : 'my_log_book'}

;******************************************************************************
;                                Build GUI
;******************************************************************************
base = WIDGET_BASE(MAIN_BASE,$
                   UNAME     = base.uname,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = base.size[2],$
                   SCR_YSIZE = base.size[3],$
                   map=1)

wProposalDroplist = WIDGET_DROPLIST(base,$
                                    VALUE   = sProposalDroplist.list,$
                                    XOFFSET = sProposalDroplist.size[0],$
                                    YOFFSET = sProposalDroplist.size[1],$
                                    UNAME   = sProposalDroplist.uname)

run_base = WIDGET_BASE(base,$
                       XOFFSET   = run_number_base.size[0],$
                       YOFFSET   = run_number_base.size[1],$
                       SCR_XSIZE = run_number_base.size[2],$
                       SCR_YSIZE = run_number_base.size[3])

run_number = CW_FIELD(run_base,$
                      XSIZE         = run_number_base.xsize,$
                      UNAME         = run_number_base.uname,$
                      RETURN_EVENTS = 1,$
                      ROW           = 1,$
                      TITLE         = run_number_base.title)
                              
Instrument_droplist = WIDGET_DROPLIST(base,$
                                      VALUE   = InstrumentList,$
                                      XOFFSET = instrumentDroplist.size[0],$
                                      YOFFSET = instrumentDroplist.size[1],$
                                      UNAME   = instrumentDroplist.uname)


;///////////////////HISTOGRAMMING BASE//////////////////////////
BinningBase = WIDGET_BASE(base,$
                          XOFFSET    = BinningBase.size[0],$
                          YOFFSET    = BinningBase.size[1],$
                          SCR_XSIZE  = BinningBase.size[2],$
                          SCR_YSIZE  = BinningBase.size[3],$
                          UNAME      = BinningBase.uname,$
                          FRAME      = BinningBase.frame)

wOffsetLabel = WIDGET_LABEL(BinningBase,$
                            XOFFSET = offsetLabel.size[0],$
                            YOFFSET = offsetLabel.size[1],$
                            VALUE   = offsetLabel.value)

wOffsetText = WIDGET_TEXT(BinningBase,$
                          XOFFSET   = offsetText.size[0],$
                          YOFFSET   = offsetText.size[1],$
                          SCR_XSIZE = offsetText.size[2],$
                          SCR_YSIZE = offsetText.size[3],$
                          VALUE     = offsetText.value,$
                          UNAME     = offsetText.uname,$
                          /ALL_EVENTS,$
                          /EDITABLE)

wMaxLabel = WIDGET_LABEL(BinningBase,$
                            XOFFSET = maxLabel.size[0],$
                            YOFFSET = maxLabel.size[1],$
                            VALUE   = maxLabel.value)

wMaxText = WIDGET_TEXT(BinningBase,$
                          XOFFSET   = maxText.size[0],$
                          YOFFSET   = maxText.size[1],$
                          SCR_XSIZE = maxText.size[2],$
                          SCR_YSIZE = maxText.size[3],$
                          VALUE     = maxText.value,$
                          UNAME     = maxText.uname,$
                          /ALL_EVENTS,$
                          /EDITABLE)

wbinLabel = WIDGET_LABEL(BinningBase,$
                            XOFFSET = binLabel.size[0],$
                            YOFFSET = binLabel.size[1],$
                            VALUE   = binLabel.value)

wbinText = WIDGET_TEXT(BinningBase,$
                          XOFFSET   = binText.size[0],$
                          YOFFSET   = binText.size[1],$
                          SCR_XSIZE = binText.size[2],$
                          SCR_YSIZE = binText.size[3],$
                          VALUE     = binText.value,$
                          UNAME     = binText.uname,$
                          /ALL_EVENTS,$
                          /EDITABLE)

wDroplist2 = WIDGET_DROPLIST(BinningBase,$
                             VALUE     = binTypeDroplist.list,$
                             XOFFSET   = binTypeDroplist.size[0],$
                             YOFFSET   = binTypeDroplist.size[1],$
                             UNAME     = binTypeDroplist.uname,$
                             SENSITIVE = 1,$
                             /DYNAMIC_RESIZE)

;- Main Output Path ------------------------------------------------------------

button = WIDGET_BUTTON(base,$
                       XOFFSET   = output_button.size[0],$
                       YOFFSET   = output_button.size[1],$
                       SCR_XSIZE = output_button.size[2],$
                       SCR_YSIZE = output_button.size[3],$
                       UNAME     = output_button.uname,$
                       VALUE     = output_button.value)

text = WIDGET_TEXT(base,$
                   XOFFSET   = output_text.size[0],$
                   YOFFSET   = output_text.size[1],$
                   SCR_XSIZE = output_text.size[2],$
                   SCR_YSIZE = output_text.size[3],$
                   VALUE     = output_text.value,$
                   UNAME     = output_text.uname,$
                   /ALL_EVENTS,$
                   /EDITABLE)

base_shared = WIDGET_BASE(base,$
                          XOFFSET   = shared_base.size[0],$
                          YOFFSET   = shared_base.size[1],$
                          SCR_XSIZE = shared_base.size[2],$
                          SCR_YSIZE = shared_base.size[3],$
                          UNAME     = shared_base.uname)
                          
group = CW_BGROUP(base_shared,$
                  button_list.list,$
                  UNAME      = button_list.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = [0,0],$
                  ROW        = 1)

;------------------------------------------------------------------------------
button = WIDGET_BUTTON(base,$
                       XOFFSET   = go_button.size[0],$
                       YOFFSET   = go_button.size[1],$
                       SCR_XSIZE = go_button.size[2],$
                       SCR_YSIZE = go_button.size[3],$
                       UNAME     = go_button.uname,$
                       VALUE     = go_button.value,$
                       SENSITIVE = 0)

;------------------------------------------------------------------------------
IF (ArchivedUser) THEN BEGIN
    wArchivedButton = WIDGET_BUTTON(base,$
                                    XOFFSET = sArchivedButton.size[0],$
                                    YOFFSET = sArchivedButton.size[1],$
                                    SCR_XSIZE = sArchivedButton.size[2],$
                                    SCR_YSIZE = sArchivedButton.size[3],$
                                    VALUE     = sArchivedButton.value,$
                                    UNAME     = sArchivedButton.uname,$
                                    SENSITIVE = sArchivedButton.sensitive)
ENDIF

;------------------------------------------------------------------------------
text = WIDGET_TEXT(base,$
                   XOFFSET   = log_book.size[0],$
                   YOFFSET   = log_book.size[1],$
                   SCR_XSIZE = log_book.size[2],$
                   SCR_YSIZE = log_book.size[3],$
                   VALUE     = '',$
                   UNAME     = log_book.uname,$
                   /WRAP,$
                   /SCROLL)

label = WIDGET_LABEL(base,$
                     XOFFSET   = STGlabel.size[0],$
                     YOFFSET   = STGlabel.size[1],$
                     VALUE     = STGlabel.value,$
                     UNAME     = STGlabel.uname,$
                     SENSITIVE = 0)

text = WIDGET_TEXT(base,$
                   XOFFSET   = STGtext.size[0],$
                   YOFFSET   = STGtext.size[1],$
                   SCR_XSIZE = STGtext.size[2],$
                   SCR_YSIZE = STGtext.size[3],$
                    UNAME     = STGtext.uname,$
                   /EDITABLE)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = STGbutton.size[0],$
                       YOFFSET   = STGbutton.size[1],$
                       SCR_XSIZE = STGbutton.size[2],$
                       SCR_YSIZE = STGbutton.size[3],$
                       VALUE     = STGbutton.value,$
                       UNAME     = STGbutton.uname,$
                       SENSITIVE = 0)

text = WIDGET_TEXT(base,$
                   XOFFSET   = my_log_book.size[0],$
                   YOFFSET   = my_log_book.size[1],$
                   SCR_XSIZE = my_log_book.size[2],$
                   SCR_YSIZE = my_log_book.size[3],$
                   VALUE     = '',$
                   UNAME     = my_log_book.uname,$
                   /WRAP,$
                   /SCROLL)



END
