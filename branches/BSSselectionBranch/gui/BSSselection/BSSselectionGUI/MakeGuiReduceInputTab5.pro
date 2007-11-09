PRO MakeGuiReduceInputTab5, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;//////////////////////////////
;Write all intermediate output/
;//////////////////////////////
WAIOBase = { size  : [15,10,500,35],$
             button : { uname : 'waio_button',$
                        list : [' Write All Intermediate Output (WARNING: VERGY LARGE FILES AND SLOW)']}}

;/////////////////////////////////////////////////
;Write out Calculated time-independent background/
;/////////////////////////////////////////////////
yoff = 35
WOCTIBbase = { size  : [WAIOBase.size[0], $
                        WAIOBase.size[1]+yoff, $
                        WAIOBase.size[2:3]],$
               button : { uname : 'woctib_button',$
                          list : [' Write Out Calculated Time-Independent Background']}}

;///////////////////////////////////
;Write Out Pixel Wavelength Spectra/
;///////////////////////////////////
WOPWSbase = { size  : [WOCTIBbase.size[0], $
                       WOCTIBbase.size[1]+yoff, $
                       WOCTIBbase.size[2:3]],$
              button : { uname : 'wopws_button',$
                         list : [' Write Out Pixel Wavelength Spectra (WARNING: VERGY LARGE FILE AND SLOW)']}}

;//////////////////////////////////////
;Write Out Monitor Wavelength Spectrum/
;//////////////////////////////////////
WOMWSbase = { size  : [WOPWSbase.size[0], $
                       WOPWSbase.size[1]+yoff, $
                       WOPWSbase.size[2:3]],$
              button : { uname : 'womws_button',$
                         list : [' Write Out Monitor Wavelenth Spectrum']}}

;//////////////////////////////////////
;Write Out Monitor Efficiency Spectrum/
;//////////////////////////////////////
WOMESbase = { size  : [WOMWSbase.size[0], $
                       WOMWSbase.size[1]+yoff, $
                       WOMWSbase.size[2:3]],$
              button : { uname : 'womes_button',$
                         list : [' Write Out Monitor Efficiency Spectrum']}}

;///////////////////////////////////
;Write Out Rebinned Monitor Spectra/
;///////////////////////////////////
WORMSbase = { size  : [WOMESbase.size[0], $
                       WOMESbase.size[1]+yoff, $
                       WOMESbase.size[2:3]],$
              button : { uname : 'worms_button',$
                         list : [' Write Out Rebinned Monitor Spectra (WARNING: VERY LARGE FILE AND SLOW)']}}

;//////////////////////////////////////////////////////////////
;Write Out Combined Pixel Spectrum After Monitor Normalization/
;//////////////////////////////////////////////////////////////
WOCPSAMNbase = { size  : [WORMSbase.size[0], $
                          WORMSbase.size[1]+yoff, $
                          WORMSbase.size[2:3]],$
              button : { uname : 'wocpsamn_button',$
                         list : [' Write Out Combined Pixel Spectrum After Monitor Normalization']}}

;///////////////////////////////////////
;Write Out Pixel Initial Energy Spectra/
;///////////////////////////////////////
WOPIESbase = { size  : [WOCPSAMNbase.size[0], $
                        WOCPSAMNbase.size[1]+yoff, $
                        WOCPSAMNbase.size[2:3]],$
              button : { uname : 'wopies_button',$
                         list : [' Write Out Pixel Initial Energy Spectra (WARNING: VERY LARGE FILE AND SLOW)']}}

;////////////////////////////////////////
;Write Out Pixel Energy Transfer Spectra/
;////////////////////////////////////////
WOPETSbase = { size  : [WOPIESbase.size[0], $
                        WOPIESbase.size[1]+yoff, $
                        WOPIESbase.size[2:3]],$
              button : { uname : 'wopets_button',$
                         list : [' Write Out Pixel Energy Transfer Spectra (WARNING: VERY LARGE FILE AND SLOW)']}}
;***********************************************************************************
;                                Build GUI
;***********************************************************************************
tab5_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[4])

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write all intermediate output\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
base = WIDGET_BASE(tab5_base,$
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
base = WIDGET_BASE(tab5_base,$
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
base = WIDGET_BASE(tab5_base,$
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
base = WIDGET_BASE(tab5_base,$
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
base = WIDGET_BASE(tab5_base,$
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
base = WIDGET_BASE(tab5_base,$
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
base = WIDGET_BASE(tab5_base,$
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

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write Out Pixel Initial Energy Spectra\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
base = WIDGET_BASE(tab5_base,$
                   XOFFSET   = WOPIESbase.size[0],$
                   YOFFSET   = WOPIESbase.size[1],$
                   SCR_XSIZE = WOPIESbase.size[2],$
                   SCR_YSIZE = WOPIESbase.size[3])

group = CW_BGROUP(base,$
                  WOPIESbase.button.list,$
                  UNAME      = WOPIESbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)

;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;Write Out Pixel Energy Transfer Spectra\
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
base = WIDGET_BASE(tab5_base,$
                   XOFFSET   = WOPETSbase.size[0],$
                   YOFFSET   = WOPETSbase.size[1],$
                   SCR_XSIZE = WOPETSbase.size[2],$
                   SCR_YSIZE = WOPETSbase.size[3])

group = CW_BGROUP(base,$
                  WOPETSbase.button.list,$
                  UNAME      = WOPETSbase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1)


END
