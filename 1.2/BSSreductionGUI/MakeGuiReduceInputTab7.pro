PRO MakeGuiReduceInputTab7, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;//////////////////////////////
;Write all intermediate output/
;//////////////////////////////
WAIOBase = { size  : [15,20,500,35],$
             button : { uname : 'waio_button',$
                        list : [' Write All Intermediate Output (WARNING: ' + $
                                'VERGY LARGE FILES AND SLOW)']}}

;/////////////////////////////////////////////////
;Write out Calculated time-independent background/
;/////////////////////////////////////////////////
yoff = 40
WOCTIBbase = { size  : [WAIOBase.size[0], $
                        WAIOBase.size[1]+yoff, $
                        WAIOBase.size[2:3]],$
               button : { uname : 'woctib_button',$
                          list : [' Write Out Calculated Time-Independent ' + $
                                  'Background']}}

NA_WOCTIBbase = { size : [WOCTIBbase.size[0]+5,$
                          WOCTIBbase.size[1]-5,$
                          WOCTIBbase.size[2:3]],$
                  value : 'Calculated Time-Independent Background - NOT AVAILABLE',$
                  uname : 'na_woctibbase'}
                          
;///////////////////////////////////
;Write Out Pixel Wavelength Spectra/
;///////////////////////////////////
WOPWSbase = { size  : [WOCTIBbase.size[0], $
                       WOCTIBbase.size[1]+yoff, $
                       WOCTIBbase.size[2:3]],$
              button : { uname : 'wopws_button',$
                         list : [' Write Out Pixel Wavelength Spectra ' + $
                                 '(WARNING: VERGY LARGE FILE AND SLOW)']}}

;//////////////////////////////////////
;Write Out Monitor Wavelength Spectrum/
;//////////////////////////////////////
WOMWSbase = { size  : [WOPWSbase.size[0], $
                       WOPWSbase.size[1]+yoff, $
                       WOPWSbase.size[2:3]],$
              button : { uname : 'womws_button',$
                         list : [' Write Out Monitor Wavelength Spectrum']}}

NA_WOMWSbase = { size : [WOMWSbase.size[0]+5,$
                         WOMWSbase.size[1]-5,$
                         WOMWSbase.size[2:3]],$
                  value : 'Monitor Wavelength Spectrum - NOT AVAILABLE',$
                  uname : 'na_womwsbase'}

;//////////////////////////////////////
;Write Out Monitor Efficiency Spectrum/
;//////////////////////////////////////
WOMESbase = { size  : [WOMWSbase.size[0], $
                       WOMWSbase.size[1]+yoff, $
                       WOMWSbase.size[2:3]],$
              button : { uname : 'womes_button',$
                         list : [' Write Out Monitor Efficiency Spectrum']}}

NA_WOMESbase = { size : [WOMESbase.size[0]+5,$
                         WOMESbase.size[1]-5,$
                         WOMESbase.size[2:3]],$
                  value : 'Monitor Efficiency Spectrum - NOT AVAILABLE',$
                  uname : 'na_womesbase'}

;///////////////////////////////////
;Write Out Rebinned Monitor Spectra/
;///////////////////////////////////
WORMSbase = { size  : [WOMESbase.size[0], $
                       WOMESbase.size[1]+yoff, $
                       WOMESbase.size[2:3]],$
              button : { uname : 'worms_button',$
                         list : [' Write Out Rebinned Monitor Spectra (WARNING:' + $
                                 ' VERY LARGE FILE AND SLOW)']}}

NA_WORMSbase = { size : [WORMSbase.size[0]+5,$
                         WORMSbase.size[1]-5,$
                         WORMSbase.size[2:3]],$
                  value : 'Rebinned Monitor Spectra - NOT AVAILABLE',$
                  uname : 'na_wormsbase'}

;//////////////////////////////////////////////////////////////
;Write Out Combined Pixel Spectrum After Monitor Normalization/
;//////////////////////////////////////////////////////////////
WOCPSAMNbase = { size  : [WORMSbase.size[0], $
                          WORMSbase.size[1]+yoff, $
                          WORMSbase.size[2:3]],$
              button : { uname : 'wocpsamn_button',$
                         list : [' Write Out Combined Pixel Spectrum After ' + $
                                 'Monitor Normalization']}}

NA_WOCPSAMNbase = { size : [WOCPSAMNbase.size[0]+5,$
                            WOCPSAMNbase.size[1]-5,$
                            WOCPSAMNbase.size[2:3]],$
                    value : 'Combined Pixel Spectrum After Monitor' + $
                    ' Normalization - NOT AVAILABLE',$
                  uname : 'na_wocpsamnbase'}

;//////////////////////////
;Wavelength Histogram Axis/
;//////////////////////////
;yoff = 50
WHAbase = { size : [WOCPSAMNbase.size[0],$
                    WOCPSAMNbase.size[1]+yoff,$
                    700,$
                    40]}
XYoff = [5,5]
WHAlabel = { size : [XYoff[0],$
                     XYoff[1]],$
             uname : 'wa_label',$
             value : 'Wavelength Histogram (Angstroms)'}
xoff = 230
WHAlabel1 = { size : [WHAlabel.size[0]+xoff,$
                      WHAlabel.size[1]],$
              uname : 'wa_min_text_label',$
              value : 'Min:'}
xoff_LT = 30
yoff = -5
WHAtext1  = { size : [WHAlabel1.size[0]+xoff_LT,$
                      WHAlabel1.size[1]+yoff,$
                      70,30],$
              uname : 'wa_min_text'}

xoff_LL = 140
WHAlabel2 = { size : [WHAlabel1.size[0]+xoff_LL,$
                      WHAlabel.size[1]],$
              uname : 'wa_max_text_label',$
              value : 'Max:'}
WHAtext2  = { size : [WHAlabel2.size[0]+xoff_LT,$
                      WHAlabel2.size[1]+yoff,$
                      WHAtext1.size[2:3]],$
              uname : 'wa_max_text'}

WHAlabel3 = { size : [WHAlabel2.size[0]+xoff_LL,$
                      WHAlabel.size[1]],$
              uname : 'wa_bin_width_text_label',$
              value : 'Bin Width:'}
xoff_LT = 68
WHAtext3  = { size : [WHAlabel3.size[0]+xoff_LT,$
                      WHAlabel3.size[1]+yoff,$
                      WHAtext1.size[2:3]],$
              uname : 'wa_bin_width_text'}

;/////////////////////////////////////////////////////////////
;Write Out Linearly Interpolated Direct Scattering Background/
;Info. Summed over all Pixel                                 /
;/////////////////////////////////////////////////////////////
yoff = 50
WOLIDSBbase = { size  : [WHAbase.size[0], $
                        WHAbase.size[1]+yoff, $
                        WHAbase.size[2:3]],$
                button : { uname : 'wolidsb_button',$
                           list : [' Write Out Linearly Interpolated Direct' + $
                                   ' Scattering Background Information Summed' + $
                                   ' over all Pixels']}}

NA_WOLIDSBbase = { size : [WOLIDSBbase.size[0]+5,$
                           WOLIDSBbase.size[1]-5,$
                           WOLIDSBbase.size[2:3]],$
                   value : 'Linearly Interpolated Direct Scatt. Back. ' + $
                   'Information Summed over all Pixels - NOT AVAILABLE',$
                  uname : 'na_wolidsbbase'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
tab7_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[4])

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write all intermediate output\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WAIOBase.size[0],$
                   YOFFSET   = WAIOBase.size[1],$
                   SCR_XSIZE = WAIOBase.size[2],$
                   SCR_YSIZE = WAIOBase.size[3])

group = CW_BGROUP(base,$
                  WAIOBase.button.list,$
                  UNAME      = WAIOBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)
                  
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write out Calculated time-independent background\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
NA_base = WIDGET_BASE(tab7_base,$
                      UNAME     = NA_WOCTIBbase.uname,$
                      XOFFSET   = NA_WOCTIBbase.size[0],$
                      YOFFSET   = NA_WOCTIBbase.size[1],$
                      SCR_XSIZE = NA_WOCTIBbase.size[2],$
                      SCR_YSIZE = NA_WOCTIBbase.size[3],$
                      MAP       = 0,$
                      ROW       = 1)

NA_label = WIDGET_LABEL(NA_base,$
                        VALUE = NA_WOCTIBbase.value)

base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WOCTIBbase.size[0],$
                   YOFFSET   = WOCTIBbase.size[1],$
                   SCR_XSIZE = WOCTIBbase.size[2],$
                   SCR_YSIZE = WOCTIBbase.size[3])

group = CW_BGROUP(base,$
                  WOCTIBbase.button.list,$
                  UNAME      = WOCTIBbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write out Pixel Wavelength Spectra\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WOPWSbase.size[0],$
                   YOFFSET   = WOPWSbase.size[1],$
                   SCR_XSIZE = WOPWSbase.size[2],$
                   SCR_YSIZE = WOPWSbase.size[3])

group = CW_BGROUP(base,$
                  WOPWSbase.button.list,$
                  UNAME      = WOPWSbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write out Monitor Wavelength Spectrum\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
NA_base = WIDGET_BASE(tab7_base,$
                      UNAME     = NA_WOMWSbase.uname,$
                      XOFFSET   = NA_WOMWSbase.size[0],$
                      YOFFSET   = NA_WOMWSbase.size[1],$
                      SCR_XSIZE = NA_WOMWSbase.size[2],$
                      SCR_YSIZE = NA_WOMWSbase.size[3],$
                      MAP       = 0,$
                      ROW       = 1)

NA_label = WIDGET_LABEL(NA_base,$
                        VALUE = NA_WOMWSbase.value)

base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WOMWSbase.size[0],$
                   YOFFSET   = WOMWSbase.size[1],$
                   SCR_XSIZE = WOMWSbase.size[2],$
                   SCR_YSIZE = WOMWSbase.size[3])

group = CW_BGROUP(base,$
                  WOMWSbase.button.list,$
                  UNAME      = WOMWSbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write out Monitor Efficiency Spectrum\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
NA_base = WIDGET_BASE(tab7_base,$
                      UNAME     = NA_WOMESbase.uname,$
                      XOFFSET   = NA_WOMESbase.size[0],$
                      YOFFSET   = NA_WOMESbase.size[1],$
                      SCR_XSIZE = NA_WOMESbase.size[2],$
                      SCR_YSIZE = NA_WOMESbase.size[3],$
                      MAP       = 0,$
                      ROW       = 1)

NA_label = WIDGET_LABEL(NA_base,$
                        VALUE = NA_WOMESbase.value)

base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WOMESbase.size[0],$
                   YOFFSET   = WOMESbase.size[1],$
                   SCR_XSIZE = WOMESbase.size[2],$
                   SCR_YSIZE = WOMESbase.size[3])

group = CW_BGROUP(base,$
                  WOMESbase.button.list,$
                  UNAME      = WOMESbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write out Rebinned Monitor Spectra\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
NA_base = WIDGET_BASE(tab7_base,$
                      UNAME     = NA_WORMSbase.uname,$
                      XOFFSET   = NA_WORMSbase.size[0],$
                      YOFFSET   = NA_WORMSbase.size[1],$
                      SCR_XSIZE = NA_WORMSbase.size[2],$
                      SCR_YSIZE = NA_WORMSbase.size[3],$
                      MAP       = 0,$
                      ROW       = 1)

NA_label = WIDGET_LABEL(NA_base,$
                        VALUE = NA_WORMSbase.value)

base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WORMSbase.size[0],$
                   YOFFSET   = WORMSbase.size[1],$
                   SCR_XSIZE = WORMSbase.size[2],$
                   SCR_YSIZE = WORMSbase.size[3])

group = CW_BGROUP(base,$
                  WORMSbase.button.list,$
                  UNAME      = WORMSbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write Out Combined Pixel Spectrum After Monitor Normalization\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
NA_base = WIDGET_BASE(tab7_base,$
                      UNAME     = NA_WOCPSAMNbase.uname,$
                      XOFFSET   = NA_WOCPSAMNbase.size[0],$
                      YOFFSET   = NA_WOCPSAMNbase.size[1],$
                      SCR_XSIZE = NA_WOCPSAMNbase.size[2],$
                      SCR_YSIZE = NA_WOCPSAMNbase.size[3],$
                      MAP       = 0,$
                      ROW       = 1)

NA_label = WIDGET_LABEL(NA_base,$
                        VALUE = NA_WOCPSAMNbase.value)

base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WOCPSAMNbase.size[0],$
                   YOFFSET   = WOCPSAMNbase.size[1],$
                   SCR_XSIZE = WOCPSAMNbase.size[2],$
                   SCR_YSIZE = WOCPSAMNbase.size[3])

group = CW_BGROUP(base,$
                  WOCPSAMNbase.button.list,$
                  UNAME      = WOCPSAMNbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

;\\\\\\\\\\\\\\\\\\\\\\\\\\
;Wavelength Histogram Axis\
;\\\\\\\\\\\\\\\\\\\\\\\\\\
base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WHAbase.size[0],$
                   YOFFSET   = WHAbase.size[1],$
                   SCR_XSIZE = WHAbase.size[2],$
                   SCR_YSIZE = WHAbase.size[3])

label = WIDGET_LABEL(base,$
                     XOFFSET   = WHAlabel.size[0],$
                     YOFFSET   = WHAlabel.size[1],$
                     VALUE     = WHAlabel.value,$
                     UNAME     = WHAlabel.uname,$
                     SENSITIVE = 0)

label1 = WIDGET_LABEL(base,$
                      XOFFSET   = WHAlabel1.size[0],$
                      YOFFSET   = WHAlabel1.size[1],$
                      SENSITIVE = 0,$
                      UNAME     = WHAlabel1.uname,$
                      VALUE     = WHAlabel1.value)

text1 = WIDGET_TEXT(base,$
                    XOFFSET   = WHAtext1.size[0],$
                    YOFFSET   = WHAtext1.size[1],$
                    SCR_XSIZE = WHAtext1.size[2],$
                    SCR_YSIZE = WHAtext1.size[3],$
                    UNAME     = WHAtext1.uname,$
                    SENSITIVE = 0,$
                    /EDITABLE,$
                    /ALL_EVENTS,$
                    /ALIGN_LEFT)
                    
label2 = WIDGET_LABEL(base,$
                      XOFFSET   = WHAlabel2.size[0],$
                      YOFFSET   = WHAlabel2.size[1],$
                      UNAME     = WHAlabel2.uname,$
                      SENSITIVE = 0,$
                      VALUE     = WHAlabel2.value)

text2 = WIDGET_TEXT(base,$
                    XOFFSET   = WHAtext2.size[0],$
                    YOFFSET   = WHAtext2.size[1],$
                    SCR_XSIZE = WHAtext2.size[2],$
                    SCR_YSIZE = WHAtext2.size[3],$
                    UNAME     = WHAtext2.uname,$
                    SENSITIVE = 0,$
                    /EDITABLE,$
                    /ALL_EVENTS,$
                    /ALIGN_LEFT)

label3 = WIDGET_LABEL(base,$
                      XOFFSET   = WHAlabel3.size[0],$
                      YOFFSET   = WHAlabel3.size[1],$
                      SENSITIVE = 0,$
                      UNAME     = WHAlabel3.uname,$
                      VALUE     = WHAlabel3.value)

text3 = WIDGET_TEXT(base,$
                    XOFFSET   = WHAtext3.size[0],$
                    YOFFSET   = WHAtext3.size[1],$
                    SCR_XSIZE = WHAtext3.size[2],$
                    SCR_YSIZE = WHAtext3.size[3],$
                    UNAME     = WHAtext3.uname,$
                    SENSITIVE = 0,$
                    /EDITABLE,$
                    /ALL_EVENTS,$
                    /ALIGN_LEFT)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write Out Linearly Interpolated Direct Scattering Background\
;Info. Summed over all Pixel                                 \
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
NA_base = WIDGET_BASE(tab7_base,$
                      UNAME     = NA_WOLIDSBbase.uname,$
                      XOFFSET   = NA_WOLIDSBbase.size[0],$
                      YOFFSET   = NA_WOLIDSBbase.size[1],$
                      SCR_XSIZE = NA_WOLIDSBbase.size[2],$
                      SCR_YSIZE = NA_WOLIDSBbase.size[3],$
                      MAP       = 0,$
                      ROW       = 1)

NA_label = WIDGET_LABEL(NA_base,$
                        VALUE = NA_WOLIDSBbase.value)

base = WIDGET_BASE(tab7_base,$
                   XOFFSET   = WOLIDSBbase.size[0],$
                   YOFFSET   = WOLIDSBbase.size[1],$
                   SCR_XSIZE = WOLIDSBbase.size[2],$
                   SCR_YSIZE = WOLIDSBbase.size[3])

group = CW_BGROUP(base,$
                  WOLIDSBbase.button.list,$
                  UNAME      = WOLIDSBbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

END
