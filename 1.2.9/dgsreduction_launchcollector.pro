;+
; :Copyright:
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; :Author: scu (campbellsi@ornl.gov)
;-

PRO DGSreduction_LaunchCollector, event, WaitForJobs=waitforjobs

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ; Now put the info structure back for consistency
    WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  ; Get out the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  dgsr_cmd = info.dgsr_cmd
  
  ; For the moment generate the logs in the current directory
  cd, CURRENT=thisDirectory
  
  ; Get the queue name
  dgsr_cmd->GetProperty, Queue=queue
  ; Get the instrument name
  dgsr_cmd->GetProperty, Instrument=instrument
  ; Get the detector bank limits
  dgsr_cmd->GetProperty, LowerBank=lowerbank
  dgsr_cmd->GetProperty, UpperBank=upperbank
  ; Get the Run Number (the first integer in the datarun)
  runnumber = dgsr_cmd->GetRunNumber()
  ; Number of Jobs
  dgsr_cmd->GetProperty, Jobs=jobs
  ; Get the Ei
  dgsr_cmd->GetProperty, Ei=ei
  ; Get the sample rotation angle
  dgsr_cmd->GetProperty, RotationAngle=rotationangle_offset
  ; Get the SE Block name of the rotation motor
  dgsr_cmd->GetProperty, SEBlock=seblock
  ; Get the Lambda Scaling flag
  dgsr_cmd->GetProperty, lambdaratio=lambda_scaling
  
  ;Construct the jobname
  jobname = instrument + "_" + runnumber + "_collector"
  
  ; Output Directory
  outDir = info.outputDir
  ;outDir = '/SNS/users/' + info.username + '/results/' + instrument + '/' + runnumber
  ; Make sure that the output directory exists
  IF FILE_TEST(outDir, /DIRECTORY) EQ 0 THEN BEGIN
    spawn, 'mkdir -p ' + outDir
  ENDIF
  
  ; log Directory
  logDir = outDir + '/logs'
  ;Make sure the that logfile directory exists.
  IF FILE_TEST(logDir, /DIRECTORY) EQ 0 THEN BEGIN
    spawn, 'mkdir -p ' + logDir
  ENDIF
  
  ; launch agg_files
  agg_cmd = "sbatch -p " + queue + $
    " --output=" + logDir + "/" + instrument + "_" + runnumber + "_collector.log" + $
    " --job-name=" + instrument + "_" + runnumber + "_collector "
    
  IF KEYWORD_SET(WAITFORJOBS) THEN BEGIN
    agg_cmd += " --dependency="
    FOR N = 0L, jobs-1 DO BEGIN
      IF N GT 0 THEN agg_cmd += ","
      agg_cmd += "afterok:" + WAITFORJOBS[N]
    ENDFOR
  ENDIF
  
  agg_cmd +=  " agg_files " + instrument + " " + runnumber + " " + outdir
  
  
  spawn, agg_cmd
  spawn, "echo " + agg_cmd + " > " + logDir + "/agg_commands"
  
  
  ; Have we created SPE files ?
  dgsr_cmd->GetProperty, SPE=spe
  IF (SPE EQ 1) THEN BEGIN
    ; Add up the SPE files.
    spe_cmd = "sbatch -p " + queue + $
      " --output=" + logDir + "/" + instrument + "_" + runnumber + "_SPE_collector.log" + $
      " --job-name=" + instrument + "_" + runnumber + "_SPE_collector "
      
    IF KEYWORD_SET(WAITFORJOBS) THEN BEGIN
      spe_cmd += " --dependency="
      FOR N = 0L, jobs-1 DO BEGIN
        IF N GT 0 THEN spe_cmd += ","
        spe_cmd += "afterok:" + WAITFORJOBS[N]
      ENDFOR
    ENDIF
    
    spe_cmd += " add_spefiles.py --force " + instrument + " -d " + outdir + $
      " -o " + outdir + "/" + instrument + "_" + runnumber + ".spe"
      
    spawn, spe_cmd, dummy, job_string
    spawn, "echo " + spe_cmd + " > " + logDir + "/spe_commands"
    
    job_string_array = STRSPLIT(job_string, ' ', /EXTRACT)
    jobID = job_string_array[N_ELEMENTS(job_string_array)-1]
    
    ; Now let's kick off the SPE -> NXSPE converter
    nxspe_cmd = "sbatch -p " + queue + $
      " --output=" + logDir + "/" + instrument + "_" + runnumber + "_NXSPE_converter.log" + $
      " --job-name=" + instrument + "_" + runnumber + "_NXSPE_converter " + $
      " --dependency=afterok:" + jobID
      
    nxspe_cmd += " spe2nxspe.py --force -i " + instrument + " -r " + runnumber + $
      " --spe=" + outdir + "/" + instrument + "_" + runnumber + ".spe" + $
      " --phx=" + outdir + "/" + instrument + "_" + runnumber + ".phx" + $
      " -o " + outdir + "/" + instrument + "_" + runnumber + ".nxspe" + $
      " -e " + ei + " --lambda-scaling=" + STRCOMPRESS(STRING(lambda_scaling), /REMOVE_ALL)
      
    ;print, 'SEBLOCK = ', SEBLOCK
      
      
    IF STRLEN(seblock) GT 0 THEN BEGIN
      nxspe_cmd += ' --seblock=' + seblock
      
      rotationangle = get_seblock_value(Instrument, runnumber, SEBLOCK)
      
      help,/str,RotationAngle
      
      IF N_ELEMENTS(rotationangle) NE 0 THEN BEGIN
        nxspe_cmd += " -a " + STRCOMPRESS(STRING(rotationangle),/REMOVE_ALL)
        
        ; Set a default offset
        tmp_offset = 0.0
        
        ; Get the real offset, if it has been defined
        IF STRLEN(rotationangle_offset) GE 1 THEN BEGIN
          tmp_offset = float(rotationangle_offset)
        ENDIF
        
        mslice_psi = float(RotationAngle) + tmp_offset
        nxspe_cmd += " --psi=" + STRCOMPRESS(STRING(mslice_psi),/REMOVE_ALL)
        
      ENDIF
    ENDIF
    
    spawn, nxspe_cmd
    spawn, "echo " + nxspe_cmd + " > " + logDir + "/nxspe_commands"
    
    
  ENDIF
  
  
  ; Is Qvector produced ?
  dgsr_cmd->GetProperty, Qvector=qvector
  IF (qvector EQ 1) THEN BEGIN
  
    ; Add up the meshes
    dgsr_cmd->GetProperty, EnergyBins_min=emin
    dgsr_cmd->GetProperty, EnergyBins_max=emax
    dgsr_cmd->GetProperty, EnergyBins_step=estep
    npoints = FLOOR((FLOAT(emax) - FLOAT(emin)) / FLOAT(estep))
    ;help, /str, npoints
    
    for index = 0L, npoints-1 do begin
      qvec_cmd = "sbatch -p " + queue + " --error=none --output=none " + $
        " --job-name=" + instrument + "_" + runnumber + "_m" + $
        STRCOMPRESS(STRING(index+1), /REMOVE_ALL)
        
      IF KEYWORD_SET(WAITFORJOBS) THEN BEGIN
        qvec_cmd += " --dependency="
        FOR N = 0L, jobs-1 DO BEGIN
          IF N GT 0 THEN qvec_cmd += ","
          qvec_cmd += "afterok:" + WAITFORJOBS[N]
        ENDFOR
      ENDIF
      
      qvec_cmd += " merge_slices " + instrument + " " + runnumber + " " + STRING(index+1) + " " + $
        outdir + "/" + runnumber + "-mesh"
        
        
      if (index EQ 0) then begin
        spawn, "echo " + qvec_cmd + " > " + logDir + "/qvector_commands"
      endif else begin
        spawn, "echo " + qvec_cmd + " >> " + logDir + "/qvector_commands"
      endelse
      
      ; Launch the jobs
      spawn, qvec_cmd
      
    endfor
    
    
  ENDIF
  
  
  ; Put the info structure back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  
END
