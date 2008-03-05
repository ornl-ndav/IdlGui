;Change the format from Thu Aug 23 16:15:23 2007
;to 2007y_08m_23d_16h_15mn_23s
Function RefReduction_GenerateIsoTimeStamp

dateUnformated = systime()    
DateArray = strsplit(dateUnformated,' ',/extract) 

DateIso = strcompress(DateArray[4]) + 'y_'

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01m'
    'Feb':month='02m'
    'Mar':month='03m'
    'Apr':month='04m'
    'May':month='05m'
    'Jun':month='06m'
    'Jul':month='07m'
    'Aug':month='08m'
    'Sep':month='09m'
    'Oct':month='10m'
    'Nov':month='11m'
    'Dec':month='12m'
endcase

DateIso += strcompress(month,/remove_all) + '_'
DateIso += strcompress(DateArray[2],/remove_all) + 'd_'

;change format of time
time = strsplit(DateArray[3],':',/extract)
DateIso += strcompress(time[0],/remove_all) + 'h_'
DateIso += strcompress(time[1],/remove_all) + 'mn_'
DateIso += strcompress(time[2],/remove_all) + 's'

return, DateIso
END


FUNCTION getTimeBatchFormat

dateUnformated = systime()    
DateArray = strsplit(dateUnformated,' ',/extract) 

DateIso = strcompress(DateArray[4]) + '/'

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01'
    'Feb':month='02'
    'Mar':month='03'
    'Apr':month='04'
    'May':month='05'
    'Jun':month='06'
    'Jul':month='07'
    'Aug':month='08'
    'Sep':month='09'
    'Oct':month='10'
    'Nov':month='11'
    'Dec':month='12'
endcase

DateIso += strcompress(month,/remove_all) + '/'
DateIso += strcompress(DateArray[2],/remove_all) + '-'
DateIso += DateArray[3]

RETURN, DateIso
END




;Change the format from Thu Aug 23 16:15:23 2007
;to 2007y_08m_23d_16h_15mn
FUNCTION GenerateDateStamp

dateUnformated = systime()    
DateArray = strsplit(dateUnformated,' ',/extract) 

DateIso = strcompress(DateArray[4]) + 'y_'

month = 0
CASE (DateArray[1]) OF
    'Jan':month='01m'
    'Feb':month='02m'
    'Mar':month='03m'
    'Apr':month='04m'
    'May':month='05m'
    'Jun':month='06m'
    'Jul':month='07m'
    'Aug':month='08m'
    'Sep':month='09m'
    'Oct':month='10m'
    'Nov':month='11m'
    'Dec':month='12m'
endcase

DateIso += strcompress(month,/remove_all) + '_'
DateIso += strcompress(DateArray[2],/remove_all) + 'd_'

;change format of time
time = strsplit(DateArray[3],':',/extract)
DateIso += strcompress(time[0],/remove_all) + 'h_'
DateIso += strcompress(time[1],/remove_all) + 'mn'

return, DateIso
END

