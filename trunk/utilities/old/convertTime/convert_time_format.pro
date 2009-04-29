FUNCTION getOutputFileName, INPUT_FILE

;just remove <extenstion> and put _new.<extension>
file_parse = STRSPLIT(INPUT_FILE,'.',/EXTRACT,COUNT=nbr)
CASE (nbr) OF 
   0: new_file_name = input_file + '_new.txt'
   1: new_file_name = file_parse[0]+ '_new.txt'
   ELSE: new_file_name = STRJOIN(file_parse[0:nbr-2],'.') + $
                         '_new.txt'
ENDCASE
RETURN, new_file_name
END

;------------------------------------------------------------------------------
FUNCTION convert_date, date

YEAR_REFERENCE  = 2000L
split = STRSPLIT(date,'/',/EXTRACT)

;year into days
year = LONG(split[0]) - YEAR_REFERENCE
year_in_days = year * 365L

;month in days
mon  = LONG(split[1])
CASE (mon) OF
    1: mon_in_days = 31
    2: mon_in_days = 29
    3: mon_in_days = 31
    4: mon_in_days = 30
    5: mon_in_days = 31
    6: mon_in_days = 30
    7: mon_in_days = 31
    8: mon_in_days = 31
    9: mon_in_days = 30
    10: mon_in_days = 31
    11: mon_in_days = 30
    12: mon_in_days = 31
ENDCASE

;day in days
day_in_days  = LONG(split[2])
new_year     = year_in_days + mon_in_days + day_in_days

RETURN, new_year
END

;-----------------------------------------------------------------------------
FUNCTION convert_time, time

split = STRSPLIT(time,':',/EXTRACT)

;hour into days
hour = DOUBLE(split[0])
IF (hour NE DOUBLE(0)) THEN BEGIN
    hour_in_days = hour / 24d
ENDIF ELSE BEGIN
    hour_in_days = 0d
ENDELSE

;minute into days
minute = DOUBLE(split[1])
IF (minute NE DOUBLE(0)) THEN BEGIN
    minute_in_days = minute / 24d*60d
ENDIF ELSE BEGIN
    minute_in_days = 0d
ENDELSE

;seconds into days
seconds = DOUBLE(split[2])
IF (seconds NE DOUBLE(0)) THEN BEGIN
    seconds_in_days = seconds / (24d*3600d)
ENDIF ELSE BEGIN
    seconds_in_days = 0d
ENDELSE
new_format = hour_in_days + minute_in_days + seconds_in_days

RETURN, new_format
END

;------------------------------------------------------------------------------
FUNCTION remove_header, file_array
header = '#'
index  = STRPOS(file_array,header)
nbr    = WHERE(index NE -1) 
IF (N_ELEMENTS(nbr) GT 0) THEN BEGIN
    last_occurence = nbr[N_ELEMENTS(nbr)-1]+1
    new_file_array = file_array[last_occurence:N_ELEMENTS(file_array)-1]
    RETURN, new_file_array
ENDIF ELSE BEGIN
    RETURN, file_array
ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION changeFormat, file_array

sz = N_ELEMENTS(file_array)
index = 0
WHILE (index LT sz) DO BEGIN
    string_split = STRSPLIT(file_array[index],' ',/EXTRACT)
    date_old     = string_split[0]
    date_new     = convert_date(date_old)
    split_2      = STRSPLIT(string_split[1],string(9b),/EXTRACT)
    time_old     = split_2[0]
    time_new     = convert_time(time_old)
    date_time    = date_new+time_new
    s_date_time  = STRING(date_time, format='(f20.10)')
    file_array[index] = STRCOMPRESS(s_date_time,/REMOVE_ALL) + ' ' + split_2[1]
    index++
ENDWHILE
RETURN, file_array
END

;------------------------------------------------------------------------------
PRO convert_time_format

VERSION = '1.0.0'

no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
   CATCH,/CANCEL
   text = ['There is a problem with the input file or your mispelled one ' + $
           'of the flags',$
           'Please send your input file to j35@ornl.gov with the command ' + $
           'line you used']
   result = DIALOG_MESSAGE(text,$
                           TITLE = "Conversion Failed",$
                           /ERROR)
   EXIT
ENDIF ELSE BEGIN
   input = COMMAND_LINE_ARGS()
   
   isVersion1 = STRMATCH(input,'--version')
   isVersion2 = STRMaTCH(input,'-v')
   IF (TOTAL(isVersion1) + TOTAL(isVersion2) GT 0) THEN BEGIN
      print, 'convertTimeFormat version ' + VERSION
      EXIT	
   ENDIF
   
;check if there is the --help or -h tag and if there is, display help
;menu
   isHelp1 = STRMATCH(input,'--help')
   isHelp2 = STRMATCH(input,'-h')
   IF (TOTAL(isHelp1) + TOTAL(isHelp2) GT 0) THEN BEGIN
      print, 'convertTimeFormat Help Menu:'
      print
      print, 'This program takes a 3 columns ASCII file with metadata in the header'
      print, 'and replace the time format by numbers of days since 2000.'
      print
      print, '   convertTimeFormat <input_file> [<output_file>] [-h] [--help]'
      print
      print, 'Parameters:'
      print
      print, '   <infput_file>(mandatory) name of file to convert'
      print, '   <output_file>(optional)  name of output file to create. If no name'
      print, '                            is provided, "_new.txt" will replace the'
      print, '                            extension of the input file.'
      print, '   -h, --help (optional)    displays this help.'
      print, '   -v, --version (optional) to get the current version of the' + $
             ' application'
      print
      print, ' To report bugs, request new feature or questions, contact j35@ornl.gov'
      EXIT
   ENDIF
   
   IF (input[0] EQ '') THEN BEGIN
      text = ['Please Provide an input file !',$
              '',$
              'Format:',$
              '    convertTimeFormat <input_file_name> [<output_file_name>]']
      result = DIALOG_MESSAGE(text,$
                              TITLE = "ERROR!",$
                              /ERROR)
      EXIT
   ENDIF
   INPUT_FILE = input[0]
   
   file_size  = FILE_LINES(INPUT_FILE)
   IF (file_size EQ 0) THEN RETURN
   file_array = STRARR(file_size)
   OPENR, 1, INPUT_FILE
   READF, 1, file_array
   CLOSE, 1
   
;remove header
   file_array_wo_header = remove_header(file_array)
   
;format the first column
   file_array_new_format = changeFormat(file_array_wo_header)
   
;output file
   IF (N_ELEMENTS(input) GT 1) THEN BEGIN
      OUTPUT_FILE=input[1]
   ENDIF ELSE BEGIN
      OUTPUT_FILE = getOutputFileName(INPUT_FILE)
   ENDELSE
   openw, 1, OUTPUT_FILE
   sz = N_ELEMENTS(file_array_new_format)
   index = 0
   WHILE (index LT sz) DO BEGIN
      PRINTF, 1, file_array_new_format[index]
      index++
   ENDWHILE        
   CLOSE, 1
   FREE_LUN, 1
   
   text = 'Output file is: ' + OUTPUT_FILE
   result = DIALOG_MESSAGE(text,$
                           TITLE = "Conversion Successful!",$
                           /INFORMATION)

ENDELSE ;end of catch statement
   
END

