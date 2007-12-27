FUNCTION MAKE_DATE, year, month, day, hour, minute, second, $
   NO_LEAP = no_leap

;+
;NAME:
;		MAKE_DATE
;PURPOSE:
;		This function creates a CDATE or a CDATE_NO_LEAP structure containing the specified values.
;CATEGORY:
;		Date and time calculations.
;CALLING SEQUENCE:
;		date = MAKE_DATE([year, [month, [day, [hour, [minute, [second]]]]]])
;INPUT:
;		year   : Optional calendar year
;		month  : Optional month (1 to 12)
;		day    : Optional day of the month (1 to 28, 30, or 31)
;		hour   : Optional hour (0 to 23)
;		minute : Optional minute (0 to 59)
;		second : Optional second (0 to 59)
;OUTPUT:
;		CDATE tructure (defined in cdate__define.pro) or
;		CDATE_NO_LEAP tructure (defined in cdate_no_leap__define.pro)
;KEYWORDS:
;     NO_LEAP : If set, create a CDATE_NO_LEAP structure (use a calendar without leap days),
;               else, create a CDATE structure.
;MODIFICATION HISTORY:
;     Kenneth Bowman, 1999-04.
;     Updated to include default values for all parameters, 2000-03.
;     Updated to include NO_LEAP option, 2001-03.
;-

COMPILE_OPT IDL2

IF (N_PARAMS() LT 6) THEN second = 0																	;Default value for second
IF (N_PARAMS() LT 5) THEN minute = 0																	;Default value for minute
IF (N_PARAMS() LT 4) THEN hour   = 0																	;Default value for hour
IF (N_PARAMS() LT 3) THEN day    = 1																	;Default value for day
IF (N_PARAMS() LT 2) THEN month  = 1																	;Default value for month
IF (N_PARAMS() LT 1) THEN year   = 1																	;Default value for year

IF((month  LT 1) OR (month  GT 12)) THEN MESSAGE, 'Month out of range in MAKE_DATE.'	;Check month range
IF((day    LT 1) OR (day    GT 31)) THEN MESSAGE, 'Day out of range in MAKE_DATE.'		;Check day range
IF((hour   LT 0) OR (hour   GT 23)) THEN MESSAGE, 'Hour out of range in MAKE_DATE.'		;Check hour range
IF((minute LT 0) OR (minute GT 59)) THEN MESSAGE, 'Minute out of range in MAKE_DATE.'	;Check minute range
IF((second LT 0) OR (second GT 59)) THEN MESSAGE, 'Second out of range in MAKE_DATE.'	;Check second range

IF KEYWORD_SET(no_leap) THEN date = {CDATE_NO_LEAP} $												;Create date structure (no leap days)
								ELSE date = {CDATE}															;Create date structure (standard calendar)

date.year   = LONG(year)																					;Copy year to structure
date.month  = LONG(month)																					;Copy month to structure
date.day    = LONG(day)																						;Copy day to structure
date.hour   = LONG(hour)																					;Copy hour to structure
date.minute = LONG(minute)																					;Copy minute to structure
date.second = LONG(second)																					;Copy second to structure

RETURN, date

END
