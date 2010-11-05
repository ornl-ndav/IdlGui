
;#### how to get metadata and data from NeXus files ####
;file_name = 'unit_test_files/REF_L_38955.nxs'
;myObject = obj_new('IDLnexusUtilities',file_name)
file_name= 'unit_test_files/REF_M_8324.nxs'
myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
value = myObject->get_tof_data()
;v_u = myObject->get_d_SD()
print, size(value)
help, value

obj_destroy, myObject

;value = myObject->get_theta()
;obj_destroy, myObject
;print, value

;data = myObject->get_tof_counts_data()
;help, data
;print, size(data)

;print, data[0:10]

;;;#### how to get metadata from xml file ####
;file_name = 'SNS_offspec_instruments.cfg'
;iFile = OBJ_NEW('idlxmlparser', file_name)
;d_sd = iFile->getValue(tag=['config','instruments','REF_L','d_SD'], attr='units')
;print, d_sd
;
;value = iFile->getValue(tag=['config','instruments','REF_M','d_MS'])
;print, value
;
;value = iFile->getValue(tag=['config','constants','h'])
;print, value

;obj_destroy, iFile

end