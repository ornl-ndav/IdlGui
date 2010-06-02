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

PRO NormCmd::Cleanup
  PTR_FREE, self.extra
END

PRO NormCmd::GetProperty, $
    Program=program, $                   ; Program name
    Version=version, $
    Queue=queue, $                       ; Name of Queue
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    DataRun=datarun, $                   ; Data filename(s)
    Output=output, $                     ; Output
    Instrument=instrument, $             ; Instrument Name
    Facility=facility, $                 ; Facility Name
    Proposal=proposal, $                 ; Proposal ID
    ConfigFile=configfile, $             ; Config (.rmd) filename
    InstGeometry=instgeometry, $         ; Instrument Geometry filename
    LowerBank=lowerbank, $               ; Lower Detector Bank
    UpperBank=upperbank, $               ; Upper Detector Bank
    DataPaths=datapaths, $               ; detector data paths
    EmptyCan=emptycan, $                 ; Empty Can file
    BlackCan=blackcan, $                 ; Black Sample file
    Dark=dark, $                         ; Dark current file
    USmonPath=usmonpath, $               ; Upstream monitor path
    DSmonPath=dsmonpath, $               ; Downstream monitor path
    ROIfile=roifile, $                   ; ROI file
    Tmin=tmin, $                         ; minimum tof
    Tmax=tmax, $                         ; maximum tof
    TIBconst=tibconst, $                 ; Time Independent Bkgrd constant
    TIBrange_Min=tibrange_min, $         ; Range for calculating TIB constant
    TIBrange_Max=tibrange_max, $         ; Range for calculating TIB constant
    Ei=ei, $                             ; Incident Energy (meV)
    Tzero=tzero, $                       ; T0
    error_ei=error_ei, $                 ; Error in Incident Energy (meV)
    error_tzero=error_tzero, $           ; Error in T0
    NoMonitorNorm=nomonitornorm, $       ; Turn off monitor normalisation
    PCnorm=pcnorm, $                     ; Proton Charge Normalisation
    MonRange_Min=monrange_min, $         ; Monitor integration range (usec) (min)
    MonRange_Max=monrange_max, $         ; Monitor integration range (usec) (max)
    DetEff=deteff, $                     ; Detector efficiency
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange_Min=normrange_min, $       ; normalisation integration range (meV) (min)
    NormRange_Max=normrange_max, $       ; normalisation integration range (meV) (max)
    LambdaBins_Min=lambdabins_min, $     ; wavelength bins (min)
    LambdaBins_Max=lambdabins_max, $     ; wavelength bins (max)
    LambdaBins_Step=lambdabins_step, $   ; wavelength bins (step)
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    WhiteNorm=whitenorm, $               ; White Beam Normalisation
    DumpEt=dumpet, $                     ; Dump combined Et file
    DumpTIB=dumptib, $                   ; Dump the TIB constant for all pixels
    Lo_Threshold=lo_threshold, $         ; Threshold for pixel to be masked (default: 0)
    Hi_Threshold=hi_threshold, $         ; Threshold for pixel to be masked (default: infinity)
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs
    NormLocation=normlocation, $         ; Setting for location of norm files ('INST','PROP','HOME')
    UseHome=usehome, $                   ; Flag to indicate whether we should write to the home directory
    ProtonCurrentUnits=ProtonCurrentUnits, $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  IF ARG_PRESENT(Program) NE 0 THEN Program = self.program
  IF ARG_PRESENT(Version) NE 0 THEN Version = self.version
  IF ARG_PRESENT(Queue) NE 0 THEN Queue = self.queue
  IF ARG_PRESENT(Verbose) NE 0 THEN self.verbose = verbose
  IF ARG_PRESENT(Quiet) NE 0 THEN Quiet = self.quiet
  IF ARG_PRESENT(DataRun) NE 0 THEN DataRun = self.datarun
  IF ARG_PRESENT(Output) NE 0 THEN Output = self.output
  IF ARG_PRESENT(Instrument) NE 0 THEN Instrument = self.instrument
  IF ARG_PRESENT(Facility) NE 0 THEN Facility = self.facility
  IF ARG_PRESENT(Proposal) NE 0 THEN Proposal = self.proposal
  IF ARG_PRESENT(ConfigFile) NE 0 THEN ConfigFile = self.configfile
  IF ARG_PRESENT(instgeometry) NE 0 THEN InstGeometry = self.instgeometry
  IF ARG_PRESENT(LowerBank) NE 0 THEN LowerBank  = self.lowerbank
  IF ARG_PRESENT(UpperBank) NE 0 THEN UpperBank = self.upperbank
  IF ARG_PRESENT(DataPaths) NE 0 THEN DataPaths = self.datapaths
  IF ARG_PRESENT(EmptyCan) NE 0 THEN EmptyCan = self.emptycan
  IF ARG_PRESENT(BlackCan) EQ 0 THEN BlackCan = self.blackcan
  IF ARG_PRESENT(Dark) NE 0 THEN Dark = self.dark
  IF ARG_PRESENT(USmonPath) NE 0 THEN USmonPath = self.usmonpath
  IF ARG_PRESENT(DSmonPath) NE 0 THEN DSmonPath = self.dsmonpath
  IF ARG_PRESENT(ROIfile) NE 0 THEN ROIfile = self.roifile
  IF ARG_PRESENT(Tmin) NE 0 THEN Tmin = self.tmin
  IF ARG_PRESENT(Tmax) NE 0 THEN Tmax = self.tmax
  IF ARG_PRESENT(TIBconst) NE 0 THEN TIBconst = self.tibconst
  IF ARG_PRESENT(TIBrange_Min) NE 0 THEN TIBrange_Min = self.tibrange_min
  IF ARG_PRESENT(TIBrange_Max) NE 0 THEN TIBrange_Max = self.tibrange_max
  IF ARG_PRESENT(Ei) NE 0 THEN Ei = self.ei
  IF ARG_PRESENT(Tzero) NE 0 THEN Tzero = self.tzero
  IF ARG_PRESENT(error_ei) NE 0 THEN error_ei = self.error_ei
  IF ARG_PRESENT(error_tzero) NE 0 THEN error_tzero = self.error_tzero
  IF ARG_PRESENT(NoMonitorNorm) NE 0 THEN NoMonitorNorm = self.nomonitornorm
  IF ARG_PRESENT(PCnorm) NE 0 THEN PCnorm = self.pcnorm
  IF ARG_PRESENT(MonRange_Min) NE 0 THEN MonRange_Min = self.monrange_min
  IF ARG_PRESENT(MonRange_Max) NE 0 THEN MonRange_Max = self.monrange_max
  IF ARG_PRESENT(DetEff) NE 0 THEN DetEff = self.deteff
  IF ARG_PRESENT(NormTrans) NE 0 THEN NormTrans = self.normtrans
  IF ARG_PRESENT(NormRange_Min) NE 0 THEN NormRange_Min = self.normrange_min
  IF ARG_PRESENT(NormRange_Max) NE 0 THEN NormRange_Max = self.normrange_max
  IF ARG_PRESENT(LambdaBins_Min) NE 0 THEN LambdaBins_Min = self.lambdabins_min
  IF ARG_PRESENT(LambdaBins_Max) NE 0 THEN LambdaBins_Max = self.lambdabins_max
  IF ARG_PRESENT(LambdaBins_Step) NE 0 THEN $
    LambdaBins_Step = self.lambdabins_step
  IF ARG_PRESENT(DumpTOF) NE 0 THEN DumpTOF = self.dumptof
  IF ARG_PRESENT(DumpWave) NE 0 THEN DumpWave = self.dumpwave
  IF ARG_PRESENT(WhiteNorm) NE 0 THEN WhiteNorm = self.whitenorm
  IF ARG_PRESENT(DumpEt) NE 0 THEN DumpEt = self.dumpet
  IF ARG_PRESENT(DumpTIB) NE 0 THEN DumpTIB = self.dumptib
  IF ARG_PRESENT(LambdaRatio) NE 0 THEN LambdaRatio = self.lambdaratio
  IF ARG_PRESENT(Lo_Threshold) NE 0 THEN Lo_Threshold = self.lo_threshold
  IF ARG_PRESENT(Hi_Threshold) NE 0 THEN Hi_Threshold = self.hi_threshold
  IF ARG_PRESENT(Timing) NE 0 THEN Timing = self.timing
  IF ARG_PRESENT(Jobs) NE 0 THEN Jobs = self.jobs
  IF ARG_PRESENT(NormLocation) NE 0 THEN NormLocation = self.normlocation
  IF ARG_PRESENT(UseHome) NE 0 THEN UseHome = self.usehome
  IF ARG_PRESENT(ProtonCurrentUnits) NE 0 THEN ProtonCurrentUnits = self.ProtonCurrentUnits
  
END

;+
; :Description:
;    Sets command line properties
;
; :Keywords:
;    Program
;    Version
;    Queue
;    Verbose
;    Quiet
;    DataRun
;    Output
;    Instrument
;    Facility
;    Proposal
;    ConfigFile
;    InstGeometry
;    LowerBank
;    UpperBank
;    DataPaths
;    EmptyCan
;    BlackCan
;    Dark
;    USmonPath
;    DSmonPath
;    ROIfile
;    Tmin
;    Tmax
;    TIBconst
;    TIBrange_Min
;    TIBrange_Max
;    Ei
;    Tzero
;    error_ei
;    error_tzero
;    NoMonitorNorm
;    PCnorm
;    MonRange_Min
;    MonRange_Max
;    DetEff
;    NormTrans
;    NormRange_Min
;    NormRange_Max
;    LambdaBins_Min
;    LambdaBins_Max
;    LambdaBins_Step
;    DumpTOF
;    DumpWave
;    WhiteNorm
;    DumpEt
;    DumpTIB
;    Lo_Threshold
;    Hi_Threshold
;    Timing
;    Jobs
;    UseHome
;    _Extra
;
; :Author: scu
;-
PRO NormCmd::SetProperty, $
    Program=program, $                   ; Program name
    Version=version, $
    Queue=queue, $                       ; Name of Queue
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    DataRun=datarun, $                   ; Data filename(s)
    Output=output, $                     ; Output
    Instrument=instrument, $             ; Instrument Name
    Facility=facility, $                 ; Facility Name
    Proposal=proposal, $                 ; Proposal ID
    ConfigFile=configfile, $             ; Config (.rmd) filename
    InstGeometry=instgeometry, $         ; Instrument Geometry filename
    LowerBank=lowerbank, $               ; Lower Detector Bank
    UpperBank=upperbank, $               ; Upper Detector Bank
    DataPaths=datapaths, $               ; detector data paths
    EmptyCan=emptycan, $                 ; Empty Can file
    BlackCan=blackcan, $                 ; Black Sample file
    Dark=dark, $                         ; Dark current file
    USmonPath=usmonpath, $               ; Upstream monitor path
    DSmonPath=dsmonpath, $               ; Downstream monitor path
    ROIfile=roifile, $                   ; ROI file
    Tmin=tmin, $                         ; minimum tof
    Tmax=tmax, $                         ; maximum tof
    TIBconst=tibconst, $                 ; Time Independent Bkgrd constant
    TIBrange_Min=tibrange_min, $         ; Range for calculating TIB constant
    TIBrange_Max=tibrange_max, $         ; Range for calculating TIB constant
    Ei=ei, $                             ; Incident Energy (meV)
    Tzero=tzero, $                       ; T0
    error_ei=error_ei, $                 ; Error in Incident Energy (meV)
    error_tzero=error_tzero, $           ; Error in T0
    NoMonitorNorm=nomonitornorm, $       ; Turn off monitor normalisation
    PCnorm=pcnorm, $                     ; Proton Charge Normalisation
    MonRange_Min=monrange_min, $         ; Monitor integration range (usec) (min)
    MonRange_Max=monrange_max, $         ; Monitor integration range (usec) (max)
    DetEff=deteff, $                     ; Detector efficiency
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange_Min=normrange_min, $       ; normalisation integration range (meV) (min)
    NormRange_Max=normrange_max, $       ; normalisation integration range (meV) (max)
    LambdaBins_Min=lambdabins_min, $     ; wavelength bins (min)
    LambdaBins_Max=lambdabins_max, $     ; wavelength bins (max)
    LambdaBins_Step=lambdabins_step, $   ; wavelength bins (step)
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    WhiteNorm=whitenorm, $               ; White beam normalisation
    DumpEt=dumpet, $                     ; Dump combined Et file
    DumpTIB=dumptib, $                   ; Dump the TIB constant for all pixels
    Lo_Threshold=lo_threshold, $         ; Threshold for pixel to be masked (default: 0)
    Hi_Threshold=hi_threshold, $         ; Threshold for pixel to be masked (default: infinity)
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs
    NormLocation=normlocation, $         ; Setting for location of norm files ('INST','PROP','HOME')
    UseHome=usehome, $                   ; Flag to indicate whether we should write to the home directory
    ProtonCurrentUnits=ProtonCurrentUnits, $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  IF N_ELEMENTS(program) NE 0 THEN self.program = program
  IF N_ELEMENTS(version) NE 0 THEN self.version = version
  IF N_ELEMENTS(queue) NE 0 THEN self.queue = queue
  IF N_ELEMENTS(verbose) NE 0 THEN self.verbose = verbose
  IF N_ELEMENTS(quiet) NE 0 THEN self.quiet = quiet
  IF N_ELEMENTS(datarun) NE 0 THEN self.datarun = STRCOMPRESS(STRING(datarun), /REMOVE_ALL)
  IF N_ELEMENTS(output) NE 0 THEN self.output = output
  IF N_ELEMENTS(instrument) NE 0 THEN BEGIN
    self.instrument = STRUPCASE(instrument)
    case (STRUPCASE(instrument)) of
      "ARCS": begin
        self.facility = "SNS"
        self.queue = "arcs"
      end
      "CNCS": begin
        self.facility = "SNS"
        self.queue = "cncsq"
      end
      "SEQUOIA": begin
        self.instrument = "SEQ"
        self.facility = "SNS"
        self.queue = "sequoiaq"
      end
      "MAPS": begin
        self.facility = "ISIS"
      end
      "MARI": begin
        self.facility = "ISIS"
      end
      "MERLIN": begin
        self.facility = "ISIS"
      end
      else: begin
        ; If it's an unknown instrument then we can't know the facility!
        self.facility = ""
      end
    endcase
  ENDIF
  IF N_ELEMENTS(facility) NE 0 THEN self.facility = STRUPCASE(facility)
  IF N_ELEMENTS(proposal) NE 0 THEN self.proposal = STRUPCASE(proposal)
  IF N_ELEMENTS(spe) NE 0 THEN self.spe = spe
  IF N_ELEMENTS(configfile) NE 0 THEN self.configfile = configfile
  IF N_ELEMENTS(instgeometry) NE 0 THEN self.instgeometry = instgeometry
  IF N_ELEMENTS(lowerbank) NE 0 THEN self.lowerbank = lowerbank
  IF N_ELEMENTS(upperbank) NE 0 THEN self.upperbank = upperbank
  IF N_ELEMENTS(datapaths) NE 0 THEN self.datapaths = datapaths
  
  IF N_ELEMENTS(emptycan) NE 0 THEN $
    self.emptycan = STRCOMPRESS(STRING(EmptyCan), /REMOVE_ALL)
  ; Don't let it be set to 0
  IF (self.emptycan EQ '0') THEN self.emptycan = ""
  
  IF N_ELEMENTS(blackcan) NE 0 THEN $
    self.blackcan = STRCOMPRESS(STRING(BlackCan), /REMOVE_ALL)
  ; Don't let it be set to 0
  IF (self.blackcan EQ '0') THEN self.blackcan = ""
  
  IF N_ELEMENTS(dark) NE 0 THEN $
    self.dark = STRCOMPRESS(STRING(dark), /REMOVE_ALL)
  ; Don't let it be set to 0
  IF (self.dark EQ '0') THEN self.dark = ""
  
  IF N_ELEMENTS(usmonpath) NE 0 THEN self.usmonpath = USmonPath
  IF N_ELEMENTS(dsmonpath) NE 0 THEN self.dsmonpath = DSmonPath
  IF N_ELEMENTS(roifile) NE 0 THEN self.roifile = ROIfile
  IF N_ELEMENTS(tmin) NE 0 THEN self.tmin = Tmin
  IF N_ELEMENTS(tmax) NE 0 THEN self.tmax = Tmax
  IF N_ELEMENTS(tibconst) NE 0 THEN self.tibconst = TIBconst
  IF N_ELEMENTS(TIBrange_Min) NE 0 THEN self.tibrange_min = TIBrange_Min
  IF N_ELEMENTS(TIBrange_Max) NE 0 THEN self.tibrange_max = TIBrange_Max
  IF N_ELEMENTS(ei) NE 0 THEN self.ei = Ei
  IF N_ELEMENTS(tzero) NE 0 THEN self.tzero = Tzero
  IF N_ELEMENTS(error_ei) NE 0 THEN self.error_ei = error_ei
  IF N_ELEMENTS(error_tzero) NE 0 THEN self.error_tzero = error_tzero
  IF N_ELEMENTS(nomonitornorm) NE 0 THEN self.nomonitornorm = NoMonitorNorm
  IF N_ELEMENTS(pcnorm) NE 0 THEN self.pcnorm = pcnorm
  IF N_ELEMENTS(monrange_min) NE 0 THEN self.monrange_min = MonRange_Min
  IF N_ELEMENTS(monrange_max) NE 0 THEN self.monrange_max = MonRange_Max
  IF N_ELEMENTS(deteff) NE 0 THEN self.deteff = deteff
  IF N_ELEMENTS(normtrans) NE 0 THEN self.normtrans = NormTrans
  IF N_ELEMENTS(normrange_min) NE 0 THEN self.normrange_min = normrange_min
  IF N_ELEMENTS(normrange_max) NE 0 THEN self.normrange_max = normrange_max
  IF N_ELEMENTS(lambdabins_min) NE 0 THEN self.lambdabins_min = lambdabins_min
  IF N_ELEMENTS(lambdabins_max) NE 0 THEN self.lambdabins_max = lambdabins_max
  IF N_ELEMENTS(lambdabins_step) NE 0 THEN $
    self.lambdabins_step = lambdabins_step
  IF N_ELEMENTS(dumptof) NE 0 THEN self.dumptof = DumpTOF
  IF N_ELEMENTS(dumpwave) NE 0 THEN self.dumpwave = DumpWave
  IF N_ELEMENTS(whitenorm) NE 0 THEN self.whitenorm = WhiteNorm
  IF N_ELEMENTS(dumpet) NE 0 THEN self.dumpet = DumpEt
  IF N_ELEMENTS(dumptib) NE 0 THEN self.dumptib = DumpTIB
  IF N_ELEMENTS(lo_threshold) NE 0 THEN self.lo_threshold = Lo_Threshold
  IF N_ELEMENTS(hi_threshold) NE 0 THEN self.hi_threshold = Hi_Threshold
  IF N_ELEMENTS(timing) NE 0 THEN self.timing = Timing
  IF N_ELEMENTS(jobs) NE 0 THEN self.jobs = jobs
  IF N_ELEMENTS(NormLocation) NE 0 THEN BEGIN
    self.NormLocation = STRUPCASE(NormLocation)
  ENDIF
  IF N_ELEMENTS(UseHome) NE 0 THEN self.usehome = UseHome
  IF N_ELEMENTS(ProtonCurrentUnits) NE 0 THEN self.ProtonCurrentUnits = ProtonCurrentUnits
  IF N_ELEMENTS(extra) NE 0 THEN *self.extra = extra
  
END

;+
; :Description:
;    Returns the first run number from the datarun property.
;    This is used for naming files/directories/jobs when more than
;    one file is specified.
;
;    e.g. datarun="1234-1250" would return "1234"
;         datarun="1234,1235" would return "1234"
;         datarun="1250,1243-1249" would return "1250"
;
; :Author: scu (campbellsi@ornl.gov)
;-
FUNCTION NormCmd::GetRunNumber

  largeNumber = 9999999
  
  ; The runs should be delimited by either a - or ,
  
  ; Lets find see if there are any commas
  commaPosition = STRPOS(self.datarun, ',')
  IF commaPosition EQ -1 THEN commaPosition = largeNumber
  
  hyphenPosition = STRPOS(self.datarun, '-')
  IF hyphenPosition EQ -1 THEN hyphenPosition = largeNumber
  
  firstDelimiter = MIN([commaPosition, hyphenPosition])
  
  RETURN, STRMID(self.datarun, 0, firstDelimiter)
  
END

;+
; :Description:
;    Returns the directory where the results from a normalisation
;    job will be written.
;
;-
FUNCTION NormCmd::GetNormalisationOutputDirectory

  directory = ''
  
  case (self.NormLocation) of
    'INST': begin
      ; Use the instrument shared directory
      directory = '/SNS/' + self.instrument + '/shared/norm/' + $
        getFirstNumber(self.datarun)
    end
    'PROP': BEGIN
      directory = get_output_directory(self.instrument, $
        getFirstNumber(self.datarun), /NO_USERDIR)
    END
    'HOME': BEGIN
      directory = get_output_directory(self.instrument, $
        getFirstNumber(self.datarun), $
        HOME=1)
    END
    else: begin
    
    end
  endcase
  
  ; print,'NormCmd Norm Directory = ',directory
  RETURN, directory
END

;+
; :Description:
;    Procedure to check that all essential parameters have
;    been defined.  Also, that we haven't specified any
;    conflicting options.
;
;    It is intended for producing a string array for display
;    in the bottom of the GUI and a status flag to enable/disable
;    the execute button.
;
;-
function NormCmd::Check

  ; Let's start out with everything well in the world!
  ok = 1
  datapaths_bad = 0
  msg = ['Everything looks good.']
  
  ;  normDir = self->GetNormalisationOutputDirectory()
  ;  IF (FILE_TEST(normDir, /DIRECTORY, /WRITE) NE 1) THEN BEGIN
  ;    ok = 1
  ;    msg = [msg,['You cannot write to the specified normalisation directory: ' + normDir]]
  ;  ENDIF
  
  IF (STRLEN(self.instrument) LT 2) THEN BEGIN
    ok = 0
    msg = [msg,['There is no Instrument selected.']]
  ENDIF
  
  IF (STRLEN(self.datarun) LT 1) THEN BEGIN
    ok = 0
    msg = [msg,["There doesn't seem to be a Vanadium RUN NUMBER defined."]]
  ENDIF
  
  ; Just construct the DataPaths for the first job.
  datapaths = Construct_DataPaths(self.lowerbank, self.upperbank, 1, self.jobs)
  IF (STRLEN(datapaths) LT 1) THEN BEGIN
    datapaths_bad = 1
    ok = 0
    msg = [msg,['The Detector Banks are not specified correctly.']]
  END
  
  ; Also check for the last job (but only if the first job check above was ok)
  datapaths = Construct_DataPaths(self.lowerbank, self.upperbank, self.jobs, self.jobs)
  IF (STRLEN(datapaths) LT 1) AND (datapaths_bad NE 1) THEN BEGIN
    ok = 0
    msg = [msg,['The Detector Banks are not specified correctly.']]
  END
  
  ; Incident Energy
  IF (STRLEN(self.ei) LT 1) THEN BEGIN
    ok = 0
    msg = [msg,['You need to define the Incident Energy (Ei).']]
  ENDIF
  
  ; T0
  IF (STRLEN(self.tzero) LT 1) THEN BEGIN
    ok = 0
    msg = [msg,['You need to define a value for T0.']]
  ENDIF
  
  ; Now let's do some more complicated dependencies
  
  ; If Empty Can OR Black Can then we must specify Data Coeff
  IF (STRLEN(self.emptycan) GE 1) OR (STRLEN(self.blackcan) GE 1) THEN BEGIN
    IF (STRLEN(self.normtrans) LT 1) THEN BEGIN
      ok = 0
      msg = [msg,["ERROR: You need to specify and value for 'Norm Coeff' " + $
        "if you have specified either an Empty Can or a Black Can."]]
    ENDIF
  ENDIF
  
  ; You cannot have a Dark current and any TIB
  IF (STRLEN(self.tibconst) GE 1) OR (STRLEN(self.tibrange_min) GE 1) $
    OR (STRLEN(self.tibrange_min) GE 1) THEN BEGIN
    IF (STRLEN(self.dark) GE 1) AND (self.dark NE 0) THEN BEGIN
      ok = 0
      msg = [msg,["ERROR: You cannot specify a Dark Current together with a " + $
        "Time-Independent-Background."]]
    ENDIF
  ENDIF
  
  ; Cannot have both a TIB constant and a TIB range
  IF (STRLEN(self.tibconst) GE 1) AND ((STRLEN(self.tibrange_min) GE 1) OR (STRLEN(self.tibrange_max) GE 1)) THEN BEGIN
    ok = 0
    msg = [msg,['ERROR: You cannot specify a TIB constant and a TIB range.']]
  ENDIF
  
  ; Need to specify a min/max for the monitor integration if we are normalising to the monitor
  IF (self.nomonitornorm EQ 0) THEN BEGIN
    IF (STRLEN(self.monrange_min) LT 1) OR (STRLEN(self.monrange_max) LT 1) THEN BEGIN
      ok = 0
      msg = [msg,['If you are normalising to the monitor, you need to specify a monitor integration range.']]
    ENDIF
  ENDIF
  
  ; Remove the first blank String
  IF (N_ELEMENTS(msg) GT 1) THEN msg = msg(1:*)
  
  data = { ok : ok, $
    message : msg}
    
  return, data
end



function NormCmd::Generate

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  cmd = STRARR(self.jobs)
  
  ; Let's get the output directory so we don't have to keep asking for it!
  outputDir = self->GetNormalisationOutputDirectory()
  
  for i = 0L, self.jobs-1 do begin
  
    cmd[i] = ""
    
    ; Queue name
    ;IF STRLEN(self.queue) GT 1 THEN cmd[i] += "sbatch -p " + self.queue + " "
    
    ; Let's first start with the program name!
    cmd[i] += self.program
    
    ; Verbose flag
    IF (self.verbose EQ 1) THEN cmd[i] += " -v"
    ; Quiet flag
    IF (self.quiet EQ 1) THEN cmd[i] += " -q"
    ; Data filename(s)
    IF STRLEN(self.datarun) GE 1 THEN cmd[i] += " " + STRCOMPRESS(STRING(self.datarun), /REMOVE_ALL)
    
    ; Output (this is automatically generated for now!)
    ;IF STRLEN(self.output) GT 1 THEN cmd[i] += " --output="+ self.output
    
    IF (STRLEN(self.instrument) GT 1) AND (STRLEN(self.datarun) GE 1) THEN $
      cmd[i] += " --output=" + outputDir + $
      "/" + self.instrument + "_bank" + Construct_DataPaths(self.lowerbank, self.upperbank, $
      i+1, self.jobs, /PAD) + ".txt"
      
    ; Instrument Name
    IF STRLEN(self.instrument) GT 1 THEN cmd[i] += " --inst="+self.instrument
    ; Facility
    IF STRLEN(self.facility) GT 1 THEN cmd[i] += " --facility="+self.facility
    ; Proposal
    IF STRLEN(self.proposal) GT 1 THEN cmd[i] += " --proposal="+self.proposal
    
    ; Config (.rmd) file
    IF STRLEN(self.configfile) GT 1 THEN $
      cmd[i] += " --config="+self.configfile
    ; Instrument Geometry
    IF STRLEN(self.instgeometry) GT 1 THEN $
      cmd[i] += " --inst-geom="+self.instgeometry
    ; Corner Geometry
      
    ; DataPaths
    ; Construct the DataPaths
    self.datapaths = Construct_DataPaths(self.lowerbank, self.upperbank, $
      i+1, self.jobs)
    IF STRLEN(self.datapaths) GE 1 THEN $
      cmd[i] += " --data-paths="+self.datapaths
      
    ; Empty sample container file
    IF (STRLEN(self.emptycan) GE 1) AND (self.emptycan NE 0) THEN $
      cmd[i] += " --ecan="+self.emptycan
    ; black sample container file
    IF (STRLEN(self.blackcan) GE 1) AND (self.blackcan NE 0) THEN $
      cmd[i] += " --bcan="+self.blackcan
    ; Dark Current File
    IF (STRLEN(self.dark) GE 1) AND (self.dark NE 0) THEN $
      cmd[i] += " --dkcur="+self.dark
    ; Upstream monitor path
    IF (STRLEN(self.usmonpath) GE 1) AND $
      (STRCOMPRESS(self.usmonpath, /REMOVE_ALL) NE '0') THEN $
      cmd[i] += " --usmon-path=/entry/monitor" + STRCOMPRESS(self.usmonpath, /REMOVE_ALL) + ",1"
    ; Downstream monitor path
    IF STRLEN(self.dsmonpath) GE 1 THEN $
      cmd[i] += " --dsmon-path="+self.dsmonpath
    ; ROI filename
    IF STRLEN(self.roifile) GE 1 THEN $
      cmd[i] += " --roi-file="+self.roifile
    ; Tmin
    IF STRLEN(self.tmin) GE 1 THEN $
      cmd[i] += " --tof-cut-min="+self.tmin
    ; Tmax
    IF STRLEN(self.tmax) GE 1 THEN $
      cmd[i] += " --tof-cut-max="+self.tmax
      
    ; Time Independent Background (TIB)
    IF STRLEN(self.tibconst) GE 1 THEN $
      cmd[i] += " --tib-const="+self.tibconst+',0'
      
    ;print, '--Generate--'
    ;print, self.tibrange_min,' ', self.tibrange_max
    ;print, STRLEN(STRCOMPRESS(STRING(self.tibrange_min)),/REMOVE_ALL), ' ', $
    ;		STRLEN(STRCOMPRESS(STRING(self.tibrange_max GE 1)),/REMOVE_ALL)
      
    ;  TIB constant determination range
    IF (STRLEN(STRING(self.tibrange_min)) GE 1) $
      AND (STRLEN(STRING(self.tibrange_max)) GE 1) THEN BEGIN
      cmd[i] += " --tib-range=" + self.tibrange_min + " " + self.tibrange_max
    ;print, 'got here'
    ;	print, cmd[i]
    ENDIF
    
    ; Ei
    IF STRLEN(self.ei) GE 1 THEN $
      cmd[i] += " --initial-energy="+self.ei+","+self.error_ei
    ; T0
    IF STRLEN(self.tzero) GE 1 THEN $
      cmd[i] += " --time-zero-offset="+self.tzero+","+self.error_tzero
    ; Flag for turning off monitor normalization
    IF (self.nomonitornorm EQ 1) THEN cmd[i] += " --no-mon-norm"
    ; proton charge normalization
    IF (self.pcnorm EQ 1) AND (self.nomonitornorm EQ 1) THEN cmd[i] += " --pc-norm"
    ; Monitor integration range
    IF (STRLEN(self.monrange_min) GE 1) $
      AND (STRLEN(self.monrange_max) GE 1) THEN $
      cmd[i] += " --mon-int-range=" + self.monrange_min + " " + self.monrange_max
    ; Detector Efficiency
    IF STRLEN(self.deteff) GE 1 THEN $
      cmd[i] += " --det-eff="+self.deteff
      
      
    ; transmission for norm data background
    IF STRLEN(self.normtrans) GE 1 THEN $
      cmd[i] += " --norm-trans-coeff=" + self.normtrans + ",0.0"
    ; Normalisation integration range
    IF (STRLEN(self.normrange_min) GE 1 ) $
      AND (STRLEN(self.normrange_max) GE 1) THEN $
      cmd[i] += " --norm-int-range " + self.normrange_min + " " $
      + self.normrange_max
    ; Lambda Bins
    IF (STRLEN(self.lambdabins_min) GE 1) $
      AND (STRLEN(self.lambdabins_max) GE 1) $
      AND (STRLEN(self.lambdabins_step) GE 1) $
      AND (self.dumpwave EQ 1) THEN $
      cmd[i] += " --lambda-bins=" + self.lambdabins_min + "," + $
      self.lambdabins_max + "," + self.lambdabins_step
      
    IF (self.dumptof EQ 1) THEN cmd[i] += " --dump-ctof-comb"
    IF (self.dumpwave EQ 1) THEN cmd[i] += " --dump-wave-comb"
    
    IF (self.whitenorm EQ 1) THEN cmd[i] += " --wb-norm"
    
    IF (self.dumpet EQ 1) THEN cmd[i] += " --dump-et-comb"
    
    IF (self.dumptib EQ 1) THEN cmd[i] += " --dump-tib"
    
    IF STRLEN(self.lo_threshold) GE 1 THEN $
      cmd[i] += " --lo-threshold="+self.lo_threshold
      
    IF STRLEN(self.hi_threshold) GE 1 THEN $
      cmd[i] += " --hi-threshold="+self.hi_threshold
      
    IF (STRLEN(self.ProtonCurrentUnits) GE 1) THEN $
      cmd[i] += " --scale-pc=" + self.ProtonCurrentUnits
      
    IF (self.timing EQ 1) THEN cmd[i] += " --timing"
    
  endfor
  
  return, cmd
end

function NormCmd::Init, $
    Program=program, $                   ; Program name
    Version=version, $
    Queue=queue, $                       ; Name of Queue
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    DataRun=datarun, $                   ; Data filename(s)
    Output=output, $                     ; Output
    Instrument=instrument, $             ; Instrument Name
    Facility=facility, $                 ; Facility Name
    Proposal=proposal, $                 ; Proposal ID
    ConfigFile=configfile, $             ; Config (.rmd) filename
    InstGeometry=instgeometry, $         ; Instrument Geometry filename
    LowerBank=lowerbank, $               ; Lower Detector Bank
    UpperBank=upperbank, $               ; Upper Detector Bank
    DataPaths=datapaths, $               ; detector data paths
    EmptyCan=emptycan, $                 ; Empty Can file
    BlackCan=blackcan, $                 ; Black Sample file
    Dark=dark, $                         ; Dark current file
    USmonPath=usmonpath, $               ; Upstream monitor path
    DSmonPath=dsmonpath, $               ; Downstream monitor path
    ROIfile=roifile, $                   ; ROI file
    Tmin=tmin, $                         ; minimum tof
    Tmax=tmax, $                         ; maximum tof
    TIBconst=tibconst, $                 ; Time Independent Bkgrd constant
    TIBrange_Min=tibrange_min, $         ; Range for calculating TIB constant
    TIBrange_Max=tibrange_max, $         ; Range for calculating TIB constant
    Ei=ei, $                             ; Incident Energy (meV)
    Tzero=tzero, $                       ; T0
    error_ei=error_ei, $                 ; Error in Incident Energy (meV)
    error_tzero=error_tzero, $           ; Error in T0
    NoMonitorNorm=nomonitornorm, $       ; Turn off monitor normalisation
    PCnorm=pcnorm, $                     ; Proton Charge Normalisation
    MonRange_Min=monrange_min, $         ; Monitor integration range (usec) (min)
    MonRange_Max=monrange_max, $         ; Monitor integration range (usec) (max)
    DetEff=deteff, $                     ; Detector efficiency
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange_Min=normrange_min, $       ; normalisation integration range (meV) (min)
    NormRange_Max=normrange_max, $       ; normalisation integration range (meV) (max)
    LambdaBins_Min=lambdabins_min, $     ; wavelength bins (min)
    LambdaBins_Max=lambdabins_max, $     ; wavelength bins (max)
    LambdaBins_Step=lambdabins_step, $   ; wavelength bins (step)
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    WhiteNorm=whitenorm, $               ; White beam normalisation
    DumpEt=dumpet, $                     ; Dump combined Et file
    DumpTIB=dumptib, $                   ; Dump the TIB constant for all pixels
    Lo_Threshold=lo_threshold, $         ; Threshold for pixel to be masked (default: 0)
    Hi_Threshold=hi_threshold, $         ; Threshold for pixel to be masked (default: infinity)
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs
    NormLocation=normlocation, $         ; Setting for location of norm files ('INST','PROP','HOME')
    UseHome=usehome, $                   ; Flag to indicate whether we should write to the home directory
    ProtonCurrentUnits=ProtonCurrentUnits, $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  IF N_ELEMENTS(program) EQ 0 THEN program = "dgs_norm"
  IF N_ELEMENTS(version) EQ 0 THEN version = ""
  IF N_ELEMENTS(queue) EQ 0 THEN queue = ""
  IF N_ELEMENTS(verbose) EQ 0 THEN verbose = 1
  IF N_ELEMENTS(quiet) EQ 0 THEN quiet = 0
  IF N_ELEMENTS(datarun) EQ 0 THEN datarun = ""
  IF N_ELEMENTS(output) EQ 0 THEN output = ""
  IF N_ELEMENTS(instrument) EQ 0 THEN instrument = ""
  IF N_ELEMENTS(facility) EQ 0 THEN facility = ""
  IF N_ELEMENTS(proposal) EQ 0 THEN proposal = ""
  IF N_ELEMENTS(configfile) EQ 0 THEN configfile = ""
  IF N_ELEMENTS(instgeometry) EQ 0 THEN instgeometry = ""
  IF N_ELEMENTS(lowerbank) EQ 0 THEN lowerbank = 0
  IF N_ELEMENTS(upperbank) EQ 0 THEN upperbank = 0
  IF N_ELEMENTS(datapaths) EQ 0 THEN datapaths = ""
  IF N_ELEMENTS(emptycan) EQ 0 THEN emptycan = ""
  IF N_ELEMENTS(blackcan) EQ 0 THEN blackcan = ""
  IF N_ELEMENTS(dark) EQ 0 THEN dark = ""
  IF N_ELEMENTS(usmonpath) EQ 0 THEN usmonpath = ''
  IF N_ELEMENTS(dsmonpath) EQ 0 THEN dsmonpath = ""
  IF N_ELEMENTS(roifile) EQ 0 THEN roifile = ""
  IF N_ELEMENTS(tmin) EQ 0 THEN tmin = ""
  IF N_ELEMENTS(tmax) EQ 0 THEN tmax = ""
  IF N_ELEMENTS(tibconst) EQ 0 THEN tibconst = ""
  IF N_ELEMENTS(tibrange_min) EQ 0 THEN tibrange_min = ""
  IF N_ELEMENTS(tibrange_max) EQ 0 THEN tibrange_max = ""
  IF N_ELEMENTS(ei) EQ 0 THEN ei = ""
  IF N_ELEMENTS(error_ei) EQ 0 THEN error_ei = '0.0'
  IF N_ELEMENTS(tzero) EQ 0 THEN tzero = ""
  IF N_ELEMENTS(error_tzero) EQ 0 THEN error_tzero = '0.0'
  IF N_ELEMENTS(nomonitornorm) EQ 0 THEN nomonitornorm = 0
  IF N_ELEMENTS(pcnorm) EQ 0 THEN pcnorm = 0
  IF N_ELEMENTS(monrange_min) EQ 0 THEN monrange_min = ""
  IF N_ELEMENTS(monrange_max) EQ 0 THEN monrange_max = ""
  IF N_ELEMENTS(deteff) EQ 0 THEN deteff = ""
  IF N_ELEMENTS(normtrans) EQ 0 THEN normtrans = ""
  IF N_ELEMENTS(normrange_min) EQ 0 THEN normrange_min = ""
  IF N_ELEMENTS(normrange_max) EQ 0 THEN normrange_max = ""
  IF N_ELEMENTS(lambdabins_min) EQ 0 THEN lambdabins_min = ""
  IF N_ELEMENTS(lambdabins_max) EQ 0 THEN lambdabins_max = ""
  IF N_ELEMENTS(lambdabins_step) EQ 0 THEN lambdabins_step = ""
  IF N_ELEMENTS(dumptof) EQ 0 THEN dumptof = 0
  IF N_ELEMENTS(dumpwave) EQ 0 THEN dumpwave = 0
  IF N_ELEMENTS(whitenorm) EQ 0 THEN whitenorm = 0
  IF N_ELEMENTS(dumpet) EQ 0 THEN dumpet = 0
  IF N_ELEMENTS(dumptib) EQ 0 THEN dumptib = 0
  IF N_ELEMENTS(lo_threshold) EQ 0 THEN lo_threshold = ""
  IF N_ELEMENTS(hi_threshold) EQ 0 THEN hi_threshold = ""
  IF N_ELEMENTS(timing) EQ 0 THEN timing = 0
  IF N_ELEMENTS(jobs) EQ 0 THEN jobs = 1
  IF N_ELEMENTS(NormLocation) EQ 0 THEN NormLocation = ""
  IF N_ELEMENTS(UseHome) EQ 0 THEN UseHome = 0
  IF N_ELEMENTS(ProtonCurrentUnits) EQ 0 THEN ProtonCurrentUnits = ""
  
  self.program = program
  self.version = version
  self.queue = queue
  self.verbose = verbose
  self.quiet = quiet
  self.datarun = datarun
  self.output = output
  self.instrument = instrument
  self.facility = facility
  self.proposal = proposal
  self.configfile = configfile
  self.instgeometry = instgeometry
  self.lowerbank = lowerbank
  self.upperbank = upperbank
  self.datapaths = datapaths
  self.emptycan = emptycan
  self.blackcan = blackcan
  self.dark = dark
  self.usmonpath = usmonpath
  self.dsmonpath = dsmonpath
  self.roifile = roifile
  self.tmin = tmin
  self.tmax = tmax
  self.tibconst = tibconst
  self.tibrange_min = tibrange_min
  self.tibrange_max = tibrange_max
  self.ei = ei
  self.error_ei = error_ei
  self.tzero = tzero
  self.error_tzero = error_tzero
  self.nomonitornorm = nomonitornorm
  self.pcnorm = pcnorm
  self.monrange_min = monrange_min
  self.monrange_max = monrange_max
  self.deteff = deteff
  self.normtrans = normtrans
  self.normrange_min = normrange_min
  self.normrange_max = normrange_max
  self.lambdabins_min = lambdabins_min
  self.lambdabins_max = lambdabins_max
  self.lambdabins_step = lambdabins_step
  self.dumptof = dumptof
  self.dumpwave = dumpwave
  self.dumpet = dumpet
  self.dumptib = dumptib
  self.whitenorm = whitenorm
  self.lo_threshold = lo_threshold
  self.hi_threshold = hi_threshold
  self.timing = timing
  self.jobs = jobs
  self.normlocation = normlocation
  self.usehome = UseHome
  self.ProtonCurrentUnits = protoncurrentunits
  self.extra = PTR_NEW(extra)
  
  RETURN, 1
end

;+
; :Description:
;    NormCmd Define.
;
; :Author: scu
;-
pro NormCmd__Define

  struct = { NORMCMD, $
    program: "", $           ; Program name
    version: "", $           ; Program version
    queue: "", $             ; Queue to use
    verbose: 0L, $           ; Verbose flag
    quiet: 0L, $             ; Quiet flag
    datarun: "", $           ; Data filename(s)
    output: "", $            ; Output
    instrument: "", $        ; Instrument (short) name
    facility: "", $          ; Facility name
    proposal: "", $          ; Proposal ID
    configfile: "", $        ; Config (.rmd) filename
    instgeometry: "", $      ; Instrument Geometry filename
    lowerbank: 0L, $         ; Lower Detector Bank
    upperbank: 0L, $         ; Upper Detector Bank
    datapaths: "", $         ; Detector Data Paths
    emptycan: "", $          ; Empty Can file
    blackcan: "", $          ; Black Sample file
    dark: "", $              ; Dark current file
    usmonpath: "", $         ; Upstream monitor path
    dsmonpath: "", $         ; Downstream monitor path
    roifile: "", $           ; ROI file
    tmin: "", $              ; minimum tof
    tmax: "", $              ; maximum tof
    tibconst: "", $          ; Time Independant Background constant
    tibrange_min: "", $      ; Range for calculating TIB constant
    tibrange_max: "", $      ; Range for calculating TIB constant
    ei: "", $                ; Incident Energy (meV)
    error_ei: "", $          ; Error in Incident Energy (meV)
    tzero: "", $             ; T0
    error_tzero: "", $       ; Error in T0
    nomonitornorm: 0L, $     ; Turn off monitor normalisation
    pcnorm: 0L, $            ; Proton Charge Normalisation
    monrange_min: "", $      ; Monitor integration range (usec) (min)
    monrange_max: "", $      ; Monitor integration range (usec) (max)
    deteff: "", $            ; Detector efficiency
    normtrans: "", $         ; transmission for norm data background
    normrange_min: "", $     ; normalisation (vanadium) integration range (meV)
    normrange_max: "", $     ; normalisation (vanadium) integration range (meV)
    lambdabins_min: "", $    ; wavelength bins (min)
    lambdabins_max: "", $    ; wavelength bins (max)
    lambdabins_step: "", $   ; wavelength bins (step)
    dumptof: 0L, $           ; Dump combined TOF file
    dumpwave: 0L, $          ; Dump combined wavelength file
    dumpet: 0L, $            ; Dump combined Et file
    dumptib: 0L, $           ; Dump the TIB constant for all pixels
    whitenorm: 0L, $         ; White beam normalisation
    hi_threshold: "", $      ; Threshold for pixel to be masked (default: infinity)
    lo_threshold: "", $      ; Threshold for pixel to be masked (default: 0.0)
    timing: 0L, $            ; Timing of code
    jobs : 0L, $             ; Number of Jobs to Run
    NormLocation: "", $      ; Setting for location of norm files ('INST','PROP','HOME')
    usehome : 0L, $          ; Flag to indicate whether we should write to the home directory
    ProtonCurrentUnits: "", $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    extra: PTR_NEW() }       ; Extra keywords
end
