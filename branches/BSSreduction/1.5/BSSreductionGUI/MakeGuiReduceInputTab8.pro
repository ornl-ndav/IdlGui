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

PRO MakeGuiReduceInputTab8, ReduceInputTab, ReduceInputTabSettings

  ;******************************************************************************
  ;                           Define size arrays
  ;******************************************************************************

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
    value : 'Calculated Time-Independent Background - NOT ' + $
    'AVAILABLE',$
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
    list : [' Write Out Rebinned Monitor' + $
    ' Spectra (WARNING:' + $
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
    list : [' Write Out Combined Pixel ' + $
    'Spectrum After Monitor Normalization']}}
    
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
    list : [' Write Out Linearly Interpolated ' + $
    'Direct' + $
    ' Scattering Background Information ' + $
    'Summed' + $
    ' over all Pixels']}}
    
  NA_WOLIDSBbase = { size : [WOLIDSBbase.size[0]+5,$
    WOLIDSBbase.size[1]-5,$
    WOLIDSBbase.size[2:3]],$
    value : 'Linearly Interpolated Direct Scatt. Back. ' + $
    'Information Summed over all Pixels - NOT AVAILABLE',$
    uname : 'na_wolidsbbase'}
    
  ;/////////////////////////////////////////////////////////////
  ;Pixel Wavelength Spectra After Vanadium Normalization -------
  ;/////////////////////////////////////////////////////////////
  yoff = 50
  sPWSAVNbase = { size  : [wOLIDSBbase.size[0], $
    wOLIDSBbase.size[1]+yoff, $
    WOLIDSBbase.size[2:3]],$
    button : { uname : 'pwsavn_button',$
    list : [' Write Out Pixel Wavelength Spectra' + $
    ' after Vanadium Normalization ' + $
    '(WARNING: ' + $
    'VERGY LARGE FILE AND SLOW)']}}
    
  sNA_PWSAVNbase = { size : [sPWSAVNbase.size[0]+5,$
    sPWSAVNbase.size[1]-5,$
    sPWSAVNbase.size[2:3]],$
    value : 'Pixel Wavelength Spectra after Vanadium' + $
    ' Normalization - NOT AVAILABLE',$
    uname : 'na_pwsavnbase'}
    
  ;///////////////////////////////////////////////
  ;Solid Angle Distribution from S(Q,E) Rebinning/
  ;///////////////////////////////////////////////
  yoff = 50
  sSAD = { size  : [sPWSAVNbase.size[0], $
    sPWSAVNbase.size[1]+yoff, $
    sPWSAVNbase.size[2:3]],$
    button : { uname : 'sad',$
    list : [' Write Out Solid Angle Distribution from S(Q,E) Rebinning.']}}
    
  sNA_SAD = { size: [sSAD.size[0]+5,$
    sSAD.size[1]-5,$
    sSAD.size[2:3]],$
    value : 'Solid Angle Distribution from S(Q,E) Rebinning. ' + $
    '- NOT AVAILABLE',$
    uname : 'na_sad'}
    
  ;******************************************************************************
  ;                                Build GUI
  ;******************************************************************************
  tab7_base = WIDGET_BASE(ReduceInputTab,$
    XOFFSET   = ReduceInputTabSettings.size[0],$
    YOFFSET   = ReduceInputTabSettings.size[1],$
    SCR_XSIZE = ReduceInputTabSettings.size[2],$
    SCR_YSIZE = ReduceInputTabSettings.size[3],$
    UNAME     = 'reduce_tab8_base',$
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
    
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Pixel Wavelength Spectra After Vanadium Normalization -------
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  NA_base = WIDGET_BASE(tab7_base,$
    UNAME     = sNA_PWSAVNbase.uname,$
    XOFFSET   = sNA_PWSAVNbase.size[0],$
    YOFFSET   = sNA_PWSAVNbase.size[1],$
    SCR_XSIZE = sNA_PWSAVNbase.size[2],$
    SCR_YSIZE = sNA_PWSAVNbase.size[3],$
    MAP       = 0,$
    ROW       = 1)
    
  NA_label = WIDGET_LABEL(NA_base,$
    VALUE = sNA_PWSAVNbase.value)
    
  base = WIDGET_BASE(tab7_base,$
    XOFFSET   = sPWSAVNbase.size[0],$
    YOFFSET   = sPWSAVNbase.size[1],$
    SCR_XSIZE = sPWSAVNbase.size[2],$
    SCR_YSIZE = sPWSAVNbase.size[3])
    
  group = CW_BGROUP(base,$
    sPWSAVNbase.button.list,$
    UNAME      = sPWSAVNbase.button.uname,$
    /NONEXCLUSIVE,$
    SET_VALUE  = 0,$
    ROW        = 1)

  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ;Solid Angle Distribution from S(Q,E) Rebinning --------------
  ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  NA_base = WIDGET_BASE(tab7_base,$
    UNAME     = sNA_SAD.uname,$
    XOFFSET   = sNA_SAD.size[0],$
    YOFFSET   = sNA_SAD.size[1],$
    SCR_XSIZE = sNA_SAD.size[2],$
    SCR_YSIZE = sNA_SAD.size[3],$
    MAP       = 0,$
    ROW       = 1)
    
  NA_label = WIDGET_LABEL(NA_base,$
    VALUE = sNA_SAD.value)
    
  base = WIDGET_BASE(tab7_base,$
    XOFFSET   = sSAD.size[0],$
    YOFFSET   = sSAD.size[1],$
    SCR_XSIZE = sSAD.size[2],$
    SCR_YSIZE = sSAD.size[3])
    
  group = CW_BGROUP(base,$
    sSAD.button.list,$
    UNAME      = sSAD.button.uname,$
    /NONEXCLUSIVE,$
    SET_VALUE  = 0,$
    ROW        = 1)

END
