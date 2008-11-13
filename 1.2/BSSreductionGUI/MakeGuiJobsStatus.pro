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

PRO MakeGuiJobsStatus, MAIN_TAB, MainTabSize, JobManagerTitle, MAIN_BASE
WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global

;******************************************************************************
;                             Define size arrays
;******************************************************************************

;Refresh list of jobs button...................................................
XYoff = [5,5]
sRefreshB = { size: [XYoff[0],$
                     XYoff[1],$
                     505],$
              value: 'R E F R E S H   L I S T   O F   J O B S',$
              uname: 'refresh_list_of_jobs_button'}

;Base that will contain the widget_tree .......................................
XYoff = [0,30]
sTreeBase = { size: [sRefreshB.size[0]+XYoff[0],$
                     sRefreshB.size[1]+XYoff[1],$
                     500,660],$
              frame: 1,$
              uname: 'list_of_jobs_tree_base'}

;Base that will contain the metadata for the selected jobs ....................
XYoff  = [10,10]
offset = -40
sMetadataBase = { size: [sTreeBase.size[0]+$
                         sTreeBase.size[2]+$
                         XYoff[0],$
                         XYoff[1],$
                         MainTabSize[2]-sTreeBase.size[2]+XYoff[0]+offset,$
                         615],$
                  uname: 'metadata_base',$
                  frame: 1}

XYoff      = [0,0]
NbrColumn  = 2
NbrRow     = 110
RowAlign   = [0,0]
TableAlign = INTARR(NbrColumn, NbrRow)
FOR i=0,(NbrRow-1) DO BEGIN
    TableAlign(*,i) = RowAlign
ENDFOR
sTable = { size: [XYoff[0],$
                  XYoff[1],$
                  sMetadataBase.size[2],$
                  sMetadataBase.size[3],$
                  NbrColumn,$
                  NbrRow],$
           uname: 'job_status_table',$
           sensitive: 1,$
           label: ['FIELD NAME','FIELD VALUE'],$
           align: TableAlign,$
           column_width: [300,400]}

;Base output file name ........................................................
XYoff = [2,10]
sOutputBase = { size: [sMetadataBase.size[0]+XYoff[0],$
                       sMEtadataBase.size[1]+$
                       sMetadataBase.size[3]+XYoff[1],$
                       sMetadataBase.size[2],$
                       75],$
                uname: 'job_status_output_base',$
                frame: 0}

XYoff = [0,0] ;output path button
sOutputPath = { size: [XYoff[0],$
                       XYoff[1],$
                       670],$
                value: '~/result/',$
                uname: 'job_status_output_path_button'}
                      
XYoff = [0,30] ;output file name text field
sOutputFile = { size: [sOutputPath.size[0]+XYoff[0],$
                       sOutputPath.size[1]+XYoff[1],$
                       500],$
                value: 'N/A',$
                uname: 'job_status_output_file_name_text_field'}

XYoff = [0,0] ;create/plot button
sCreatePlotB = { size: [sOutputFile.size[0]+$
                        sOutputFile.size[2]+$
                        XYoff[0],$
                        sOutputFile.size[1]+$
                        XYoff[1],$
                        170,30],$
                 value: 'CREATE / PLOT',$
                 sensitive: 1,$
                 uname: 'job_status_create_plot_button'}

;******************************************************************************
;                                Build GUI
;******************************************************************************
Base = WIDGET_BASE(MAIN_TAB,$
                   XOFFSET   = 0,$
                   YOFFSET   = 0,$
                   SCR_XSIZE = MainTabSize[2],$
                   SCR_YSIZE = MainTabSize[3],$
                   TITLE     = JobManagerTitle,$
                   UNAME     = 'job_manager_base')

;Refresh list of jobs button...................................................
button = WIDGET_BUTTON(Base,$
                       XOFFSET   = sRefreshB.size[0],$
                       YOFFSET   = sRefreshB.size[1],$
                       SCR_XSIZE = sRefreshB.size[2],$
                       VALUE     = sRefreshB.value,$
                       UNAME     = sRefreshB.uname)
                       
;Base that will contain the widget_tree .......................................
TreeBase = WIDGET_BASE(Base,$
                       XOFFSET   = sTreeBase.size[0],$
                       YOFFSET   = sTreeBase.size[1],$
                       SCR_XSIZE = sTreeBase.size[2],$
                       SCR_YSIZE = sTreeBase.size[3],$
                       FRAME     = sTreeBase.frame,$
                       UNAME     = sTreeBase.uname)
(*global).TreeBase = TreeBase

;Base that will contain the metadata for the selected jobs ....................
MetadataBase = WIDGET_BASE(Base,$
                           XOFFSET   = sMetadataBase.size[0],$
                           YOFFSET   = sMetadataBase.size[1],$
                           SCR_XSIZE = sMetadataBase.size[2],$
                           SCR_YSIZE = sMetadataBase.size[3],$
                           UNAME     = sMetadataBase.uname,$
                           FRAME     = sMetadataBase.frame)

wTable = WIDGET_TABLE(MetadataBase,$
                      XOFFSET       = sTable.size[0],$
                      YOFFSET       = sTable.size[1],$
                      SCR_XSIZE     = sTable.size[2],$
                      SCR_YSIZE     = sTable.size[3],$
                      XSIZE         = sTable.size[4],$
                      YSIZE         = sTable.size[5],$
                      UNAME         = sTable.uname,$
                      SENSITIVE     = sTable.sensitive,$
                      COLUMN_LABELS = sTable.label,$
                      COLUMN_WIDTHS = sTable.column_width,$
                      ALIGNMENT     = sTable.align,$
                      /NO_ROW_HEADERS,$
                      /ROW_MAJOR,$
                      /RESIZEABLE_COLUMNS,$
                      /ALL_EVENTS)

;Base output file name ........................................................
Outputbase = WIDGET_BASE(Base,$
                           XOFFSET   = sOutputbase.size[0],$
                           YOFFSET   = sOutputbase.size[1],$
                           SCR_XSIZE = sOutputbase.size[2],$
                           SCR_YSIZE = sOutputbase.size[3],$
                           UNAME     = sOutputbase.uname,$
                           FRAME     = sOutputbase.frame)

;output path button
wOutputPathB = WIDGET_BUTTON(OutputBase,$
                             XOFFSET   = sOutputPath.size[0],$
                             YOFFSET   = sOutputPath.size[1],$
                             SCR_XSIZE = sOutputPath.size[2],$
                             VALUE     = sOutputPath.value,$
                             UNAME     = sOutputPath.uname)

;output file name
wOutputFile = WIDGET_TEXT(OutputBase,$
                          XOFFSET   = sOutputFile.size[0],$
                          YOFFSET   = sOutputFile.size[1],$
                          SCR_XSIZE = sOutputFile.size[2],$
                          VALUE     = sOutputFile.value,$
                          UNAME     = sOutputFile.uname)

;create/plot button
wCreateButton = WIDGET_BUTTON(OutputBase,$
                              XOFFSET   = sCreatePlotB.size[0],$
                              YOFFSET   = sCreatePlotB.size[1],$
                              SCR_XSIZE = sCreatePlotB.size[2],$
                              SCR_YSIZE = sCreatePlotB.size[3],$
                              VALUE     = sCreatePlotB.value,$
                              UNAME     = sCreatePlotB.uname,$
                              SENSITIVE = sCreatePlotB.sensitive)

END
