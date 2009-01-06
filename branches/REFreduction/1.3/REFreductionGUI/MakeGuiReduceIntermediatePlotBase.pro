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

PRO MakeGuiReduceIntermediatePlotBase, Event, $
                                       REDUCE_BASE, $
                                       IndividualBaseWidth, $
                                       PlotsTitle

InterLabelTitle = 'I N T E R M E D I A T E   P L O T S'
InterLabelSize = [IndividualBasewidth+20,10]

;intermdiate plot base
InterBaseSize = [IndividualBaseWidth,15,$
                 510,290]
InterMainFramesize = [5,5,450,270]

plot1BaseSize = [15,22,400,23]
plotnYoff = 28
plot2Basesize = [plot1BaseSize[0],$
                 plot1BaseSize[1]+plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]
plot3Basesize = [plot1BaseSize[0],$
                 plot1BaseSize[1]+2*plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]
plot4Basesize = [plot1BaseSize[0],$
                 plot1BaseSize[1]+3*plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]
plot5Basesize = [plot1BaseSize[0],$
                 plot1BaseSize[1]+4*plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]
plot6Basesize = [plot1BaseSize[0],$
                 plot1BaseSize[1]+5*plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]
plot7Basesize = [plot1BaseSize[0],$
                 plot1BaseSize[1]+6*plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]
plot8Basesize = [plot1BaseSize[0],$
                 plot1BaseSize[1]+8*plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]

;remove last plot title from list
sz = (size(PlotsTitle))(1)
;intermediate plots list
InterList = PlotsTitle

InterListSize = [10,15]
NotAvailableTitle = ' -- NOT AVAILABLE! --'

;*********************************************************
;Create GUI

IndividualLabel = widget_label(REDUCE_BASE,$
                               xoffset=InterLabelSize[0],$
                               yoffset=InterLabelSize[1],$
                               value=InterLabeltitle,$
                               uname='reduce_label8')

;base
InterBase = widget_base(REDUCE_BASE,$
                        uname='intermediate_base',$
                        xoffset=InterBaseSize[0],$
                        yoffset=InterBaseSize[1],$
                        scr_xsize=InterBaseSize[2],$
                        scr_ysize=InterBasesize[3])

;plot 1 base/label
plot1Base = widget_base(InterBase,$
                        xoffset=plot1BaseSize[0],$
                        yoffset=plot1Basesize[1],$
                        scr_xsize=plot1BaseSize[2],$
                        scr_ysize=plot1Basesize[3],$
                        uname='reduce_plot1_base',$
                        map=0)

plot1Label = widget_label(plot1Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[0] + NotAvailableTitle)

;plot 2 base/label
plot2Base = widget_base(InterBase,$
                        xoffset=plot2BaseSize[0],$
                        yoffset=plot2Basesize[1],$
                        scr_xsize=plot2BaseSize[2],$
                        scr_ysize=plot2Basesize[3],$
                        uname='reduce_plot2_base',$
                        map=0)

plot2Label = widget_label(plot2Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[1] + NotAvailableTitle)

;plot 3 base/label
plot3Base = widget_base(InterBase,$
                        xoffset=plot3BaseSize[0],$
                        yoffset=plot3Basesize[1],$
                        scr_xsize=plot3BaseSize[2],$
                        scr_ysize=plot3Basesize[3],$
                        uname='reduce_plot3_base',$
                        map=0)

plot3Label = widget_label(plot3Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[2] + NotAvailableTitle)

;plot 4 base/label
plot4Base = widget_base(InterBase,$
                        xoffset=plot4BaseSize[0],$
                        yoffset=plot4Basesize[1],$
                        scr_xsize=plot4BaseSize[2],$
                        scr_ysize=plot4Basesize[3],$
                        uname='reduce_plot4_base',$
                        map=0)

plot4Label = widget_label(plot4Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[3] + NotAvailableTitle)

;plot 5 base/label
plot5Base = widget_base(InterBase,$
                        xoffset=plot5BaseSize[0],$
                        yoffset=plot5Basesize[1],$
                        scr_xsize=plot5BaseSize[2],$
                        scr_ysize=plot5Basesize[3],$
                        uname='reduce_plot5_base',$
                        map=0)

plot5Label = widget_label(plot5Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[4] + NotAvailableTitle)

;plot 6 base/label
plot6Base = widget_base(InterBase,$
                        xoffset=plot6BaseSize[0],$
                        yoffset=plot6Basesize[1],$
                        scr_xsize=plot6BaseSize[2],$
                        scr_ysize=plot6Basesize[3],$
                        uname='reduce_plot6_base',$
                        map=0)

plot6Label = widget_label(plot6Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[5] + NotAvailableTitle)

;plot 7 base/label
plot7Base = widget_base(InterBase,$
                        xoffset=plot7BaseSize[0],$
                        yoffset=plot7Basesize[1],$
                        scr_xsize=plot7BaseSize[2],$
                        scr_ysize=plot7Basesize[3],$
                        uname='reduce_plot7_base',$
                        map=0)

plot7Label = widget_label(plot7Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[6] + NotAvailableTitle)

;;plot 8 base/label
;plot8Base = widget_base(InterBase,$
;                        xoffset=plot8BaseSize[0],$
;                        yoffset=plot8Basesize[1],$
;                        scr_xsize=plot8BaseSize[2],$
;                        scr_ysize=plot8Basesize[3],$
;                        uname='reduce_plot8_base',$
;                        map=0)

;plot8Label = widget_label(plot8Base,$
;                          xoffset=0,$
;                          yoffset=0,$
;                          value=InterList[7] + NotAvailableTitle)

;plot 9 base/label
plot8Base = widget_base(InterBase,$
                        xoffset=plot8BaseSize[0],$
                        yoffset=plot8Basesize[1],$
                        scr_xsize=plot8BaseSize[2],$
                        scr_ysize=plot8Basesize[3],$
                        uname='reduce_plot8_base',$
                        map=1)

plot8Label = widget_label(plot8Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[8] + NotAvailableTitle)


InterList = cw_bgroup(InterBase,$
                      InterList,$
                      xoffset=InterListSize[0],$
                      yoffset=InterListSize[1],$
                      uname='intermediate_plot_list',$
                      /nonexclusive,$
                      set_value=[0,0,0,0,0,0,0,0])
                            
InterMainFrame = widget_label(InterBase,$
                              xoffset=InterMainFrameSize[0],$
                              yoffset=InterMainFrameSize[1],$
                              scr_xsize=InterMainFrameSize[2],$
                              scr_ysize=InterMainFrameSize[3],$
                              frame=1,$
                              value='')


END
