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

PRO NexusInterface, BASE_UNAME = base_uname,$
                BROWSE_BUTTON_UNAME = browse_button_uname,$
                RUN_NBR_UNAME = run_nbr_uname,$
                ARCHIVED_ALL_UNAME = archived_all_uname,$
                PROPOSAL_BUTTON_UNAME = proposal_button_uname,$
                PROPOSAL_BASE_UNAME = proposal_base_uname,$
                PROPOSAL_FOLDER_DROPLIST_UNAME = proposal_folder_droplist_uname,$
                SAVE_AS_JPEG_UNAME = save_as_jpeg_uname,$
                PLOT_BUTTON_UNAME = plot_button_uname
                
NexusBase = WIDGET_BASE(BASE_UNAME,$
                        XOFFSET = 10,$
                        /ROW)
                        
;Browse Nexus File Button
Button = WIDGET_BUTTON(NexusBase,$
                       SCR_XSIZE = 70,$
                       VALUE     = 'BROWSE...',$
                       UNAME     = BROWSE_BUTTON_UNAME)

label = WIDGET_LABEL(NexusBase,$
                     VALUE = ' OR   Run #')
                     
runNbr = WIDGET_TEXT(NexusBase,$
                     XSIZE = 10,$
                     /EDITABLE,$ 
                     UNAME = RUN_NBR_UNAME)
                      
;Archived or All NeXus list
group = CW_BGROUP(NexusBase,$
            ['Archived.','All NeXus'],$
            UNAME     = ARCHIVED_ALL_UNAME,$
            ROW       = 1,$
            SET_VALUE = 0,$
            /EXCLUSIVE)

;space
label = WIDGET_LABEL(NexusBase,$
                     VALUE = '')
                     
;with proposal base                     
ProBase = WIDGET_BASE(NexusBase,$
                      /NONEXCLUSIVE,$
                      /ROW)
                      
ProButton = WIDGET_BUTTON(ProBase,$
                          VALUE = 'Specify Proposal:',$
                          UNAME = PROPOSAL_BUTTON_UNAME)

;proposal folder base
ProFoldBase = WIDGET_BASE(NexusBase,$
                          UNAME = PROPOSAL_BASE_UNAME,$
                          SENSITIVE = 0)

;droplist
droplist = WIDGET_DROPLIST(ProFoldBase,$
                           VALUE = ['   Select Me ...         '],$
                           SCR_YSIZE = 25,$
                           UNAME = PROPOSAL_FOLDER_DROPLIST_UNAME)

;Save As Jpeg Button ----------------------------------------------------------
button = WIDGET_BUTTON(NexusBase,$
                       UNAME = SAVE_AS_JPEG_UNAME,$
                       VALUE   = 'REFreduction_images/SaveAsJpeg.bmp',$
                       TOOLTIP = 'Create a JPEG of the plot',$
                       SENSITIVE = 0,$
                       /BITMAP)

;------------------------------------------------------------------------------
;Advanced plot
button = WIDGET_BUTTON(NexusBase,$
                       UNAME = PLOT_BUTTON_UNAME,$
                       VALUE   = 'REFreduction_images/advanced_plot.bmp',$
                       TOOLTIP = 'Open the Advanced Plot Tool',$
                       SENSITIVE = 0,$
                       /BITMAP)

END