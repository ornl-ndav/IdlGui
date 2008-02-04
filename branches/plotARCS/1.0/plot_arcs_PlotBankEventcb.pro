FUNCTION CalculatePixelIDOffset, BankID

StrLength = STRLEN(BankID)
Row = strmid(BankID,0,1)
CASE (Row) OF
    'L': ColumnOffset = 0L
    'M': ColumnOffset = 38912L
    'T': ColumnOffset = 78848L
ENDCASE

;case of banks 32A and 32B
Column = strmid(BankID,1,StrLength-1)
CASE (Row) OF 
    'L':BEGIN
        Row = LONG(Column)
        RowOffset = (Row-1)*1024L+ColumnOffset
    END
    'M':BEGIN
        IF (STRMATCH(Row,'*A')) THEN BEGIN 
            RowOffset = 71680L   ;it is 32A
        ENDIF ELSE BEGIN
            IF (STRMATCH(Row,'*B')) THEN BEGIN 
                RowOffset = 70783L ;it is 32B
            ENDIF ELSE BEGIN
                Row = LONG(Column)
                IF (Row GE 33) THEN BEGIN
                    RowOffset = 72704L+(Row-33)*1024L
                ENDIF ELSE BEGIN
                    RowOffset = ColumnOffset+(Row-1)*1024L
                ENDELSE
            ENDELSE
        ENDELSE
    END
    'T':BEGIN
        ROW = LONG(Column)
        RowOffset = (Row-1)*1024L+ColumnOffset
    END
ENDCASE         
RETURN, RowOffset
END







PRO BankPlotInteraction, Event
WIDGET_CONTROL, event.top, GET_UVALUE=global2
wbase   = (*global2).wBase
;retrieve bank number
BankX = getBankPlotX(Event)
putTextInTextField, Event, 'x_input', BankX
BankY = getBankPlotY(Event)
putTextInTextField, Event, 'y_input', BankY

;get pixelID
BankID = (*global2).bankName
;;get pixeloffset of bank
PixelIDoffset = CalculatePixelIDOffset(BankID)
;;add pixeloffset inside bank
pxOffset = BankY + 128*BankX
PixelID = pxoffset + PixelIDoffset
putTextInTextField, Event, 'pixelid_input', PixelID

;get number of counts
tvimg = (*(*global2).tvimg)
putTextInTextField, Event, 'counts', tvimg[PixelID]
END
