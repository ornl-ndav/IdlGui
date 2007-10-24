PRO MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, title

SelectionTabBase = WIDGET_BASE(NeXusRoiSelectionTab,$
                               XOFFSET   = 0,$
                               YOFFSET   = 0,$
                               SCR_XSIZE = OpenNeXusSelectionTab[2],$
                               SCR_YSIZE = OpenNeXusSelectionTab[3],$
                               TITLE     = title)

END
