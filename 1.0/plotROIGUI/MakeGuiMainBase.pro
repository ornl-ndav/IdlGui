PRO MakeGuiMainBase, MAIN_BASE, global

;///////////////////////////////////////
;         General Information
;///////////////////////////////////////
GIframe           = { size  : [15,15,500,45],$
                      frame : 3}

XYoff_f           = [20,-8]
GItitle           = { size  : [GIframe.size[0]+XYoff_f[0],$
                               GIframe.size[1]+XYoff_f[1]],$
                      value : 'General Information'}

XYoff             = [20,20]
GIinstLabel       = { size  : [GIframe.size[0]+XYoff[0],$
                               GIFrame.size[1]+XYoff[1]],$
                      value : 'Instrument:'}

XYoff             = [70,-10]
ListOfInstruments = ['   PLease Select An Instrument . . . ', $
                     (*global).ListOfInstruments]
GIdroplist        = { size   : [GIinstLabel.size[0]+XYoff[0],$
                                GIinstLabel.size[1]+XYoff[1]],$
                      value  : ListOfInstruments,$
                      uname  : 'list_of_instrument'}

;///////////////////////////////////////
;         Nexus Input Box
;///////////////////////////////////////
XYoff    = [0,20]
NBframe = { size  : [15+XYoff[0], $
                     15+XYoff[1]+GIframe.size[3], $
                     GIframe.size[2], $
                     100],$
            frame : 3 }

NBtitle = { size  : [NBframe.size[0]+XYoff_f[0],$
                      NBframe.size[1]+XYoff_f[1]],$
             value : 'NeXus File'}

XYoff        = [20,15]
NBrunField  = { size       : [NBframe.size[0]+XYoff[0],$
                              NBframe.size[1]+XYoff[1],$
                              200, $
                              35,$
                              15, $
                              1],$
                 title      : 'Run Number: ',$
                uname_base : 'nexus_run_number_base',$
                uname      : 'nexus_run_number'}
XYoff        = [0,8]
NBor         = { size  : [NBrunField.size[0]+NBrunField.size[2]+XYoff[0],$
                          NBrunField.size[1]+XYoff[1]],$
                 value : 'OR',$
                 uname : 'nexus_file_or_label'}
XYoff        = [25,-8]
NBbutton     = { size  : [NBor.size[0]+XYoff[0],$
                          NBor.size[1]+XYoff[1],$
                          115,35],$
                 value : 'BROWSE ...',$
                 uname : 'browse_nexus'}
XYoff        = [20,40]
NBfield       = { size  : [NBframe.size[0]+XYoff[0],$
                           NBbutton.size[1]+XYoff[1],$
                           470, $
                           35,$
                           55, $
                           1],$
                  title : 'Full Nexus Name:',$
                  uname_base : 'nexus_file_base',$
                  uname : 'nexus_file_text_field'}
                 
;///////////////////////////////////////
;              ROI file
;///////////////////////////////////////
XYoff    = [0,20]
ROIframe = { size  : [15+XYoff[0], $
                      NBframe.size[1]+XYoff[1]+NBframe.size[3], $
                      GIframe.size[2], $
                      55],$
             frame : 3 }

ROItitle = { size  : [ROIframe.size[0]+XYoff_f[0],$
                      ROIframe.size[1]+XYoff_f[1]],$
             value : 'ROI file'}

XYoff    = [20,15]
ROIbutton = { size  : [ROIframe.size[0]+XYoff[0],$
                       ROIframe.size[1]+XYoff[1],$
                       115,35],$
              uname : 'browse_roi_button',$
              value : 'BROWSE ...'}

XYoff    = [5,8]
ROIor    = { size : [ROIbutton.size[0]+ROIbutton.size[2]+XYoff[0],$
                     ROIbutton.size[1]+XYoff[1]],$
             value : 'OR'}
                     
XYoff    = [25,0]
ROItext  = { size  : [ROIor.size[0]+XYoff[0],$
                      ROIbutton.size[1]+XYoff[1],$
                      310,35],$
             uname : 'roi_text_field'}
                     
;///////////////////////////////////////
;         Select bank and PLOT
;///////////////////////////////////////
XYoff    = [0,20]
Bank     = { size : [ROIframe.size[0]+XYoff[0],$
                     ROIframe.size[1]+ROIframe.size[3]+XYoff[1],$
                     5,35],$
             value : 'BANKE 1',$
             uname : 'bank_droplist'}
                     
XYoff     = [100,3]
Mainplot  = { size  : [Bank.size[0]+XYoff[0],$
                       Bank.size[1]+XYoff[1],$
                       390,$
                       30],$
              uname : 'plot_button',$
              value : 'P L O T'}

;///////////////////////////////////////
;             Send To Geek
;///////////////////////////////////////
XYoff = [15,20]
sSTG = { size : [XYoff[0],$
                 MainPlot.size[1]+MainPlot.size[3]+XYoff[1],$
                 GIframe.size[2]]}
         
;***************************************
;            BUILD GUI
;***************************************

;///////////////////////////////////////
;         General Information
;///////////////////////////////////////

wGItitle = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET = GItitle.size[0],$
                         YOFFSET = GItitle.size[1],$
                         VALUE   = GItitle.value)

wGIinstrument = WIDGET_LABEL(MAIN_BASE,$
                             XOFFSET = GIinstLabel.size[0],$
                             YOFFSET = GIinstLabel.size[1],$
                             VALUE   = GIinstLabel.value)

wGIdroplist = WIDGET_DROPLIST(MAIN_BASE,$
                              VALUE   = GIdroplist.value,$
                              XOFFSET = GIdroplist.size[0],$
                              YOFFSET = GIdroplist.size[1],$
                              UNAME   = GIdroplist.uname)

wGIframe = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET   = GIframe.size[0],$
                         YOFFSET   = GIframe.size[1],$
                         SCR_XSIZE = GIframe.size[2],$
                         SCR_YSIZE = GIframe.size[3],$
                         FRAME     = GIframe.frame,$
                         VALUE     = '')

;///////////////////////////////////////
;         Nexus Input Box
;///////////////////////////////////////

wNBtitle = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET = NBtitle.size[0],$
                         YOFFSET = NBtitle.size[1],$
                         VALUE   = NBtitle.value)

wNBrunBase = WIDGET_BASE(MAIN_BASE,$
                          XOFFSET   = NBrunField.size[0],$
                          YOFFSET   = NBrunField.size[1],$
                          SCR_XSIZE = NBrunField.size[2],$
                          SCR_YSIZE = NBrunField.size[3],$
                          UNAME     = NBrunField.uname_base)

wNBrunField = CW_FIELD(wNBrunBase,$
                        XSIZE = NBrunField.size[4],$
                        YSIZE = NBrunField.size[5],$
                        TITLE = NBrunField.title,$
                        UNAME = NBrunField.uname,$
                        /LONG)

wNBofLabel = WIDGET_LABEL(MAIN_BASE,$
                           XOFFSET = NBor.size[0],$
                           YOFFSET = NBor.size[1],$
                           VALUE   = NBor.value,$
                           UNAME   = NBor.uname)

wNButton = WIDGET_BUTTON(MAIN_BASE,$
                         XOFFSET   = NBbutton.size[0],$
                         YOFFSET   = NBbutton.size[1],$
                         SCR_XSIZE = NBbutton.size[2],$
                         SCR_YSIZE = NBbutton.size[3],$
                         VALUE     = NBbutton.value,$
                         UNAME     = NBbutton.uname)

wNBfieldBase = WIDGET_BASE(MAIN_BASE,$
                           XOFFSET   = NBField.size[0],$
                           YOFFSET   = NBField.size[1],$
                           SCR_XSIZE = NBField.size[2],$
                           SCR_YSIZE = NBField.size[3],$
                           UNAME     = NBField.uname_base)

wNBField = CW_FIELD(wNBfieldBase,$
                    XSIZE = NBField.size[4],$
                    YSIZE = NBField.size[5],$
                    TITLE = NBField.title,$
                    UNAME = NBField.uname)

wNBframe = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET   = NBframe.size[0],$
                         YOFFSET   = NBframe.size[1],$
                         SCR_XSIZE = NBframe.size[2],$
                         SCR_YSIZE = NBframe.size[3],$
                         FRAME     = NBframe.frame,$
                         VALUE     = '')

;///////////////////////////////////////
;              ROI file
;///////////////////////////////////////
wROItitle = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET = ROItitle.size[0],$
                         YOFFSET = ROItitle.size[1],$
                         VALUE   = ROItitle.value)

wROIbutton = WIDGET_BUTTON(MAIN_BASE,$
                           XOFFSET   = ROIbutton.size[0],$
                           YOFFSET   = ROIbutton.size[1],$
                           SCR_XSIZE = ROIbutton.size[2],$
                           SCR_YSIZE = ROIbutton.size[3],$
                           VALUE     = ROIbutton.value,$
                           UNAME     = ROIbutton.uname)

wROIor = WIDGET_LABEL(MAIN_BASE,$
                      XOFFSET = ROIor.size[0],$
                      YOFFSET = ROIor.size[1],$
                      VALUE   = ROIor.value)

wROItext = WIDGET_TEXT(MAIN_BASE,$
                       XOFFSET   = ROItext.size[0],$
                       YOFFSET   = ROItext.size[1],$
                       SCR_XSIZE = ROItext.size[2],$
                       SCR_YSIZE = ROItext.size[3],$
                       UNAME     = ROItext.uname,$
                       /EDITABLE)

wROIframe = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET   = ROIframe.size[0],$
                         YOFFSET   = ROIframe.size[1],$
                         SCR_XSIZE = ROIframe.size[2],$
                         SCR_YSIZE = ROIframe.size[3],$
                         FRAME     = ROIframe.frame,$
                         VALUE     = '')

;///////////////////////////////////////
;                PLOT
;///////////////////////////////////////
wBank = WIDGET_DROPLIST(MAIN_BASE,$
                        VALUE   = Bank.value,$
                        XOFFSET = Bank.size[0],$
                        YOFFSET = Bank.size[1],$
                        SCR_YSIZE = Bank.size[3],$
                        UNAME   = Bank.uname)

wplot = WIDGET_BUTTON(MAIN_BASE,$
                      XOFFSET   = Mainplot.size[0],$
                      YOFFSET   = Mainplot.size[1],$
                      SCR_XSIZE = Mainplot.size[2],$
                      SCR_YSIZE = Mainplot.size[3],$
                      UNAME     = Mainplot.uname,$
                      VALUE     = Mainplot.value)

;///////////////////////////////////////
;             Send To Geek
;///////////////////////////////////////
STGinstance = obj_new('IDLsendToGeek', $
                      XOFFSET   = sSTG.size[0],$
                      YOFFSET   = sSTG.size[1],$
                      XSIZE     = sSTG.size[2],$
                      MAIN_BASE = MAIN_BASE)

END
