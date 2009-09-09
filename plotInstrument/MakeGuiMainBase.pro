;==============================================================================

PRO MakeGuiMainBase, MAIN_BASE, global


  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************



  ;build widgets

  column = WIDGET_BASE(main_base, /column)
  row = WIDGET_BASE(column, /row)
  labelRunNbr = WIDGET_LABEL(row, value = "Run Number: ")
  txtRunNbr = WIDGET_TEXT(row, uname = "txtRunNbr", /EDITABLE)
  comboBox = WIDGET_COMBOBOX(row, uname = "instChoice", value = (*global).instrumentList)
  IF (*global).cpuName NE "" THEN BEGIN
    index = WHERE((*global).instrumentList EQ (*global).cpuName[0], count)
    WIDGET_CONTROL, comboBox, SET_COMBOBOX_SELECT = index
  ENDIF
  
  btnSearch = WIDGET_BUTTON(row, uname = "Search", value = "Search")
  labelOr = WIDGET_LABEL(row, value = "  Or  ")
  btnBrowse = WIDGET_BUTTON(row, uname = "loadFile", value = "BROWSE...")
  btnGraph = WIDGET_BUTTON(column, uname = "graph", value = "Graph")
  
  
  
  
END
