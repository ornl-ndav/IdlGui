FUNCTION isArchived, Event
value = getCW_BgroupValue(Event,'archived_or_list_all')
IF (value EQ 0) THEN RETURN, 1
RETURN,0

END
