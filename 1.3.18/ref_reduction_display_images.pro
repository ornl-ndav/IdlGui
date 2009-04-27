;==============================================================================
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
;==============================================================================

;display empty cell images ----------------------------------------------------
PRO display_images, MAIN_BASE, global

  ;get images files
  sImages = (*(*global).empty_cell_images)
  
  ;background image
  draw1 = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='confuse_background')
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.confuse_background)
  TV, image, 0,0,/true
  
  ;empty cell image
  empty_cell_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='empty_cell_draw')
  WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.empty_cell)
  TV, image, 0,0,/true
  
  ;data background image
  data_background_draw = WIDGET_INFO(MAIN_BASE, $
    FIND_BY_UNAME='data_background_draw')
  WIDGET_CONTROL, data_background_draw, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.data_background)
  TV, image, 0,0,/true
  
  ;display equation of Scalling factor in Empty Cell tab
  draw1 = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scaling_factor_equation_draw')
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  image = READ_PNG((*global).sf_equation_file)
  TV, image, 0,0,/true
  
END