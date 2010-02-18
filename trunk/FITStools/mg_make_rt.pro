; docformat = 'rst'

;+
; Wrapper for MAKE_RT. MG_MAKE_RT will automatically use all the platforms
; which are available in the $IDL_DIR/bin directory. The params/keywords are 
; the same as for MAKE_RT, except all the platform specifying ones are omitted
; since they are no longer needed.
;
; :Params:
;    appname : in, required, type=string
;       name of the application
;    outdir : in, required, type=string
;       directory to place output in; this directory must exist and must use 
;       the OVERWRITE keyword if this directory is not empty
;
; :Keywords:
;    idldir
;    logfile
;    manifest
;    overwrite
;    savefile
;    vm
;    embedded
;    dataminer
;    dicomex
;    hires_maps
;    idl_assistant
;
; :Requires:
;    IDL 7.1
;-
pro mg_make_rt, appname, outdir, $
                idldir=idldir, logfile=logfile, manifest=manifest, $
                overwrite=overwrite, savefile=savefile, $
                vm=vm, embedded=embedded, dataminer=dataminer, $
                dicomex=dicomex, hires_maps=hires_maps, $
                idl_assistant=idl_assistant
  compile_opt strictarr
  
  binFiles = filepath('bin.*', subdir=['bin'])
  binDirs = file_basename(file_search(binFiles, /test_directory))
  archAvailable = strmid(binDirs, 4)
  
  for a = 0, n_elements(archAvailable) - 1L do begin
    case archAvailable[a] of
      'x86': win32 = 1
      'x86_64': win64 = 1
      'darwin.ppc': macppc32 = 1
      'darwin.i386': macint32 = 1
      'darwin.x86_64': macint64 = 1
      'linux.x86': lin32 = 1
      'linux.x86_64': lin64 = 1
      'solaris2.sparc': sun32 = 1
      'solaris2.sparc64': sun64 = 1
      'solaris2.x86_64': sunx86_64 = 1     
      else: message, 'unknown architecture ' + archAvailable[a], /informational
    endcase    
  endfor
  
  make_rt, appname, outdir, $
           idldir=idldir, logfile=logfile, manifest=manifest, $
           overwrite=overwrite, savefile=savefile, $
           vm=vm, embedded=embedded, dataminer=dataminer, $
           dicomex=dicomex, hires_maps=hires_maps, $
           idl_assistant=idl_assistant, $
           win32=win32, win64=win64, $
           macppc32=macppc32, macint32=macint32, macint64=macint64, $
           lin32=lin32, lin64=lin64, $
           sunx86_64=sunx86_64, sun32=sun32, sun64=sun64
end
