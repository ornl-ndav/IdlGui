;+
; :Description:
;    Launches Firefox and loads the SLURM job monitor webpage.
;
; :Params:
;    event
;
; :Author: scu
;-
PRO DGSreduction_LaunchJobMonitor, event

  spawn, 'firefox https://neutronsr.us/applications/jobmonitor/squeue.php?view=all &'

END