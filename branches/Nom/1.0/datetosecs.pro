function datetosecs,y,mo,d,h,mi,s

; returns seconds since Jan 1, 1990

dm=long([31,28,31,30,31,30,31,31,30,31,30,31])

secsince1990=((y-1990l)*365l+((y-1990l)/4l-1l))
if (mo gt 1) then secsince1990=secsince1990+total(dm(0:mo-2))
secsince1990=secsince1990+d
secsince1990=long(secsince1990)*24l*3600l
secsince1990=secsince1990+long(h+4)*3600l+long(mi)*60l+long(s)

return,secsince1990
end


