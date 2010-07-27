;==============================================================================





PRO MakeGuiMainBase, MAIN_BASE, global


  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************



  ;build widgets

  column  = WIDGET_BASE(main_base, /column)
  row  = WIDGET_BASE(column, /row)
  row2 = WIDGET_BASE(column, /row)
  row3 = WIDGET_BASE(column, /row)
  row4 = WIDGET_BASE(column, /row)
  
  labelRunNbr = WIDGET_LABEL(row, value = "Run Number: ")
  txtRunNbr = WIDGET_TEXT(row, uname = "txtRunNbr", /EDITABLE)
  cmbInst = WIDGET_COMBOBOX(row, uname = "cmbInst", $
    value = (*global).instrumentList)
  btnSearch = WIDGET_BUTTON(row, uname = "Search", value = "Search")
  labelOr = WIDGET_LABEL(row, value = "  Or  ")
  btnBrowse = WIDGET_BUTTON(row, uname = "loadFile", value = "BROWSE...")
  
  cmbDPath = WIDGET_COMBOBOX(row2, XSIZE = 300, uname = "cmbDPath", $
  value = ['/entry/instrument/bank#/data', $
        '/entry-Off_Off/instrument/bank#/data', $
        '/entry-Off_On/instrument/bank#/data', $
        '/entry-On_Off/instrument/bank#/data', $
        '/entry-On_On/instrument/bank#/data'], /EDITABLE)
  cmbPlot = WIDGET_COMBOBOX(row2, XSIZE = 70, uname = "linlog", /DYNAMIC_RESIZE, $
    VALUE = ["LIN","LOG"])
  cmbRebin = WIDGET_COMBOBOX(row2, XSIZE = 70, uname = "cmbRebin", /DYNAMIC_RESIZE, $
    VALUE = ['1','2','3','4','5','6','7','8'])
  btnGraph = WIDGET_BUTTON(row2, uname = "graph", value = "Graph", $
    /SENSITIVE)
    
  txtLog = WIDGET_TEXT(column, XSIZE = 70, YSIZE = 5, uname = "log_book_text", $
  value = "LogBook", /SCROLL, /WRAP)
  
  sendToGeek = OBJ_NEW('IDLsendToGeek', XSIZE = 480, MAIN_BASE = column, FRAME = 2)
  
 
  
  IF (*global).cpuName NE "" THEN BEGIN
    index = WHERE((*global).instrumentList EQ (*global).cpuName[0], count)
    WIDGET_CONTROL, cmbInst, SET_COMBOBOX_SELECT = index
  ENDIF

  
END

