;==============================================================================

PRO MakeGuiMainBase, MAIN_BASE, global


  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************



  ;build widgets

  column = WIDGET_BASE(main_base, /column)
  row = WIDGET_BASE(main_base, /row)
  
  labelRunNbr = WIDGET_LABEL(row, value = "Run Number: ")
  txtRunNbr = WIDGET_TEXT(row, uname = "txtRunNbr", /EDITABLE)
  comboBox = WIDGET_COMBOBOX(row, uname = "instChoice", value = (*global).instrumentList)
  btnSearch = WIDGET_BUTTON(row, uname = "Search", value = "Search")
  labelOr = WIDGET_LABEL(row, value = "  Or  ")
  btnBrowse = WIDGET_BUTTON(row, uname = "loadFile", value = "BROWSE...")
  
  
  
  
END
