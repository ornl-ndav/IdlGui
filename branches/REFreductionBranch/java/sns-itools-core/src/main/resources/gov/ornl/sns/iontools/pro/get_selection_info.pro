;Height of the selection in pixels
function getSelectionHeight, ymax, ymin
return, ymax-ymin+1
end

;Width of the selection in pixles
function getSelectionWidth, xmax, xmin
return, xmax-xmin+1
end

;Get the number of pixels inside the selection
function getNbrPixelInsideSelection, SelectionHeight, SelectionWidth
return, SelectionHeight * SelectionWidth
end

;Get the number of pixels outside the selection
function getNbrPixelOutsideSelection, Nx, Ny, NbrPixelInsideSelection
return, Nx*Ny - NbrPixelInsideSelection
end

;Get pixelid
function getPixelId, Nx, x, y
return, x + Nx*y
end

;Get number of counts of pixelID
function getCounts, img, x, y
return, img[x,y]
end

;Get number of counts insisde selection
function getCountsInsideSelection, img, xmin, xmax, ymin, ymax
return, total(img(xmin:xmax, ymin:ymax))
end

;get number of counts outside selection
function getCountsOutsideSelection, img, CountsInsideSelection
return, total(img)-CountsInsideSelection
end

;get average number of counts inside selection
function getAverageCounts, TotalCounts, NbrPixel
return, TotalCounts/NbrPixel
end








function GET_SELECTION_INFO, Nx, Ny, tmp_file_name, xmin, ymin, xmax, ymax

openr,u,tmp_file_name,/get
fs = fstat(u)
Nimg = Nx*Ny
Ntof = fs.size/(Nimg*4L)
data_assoc = assoc(u,lonarr(Ntof))

;make the image array
img = lonarr(long(Ny),long(Nx))
for i=0L,Nimg-1 do begin
    x = i MOD Ny
    y = i/Ny
    img[x,y] = total(data_assoc[i])
endfor

close, u
free_lun, u

img=transpose(img)    

SelectionHeight = getSelectionHeight(ymax, ymin)
SelectionWidth = getSelectionWidth(xmax, xmin)
NbrPixelInsideSelection = getNbrPixelInsideSelection(SelectionHeight,$
                                                     SelectionWidth)
NbrPixelOutsideSelection = getNbrPixelOutsideSelection(Nx, $
                                                       Ny, $
                                                       NbrPixelInsideSelection)
StartingPixelId = getPixelId(Nx, xmin, ymin)
EndingPixelId = getPixelId(Nx, xmax, ymax)
CountsStartingPixelId = getCounts(img, xmin, ymin)
CountsEndingPixelId = getCounts(img, xmax,ymax)
CountsInsideSelection = getCountsInsideSelection(img, xmin, xmax, ymin, ymax)
CountsOutsideSelection = getCountsOutsideSelection(img, CountsInsideSelection)
AverageCountsInsideSelection = getAverageCounts(CountsInsideSelection,NbrPixelInsideSelection)
AverageCountsOutsideSelection = getAverageCounts(CountsOutsideSelection,NbrPixelOutsideSelection)

result = [strcompress(SelectionHeight),$
          strcompress(SelectionWidth),$
          strcompress(NbrPixelInsideSelection),$
          strcompress(NbrPixelOutsideSelection),$
          strcompress(StartingPixelId),$
          strcompress(EndingPixelId),$
          strcompress(CountsStartingPixelId),$
          strcompress(CountsEndingPixelId),$
          strcompress(CountsInsideSelection),$
          strcompress(CountsOutsideSelection),$
          strcompress(AverageCountsInsideSelection),$
          strcompress(AverageCountsOutsideSelection)]

return, string(result)
end




