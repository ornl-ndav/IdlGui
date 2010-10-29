
;#### how to get metadata and data from NeXus files ####
;file_name = 'REF_M_5000.nxs'
;myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
;d_sd = myObject->get_d_SD()
;print, d_sd
;obj_destroy, myObject

;#### how to get metadata from xml file ####
file_name = 'instruments.cfg'
iFile = OBJ_NEW('idlxmlparser', file_name)
d_sd = iFile->getValue(tag=['configuration','REF_L','d_SD'], attr='description')
print
print, 'd_sd: ' , d_sd
obj_destroy, iFile

end