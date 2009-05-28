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

PRO MAIN_BASE_event, Event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    ;-------------------------------------------------------------------------------
    ;Tab Event (Histo - Nexus)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='histo_nexus_tab'): begin
      TabEventcb, Event ;_eventcb
    end
    
    ;-------------------------------------------------------------------------------
    ;'Run #' cw_field in INPUT base
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number'): begin
      WIDGET_CONTROL,/HOURGLASS
      InputRunNumber, Event  
      ActivateHistoMappingBasesStatus, Event 
      GetHistogramInfo, Event 
      ActivateOrNotCreateHistogramMapped, Event 
      ActivateOrNotPlotButton, Event 
      WIDGET_CONTROL,HOURGLASS=0
    end
    
    ;'BROWSE EVENT FILE' button in INPUT base
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_event_file_button'): begin
      BrowseEventRunNumber, Event ;in plot_arcs_Browse.pro
      ActivateHistoMappingBasesStatus, Event ;in plot_arcs_GUIupdate.pro
      GetHistogramInfo, Event ;in plot_arcs_CollectHistoInfo.pro
      ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
    end
    
    ;preview runinfo file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_runinfo_file'): begin
      PreviewRuninfoFile, Event ;in plot_arcs_PreviewRuninfoFile.pro
    end
    
    ;'Event File' widget_text in INPUT base
    WIDGET_INFO(wWidget, FIND_BY_UNAME='event_file'): begin
      putTextInTextField, Event, 'histo_mapped_text_field', ''
      ActivateOrNotPlotButton, Event ;in plot_arcs_GUIupdate.pro
      ActivateHistoMappingBaseFromWidgetText, Event ;in plot_arcs_GUIupdate.pro
      ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
      GetHistogramInfo, Event ;in plot_arcs_CollectHistoInfo.pro
    end
    
    ;'max_time_bin'
    WIDGET_INFO(wWidget, FIND_BY_UNAME='max_time_bin'): begin
      ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
    end
    
    ;'bin_width'
    WIDGET_INFO(wWidget, FIND_BY_UNAME='bin_width'): begin
      ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
    end
    
    ;create_histo_mapped_button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='create_histo_mapped_button'): begin
      CreateHistoMapped, Event ;in plot_arcs_CreateHistoMapped.pro
    end
    
    ;'BROWSE HISTO FILE' button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_histo_mapped_button'): begin
      BrowseHistoFile, Event ;in plot_arcs_Browse.pro
      ActivateOrNotPlotButton, Event ;in plot_arcs_GUIupdate.pro
    end
    
    ;'histo_mapped text_field'
    WIDGET_INFO(wWidget, FIND_BY_UNAME='histo_mapped_text_field'): begin
      ActivateOrNotPlotButton, Event ;in plot_arcs_GUIupdate.pro
    end
    
    ;SAVE AS button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_as_histo_mapped_button'): begin
      SaveAsHistoMappedFile, Event ;in plot_arcs_SaveAsHistoMapped.pro
    end
    
    ;send to geek button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): begin
      LogBook, Event ;in plot_arcs_SendToGeek.pro
    end
    
    ;-------------------------------------------------------------------------------
    ;***** NeXus Tab ***************************************************************
    ;-------------------------------------------------------------------------------
    ;Run Number CW_FIELD
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number_cw_field'): begin
      RetrieveFullNexusFileName, Event ;_Nexus
      ActivateOrNotPlotButton_from_NexusTab, Event
    end
    
    ;Archived or ListAll
    WIDGET_INFO(wWidget, FIND_BY_UNAME='archived_or_list_all'): begin
      ArchivedOrListAll, Event ;_Nexus
      ActivateOrNotPlotButton_from_NexusTab, Event
    end
    
    ;Browse Nexus
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_nexus_button'): begin
      BrowseNexus, Event ;_Nexus
      ActivateOrNotPlotButton_from_NexusTab, Event
    end
    
    ;-------------------------------------------------------------------------------
    ;***** PLOT BUTTON *************************************************************
    ;-------------------------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_button'): begin
      LaunchPlot, Event     ;_eventcb
    end
    
    ELSE:
    
  ENDCASE
  
END
