;this function is going to retrive the data from bank1
;and save them in (*(*global).bank)
PRO retrieveBanksData, Event, FullNexusName, type

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

fileID  = h5f_open(FullNexusName)
;get bank data
fieldID = h5d_open(fileID,(*global).nexus_bank1_path)

if (type EQ 'data') then begin
    data = h5d_read(fieldID)
    (*(*global).bank1_data) = data
endif else begin
    (*(*global).bank1_norm) = h5d_read(fieldID)
endelse
END



;**********************************************************************
;DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA  *
;**********************************************************************
;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinaryData, Event, full_nexus_name, destination_folder

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_file_name = (*global).data_tmp_dat_file

RefReduction_DumpBinary, $
  Event, $
  full_nexus_name, $
  'data'

END



;**********************************************************************
;NORMALIZATION - NORMALIZATION - NORMALIZATION - NORMALIZATION        *
;**********************************************************************
;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinaryNormalization, Event, full_nexus_name, destination_folder

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_file_name = (*global).norm_tmp_dat_file

RefReduction_DumpBinary, $
  Event, $
  full_nexus_name, $
  'norm'

END



;**********************************************************************
;DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA*
;**********************************************************************
;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinary, Event, full_nexus_name, type

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message ;processing message

;display in log book what is going on
cmd = 'Retrieving data ... ' + PROCESSING
cmd_text = '        > ' + cmd
putLogBookMessage, Event, cmd_text, Append=1

retrieveBanksData, Event, full_nexus_name, type

;tells user that dump is done
LogBookText = getLogBookText(Event)
Message = 'OK'
putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

END
