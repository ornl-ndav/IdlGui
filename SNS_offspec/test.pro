
file_name = 'REF_M_5000.nxs'
myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
d_sd = myObject->get_d_SD()
print, d_sd

end