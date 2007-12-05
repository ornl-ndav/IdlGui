PRO MakeGuiInputGeometry, MAIN_BASE, MainBaseSize, images_structure

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

base = { size  : [0,0,MainBaseSize[2:3]],$
         uname : 'input_geometry_base'} 

;////////////
;tree widget/
;////////////
tree_widget = { size  : [0,0,200,MainBaseSize[3]],$
                uname : 'tree_widget'}


;/////////////
;table widget/
;/////////////
table_widget = { size         : [200,0,500,300,4,15],$
                 uname        : 'table_widget',$
                 label        : ['STATUS','N A M E','VALUE','UNITS'],$
                 column_width : [60,180,120,110]}

;///////////
;Input base/
;///////////
input_base = { size  : [200,300,500,200],$
               uname : 'input_base'}
name_label = { size  : [20,20,60,30],$
               value : 'N A M E :'}
XYoff = [50,0]
name_value = { size : [name_label.size[0]+XYoff[0],$
                       name_label.size[1]+XYoff[1],$
                       150,$
                       30],$
               uname : 'name_value'}
XYoff = [200,0]
value_label = { size  : [name_label.size[0]+XYoff[0],$
                         name_label.size[1]+XYoff[1]],$
                value : 'Value'}
XYoff = [160,0]
Units_label = { size  : [value_label.size[0]+XYoff[0],$
                         value_label.size[1]+XYoff[1]],$
                value : 'Units'}
XYoff = [80,40]
original_label = { size : [name_label.size[0]+XYoff[0],$
                           name_label.size[1]+XYoff[1]],$
                   value : 'Original'}
XYoff = [0,60]
current_label  = { size : [original_label.size[0]+XYoff[0],$
                           original_label.size[1]+XYoff[1]],$
                   value : 'Current'}

XYoff = [80,0]
original_value_label = { size : [original_label.size[0]+XYoff[0],$
                                 original_label.size[1]+XYoff[1],$
                                 130,30],$
                         uname : 'original_value_label'}
XYoff = [160,0]
original_units_label = { size : [original_value_label.size[0]+XYoff[0],$
                                 original_value_label.size[1]+XYoff[1],$
                                 130,30],$
                         uname : 'original_units_label'}
XYoff = [75,-5]
current_value_base = { size : [current_label.size[0]+XYoff[0],$
                               current_label.size[1]+XYoff[1],$
                               150,40],$
                       xsize : 20,$
                       uname : 'current_value_text_field'}

XYoff = [235,-5]
current_units_base = { size : [current_label.size[0]+XYoff[0],$
                               current_label.size[1]+XYoff[1],$
                               150,40],$
                       xsize : current_value_base.xsize,$
                       uname : 'current_units_text_field'}

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

;\\\\\\\\\\\\
;tree widget\
;\\\\\\\\\\\\
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
                      VALUE  = 'lengths',$
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

;\\\\\\\\\\\\\
;table widget\
;\\\\\\\\\\\\\
table = WIDGET_TABLE(base,$
                     XOFFSET       = table_widget.size[0],$
                     YOFFSET       = table_widget.size[1],$
                     SCR_XSIZE     = table_widget.size[2],$
                     SCR_YSIZE     = table_widget.size[3],$
                     XSIZE         = table_widget.size[4],$
                     YSIZE         = table_widget.size[5],$
                     UNAME         = table_widget.uname,$
                     COLUMN_LABELS = table_widget.label,$
                     COLUMN_WIDTHS = table_widget.column_width,$
                     /NO_ROW_HEADERS,$
                     /ROW_MAJOR,$
                     /RESIZEABLE_COLUMNS)

;\\\\\\\\\\\
;Input base\
;\\\\\\\\\\\
input_base = WIDGET_BASE(base,$
                         XOFFSET   = input_base.size[0],$
                         YOFFSET   = input_base.size[1],$
                         SCR_XSIZE = input_base.size[2],$
                         SCR_YSIZE = input_base.size[3],$
                         UNAME     = input_base.uname)

label = WIDGET_LABEL(input_base,$
                     XOFFSET   = name_label.size[0],$
                     YOFFSET   = name_label.size[1],$
                     SCR_XSIZE = name_label.size[2],$
                     SCR_YSIZE = name_label.size[3],$
                     VALUE     = name_label.value)

value = WIDGET_LABEL(input_base,$
                     XOFFSET   = name_value.size[0],$
                     YOFFSET   = name_value.size[1],$
                     SCR_XSIZE = name_value.size[2],$
                     SCR_YSIZE = name_value.size[3],$
                     UNAME     = name_value.uname,$
                     VALUE     = '')

value_label = WIDGET_LABEL(input_base,$
                           XOFFSET   = value_label.size[0],$
                           YOFFSET   = value_label.size[1],$
                           SCR_YSIZE = name_value.size[3],$
                           VALUE     = value_label.value)
                           
units_label = WIDGET_LABEL(input_base,$
                           XOFFSET   = units_label.size[0],$
                           YOFFSET   = units_label.size[1],$
                           SCR_YSIZE = name_value.size[3],$
                           VALUE     = units_label.value)

original_label = WIDGET_LABEL(input_base,$
                              XOFFSET   = original_label.size[0],$
                              YOFFSET   = original_label.size[1],$
                              SCR_YSIZE = name_value.size[3],$
                              VALUE     = original_label.value)

original_value_label = WIDGET_LABEL(input_base,$
                                    XOFFSET   = original_value_label.size[0],$
                                    YOFFSET   = original_value_label.size[1],$
                                    SCR_XSIZE = original_value_label.size[2],$
                                    SCR_YSIZE = original_value_label.size[3],$
                                    VALUE     = '',$
                                    FRAME     = 1)

original_units_label = WIDGET_LABEL(input_base,$
                                    XOFFSET   = original_units_label.size[0],$
                                    YOFFSET   = original_units_label.size[1],$
                                    SCR_XSIZE = original_units_label.size[2],$
                                    SCR_YSIZE = original_units_label.size[3],$
                                    VALUE     = '',$
                                    FRAME     = 1)

current_label = WIDGET_LABEL(input_base,$
                              XOFFSET   = current_label.size[0],$
                              YOFFSET   = current_label.size[1],$
                              SCR_YSIZE = name_value.size[3],$
                              VALUE     = current_label.value)

value_base = WIDGET_BASE(input_base,$
                         XOFFSET   = current_value_base.size[0],$
                         YOFFSET   = current_value_base.size[1],$
                         SCR_XSIZE = current_value_base.size[2],$
                         SCR_YSIZE = current_value_base.size[3])

field1 = CW_FIELD(value_base,$
                  XSIZE         = current_value_base.xsize,$
                  UNAME         = current_value_base.uname,$
                  RETURN_EVENTS = 1,$
                  ROW           = 1,$
                  TITLE = '')
                  
units_base = WIDGET_BASE(input_base,$
                         XOFFSET   = current_units_base.size[0],$
                         YOFFSET   = current_units_base.size[1],$
                         SCR_XSIZE = current_units_base.size[2],$
                         SCR_YSIZE = current_units_base.size[3])

field2 = CW_FIELD(units_base,$
                  XSIZE         = current_units_base.xsize,$
                  UNAME         = current_units_base.uname,$
                  RETURN_EVENTS = 1,$
                  ROW           = 1,$
                  TITLE = '')
                  
                                 




                     

END
