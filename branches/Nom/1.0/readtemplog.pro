pro readtemplog,time1,temp1,filename=file

if (not var_defined(file)) then begin
path = "~/detectorpositions"  ;path to Temp log file

 file = dialog_pickfile(/must_exist, $
 title = 'Select a Temp log file file', $
 filter = ['*.log'], $
 path = path,$
 get_path = Path)
file_list = strsplit(file,'\',/extract, count=length)
file_name = file_list[length-1]
end

openr,1,file

dummy='dummy'
nover=0
istop=0
while istop eq 0 do begin
readf,1,dummy
nover=nover+1
if strpos(dummy,'#') lt 0 then istop=1
end
close,1
openr,1,file
for i=0,nover-1 do begin
readf,1,dummy
end
temp1=0
time1=0l
dm=long([31,28,31,30,31,30,31,31,30,31,30,31])
y='y'
d='d'
a=1l
b=1l
c=1l
e=1l
f=1l
g=1l
while not eof(1) do begin
readf,1,format='(a13,a13,f13.6)',y,d,temp
temp1=[temp1,temp]
reads,y,a,b,c,format='(3x,i4,1x,i2,1x,i2)'
reads,d,e,f,g,format='(1x,i2,1x,i2,1x,f6.3)'
secsince1990=((a-1990l)*365l+((a-1990l)/4l-1l))
if (b gt 1) then secsince1990=secsince1990+total(dm(0:b-2))
secsince1990=secsince1990+c
secsince1990=long(secsince1990)*24l*3600l
secsince1990=secsince1990+long(e+4)*3600l+long(f)*60l+long(g)
time1=[time1,secsince1990]
end
temp1=temp1(1:*)
time1=time1(1:*)
close,1
return
end
