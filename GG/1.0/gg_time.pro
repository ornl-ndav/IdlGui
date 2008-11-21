Function gg_GenerateIsoTimeStamp
dateUnformated = systime()      ;ex: Thu Aug 23 16:15:23 2007
DateArray = strsplit(dateUnformated,' ',/extract) 
;ISO8601 : 2007-08-23T12:20:34-04:00
DateIso = strcompress(DateArray[4]) + '-'
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
DateIso += strcompress(month,/remove_all) + '-'
DateIso += strcompress(DateArray[2],/remove_all) + 'T'
DateIso += strcompress(DateArray[3],/remove_all) + '-04:00'
return, DateIso
END
