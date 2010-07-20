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

PRO DGSnorm_LaunchCollector, event, WaitForJobs=waitforjobs

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  ; Get out the info structure
  WIDGET_CONTROL, event.top, GET_UVALUE=info, /NO_COPY
  dgs_cmd = info.dgsr_cmd
  
  ; For the moment generate the logs in the current directory
  cd, CURRENT=thisDirectory
  
  ; Get the queue name
  dgs_cmd->GetProperty, Queue=queue
  ; Get the instrument name
  dgs_cmd->GetProperty, Instrument=instrument
  ; Get the detector bank limits
  dgs_cmd->GetProperty, LowerBank=lowerbank
  dgs_cmd->GetProperty, UpperBank=upperbank
  ; Get the Run Number (the first integer in the datarun)
  runnumber = dgs_cmd->GetNormalisationNumber()
  ; Number of Jobs
  dgs_cmd->GetProperty, Jobs=jobs
  
  ;Construct the jobname
  jobname = instrument + "_" + runnumber + "_collector"
  
  ; Output Directory
  ; outDir = get_output_directory(instrument, runnumber, /HOME, /CREATE)
  outDir = info.outputDir
  
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
  
  agg_cmd += " agg_files " + instrument + " " + runnumber + " " + outdir
  
  spawn, agg_cmd
  spawn, "echo " + agg_cmd + " > " + logDir + "/agg_commands"
  ;print, "echo " + agg_cmd + " > " + logDir + "/agg_commands"
  
  ; Put the info structure back
  WIDGET_CONTROL, event.top, SET_UVALUE=info, /NO_COPY
  
END
