PRO MakeGuiReduceInputTab2, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;/////////////////////////
;Requested Detector Banks/
;/////////////////////////
RDBbase = { size  : [5,25,500,40],$
            value : '  Requested Detector Banks:   ',$
            banks : { size : [5,0,100,35],$
                      uname : 'rdbbase_bank_button',$
                      value : 'Bank 1'},$
            list : ['Bank 1 ','Bank 2 ']}

;//////////////////////
;Run McStas NeXus file/
;//////////////////////
yoff = 50             
RMcNFBase = { size : [RDBbase.size[0],$
                      RDBbase.size[1]+yoff,$
                      200,$
                      RDBbase.size[3]],$
              button : { uname : 'rmcnf_button',$
                         value : '',$
                         list : ['Run McStas NeXus Files']}}

;////////
;Verbose/
;////////
VerboseBase = { size : [RDBbase.size[0],$
                        RMcNFbase.size[1]+yoff,$
                        200,$
                        RDBbase.size[3]],$
                button : { uname : 'verbose_button',$
                           value : RMcNFbase.button.value,$
                           list : ['Verbose']}}

;////////////////////////////////////////
;Alternate Background Subtraction Method/
;////////////////////////////////////////
ABSMBase = { size : [Verbosebase.size[0],$
                     Verbosebase.size[1]+yoff,$
                     400,$
                     Verbosebase.size[3]],$
             button : { uname : 'absm_button',$
                        value : RMcNFbase.button.value,$
                        list : ['Alternate Background Subtraction Method']}}

;/////////////////////////
;No Monitor Normalization/
;/////////////////////////
NMNBase = { size : [ABSMbase.size[0],$
                    ABSMbase.size[1]+yoff,$
                    400,$
                    ABSMbase.size[3]],$
             button : { uname : 'nmn_button',$
                        value : RMcNFbase.button.value,$
                        list : ['No Monitor Normalization']}}

;/////////////////////////////////
;No Monitor Efficiency Correction/
;/////////////////////////////////
NMECBase = { size : [NMNbase.size[0],$
                     NMNbase.size[1]+yoff,$
                     400,$
                     NMNbase.size[3]],$
             button : { uname : 'nmec_button',$
                        value : RMcNFbase.button.value,$
                        list : ['No Monitor Efficiency Correction']}}

;///////////////////////////////////////////
;Normalization Integration Start Wavelength/
;///////////////////////////////////////////
NISWBase = { size : [NMECBase.size[0],$
                     NMECBase.size[1]+yoff+3,$
                     500,$
                     NMECBase.size[3]],$
             field : { xsize : 10,$
                       value : '   Normalization Integration Start Wavelength :',$
                       uname : 'nisw_field'},$
             label : { size : [375,10],$
                        value : 'Angstroms'}}


;///////////////////////////////////////////
;Normalization Integration END Wavelength/
;///////////////////////////////////////////
NIEWBase = { size : [NISWBase.size[0],$
                     NISWBase.size[1]+yoff+3,$
                     500,$
                     NISWBase.size[3]],$
             field : { xsize : 10,$
                       value : '   Normalization Integration END Wavelength   :',$
                       uname : 'nisE_field'},$
             label : { size : [NISWBase.label.size[0],$
                              NISWBase.label.size[1]],$
                        value : 'Angstroms'}}



;***********************************************************************************
;                                Build GUI
;***********************************************************************************
tab2_base = WIDGET_BASE(ReduceInputTab,$
                        XOFFSET   = ReduceInputTabSettings.size[0],$
                        YOFFSET   = ReduceInputTabSettings.size[1],$
                        SCR_XSIZE = ReduceInputTabSettings.size[2],$
                        SCR_YSIZE = ReduceInputTabSettings.size[3],$
                        TITLE     = ReduceInputTabSettings.title[1])

;\\\\\\\\\\\\\\\\\\\\\\\\\
;Requested Detector Banks\
;\\\\\\\\\\\\\\\\\\\\\\\\\
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = RDBbase.size[0],$
                   YOFFSET   = RDBbase.size[1],$
                   SCR_XSIZE = RDBbase.size[2],$
                   SCR_YSIZE = RDBbase.size[3])

banks = CW_BGROUP(base,$
                  XOFFSET = RDBbase.banks.size[0],$
                  RDBbase.list,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  =[1,1],$
                  ROW        = 1,$
                  LABEL_LEFT = RDBbase.value,$
                  UNAME = RDBbase.banks.uname)

;//////////////////////
;Run McStas NeXus file/
;//////////////////////
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = RMcNFBase.size[0],$
                   YOFFSET   = RMcNFBase.size[1],$
                   SCR_XSIZE = RMcNFBase.size[2],$
                   SCR_YSIZE = RMcNFBase.size[3])

group = CW_BGROUP(base,$
                  RMCNFBASE.button.list,$
                  UNAME      = RMcNFBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = RMcNFBase.button.value)
                  
;////////
;Verbose/
;////////
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = VerboseBase.size[0],$
                   YOFFSET   = VerboseBase.size[1],$
                   SCR_XSIZE = VerboseBase.size[2],$
                   SCR_YSIZE = VerboseBase.size[3])

group = CW_BGROUP(base,$
                  VerboseBASE.button.list,$
                  UNAME      = VerboseBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = VerboseBase.button.value)
                  

;////////////////////////////////////////
;Alternate Background Subtraction Method/
;////////////////////////////////////////
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = ABSMBase.size[0],$
                   YOFFSET   = ABSMBase.size[1],$
                   SCR_XSIZE = ABSMBase.size[2],$
                   SCR_YSIZE = ABSMBase.size[3])

group = CW_BGROUP(base,$
                  ABSMBASE.button.list,$
                  UNAME      = ABSMBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = ABSMBase.button.value)
                  
;/////////////////////////
;No Monitor Normalization/
;/////////////////////////
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = NMNBase.size[0],$
                   YOFFSET   = NMNBase.size[1],$
                   SCR_XSIZE = NMNBase.size[2],$
                   SCR_YSIZE = NMNBase.size[3])

group = CW_BGROUP(base,$
                  NMNBASE.button.list,$
                  UNAME      = NMNBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = NMNBase.button.value)

;/////////////////////////////////
;No Monitor Efficiency Correction/
;/////////////////////////////////
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = NMECBase.size[0],$
                   YOFFSET   = NMECBase.size[1],$
                   SCR_XSIZE = NMECBase.size[2],$
                   SCR_YSIZE = NMECBase.size[3])

group = CW_BGROUP(base,$
                  NMECBASE.button.list,$
                  UNAME      = NMECBase.button.uname,$
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = NMECBase.button.value)

;///////////////////////////////////////////
;Normalization Integration Start Wavelength/
;///////////////////////////////////////////
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = NISWBase.size[0],$
                   YOFFSET   = NISWBase.size[1],$
                   SCR_XSIZE = NISWBase.size[2],$
                   SCR_YSIZE = NISWBase.size[3])

label = WIDGET_LABEL(base,$
                     XOFFSET = NISWBase.label.size[0],$
                     YOFFSET = NISWBase.label.size[1],$
                     VALUE   = NISWBase.label.value)

text = CW_FIELD(base,$
                UNAME         = NISWBase.field.uname,$
                RETURN_EVENTS = 1,$
                TITLE         = NISWBase.field.value,$
                ROW           = 1,$
                XSIZE         = NISWBase.field.xsize,$
                /FLOAT)



;///////////////////////////////////////////
;Normalization Integration END Wavelength/
;///////////////////////////////////////////
base = WIDGET_BASE(tab2_base,$
                   XOFFSET   = NIEWBase.size[0],$
                   YOFFSET   = NIEWBase.size[1],$
                   SCR_XSIZE = NIEWBase.size[2],$
                   SCR_YSIZE = NIEWBase.size[3])

label = WIDGET_LABEL(base,$
                     XOFFSET = NIEWBase.label.size[0],$
                     YOFFSET = NIEWBase.label.size[1],$
                     VALUE   = NIEWBase.label.value)

text = CW_FIELD(base,$
                UNAME         = NIEWBase.field.uname,$
                RETURN_EVENTS = 1,$
                TITLE         = NIEWBase.field.value,$
                ROW           = 1,$
                XSIZE         = NIEWBase.field.xsize,$
                /FLOAT)


END
