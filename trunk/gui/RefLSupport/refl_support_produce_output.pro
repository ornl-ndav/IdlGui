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

;get list of files
list_of_files = (*(*global).list_of_files)

;get global object of data of interest
flt0_ptr = (*global).flt0_rescale_ptr
flt1_ptr = (*global).flt1_rescale_ptr
flt2_ptr = (*global).flt2_rescale_ptr

;loop over all the files to get output
for i=0,(nbrFiles-1) do begin

   ;add a blank line before all data
   MasterText = [MasterText,'']
   
   ;get name of file first
   fileName = list_of_files[i]
   TextFileName = '## ' + fileName + '##'
   MasterText = [MasterText,TextFileName]

   ;add the value of the angle (in degree)
   angle_array = (*(*global).angle_array)
   angle_value = angle_array[i]
   TextAngle = '#Angle value: ' + strcompress(angle_value)
   TextAngle += ' degrees'
   MasterText = [MasterText,TextAngle]

   ;retrieve flt0, flt1 and flt2
   flt0 = *flt0_ptr[i]
   flt1 = *flt1_ptr[i]
   flt2 = *flt2_ptr[i]
   
   ;remove INF, -INF and NAN values from arrays
   index = getArrayRangeOfNotNanValues(flt1)
   flt0 = flt0(index)
   flt1 = flt1(index)
   flt2 = flt2(index)
     
   flt0Size = (size(flt0))(1)
   for j=0,(flt0Size-1) do begin
      TextData = strcompress(flt0[j]) 
      TextData += ' '
      TextData += strcompress(flt1[j])
      TextData += ' '
      TextData += strcompress(flt2[j])
      MasterText = [MasterText,TextData]
   endfor

endfor
;output contain of output file in output_file_tab
putValueInTextField, Event, 'output_file_text_field', MasterText

;create output file name
createOutputFile, Event, outputFileName, MasterText

END



;This function create the output file
PRO createOutputFile, Event, output_file_name, MasterText

;size of MasterText
MasterTextSize = (size(MasterText))(1)

openw, 1, output_file_name

for i=0,(MasterTextsize-1) do begin
   printf, 1,MasterText[i]
endfor

close, 1
free_lun, 1

END

