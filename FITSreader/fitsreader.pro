PRO FITSreader

  file4 = '~/IDLWorkspace/FITSreader/121009_4.fits'
  file3 = '~/IDLWorkspace/FITSreader/121009_3.fits'
  file2 = '~/IDLWorkspace/FITSreader/121009_2.fits'
  
  a = mrdfits(file4, 1, header, status=status)
  help, a,/structure
  
  help, a.x
  help, a.y
  help, a.p
  help, a.count
  
END