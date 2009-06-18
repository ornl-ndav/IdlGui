PRO DGSnorm_LaunchCollector, event

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF

  ; Get out the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  dgsn_cmd = info.dgsn_cmd
  
  ; For the moment generate the logs in the current directory
  cd, CURRENT=thisDirectory
  
; Get the queue name
  dgsn_cmd->GetProperty, Queue=queue
  ; Get the instrument name
  dgsn_cmd->GetProperty, Instrument=instrument
  ; Get the detector bank limits
  dgsn_cmd->GetProperty, LowerBank=lowerbank
  dgsn_cmd->GetProperty, UpperBank=upperbank
  ; Get the Run Number (the first integer in the datarun)
  runnumber = dgsn_cmd->GetRunNumber()
  ; Number of Jobs
  dgsn_cmd->GetProperty, Jobs=jobs
  
  ;Construct the jobname
  jobname = instrument + "_" + runnumber + "_collector"
 
  ; log Directory
  logDir = '/SNS/users/' + info.username + '/results/logs/' + $
   instrument + '-' + runnumber
  ;Make sure the that logfile directory exists.
  spawn, 'mkdir -p ' + logDir
 
  ; Output Directory
  outDir = "~/results/" + instrument + "/" + runnumber
  ; Make sure that the output directory exists
  spawn, 'mkdir -p ' + outDir
  
  ; launch agg_files
  agg_cmd = "sbatch -p " + queue + $
    " --output=" + logDir + "/" + instrument + "_" + runnumber + "_collector.log" + $
    " --job-name=" + instrument + "_" + runnumber + "_collector " + $
    "agg_files " + instrument + " " + runnumber + " " + outdir
  
  spawn, agg_cmd
  spawn, "echo " + agg_cmd + " > /tmp/" + info.username + "_agg_commands"
  
  ; Put the info structure back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY

END
