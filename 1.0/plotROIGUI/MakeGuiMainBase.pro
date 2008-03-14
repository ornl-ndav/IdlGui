PRO MakeGuiMainBase, MAIN_BASE, global

;///////////////////////////////////////
;             Nexus File
;///////////////////////////////////////
GIframe           = { size  : [15,15,500,150],$
                      frame : 3}

XYoff_f           = [20,-8]
GItitle           = { size  : [GIframe.size[0]+XYoff_f[0],$
                               GIframe.size[1]+XYoff_f[1]],$
                      value : 'Nexus File'}

XYoff             = [15,20]
GIinstLabel       = { size  : [GIframe.size[0]+XYoff[0],$
                               GIFrame.size[1]+XYoff[1]],$
                      value : 'Instrument:'}

XYoff             = [70,-10]
ListOfInstruments = ['PLease Select An Instrument ...', $
                     (*global).ListOfInstruments]
GIdroplist        = { size   : [GIinstLabel.size[0]+XYoff[0],$
                                GIinstLabel.size[1]+XYoff[1]],$
                      value  : ListOfInstruments,$
                      uname  : 'list_of_instrument'}

XYoff        = [235,0]
NBrunField  = { size       : [GIdroplist.size[0]+XYoff[0],$
                              GIdroplist.size[1]+XYoff[1],$
                              175, $
                              35,$
                              13, $
                              1],$
                title      : '&  Run #:',$
                uname_base : 'nexus_run_number_base',$
                uname      : 'nexus_run_number'}

XYoff = [160,3]
ClearButton0 = { size  : [NBrunField.size[0]+XYoff[0],$
                          NBrunField.size[1]+XYoff[1],$
                          20,30],$
                 uname : 'clear_nexus_run_number',$
                 value : 'X'}

XYoff    =[230,30]
sOrLabel = { size  : [GIframe.size[0]+XYoff[0],$
                     GIinstLabel.size[1]+XYoff[1]],$
             value : 'O R'}
                 
XYoff        = [20,25]
NBbutton     = { size  : [GIframe.size[0]+XYoff[0],$
                          sOrLabel.size[1]+XYoff[1],$
                          460,30],$
                 value : 'B R O W S E   . . .',$
                 uname : 'browse_nexus'}

XYoff        = [20,40]
NBfield       = { size  : [GIframe.size[0]+XYoff[0],$
                           NBbutton.size[1]+XYoff[1],$
                           483, $
                           35,$
                           56, $
                           1],$
                  title : 'Full Nexus Name:',$
                  uname_base : 'nexus_file_base',$
                  uname : 'nexus_file_text_field'}
XYoff = [460,3]
ClearButton1 = { size  : [NBfield.size[0]+XYoff[0],$
                          NBfield.size[1]+XYoff[1],$
                          20,30],$
                 uname : 'clear_nexus_file_text_field',$
                 value : 'X'}
                 
;///////////////////////////////////////
;              ROI file
;///////////////////////////////////////
XYoff    = [0,20]
ROIframe = { size  : [15+XYoff[0], $
                      GIframe.size[1]+XYoff[1]+GIframe.size[3], $
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

XYoff    = [120,0]
ROItext  = { size  : [ROIbutton.size[0]+XYoff[0],$
                      ROIbutton.size[1]+XYoff[1],$
                      340,35],$
             uname : 'roi_text_field'}

XYoff = [0,0]
ClearButton2 = { size  : [ROItext.size[0]+ROItext.size[2]+XYoff[0],$
                          ROItext.size[1]+XYoff[1],$
                          20,35],$
                 uname : 'clear_roi_text_field',$
                 value : 'X'}
                     
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
;                Status
;///////////////////////////////////////
XYoff = [15,20]
sStatusFrame = { size : [XYoff[0],$
                         MainPlot.size[1]+MainPlot.size[3]+XYoff[1],$
                         GIframe.size[2],$
                         40],$
                 frame : 3}

sStatustitle = { size  : [GIframe.size[0]+XYoff_f[0],$
                          sStatusFrame.size[1]+XYoff_f[1]],$
                 value : 'Status'}

XYoff = [20,5]
sStatusLabel = { size : [sStatusFrame.size[0]+XYoff[0],$
                         sSTatusFrame.size[1]+XYoff[1],$
                         GIframe.size[2]-40,$
                         35],$
                 value : '',$
                 uname : 'status_message'}

;///////////////////////////////////////
;             Send To Geekx
;///////////////////////////////////////
XYoff = [15,25]
sSTG = { size : [XYoff[0],$
                 sStatusFrame.size[1]+sStatusFrame.size[3]+XYoff[1],$
                 GIframe.size[2]]}

;///////////////////////////////////////
;             LOG BOOK
;///////////////////////////////////////
XYoff = [15,70]
LB = { size : [XYoff[0],$
               sSTG.size[1]+XYoff[1],$
               505,240],$
       uname : 'log_book_text'}
       
;***************************************
;            BUILD GUI
;***************************************

;///////////////////////////////////////
;         Archived Nexus File
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

wClearButton0 = WIDGET_BUTTON(MAIN_BASE,$
                              XOFFSET   = ClearButton0.size[0],$
                              YOFFSET   = ClearButton0.size[1],$
                              SCR_XSIZE = ClearButton0.size[2],$
                              SCR_YSIZE = ClearButton0.size[3],$
                              UNAME     = ClearButton0.uname,$
                              VALUE     = ClearButton0.value)

wNBrunBase = WIDGET_BASE(MAIN_BASE,$
                          XOFFSET   = NBrunField.size[0],$
                          YOFFSET   = NBrunField.size[1],$
                          SCR_XSIZE = NBrunField.size[2],$
                          SCR_YSIZE = NBrunField.size[3],$
                          UNAME     = NBrunField.uname_base)

wNBrunField = CW_FIELD(wNBrunBase,$
                       XSIZE         = NBrunField.size[4],$
                       YSIZE         = NBrunField.size[5],$
                       TITLE         = NBrunField.title,$
                       UNAME         = NBrunField.uname,$
                       /RETURN_EVENTS)
;                       /LONG)

wOrLabel = WIDGET_LABEL(MAIN_BASE,$
                        XOFFSET = sOrLabel.size[0],$
                        YOFFSET = sOrLabel.size[1],$
                        VALUE   = sOrLabel.value)

wNButton = WIDGET_BUTTON(MAIN_BASE,$
                         XOFFSET   = NBbutton.size[0],$
                         YOFFSET   = NBbutton.size[1],$
                         SCR_XSIZE = NBbutton.size[2],$
                         SCR_YSIZE = NBbutton.size[3],$
                         VALUE     = NBbutton.value,$
                         UNAME     = NBbutton.uname)

wClearButton1 = WIDGET_BUTTON(MAIN_BASE,$
                              XOFFSET   = ClearButton1.size[0],$
                              YOFFSET   = ClearButton1.size[1],$
                              SCR_XSIZE = ClearButton1.size[2],$
                              SCR_YSIZE = ClearButton1.size[3],$
                              UNAME     = ClearButton1.uname,$
                              VALUE     = ClearButton1.value)

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
                    UNAME = NBField.uname,$
                    /RETURN_EVENTS)

wGIframe = WIDGET_LABEL(MAIN_BASE,$
                         XOFFSET   = GIframe.size[0],$
                         YOFFSET   = GIframe.size[1],$
                         SCR_XSIZE = GIframe.size[2],$
                         SCR_YSIZE = GIframe.size[3],$
                         FRAME     = GIframe.frame,$
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

wROItext = WIDGET_TEXT(MAIN_BASE,$
                       XOFFSET   = ROItext.size[0],$
                       YOFFSET   = ROItext.size[1],$
                       SCR_XSIZE = ROItext.size[2],$
                       SCR_YSIZE = ROItext.size[3],$
                       UNAME     = ROItext.uname,$
                       /ALL_EVENTS,$
                       /EDITABLE)

wClearButton2 = WIDGET_BUTTON(MAIN_BASE,$
                              XOFFSET   = ClearButton2.size[0],$
                              YOFFSET   = ClearButton2.size[1],$
                              SCR_XSIZE = ClearButton2.size[2],$
                              SCR_YSIZE = ClearButton2.size[3],$
                              UNAME     = ClearButton2.uname,$
                              VALUE     = ClearButton2.value)

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
                        VALUE     = Bank.value,$
                        XOFFSET   = Bank.size[0],$
                        YOFFSET   = Bank.size[1],$
                        SCR_YSIZE = Bank.size[3],$
                        UNAME     = Bank.uname,$
                        SENSITIVE = 1)

wplot = WIDGET_BUTTON(MAIN_BASE,$
                      XOFFSET   = Mainplot.size[0],$
                      YOFFSET   = Mainplot.size[1],$
                      SCR_XSIZE = Mainplot.size[2],$
                      SCR_YSIZE = Mainplot.size[3],$
                      UNAME     = Mainplot.uname,$
                      VALUE     = Mainplot.value,$
                      SENSITIVE = 0)

;///////////////////////////////////////
;                Status
;///////////////////////////////////////
wStatustitle = WIDGET_LABEL(MAIN_BASE,$
                            XOFFSET = sStatustitle.size[0],$
                            YOFFSET = sStatustitle.size[1],$
                            VALUE   = sStatustitle.value)

wStatusLabel = WIDGET_LABEL(MAIN_BASE,$
                            XOFFSET   = sStatusLabel.size[0],$
                            YOFFSET   = sStatusLabel.size[1],$
                            SCR_XSIZE = sStatusLabel.size[2],$
                            SCR_YSIZE = sStatusLabel.size[3],$
                            VALUE     = sStatusLabel.value,$
                            UNAME     = sStatusLabel.uname)

wStatusframe = WIDGET_LABEL(MAIN_BASE,$
                            XOFFSET   = sStatusframe.size[0],$
                            YOFFSET   = sStatusframe.size[1],$
                            SCR_XSIZE = sStatusframe.size[2],$
                            SCR_YSIZE = sStatusframe.size[3],$
                            FRAME     = sStatusframe.frame,$
                            VALUE     = '')

;///////////////////////////////////////
;             Send To Geek
;///////////////////////////////////////
STGinstance = obj_new('IDLsendToGeek', $
                      XOFFSET   = sSTG.size[0],$
                      YOFFSET   = sSTG.size[1],$
                      XSIZE     = sSTG.size[2],$
                      MAIN_BASE = MAIN_BASE)

;///////////////////////////////////////
;             LOG BOOK
;///////////////////////////////////////
wLB = WIDGET_TEXT(MAIN_BASE,$
                  XOFFSET   = LB.size[0],$
                  YOFFSET   = LB.size[1],$
                  SCR_XSIZE = LB.size[2],$
                  SCR_YSIZE = LB.size[3],$
                  /SCROLL,$
                  /WRAP)

END
