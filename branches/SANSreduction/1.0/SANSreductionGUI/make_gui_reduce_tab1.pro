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

PRO make_gui_reduce_tab1, REDUCE_TAB, tab_size, tab_title

;- Define Main Base of Reduce Tab 1 --------------------------------------------
sBaseTab1 = { size:  tab_size,$
              uname: 'reduce_tab1_base',$
              title: tab_title}

;- Data File Frame -------------------------------------------------------------
sDataFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                  main_base_uname: 'data_base_uname',$
                  xoff:            0,$
                  yoff:            5,$
                  frame_title:     'Data File',$
                  label_1:         'Run Number:',$
                  tf1_uname:       'data_run_number_cw_field',$
                  browse_uname:    'data_browse_button',$
                  file_name_uname: 'data_file_name_text_field'}

yoff = 70
;- Solvant Buffer Only ---------------------------------------------------------
sSolvantFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                     main_base_uname: 'solvant_base_uname',$
                     xoff:            0,$
                     yoff:            sDataFileFrame.yoff+yoff,$
                     frame_title:     'Solvant Buffer Only',$
                     label_1:         'Run Number:',$
                     tf1_uname:       'solvant_run_number_cw_field',$
                     browse_uname:    'solvant_browse_button',$
                     file_name_uname: 'solvant_file_name_text_field'}

;- Empty Can -------------------------------------------------------------------
sEmptyFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                   main_base_uname: 'empty_base_uname',$
                   xoff:            0,$
                   yoff:            sSolvantFileFrame.yoff+yoff,$
                   frame_title:     'Empty Can',$
                   label_1:         'Run Number:',$
                   tf1_uname:       'empty_run_number_cw_field',$
                   browse_uname:    'empty_browse_button',$
                   file_name_uname: 'empty_file_name_text_field'}

;- Open beam -------------------------------------------------------------------
sOpenFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                  main_base_uname: 'open_beam_base_uname',$
                  xoff:            0,$
                  yoff:            sEmptyFileFrame.yoff+yoff,$
                  frame_title:     'Open Beam (shutter open)',$
                  label_1:         'Run Number:',$
                  tf1_uname:       'open_run_number_cw_field',$
                  browse_uname:    'open_browse_button',$
                  file_name_uname: 'open_file_name_text_field'}

;- Dark Current ----------------------------------------------------------------
sDarkFileFrame = {main_base_xsize: sBaseTab1.size[2],$
                  main_base_uname: 'dark_beam_base_uname',$
                  xoff:            0,$
                  yoff:            sOpenFileFrame.yoff+yoff,$
                  frame_title:     'Dark Current (shutter closed)',$
                  label_1:         'Run Number:',$
                  tf1_uname:       'dark_run_number_cw_field',$
                  browse_uname:    'dark_browse_button',$
                  file_name_uname: 'dark_file_name_text_field'}

;===============================================================================
;= Build Widgets ===============================================================
BaseTab1 = WIDGET_BASE(REDUCE_TAB,$
                       UNAME     = sBaseTab1.uname,$
                       XOFFSET   = sBaseTab1.size[0],$
                       YOFFSET   = sBaseTab1.size[1],$
                       SCR_XSIZE = sBaseTab1.size[2],$
                       SCR_YSIZE = sBaseTab1.size[3],$
                       TITLE     = sBaseTab1.title)

;- Data File Frame -------------------------------------------------------------
cDataFileFrame = OBJ_NEW('IDLnexusFrame',$
                         MAIN_BASE_ID    = BaseTab1,$
                         MAIN_BASE_XSIZE = sDataFileFrame.main_base_xsize,$
                         MAIN_BASE_UNAME = sDataFileFrame.main_base_uname,$
                         XOFF            = sDataFileFrame.xoff,$
                         YOFF            = sDataFileFrame.yoff,$
                         FRAME_TITLE     = sDataFileFrame.frame_title,$
                         LABEL_1         = sDataFileFrame.label_1,$
                         CWFIELD_UNAME   = sDataFileFrame.tf1_uname,$
                         BROWSE_UNAME    = sDataFileFrame.browse_uname,$
                         FILE_NAME_UNAME = sDataFileFrame.file_name_uname)

;- Solvant Buffer Only ---------------------------------------------------------
cSolvantFileFrame = OBJ_NEW('IDLnexusFrame',$
                            MAIN_BASE_ID    = BaseTab1,$
                            MAIN_BASE_XSIZE = sSolvantFileFrame.main_base_xsize,$
                            MAIN_BASE_UNAME = sSolvantFileFrame.main_base_uname,$
                            XOFF            = sSolvantFileFrame.xoff,$
                            YOFF            = sSolvantFileFrame.yoff,$
                            FRAME_TITLE     = sSolvantFileFrame.frame_title,$
                            LABEL_1         = sSolvantFileFrame.label_1,$
                            CWFIELD_UNAME   = sSolvantFileFrame.tf1_uname,$
                            BROWSE_UNAME    = sSolvantFileFrame.browse_uname,$
                            FILE_NAME_UNAME = sSolvantFileFrame.file_name_uname)

;- Empty Can -------------------------------------------------------------------
cEmptyFileFrame = OBJ_NEW('IDLnexusFrame',$
                          MAIN_BASE_ID    = BaseTab1,$
                          MAIN_BASE_XSIZE = sEmptyFileFrame.main_base_xsize,$
                          MAIN_BASE_UNAME = sEmptyFileFrame.main_base_uname,$
                          XOFF            = sEmptyFileFrame.xoff,$
                          YOFF            = sEmptyFileFrame.yoff,$
                          FRAME_TITLE     = sEmptyFileFrame.frame_title,$
                          LABEL_1         = sEmptyFileFrame.label_1,$
                          CWFIELD_UNAME   = sEmptyFileFrame.tf1_uname,$
                          BROWSE_UNAME    = sEmptyFileFrame.browse_uname,$
                          FILE_NAME_UNAME = sEmptyFileFrame.file_name_uname)

;- Open beam -------------------------------------------------------------------
cOpenFileFrame = OBJ_NEW('IDLnexusFrame',$
                         MAIN_BASE_ID    = BaseTab1,$
                         MAIN_BASE_XSIZE = sOpenFileFrame.main_base_xsize,$
                         MAIN_BASE_UNAME = sOpenFileFrame.main_base_uname,$
                         XOFF            = sOpenFileFrame.xoff,$
                         YOFF            = sOpenFileFrame.yoff,$
                         FRAME_TITLE     = sOpenFileFrame.frame_title,$
                         LABEL_1         = sOpenFileFrame.label_1,$
                         CWFIELD_UNAME   = sOpenFileFrame.tf1_uname,$
                         BROWSE_UNAME    = sOpenFileFrame.browse_uname,$
                         FILE_NAME_UNAME = sOpenFileFrame.file_name_uname)

;- Dark Current ----------------------------------------------------------------
cDarkFileFrame = OBJ_NEW('IDLnexusFrame',$
                         MAIN_BASE_ID    = BaseTab1,$
                         MAIN_BASE_XSIZE = sDarkFileFrame.main_base_xsize,$
                         MAIN_BASE_UNAME = sDarkFileFrame.main_base_uname,$
                         XOFF            = sDarkFileFrame.xoff,$
                         YOFF            = sDarkFileFrame.yoff,$
                         FRAME_TITLE     = sDarkFileFrame.frame_title,$
                         LABEL_1         = sDarkFileFrame.label_1,$
                         CWFIELD_UNAME   = sDarkFileFrame.tf1_uname,$
                         BROWSE_UNAME    = sDarkFileFrame.browse_uname,$
                         FILE_NAME_UNAME = sDarkFileFrame.file_name_uname)




END
