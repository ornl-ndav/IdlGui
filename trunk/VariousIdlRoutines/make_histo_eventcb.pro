; \brief Empty stub procedure used for autoloading.
;
pro make_histo_eventcb
end


pro OPEN_EVENT_FILE_CB, event

;indicate reading data with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='wTLB')
widget_control,id,get_uvalue=global

;open file
filter = (*global).filter_event
path = (*global).path
file = dialog_pickfile(path=path,get_path=path,title='Select event file',filter=filter)

;only read data if valid file given
if file NE '' then begin

	(*global).event_filename = file ; store input filename
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
	text = "Select event file: "
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	text = strcompress(file,/remove_all)
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;get only the last part of the file (its name)
	file_list=strsplit(file,'/',/extract,count=length)     ;to get only the last part of the name
	filename_only=file_list[length-1]	
	(*global).event_filename_only = filename_only ; store only name of the file (without the path)

	view_info = widget_info(Event.top,FIND_BY_UNAME='EVENT_FILE_LABEL_tab1')
	WIDGET_CONTROL, view_info, SET_VALUE=filename_only

	;determine path	
	path_list=strsplit(file,filename_only,/reg,/extract)
	path=path_list[0]
	cd, path
	(*global).path = path

	;display path
	view_info = widget_info(Event.top,FIND_BY_UNAME='DEFAULT_FINAL_PATH_tab2')
	WIDGET_CONTROL, view_info, SET_VALUE=path

	;now we can activate "GO_HISTOGRAM
	button1=widget_info(Event.top, FIND_BY_UNAME="GO_HISTOGRAM_BUTTON_wT1")
	widget_control,button1,sensitive=1

  endif

end

pro NUMBER_PIXEL_IDS_CB, event
print,'NUMBER_PIXEL_IDS_CB'
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers

end

pro REBINNING_TEXT_CB, event
print,'REBINNING_TEXT_CB'
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers

end

pro MAX_TIME_BIN_TEXT_CB, event
print,'MAX_TIME_BIN_TEXT_CB'
;can insert here a routine to check for valid field values - for example, discard letter, keep numbers

end

pro  OPEN_MAPPING_FILE_BUTTON_CB, event

;indicate reading data with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='wTLB')
widget_control,id,get_uvalue=global

;open file
filter = (*global).filter_mapping
path = (*global).path_mapping
file = dialog_pickfile(path=path,get_path=path,title='Select mapping file',filter=filter)

;only read data if valid file given
if file NE '' then begin

	(*global).mapping_filename = file ; store input filename
	
	view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
	text = "Mapping file selected: "
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
	text = strcompress(file,/remove_all)
	WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

	;display path
	view_info = widget_info(Event.top,FIND_BY_UNAME='MAPPING_FILE_LABEL_tab1')
	WIDGET_CONTROL, view_info, SET_VALUE=path

  endif

print,'OPEN_MAPPING_FILE_BUTTON_CB'

end

pro  DEFAULT_PATH_BUTTON_CB, event
print,'DEFAULT_PATH_BUTTON_CB'

end

pro  GO_HISTOGRAM_CB, event

wWidget = event.top

;get the global data structure
id=widget_info(wWidget, FIND_BY_UNAME='wTLB')
widget_control,id,get_uvalue=global

txt = "*** HISTOGRAMMING ***"
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=txt, /APPEND

;in GO_HISTOGRAM, we need to get widget values of tab 1 to do our work
id_0 = Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TYPE_GROUP')
	WIDGET_CONTROL, id_0, GET_VALUE = lin_log

id_1 = Widget_Info(wWidget, FIND_BY_UNAME='NUMBER_PIXEL_IDS')
	WIDGET_CONTROL, id_1, GET_VALUE =number_pixels

id_2 = Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TEXT')
	WIDGET_CONTROL, id_2, GET_VALUE =rebinning_text

id_3 = Widget_Info(wWidget, FIND_BY_UNAME='MAX_TIME_BIN_TEXT')
	WIDGET_CONTROL, id_3, GET_VALUE =max_time_bin

(*global).lin_log = lin_log
(*global).number_pixels = number_pixels
(*global).rebinning = rebinning_text
(*global).max_time_bin = max_time_bin

event_filename = (*global).event_filename
path = (*global).path

cmd_line = "Event_to_Histo "
cmd_line += "-l " + strcompress(rebinning_text,/remove_all)
cmd_line += " -M " + strcompress(max_time_bin,/remove_all)
cmd_line += " -p " + strcompress(number_pixels,/remove_all)
cmd_line += " " + event_filename

cmd_line_displayed = "> " + cmd_line

WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch histogramming
str_time = systime(1)
text = "Processing....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;determine name of histo file
event_filename = (*global).event_filename
file_list=strsplit(event_filename,'event.dat$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
histo_filename = filename_short + 'histo.dat'
(*global).histo_filename = histo_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = histo_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

rb_id=widget_info(Event.top, FIND_BY_UNAME='CREATE_NEXUS')
widget_control,rb_id,sensitive=1

end

pro CREATE_NEXUS_CB, event

wWidget = event.top

;get the global data structure
id=widget_info(wWidget, FIND_BY_UNAME='wTLB')
widget_control,id,get_uvalue=global

txt = "*** TRANSLATION SERVICE ***"
view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=txt, /APPEND

;retrieve constant
number_pixels = (*global).number_pixels
rebinning_text = (*global).rebinning
max_time_bin = (*global).max_time_bin
number_tbin = max_time_bin / rebinning_text
mapping_filename = (*global).mapping_filename
histo_filename = (*global).histo_filename
path = (*global).path

cmd_line = "Map_Data "
cmd_line += "-m " + mapping_filename
cmd_line += " -n " + histo_filename
cmd_line += " -p " + strcompress(number_pixels, /remove_all)
cmd_line += " -t " + strcompress(number_tbin, /remove_all)

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch mapping
str_time = systime(1)
text = "Processing mapping....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
;spawn, cmd_line, listening

;determine name of histo_mapped file
file_list=strsplit(histo_filename,'histo.dat$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
histo_mapped_filename = filename_short + 'histo_mapped.dat'
(*global).histo_mapped_filename = histo_mapped_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = histo_mapped_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

;making translation file now
translation_filename = (*global).translation_filename
cmd_line = "TS_merge_preNeXus.sh "
cmd_line += translation_filename

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch merging
str_time = systime(1)
text = "Processing merging....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;determine name of merge file
file_list=strsplit(histo_filename,'_neutron_histo.dat$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
new_translation_filename = filename_short + '.nxt'
(*global).new_translation_filename = new_translation_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = new_translation_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND


;making NeXus file now
new_translation_filename = (*global).new_translation_filename
cmd_line = "nxtranslate "
cmd_line += new_translation_filename

cmd_line_displayed = "> " + cmd_line

view_info = widget_info(Event.top,FIND_BY_UNAME='HISTOGRAM_STATUS')
WIDGET_CONTROL, view_info, SET_VALUE=cmd_line_displayed, /APPEND

;launch translation
str_time = systime(1)
text = "Processing translation....."
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
spawn, cmd_line, listening

;determine name of nexus file
file_list=strsplit(new_translation_filename,'t$',/REGEX,/extract,count=length) ;to remove last part of the name
filename_short=file_list[0]	
nexus_filename = filename_short + 's'
(*global).nexus_filename = nexus_filename

text = "New file created: "
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = nexus_filename
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end_time = systime(1)
text = "Done"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND
text = "Processing_time: " + strcompress((end_time-str_time),/remove_all) + " s"
WIDGET_CONTROL, view_info, SET_VALUE=text, /APPEND

end


pro  tmp1, event

end


pro wTLB_REALIZE, wWidget

;indicate initialization with hourglass icon
widget_control,/hourglass

;turn off hourglass
widget_control,hourglass=0

end
