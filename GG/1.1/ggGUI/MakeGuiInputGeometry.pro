;===============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;===============================================================================

PRO MakeGuiInputGeometry, MAIN_BASE, MainBaseSize, images_structure

;***********************************************************************************
;                           Define size arrays
;***********************************************************************************

base = { size  : [0,0,MainBaseSize[2:3]],$
         uname : 'input_geometry_base'} 

;////////////
;tree widget/
;////////////
tree_widget = { size  : [0,0,200,MainBaseSize[3]-120],$
                uname : 'tree_widget'}


;//////////////////
;Main button panel/
;//////////////////
XYoff = [0,MainBaseSize[3]-120]
full_reset = { size  : [XYoff[0], $
                        XYoff[1], $
                        tree_widget.size[2], $
                        30],$
               value : 'FULL RESET',$
               uname : 'full_reset_button'}

XYoff = [0,30]
load_new_geometry = { size  : [full_reset.size[0]+XYoff[0],$
                               full_reset.size[1]+XYoff[1],$
                               full_reset.size[2],$
                               full_reset.size[3]],$
                      value : 'LOAD NEW BASE GEOMETRY',$
                      uname : 'load_new_geometry_button'}

create_geometry = { size  : [full_reset.size[0]+XYoff[0],$
                             load_new_geometry.size[1]+XYoff[1],$
                             full_reset.size[2],$
                             full_reset.size[3]],$
                    value : 'CREATE GEOMETRY FILE',$
                    uname : 'create_geometry_file_button'}
                            
check_error_log = { size      : [full_reset.size[0]+XYoff[0],$
                                 create_geometry.size[1]+XYoff[1],$
                                 full_reset.size[2],$
                                 full_reset.size[3]],$
                    value     : 'ERROR LOG BOOK',$
                    sensitive : 0,$
                    uname     : 'check_error_log_button'}
                            
;/////////////
;table widget/
;/////////////
table_widget = { size         : [200,0,500,300,4,50],$
                 uname        : 'table_widget',$
                 label        : ['STATUS','N A M E','VALUE','UNITS'],$
                 column_width : [60,180,120,110]}

;///////////
;Input base/
;///////////
input_base = { size  : [200,300,500,200],$
               uname : 'input_base'}
name_label = { size  : [5,0,60,30],$
               value : 'N A M E :'}
XYoff = [80,0]
name_value = { size : [name_label.size[0]+XYoff[0],$
                       name_label.size[1]+XYoff[1],$
                       150,$
                       30],$
               uname : 'name_value'}
XYoff = [5,35]
original_label = { size : [name_value.size[0]+XYoff[0],$
                           name_value.size[1]+XYoff[1]],$
                   value : 'Setpoint:'}

XYoff = [0,45]
readback_label = { size : [original_label.size[0]+XYoff[0],$
                           original_label.size[1]+XYoff[1]],$
                   value : 'Readback:'}

XYoff = [0,45]
current_label  = { size : [readback_label.size[0]+XYoff[0],$
                           readback_label.size[1]+XYoff[1]],$
                   value : 'Value:'}

XYoff = [80,0]
original_value_label = { size : [original_label.size[0]+XYoff[0],$
                                 original_label.size[1]+XYoff[1],$
                                 130,30],$
                         uname : 'setpoint_value_label'}
XYoff = [160,0]
original_units_label = { size : [original_value_label.size[0]+XYoff[0],$
                                 original_value_label.size[1]+XYoff[1],$
                                 130,30],$
                         uname : 'setpoint_units_label'}
XYoff = [80,0]
readback_value_label = { size : [readback_label.size[0]+XYoff[0],$
                                 readback_label.size[1]+XYoff[1],$
                                 130,30],$
                         uname : 'readback_value_label'}
XYoff = [160,0]
readback_units_label = { size : [readback_value_label.size[0]+XYoff[0],$
                                 readback_value_label.size[1]+XYoff[1],$
                                 130,30],$
                         uname : 'readback_units_label'}

XYoff = [75,-5]
current_value_base = { size : [current_label.size[0]+XYoff[0],$
                               current_label.size[1]+XYoff[1],$
                               150,40],$
                       base_uname : 'current_value_text_base',$
                       xsize : 20,$
                       uname : 'current_value_text_field'}

XYoff = [235,-5]
current_units_base = { size : [current_label.size[0]+XYoff[0],$
                               current_label.size[1]+XYoff[1],$
                               150,40],$
                       base_uname : 'current_units_text_base',$
                       xsize : current_value_base.xsize,$
                       uname : 'current_units_text_field'}

reset_button = { size  : [35,165,80,30],$
                 value : 'RESET',$
                 uname : 'reset_selected_element_button'}

XYoff = [138,0]
validate_button = {size  : [reset_button.size[0]+XYoff[0],$
                            reset_button.size[1]+XYoff[1],$
                            290,30],$
                   value : 'VALIDATE CHANGES',$
                   uname : 'validate_selected_element_button'}

;***********************************************************************************
;                                Build GUI
;***********************************************************************************
base = WIDGET_BASE(MAIN_BASE,$
                   UNAME     = base.uname,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = base.size[2],$
                   SCR_YSIZE = base.size[3],$
                   map=0) ;remove 1 and put 0 back

;\\\\\\\\\\\\
;tree widget\
;\\\\\\\\\\\\
wTree = WIDGET_TREE(base,$
                    XOFFSET   = tree_widget.size[0],$
                    YOFFSET   = tree_widget.size[1],$
                    SCR_XSIZE = tree_widget.size[2],$
                    SCR_YSIZE = tree_widget.size[3],$
                    UNAME     = tree_widget.uname,$
                    SENSITIVE = 0)

                   
wtRoot = WIDGET_TREE(wTree,$
                     VALUE = 'Types',$
                     /FOLDER,$
                     /EXPANDED,$
                     UNAME = 'widget_tree_root')


file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[0]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf1 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'number',$
                      UVALUE = 'LEAF',$
                      BITMAP = myIcon2,$
                      UNAME  = 'leaf1')

file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[1]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf2 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'angle',$
                      UVALUE = 'LEAF',$
                      BITMAP = myIcon2,$
                      UNAME  = 'leaf2')

file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[2]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf3 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'length',$
                      UVALUE = 'LEAF',$
                      BITMAP = myIcon2,$
                      UNAME  = 'leaf3')


file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[3]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf4 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'wavelength',$
                      UVALUE = 'LEAF',$
                      BITMAP = myIcon2,$
                      UNAME  = 'leaf4')

file = strjoin(images_structure.images_path,'/')
file += '/' + images_structure.images[4]
myIcon1 = READ_BMP(file)
myIcon2 = bytarr(16,16,3,/nozero)
myIcon2[*,*,0] = myIcon1[0,*,*]
myIcon2[*,*,1] = myIcon1[1,*,*]
myIcon2[*,*,2] = myIcon1[2,*,*]
wtLeaf5 = WIDGET_TREE(wtRoot,$
                      VALUE  = 'other',$
                      UVALUE = 'LEAF',$
                      BITMAP = MYICON2,$
                      UNAME  = 'leaf5')

;\\\\\\\\\\\\\\\\\\
;Main button panel\
;\\\\\\\\\\\\\\\\\\
button1 = WIDGET_BUTTON(base,$
                        XOFFSET   = full_reset.size[0],$
                        YOFFSET   = full_reset.size[1],$
                        SCR_XSIZE = full_reset.size[2],$
                        SCR_YSIZE = full_reset.size[3],$
                        VALUE     = full_reset.value,$
                        UNAME     = full_reset.uname)

button2 = WIDGET_BUTTON(base,$
                        XOFFSET   = load_new_geometry.size[0],$
                        YOFFSET   = load_new_geometry.size[1],$
                        SCR_XSIZE = load_new_geometry.size[2],$
                        SCR_YSIZE = load_new_geometry.size[3],$
                        VALUE     = load_new_geometry.value,$
                        UNAME     = load_new_geometry.uname)

button3 = WIDGET_BUTTON(base,$
                        XOFFSET   = create_geometry.size[0],$
                        YOFFSET   = create_geometry.size[1],$
                        SCR_XSIZE = create_geometry.size[2],$
                        SCR_YSIZE = create_geometry.size[3],$
                        VALUE     = create_geometry.value,$
                        UNAME     = create_geometry.uname)

button4 = WIDGET_BUTTON(base,$
                        XOFFSET   = check_error_log.size[0],$
                        YOFFSET   = check_error_log.size[1],$
                        SCR_XSIZE = check_error_log.size[2],$
                        SCR_YSIZE = check_error_log.size[3],$
                        VALUE     = check_error_log.value,$
                        SENSITIVE = check_error_log.sensitive,$
                        UNAME     = check_error_log.uname)
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
                     SENSITIVE     = 0,$
                     /NO_ROW_HEADERS,$
                     /ROW_MAJOR,$
                     /RESIZEABLE_COLUMNS,$
                     /ALL_EVENTS)

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
                     VALUE     = '',$
                     /ALIGN_LEFT)

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
                                    UNAME     = original_value_label.uname,$
                                    VALUE     = '',$
                                    FRAME     = 1)

original_units_label = WIDGET_LABEL(input_base,$
                                    XOFFSET   = original_units_label.size[0],$
                                    YOFFSET   = original_units_label.size[1],$
                                    SCR_XSIZE = original_units_label.size[2],$
                                    SCR_YSIZE = original_units_label.size[3],$
                                    UNAME     = original_units_label.uname,$
                                    VALUE     = '',$
                                    FRAME     = 1)

readback_label = WIDGET_LABEL(input_base,$
                              XOFFSET   = readback_label.size[0],$
                              YOFFSET   = readback_label.size[1],$
                              SCR_YSIZE = name_value.size[3],$
                              VALUE     = readback_label.value)

readback_value_label = WIDGET_LABEL(input_base,$
                                    XOFFSET   = readback_value_label.size[0],$
                                    YOFFSET   = readback_value_label.size[1],$
                                    SCR_XSIZE = readback_value_label.size[2],$
                                    SCR_YSIZE = readback_value_label.size[3],$
                                    UNAME     = readback_value_label.uname,$
                                    VALUE     = '',$
                                    FRAME     = 1)

readback_units_label = WIDGET_LABEL(input_base,$
                                    XOFFSET   = readback_units_label.size[0],$
                                    YOFFSET   = readback_units_label.size[1],$
                                    SCR_XSIZE = readback_units_label.size[2],$
                                    SCR_YSIZE = readback_units_label.size[3],$
                                    UNAME     = readback_units_label.uname,$
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
                         SCR_YSIZE = current_value_base.size[3],$
                         SENSITIVE = 0,$
                         UNAME     = current_value_base.base_uname)

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
                         SCR_YSIZE = current_units_base.size[3],$
                         SENSITIVE = 0,$
                         UNAME     = current_units_base.base_uname)

field2 = CW_FIELD(units_base,$
                  XSIZE         = current_units_base.xsize,$
                  UNAME         = current_units_base.uname,$
                  RETURN_EVENTS = 1,$
                  ROW           = 1,$
                  TITLE = '')

button = WIDGET_BUTTON(input_base,$
                       XOFFSET   = reset_button.size[0],$
                       YOFFSET   = reset_button.size[1],$
                       SCR_XSIZE = reset_button.size[2],$
                       SCR_YSIZE = reset_button.size[3],$
                       VALUE     = reset_button.value,$
                       UNAME     = reset_button.uname,$
                       SENSITIVE = 0)
                  
button = WIDGET_BUTTON(input_base,$
                       XOFFSET   = validate_button.size[0],$
                       YOFFSET   = validate_button.size[1],$
                       SCR_XSIZE = validate_button.size[2],$
                       SCR_YSIZE = validate_button.size[3],$
                       VALUE     = validate_button.value,$
                       UNAME     = validate_button.uname,$
                       SENSITIVE = 0)
                  
END
