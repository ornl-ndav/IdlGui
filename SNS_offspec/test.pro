
;#### how to get metadata and data from NeXus files ####
file_name = 'REF_L_38955.nxs'
myObject = obj_new('IDLnexusUtilities',file_name)
d_sd = myObject->get_twotheta()
help, d_sd
print, d_sd
obj_destroy, myObject

;;#### how to get metadata from xml file ####
;file_name = 'instruments.cfg'
;iFile = OBJ_NEW('idlxmlparser', file_name)
;d_sd = iFile->getValue(tag=['configuration','REF_L','d_SD'], attr='description')
;print, d_sd
;obj_destroy, iFile

end