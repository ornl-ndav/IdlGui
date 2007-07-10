FUNCTION getNumeric, text
text = strcompress(text,/remove_all)

;convert into array of bytes
textByteArray = byte(text)

;get length of array
tmpSize = size(textByteArray)
ArraySize = tmpSize[1]

finalArray = bytarr(ArraySize)
minByteAllowed = 48
maxByteAllowed = 57
dotByteAllowed = 46
j=0
for i=0,(ArraySize-1) do begin
    if (((textByteArray[i] GE minByteAllowed) AND $
    (textByteArray[i] LE maxByteAllowed)) OR $
    (textByteArray[i] EQ dotByteAllowed)) then begin
        finalArray[j] = textByteArray[i]
        j+=1
    endif 
endfor
return, string(finalArray)
END
