;==============================================================================





PRO MakeGuiMainBase, MAIN_BASE, global


  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************



  ;build widgets

  column = WIDGET_BASE(main_base, /column)
  row = WIDGET_BASE(column, /row)
  row2 = WIDGET_BASE(column, /row)
  labelRunNbr = WIDGET_LABEL(row, value = "Run Number: ")
  txtRunNbr = WIDGET_TEXT(row, uname = "txtRunNbr", /EDITABLE)
  cmbInst = WIDGET_COMBOBOX(row, uname = "cmbInst", $
    value = (*global).instrumentList)
    
    
    
    
  btnSearch = WIDGET_BUTTON(row, uname = "Search", value = "Search")
  labelOr = WIDGET_LABEL(row, value = "  Or  ")
  btnBrowse = WIDGET_BUTTON(row, uname = "loadFile", value = "BROWSE...")
  pathLabel = WIDGET_LABEL(column, uname = "pathLabel", $
    value = "Path: no path", /ALIGN_LEFT, /DYNAMIC_RESIZE)
    
  cmbDPath = WIDGET_COMBOBOX(row2, XSIZE = 300, uname = "cmbDPath", /EDITABLE)
  
  cmbPlot = WIDGET_COMBOBOX(row2, XSIZE = 70, uname = "linlog", /DYNAMIC_RESIZE, $
    VALUE = ["LIN","LOG"])
  cmbRebin = WIDGET_COMBOBOX(row2, XSIZE = 70, uname = "cmbRebin", /DYNAMIC_RESIZE, $
    VALUE = ['1','2','3','4','5','6','7','8'])
  btnGraph = WIDGET_BUTTON(row2, uname = "graph", value = "Graph", $
    /SENSITIVE)
    
    
  IF (*global).cpuName NE "" THEN BEGIN
    index = WHERE((*global).instrumentList EQ (*global).cpuName[0], count)
    WIDGET_CONTROL, cmbInst, SET_COMBOBOX_SELECT = index
  ENDIF
  
;  status = WIDGET_LABEL(column, uname = "status", XSIZE = (*global).MainBaseSize[3], $
;    value = "Choose a file", /SUNKEN_FRAME, /ALIGN_LEFT, /DYNAMIC_RESIZE)
  
END

