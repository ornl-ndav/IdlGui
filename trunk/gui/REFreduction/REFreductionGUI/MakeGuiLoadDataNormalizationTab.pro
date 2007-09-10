PRO MakeGuiLoadDataNormalizationTab, LOAD_BASE,$
                                     MainBaseSize,$
                                     D_DD_TabSize,$
                                     D_DD_BaseSize,$
                                     D_DD_TabTitle,$
                                     GlobalRunNumber,$
                                     RunNumberTitles,$
                                     GlobalLoadDataGraphs,$
                                     FileInfoSize,$
                                     LeftInteractionHelpSize,$
                                     LeftInteractionHelpMessageLabeltitle,$
                                     NxsummaryZoomTabSize,$
                                     NxsummaryZoomTitle,$
                                     ZoomScaleBaseSize,$
                                     ZoomScaleTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
DataNormalizationTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

;Tab titles
DataTitle          = '         D A T A          '
NormalizationTitle = '      N O R M A L I Z A T I O N      '

;Archived or Full NeXus list cw_bgroup
ArchivedOrAllCWBgroupList = ['Archived ','All NeXus ']
ArchivedOrAllCWBgroupSize = [480,13]

;base that displays the full list of NeXus found
NeXusListBaseSize          = [90,110,500,500]
NexusListLabelSize         = [0,0,496,30]
NexusListLabelTitle        = 'S E L E C T    A    N E X U S    F I L E' 
NexusListDropListSize      = [5,35]
NexusListNXsummarySize     = [5,75,487,380]
NexusListLoadButtonSize    = [5,460,300,30]
NexusListLoadButtonTitle   = 'LOAD'
NexusListCancelButtonSize  = [310,460,185,30]
NexusListCancelButtonTitle = 'CANCEL'

NexusListSizeGlobal = [NexusListBaseSize,$ ;0,1,2,3
                       NexusListLabelSize,$ ;4,5,6,7
                       NexusListDropListSize,$ ;8,9
                       NexusListNXsummarySize,$ ;10,11,12,13
                       NexusListLoadButtonSize,$ ;14,15,16,17
                       NexusListCancelButtonSize] ;18,19,20,21
NexusListLabelGlobal = [NexusListLabelTitle,$
                        NexusListLoadButtonTitle,$
                        NexusListCancelButtonTitle]


;build widgets
DataNormalizationTab = WIDGET_TAB(LOAD_BASE,$
                                  UNAME='data_normalization_tab',$
                                  LOCATION=0,$
                                  XOFFSET=DataNormalizationTabSize[0],$
                                  YOFFSET=DataNormalizationTabSize[1],$
                                  SCR_XSIZE=DataNormalizationTabSize[2],$
                                  SCR_YSIZE=DataNormalizationTabSize[3],$
                                  /TRACKING_EVENTS)

;build DATA tab
MakeGuiLoadDataTab,$
  DataNormalizationTab,$
  DataNormalizationTabSize,$
  DataTitle,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles,$
  GlobalLoadDataGraphs,$
  FileInfoSize,$
  LeftInteractionHelpsize,$
  LeftInteractionHelpMessageLabeltitle,$
  NxsummaryZoomTabSize,$
  NxsummaryZoomTitle,$
  ZoomScaleBaseSize,$
  ZoomScaleTitle,$
  ArchivedOrAllCWBgroupList,$
  ArchivedOrAllCWBgroupSize,$
  NexusListSizeGlobal,$
  NexusListLabelGlobal

;build NORMALIZATION tab
MakeGuiLoadNormalizationTab,$
  DataNormalizationTab,$
  DataNormalizationTabSize,$
  NormalizationTitle,$
  D_DD_TabSize,$
  D_DD_BaseSize,$
  D_DD_TabTitle,$
  GlobalRunNumber,$
  RunNumberTitles,$
  GlobalLoadDataGraphs,$
  FileInfoSize,$
  LeftInteractionHelpsize,$
  LeftInteractionHelpMessageLabeltitle,$
  NxsummaryZoomTabSize,$
  NxsummaryZoomTitle,$
  ZoomScaleBaseSize,$
  ZoomScaleTitle,$
  ArchivedOrAllCWBgroupList,$
  ArchivedOrAllCWBgroupSize,$
  NexusListSizeGlobal,$
  NexusListLabelGlobal

END
