PRO MakeGuiReduceInputTab, ReduceBase, ReduceInputTabSettings

ReduceInputTab = WIDGET_TAB(ReduceBase,$
                            UNAME     = 'reduce_input_tab',$
                            LOCATION  = 0,$
                            XOFFSET   = ReduceInputTabSettings.Size[0],$
                            YOFFSET   = ReduceInputTabSettings.Size[1],$
                            SCR_XSIZE = ReduceInputTabSettings.Size[2],$
                            SCR_YSIZE = ReduceInputTabSettings.Size[3])


;Make Tab1 (input data (1))
MakeGuiReduceInputTab1, ReduceInputTab, ReduceInputTabSettings

;Make Tab2 (input data (2))
MakeGuiReduceInputTab2, ReduceInputTab, ReduceInputTabSettings

;Make Tab3 (Process Setup)
MakeGuiReduceInputTab3, ReduceInputTab, ReduceInputTabSettings

;Make Tab4 (Time-independent Back.)
MakeGuiReduceInputTab4, ReduceInputTab, ReduceInputTabSettings

;Make Tab5 (Lambda-Dependent Background)
MakeGuiReduceInputTab5, ReduceInputTab, ReduceInputTabSettings

;Make Tab6 (Scalling constant)
MakeGuiReduceInputTab6, ReduceInputTab, ReduceInputTabSettings

;Make Tab7 (Data Control)
MakeGuiReduceInputTab7, ReduceInputTab, ReduceInputTabSettings

;Make Tab8 (Intermediate Output)
MakeGuiReduceInputTab8, ReduceInputTab, ReduceInputTabSettings
END
