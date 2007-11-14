PRO MakeGuiReduceTab, MAIN_TAB, MainTabSize

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************
ReduceBaseTitle      = 'REDUCE'

ReduceInputTabSettings       = {size : [0, $
                                        0, $
                                        750, $
                                        575],$
                                title : ['Input Data (1)', $
                                         'Process Setup', $
                                         'Time-Independent Back.', $ 
                                         'Data Control', $
                                         'Intermediate Output',$
                                         'Input Data (2)',$
                                        'Scalling Constant'], $
                                tab1 : {size : [0, $
                                                0, $
                                                750, $
                                                575]}}
xoff = 5
yoff = 48
ReduceClgXmlTabSettings = {Size : [ReduceInputTabSettings.Size[0]+$
                                   ReduceInputTabSettings.Size[2]+xoff, $
                                   ReduceInputTabSettings.Size[1], $
                                   440, $
                                   ReduceInputTabSettings.size[3]+yoff],$
                           title : ['Command Line Generator Status', $
                                    'XML Reduce File']}

yoff = 5
SubmitButton = {Size : [0, $
                        ReduceInputTabSettings.size[1]+$
                        ReduceInputTabSettings.size[3]+yoff, $
                        400, $
                        45], $
                sensitive : 0,$
                title : 'START DATA REDUCTION', $
                uname : 'submit_button'}

xoff  = 5
xoff1 = 10
yoff  = -7
yoff1 = 10
status = {frame : {size : [SubmitButton.size[0] +$
                           SubmitButton.size[2] + xoff, $
                           SubmitButton.size[1], $
                           340, $
                           40]}, $
          label : {size : [500, $
                           SubmitButton.size[1] + yoff],$
                   title : 'Data Reduction Status'}, $
          text : {size: [SubmitButton.size[0] +$
                         SubmitButton.size[2] + xoff1, $
                         SubmitButton.size[1] + yoff1, $
                         330, $
                         30]}}

yoff  = 10
xoff  = 498
yoff1 = 0 
clg = {text : {size : [0,$
                       SubmitButton.size[1]+$
                       SubmitButton.size[3] + yoff,$
                       ReduceInputTabSettings.size[2]+$
                       ReduceClgXmlTabSettings.size[2],$
                       63],$
               uname : 'command_line_generator_text'},$
       label : {size : [xoff,$
                        SubmitButton.size[1]+$
                        SubmitButton.size[3] + yoff1],$
                title : 'COMMAND LINE GENERATOR'}}

                        




;***********************************************************************************
;                                Build GUI
;***********************************************************************************
ReduceBase = WIDGET_BASE(MAIN_TAB,$
                         XOFFSET   = 0,$
                         YOFFSET   = 0,$
                         SCR_XSIZE = MainTabSize[2],$
                         SCR_YSIZE = MainTabSize[3],$
                         TITLE     = ReduceBaseTitle,$
                         UNAME     = 'reduce_base')

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
                       SENSITIVE = SubmitButton.sensitive,$
                       UNAME     = SubmitButton.uname)


;Data Reduction status
label = WIDGET_LABEL(ReduceBase,$
                     XOFFSET   = Status.label.size[0],$
                     YOFFSET   = Status.label.size[1],$
                     VALUE     = Status.label.title)
                     
text = WIDGET_TEXT(ReduceBase,$
                   XOFFSET   = Status.text.size[0],$
                   YOFFSET   = Status.text.size[1],$
                   SCR_XSIZE = Status.text.size[2],$
                   SCR_YSIZE = Status.text.size[3],$
                   /ALIGN_LEFT)

frame = WIDGET_LABEL(ReduceBase,$
                     XOFFSET   = Status.frame.size[0],$
                     YOFFSET   = Status.frame.size[1],$
                     SCR_XSIZE = Status.frame.size[2],$
                     SCR_YSIZE = Status.frame.size[3],$
                     FRAME     = 1,$
                     VALUE     = '')

;Command Line Generator
label = WIDGET_LABEL(ReduceBase,$
                     XOFFSET = clg.label.size[0],$
                     YOFFSET = clg.label.size[1],$
                     VALUE   = clg.label.title)

text = WIDGET_TEXT(ReduceBase,$
                   XOFFSET = clg.text.size[0],$
                   YOFFSET = clg.text.size[1],$
                   SCR_XSIZE = clg.text.size[2],$
                   SCR_YSIZE = clg.text.size[3],$
                   UNAME = clg.text.uname,$
                   /ALIGN_LEFT,$
                   /WRAP,$
                   /SCROLL)


END
