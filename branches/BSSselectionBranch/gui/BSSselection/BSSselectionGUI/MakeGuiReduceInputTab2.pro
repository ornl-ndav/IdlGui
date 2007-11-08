PRO MakeGuiReduceInputTab2, ReduceInputTab, ReduceInputTabSettings

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

;/////////////////////////
;Requested Detector Banks/
;/////////////////////////
RDBbase = { size  : [5,10,500,40],$
            value : '-->    Requested Detector Banks:   ',$
            banks : { size : [5,0,100,35],$
                      uname : 'rdbbase_bank1_button',$
                      value : 'Bank 1'},$
            list : ['Bank 1 ','Bank 2 ']}
            
;//////////////////////
;Run McStas NeXus file/
;//////////////////////
yoff = 40
RMcNFBase = { size : [RDBbase.size[0],$
                      RDBbase.size[1]+yoff,$
                      200,$
                      RDBbase.size[3]],$
              button : { uname : 'rmcnf_button',$
                         value : ' --> ',$
                       list : ['Run McStas NeXus Files']}}
              

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
                  LABEL_LEFT = RDBbase.value )

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
                  /NONEXCLUSIVE,$
                  SET_VALUE  = 0,$
                  ROW        = 1,$
                  LABEL_LEFT = RMcNFBase.button.value)
                  




END
