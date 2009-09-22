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
  
  ;Construct the jobname
  jobname = instrument + "_" + runnumber + "_collector"
 
  ; log Directory
  logDir = '/SNS/users/' + info.username + '/results/' + $
   instrument + '/' + runnumber + '/logs'
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
  
  
  ; Have we created SPE files ?
  dgsr_cmd->GetProperty, SPE=spe
  IF (SPE EQ 1) THEN BEGIN
    ; Add up the SPE files.
    spe_cmd = "sbatch -p " + queue + $
      " --output=" + logDir + "/" + instrument + "_" + runnumber + "_SPE_collector.log" + $
      " --job-name=" + instrument + "_" + runnumber + "_SPE_collector " + $
      "add_spefiles.py --force " + instrument + " -d " + outdir + $
      " -o " + outdir + "/" + instrument + "_" + runnumber + ".spe"
    spawn, spe_cmd
    spawn, "echo " + spe_cmd + " > /tmp/" + info.username + "_spe_commands"
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
      qvec_cmd = "sbatch -q " + queue + " --error=none --output=none " + $
        " --job-name=" + instrument + "_" + runnumber + "_m" + $
        STRCOMPRESS(STRING(index+1), /REMOVE_ALL) + $
        " merge_slices " + instrument + " " + runnumber + " " + STRING(index+1) + " " + $
        outdir + "/" + runnumber + "-mesh"
        
            
    if (index EQ 0) then begin
      spawn, "echo " + qvec_cmd + " > /tmp/" + info.username + "_qvector_commands"
    endif else begin
      spawn, "echo " + qvec_cmd + " >> /tmp/" + info.username + "_qvector_commands"
    endelse
    
    ; Launch the jobs
    spawn, qvec_cmd
    
    endfor

    
  ENDIF
  
  
  ; Put the info structure back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY

END
