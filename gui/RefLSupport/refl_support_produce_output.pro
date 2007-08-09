;this function create the output file name
;if CE file name is REF_L_2893.txt
;the output file name will be: REF_L_2893_CE_scaling.txt
FUNCTION createOuputFileName, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

full_CE_name = (*global).full_CE_name

;remove the .txt extension
full_ce_name_1 = strsplit(full_CE_name,'.txt',/regex,/extract)

;add '_CE_scalling.txt'
output_file_name = full_ce_name_1[0] + '_CE_scaling.txt'

RETURN, output_file_name
END




;Main function that will produce and display the output file.
PRO ReflSupport_ProduceOutputFile, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;text string to output
MasterText = ''

;create output file name
outputFileName = createOuputFileName(Event)

;display the name of the output file name
putValueInLabel, Event, 'output_file_name_label_dynmaic', outputFileName

;metadata of the CE file
metadata_CE_file = (*(*global).metadata_CE_file)
MasterText += metadata_CE_file

;remove first blank line
MasterText = MasterText[1:*]
;get the number of files to print out
nbrFiles = getNbrElementsInDroplist(Event, 'list_of_files_droplist')

;output contain of output file in output_file_tab
putValueInTextField, Event, 'output_file_text_field', MasterText

END
