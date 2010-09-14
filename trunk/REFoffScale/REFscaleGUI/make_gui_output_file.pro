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

PRO MakeGuiOutputFile, STEPS_TAB, Step1Size
                       
OutputFileNameLabelStaticSize  = [5,8]
OutputfileNameLabelDynamicSize = [115,3,400]

OutputFileTextFieldsize        = [ 5, 5+38, 515, 365-35]
OutputFileTitle                = 'OUTPUT FILE'
OutputFileNameLabelStaticTitle = 'Output file name:'

;Build GUI
OutputFile_BASE = WIDGET_BASE(STEPS_TAB,$
                              UNAME     = 'output_file_base',$
                              TITLE     = OutputFileTitle,$
                              XOFFSET   = Step1Size[0],$
                              YOFFSET   = Step1Size[1],$
                              SCR_XSIZE = Step1Size[2],$
                              SCR_YSIZE = Step1Size[3],$
                              MAP       = 1)

OutputFileNameLabelStatic = $
  WIDGET_LABEL(OutputFile_base,$
               XOFFSET = OutputFileNameLabelStaticSize[0],$
               YOFFSET = OutputFileNameLabelStaticSize[1],$
               VALUE   = OutputFileNameLabelStaticTitle)

OutputFileNameLabelDynamic = $
  WIDGET_TEXT(OutputFile_base,$
              XOFFSET   = OutputFileNameLabelDynamicSize[0],$
              YOFFSET   = OutputFileNameLabelDynamicSize[1],$
              SCR_XSIZE = OutputFileNameLabelDynamicSize[2],$
              UNAME     = 'output_file_name_label_dynmaic',$
              VALUE     = '',$
              FRAME     = 1,$
              /EDITABLE,$
              /ALIGN_LEFT)

OutputFileTextfield = WIDGET_TEXT(OutputFile_base,$
                                  UNAME     = 'output_file_text_field',$
                                  XOFFSET   = OutputFileTextFieldSize[0],$
                                  YOFFSET   = OutputFileTextFieldSize[1],$
                                  SCR_XSIZE = OutputFileTextFieldSize[2],$
                                  SCR_YSIZE = OutputFileTextFieldsize[3],$
                                  /SCROLL)
                                  
END

;------------------------------------------------------------------------------
PRO make_gui_output_file
END
