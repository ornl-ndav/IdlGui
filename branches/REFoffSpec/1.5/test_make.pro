;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run array.pro
.run math_utilities.pro
.run system_utilities.pro
.run time.pro
.run IDLsendLogBook__define.pro
.run IDLsendToGeek__define.pro
.run IDL3columnsASCIIparser__define.pro
.run IDLgetMetadata__define.pro
.run IDLgetMetadata_REF_M__define.pro
.run xdisplayfile.pro
.run findnexus.pro
.run uniq_element_table.pro
.run logger.pro
.run IDLxmlParser__define.pro
.run fsc_color.pro

;Build all procedures
cd, CurrentFolder

; test procedures
.run test_color4.pro

