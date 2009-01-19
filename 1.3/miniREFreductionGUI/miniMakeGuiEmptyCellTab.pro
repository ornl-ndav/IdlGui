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

PRO miniMakeGuiEmptyCellTab, DataNormalizationTab,$
                             DataNormalizationTabSize,$
                             EmptyCellTitle,$
                             D_DD_TabSize,$
                             NexusListSizeGlobal,$
                             NexusListLabelGlobal,$
                             MAIN_BASE

;******************************************************************************
;Define structures ************************************************************
;******************************************************************************

;main base --------------------------------------------------------------------
sBase = { size: [0,0,DataNormalizationTabSize[2:3]],$
          uname: 'empty_cell_base'}


;nexus (browse, widget_text....etc) -------------------------------------------
XYoff = [0,0] ;base
sNexusBase = { size: [XYoff[0],$
                      XYoff[1],$
                      600,30],$
               frame: 0,$
               uname: 'empty_cell_nexus_base'}

XYoff = [0,0] ;browse button
sNexusBrowseButton = { size: [XYoff[0],$
                              XYoff[1],$
                              120],$
                       uname: 'browse_empty_cell_nexus_button',$
                       value: 'BROWSE NeXus ...'}

;empty cell run number
sEmptyCellLabel = { value: 'Empty Cell Run Number:'}

;Empty cell run number text field
sEmptyCellTextfield = { value: '',$
                        uname: 'empty_cell_nexus_run_number'}

;Archived/List All
sEmptyCellArchivedListAll = { list: ['Archived','All NeXus'],$
                              uname: 'empty_cell_archived_or_all_uname'}

;JPEG button
sEmptyCellJPEGbutton = { value: 'REFreduction_images/SaveAsJpeg.bmp',$
                         uname: 'empty_cell_save_as_jpeg_button',$
                         tooltip: 'Create a JPEG of the plot' ,$
                         sensitive: 0}

;Y vs TOF (2d) and Y vs X (2D)
XYoff = [5,45]
sTab = { size: [XYoff[0], $
                XYoff[1], $
                304+40, $
                304+60],$
         uname: 'empty_cell_d_dd_tab',$
         location: 1 }
         
;Y vs TOF (2D) ................................................................
sBase1 = { value: 'Y vs TOF (2D)'}
sDraw1 = { size: [0,0,sTab.size[2:3]],$
           uname: 'empty_cell_draw1_uname',$
           scroll: [590,570] }

;Y vs X (2D) ..................................................................
sBase2 = { value: 'Y vs X (2D)'}

spawn, 'hostname', instrument
IF (instrument EQ 'lrac') THEN BEGIN
    XYoff = [40,15]
    xsize = 256
    ysize = 304
ENDIF ELSE BEGIN
    XYoff = [15,40]
    ysize = 256
    xsize = 304
ENDELSE
sDraw2 = { size: [XYoff[0],$
                  XYoff[1],$
                  xsize,$
                  ysize],$
           uname: 'empty_cell_draw2_uname',$
           scroll: sDraw1.scroll }

;NXsummary --------------------------------------------------------------------
XYoff = [5,15]
sNXsummary = { size: [sTab.size[0]+$
                      sTab.size[2]+$
                      XYoff[0],$
                      sTab.size[1]+$
                      XYoff[1],$
                      545,200],$
               uname: 'empty_cell_nx_summary'}

XYoff = [200,-20] ;label
sNXsummaryLabel = { size: [sNXsummary.size[0]+XYoff[0],$
                           sNXsummary.size[1]+XYoff[1]],$
                    value: 'N X s u m m a r y'}

;status -----------------------------------------------------------------------
XYoff = [0,30]
sStatus = { size: [sNXsummary.size[0]+$
                   XYoff[0],$
                   sNXsummary.size[1]+$
                   sNXsummary.size[3]+$
                   XYoff[1],$
                   sNXsummary.size[2], $
                   100],$
               uname: 'empty_cell_status'}

XYoff = [200,-20] ;label
sStatusLabel = { size: [sStatus.size[0]+XYoff[0],$
                        sStatus.size[1]+XYoff[1]],$
                 value: 'S t a t u s'}

;Nexus list base --------------------------------------------------------------
;base
sNexusListBase = { size: [NexusListSizeGlobal[0:3]],$
                   frame: 2,$
                   uname: 'empty_cell_list_nexus_base',$
                   map: 0}
;label
XYoff = [0,0]
sNexusListLabel = { size: [XYoff[0],$
                           XYoff[1],$
                           sNexusListBase.size[2]-4],$
                    value: NexusListLabelGlobal[0],$
                    frame: 1 }

;droplist value
XYoff = [0,25]
sNexusDroplist = { size: [XYoff[0],$
                          XYoff[1]],$
                   value: ['                                        ' + $
                           '                                 '],$
                   uname: 'empty_cell_nexus_droplist' }

;widget_text
XYoff = [0,38]
sNexusText = { size: [XYoff[0],$
                      sNexusDroplist.size[1]+XYoff[1],$
                      sNexusListBase.size[2]-2,$
                      400],$
               uname: 'empty_cell_list_nexus_nxsummary_text_field' }

;cancel button
XYoff = [2,5]
sNexusCancelButton = { size: [XYoff[0],$
                              sNexusText.size[1]+$
                              sNexusText.size[3]+$
                              XYoff[1],$
                              245],$
                       value: 'CANCEL',$
                       uname: 'empty_cell_list_cancel_button' }

;load button
XYoff = [5,0]
sNexusLoadButton = { size: [sNexusCancelButton.size[0]+ $
                            sNexusCancelButton.size[2]+ $
                            XYoff[0],$
                            sNexusCancelButton.size[1]+XYoff[1],$
                            sNexusCancelButton.size[2]],$
                     value: 'LOAD SELECTED NEXUS',$
                     uname: 'empty_cell_list_load_button' }

;Substrate Transmission Equation ----------------------------------------------
XYoff = [0,30]
sSubBase = { size: [sTab.size[0]+XYoff[0],$
                    sTab.size[1]+$
                    sTab.size[3]+$
                    XYoff[1],$
                    880,135],$
             uname: 'empty_cell_substrate_base',$
             frame: 1}

XYoff = [20,-8] ;title
sSubTitle = { size: [sSubBase.size[0]+XYoff[0],$
                     sSubBase.size[1]+XYoff[1]],$
              title: 'Substrate Transmission Equation '}

;equation label ...............................................................
sSubEquation = {value: 'T = exp[-(A + B * Lambda) * D]'}

;substrate type ...............................................................
WIDGET_CONTROL, MAIN_BASE, GET_UVALUE=global
substrate_type = (*(*global).substrate_type)

sz = (SIZE(substrate_type))(1)
type_array = STRARR(sz)
FOR i=0,(sz-1) DO BEGIN
    type_array[i] = substrate_type[i].type_name
ENDFOR
sSubList = { list: type_array,$
             uname: 'empty_cell_substrate_list',$
             title: 'Substrate Type:'}

;a and b coefficient ..........................................................
sAcoeff = { uname: 'empty_cell_substrate_a',$
            title: 'A =',$
            value: STRCOMPRESS(substrate_type[0].a,/REMOVE_ALL)}
sAunits = { value: 'cm^-1' }

sBcoeff = { uname: 'empty_cell_substrate_b',$
            title: 'B =',$
            value: STRCOMPRESS(substrate_type[0].b,/REMOVE_ALL)}
sBunits = { value: 'cm^-2' }

;substrate diameter ...........................................................
sDiameterLabel = { title: '   Substrate Diameter' }
sDiameterField = { title: 'D =',$
                   uname: 'empty_cell_diameter',$
                   value: STRCOMPRESS(substrate_type[0].d,/REMOVE_ALL)}
sDiameterUnits = { title: 'cm' }

;scaling factor ..-...........................................................
sScalingFactorLabel = { title: '      Scaling Factor' }
sScalingFactorField = { title: 'C =',$
                        uname: 'empty_cell_scaling_factor',$
                        value: STRCOMPRESS(1,/REMOVE_ALL)}
sScalingFactorButton = { value: '  CALCULATE C  ',$
                         uname: 'empty_cell_scaling_factor_button'}

;final equation ...............................................................
Equation  = 'T = exp[-(' + STRCOMPRESS(substrate_type[0].a,/REMOVE_ALL)
Equation += ' + ' + STRCOMPRESS(substrate_type[0].b,/REMOVE_ALL)
Equation += ' * Lambda) * ' + STRCOMPRESS(substrate_type[0].d,/REMOVE_ALL)
Equation += ']'
sFinalEquation = { uname: 'empty_cell_substrate_equation',$
                   value: Equation,$
                   frame: 1}

;******************************************************************************
;Define widgets ***************************************************************
;******************************************************************************
wBase = WIDGET_BASE(DataNormalizationTab,$
                    UNAME     = sBase.uname,$
                    XOFFSET   = sBase.size[0],$
                    YOFFSET   = sBase.size[1],$
                    SCR_XSIZE = sBase.size[2],$
                    SCR_YSIZE = sBase.size[3],$
                    TITLE     = EmptyCellTitle)

;nexus (browse, widget_text....etc) -------------------------------------------
wNexusBase = WIDGET_BASE(wBase,$
                         XOFFSET   = sNexusBase.size[0],$
                         YOFFSET   = sNexusBase.size[1],$
                         FRAME     = sNexusBase.frame,$
                         UNAME     = sNexusBase.uname,$
                         /ROW)

;browse button
wNexusBrowseButton = WIDGET_BUTTON(wNexusBase,$
                                   XSIZE = sNexusBrowseButton.size[2],$
                                   UNAME = sNexusBrowseButton.uname,$
                                   VALUE = sNexusBrowseButton.value)

;empty space
wLabel = WIDGET_LABEL(wNexusBase,$
                      VALUE = '  ')

;label and text field
wEmptyCellLabel = WIDGET_LABEL(wNexusBase,$
                               VALUE = sEmptyCellLabel.value)

wEmptyCellTextField = WIDGET_TEXT(wNexusBase,$
                                  VALUE = sEmptyCellTextField.value,$
                                  UNAME = sEmptyCellTextField.uname,$
                                  /EDITABLE)

;empty space
wLabel = WIDGET_LABEL(wNexusBase,$
                      VALUE = '  ')

;Archived or List All
wEmptyCellCWBgroup = CW_BGROUP(wNexusBase,$
                               sEmptyCellArchivedListAll.list,$
                               UNAME     = sEmptyCellArchivedListAll.uname,$
                               ROW       = 1,$
                               SET_VALUE = 0,$
                               /EXCLUSIVE)

;empty space
wLabel = WIDGET_LABEL(wNexusBase,$
                      VALUE = '  ')

;JPEG button                               
wEmptyCellJPEGbutton = $
  WIDGET_BUTTON(wNexusBase,$
                UNAME     = sEmptyCellJPEGbutton.uname,$
                VALUE     = sEmptyCellJPEGbutton.value,$
                TOOLTIP   = sEmptyCellJPEGbutton.tooltip,$
                SENSITIVE = sEmptyCellJPEGbutton.sensitive,$
                /BITMAP)

;Nexus list base and widgets --------------------------------------------------

;base
wNexusListBase = WIDGET_BASE(wBase,$
                             UNAME     = sNexusListBase.uname,$
                             XOFFSET   = sNexusListBase.size[0],$
                             YOFFSET   = sNexusListBase.size[1],$
                             SCR_XSIZE = sNexusListBase.size[2],$
                             SCR_YSIZE = sNexusListBase.size[3],$
                             FRAME     = sNexusListBase.frame,$
                             MAP       = sNexusListBase.map)

;label
wNexusListLabel = WIDGET_LABEL(wNexusListBase,$
                               XOFFSET   = sNexusListLabel.size[0],$
                               YOFFSET   = sNexusListLabel.size[1],$
                               SCR_XSIZE = sNexusListLabel.size[2],$
                               VALUE     = sNexusListLabel.value,$
                               FRAME     = sNexusListLabel.frame)

;droplist value
wNexusDroplist = WIDGET_DROPLIST(wNexusListBase,$
                                 UNAME   = sNexusDroplist.uname,$
                                 XOFFSET = sNexusDroplist.size[0],$
                                 YOFFSET = sNexusDroplist.size[1],$
                                 VALUE   = sNexusDroplist.value,$
                                 /TRACKING_EVENTS)
                                   
;nxsummary text
wNexusText = WIDGET_TEXT(wNexusListBase,$
                         XOFFSET = sNexusText.size[0],$
                         YOFFSET = sNexusText.size[1],$
                         SCR_XSIZE = sNexusText.size[2],$
                         SCR_YSIZE = sNexusText.size[3],$
                         UNAME     = sNexusText.uname,$
                         /WRAP,$
                         /SCROLL)
  
;cancel button
wNexusCancelButton = WIDGET_BUTTON(wNexusListBase,$
                                 UNAME     = sNexusCancelButton.uname,$
                                 XOFFSET   = sNexusCancelButton.size[0],$
                                 YOFFSET   = sNexusCancelButton.size[1],$
                                 SCR_XSIZE = sNexusCancelButton.size[2],$
                                 VALUE     = sNexusCancelButton.value)

;load button
wNexusLoadButton = WIDGET_BUTTON(wNexusListBase,$
                                 UNAME     = sNexusLoadButton.uname,$
                                 XOFFSET   = sNexusLoadButton.size[0],$
                                 YOFFSET   = sNexusLoadButton.size[1],$
                                 SCR_XSIZE = sNexusLoadButton.size[2],$
                                 VALUE     = sNexusLoadButton.value)
                                        
;Plot Tabs ....................................................................
wTab = WIDGET_TAB(wBase,$
                  XOFFSET   = sTab.size[0],$
                  YOFFSET   = sTab.size[1],$
                  SCR_XSIZE = sTab.size[2],$
                  SCR_YSIZE = sTab.size[3],$
                  UNAME     = sTab.uname,$
                  LOCATION  = sTab.location,$
                  /TRACKING_EVENTS)

;Y vs TOF (2D) ________________________________________________________________
wBase1 = WIDGET_BASE(wTab,$
                     TITLE = sBase1.value)

wDraw1 = WIDGET_DRAW(wBase1,$
                     XOFFSET       = 0,$
                     YOFFSET       = 0,$
                     X_SCROLL_SIZE = 304,$
                     Y_SCROLL_SIZE = 304,$
                     XSIZE         = 304,$
                     YSIZE         = 304,$
                     UNAME         = sDraw1.uname,$
                     RETAIN        = 2,$
                     /SCROLL,$
                     /MOTION_EVENTS)

;Y vs X (2D) ________________________________________________________________
wBase2 = WIDGET_BASE(wTab,$
                     TITLE = sBase2.value)

wDraw2 = WIDGET_DRAW(wBase2,$
                     XOFFSET       = sDraw2.size[0],$
                     YOFFSET       = sDraw2.size[1],$
;                     X_SCROLL_SIZE = sDraw2.scroll[0],$
;                     Y_SCROLL_SIZE = sDraw2.scroll[1],$
                     SCR_XSIZE     = sDraw2.size[2],$
                     SCR_YSIZE     = sDraw2.size[3],$
                     UNAME         = sDraw2.uname,$
                     RETAIN        = 2,$
;                     /SCROLL,$
                     /MOTION_EVENTS)

;NXsummary --------------------------------------------------------------------
wNXsummary = WIDGET_TEXT(wBase,$
                         XOFFSET   = sNXsummary.size[0],$
                         YOFFSET   = sNXsummary.size[1],$
                         SCR_XSIZE = sNXsummary.size[2],$
                         SCR_YSIZE = sNXsummary.size[3],$
                         UNAME     = sNXsummary.uname,$
                         /WRAP,$
                         /SCROLL)

wNXsummaryLabel = WIDGET_LABEL(wBase,$
                               XOFFSET = sNXsummaryLabel.size[0],$
                               YOFFSET = sNXsummaryLabel.size[1],$
                               VALUE   = sNXsummaryLabel.value)

;Status -----------------------------------------------------------------------
wStatus = WIDGET_TEXT(wBase,$
                         XOFFSET   = sStatus.size[0],$
                         YOFFSET   = sStatus.size[1],$
                         SCR_XSIZE = sStatus.size[2],$
                         SCR_YSIZE = sStatus.size[3],$
                         UNAME     = sStatus.uname,$
                         /WRAP,$
                         /SCROLL)

wStatusLabel = WIDGET_LABEL(wBase,$
                               XOFFSET = sStatusLabel.size[0],$
                               YOFFSET = sStatusLabel.size[1],$
                               VALUE   = sStatusLabel.value)


;Substrate Transmission Equation ----------------------------------------------
;title
wSubTitle = WIDGET_LABEL(wBase,$
                         XOFFSET = sSubTitle.size[0],$
                         YOFFSET = sSubTitle.size[1],$
                         VALUE   = sSubTitle.title)

;frame
wSubBase = WIDGET_BASE(wBase,$
                       XOFFSET   = sSubBase.size[0],$
                       YOFFSET   = sSubBase.size[1],$
                       SCR_XSIZE = sSubBase.size[2],$
                       SCR_YSIZE = sSubBase.size[3],$
                       UNAME     = sSubBase.uname,$
                       FRAME     = sSubBase.frame,$
                       /ROW)

;equation .....................................................................
wSpace = WIDGET_LABEL(wSubBase,$
                      VALUE = '  ')
wSubEquation = WIDGET_LABEL(wSubBase,$
                            VALUE = sSubEquation.value)
wSpace = WIDGET_LABEL(wSubBase,$
                      VALUE = '  ')

;Type .........................................................................
wTypeBase = WIDGET_BASE(wSubBase,$
                        /COLUMN)
list = WIDGET_DROPLIST(wTypeBase,$
                       UNAME = sSubList.uname,$
                       VALUE = sSubList.list,$
                       TITLE = sSubList.title)

;a and b coefficient ..........................................................
wBase1 = WIDGET_BASE(wTypeBase,$
                     /ROW)
wAcoeff = CW_FIELD(wBase1,$
                   VALUE = sAcoeff.value,$
                   UNAME = sAcoeff.uname,$
                   TITLE = sAcoeff.title,$
;                   /FLOATING,$
                   /ALL_EVENTS)
wAunits = WIDGET_LABEL(wBase1,$
                       VALUE = sAunits.value)

wBase2 = WIDGET_BASE(wTypeBase,$
                     /ROW)
wBcoeff = CW_FIELD(wBase2,$
                   VALUE = sBcoeff.value,$
                   UNAME = sBcoeff.uname,$
                   TITLE = sBcoeff.title,$
;                   /FLOATING,$
                   /ALL_EVENTS)
wBunits = WIDGET_LABEL(wBase2,$
                       VALUE = sBunits.value)


;space
wSpace = WIDGET_LABEL(wSubBase,$
                      VALUE = '   ')

;diameter label/units, Scaling Factor and equation .............................
wBaseColumn = WIDGET_BASE(wSubBase,$
                          /COLUMN,$
                          XSIZE = 400,$
                          /BASE_ALIGN_CENTER)

;diameter and scaling factor
wBaseRow1 = WIDGET_BASE(wBaseColumn,$
                        /ROW)

;diameter 
wBaseColumn1_1 = WIDGET_BASE(wBaseRow1,$
                             /COLUMN,$
                             /BASE_ALIGN_CENTER,$
                             xsize = 150)

wDiameterLabel = WIDGET_LABEL(wBaseColumn1_1,$
                              VALUE = sDiameterLabel.title)
wBaseColumn1_1_row1 = WIDGET_BASE(wBaseColumn1_1,$
                     /ROW)
wDiameterValue = CW_FIELD(wBaseColumn1_1_row1,$
                          TITLE = sDiameterField.title,$
                          VALUE = sDiameterField.value,$
                          UNAME = sDiameterField.uname,$
                          XSIZE = 10,$
;                          /FLOATING,$
                          /ALL_EVENTS)
wDiameterUnits = WIDGET_LABEL(wBaseColumn1_1_row1,$
                              VALUE = sDiameterUnits.title)

;space
space = WIDGET_LABEL(wBaseRow1,$
                     VALUE = '')

;Scaling Factor
wBaseColumn1_2 = WIDGET_BASE(wBaseRow1,$
                             /COLUMN,$
                             xsize = 300,$
                             /BASE_ALIGN_LEFT)
wSFLabel = WIDGET_LABEL(wBaseColumn1_2,$
                        VALUE = sScalingFactorLabel.title)
wBaseColumn1_2_row1 = WIDGET_BASE(wBaseColumn1_2,$
                     /ROW)
wSFValue = CW_FIELD(wBaseColumn1_2_row1,$
                    TITLE = sScalingFactorField.title,$
                    VALUE = sScalingFactorField.value,$
                    UNAME = sScalingFactorField.uname,$
                    XSIZE = 10,$
                    /FLOATING,$
                    /ALL_EVENTS)
wSFbutton = WIDGET_BUTTON(wBaseColumn1_2_row1,$
                          VALUE = sScalingFactorButton.value,$
                          UNAME = sScalingFactorButton.uname)

;space
wSpace = WIDGET_LABEL(wBaseColumn,$
                      VALUE = '')
wSpace = WIDGET_LABEL(wBaseColumn,$
                      VALUE = '')

;final equation
wBaseColumn2_1 = WIDGET_BASE(wBaseColumn,$
                             /ROW,$
                             /BASE_ALIGN_LEFT)
wEquation = WIDGET_LABEL(wBaseColumn2_1, $
                         VALUE = sFinalEquation.value,$
                         UNAME = sFinalEquation.uname,$
                         XSIZE = 350,$
                         FRAME = sFinalEquation.frame)

END

