PRO RepopulateGui, Event
;get cmd of current selected row
cmd = getTextFieldValue(Event,'cmd_status_preview')
ClassInstance = obj_new('IDLparseCommandLine',cmd)
print, cmd
END
