pro table_right_click, event=event, type=type
compile_opt idl2      
            
            if (tag_names(event, /structure_name) EQ 'WIDGET_CONTEXT') THEN BEGIN
          id = widget_info(event.top, find_by_uname='context_open_beam_base')
          widget_displaycontextmenu, event.id, event.X, event.Y, id
        endif

        
        end