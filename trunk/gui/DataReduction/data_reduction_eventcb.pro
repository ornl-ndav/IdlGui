function check_access, Event, instrument, user

list_of_instrument = ['REF_L', 'REF_M']

;0:j35:jean / 1:pf9:pete / 2:2zr:michael / 3:mid:steve / 4:1qg:rick / 5:ha9:haile / 6:vyi:frank / 7:vuk:john 
;8:x4t:xiadong / 9:ele:eugene
list_of_users = ['j35','pf9','2zr','mid','1qg','ha9','vyi','vuk','x4t','ele']

;check if ucams is in the list
user_index=-1
for i =0, 9 do begin
   if (user EQ list_of_users[i]) then begin
     user_index = i
     break 
   endif
endfor

;check if user is autorized for this instrument
CASE instrument OF		
   ;REF_L
   0: CASE user_index OF
        -1:
	0: 		;authorized
	1: 		;authorized
	2: 		;authorized
	3: 		;authorized
	4: user_index=-1	;unauthorized
	5: user_index=-1	;unauthorized
	6: user_index=-1	;unauthorized
	7: 		;authorized
	8: 		;authorized
	9: user_index=-1	;unauthorized
      ENDCASE
   ;REF_M
   1: CASE user_index OF
	-1:
	0: 
	1: 
	2: 
	3: 
	4: 
	5: 
	6: 
	7: user_index=-1
	8: user_index=-1
	9: user_index=-1
      ENDCASE
ENDCASE	 
	
RETURN, user_index

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


;--------------------------------------------------------------------------------
; \brief main function that plot the window
;
; \argument wWidget (INPUT) 
;--------------------------------------------------------------------------------
pro MAIN_REALIZE, wWidget

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
