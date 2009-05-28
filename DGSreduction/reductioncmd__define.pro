;+
; :Author: scu (campbellsi@ornl.gov)
;-

PRO ReductionCmd::Cleanup
  PTR_FREE, self.extra
END

PRO ReductionCmd::GetProperty, $
    Program=program, $                   ; Program name
    Version=version, $
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    DataRun=datarun, $                         ; Data filename(s)
    Output=output, $                     ; Output
    Instrument=instrument, $             ; Instrument Name
    Facility=facility, $                 ; Facility Name
    Proposal=proposal, $                 ; Proposal ID
    SPE=spe, $                           ; Create SPE/PHX files
    ConfigFile=configfile, $             ; Config (.rmd) filename
    InstGeometry=instgeometry, $         ; Instrument Geometry filename
    CornerGeometry=cornergeometry, $     ; Corner Geometry filename
    LowerBank=lowerbank, $               ; Lower Detector Bank
    UpperBank=upperbank, $               ; Upper Detector Bank
    DataPaths=datapaths, $               ; Detector Data paths
    Normalisation=normalisation, $       ; Normalisation file
    EmptyCan=emptycan, $                 ; Empty Can file
    BlackCan=blackcan, $                 ; Black Sample file
    Dark=dark, $                         ; Dark current file
    USmonPath=usmonpath, $               ; Upstream monitor path
    DSmonPath=dsmonpath, $               ; Downstream monitor path
    ROIfile=roifile, $                   ; ROI file
    Tmin=tmin, $                         ; minimum tof
    Tmax=tmax, $                         ; maximum tof
    TIBconst=tibconst, $                 ; Time Independent Bkgrd constant
    Ei=ei, $                             ; Incident Energy (meV)
    Tzero=tzero, $                       ; T0
    Ei_error=ei_error, $                 ; Error in Incident Energy (meV)
    Tzero_error=tzero_error, $           ; Error in T0
    NoMonitorNorm=nomonitornorm, $       ; Turn off monitor normalisation
    PCnorm=pcnorm, $                     ; Proton Charge Normalisation
    MonRange=monrange, $                 ; Monitor integration range (usec)
    DetEff=deteff, $                     ; Detector efficiency
    DataTrans=datatrans, $               ; transmission for sample data bkgrd
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange=normrange, $               ; normalisation integration range (meV)
    LambdaBins=lambdabins, $             ; wavelength bins
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    DumpNorm=dumpnorm, $                 ; Dump combined Norm file
    DumpEt=dumpet, $                     ; Dump combined Et file
    MaskFile=maskfile, $                 ; Mask File
    LambdaRatio=lambdaratio, $           ; Lambda ratio
    EnergyBins_min=energybins_min, $     ; Energy transfer bins (min)
    EnergyBins_max=energybins_max, $     ; Energy transfer bins (max)
    EnergyBins_step=energybins_step, $   ; Energy transfer bins (step)
    OmegaBins=omegabins, $               ; Momentum transfer bins
    Qvector=qvector, $                   ; Create Qvec mesh per energy slice
    Fixed=fixed, $                       ; dump Qvec info onto a fixed mesh
    Split=split, $                       ; split (distributed mode)
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs to run
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return
  ENDIF
  
  IF ARG_PRESENT(Instrument) NE 0 THEN Instrument = self.instrument
  
END

PRO ReductionCmd::SetProperty, $
    Program=program, $                   ; Program name
    Version=version, $
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    DataRun=datarun, $                         ; Data filename(s)
    Output=output, $                     ; Output
    Instrument=instrument, $             ; Instrument Name
    Facility=facility, $                 ; Facility Name
    Proposal=proposal, $                 ; Proposal ID
    SPE=spe, $                           ; Create SPE/PHX files
    ConfigFile=configfile, $             ; Config (.rmd) filename
    InstGeometry=instgeometry, $         ; Instrument Geometry filename
    CornerGeometry=cornergeometry, $     ; Corner Geometry filename
    LowerBank=lowerbank, $               ; Lower Detector Bank
    UpperBank=upperbank, $               ; Upper Detector Bank
    DataPaths=datapaths, $               ; Detector Data paths
    Normalisation=normalisation, $       ; Normalisation file
    EmptyCan=emptycan, $                 ; Empty Can file
    BlackCan=blackcan, $                 ; Black Sample file
    Dark=dark, $                         ; Dark current file
    USmonPath=usmonpath, $               ; Upstream monitor path
    DSmonPath=dsmonpath, $               ; Downstream monitor path
    ROIfile=roifile, $                   ; ROI file
    Tmin=tmin, $                         ; minimum tof
    Tmax=tmax, $                         ; maximum tof
    TIBconst=tibconst, $                 ; Time Independent Bkgrd constant
    Ei=ei, $                             ; Incident Energy (meV)
    Tzero=tzero, $                       ; T0
    Ei_error=ei_error, $                 ; Error in Incident Energy (meV)
    Tzero_error=tzero_error, $           ; Error in T0
    NoMonitorNorm=nomonitornorm, $       ; Turn off monitor normalisation
    PCnorm=pcnorm, $                     ; Proton Charge Normalisation
    MonRange=monrange, $                 ; Monitor integration range (usec)
    DetEff=deteff, $                     ; Detector efficiency
    DataTrans=datatrans, $               ; transmission for sample data bkgrd
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange=normrange, $               ; normalisation integration range (meV)
    LambdaBins=lambdabins, $             ; wavelength bins
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    DumpNorm=dumpnorm, $                 ; Dump combined Norm file
    DumpEt=dumpet, $                     ; Dump combined Et file
    MaskFile=maskfile, $                 ; Mask File
    LambdaRatio=lambdaratio, $           ; Lambda ratio
    EnergyBins_min=energybins_min, $     ; Energy transfer bins (min)
    EnergyBins_max=energybins_max, $     ; Energy transfer bins (max)
    EnergyBins_step=energybins_step, $   ; Energy transfer bins (step)
    OmegaBins=omegabins, $               ; Momentum transfer bins
    Qvector=qvector, $                   ; Create Qvec mesh per energy slice
    Fixed=fixed, $                       ; dump Qvec info onto a fixed mesh
    Split=split, $                       ; split (distributed mode)
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs to run
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
  IF N_ELEMENTS(verbose) NE 0 THEN self.verbose = verbose
  IF N_ELEMENTS(quiet) NE 0 THEN self.quiet = quiet
  IF N_ELEMENTS(datarun) NE 0 THEN self.datarun = datarun
  IF N_ELEMENTS(output) NE 0 THEN self.output = output
  IF N_ELEMENTS(instrument) NE 0 THEN BEGIN
    self.instrument = STRUPCASE(instrument)
    case (STRUPCASE(instrument)) of
      "ARCS": begin
        self.facility = "SNS"
      end
      "CNCS": begin
        self.facility = "SNS"
      end
      "SEQ": begin
        self.facility = "SNS"
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
        ; If it's an unknown instrument then we don't know the facility!
        self.facility = ""
      end
    endcase
  ENDIF
  IF N_ELEMENTS(facility) NE 0 THEN self.facility = STRUPCASE(facility)
  IF N_ELEMENTS(proposal) NE 0 THEN self.proposal = STRUPCASE(proposal)
  IF N_ELEMENTS(spe) NE 0 THEN self.spe = spe
  IF N_ELEMENTS(configfile) NE 0 THEN self.configfile = configfile
  IF N_ELEMENTS(instgeometry) NE 0 THEN self.instgeometry = instgeometry
  IF N_ELEMENTS(cornergeometry) NE 0 THEN self.cornergeometry = cornergeometry
  IF N_ELEMENTS(lowerbank) NE 0 THEN self.lowerbank = lowerbank
  IF N_ELEMENTS(upperbank) NE 0 THEN self.upperbank = upperbank
  IF N_ELEMENTS(datapaths) NE 0 THEN self.datapaths = datapaths
  IF N_ELEMENTS(normalisation) NE 0 THEN self.normalisation = Normalisation
  IF N_ELEMENTS(emptycan) NE 0 THEN self.emptycan = EmptyCan
  IF N_ELEMENTS(blackcan) EQ 0 THEN blackcan = BlackCan
  IF N_ELEMENTS(dark) NE 0 THEN self.dark = dark
  IF N_ELEMENTS(usmonpath) NE 0 THEN self.usmonpath = USmonPath
  IF N_ELEMENTS(dsmonpath) NE 0 THEN self.dsmonpath = DSmonPath
  IF N_ELEMENTS(roifile) NE 0 THEN self.roifile = ROIfile
  IF N_ELEMENTS(tmin) NE 0 THEN self.tmin = Tmin
  IF N_ELEMENTS(tmax) NE 0 THEN self.tmax = Tmax
  IF N_ELEMENTS(tibconst) NE 0 THEN self.tibconst = TIBconst
  IF N_ELEMENTS(ei) NE 0 THEN self.ei = Ei
  IF N_ELEMENTS(tzero) NE 0 THEN self.tzero = Tzero
  IF N_ELEMENTS(ei_error) NE 0 THEN self.ei_error = Ei_error
  IF N_ELEMENTS(tzero_error) NE 0 THEN self.tzero_error = Tzero_error
  IF N_ELEMENTS(nomonitornorm) NE 0 THEN self.nomonitornorm = NoMonitorNorm
  IF N_ELEMENTS(pcnorm) NE 0 THEN self.pcnorm = pcnorm
  IF N_ELEMENTS(monrange) NE 0 THEN self.monrange = MonRange
  IF N_ELEMENTS(deteff) NE 0 THEN self.deteff = deteff
  IF N_ELEMENTS(datatrans) NE 0 THEN self.datatrans = DataTrans
  IF N_ELEMENTS(normtrans) NE 0 THEN self.normtrans = NormTrans
  IF N_ELEMENTS(normrange) NE 0 THEN self.normrange = normrange
  IF N_ELEMENTS(lambdabins) NE 0 THEN self.lambdabins = lambdabins
  IF N_ELEMENTS(dumptof) NE 0 THEN self.dumptof = DumpTOF
  IF N_ELEMENTS(dumpwave) NE 0 THEN self.dumpwave = DumpWave
  IF N_ELEMENTS(dumpnorm) NE 0 THEN self.dumpnorm = DumpNorm
  IF N_ELEMENTS(dumpet) NE 0 THEN self.dumpet = DumpEt
  IF N_ELEMENTS(maskfile) NE 0 THEN self.maskfile = MaskFile
  IF N_ELEMENTS(lambdaratio) NE 0 THEN self.lambdaratio = LambdaRatio
  IF N_ELEMENTS(energybins_min) NE 0 THEN self.energybins_min = EnergyBins_Min
  IF N_ELEMENTS(energybins_max) NE 0 THEN self.energybins_max = EnergyBins_Max
  IF N_ELEMENTS(energybins_step) NE 0 THEN self.energybins_step = EnergyBins_step
  IF N_ELEMENTS(omegabins) NE 0 THEN self.omegabins = OmegaBins
  IF N_ELEMENTS(qvector) NE 0 THEN self.qvector = Qvector
  IF N_ELEMENTS(fixed) NE 0 THEN self.fixed = Fixed
  IF N_ELEMENTS(split) NE 0 THEN self.split = Split
  IF N_ELEMENTS(timing) NE 0 THEN self.timing = Timing
  IF N_ELEMENTS(jobs) NE 0 THEN self.jobs = jobs
  IF N_ELEMENTS(extra) NE 0 THEN *self.extra = extra
  
END

function ReductionCmd::Generate

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  cmd = STRARR(self.jobs)
  
  for i = 0L, self.jobs-1 do begin
  
    ; Let's first start with the program name!
    cmd[i] = self.program
    
    ; Verbose flag
    IF (self.verbose EQ 1) THEN cmd[i] += " -v"
    ; Quiet flag
    IF (self.quiet EQ 1) THEN cmd[i] += " -q"
    ; Data filename(s)
    IF STRLEN(self.datarun) GE 1 THEN cmd[i] += " "+ STRING(self.datarun)
    ; Output
    IF STRLEN(self.output) GT 1 THEN cmd[i] += " --output="+ self.output
    ; Instrument Name
    IF STRLEN(self.instrument) GT 1 THEN cmd[i] += " --inst="+self.instrument
    ; Facility
    IF STRLEN(self.facility) GT 1 THEN cmd[i] += " --facility="+self.facility
    ; Proposal
    IF STRLEN(self.proposal) GT 1 THEN cmd[i] += " --proposal="+self.proposal
    ; SPE/PHX creation
    IF (self.spe EQ 1) THEN cmd[i]+= " --make-spe"
    ; Config (.rmd) file
    IF STRLEN(self.configfile) GT 1 THEN $
      cmd[i] += " --config="+self.configfile
    ; Instrument Geometry
    IF STRLEN(self.instgeometry) GT 1 THEN $
      cmd[i] += " --inst-geom="+self.instgeometry
    ; Corner Geometry
    IF STRLEN(self.cornergeometry) GT 1 THEN $
      cmd[i] += " --corner-geom="+self.cornergeometry
    ; DataPaths
    ; Construct the DataPaths
    self.datapaths = Construct_DataPaths(self.lowerbank, self.upperbank, $
      i+1, self.jobs)
    IF STRLEN(self.datapaths) GT 0 THEN $
      cmd[i] += " --data-paths="+self.datapaths
    ; normalisation file
    IF STRLEN(self.normalisation) GT 1 THEN $
      cmd[i] += " --norm="+self.normalisation
    ; Empty sample container file
    IF STRLEN(self.emptycan) GT 1 THEN $
      cmd[i] += " --ecan="+self.emptycan
    ; black sample container file
    IF STRLEN(self.blackcan) GT 1 THEN $
      cmd[i] += " --bcan="+self.blackcan
    ; Dark Current File
    IF STRLEN(self.dark) GT 1 THEN $
      cmd[i] += " --dkcur="+self.dark
    ; Upstream monitor path
    IF STRLEN(self.usmonpath) GT 1 THEN $
      cmd[i] += " --usmon-path="+self.usmonpath
    ; Downstream monitor path
    IF STRLEN(self.dsmonpath) GT 1 THEN $
      cmd[i] += " --dsmon-path="+self.dsmonpath
    ; ROI filename
    IF STRLEN(self.roifile) GT 1 THEN $
      cmd[i] += " --roi-file="+self.roifile
    ; Tmin
    IF STRLEN(self.tmin) GT 1 THEN $
      cmd[i] += " --tof-cut-min="+self.tmin
    ; Tmax
    IF STRLEN(self.tmax) GT 1 THEN $
      cmd[i] += " --tof-cut-max="+self.tmax
    ; Time Independent Background
    IF STRLEN(self.tibconst) GT 1 THEN $
      cmd[i] += " --tib-const="+self.tibconst
    ; Ei
    IF STRLEN(self.ei) GT 1 THEN $
      cmd[i] += " --initial-energy="+self.ei+","+self.ei_error
    ; T0
    IF STRLEN(self.tzero) GT 1 THEN $
      cmd[i] += " --time-zero-offset="+self.tzero+","+self.tzero_error
    ; Flag for turning off monitor normalization
    IF (self.nomonitornorm EQ 1) THEN cmd[i] += " --no-mon-norm"
    ; proton charge normalization
    IF (self.pcnorm EQ 1) THEN cmd[i] += " --pc-norm"
    ; Monitor integration range
    IF STRLEN(self.monrange) GT 1 THEN $
      cmd[i] += " --mon-int-range="+self.monrange
    ; Detector Efficiency
    IF STRLEN(self.deteff) GT 1 THEN $
      cmd[i] += " --det-eff="+self.deteff
    ; transmission for sample data background
    IF STRLEN(self.datatrans) GT 1 THEN $
      cmd[i] += " --data-trans-coef=" + self.datatrans
    ; transmission for norm data background
    IF STRLEN(self.normtrans) GT 1 THEN $
      cmd[i] += " --norm-trans-coef=" + self.normtrans
    ; Normalisation integration range
    IF STRLEN(self.normrange) GT 1 THEN $
      cmd[i] += " --norm-int-range="+self.normrange
    ; Lambda Bins
    IF STRLEN(self.lambdabins) GT 1 THEN $
      cmd[i] += " --lambda-bins=" + self.lambdabins
      
    IF (self.dumptof EQ 1) THEN cmd[i] += " --dump-ctof-comb"
    IF (self.dumpwave EQ 1) THEN cmd[i] += " --dump-wave-comb"
    IF (self.dumpnorm EQ 1) THEN cmd[i] += " --dump-norm"
    IF (self.dumpet EQ 1) THEN cmd[i] += " --dump-et-comb"
    ; Mask File
    IF STRLEN(self.maskfile) GT 1 THEN $
      cmd[i] += " --nask-file="+self.maskfile
    ; Lambda Ratio
    IF (self.lambdaratio EQ 1) THEN cmd[i] += " --lambda-ratio"
    ; Energy Bins
    IF (STRLEN(self.energybins_min) GE 1) AND (STRLEN(self.energybins_max) GE 1) $
    AND (STRLEN(self.energybins_step) GE 1) THEN $
      cmd[i] += " --energy-bins=" + self.energybins_min + "," + $
          self.energybins_max + "," + self.energybins_step
    ; Momentum Transfer Bins
    IF STRLEN(self.omegabins) GT 1 THEN $
      cmd[i] += " --mom-trans-bins="+self.omegabins
    IF (self.qvector EQ 1) THEN cmd[i] += " --qmesh"
    IF (self.fixed EQ 1) THEN cmd[i] += " --fixed"
    IF (self.split EQ 1) THEN cmd[i] += " --split"
    IF (self.timing EQ 1) THEN cmd[i] += " --timing"
    
  endfor
  
  
  
  return, cmd
end

function ReductionCmd::Init, $
    Program=program, $                   ; Program name
    Version=version, $
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    DataRun=datarun, $                   ; Data filename(s)
    Output=output, $                     ; Output
    Instrument=instrument, $             ; Instrument Name
    Facility=facility, $                 ; Facility Name
    Proposal=proposal, $                 ; Proposal ID
    SPE=spe, $                           ; Create SPE/PHX files
    ConfigFile=configfile, $             ; Config (.rmd) filename
    InstGeometry=instgeometry, $         ; Instrument Geometry filename
    CornerGeometry=cornergeometry, $     ; Corner Geometry filename
    LowerBank=lowerbank, $               ; Lower Detector Bank
    UpperBank=upperbank, $               ; Upper Detector Bank
    DataPaths=datapaths, $               ; detector data paths
    Normalisation=normalisation, $       ; Normalisation file
    EmptyCan=emptycan, $                 ; Empty Can file
    BlackCan=blackcan, $                 ; Black Sample file
    Dark=dark, $                         ; Dark current file
    USmonPath=usmonpath, $               ; Upstream monitor path
    DSmonPath=dsmonpath, $               ; Downstream monitor path
    ROIfile=roifile, $                   ; ROI file
    Tmin=tmin, $                         ; minimum tof
    Tmax=tmax, $                         ; maximum tof
    TIBconst=tibconst, $                 ; Time Independent Bkgrd constant
    Ei=ei, $                             ; Incident Energy (meV)
    Tzero=tzero, $                       ; T0
    Ei_error=ei_error, $                 ; Error in Incident Energy (meV)
    Tzero_error=tzero_error, $           ; Error in T0
    NoMonitorNorm=nomonitornorm, $       ; Turn off monitor normalisation
    PCnorm=pcnorm, $                     ; Proton Charge Normalisation
    MonRange=monrange, $                 ; Monitor integration range (usec)
    DetEff=deteff, $                     ; Detector efficiency
    DataTrans=datatrans, $               ; transmission for sample data bkgrd
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange=normrange, $               ; normalisation integration range (meV)
    LambdaBins=lambdabins, $             ; wavelength bins
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    DumpNorm=dumpnorm, $                 ; Dump combined Norm file
    DumpEt=dumpet, $                     ; Dump combined Et file
    MaskFile=maskfile, $                 ; Mask File
    LambdaRatio=lambdaratio, $           ; Lambda ratio
    EnergyBins_min=energybins_min, $     ; Energy transfer bins (min)
    EnergyBins_max=energybins_max, $     ; Energy transfer bins (max)
    EnergyBins_step=energybins_step, $   ; Energy transfer bins (step)
    OmegaBins=omegabins, $               ; Momentum transfer bins
    Qvector=qvector, $                   ; Create Qvec mesh per energy slice
    Fixed=fixed, $                       ; dump Qvec info onto a fixed mesh
    Split=split, $                       ; split (distributed mode)
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs
    _Extra=extra
    
  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  IF N_ELEMENTS(program) EQ 0 THEN program = "dgs_reduction"
  IF N_ELEMENTS(version) EQ 0 THEN version = ""
  IF N_ELEMENTS(verbose) EQ 0 THEN verbose = 1
  IF N_ELEMENTS(quiet) EQ 0 THEN quiet = 0
  IF N_ELEMENTS(datarun) EQ 0 THEN datarun = ""
  IF N_ELEMENTS(output) EQ 0 THEN output = ""
  IF N_ELEMENTS(instrument) EQ 0 THEN instrument = ""
  IF N_ELEMENTS(facility) EQ 0 THEN facility = ""
  IF N_ELEMENTS(proposal) EQ 0 THEN proposal = ""
  IF N_ELEMENTS(spe) eq 0 THEN spe = 1
  IF N_ELEMENTS(configfile) EQ 0 THEN configfile = ""
  IF N_ELEMENTS(instgeometry) EQ 0 THEN instgeometry = ""
  IF N_ELEMENTS(cornergeometry) EQ 0 THEN cornergeometry = ""
  IF N_ELEMENTS(lowerbank) EQ 0 THEN lowerbank = -1
  IF N_ELEMENTS(upperbank) EQ 0 THEN upperbank = -1
  IF N_ELEMENTS(datapaths) EQ 0 THEN datapaths = ""
  IF N_ELEMENTS(normalisation) EQ 0 THEN normalisation = ""
  IF N_ELEMENTS(emptycan) EQ 0 THEN emptycan = ""
  IF N_ELEMENTS(blackcan) EQ 0 THEN blackcan = ""
  IF N_ELEMENTS(dark) EQ 0 THEN dark = ""
  IF N_ELEMENTS(usmonpath) EQ 0 THEN usmonpath = ""
  IF N_ELEMENTS(dsmonpath) EQ 0 THEN dsmonpath = ""
  IF N_ELEMENTS(roifile) EQ 0 THEN roifile = ""
  IF N_ELEMENTS(tmin) EQ 0 THEN tmin = ""
  IF N_ELEMENTS(tmax) EQ 0 THEN tmax = ""
  IF N_ELEMENTS(tibconst) EQ 0 THEN tibconst = ""
  IF N_ELEMENTS(ei) EQ 0 THEN ei = ""
  IF N_ELEMENTS(ei_error) EQ 0 THEN ei_error = '0.0'
  IF N_ELEMENTS(tzero) EQ 0 THEN tzero = ""
  IF N_ELEMENTS(tzero_error) EQ 0 THEN tzero_error = '0.0'
  IF N_ELEMENTS(nomonitornorm) EQ 0 THEN nomonitornorm = 0
  IF N_ELEMENTS(pcnorm) EQ 0 THEN pcnorm = 0
  IF N_ELEMENTS(monrange) EQ 0 THEN monrange = ""
  IF N_ELEMENTS(deteff) EQ 0 THEN deteff = ""
  IF N_ELEMENTS(datatrans) EQ 0 THEN datatrans = ""
  IF N_ELEMENTS(normtrans) EQ 0 THEN normtrans = ""
  IF N_ELEMENTS(normrange) EQ 0 THEN normrange = ""
  IF N_ELEMENTS(lambdabins) EQ 0 THEN lambdabins = ""
  IF N_ELEMENTS(dumptof) EQ 0 THEN dumptof = 0
  IF N_ELEMENTS(dumpwave) EQ 0 THEN dumpwave = 0
  IF N_ELEMENTS(dumpnorm) EQ 0 THEN dumpnorm = 0
  IF N_ELEMENTS(dumpet) EQ 0 THEN dumpet = 0
  IF N_ELEMENTS(maskfile) EQ 0 THEN maskfile = ""
  IF N_ELEMENTS(lambdaratio) EQ 0 THEN lambdaratio = 0
  IF N_ELEMENTS(energybins_min) EQ 0 THEN energybins_min = ""
  IF N_ELEMENTS(energybins_max) EQ 0 THEN energybins_max = ""
  IF N_ELEMENTS(energybins_step) EQ 0 THEN energybins_step = ""
  IF N_ELEMENTS(omegabins) EQ 0 THEN omegabins = ""
  IF N_ELEMENTS(qvector) EQ 0 THEN qvector = 0
  IF N_ELEMENTS(fixed) EQ 0 THEN fixed = 0
  IF N_ELEMENTS(split) EQ 0 THEN split = 0
  IF N_ELEMENTS(timing) EQ 0 THEN timing = 0
  IF N_ELEMENTS(jobs) EQ 0 THEN jobs = 1
  
  self.program = program
  self.version = version
  self.verbose = verbose
  self.quiet = quiet
  self.datarun = datarun
  self.output = output
  self.instrument = instrument
  self.facility = facility
  self.proposal = proposal
  self.spe = spe
  self.configfile = configfile
  self.instgeometry = instgeometry
  self.cornergeometry = cornergeometry
  self.lowerbank = lowerbank
  self.upperbank = upperbank
  self.datapaths = datapaths
  self.normalisation = normalisation
  self.emptycan = emptycan
  self.blackcan = blackcan
  self.dark = dark
  self.usmonpath = usmonpath
  self.dsmonpath = dsmonpath
  self.roifile = roifile
  self.tmin = tmin
  self.tmax = tmax
  self.tibconst = tibconst
  self.ei = ei
  self.ei_error = ei_error
  self.tzero = tzero
  self.tzero_error = tzero_error
  self.nomonitornorm = nomonitornorm
  self.pcnorm = pcnorm
  self.monrange = monrange
  self.deteff = deteff
  self.datatrans = datatrans
  self.normtrans = normtrans
  self.normrange = normrange
  self.lambdabins = lambdabins
  self.dumptof = dumptof
  self.dumpwave = dumpwave
  self.dumpnorm = dumpnorm
  self.dumpet = dumpet
  self.maskfile = maskfile
  self.lambdaratio = lambdaratio
  self.energybins_min = energybins_min
  self.energybins_max = energybins_max
  self.energybins_step = energybins_step
  self.omegabins = omegabins
  self.qvector = qvector
  self.fixed = fixed
  self.split = split
  self.timing = timing
  self.jobs = jobs
  self.extra = PTR_NEW(extra)
  
  RETURN, 1
end

;+
; :Description:
;    ReductionCmd Define.
;
; :Author: scu
;-
pro ReductionCmd__Define

  struct = { REDUCTIONCMD, $
    program: "", $           ; Program name
    version: "", $           ; Program version
    verbose: 0L, $           ; Verbose flag
    quiet: 0L, $             ; Quiet flag
    datarun: "", $           ; Data filename(s)
    output: "", $            ; Output
    instrument: "", $        ; Instrument (short) name
    facility: "", $          ; Facility name
    proposal: "", $          ; Proposal ID
    spe: 0L, $               : SPE file creation
  configfile: "", $        ; Config (.rmd) filename
    instgeometry: "", $      ; Instrument Geometry filename
    cornergeometry: "", $    ; Corner Geometry filename
    lowerbank: 0L, $         ; Lower Detector Bank
    upperbank: 0L, $         ; Upper Detector Bank
    datapaths: "", $         ; Detector Data Paths
    normalisation: "", $     ; Normalisation file
    emptycan: "", $          ; Empty Can file
    blackcan: "", $          ; Black Sample file
    dark: "", $              ; Dark current file
    usmonpath: "", $         ; Upstream monitor path
    dsmonpath: "", $         ; Downstream monitor path
    roifile: "", $           ; ROI file
    tmin: "", $              ; minimum tof
    tmax: "", $              ; maximum tof
    tibconst: "", $          ; Time Independant Background constant
    ei: "", $                ; Incident Energy (meV)
    ei_error: "", $          ; Error in Incident Energy (meV)
    tzero: "", $             ; T0
    tzero_error: "", $       ; Error in T0
    nomonitornorm: 0L, $     ; Turn off monitor normalisation
    pcnorm: 0L, $            ; Proton Charge Normalisation
    monrange: "", $          ; Monitor integration range (usec)
    deteff: "", $            ; Detector efficiency
    datatrans: "", $         ; transmission for sample data background
    normtrans: "", $         ; transmission for norm data background
    normrange: "", $         ; normalisation (vanadium) integration range (meV)
    lambdabins: "", $        ; wavelength bins
    dumptof: 0L, $           ; Dump combined TOF file
    dumpwave: 0L, $          ; Dump combined wavelength file
    dumpnorm: 0L, $          ; Dump combined Norm file
    dumpet: 0L, $            ; Dump combined Et file
    maskfile: "", $          ; Mask File
    lambdaratio: 0L, $       ; Lambda ratio
    energybins_min: "", $    ; Energy transfer bins (min)
    energybins_max: "", $    ; Energy transfer bins (max)
    energybins_step: "", $   ; Energy transfer bins (step)
    omegabins: "", $         ; Momentum transfer bins
    qvector: 0L, $           ; Create Q vector meshes for each energy slice
    fixed: 0L, $             ; dump Qvector info onto a fixed mesh
    split: 0L, $             ; split (distributed mode)
    timing: 0L, $            ; Timing of code
    jobs : 0L, $             ; Number of Jobs to Run
    extra: PTR_NEW() }       ; Extra keywords
end
