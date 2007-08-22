PRO MakeGuiReduceIntermediatePlotBase, Event, REDUCE_BASE, IndividualBaseWidth

;dimension
IntermediatePlotCWBgroupLabelSize = [IndividualBaseWidth + 80,10]
IntermediatePlotCWBgroupLabelTitle = 'Intermediate plots:'
IntermediatePlotCWBgroupSize = [ IntermediatePlotCWBgroupLabelSize[0]+140, $
                                 IntermediatePlotCWBgroupLabelSize[1]-5]
IntermediatePlotCWBgroupList = [' Yes   ', ' No    ']

;intermdiate plot base
InterBaseSize = [IndividualBaseWidth,40,$
                 510,190]
InterMainFramesize = [5,5,450,155]

;intermediate plots list
InterList = ['Intermediate plot #1',$
             'Intermediate plot #2',$
             'Intermediate plot #3',$
             'Intermediate plot #4',$
             'Intermediate plot #5']
InterListSize = [ 10, 10]
                 

;*********************************************************
;Create GUI

IntermediatePlotCWBgroupLabel = widget_label(REDUCE_BASE,$
                                             xoffset=IntermediatePlotCWBgroupLabelSize[0],$
                                             yoffset=IntermediatePlotCWBgroupLabelSize[1],$
                                             value=IntermediatePlotCWBgroupLabelTitle)

IntermediatePlotCWBgroup = cw_bgroup(REDUCE_BASE,$
                                     IntermediatePlotCWBgroupList,$
                                     uname='intermediate_plot_cwbgroup',$
                                     xoffset=IntermediatePlotCWBgroupSize[0],$
                                     yoffset=IntermediatePlotCWBgroupSize[1],$
                                     set_value=0,$
                                     row=1,$
                                     /exclusive)

;base
InterBase = widget_base(REDUCE_BASE,$
                        uname='intermediate_base',$
                        xoffset=InterBaseSize[0],$
                        yoffset=InterBaseSize[1],$
                        scr_xsize=InterBaseSize[2],$
                        scr_ysize=InterBasesize[3])


InterList = cw_bgroup(InterBase,$
                      InterList,$
                      xoffset=InterListSize[0],$
                      yoffset=InterListSize[1],$
                      uname='intermediate_plot_list',$
                      /nonexclusive,$
                      set_value=[1,1,1,1,1])
                      

InterMainFrame = widget_label(InterBase,$
                              xoffset=InterMainFrameSize[0],$
                              yoffset=InterMainFrameSize[1],$
                              scr_xsize=InterMainFrameSize[2],$
                              scr_ysize=InterMainFrameSize[3],$
                              frame=1,$
                              value='')


END
