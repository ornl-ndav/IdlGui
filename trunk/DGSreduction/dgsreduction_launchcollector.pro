PRO DGSreduction_LaunchCollector, event

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF

  ; Get out the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  dgscmd = info.dgscmd
  
  ; For the moment generate the logs in the current directory
  cd, CURRENT=thisDirectory
  
; Get the queue name
  dgscmd->GetProperty, Queue=queue
  ; Get the instrument name
  dgscmd->GetProperty, Instrument=instrument
  ; Get the detector bank limits
  dgscmd->GetProperty, LowerBank=lowerbank
  dgscmd->GetProperty, UpperBank=upperbank
  ; Get the Run Number (the first integer in the datarun)
  runnumber = dgscmd->GetRunNumber()
  ; Number of Jobs
  dgscmd->GetProperty, Jobs=jobs
  
  ;Construct the jobname
  jobname = instrument + "_" + runnumber + "_Collector"
  
  ; Output Directory
  outdir = "~/results/" + instrument + "/" + runnumber
  
  ; launch agg_files
  agg_cmd = "sbatch -p " + queue + $
    " --job-name=" + instrument + "_" + runnumber + "_collector " + $
    "agg_files " + instrument + " " + runnumber + " " + outdir
  
  ;spawn, agg_cmd
  spawn, "echo " + agg_cmd + " > /tmp/agg_commands"
  
  
  ; Have we created SPE files ?
  dgscmd->GetProperty, SPE=spe
  IF (SPE EQ 1) THEN BEGIN
    ; Add up the SPE files.
    spe_cmd = "sbatch -p " + queue + $
      " --job-name=" + instrument + "_" + runnumber + "_SPE_collector " + $
      "add_spefiles.py " + instrument + " -d " + outdir + $
      " -o " + outdir + "/" + instrument + "_" + runnumber + ".spe"
    ;spawn, spe_cmd
    spawn, "echo " + spe_cmd + " > /tmp/spe_commands"
  ENDIF
  
  
  ; Is Qvector produced ?
  dgscmd->GetProperty, Qvector=qvector
  IF (qvector EQ 1) THEN BEGIN
  
    ; Add up the meshes
    dgscmd->GetProperty, EnergyBins_min=emin
    dgscmd->GetProperty, EnergyBins_max=emax
    dgscmd->GetProperty, EnergyBins_step=estep
    npoints = FLOOR((FLOAT(emax) - FLOAT(emin)) / FLOAT(estep))
    help, /str, npoints
    
    for index = 0L, npoints-1 do begin
      qvec_cmd = "sbatch -q " + queue + " --error=none --output=none " + $
        " --job-name=" + instrument + "_" + runnumber + "_vtk" + $
        STRCOMPRESS(STRING(index+1), /REMOVE_ALL) + $
        " make_vtk " + instrument + " " + runnumber + " " + STRING(index+1) + " " + $
        outdir + "/" + runnumber + "-mesh"
        
            
    if (index EQ 0) then begin
      spawn, "echo " + qvec_cmd + " > /tmp/qvector_commands"
    endif else begin
      spawn, "echo " + qvec_cmd + " >> /tmp/qvector_commands"
    endelse
        
    endfor

    
  ENDIF
  
  
  ; Put the info structure back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY

END