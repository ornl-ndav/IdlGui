PRO MakeGuiReduceTab, MAIN_TAB, MainTabSize

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************
ReduceBaseTitle      = 'REDUCE'

ReduceInputTabSettings       = {size : [0, $
                                        0, $
                                        750, $
                                        500],$
                                title : [' Input Data Setup ', $
                                         ' Process Setup ', $
                                         ' Time-Independent Background ', $ 
                                         ' Data Control ', $
                                         ' Intermediate Output '], $
                                tab1 : {size : [0, $
                                                0, $
                                                750, $
                                                500]}}
xoff = 5
ReduceClgXmlTabSettings = {Size : [ReduceInputTabSettings.Size[0]+$
                                   ReduceInputTabSettings.Size[2]+xoff, $
                                   ReduceInputTabSettings.Size[1], $
                                   440, $
                                   550],$
                           title : ['Command Line Generator Status', $
                                    'XML Reduce File']}

yoff = 5
SubmitButton = {Size : [0, $
                        ReduceInputTabSettings.size[1]+$
                        ReduceInputTabSettings.size[3]+yoff, $
                        400, $
                        45], $
                title : 'START DATA REDUCTION', $
                uname : 'submit_button'}

xoff = 5
yoff = -7
status = {frame : {size : [SubmitButton.size[0] +$
                           SubmitButton.size[2] + xoff, $
                           SubmitButton.size[1], $
                           340, $
                           40]}, $
          label : {size : [500, $
                           SubmitButton.size[1] + yoff],$
                   title : 'Data Reduction Status'}}




;***********************************************************************************
;                                Build GUI
;***********************************************************************************
ReduceBase = WIDGET_BASE(MAIN_TAB,$
                         XOFFSET   = 0,$
                         YOFFSET   = 0,$
                         SCR_XSIZE = MainTabSize[2],$
                         SCR_YSIZE = MainTabSize[3],$
                         TITLE     = ReduceBaseTitle)

;tabs of 'input data setup', 'process setup' ....
MakeGuiReduceInputTab, ReduceBase, ReduceInputTabSettings

;tabs of 'CLG status' and 'XML reduce file'
MakeGuiReduceClgXmlTab, ReduceBase, ReduceClgXmlTabSettings

;Submit Button
button = WIDGET_BUTTON(ReduceBase,$
                       XOFFSET   = SubmitButton.size[0],$
                       YOFFSET   = SubmitButton.size[1],$
                       SCR_XSIZE = SubmitButton.size[2],$
                       SCR_YSIZE = SubmitButton.size[3],$
                       VALUE     = SubmitButton.title,$
                       UNAME     = SubmitButton.uname)


;Data Reduction status
label = WIDGET_LABEL(ReduceBase,$
                     XOFFSET   = Status.label.size[0],$
                     YOFFSET   = Status.label.size[1],$
                     VALUE     = Status.label.title)
                     
frame = WIDGET_LABEL(ReduceBase,$
                     XOFFSET   = Status.Frame.size[0],$
                     YOFFSET   = Status.Frame.size[1],$
                     SCR_XSIZE = Status.Frame.size[2],$
                     SCR_YSIZE = Status.Frame.size[3],$
                     FRAME     = 1,$
                     VALUE     = '')




END
