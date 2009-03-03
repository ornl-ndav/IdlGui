rtof_file = './REF_M_3769_2008y_05m_23d_17h_52mn_28s.rtof'
crtof_file = './REF_M_3769_2008y_05m_23d_17h_52mn_28s.crtof'
bss_file = './BSS_638_2008y_10m_30d_14h_48mn_48s.txt'
norm_file = 'BSS_126.norm'

file_name = bss_file
file_name = '/SNS/users/dfp/IdlGui/trunk/Summer2008/IDL3columnASCIIparser/' + bss_file
;print, file_name

iClass = OBJ_NEW('IDL3columnsASCIIparser', file_name)
;print, 'File name is: ' + file_name
;help, iClass
;help, OBJ_VALID(iClass)
;print
;print, '**** Reading the Comments *****'
;print, "get_tag('#F data:') = " + iClass->getMetadata('#F data:')
;;print, "get_tag('#E') = " + iClass->getTag('#E')
;;print, "get_tag('#e') = " + iClass->getTag('#e')
;print, "get_tag('#C') = " + iClass->getMetadata('#C')
;print
;print, "****Metadata*****"
;print, iClass -> getMetadata()
print, '**** Reading the Data ****'
myData = iClass->getData()
print
help, myData, /STRUCTURE
;print, mydata 
end

