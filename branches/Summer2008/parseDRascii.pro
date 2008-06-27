FUNCTION READ_DATA, file

  ;Open the data file.
  OPENR, 1, file
  
  
  line = ''
  
  ;Read a line from file
  READF,1,line
   
  ;Close file and return the string
  close, 1
  return, line
  
END

pro parseDRascii
  location = "/SNS/users/dfp/IdlGui/branches/Summer2008/REF_L_4000_2008y_06m_24d_09h_55mn_08s.txt"
  tag = "#F data"
  output = READ_DATA(location)
  print, output
  
end
