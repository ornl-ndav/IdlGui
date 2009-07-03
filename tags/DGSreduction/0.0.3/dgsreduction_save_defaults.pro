PRO DGSreduction_Save_Defaults, event

  DEFAULTS_DIR = '~/.sns/dgsreduction'

  ; Make sure directory exists first
  spawn, 'mkdir -p ' + DEFAULTS_DIR

  filename = DEFAULTS_DIR + '/defaults.sav'
  
  save_parameters, event, FILENAME=filename

END