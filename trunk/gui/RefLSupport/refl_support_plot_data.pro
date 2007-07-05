;This function plots the selected file
PRO plot_loaded_file, Event, ListLongFileName

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

size = getSizeOfArray(ListLongFileName)

if (size NE 0) then begin

    color_array = (*(*global).color_array)
    FirstPass = 1
    for i=0,(size-1) do begin

        error_plot_status = 0
        catch, error_plot_status
        if (error_plot_status NE 0) then begin
            text = 'Not enough data to plot'
            CATCH,/cancel
        endif else begin
    
            openr,u,ListLongFileName[i],/get
            fs = fstat(u)
        
;define an empty string variable to hold results from reading the file
            tmp  = ''
            tmp0 = ''
            tmp1 = ''
            tmp2 = ''
            
            flt0 = -1.0
            flt1 = -1.
            flt2 = -1.0
            
            Nelines = 0L ;number of lines that does not start with a number
            Nndlines = 0L
            Ndlines = 0L
            onebyte = 0b
            
            while (NOT eof(u)) do begin
                
                readu,u,onebyte ;,format='(a1)'
                fs = fstat(u)
                                ;print,'onebyte: ',onebyte
                                ;rewinded file pointer one character
        
                if fs.cur_ptr EQ 0 then begin 
                    point_lun,u,0
                endif else begin
                    point_lun,u,fs.cur_ptr - 1
                endelse
                
                true = 1
                case true of
                    
                    ((onebyte LT 48) OR (onebyte GT 57)): begin
                                ;case where we have non-numbers
                        Nelines = Nelines + 1
                        readf,u,tmp
                    end
                    
                    else: begin
                                ;case where we (should) have data
                        Ndlines = Ndlines + 1
                                ;print,'Data Line: ',Ndlines
                        
                        catch, Error_Status
                        if Error_status NE 0 then begin
                            
                                ;you're done now...
                            CATCH, /CANCEL
                            
                        endif else begin
                            
                            readf,u,tmp0,tmp1,tmp2,format='(3F0)' ;
                            flt0 = [flt0,float(tmp0)] ;x axis
                            flt1 = [flt1,float(tmp1)] ;y axis
                            flt2 = [flt2,float(tmp2)] ;y_error axis
                            
                        endelse
                        
                    end
                endcase
                
            endwhile
            
;strip -1 from beginning of each array
            flt0 = flt0[1:*]
            flt1 = flt1[1:*]
            flt2 = flt2[1:*]
            
            draw_id = widget_info(Event.top, find_by_uname='plot_window')
            WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
            wset,view_plot_id
            
            close,u
            free_lun,u
            
            CATCH,/CANCEL
            DEVICE, DECOMPOSED = 0
            loadct,5
 
            colorIndex = color_array[i]
            if (FirstPass EQ 1) then begin

                flt1_first = flt1
                plot,flt0, flt1
                errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex
                FirstPass = 0
            
            endif else begin

                plot, flt0, flt1_first,/noerase
                errplot, flt0,flt1-flt2,flt1+flt2,color=colorIndex

            endelse

        endelse

    endfor

endif

END
