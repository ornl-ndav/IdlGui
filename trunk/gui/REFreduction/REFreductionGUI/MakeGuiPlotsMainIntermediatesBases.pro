PRO MakeGuiPlotsMainIntermediatesBases, PLOTS_BASE

;define widgets variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainPlotBaseSize = [ 200,20,970,700]
MainPlotDrawSize = [0,0,MainPlotBaseSize[2],MainPlotBasesize[3]]

;Tab Titles
MainPlotTitle          = 'Main Output Plot'
IntermediatePlot1Title = 'Data Specular'
IntermediatePlot2Title = 'Data Background'
IntermediatePlot3Title = 'Data Sub'
IntermediatePlot4Title = 'Normalization Specular'
IntermediatePlot5Title = 'Normalization Background'
IntermediatePlot6Title = 'Normalization Sub'
IntermediatePlot7Title = 'Uncombine'

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






END
