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

;------------------------------------------------------------------------------
;--- UTILITIES - UTILITIES - UTILITIES - UTILITIES - UTILITIES - UTILITIES ----
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;This function returns the list of proposal number of the given
;instrument
FUNCTION  getListOfProposal, facility, instrument
FileList = FILE_SEARCH('/' + facility + '/' + instrument + '/*', $
                       COUNT= length,$
                       /TEST_DIRECTORY)
ProposalList = STRARR(length+1)
ProposalList[0] = 'PROPOSAL NUMBER UNDEFINED'
FOR i=1,(length) DO BEGIN
    ParseList = STRSPLIT(FileList[i-1],'/',/EXTRACT,COUNT=nbr)
    ProposalList[i] = ParseList[nbr-1]
ENDFOR
RETURN, ProposalList
END
;------------------------------------------------------------------------------

;This is the function launched by the BROWSE NeXus file
FUNCTION BrowseRunNumber, Event, $
                          default_extension, $
                          filter, $
                          title, $
                          GET_PATH = new_path,$
                          path

id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
full_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
                                 FILTER            = filter,$
                                 DIALOG_PARENT     = id,$
                                 TITLE             = title,$
                                 PATH              = path,$
                                 GET_PATH          = new_path,$
                                 /MUST_EXIST)
RETURN, full_file_name
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;This procedure builds the Input frame (instrument..., proposal..., run
;number..., Arhived or ListAll, OR Browse button) 
PRO MakeNexusInputGui, sInput

;==============================================================================
;===== Define Structures ======================================================

;FRAME and main title
XYoff     = [sInput.xoffset, sInput.yoffset]
sFrame    = { size  : [XYoff[0],$
                       XYoff[1],$
                       980,100],$
              frame : 5}
sTitle    = { size  : [sFrame.size[0]+20,$
                       sFrame.size[1]-8],$
              value : 'NeXus Input'}

;Define Proposal Number ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XYoff           = [sInput.xoffset+10, $
                   sInput.yoffset+15]
ListOfProposal  = getListOfProposal(sInput.facility, sInput.instrument)
PropNbrDroplist = { size  : [XYoff[0],$
                             XYoff[1]],$
                    value : ListOfProposal,$
                    uname : 'proposal_droplist'}

;Run Number Input ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XYoff             = [210,0]
RunNumberCwField  = { base_size   : [PropNbrDroplist.size[0]+XYoff[0],$
                                     PropNbrDroplist.size[1]+XYoff[1],$
                                     200,40],$
                      base_uname  : 'run_number_cw_field_base',$
                      title       : 'Run Number:',$
                      field_size  : [15],$
                      field_uname : 'run_number_cw_field'}
 
;Archived or List All ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XYoff            = [5,5]
sArchivedListAll = { base_size  : [RunNumberCwField.base_size[0]+ $
                                   RunNumberCwField.base_size[2]+XYoff[0],$
                                   RunNumberCwField.base_size[1]+XYoff[1],$
                                   170,40],$
                     base_uname : 'archived_or_list_all_base',$
                     value      : ['ARCHIVED','LIST ALL'],$
                     deft_value : 0,$
                     sensitive  : 0,$
                     uname      : 'archived_or_list_all'}

;Or label ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XYoff    = [sArchivedListAll.base_size[0]+180,$
            sArchivedListAll.base_size[1]+5]
sOrLabel = { size  : [XYoff[0],$
                      XYoff[1]],$
             value : 'OR'}

;Browse Button ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XYoff         = [50,0]
sBrowseButton = { size  : [sOrLabel.size[0]+XYoff[0],$
                           PropNbrDroplist.size[1]+XYoff[1],$
                           310,30],$
                  uname : 'browse_nexus_button',$
                  VALUE : 'B R O W S E . . .'}
                      

;Nexus file name label --------------------------------------------------------
XYoff = [10,50]
sNexusLabel = { size: [PropNbrDroplist.size[0]+XYoff[0],$
                       PropNbrDroplist.size[1]+XYoff[1]],$
                value: 'Nexus File Name:'}
XYoff = [110,0]
sNexusNameValue = { size: [sNexusLabel.size[0]+XYoff[0],$
                           sNexusLabel.size[1]+XYoff[1],$
                           835],$
                    value : 'N/A',$
                    uname : 'data_nexus_file_name'}

;==============================================================================
;====== Make GUI ==============================================================

MainBase = sInput.MainBase

;Design PROPOSAL... droplist ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wProposalDroplist = WIDGET_DROPLIST(MainBase,$
                                    UNAME   = PropNbrDroplist.uname,$
                                    VALUE   = PropNbrDroplist.value,$
                                    XOFFSET = PropNbrDroplist.size[0],$
                                    YOFFSET = PropNbrDroplist.size[1],$
                                    /ALIGN_LEFT)

;Run Number Input ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wRunNumberBase = WIDGET_BASE(MainBase,$
                             XOFFSET   = RunNumberCwField.base_size[0],$
                             YOFFSET   = RunNumberCwField.base_size[1],$
                             SCR_XSIZE = RunNumberCwField.base_size[2],$
                             SCR_YSIZE = RunNumberCwField.base_size[3],$
                             UNAME     = RunNumberCwField.base_uname)

wRunNumberField = CW_FIELD(wRunNumberBase,$
                           XSIZE = RunNumberCwField.field_size[0],$
                           TITLE = RunNumberCwField.title,$
                           UNAME = RunNumberCwField.field_uname,$
                           /LONG,$
                           /RETURN_EVENTS)


;Archived or List All ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wArchivedListAll = WIDGET_BASE(MainBase,$
                               XOFFSET   = sArchivedListAll.base_size[0],$
                               YOFFSET   = sArchivedListAll.base_size[1],$
                               SCR_XSIZE = sArchivedListAll.base_size[2],$
                               SCR_YSIZE = sArchivedListAll.base_size[3],$
                               UNAME     = sArchivedListAll.base_uname,$
                               SENSITIVE = sArchivedListAll.sensitive)

wArchivedGroup = CW_BGROUP(wArchivedListAll,$
                           sArchivedListAll.value,$
                           UNAME     = sArchivedListAll.uname,$
                           ROW       = 1,$
                           SET_VALUE = sArchivedListAll.deft_value,$
                           /EXCLUSIVE)

;Or label ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wOrLabel = WIDGET_LABEL(MainBase,$
                        XOFFSET = sOrLabel.size[0],$
                        YOFFSET = sOrLabel.size[1],$
                        VALUE   = sOrLabel.value)

;Browse Button ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wBrowseButton = WIDGET_BUTTON(MainBase,$
                              XOFFSET   = sBrowseButton.size[0],$
                              YOFFSET   = sBrowseButton.size[1],$
                              SCR_XSIZE = sBrowseButton.size[2],$
                              SCR_YSIZE = sBrowseButton.size[3],$
                              UNAME     = sBrowseButton.uname,$
                              VALUE     = sBrowseButton.value)
                                 
;Nexus file name label ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wNexusLabel = WIDGET_LABEL(MainBase,$
                           XOFFSET = sNexusLabel.size[0],$
                           YOFFSET = sNexusLabel.size[1],$
                           VALUE   = sNexusLabel.value)

;Nexus file name value ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wNexusValue = WIDGET_LABEL(MainBase,$
                           XOFFSET   = sNexusNameValue.size[0],$
                           YOFFSET   = sNexusNameValue.size[1],$
                           SCR_XSIZE = sNexusNameValue.size[2],$
                           VALUE     = sNexusNameValue.value,$
                           UNAME     = sNexusNameValue.uname,$
                           /ALIGN_LEFT)

;Frame and Main Title ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wTitle = WIDGET_LABEL(MainBase,$
                      XOFFSET = sTitle.size[0],$
                      YOFFSET = sTitle.size[1],$
                      VALUE   = sTitle.value)

wFrame = WIDGET_LABEL(MainBase,$
                      XOFFSET   = sFrame.size[0],$
                      YOFFSET   = sFrame.size[1],$
                      SCR_XSIZE = sFrame.size[2],$
                      SCR_YSIZE = sFrame.size[3],$
                      VALUE     = '',$
                      FRAME     = sFrame.frame)


END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO MakeStatusGui, sInput
;==============================================================================
;===== Define Structures ======================================================
XYoff     = [3,145]
sFrame    = { size  : [XYoff[0],$
                       XYoff[1],$
                       680,35],$
              frame : 5,$
              uname : 'status_label'}
sTitle    = { size  : [sFrame.size[0]+20,$
                       sFrame.size[1]-8],$
              value : 'Status'}

;==============================================================================
;====== Make GUI ==============================================================
MainBase = sInput.MainBase
wTitle = WIDGET_LABEL(MainBase,$
                      XOFFSET = sTitle.size[0],$
                      YOFFSET = sTitle.size[1],$
                      VALUE   = sTitle.value)

wFrame = WIDGET_LABEL(MainBase,$
                      XOFFSET   = sFrame.size[0],$
                      YOFFSET   = sFrame.size[1],$
                      SCR_XSIZE = sFrame.size[2],$
                      SCR_YSIZE = sFrame.size[3],$
                      VALUE     = '                                     ' + $
                      '    ' + $
                      '                                    ' + $
                      '     ' + $
                      '                                     ' + $
                      '      ',$
                      FRAME     = sFrame.frame,$
                      UNAME     = sFrame.uname)
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;This is where the nexus found is going to be displayed
PRO MakeNexusFileNameGui, sInput

;==============================================================================
;===== Define Structures ======================================================
XYoff     = [sInput.xoffset,sInput.yoffset+140]
sBase     = { size  : [XYoff[0],$
                       XYoff[1],$
                       680,35],$
              uname : 'nexus_file_name_base',$
              frame : 5,$
              map   : 1}

XYoff    = [7,9]
sLabel   = { size  : [XYoff[0],$
                      XYoff[1]],$
             value : 'NeXus File Name:'}

;Archived Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
XYoff         = [105,-8]
sArchivedBase = { size  :  [sLabel.size[0]+XYoff[0],$
                            sLabel.size[1]+XYoff[1],$
                            560,35],$
                  uname : 'archived_base',$
                  map   : 1}
XYoff         = [0,0]
sArchivedLabel = { size  : [XYoff[0],$
                            XYoff[1],$
                            sArchivedBase.size[2],$
                            sArchivedBase.size[3]],$
                   value : '                                          ' + $
                   '      ' + $
                   '                                                    ' + $
                   '     ',$
                   uname : 'archived_text_field'}

;List All Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sListAllBase = { size  : sArchivedBase.size,$
                 uname : 'list_all_base',$
                 map   : 0}
XYoff            = [0,0]
sListallDroplist = { size  : [XYoff[0],$
                              XYoff[1],$
                              350,$
                              sArchivedBase.size[3]],$
                     uname : 'list_all_droplist',$
                     value : ['                                         ' + $
                              '    ' + $
                              '                                      ']}
                              
;==============================================================================
;====== Make GUI ==============================================================
MainBase = sInput.MainBase
;Base ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wBase = WIDGET_BASE(MainBase,$
                    XOFFSET   = sBase.size[0],$
                    YOFFSET   = sBase.size[1],$
                    SCR_XSIZE = sBase.size[2],$
                    SCR_YSIZE = sBase.size[3],$
                    MAP       = sBase.map,$
                    FRAME     = sBase.frame,$
                    UNAME     = sBase.uname)

wLabel = WIDGET_LABEL(wBase,$
                      XOFFSET = sLabel.size[0],$
                      YOFFSET = sLabel.size[1],$
                      VALUE   = sLabel.value)

;Archived Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wArchivedBase = WIDGET_BASE(wBase,$
                            XOFFSET   = sArchivedBase.size[0],$
                            YOFFSET   = sArchivedBase.size[1],$
                            SCR_XSIZE = sArchivedBase.size[2],$
                            SCR_YSIZE = sArchivedBase.size[3],$
                            UNAME     = sArchivedBase.uname,$
                            MAP       = sArchivedBase.map)

wArchivedLabel = WIDGET_LABEL(wArchivedBase,$
                             XOFFSET   = sArchivedLabel.size[0],$
                             YOFFSET   = sArchivedLabel.size[1],$
                             SCR_XSIZE = sArchivedLabel.size[2],$
                             SCR_YSIZE = sArchivedLabel.size[3],$
                             UNAME     = sArchivedLabel.uname,$
                             VALUE     = sArchivedLabel.value,$
                             /ALIGN_LEFT)

;List All Case ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wListAllBase = WIDGET_BASE(wBase,$
                           XOFFSET   = sListAllBase.size[0],$
                           YOFFSET   = sListAllBase.size[1],$
                           SCR_XSIZE = sListAllBase.size[2],$
                           SCR_YSIZE = sListAllBase.size[3],$
                           UNAME     = sListAllBase.uname,$
                           MAP       = sListAllBase.map)

wListAllDroplist = WIDGET_DROPLIST(wListAllBase,$
                                   XOFFSET = sListAllDroplist.size[0],$
                                   YOFFSET = sListAllDroplist.size[1],$
                                   VALUE   = sListAllDroplist.value,$
                                   UNAME   = sListAllDroplist.uname)

END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;sInput = { MainBase   : MAIN_BASE,$
;           xoffset    : xoff,$
;           yoffset    : yoff,$
;           instrument : instrument}
PRO MakeNxSummaryGui, sInput

;==============================================================================
;===== Define Structures ======================================================
XYoff = [sInput.xoffset, sInput.yoffset]
sBase = { size  : [XYoff[0],XYoff[1],685,160],$
          uname : 'nxsummary_base',$
          map   : 0}
sText = { size  : [0,0,sBase.size[2],sBase.size[3]],$
          uname : 'nxsummary_text_field'}

;==============================================================================
;====== Make GUI ==============================================================
MainBase = sInput.MainBase
wBase = WIDGET_BASE(MainBase,$
                    XOFFSET   = sBase.size[0],$
                    YOFFSET   = sBase.size[1],$
                    SCR_XSIZE = sBase.size[2],$
                    SCR_YSIZE = sBase.size[3],$
                    UNAME     = sBase.uname,$
                    MAP       = sBase.map)

wTextField = WIDGET_TEXT(wBase,$
                         XOFFSET   = sText.size[0],$
                         YOFFSET   = sText.size[1],$
                         SCR_XSIZE = sText.size[2],$
                         SCR_YSIZE = sText.size[3],$
                         UNAME     = sText.uname,$
                         /SCROLL,$
                         /WRAP)
END

 ;*****************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLloadNexus::init, sInput

;Design First Part of GUI (NeXus input)
MakeNexusInputGui, sInput
;;Design Status box (not used here because of duplication of status message
;MakeStatusGui, sInput
;Design Name of nexus test_field or droplist
;MakeNexusFileNameGui, sInput
;Design NXsummary text_field
;MakeNxSummaryGui, sInput

RETURN,1
END

;******************************************************************************
;******  Class Define *********************************************************
PRO IDLloadNexus__define
struct = {IDLloadNexus,$
          var : ''}
END
;******************************************************************************
;******************************************************************************
