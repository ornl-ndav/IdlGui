PRO MakeGuiSelectionOutputCountsVsTof, SelectionBase

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************
base  = { size : [300,200,600,415]}
label = { size : [105,5],$
          title : 'O U T P U T    C O U N T S    V S    T O F    A S C I I    F I L E'}
frame = { size : [0,25,600,1]}

file_label  = { size : [5,40],$
                value : 'File Name:'}
file_text   = { size : [70,33,525,31],$
                uname : 'output_counts_vs_tof_file_name_text'}
file_button = { size : [5,70,590,31],$
                uname : 'output_counts_vs_tof_path_button',$
                value : '~/local'}

message_label = { size : [5,115],$
                  value : 'Message to add:'}
message_text  = { size : [100,107,495,31],$
                  uname : 'output_couts_vs_tof_message_text'}

preview_label = { size : [260,140],$
                  value : 'P R E V I E W'}
preview_text  = { size : [5,158,590,220],$
                  uname : 'output_couts_vs_tof_preview_text'}

cancel_button = { size : [388,380,100,30],$
                  value : 'CANCEL',$
                  uname : 'output_couts_vs_tof_cancel_button'}
xoff = 5
ok_button     = { size : [cancel_button.size[0]+cancel_button.size[2]+xoff, $
                          cancel_button.size[1], $
                          100,30],$
                  value : 'OK',$
                  uname : 'output_couts_vs_tof_ok_button'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
base = WIDGET_BASE(SelectionBase,$
                   XOFFSET   = base.size[0],$
                   YOFFSET   = base.size[1],$
                   SCR_XSIZE = base.size[2],$
                   SCR_YSIZE = base.size[3],$
                   FRAME     = 2)

;title and bar
label = WIDGET_LABEL(base,$
                     XOFFSET = label.size[0],$
                     YOFFSET = label.size[1],$
                     VALUE   = label.title)

frame = WIDGET_LABEL(base,$
                     XOFFSET   = frame.size[0],$
                     YOFFSET   = frame.size[1],$
                     SCR_XSIZE = frame.size[2],$
                     SCR_YSIZE = frame.size[3],$
                     FRAME     = 1,$
                     VALUE     = '')

;file label/text/button
label = WIDGET_LABEL(base,$
                     XOFFSET = file_label.size[0],$
                     YOFFSET = file_label.size[1],$
                     VALUE   = file_label.value)

text = WIDGET_TEXT(base,$
                   XOFFSET   = file_text.size[0],$
                   YOFFSET   = file_text.size[1],$
                   SCR_XSIZE = file_text.size[2],$
                   SCR_YSIZE = file_text.size[3],$
                   UNAME     = file_text.uname,$
                   /ALIGN_LEFT,$
                   /EDITABLE)

button = WIDGET_BUTTON(base,$
                       XOFFSET   = file_button.size[0],$
                       YOFFSET   = file_button.size[1],$
                       SCR_XSIZE = file_button.size[2],$
                       SCR_YSIZE = file_button.size[3],$
                       UNAME     = file_button.uname,$
                       VALUE     = file_button.value)

;message to add lable/text
label = WIDGET_LABEL(base,$
                     XOFFSET = message_label.size[0],$
                     YOFFSET = message_label.size[1],$
                     VALUE   = message_label.value)

text = WIDGET_TEXT(base,$
                   XOFFSET   = message_text.size[0],$
                   YOFFSET   = message_text.size[1],$
                   SCR_XSIZE = message_text.size[2],$
                   SCR_YSIZE = message_text.size[3],$
                   UNAME     = message_text.uname,$
                   /ALIGN_LEFT,$
                   /EDITABLE)

;preview label/text
label = WIDGET_LABEL(base,$
                     XOFFSET = preview_label.size[0],$
                     YOFFSET = preview_label.size[1],$
                     VALUE   = preview_label.value)

text = WIDGET_TEXT(base,$
                   XOFFSET   = preview_text.size[0],$
                   YOFFSET   = preview_text.size[1],$
                   SCR_XSIZE = preview_text.size[2],$
                   SCR_YSIZE = preview_text.size[3],$
                   UNAME     = preview_text.uname,$
                   /ALIGN_LEFT,$
                   /EDITABLE)

;cancel/ok buttons
button1 = WIDGET_BUTTON(base,$
                        XOFFSET   = cancel_button.size[0],$
                        YOFFSET   = cancel_button.size[1],$
                        SCR_XSIZE = cancel_button.size[2],$
                        SCR_YSIZE = cancel_button.size[3],$
                        UNAME     = cancel_button.uname,$
                        VALUE     = cancel_button.value)

button1 = WIDGET_BUTTON(base,$
                        XOFFSET   = ok_button.size[0],$
                        YOFFSET   = ok_button.size[1],$
                        SCR_XSIZE = ok_button.size[2],$
                        SCR_YSIZE = ok_button.size[3],$
                        UNAME     = ok_button.uname,$
                        VALUE     = ok_button.value)                     

END
