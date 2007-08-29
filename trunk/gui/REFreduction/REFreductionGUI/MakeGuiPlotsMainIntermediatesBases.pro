PRO MakeGuiPlotsMainIntermediatesBases, PLOTS_BASE, PlotsTitle

;define widgets variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainPlotBaseSize  = [ 200,40,970,680]
MainPlotDrawSize  = [0,0,MainPlotBaseSize[2],MainPlotBasesize[3]]
PlotsDropListSize = [500,0]

;build widgets
MainPlotBase = Widget_base(PLOTS_BASE,$
                           UNAME='main_plot_base',$
                           xoffset=MainPlotBaseSize[0],$
                           yoffset=MainPlotBaseSize[1],$
                           scr_xsize=MainPlotBaseSize[2],$
                           scr_ysize=MainPlotBaseSize[3],$
                           frame=3)
                          
MainPlotDraw = widget_draw(MainPlotBase,$
                           uname='main_plot_draw',$
                           xoffset=MainPlotDrawSize[0],$
                           yoffset=MainPlotDrawSize[1],$
                           scr_xsize=MainPlotDrawSize[2],$
                           scr_ysize=MainPlotDrawSize[3])

PlotsDropList = widget_droplist(PLOTS_BASE,$
                                xoffset=PlotsDropListSize[0],$
                                yoffset=PlotsDropListSize[1],$
                                value=PlotsTitle)
                                
                               
END
