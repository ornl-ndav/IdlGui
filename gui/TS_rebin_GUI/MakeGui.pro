PRO MakeGui, MAIN_BASE

;main base (without ok or cancel buttons)
main = WIDGET_BASE(MAIN_BASE,$
                   COLUMN = 1,$
                   FRAME  = 1)

;Runs number, instrument, proposal number
first_base = WIDGET_BASE(main,$
                         ROW = 1,$
                         /BASE_ALIGN_CENTER)
label = WIDGET_LABEL(first_base,$
                     VALUE = 'Runs #:')

text  = WIDGET_TEXT(first_base,$
                    UNAME = 'runs',$
                    /EDITABLE,$
                    XSIZE = 20)

label = WIDGET_LABEL(first_base,$
                     VALUE = '  Instrument:')

text  = WIDGET_TEXT(first_base,$
                    UNAME = 'instrument',$
                    /EDITABLE,$
                    XSIZE = 5)

label = WIDGET_LABEL(first_base,$
                     VALUE = ' Proposal number:')

text = WIDGET_TEXT(first_base,$
                   UNAME = 'proposal_number',$
                   /EDITABLE,$
                   XSIZE = 12)

;Bins width and type
second_base = WIDGET_BASE(main,$
                          ROW = 1,$
                          /BASE_ALIGN_CENTER)

label = WIDGET_LABEL(second_base,$
                     VALUE = 'Bins:')

label = WIDGET_LABEL(second_base,$
                     VALUE = ' width:')

text = WIDGET_TEXT(second_base,$
                   UNAME = 'bin_width',$
                   /EDITABLE,$
                   XSIZE=5)

type_list = ['linear','log']
group = cw_bgroup(second_base,$
                  type_list,$
                  UNAME = 'bin_type',$
                  /EXCLUSIVE,$
                  /ROW)

END
