PRO MakeGuiInputGeometry, MAIN_BASE, MainBaseSize, images_structure

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

base = { size  : [0,0,MainBaseSize[2:3]],$
         uname : 'input_geometry_base'} 

tree_widget = { size  : [0,0,200,MainBaseSize[3]],$
                uname : 'tree_widget'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
base = WIDGET_BASE(MAIN_BASE,$
                   UNAME     = base.uname,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = base.size[2],$
                   SCR_YSIZE = base.size[3],$
                   map=1)

wTree = WIDGET_TREE(base,$
                   XOFFSET   = tree_widget.size[0],$
                   YOFFSET   = tree_widget.size[1],$
                   SCR_XSIZE = tree_widget.size[2],$
                   SCR_YSIZE = tree_widget.size[3],$
                   UNAME     = tree_widget.uname)
                   
wtRoot = WIDGET_TREE(wTree,$
                     VALUE = 'Types',$
                     /FOLDER,$
                     /EXPANDED)


file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[0]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf1 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'numbers',$
                      uvalue = 'LEAF',$
                      BITMAP = myIcon2)

file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[1]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf2 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'angles',$
                      uvalue = 'LEAF',$
                      BITMAP = myIcon2)

file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[2]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf3 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'lengthss',$
                      uvalue = 'LEAF',$
                      BITMAP = myIcon2)


file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[3]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf4 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'wavelength',$
                      uvalue = 'LEAF',$
                      BITMAP = myIcon2)

file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[4]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf5 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'other',$
                      uvalue = 'LEAF',$
                      BITMAP = myIcon2)


END
