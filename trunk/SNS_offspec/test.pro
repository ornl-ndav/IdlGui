
;#### how to get metadata and data from NeXus files ####
;file_name = 'unit_test_files/REF_L_38955.nxs'
file_name= 'unit_test_files/REF_M_5000.nxs'
myObject = obj_new('IDLnexusUtilities',file_name,spin_state='Off_Off')
;d_sd = myObject->get_twotheta()
v_u = myObject->get_d_SD()
help, v_u
print, v_u
obj_destroy, myObject

;;#### how to get metadata from xml file ####
;file_name = 'SNS_offspec_instruments.cfg'
;iFile = OBJ_NEW('idlxmlparser', file_name)
;d_sd = iFile->getValue(tag=['configuration','REF_L','d_SD'], attr='units')
;print, d_sd
;obj_destroy, iFile

end