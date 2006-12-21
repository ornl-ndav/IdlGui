function get_ucams

cmd_pwd = "pwd"
spawn, cmd_pwd, listening
print, "listening is: ", listening
array_listening=strsplit(listening,'/',count=length,/extract)
ucams = array_listening[2]
return, ucams
end





function check_access, Event, instrument, ucams

list_of_instrument = ['REF_L', 'REF_M']

;0:j35:jean / 1:pf9:pete / 2:2zr:michael / 3:mid:steve / 4:1qg:rick / 5:ha9:haile / 6:vyi:frank / 7:vuk:john 
;8:x4t:xiadong / 9:ele:eugene
list_of_ucams = ['j35','pf9','2zr','mid','1qg','ha9','vyi','vuk','x4t','ele']

;check if ucams is in the list
ucams_index=-1
for i =0, 9 do begin
   if (ucams EQ list_of_ucams[i]) then begin
     ucams_index = i
     break 
   endif
endfor

;check if user is autorized for this instrument
CASE instrument OF		
   ;REF_L
   0: CASE  ucams_index OF
        -1:
	0: 		;authorized
	1: 		;authorized
	2: 		;authorized
	3: 		;authorized
	4: ucams_index=-1	;unauthorized
	5: ucams_index=-1	;unauthorized
	6: ucams_index=-1	;unauthorized
	7: 		;authorized
	8: 		;authorized
	9: ucams_index=-1	;unauthorized
      ENDCASE
   ;REF_M
   1: CASE ucams_index OF
	-1:
	0: 
	1: 
	2: 
	3: 
	4: 
	5: 
	6: 
	7: ucams_index=-1
	8: ucams_index=-1
	9: ucams_index=-1
      ENDCASE
ENDCASE	 
	
RETURN, ucams_index
 
end

;---------------------------------------------------------------------------------
pro USER_TEXT_cb, Event   ;for REF_M

view_id = widget_info(Event.top,FIND_BY_UNAME='LEFT_TOP_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='RIGHT_TOP_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='LEFT_BOTTOM_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	
view_id = widget_info(Event.top,FIND_BY_UNAME='RIGHT_BOTTOM_ACCESS_DENIED')
WIDGET_CONTROL, view_id, set_value= ''	

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;------------------------------------------------------------------------------------------
; \brief function to obtain the top level base widget given an arbitrary widget ID.
;
; \argument wWidget (INPUT)
;------------------------------------------------------------------------------------------
function get_tlb,wWidget

id = wWidget
cntr = 0
while id NE 0 do begin

	tlb = id
	id = widget_info(id,/parent)
	cntr = cntr + 1
	if cntr GT 10 then begin
		print,'Top Level Base not found...'
		tlb = -1
	endif
endwhile

return,tlb

end


;main_realize of the front door interface (instrument selection)
pro MAIN_REALIZE, wWidget

;get global structure
id=widget_info(wWidget, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

image_logo="/SNS/users/j35/SVN/HistoTool/trunk/gui/DataReduction/data_reduction_gui_logo.bmp"
id = widget_info(wWidget,find_by_uname="logo_message_draw")
WIDGET_CONTROL, id, GET_VALUE=id_value
wset, id_value
image = read_bmp(image_logo)
tv, image,0,0,/true

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


;main_realize of main data_reduction display
pro MAIN_REALIZE_data_reduction, wWidget

tlb = get_tlb(wWidget)

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$






; \brief Empty stub procedure used for autoloading.
;
pro data_reduction_eventcb
end


pro wTLB_REALIZE, wWidget
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end
