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

FUNCTION getSubstrateType

NbrEntries = 4

SubstrateType = { type_name: '',$
                  a:         '',$
                  b:         '',$
                  d:         '5'}

mySubstrateType = REPLICATE(SubstrateType, NbrEntries)

;Silicon
mySubstrateType[0].type_name = 'Si'
mySubstrateType[0].a         = '2.00E-4'  ;cm^-1
mySubstrateType[0].b         = '4.75E5'   ;cm^-2

;SiO2
mySubstrateType[1].type_name = 'SiO2'
mySubstrateType[1].a         = '1.49E-4'
mySubstrateType[1].b         = '2.53E5'

;Al2O3
mySubstrateType[2].type_name = 'Al2O3'
mySubstrateType[2].a         = '4.47E-4'
mySubstrateType[2].b         = '6.12E5'

;TiO2
mySubstrateType[3].type_name = 'TiO2'
mySubstrateType[3].a         = '1.14E-1'
mySubstrateType[3].b         = '1.35E-1'

;name#4
;mySubstrateType[4].type_name = 'name#4'
;mySubstrateType[4].a         = 'N/A'
;mySubstrateType[4].b         = 'N/A'

RETURN, mySubstrateType
END

;------------------------------------------------------------------------------
FUNCTION getEmptyCellImages

folder = 'REFreduction_images/'

sImages = { confuse_background: folder + 'confuse_background.png',$
            data_background: folder + 'data_background.png',$
            data_background_mouse_over: folder + $
            'data_background_mouse_over.png',$
            data_background_mouse_click: folder + $
            'data_background_mouse_click.png',$
            empty_cell: folder + $
            'empty_cell.png',$
            empty_cell_mouse_over: folder + $
            'empty_cell_mouse_over.png',$
            empty_cell_mouse_click: folder + $
            'empty_cell_mouse_click.png'}

RETURN, sImages
END

;------------------------------------------------------------------------------
FUNCTION getDebuggingStructure

debugging_structure = {nbr_pola_state:1,$
                       working_path: $
                       '~/SVN/IdlGui/branches/REFreduction/1.3/',$
                       working_path_onMac: $
                       '~/SVN/IdlGui/branches/REFreduction/1.3/',$
                       data_nexus_full_path: '/Users/jeanbilheux/' + $
                       '/REF_M_4585.nxs',$
                       full_list_OF_nexus: ['/SNS/users/j35/REF_M_4117.nxs',$
                                            '/SNS/users/j35/REF_M_4117.nxs'],$
                       list_pola_state: ['entry-Off_Off',$
                                         'entry-Off_On',$
                                         'entry-On_Off',$
                                         'entry-On_On']}

RETURN, debugging_structure
END
