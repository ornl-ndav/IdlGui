;-------------------------------------------------------------------------------
FUNCTION isFullNexusNameEmpty, Event
;get Full Nexus File Name
FullNexusFileName = getFullNexusFileName(Event)
IF (FullNexusFileName EQ '') THEN RETURN, 1
RETURN,0
END

;-------------------------------------------------------------------------------
FUNCTION isRoiFileNameEmpty, Event
;get Roi file name
RoiFileName      = getRoiFileName(Event)
IF (RoiFileName EQ '') THEN RETURN,1
RETURN,0
END

;-------------------------------------------------------------------------------
