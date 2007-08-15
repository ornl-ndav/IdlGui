;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinaryData, Event, full_nexus_name, destination_folder

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message ;processing message

cmd_dump = 'nxdir ' + full_nexus_name
cmd_dump += ' -p /entry/bank1/data/ --dump ' 
cmd_dump += (*global).working_path + (*global).data_tmp_dat_file
cmd_dump_text = cmd_dump + '........' + PROCESSING

;display in log book what is going on
cmd_dump_text = '        > ' + cmd_dump_text
putLogBookMessage, Event, cmd_dump_text, Append=1

;run command
spawn, cmd_dump, listening

;tells user that dump is done
LogBookText = getLogBookText(Event)
Message = 'OK'
putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

END
