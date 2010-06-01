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

PRO ReductionCmd::Cleanup
  PTR_FREE, self.extra
END

PRO ReductionCmd::GetProperty, $
    Program=program, $                   ; Program name
    Version=version, $
    Queue=queue, $                       ; Queue name
    Verbose=verbose, $                   ; Verbose flag
    Quiet=quiet, $                       ; Quiet flag
    DataRun=datarun, $                   ; Data
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
    DataTrans=datatrans, $               ; transmission for sample data bkgrd
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange_Min=normrange_min, $       ; normalisation integration range (meV) (min)
    NormRange_Max=normrange_max, $       ; normalisation integration range (meV) (max)
    LambdaBins_Min=lambdabins_min, $     ; wavelength bins (min)
    LambdaBins_Max=lambdabins_max, $     ; wavelength bins (max)
    LambdaBins_Step=lambdabins_step, $   ; wavelength bins (step)
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    DumpNorm=dumpnorm, $                 ; Dump combined Norm file
    DumpEt=dumpet, $                     ; Dump combined Et file
    DumpTIB=dumptib, $                   ; Dump the TIB constant for all pixels
    Mask=mask, $                         ; Apply Mask
    HardMask=hardmask, $                 ; Apply Hard Mask
    CustomHardMask=CustomHardMask, $     ; Apply a Custom Hard Mask File
    LambdaRatio=lambdaratio, $           ; Lambda ratio
    EnergyBins_min=energybins_min, $     ; Energy transfer bins (min)
    EnergyBins_max=energybins_max, $     ; Energy transfer bins (max)
    EnergyBins_step=energybins_step, $   ; Energy transfer bins (step)
    QBins_Min=qbins_min, $               ; Momentum transfer bins (min)
    QBins_Max=qbins_max, $               ; Momentum transfer bins (max)
    QBins_Step=qbins_step, $             ; Momentum transfer bins (step)
    Qvector=qvector, $                   ; Create Qvec mesh per energy slice
    Fixed=fixed, $                       ; dump Qvec info onto a fixed mesh
    Split=split, $                       ; split (distributed mode)
    Lo_Threshold=lo_threshold, $         ; Threshold for pixel to be masked (default: 0)
    Hi_Threshold=hi_threshold, $         ; Threshold for pixel to be masked (default: infinity)
    DOS=dos, $                           ; Flag to indicate production of Phonon DOS for S(Q,w)
    DebyeWaller=debyewaller, $           ; Debye-Waller factor
    Error_DebyeWaller=error_debyewaller, $ ; Error in Debye-Waller factor
    SEblock=seblock, $                   ; Sample Environment Block name for the sample rotation
    RotationAngle=rotationangle, $       ; Value of the sample rotation
    CWP=cwp, $                           ; Chopper Wandering Phase on/off
    Bcan_CWP=bcan_cwp, $                 ; chopper phase corrections for black can data. (usecs)
    Ecan_CWP=ecan_cwp, $                 ; chopper phase corrections for empty can data. (usecs)
    Data_CWP=data_cwp, $                 ; chopper phase corrections for sample data. (usecs)
    OutputOverride=OutputOverride, $     ; Prefix for where to write the output
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs to run
    UseHome=usehome, $                   ; Flag to indicate whether we should write to the home directory
    working_mask_dir=working_mask_dir, $ ; Directory that the (split) 'hard' mask files are located.
    MasterMaskFile=mastermaskfile, $     ; An alternative master mask file to use as the source for spliting.
    NormLocation=normlocation, $         ; Setting for location of norm files ('INST','PROP','HOME')
    ProtonCurrentUnits=ProtonCurrentUnits, $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    UserLabel=userlabel, $               ; A Label that is applied to the output directory name.
    Busy=Busy, $                         ; A flag to indicate that we are busy processing something
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
  IF ARG_PRESENT(SPE) NE 0 THEN SPE = self.spe
  IF ARG_PRESENT(ConfigFile) NE 0 THEN ConfigFile = self.configfile
  IF ARG_PRESENT(instgeometry) NE 0 THEN InstGeometry = self.instgeometry
  IF ARG_PRESENT(CornerGeometry) NE 0 THEN CornerGeometry = self.cornergeometry
  IF ARG_PRESENT(LowerBank) NE 0 THEN LowerBank  = self.lowerbank
  IF ARG_PRESENT(UpperBank) NE 0 THEN UpperBank = self.upperbank
  IF ARG_PRESENT(DataPaths) NE 0 THEN DataPaths = self.datapaths
  IF ARG_PRESENT(Normalisation) NE 0 THEN Normalisation = self.normalisation
  IF ARG_PRESENT(EmptyCan) NE 0 THEN EmptyCan = self.emptycan
  IF ARG_PRESENT(BlackCan) NE 0 THEN BlackCan = self.blackcan
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
  IF ARG_PRESENT(DataTrans) NE 0 THEN DataTrans = self.datatrans
  IF ARG_PRESENT(NormTrans) NE 0 THEN NormTrans = self.normtrans
  IF ARG_PRESENT(NormRange_Min) NE 0 THEN NormRange_Min = self.normrange_min
  IF ARG_PRESENT(NormRange_Max) NE 0 THEN NormRange_Max = self.normrange_max
  IF ARG_PRESENT(LambdaBins_Min) NE 0 THEN LambdaBins_Min = self.lambdabins_min
  IF ARG_PRESENT(LambdaBins_Max) NE 0 THEN LambdaBins_Max = self.lambdabins_max
  IF ARG_PRESENT(LambdaBins_Step) NE 0 THEN $
    LambdaBins_Step = self.lambdabins_step
  IF ARG_PRESENT(DumpTOF) NE 0 THEN DumpTOF = self.dumptof
  IF ARG_PRESENT(DumpWave) NE 0 THEN DumpWave = self.dumpwave
  IF ARG_PRESENT(DumpNorm) NE 0 THEN DumpNorm = self.dumpnorm
  IF ARG_PRESENT(DumpEt) NE 0 THEN DumpEt = self.dumpet
  IF ARG_PRESENT(DumpTIB) NE 0 THEN DumpTIB = self.dumptib
  IF ARG_PRESENT(Mask) NE 0 THEN Mask = self.mask
  IF ARG_PRESENT(HardMask) NE 0 THEN HardMask = self.hardmask
  IF ARG_PRESENT(CustomHardMask) NE 0 THEN CustomHardMask = self.CustomHardMask
  IF ARG_PRESENT(LambdaRatio) NE 0 THEN LambdaRatio = self.lambdaratio
  IF ARG_PRESENT(EnergyBins_Min) NE 0 THEN EnergyBins_Min = self.energybins_min
  IF ARG_PRESENT(EnergyBins_Max) NE 0 THEN EnergyBins_Max = self.energybins_max
  IF ARG_PRESENT(EnergyBins_Step) NE 0 THEN $
    EnergyBins_step = self.energybins_step
  IF ARG_PRESENT(QBins_Min) NE 0 THEN QBins_Min = self.qbins_min
  IF ARG_PRESENT(QBins_Max) NE 0 THEN QBins_Max = self.qbins_max
  IF ARG_PRESENT(QBins_Step) NE 0 THEN QBins_Step = self.qbins_step
  IF ARG_PRESENT(Qvector) NE 0 THEN Qvector = self.qvector
  IF ARG_PRESENT(Fixed) NE 0 THEN Fixed = self.fixed
  IF ARG_PRESENT(Split) NE 0 THEN Split = self.split
  IF ARG_PRESENT(Lo_Threshold) NE 0 THEN Lo_Threshold = self.lo_threshold
  IF ARG_PRESENT(Hi_Threshold) NE 0 THEN Hi_Threshold = self.hi_threshold
  IF ARG_PRESENT(DOS) NE 0 THEN DOS = self.DOS
  IF ARG_PRESENT(DebyeWaller) NE 0 THEN DebyeWaller = self.DebyeWaller
  IF ARG_PRESENT(Error_DebyeWaller) NE 0 THEN Error_DebyeWaller = self.Error_DebyeWaller
  IF ARG_PRESENT(SEblock) NE 0 THEN SEblock = self.seblock
  IF ARG_PRESENT(RotationAngle) NE 0 THEN RotationAngle = self.rotationangle
  IF ARG_PRESENT(CWP) NE 0 THEN CWP = self.cwp
  IF ARG_PRESENT(Ecan_CWP) NE 0 THEN Ecan_CWP = self.ecan_cwp
  IF ARG_PRESENT(Bcan_CWP) NE 0 THEN Bcan_CWP = self.bcan_cwp
  IF ARG_PRESENT(Data_CWP) NE 0 THEN Data_CWP = self.data_cwp
  IF ARG_PRESENT(OutputOverride) NE 0 THEN OutputOverride = self.OutputOverride
  IF ARG_PRESENT(Timing) NE 0 THEN Timing = self.timing
  IF ARG_PRESENT(Jobs) NE 0 THEN Jobs = self.jobs
  IF ARG_PRESENT(UseHome) NE 0 THEN UseHome = self.usehome
  IF ARG_PRESENT(working_mask_dir) NE 0 THEN working_mask_dir = self.working_mask_dir
  IF ARG_PRESENT(MasterMaskFile) NE 0 THEN MasterMaskFile = self.mastermaskfile
  IF ARG_PRESENT(NormLocation) NE 0 THEN NormLocation = self.normlocation
  IF ARG_PRESENT(ProtonCurrentUnits) NE 0 THEN ProtonCurrentUnits = self.ProtonCurrentUnits
  IF ARG_PRESENT(UserLabel) NE 0 THEN UserLabel = self.UserLabel
  IF ARG_PRESENT(Busy) NE 0 THEN Busy = self.busy
  
END

PRO ReductionCmd::SetProperty, $
    Program=program, $                   ; Program name
    Version=version, $
    Queue=queue, $                       ; Queue name
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
    DataTrans=datatrans, $               ; transmission for sample data bkgrd
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange_Min=normrange_min, $       ; normalisation integration range (meV) (min)
    NormRange_Max=normrange_max, $       ; normalisation integration range (meV) (max)
    LambdaBins_Min=lambdabins_min, $     ; wavelength bins (min)
    LambdaBins_Max=lambdabins_max, $     ; wavelength bins (max)
    LambdaBins_Step=lambdabins_step, $   ; wavelength bins (step)
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    DumpNorm=dumpnorm, $                 ; Dump combined Norm file
    DumpEt=dumpet, $                     ; Dump combined Et file
    DumpTIB=dumptib, $                   ; Dump the TIB constant for all pixels
    Mask=mask, $                         ; Apply Mask
    HardMask=hardmask, $                 ; Apply Hard Mask
    CustomHardMask=CustomHardMask, $     ; Apply a Custom Hard Mask File
    LambdaRatio=lambdaratio, $           ; Lambda ratio
    EnergyBins_min=energybins_min, $     ; Energy transfer bins (min)
    EnergyBins_max=energybins_max, $     ; Energy transfer bins (max)
    EnergyBins_step=energybins_step, $   ; Energy transfer bins (step)
    QBins_Min=qbins_min, $               ; Momentum transfer bins (min)
    QBins_Max=qbins_max, $               ; Momentum transfer bins (max)
    QBins_Step=qbins_step, $             ; Momentum transfer bins (step)
    Qvector=qvector, $                   ; Create Qvec mesh per energy slice
    Fixed=fixed, $                       ; dump Qvec info onto a fixed mesh
    Split=split, $                       ; split (distributed mode)
    Lo_Threshold=lo_threshold, $         ; Threshold for pixel to be masked (default: 0)
    Hi_Threshold=hi_threshold, $         ; Threshold for pixel to be masked (default: infinity)
    DOS=dos, $                           ; Flag to indicate production of Phonon DOS for S(Q,w)
    DebyeWaller=debyewaller, $           ; Debye-Waller factor
    Error_DebyeWaller=error_debyewaller, $ ; Error in Debye-Waller factor
    SEblock=seblock, $                   ; Sample Environment Block name for the sample rotation
    RotationAngle=rotationangle, $       ; Value of the sample rotation
    CWP=cwp, $                           ; Chopper Wandering Phase on/off
    Bcan_CWP=bcan_cwp, $                 ; chopper phase corrections for black can data. (usecs)
    Ecan_CWP=ecan_cwp, $                 ; chopper phase corrections for empty can data. (usecs)
    Data_CWP=data_cwp, $                 ; chopper phase corrections for sample data. (usecs)
    OutputOverride=OutputOverride, $         ; Prefix for where to write the output
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs to run
    UseHome=usehome, $                   ; Flag to indicate whether we should write to the home directory
    working_mask_dir=working_mask_dir, $                 ; Directory that the (split) 'hard' mask files are located.
    MasterMaskFile=mastermaskfile, $     ; An alternative master mask file to use as the source for spliting.
    NormLocation=normlocation, $         ; Setting for location of norm files ('INST','PROP','HOME')
    ProtonCurrentUnits=ProtonCurrentUnits, $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    UserLabel=userlabel, $               ; A Label that is applied to the output directory name.
    Busy=Busy, $                         ; A flag to indicate that we are busy processing something
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
  IF N_ELEMENTS(datarun) NE 0 THEN BEGIN
    self.datarun = STRCOMPRESS(STRING(datarun), /REMOVE_ALL)
    self.cornergeometry = getCornerGeometryFile(self.instrument, RUNNUMBER=self->GetRunNumber())
  ENDIF
  IF N_ELEMENTS(output) NE 0 THEN self.output = output
  IF N_ELEMENTS(instrument) NE 0 THEN BEGIN
    self.instrument = STRUPCASE(instrument)
    case (STRUPCASE(instrument)) of
      "ARCS": begin
        self.facility = "SNS"
        self.cornergeometry = getCornerGeometryFile(self.instrument)
        self.queue = "arcs"
        self.jobs = 23
        self.split = 1
      end
      "CNCS": begin
        self.facility = "SNS"
        self.cornergeometry = getCornerGeometryFile(self.instrument)
        self.queue = "cncsq"
        self.jobs = 24
        self.split = 1
      end
      "SEQUOIA": begin
        self.instrument = "SEQ"
        self.facility = "SNS"
        self.cornergeometry = getCornerGeometryFile(self.instrument)
        self.queue = "sequoiaq"
        self.jobs = 23
        self.split = 1
      end
      "MAPS": begin
        self.facility = "ISIS"
        self.jobs = 1
      end
      "MARI": begin
        self.facility = "ISIS"
        self.jobs = 1
      end
      "MERLIN": begin
        self.facility = "ISIS"
        self.jobs = 1
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
  IF N_ELEMENTS(cornergeometry) NE 0 THEN self.cornergeometry = cornergeometry
  IF N_ELEMENTS(lowerbank) NE 0 THEN self.lowerbank = lowerbank
  IF N_ELEMENTS(upperbank) NE 0 THEN self.upperbank = upperbank
  IF N_ELEMENTS(datapaths) NE 0 THEN self.datapaths = datapaths
  
  IF N_ELEMENTS(normalisation) NE 0 THEN BEGIN
    ; If -ve then ignore
    IF Normalisation LE 0 THEN Normalisation = ""
    self.normalisation = STRCOMPRESS(STRING(Normalisation), /REMOVE_ALL)
  ENDIF
  
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
  IF N_ELEMENTS(datatrans) NE 0 THEN self.datatrans = DataTrans
  IF N_ELEMENTS(normtrans) NE 0 THEN self.normtrans = NormTrans
  IF N_ELEMENTS(normrange_min) NE 0 THEN self.normrange_min = normrange_min
  IF N_ELEMENTS(normrange_max) NE 0 THEN self.normrange_max = normrange_max
  IF N_ELEMENTS(lambdabins_min) NE 0 THEN self.lambdabins_min = lambdabins_min
  IF N_ELEMENTS(lambdabins_max) NE 0 THEN self.lambdabins_max = lambdabins_max
  IF N_ELEMENTS(lambdabins_step) NE 0 THEN $
    self.lambdabins_step = lambdabins_step
  IF N_ELEMENTS(dumptof) NE 0 THEN self.dumptof = DumpTOF
  IF N_ELEMENTS(dumpwave) NE 0 THEN self.dumpwave = DumpWave
  IF N_ELEMENTS(dumpnorm) NE 0 THEN self.dumpnorm = DumpNorm
  IF N_ELEMENTS(dumpet) NE 0 THEN self.dumpet = DumpEt
  IF N_ELEMENTS(dumptib) NE 0 THEN self.dumptib = DumpTIB
  IF N_ELEMENTS(mask) NE 0 THEN self.mask = Mask
  IF N_ELEMENTS(hardmask) NE 0 THEN self.hardmask = HardMask
  IF N_ELEMENTS(CustomHardMask) NE 0 THEN self.customhardmask = CustomHardMask
  IF N_ELEMENTS(lambdaratio) NE 0 THEN self.lambdaratio = LambdaRatio
  IF N_ELEMENTS(energybins_min) NE 0 THEN self.energybins_min = EnergyBins_Min
  IF N_ELEMENTS(energybins_max) NE 0 THEN self.energybins_max = EnergyBins_Max
  IF N_ELEMENTS(energybins_step) NE 0 THEN $
    self.energybins_step = EnergyBins_step
  IF N_ELEMENTS(qbins_min) NE 0 THEN self.qbins_min = qbins_min
  IF N_ELEMENTS(qbins_max) NE 0 THEN self.qbins_max = qbins_max
  IF N_ELEMENTS(qbins_step) NE 0 THEN self.qbins_step = qbins_step
  IF N_ELEMENTS(qvector) NE 0 THEN self.qvector = Qvector
  IF N_ELEMENTS(fixed) NE 0 THEN self.fixed = Fixed
  IF N_ELEMENTS(split) NE 0 THEN self.split = Split
  IF N_ELEMENTS(lo_threshold) NE 0 THEN self.lo_threshold = Lo_Threshold
  IF N_ELEMENTS(hi_threshold) NE 0 THEN self.hi_threshold = Hi_Threshold
  
  IF N_ELEMENTS(DOS) NE 0 THEN self.DOS = DOS
  IF N_ELEMENTS(DebyeWaller) NE 0 THEN self.DebyeWaller = DebyeWaller
  IF N_ELEMENTS(Error_DebyeWaller) NE 0 THEN self.Error_DebyeWaller = Error_DebyeWaller
  
  IF N_ELEMENTS(SEblock) NE 0 THEN self.seblock = STRCOMPRESS(STRING(SEblock), /REMOVE_ALL)
  IF N_ELEMENTS(RotationAngle) NE 0 THEN self.rotationangle = STRCOMPRESS(STRING(RotationAngle), /REMOVE_ALL)
  
  IF N_ELEMENTS(CWP) NE 0 THEN self.CWP = cwp
  IF N_ELEMENTS(Ecan_CWP) NE 0 THEN $
    self.ecan_cwp = STRCOMPRESS(STRING(Ecan_CWP), /REMOVE_ALL)
  IF N_ELEMENTS(Bcan_CWP) NE 0 THEN $
    self.bcan_cwp = STRCOMPRESS(STRING(Bcan_CWP), /REMOVE_ALL)
  IF N_ELEMENTS(Data_CWP) NE 0 THEN $
    self.data_cwp = STRCOMPRESS(STRING(Data_CWP), /REMOVE_ALL)
    
    
  IF N_ELEMENTS(OutputOverride) NE 0 THEN self.OutputOverride = OutputOverride
  
  IF N_ELEMENTS(timing) NE 0 THEN self.timing = Timing
  
  IF N_ELEMENTS(jobs) NE 0 THEN BEGIN
    self.jobs = jobs
    ; If the number of jobs is > 1 then also set the split flag
    IF (jobs GT 1) THEN self.split = 1
  ENDIF
  
  IF N_ELEMENTS(UseHome) NE 0 THEN self.usehome = UseHome
  
  IF N_ELEMENTS(working_mask_dir) NE 0 THEN self.working_mask_dir = working_mask_dir
  IF N_ELEMENTS(MasterMaskFile) NE 0 THEN self.mastermaskfile = MasterMaskFile
  
  IF N_ELEMENTS(NormLocation) NE 0 THEN BEGIN
    self.NormLocation = STRUPCASE(NormLocation)
  ENDIF
  
  IF N_ELEMENTS(ProtonCurrentUnits) NE 0 THEN self.ProtonCurrentUnits = ProtonCurrentUnits
  
  IF N_ELEMENTS(UserLabel) NE 0 THEN self.UserLabel = UserLabel
  
  IF N_ELEMENTS(Busy) NE 0 THEN self.busy = Busy
  
  IF N_ELEMENTS(extra) NE 0 THEN *self.extra = extra
  
;print, '--SetProperty--'
;print, self.TIBrange_Min, self.TIBrange_Max
  
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
FUNCTION ReductionCmd::GetRunNumber

  RETURN, getFirstNumber(self.datarun)
  
END

;+
; :Description:
;    Returns the first run number from the normalisation property.
;    This is used for naming files/directories/jobs when more than
;    one file is specified.
;
;    e.g. normalisation="1234-1250" would return "1234"
;         normalisation="1234,1235" would return "1234"
;         normalisation="1250,1243-1249" would return "1250"
;
; :Author: scu (campbellsi@ornl.gov)
;-
FUNCTION ReductionCmd::GetNormalisationNumber

  RETURN, getFirstNumber(self.normalisation)
  
END

;+
; :Description:
;    Returns the directory where the results from a reduction
;    job will be written.
;
; :Author: scu (campbellsi@ornl.gov)
;-
FUNCTION ReductionCmd::GetReductionOutputDirectory

  ;print,'ReductionCmd::GetReductionOutputDirectory():'
  directory = get_output_directory(self.instrument, $
    self->GetRunNumber(), $
    HOME=self.usehome, OVERRIDE=self.OutputOverride, $
    LABEL=self.UserLabel)
  ;print,'GetReductionOutputDirectory() --> ',directory
  RETURN, directory
END

;+
; :Description:
;    Returns the directory where the results from a
;    normalisation job will be written.
;
; :Author: scu (campbellsi@ornl.gov)
;-
FUNCTION ReductionCmd::GetNormalisationOutputDirectory

  directory = ''
  
  case (self.NormLocation) of
    'INST': begin
      ; Use the instrument shared directory
      directory = '/SNS/' + self.instrument + '/shared/norm/' + $
        getFirstNumber(self.normalisation)
    end
    'PROP': BEGIN
      directory = get_output_directory(self.instrument, $
        getFirstNumber(self.normalisation), /NO_USERDIR)
    END
    'HOME': BEGIN
      directory = get_output_directory(self.instrument, $
        getFirstNumber(self.normalisation), $
        HOME=1)
    END
    else: begin
    
    end
  endcase
  
  ;print,'Norm Directory = ',directory
  RETURN, directory
END


;+
; :Description:
;    Returns the total number of run numbers that we
;    will need to calculate a wandering phase for.
;
; :Author: scu (campbellsi@ornl.gov)
;-
FUNCTION ReductionCmd::GetNumberOfWanderingRuns
  cwp_runs = 0
  IF (self.CWP) THEN BEGIN
    RunNumbers = ExpandRunNumbers(DataRun)
    FOR i = 0L, N_ELEMENTS(RunNumbers)-1 do begin
      ;print, i
      cwp_runs += N_ELEMENTS(ExpandIndividualRunNumbers(RunNumbers[i]))
      IF (STRLEN(self.emptycan) GT 0) THEN cwp_runs += N_ELEMENTS(ExpandIndividualRunNumbers(self.emptycan))
      IF (STRLEN(self.blackcan) GT 0) THEN cwp_runs += N_ELEMENTS(ExpandIndividualRunNumbers(self.blackcan))
    ENDFOR
  ENDIF
  
  RETURN, cwp_runs
END

;+
; :Description:
;    This procedure tries to estimate the length of time
;    (in clock ticks) that it will take to launch this
;    reduction job(s).  The ticks will be used to update the
;    progress bar.  Various factors have been 'weighted' by
;    hand from experience on how long each part takes.
;
; :Author: scu (campbellsi@ornl.gov)
;-
FUNCTION ReductionCmd::EstimateProgressTicks

  ticks = 0L
  
  ; Let's add a couple of 'ticks' for the initial stuff
  ticks += 2
  
  ; Are we using a hard mask ?
  IF (self.hardmask EQ 1) OR (self.customhardmask EQ 1) THEN BEGIN
    ticks += (2*self.jobs)
  ENDIF
  
  ; Launching the jobs (number + 3 dependant)
  ; (general and SPE collectors & NXSPE converter)
  ticks += (self.jobs + 3)
  
  ; How many individual runs have we to run
  batches = N_ELEMENTS(ExpandRunNumbers(self.datarun))
  
  print,'batches=',batches
  
  ; multiple everything so far by this...
  ticks *= batches
  
  ; Let's see how many Wandering Jobs we have to do
  cwp_runs = self->GetNumberOfWanderingRuns()
  print,'cwp_runs=',cwp_runs
  ; As the wandering calc takes a while, lets weight these higher
  ticks += (4*cwp_runs)
  
  print, 'ticks=',ticks
  
  RETURN, ticks
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
;
; :Author: scu
;-
function ReductionCmd::Check

  ; Let's start out with everything well in the world!
  ok = 1
  datapaths_bad = 0
  msg = ['Everything looks good.']
  
  ; Print a warning if they have selected the wandering phase correction
  IF (self.cwp EQ 1) THEN BEGIN
    ; Don't alter 'ok' as this is just informational
    msg = [msg,['WARNING: You have selected to automatically determine the time ' + $
      'wandering phase corrections - THIS WILL TAKE A LONG TIME TO CALCULATE!']]
  ENDIF
  
  ; Are we doing something else at the moment ?
  IF (self.busy EQ 1) THEN BEGIN
    ok = 0
    msg = [msg,['We are currently processing your job request.']]
  ENDIF
  
  IF (STRLEN(self.instrument) LT 2) THEN BEGIN
    ok = 0
    msg = [msg,['There is no Instrument selected.']]
  ENDIF
  
  IF (STRLEN(self.datarun) LT 1) THEN BEGIN
    ok = 0
    msg = [msg,["There doesn't seem to be a RUN NUMBER defined."]]
  ENDIF
  
  ;Check that the run numbers entered in the "Run Number" box are sensible
  IF (STRLEN(self.datarun) GE 1) THEN BEGIN
    IF (getFirstNumber(self.datarun) EQ '-1') THEN BEGIN
      ok = 0
      msg = [msg, ['Run Number is incorrectly specified or the file does not exist.']]
    ENDIF
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
  
  ; Energy Bins
  IF (STRLEN(self.energybins_min) LT 1) $
    OR (STRLEN(self.energybins_max) LT 1) $
    OR (STRLEN(self.energybins_step) LT 1) THEN BEGIN
    ok = 0
    msg = [msg,["The Energy Transfer Range isn't defined correctly."]]
  ENDIF
  
  ; Q Bins
  IF (STRLEN(self.qbins_min) LT 1) $
    OR (STRLEN(self.qbins_max) LT 1) $
    OR (STRLEN(self.qbins_step) LT 1) THEN BEGIN
    ok = 0
    msg = [msg,["The Q-Range isn't defined correctly."]]
  ENDIF
  
  ; Check that the max Energy Transfer is less than Ei
  ;  IF (self.energybins_max GE self.ei) THEN BEGIN
  ;    ok = 0
  ;    print, 'Ei = ', self.ei
  ;    print, 'Emax = ', self.energybins_max
  ;    msg = [msg,['You cannot have Emax ('+ $
  ;      STRCOMPRESS(STRING(self.energybins_max),/REMOVE_ALL)+ $
  ;      'meV) >= Ei ('+STRCOMPRESS(STRING(self.ei),/REMOVE_ALL)+'meV).']]
  ;  ENDIF
  
  ; Now let's do some more complicated dependencies
  
  ; If Empty Can OR Black Can then we must specify Data Coeff
  IF (STRLEN(self.emptycan) GE 1) OR (STRLEN(self.blackcan) GE 1) THEN BEGIN
    IF (STRLEN(self.datatrans) LT 1) THEN BEGIN
      ok = 0
      msg = [msg,["ERROR: You need to specify and value for 'Data Coeff' " + $
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
  
  
  ; If Normalisation defined and empty or black then need to define norm-coeff
  ;  IF (STRLEN(self.normalisation) GE 1) THEN BEGIN
  ;    IF (STRLEN(self.emptycan) GE 1) OR (STRLEN(self.blackcan) GE 1) THEN BEGIN
  ;      IF (STRLEN(self.normtrans) LT 1) THEN BEGIN
  ;        ok = 0
  ;        msg = [msg,["ERROR: You need to specify and value for 'Norm Coeff' " + $
  ;          "if you have specified a Normalisation Run and either an Empty Can or a Black Can."]]
  ;      ENDIF
  ;    ENDIF
  ;  ENDIF
  
  ; Check for non-expected special characters in the Data Run field
  BadSymbols = ['!','@','#','$','%','^','&','*','(',')','<','>','?','[',']','{','}']
  for index = 0L, N_ELEMENTS(BadSymbols)-1 do begin
    IF (STRPOS(self.datarun, BadSymbols[index]) NE -1) THEN BEGIN
      ok = 0
      msg = [msg,[BadSymbols[index]+' is not an allowed delimiter in the data run specification.']]
    ENDIF
  endfor
  
  
  
  ; Need to specify a min/max for the monitor integration if we are normalising to the monitor
  IF (self.nomonitornorm EQ 0) THEN BEGIN
    IF (STRLEN(self.monrange_min) LT 1) OR (STRLEN(self.monrange_max) LT 1) THEN BEGIN
      ok = 0
      msg = [msg,['If you are normalising to the monitor, you need to specify a monitor integration range.']]
    ENDIF
  ENDIF
  
  ; And the other way round, if you specify a norm run then you need to turn the mask on!
  ;  IF (STRLEN(self.normalisation) GE 1) THEN BEGIN
  ;    IF (self.mask NE 1) THEN BEGIN
  ;      ok = 0
  ;      msg = [msg,['If you specify a Normalisation Run then you need to turn on the Vanadium Mask.']]
  ;    ENDIF
  ;  ENDIF
  
  ; Phonon Density of States
  IF (self.DOS EQ 1) THEN BEGIN
    ; If we want the DOS produced then we need to have a Debye Waller Factor specified.
    IF (STRLEN(self.DebyeWaller) LT 1) THEN BEGIN
      ok = 0
      msg = [msg,['The creation of a Phonon DOS representation requires a Debye-Waller factor.']]
    ENDIF
  ENDIF
  
  ; Check to see if the Corner Geometry file Exists....
  IF (FILE_TEST(self.cornergeometry, /READ) EQ 0) THEN BEGIN
    ok = 0
    msg = [msg,['The corner geometry file ('+self.cornergeometry+') does not seem to be readable.']]
  ENDIF
  
  ; You cannot specify a 'batch' of runs and also specify a custom output directory
  IF (STRLEN(self.OutputOverride) GE 1) AND (STRPOS(self.datarun, ':') NE -1) THEN BEGIN
    ok = 0
    msg = [msg,['Sorry - you cannot specify a series of batch runs and a custom output directory']]
  ENDIF
  
  ; Check to see that the *.norm and mask files for vanadium are split up into
  ; the correct number of jobs.
  IF (STRLEN(self.normalisation) GE 1) AND (self.normalisation NE 0) $
    AND (STRLEN(self.instrument) GT 1) THEN BEGIN
    
    print,'Checking mask and norm files...'
    ; Let's get the norm output directory so we don't have to keep asking for it!
    normDir = self->GetNormalisationOutputDirectory()
    
    norm_error = 0
    mask_error = 0
    
    FOR i = 0L, self.jobs-1 DO BEGIN
    
      IF (norm_error EQ 0) THEN BEGIN
        norm_filename =  normDir + "/" + $
          self.instrument + "_bank" + Construct_DataPaths(self.lowerbank, self.upperbank, $
          i+1, self.jobs, /PAD) + ".norm"
          
        norm_exists = FILE_TEST(norm_filename, /READ)
        IF (norm_exists EQ 0) THEN BEGIN
          norm_error = 1
          ok = 0
          msg = [msg,['The *.norm files do not seem to match the current data configuration.']]
        ENDIF
      ENDIF
      
      IF (mask_error EQ 0) THEN BEGIN
        mask_filename = normDir + "/" + $
          self.instrument + "_bank" + Construct_DataPaths(self.lowerbank, self.upperbank, $
          i+1, self.jobs, /PAD) + "_mask.dat"
          
        mask_exists = FILE_TEST(mask_filename, /READ)
        IF (mask_exists EQ 0) THEN BEGIN
          mask_exists = 1
          ok = 0
          msg = [msg,['The vanadium mask files do not seem to match the current data configuration.']]
        ENDIF
        
      ENDIF
    ENDFOR
  ENDIF
  
  ; Remove the first blank String
  IF (N_ELEMENTS(msg) GT 1) THEN msg = msg(1:*)
  
  data = { ok : ok, $
    message : msg}
    
  return, data
end


;+
; :Description:
;    Generates the command strings to execute for reduction jobs.
;
;-
function ReductionCmd::Generate

  ; Error Handling
  catch, theError
  IF theError NE 0 THEN BEGIN
    catch, /cancel
    ok = ERROR_MESSAGE(!ERROR_STATE.MSG + ' Returning...', TRACEBACK=1, /error)
    return, 0
  ENDIF
  
  cmd = STRARR(self.jobs)
  
  ; Let's get the output directory so we don't have to keep asking for it!
  outputDir = self->GetReductionOutputDirectory()
  normDir = self->GetNormalisationOutputDirectory()
  
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
    IF STRLEN(self.datapaths) GE 1 THEN $
      cmd[i] += " --data-paths="+self.datapaths
      
      
    ; normalisation file
    IF (STRLEN(self.normalisation) GE 1) AND (self.normalisation NE 0) $
      AND (STRLEN(self.instrument) GT 1) THEN BEGIN
      
      cmd[i] += " --norm=" + normDir + "/" + $
        self.instrument + "_bank" + Construct_DataPaths(self.lowerbank, self.upperbank, $
        i+1, self.jobs, /PAD) + ".norm"
        
        
    ;cmd[i] += " --norm="+self.normalisation
    ENDIF
    
    
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
    ENDIF
    
    ; Ei
    IF STRLEN(self.ei) GE 1 THEN $
      cmd[i] += " --initial-energy="+strcompress(self.ei,/remove_all)+","+self.error_ei
    ; T0
    IF STRLEN(self.tzero) GE 1 THEN $
      cmd[i] += " --time-zero-offset="+strcompress(self.tzero,/remove_all)+","+self.error_tzero
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
    ; transmission for sample data background
    IF STRLEN(self.datatrans) GE 1 THEN $
      cmd[i] += " --data-trans-coeff=" + self.datatrans + ",0.0"
      
    ; These are no longer needed in dgs_reduction
      
    ; transmission for norm data background
    ;IF STRLEN(self.normtrans) GE 1 THEN $
    ;  cmd[i] += " --norm-trans-coeff=" + self.normtrans + ",0.0"
    ; Normalisation integration range
    ;    IF (STRLEN(self.normrange_min) GE 1 ) $
    ;      AND (STRLEN(self.normrange_max) GE 1) THEN $
    ;      cmd[i] += " --norm-int-range " + self.normrange_min + " " $
    ;                + self.normrange_max
      
    ; Lambda Bins
    IF (STRLEN(self.lambdabins_min) GE 1) $
      AND (STRLEN(self.lambdabins_max) GE 1) $
      AND (STRLEN(self.lambdabins_step) GE 1) $
      AND (self.dumpwave EQ 1) THEN $
      cmd[i] += " --lambda-bins=" + self.lambdabins_min + "," + $
      self.lambdabins_max + "," + self.lambdabins_step
      
    IF (self.dumptof EQ 1) THEN cmd[i] += " --dump-ctof-comb"
    IF (self.dumpwave EQ 1) THEN cmd[i] += " --dump-wave-comb"
    ;IF (self.dumpnorm EQ 1) THEN cmd[i] += " --dump-norm"
    IF (self.dumpet EQ 1) THEN cmd[i] += " --dump-et-comb"
    
    IF (self.dumptib EQ 1) THEN cmd[i] += " --dump-tib"
    
    ; Mask File(s)
    IF (((self.mask EQ 1) AND (STRLEN(self.normalisation) GE 1) AND (STRLEN(self.instrument) GT 1)) $
      OR ((self.hardmask EQ 1) AND (STRLEN(self.instrument) GT 1)) $
      OR ((self.customhardmask EQ 1) AND (STRLEN(self.instrument) GT 1))) THEN BEGIN
      cmd[i] += " --mask-file="
      
      
      ; Vanadium Mask file...
      IF (self.mask EQ 1) AND (STRLEN(self.normalisation) GE 1) $
        AND (STRLEN(self.instrument) GT 1) THEN BEGIN
        cmd[i] += normDir + "/" + $
          self.instrument + "_bank" + Construct_DataPaths(self.lowerbank, self.upperbank, $
          i+1, self.jobs, /PAD) + "_mask.dat"
          
        ; Put a ',' in if the hardmask is defined as well.
        IF (self.mask EQ 1) AND (self.hardmask EQ 1) THEN cmd[i] += ","
        IF (self.mask EQ 1) AND (self.customhardmask EQ 1) THEN cmd[i] += ","
        
      ENDIF
      
      
      ; 'Hard' Mask file...
      IF ((self.customhardmask EQ 1) OR (self.hardmask EQ 1)) AND (STRLEN(self.instrument) GT 1) THEN BEGIN
        ;
        mask_dir = outputDir + "/masks"
        
        tmp_maskfile = mask_dir + "/" + $
          self.instrument + "_bank" + Construct_DataPaths(self.lowerbank, self.upperbank, $
          i+1, self.jobs, /PAD) + "_mask.dat"
          
        cmd[i] += tmp_maskfile
        
      ENDIF
      
    ENDIF
    
    
    ; Lambda Ratio
    IF (self.lambdaratio EQ 1) THEN cmd[i] += " --lambda-ratio"
    
    ; Energy Bins
    IF (STRLEN(self.energybins_min) GE 1) $
      AND (STRLEN(self.energybins_max) GE 1) $
      AND (STRLEN(self.energybins_step) GE 1) THEN $
      cmd[i] += " --energy-bins=" + self.energybins_min + "," + $
      self.energybins_max + "," + self.energybins_step
      
    ; Momentum Transfer Bins
    IF (STRLEN(self.qbins_min) GE 1) $
      AND (STRLEN(self.qbins_max) GE 1) $
      AND (STRLEN(self.qbins_step) GE 1) THEN $
      cmd[i] += " --mom-trans-bins=" + self.qbins_min + "," + $
      self.qbins_max + "," + self.qbins_step
      
    ; Phonon Density of States
    IF (self.DOS EQ 1) THEN BEGIN
      IF (STRLEN(self.DebyeWaller) GE 1) THEN $
        cmd[i] += " --pdos-Q --debye-waller=" + self.DebyeWaller + "," + $
        (self.Error_DebyeWaller ? self.Error_DebyeWaller : '0.0')
    ENDIF
    
    ; Auto Wandering Phase
    IF (self.CWP EQ 1) THEN BEGIN
    ; Don't need to do owt at the moment.
    ENDIF
    
    ; For now let people specify these offsets without turning on the CWP!
    IF (STRLEN(self.bcan_cwp) GE 1)  THEN $
      cmd[i] += " --cwp-bcan=" + self.bcan_cwp
    IF (STRLEN(self.ecan_cwp) GE 1)  THEN $
      cmd[i] += " --cwp-ecan=" + self.ecan_cwp
    IF (STRLEN(self.data_cwp) GE 1)  THEN $
      cmd[i] += " --cwp-data=" + self.data_cwp
      
    IF (STRLEN(self.ProtonCurrentUnits) GE 1) THEN $
      cmd[i] += " --scale-pc=" + self.ProtonCurrentUnits
      
    IF (self.qvector EQ 1) THEN cmd[i] += " --qmesh"
    IF (self.fixed EQ 1) AND (self.qvector EQ 1) THEN cmd[i] += " --fixed"
    IF (self.split EQ 1) THEN cmd[i] += " --split"
    IF (self.timing EQ 1) THEN cmd[i] += " --timing"
    
  endfor
  
  return, cmd
end

function ReductionCmd::Init, $
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
    DataTrans=datatrans, $               ; transmission for sample data bkgrd
    NormTrans=normtrans, $               ; transmission for norm data bkgrd
    NormRange_Min=normrange_min, $       ; normalisation integration range (meV) (min)
    NormRange_Max=normrange_max, $       ; normalisation integration range (meV) (max)
    LambdaBins_Min=lambdabins_min, $     ; wavelength bins (min)
    LambdaBins_Max=lambdabins_max, $     ; wavelength bins (max)
    LambdaBins_Step=lambdabins_step, $   ; wavelength bins (step)
    DumpTOF=dumptof, $                   ; Dump combined TOF file
    DumpWave=dumpwave, $                 ; Dump combined wavelength file
    DumpNorm=dumpnorm, $                 ; Dump combined Norm file
    DumpEt=dumpet, $                     ; Dump combined Et file
    DumpTIB=dumptib, $                   ; Dump the TIB constant for all pixels
    Mask=mask, $                         ; Apply Mask
    HardMask=hardmask, $                 ; Apply Hard Mask
    CustomHardMask=CustomHardMask, $     ; Apply a Custom Hard Mask File
    LambdaRatio=lambdaratio, $           ; Lambda ratio
    EnergyBins_min=energybins_min, $     ; Energy transfer bins (min)
    EnergyBins_max=energybins_max, $     ; Energy transfer bins (max)
    EnergyBins_step=energybins_step, $   ; Energy transfer bins (step)
    QBins_Min=qbins_min, $               ; Momentum transfer bins (min)
    QBins_Max=qbins_max, $               ; Momentum transfer bins (max)
    QBins_Step=qbins_step, $             ; Momentum transfer bins (step)
    Qvector=qvector, $                   ; Create Qvec mesh per energy slice
    Fixed=fixed, $                       ; dump Qvec info onto a fixed mesh
    Split=split, $                       ; split (distributed mode)
    Lo_Threshold=lo_threshold, $         ; Threshold for pixel to be masked (default: 0)
    Hi_Threshold=hi_threshold, $         ; Threshold for pixel to be masked (default: infinity)
    DOS=dos, $                           ; Flag to indicate production of Phonon DOS for S(Q,w)
    DebyeWaller=debyewaller, $           ; Debye-Waller factor
    Error_DebyeWaller=error_debyewaller, $ ; Error in Debye-Waller factor
    SEblock=seblock, $                   ; Sample Environment Block name for the sample rotation
    RotationAngle=rotationangle, $       ; Value of the sample rotation
    CWP=cwp, $                           ; Chopper Wandering Phase on/off
    Bcan_CWP=bcan_cwp, $                 ; chopper phase corrections for black can data. (usecs)
    Ecan_CWP=ecan_cwp, $                 ; chopper phase corrections for empty can data. (usecs)
    Data_CWP=data_cwp, $                 ; chopper phase corrections for sample data. (usecs)
    OutputOverride=OutputOverride, $     ; Prefix for where to write the output
    Timing=timing, $                     ; Timing of code
    Jobs=jobs, $                         ; Number of Jobs
    UseHome=usehome, $                   ; Flag to indicate whether we should write to the home directory
    working_mask_dir=working_mask_dir, $ ; Directory that the (split) 'hard' mask files are located.
    MasterMaskFile=mastermaskfile, $     ; An alternative master mask file to use as the source for spliting.
    NormLocation=normlocation, $         ; Setting for location of norm files ('INST','PROP','HOME')
    ProtonCurrentUnits=ProtonCurrentUnits, $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    UserLabel=userlabel, $               ; A Label that is applied to the output directory name.
    Busy=Busy, $                         ; A flag to indicate that we are busy processing something
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
  IF N_ELEMENTS(queue) EQ 0 THEN queue = ""
  IF N_ELEMENTS(verbose) EQ 0 THEN verbose = 1
  IF N_ELEMENTS(quiet) EQ 0 THEN quiet = 0
  IF N_ELEMENTS(datarun) EQ 0 THEN datarun = ""
  IF N_ELEMENTS(output) EQ 0 THEN output = ""
  IF N_ELEMENTS(instrument) EQ 0 THEN instrument = ""
  IF N_ELEMENTS(facility) EQ 0 THEN facility = ""
  IF N_ELEMENTS(proposal) EQ 0 THEN proposal = ""
  IF N_ELEMENTS(spe) EQ 0 THEN spe = 1
  IF N_ELEMENTS(configfile) EQ 0 THEN configfile = ""
  IF N_ELEMENTS(instgeometry) EQ 0 THEN instgeometry = ""
  IF N_ELEMENTS(cornergeometry) EQ 0 THEN cornergeometry = ""
  IF N_ELEMENTS(lowerbank) EQ 0 THEN lowerbank = 0
  IF N_ELEMENTS(upperbank) EQ 0 THEN upperbank = 0
  IF N_ELEMENTS(datapaths) EQ 0 THEN datapaths = ""
  IF N_ELEMENTS(normalisation) EQ 0 THEN normalisation = ""
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
  IF N_ELEMENTS(datatrans) EQ 0 THEN datatrans = ""
  IF N_ELEMENTS(normtrans) EQ 0 THEN normtrans = ""
  IF N_ELEMENTS(normrange_min) EQ 0 THEN normrange_min = ""
  IF N_ELEMENTS(normrange_max) EQ 0 THEN normrange_max = ""
  IF N_ELEMENTS(lambdabins_min) EQ 0 THEN lambdabins_min = ""
  IF N_ELEMENTS(lambdabins_max) EQ 0 THEN lambdabins_max = ""
  IF N_ELEMENTS(lambdabins_step) EQ 0 THEN lambdabins_step = ""
  IF N_ELEMENTS(dumptof) EQ 0 THEN dumptof = 0
  IF N_ELEMENTS(dumpwave) EQ 0 THEN dumpwave = 0
  IF N_ELEMENTS(dumpnorm) EQ 0 THEN dumpnorm = 0
  IF N_ELEMENTS(dumpet) EQ 0 THEN dumpet = 0
  IF N_ELEMENTS(DumpTIB) EQ 0 THEN dumptib = 0
  IF N_ELEMENTS(mask) EQ 0 THEN mask = 1
  IF N_ELEMENTS(hardmask) EQ 0 THEN hardmask = 0
  IF N_ELEMENTS(customhardmask) EQ 0 THEN customhardmask = 0
  IF N_ELEMENTS(lambdaratio) EQ 0 THEN lambdaratio = 0
  IF N_ELEMENTS(energybins_min) EQ 0 THEN energybins_min = ""
  IF N_ELEMENTS(energybins_max) EQ 0 THEN energybins_max = ""
  IF N_ELEMENTS(energybins_step) EQ 0 THEN energybins_step = ""
  IF N_ELEMENTS(qbins_min) EQ 0 THEN qbins_min = ""
  IF N_ELEMENTS(qbins_max) EQ 0 THEN qbins_max = ""
  IF N_ELEMENTS(qbins_step) EQ 0 THEN qbins_step = ""
  IF N_ELEMENTS(qvector) EQ 0 THEN qvector = 0
  IF N_ELEMENTS(fixed) EQ 0 THEN fixed = 0
  IF N_ELEMENTS(split) EQ 0 THEN split = 0
  IF N_ELEMENTS(lo_threshold) EQ 0 THEN lo_threshold = ""
  IF N_ELEMENTS(hi_threshold) EQ 0 THEN hi_threshold = ""
  IF N_ELEMENTS(DOS) EQ 0 THEN dos = 0
  IF N_ELEMENTS(DebyeWaller) EQ 0 THEN debyewaller = '0.0'
  IF N_ELEMENTS(Error_DebyeWaller) EQ 0 THEN error_debyewaller = '0.0'
  IF N_ELEMENTS(SEblock) EQ 0 THEN seblock = ""
  IF N_ELEMENTS(RotationAngle) EQ 0 THEN rotationangle = ""
  IF N_ELEMENTS(CWP) EQ 0 THEN cwp = 0
  IF N_ELEMENTS(Bcan_CWP) EQ 0 THEN bcan_cwp = ""
  IF N_ELEMENTS(Ecan_CWP) EQ 0 THEN ecan_cwp = ""
  IF N_ELEMENTS(Data_CWP) EQ 0 THEN data_cwp = ""
  IF N_ELEMENTS(OutputOverride) EQ 0 THEN OutputOverride = ""
  IF N_ELEMENTS(timing) EQ 0 THEN timing = 0
  IF N_ELEMENTS(jobs) EQ 0 THEN jobs = 1
  IF N_ELEMENTS(UseHome) EQ 0 THEN UseHome = 0
  IF N_ELEMENTS(working_mask_dir) EQ 0 THEN working_mask_dir = ""
  IF N_ELEMENTS(MasterMaskFile) EQ 0 THEN MasterMaskFile = ""
  IF N_ELEMENTS(NormLocation) EQ 0 THEN NormLocation = ""
  IF N_ELEMENTS(ProtonCurrentUnits) EQ 0 THEN ProtonCurrentUnits = ""
  IF N_ELEMENTS(UserLabel) EQ 0 THEN UserLabel = ""
  IF N_ELEMENTS(Busy) EQ 0 THEN Busy = 0
  
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
  self.datatrans = datatrans
  self.normtrans = normtrans
  self.normrange_min = normrange_min
  self.normrange_max = normrange_max
  self.lambdabins_min = lambdabins_min
  self.lambdabins_max = lambdabins_max
  self.lambdabins_step = lambdabins_step
  self.dumptof = dumptof
  self.dumpwave = dumpwave
  self.dumpnorm = dumpnorm
  self.dumpet = dumpet
  self.dumptib = dumptib
  self.mask = mask
  self.hardmask = hardmask
  self.customhardmask = customhardmask
  self.lambdaratio = lambdaratio
  self.energybins_min = energybins_min
  self.energybins_max = energybins_max
  self.energybins_step = energybins_step
  self.qbins_min = qbins_min
  self.qbins_max = qbins_max
  self.qbins_step = qbins_step
  self.qvector = qvector
  self.fixed = fixed
  self.split = split
  self.lo_threshold = Lo_Threshold
  self.hi_threshold = Hi_Threshold
  self.dos = dos
  self.debyewaller = debyewaller
  self.error_debyewaller = error_debyewaller
  self.seblock = seblock
  self.rotationangle = rotationangle
  self.cwp = cwp
  self.ecan_cwp = ecan_cwp
  self.bcan_cwp = bcan_cwp
  self.data_cwp = data_cwp
  self.OutputOverride = OutputOverride
  self.timing = timing
  self.jobs = jobs
  self.usehome = usehome
  self.working_mask_dir = working_mask_dir
  self.mastermaskfile = mastermaskfile
  self.normlocation = normlocation
  self.ProtonCurrentUnits = protoncurrentunits
  self.UserLabel = userlabel
  self.busy = Busy
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
    queue: "", $             ; Queue to use
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
    datatrans: "", $         ; transmission for sample data background
    normtrans: "", $         ; transmission for norm data background
    normrange_min: "", $     ; normalisation (vanadium) integration range (meV)
    normrange_max: "", $     ; normalisation (vanadium) integration range (meV)
    lambdabins_min: "", $    ; wavelength bins (min)
    lambdabins_max: "", $    ; wavelength bins (max)
    lambdabins_step: "", $   ; wavelength bins (step)
    dumptof: 0L, $           ; Dump combined TOF file
    dumpwave: 0L, $          ; Dump combined wavelength file
    dumpnorm: 0L, $          ; Dump combined Norm file
    dumpet: 0L, $            ; Dump combined Et file
    dumptib: 0L, $           ; Dump the TIB constant for all pixels
    mask: 0L, $              ; Apply Mask File
    hardmask: 0L, $          ; Apply Hard Mask File
    customhardmask: 0L, $    ; Apply a Custom Hard Mask File
    lambdaratio: 0L, $       ; Lambda ratio
    energybins_min: "", $    ; Energy transfer bins (min)
    energybins_max: "", $    ; Energy transfer bins (max)
    energybins_step: "", $   ; Energy transfer bins (step)
    qbins_min: "", $         ; Momentum transfer bins (min)
    qbins_max: "", $         ; Momentum transfer bins (max)
    qbins_step: "", $        ; Momentum transfer bins (step)
    qvector: 0L, $           ; Create Q vector meshes for each energy slice
    fixed: 0L, $             ; dump Qvector info onto a fixed mesh
    split: 0L, $             ; split (distributed mode)
    hi_threshold: "", $      ; Threshold for pixel to be masked (default: infinity)
    lo_threshold: "", $      ; Threshold for pixel to be masked (default: 0.0)
    DOS: 0L, $               ; Flag to indicate production of Phonon DOS for S(Q,w)
    DebyeWaller: "", $       ; Debye-Waller factor
    Error_DebyeWaller: "", $ ; Error in Debye-Waller factor
    seblock: "", $           ; Sample Environment Block name for the sample rotation
    RotationAngle:"", $      ; Value of the sample rotation offset
    OutputOverride: "", $      ; Prefix for where to write the output (normally ~/results/)
    CWP: 0L, $               ; Chopper Wandering Phase on/off
    bcan_cwp: "", $          ; chopper phase corrections for black can data. (usecs)
    ecan_cwp: "", $          ; chopper phase corrections for empty can data. (usecs)
    data_cwp: "", $          ; chopper phase corrections for sample data. (usecs)
    timing: 0L, $            ; Timing of code
    jobs : 0L, $             ; Number of Jobs to Run
    usehome : 0L, $          ; Flag to indicate whether we should write to the home directory
    working_mask_dir: "", $  ; Directory that the (split) 'hard' mask files are located.
    mastermaskfile: "", $    ; An alternative master mask file to use as the source for spliting.
    NormLocation: "", $      ; Setting for location of norm files ('INST','PROP','HOME')
    ProtonCurrentUnits: "", $ ; The units for the proton current, either 'C','mC','uC' or 'pC'
    UserLabel:"", $          ; A Label that is applied to the output directory name.
    Busy: 0L, $              ; A flag to indicate that we are busy processing something
    extra: PTR_NEW() }       ; Extra keywords
end
