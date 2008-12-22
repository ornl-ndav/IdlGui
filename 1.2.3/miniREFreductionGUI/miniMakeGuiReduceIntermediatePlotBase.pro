PRO miniMakeGuiReduceIntermediatePlotBase, Event, REDUCE_BASE, IndividualBaseWidth, PlotsTitle

InterLabelTitle = 'I N T E R M E D I A T E   P L O T S'
InterLabelSize = [IndividualBasewidth+10,0]

;intermdiate plot base
InterBaseSize = [IndividualBaseWidth-5, $
                 0,$
                 298, $
                 236]
InterMainFramesize = [5,0,288,215]

plot1BaseSize = [15,9,280,23]
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
                 plot1BaseSize[1]+7*plotnYoff,$
                 plot1BaseSize[2],$
                 plot1Basesize[3]]

;remove last plot title from list
sz = (size(PlotsTitle))(1)
;intermediate plots list
InterList = PlotsTitle[0:sz-2]

InterListSize = [10,5]
NotAvailableTitle = '- No Dispo.'

;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

;IndividualLabel = WIDGET_LABEL(REDUCE_BASE,$
;                               XOFFSET = InterLabelSize[0],$
;                               YOFFSET = InterLabelSize[1],$
;                               VALUE   = InterLabeltitle)

;base
InterBase = WIDGET_BASE(REDUCE_BASE,$
                        UNAME     = 'intermediate_base',$
                        XOFFSET   = InterBaseSize[0],$
                        YOFFSET   = InterBaseSize[1],$
                        SCR_XSIZE = InterBaseSize[2],$
                        SCR_YSIZE = InterBasesize[3])

;plot 1 base/label
plot1Base = WIDGET_BASE(InterBase,$
                        XOFFSET   = plot1BaseSize[0],$
                        YOFFSET   = plot1Basesize[1],$
                        SCR_XSIZE = plot1BaseSize[2],$
                        SCR_YSIZE = plot1Basesize[3],$
                        UNAME     = 'reduce_plot1_base',$
                        MAP       = 0)

plot1Label = WIDGET_LABEL(plot1Base,$
                          XOFFSET = 0,$
                          YOFFSET = 0,$
                          VALUE   = InterList[0] + NotAvailableTitle)

;plot 2 base/label
plot2Base = WIDGET_BASE(InterBase,$
                        XOFFSET   = plot2BaseSize[0],$
                        YOFFSET   = plot2Basesize[1],$
                        SCR_XSIZE = plot2BaseSize[2],$
                        SCR_YSIZE = plot2Basesize[3],$
                        UNAME     = 'reduce_plot2_base',$
                        MAP       = 0)

plot2Label = WIDGET_LABEL(plot2Base,$
                          XOFFSET = 0,$
                          YOFFSET = 0,$
                          VALUE   = InterList[1] + NotAvailableTitle)

;plot 3 base/label
plot3Base = WIDGET_BASE(InterBase,$
                        XOFFSET   = plot3BaseSize[0],$
                        YOFFSET   = plot3Basesize[1],$
                        SCR_XSIZE = plot3BaseSize[2],$
                        SCR_YSIZE = plot3Basesize[3],$
                        UNAME     = 'reduce_plot3_base',$
                        MAP       = 0)

plot3Label = WIDGET_LABEL(plot3Base,$
                          XOFFSET = 0,$
                          YOFFSET = 0,$
                          VALUE   = InterList[2] + NotAvailableTitle)

;plot 4 base/label
plot4Base = WIDGET_BASE(InterBase,$
                        XOFFSET   = plot4BaseSize[0],$
                        YOFFSET   = plot4Basesize[1],$
                        SCR_XSIZE = plot4BaseSize[2],$
                        SCR_YSIZE = plot4Basesize[3],$
                        UNAME     = 'reduce_plot4_base',$
                        MAP       = 0)

plot4Label = WIDGET_LABEL(plot4Base,$
                          XOFFSET = 0,$
                          YOFFSET = 0,$
                          VALUE   = InterList[3] + NotAvailableTitle)

;plot 5 base/label
plot5Base = WIDGET_BASE(InterBase,$
                        XOFFSET   = plot5BaseSize[0],$
                        YOFFSET   = plot5Basesize[1],$
                        SCR_XSIZE = plot5BaseSize[2],$
                        SCR_YSIZE = plot5Basesize[3],$
                        UNAME     = 'reduce_plot5_base',$
                        MAP       = 0)

plot5Label = WIDGET_LABEL(plot5Base,$
                          XOFFSET = 0,$
                          YOFFSET = 0,$
                          VALUE   = InterList[4] + NotAvailableTitle)

;plot 6 base/label
plot6Base = WIDGET_BASE(InterBase,$
                        XOFFSET   = plot6BaseSize[0],$
                        YOFFSET   = plot6Basesize[1],$
                        SCR_XSIZE = plot6BaseSize[2],$
                        SCR_YSIZE = plot6Basesize[3],$
                        UNAME     = 'reduce_plot6_base',$
                        MAP       = 0)

plot6Label = WIDGET_LABEL(plot6Base,$
                          XOFFSET = 0,$
                          YOFFSET = 0,$
                          VALUE   = InterList[5] + NotAvailableTitle)

;plot 7 base/label
plot7Base = WIDGET_BASE(InterBase,$
                        XOFFSET   = plot7BaseSize[0],$
                        YOFFSET   = plot7Basesize[1],$
                        SCR_XSIZE = plot7BaseSize[2],$
                        SCR_YSIZE = plot7Basesize[3],$
                        UNAME     = 'reduce_plot7_base',$
                        MAP       = 0)

plot7Label = WIDGET_LABEL(plot7Base,$
                          XOFFSET = 0,$
                          YOFFSET = 0,$
                          VALUE   = InterList[6] + NotAvailableTitle)

;plot 8 base/label
plot8Base = widget_base(InterBase,$
                        xoffset=plot8BaseSize[0],$
                        yoffset=plot8Basesize[1],$
                        scr_xsize=plot8BaseSize[2],$
                        scr_ysize=plot8Basesize[3],$
                        uname='reduce_plot8_base',$
                        map=0)

plot8Label = widget_label(plot8Base,$
                          xoffset=0,$
                          yoffset=0,$
                          value=InterList[7] + NotAvailableTitle)





InterList = CW_BGROUP(InterBase,$
                      InterList,$
                      XOFFSET   =InterListSize[0],$
                      YOFFSET   =InterListSize[1],$
                      UNAME     ='intermediate_plot_list',$
                      SET_VALUE =[0,0,0,0,0,0,0,0],$
                      /NONEXCLUSIVE)
                            
; InterMainFrame = WIDGET_LABEL(InterBase,$
;                               XOFFSET   = InterMainFrameSize[0],$
;                               YOFFSET   = InterMainFrameSize[1],$
;                               SCR_XSIZE = InterMainFrameSize[2],$
;                               SCR_YSIZE = InterMainFrameSize[3],$
;                               FRAME     = 1,$
;                               VALUE='')


END
