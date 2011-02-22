file = obj_new('IDLxmlParser', '/SNS/REF_L/2010_2_4B_CAL/calibrations/REF_L_geom_2010_09_03.xml')
center_pixel = file->getValue(tag=['instrumentgeometry','math',$
'definitions'], attribute='yCenterPixel')
help, file
obj_destroy, file

print, 'center_pixel: ' , center_pixel



end