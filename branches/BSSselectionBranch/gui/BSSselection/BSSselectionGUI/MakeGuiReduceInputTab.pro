PRO MakeGuiReduceInputTab, ReduceBase, ReduceInputTabSettings

ReduceInputTab = WIDGET_TAB(ReduceBase,$
                            UNAME = 'reduce_input_tab',$
                            LOCATION = 0,$
                            XOFFSET = ReduceInputTabSettings.Size[0],$
                            YOFFSET = ReduceInputTabSettings.Size[1],$
                            SCR_XSIZE = ReduceInputTabSettings.Size[2],$
                            SCR_YSIZE = ReduceInputTabSettings.Size[3])


;Make Tab1
MakeGuiReduceInputTab1, ReduceInputTab, ReduceInputTabSettings

;Make Tab11
MakeGuiReduceInputTab11, ReduceInputTab, ReduceInputTabSettings

;Make Tab2
MakeGuiReduceInputTab2, ReduceInputTab, ReduceInputTabSettings

;Make Tab3
MakeGuiReduceInputTab3, ReduceInputTab, ReduceInputTabSettings

;Make Tab4
MakeGuiReduceInputTab4, ReduceInputTab, ReduceInputTabSettings

;Make Tab5
MakeGuiReduceInputTab5, ReduceInputTab, ReduceInputTabSettings
END
