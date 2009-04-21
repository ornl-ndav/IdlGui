print
print, "****Starting****"

;File bank
rtof_file = './REF_M_3769_2008y_05m_23d_17h_52mn_28s.rtof'
crtof_file = './REF_M_3769_2008y_05m_23d_17h_52mn_28s.crtof'
bss_file = './BSS_638_2008y_10m_30d_14h_48mn_48s.txt'
norm_file = 'BSS_126.norm'

;Choose file
file_name = bss_file
file_name = '/SNS/users/dfp/IdlGui/trunk/Summer2008/IDL3columnASCIIparser/' + bss_file
print, 'File path: ' + file_name

;Create object
myObj = OBJ_NEW('IDL3columnsASCIIparser', file_name)


;Read all metadata
print
print, "****Metadata*****"
print, myObj -> getMetadata()

;Read specific comment in metadata
print
print, '**** Reading the Comments *****'
print, "getMetadata('#F data:') = " + myObj->getMetadata('#F data:')
print, "getMetadata('#E') = " + myObj->getMetadata('#E')
print, "getMetadata('#e') = " + myObj->getMetadata('#e')
print, "getMetadata('#C') = " + myObj->getMetadata('#C')

;Read data
print
print, '**** Reading the Data ****'
myData = myObj->getData()
print
help, myData, /STRUCTURE
;print, mydata 
end

