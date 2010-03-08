PRO test_color4, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra4
           axisColor = FSC_COLOR("Green", !D.Table_Size-2)
           backColor = FSC_COLOR("Charcoal", !D.Table_Size-3)
           dataColor = FSC_COLOR("Yellow", !D.Table_Size-4)
           symColor  = FSC_COLOR("Red", !D.Table_Size-5)
           Plot, Findgen(11), Color=axisColor, Background=backColor, /NoData
           OPlot, Findgen(11), Color=dataColor
           Oplot, Findgen(11), Color=symColor, SYMSIZE = 2, PSYM = 2
END
