PRO test_color3
       axisColor = FSC_COLOR("Green", !D.Table_Size-2)
       backColor = FSC_COLOR("Charcoal", !D.Table_Size-3)
       dataColor = FSC_COLOR("Yellow", !D.Table_Size-4)
       thisDevice = !D.Name
       Set_Plot, 'toWhateverYourDeviceIsGoingToBe', /Copy
       Device, .... ; Whatever you need here to set things up properly.
       IF (!D.Flags AND 256) EQ 0 THEN $
         POLYFILL, [0,1,1,0,0], [0,0,1,1,0], /Normal, Color=backColor
       Plot, Findgen(11), Color=axisColor, Background=backColor, /NoData, $
          NoErase= ((!D.Flags AND 256) EQ 0)
       OPlot, Findgen(11), Color=dataColor
       Device, .... ; Whatever you need here to wrap things up properly.
       Set_Plot, thisDevice
END
