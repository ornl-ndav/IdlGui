;==============================================================================

PRO make_gui_tab1, MAIN_TAB, MainTabSize, title

  ;Load button
  XYoff = [5,5]
  sBrowse = { size: [XYoff[0],$
    XYoff[1],$
    150],$
    value: 'BROWSE...',$
    uname: 'loadFile'}
    
  ;Label (file name: and 'name of file')
  XYoff = [10,6]
  sLabel1 = { size: [sBrowse.size[0]+sBrowse.size[2]+XYoff[0],$
    sBrowse.size[1]+XYoff[1]],$
    value: 'File Loaded:' }
  XYoff = [100,0]
  sLabel2 = { size: [sLabel1.size[0]+XYoff[0],$
    sLabel1.size[1]+XYoff[1],$
    400],$
    value: 'N/A',$
    uname: 'fileName'}
    
  XYoff = [100,0]
  fileTree = { size: [sLabel1.size[0]+XYoff[0],$
    sLabel1.size[1]+XYoff[1],$
    400],$
    value: 'N/A',$
    uname: 'fileName'}
    
    
  ;==============================================================================
    
  Base = WIDGET_BASE(MAIN_TAB,$
    UNAME     = 'tab1',$
    XOFFSET   = MainTabSize[0],$
    YOFFSET   = MainTabSize[1],$
    SCR_XSIZE = MainTabSize[2],$
    SCR_YSIZE = MainTabSize[3],$
    TITLE     = title,$
    map = 0)
    
  ;Load Button
  wLoad = WIDGET_BUTTON(Base,$
    XOFFSET   = sBrowse.size[0],$
    YOFFSET   = sBrowse.size[1],$
    SCR_XSIZE = sBrowse.size[2],$
    UNAME     = sBrowse.uname,$
    VALUE     = sBrowse.value)
    
  ;File Name Labels
  wLabel1 = WIDGET_LABEL(Base,$
    XOFFSET = sLabel1.size[0],$
    YOFFSET = sLabel1.size[1],$
    VALUE   = sLabel1.value)
    
  wLabel2 = WIDGET_LABEL(Base,$
    XOFFSET   = sLabel2.size[0],$
    YOFFSET   = sLabel2.size[1],$
    SCR_XSIZE = sLabel2.size[2],$
    VALUE     = sLabel2.value,$
    UNAME     = sLabel2.uname,$
    /ALIGN_LEFT)
    
    tmpStruct = { first: 'first', $
        second: 'second'}
    
   wTree = WIDGET_TREE(Base, $
    XOFFSET = 100,$
    YOFFSET = 70,$
    SCR_XSIZE = 100,$
    SCR_YSIZE = 100,$
    UNAME = wTree)
    
    
    tree = WIDGET_TREE(wTree, $
    XOFFSET = 0,$
    YOFFSET = 0,$
    SCR_XSIZE = 10,$
    SCR_YSIZE = 10,$
    UNAME = tree)
    
    
END




