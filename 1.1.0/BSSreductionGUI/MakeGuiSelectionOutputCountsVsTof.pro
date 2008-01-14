PRO MakeGuiSelectionOutputCountsVsTof, SelectionBase, MainBase

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************
base  = { size : [80,130,600,415],$
          uname : 'output_couts_vs_tof_base'}
label = { size : [70,5],$
          title : '--------- OUTPUT  COUNTS  VS  TOF  OF  SELECTION  INTO  ASCII  FILE ---------'}
frame = { size : [0,25,600,1]}

file_label  = { size : [5,40],$
                value : 'File Name:'}
file_text   = { size : [70,33,525,31],$
                uname : 'output_counts_vs_tof_file_name_text'}
file_button = { size : [5,70,590,31],$
                uname : 'output_counts_vs_tof_path_button',$
                value : '~/local'}

message_base  = { size : [3,107,592,35]}
message_text  = { size : [79],$
                  uname : 'output_counts_vs_tof_message_text',$
                  title : 'Message to add:'}

preview_label = { size : [260,140],$
                  value : 'P R E V I E W'}
preview_text  = { size : [5,158,590,220],$
                  uname : 'output_counts_vs_tof_preview_text'}

cancel_button = { size : [388,380,100,30],$
                  value : 'CANCEL',$
                  uname : 'output_counts_vs_tof_cancel_button'}
xoff = 5
ok_button     = { size : [cancel_button.size[0]+cancel_button.size[2]+xoff, $
                          cancel_button.size[1], $
                          100,30],$
                  value : 'OK',$
                  uname : 'output_counts_vs_tof_ok_button'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
output_base = WIDGET_BASE(SelectionBase,$
                          XOFFSET   = base.size[0],$
                          YOFFSET   = base.size[1],$
                          SCR_XSIZE = base.size[2],$
                          SCR_YSIZE = base.size[3],$
                          FRAME     = 2,$
                          UNAME     = base.uname,$
                          MAP       = 0)

;title and bar
label = WIDGET_LABEL(output_base,$
                     XOFFSET = label.size[0],$
                     YOFFSET = label.size[1],$
                     VALUE   = label.title)

frame = WIDGET_LABEL(output_base,$
                     XOFFSET   = frame.size[0],$
                     YOFFSET   = frame.size[1],$
                     SCR_XSIZE = frame.size[2],$
                     SCR_YSIZE = frame.size[3],$
                     FRAME     = 1,$
                     VALUE     = '')

;file label/text/button
label = WIDGET_LABEL(output_base,$
                     XOFFSET = file_label.size[0],$
                     YOFFSET = file_label.size[1],$
                     VALUE   = file_label.value)

text = WIDGET_TEXT(output_base,$
                   XOFFSET   = file_text.size[0],$
                   YOFFSET   = file_text.size[1],$
                   SCR_XSIZE = file_text.size[2],$
                   SCR_YSIZE = file_text.size[3],$
                   UNAME     = file_text.uname,$
                   /ALIGN_LEFT,$
                   /EDITABLE)

button = WIDGET_BUTTON(output_base,$
                       XOFFSET   = file_button.size[0],$
                       YOFFSET   = file_button.size[1],$
                       SCR_XSIZE = file_button.size[2],$
                       SCR_YSIZE = file_button.size[3],$
                       UNAME     = file_button.uname,$
                       VALUE     = file_button.value)

;message to add lable/text
message_base = WIDGET_BASE(output_base,$
                           XOFFSET   = message_base.size[0],$
                           YOFFSET   = message_base.size[1],$
                           SCR_XSIZE = message_base.size[2],$
                           SCR_YSIZE = message_base.size[3])

cw_field = CW_FIELD(message_base,$
                    UNAME         = message_text.uname,$
                    TITLE         = message_text.title,$
                    RETURN_EVENTS = 1,$
                    ROW           = 1,$
                    XSIZE         = message_text.size[0])

;preview label/text
label = WIDGET_LABEL(output_base,$
                     XOFFSET = preview_label.size[0],$
                     YOFFSET = preview_label.size[1],$
                     VALUE   = preview_label.value)

text = WIDGET_TEXT(output_base,$
                   XOFFSET   = preview_text.size[0],$
                   YOFFSET   = preview_text.size[1],$
                   SCR_XSIZE = preview_text.size[2],$
                   SCR_YSIZE = preview_text.size[3],$
                   UNAME     = preview_text.uname,$
                   /ALIGN_LEFT,$
                   /WRAP,$
                   /SCROLL)

;cancel/ok buttons
button1 = WIDGET_BUTTON(output_base,$
                        XOFFSET   = cancel_button.size[0],$
                        YOFFSET   = cancel_button.size[1],$
                        SCR_XSIZE = cancel_button.size[2],$
                        SCR_YSIZE = cancel_button.size[3],$
                        UNAME     = cancel_button.uname,$
                        VALUE     = cancel_button.value)

button1 = WIDGET_BUTTON(output_base,$
                        XOFFSET   = ok_button.size[0],$
                        YOFFSET   = ok_button.size[1],$
                        SCR_XSIZE = ok_button.size[2],$
                        SCR_YSIZE = ok_button.size[3],$
                        UNAME     = ok_button.uname,$
                        VALUE     = ok_button.value)                     

END
