; \
; \defgroup find_full_nexus_name
; \{
;;

;;
; \brief This function looks for a nexus file
; using 'findnexus'
;
; \param run_number (INPUT) run number
; \param instrument (INPUT) instrument name
; \param path (INPUT/OPTIONAL) path to search for 
;
; \return full_nexus_name
; full nexus file name (with full path) if found
; empty string if not found
FUNCTION find_full_nexus_name, run_number, instrument, path

cmd = "findnexus -i" + instrument 
;if (local EQ 1) then begin
if (n_elements(path) NE 0) then begin
    cmd += " --prefix " + path
endif

cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name, err_listening

;check if nexus exists
result = strmatch(full_nexus_name,"ERROR*")

if (result GE 1) then begin
    full_nexus_name = ''
endif

return, full_nexus_name

end
; \}
;;     //end of find_full_nexus_name








function dumpBinaryData, full_nexus_name, instrument, ucams

;create tmp_working_path
;get global structure
tmp_working_path = "/SNS/users/" + ucams + '/local/'

cmd_dump = "nxdir " + full_nexus_name
cmd_dump += " -p /entry/bank1/data/ --dump "

;get tmp_output_file_name
tmp_output_file_name = tmp_working_path + instrument + '_tmp_histo_data.dat'
cmd_dump += tmp_output_file_name
;print, 'cmd_dump: ' + cmd_dump
spawn, cmd_dump, listenining

return, tmp_output_file_name
end






function PLOT_DATA, run_number, instrument, ucams

;determine full path to nexus file
full_nexus_path = find_full_nexus_name(run_number, instrument)

foundNeXus = 0

if (full_nexus_path NE '') then begin

 ;dump histo data into temporary file
     tmp_output_file_name = dumpBinaryData(full_nexus_path, instrument, ucams)

     if (instrument EQ 'REF_L') then begin
         Nx = 304L
         Ny = 256L
     endif else begin
         Nx = 256L
         Ny = 304L
     endelse

     file = '/SNS/users/' + ucams + '/local/' + instrument + '_tmp_histo_data.dat'
    
     ;only read data if valid file given
     openr,u,file,/get
                                 ;find out file info
     fs = fstat(u)
     
     Nimg = Nx*Ny
     Ntof = fs.size/(Nimg*4L)

     data_assoc = assoc(u,lonarr(Ntof))
    
     ;make the image array
     img = lonarr(Nx,Ny)
     
     for i=0L,Nimg-1 do begin
         x = i MOD Nx
         y = i/Nx
         img[x,y] = total(data_assoc[i])
     endfor

     close, u
     free_lun, u

     img=transpose(img)    
     set_plot, 'z'                 ;put image data in the display window
     New_Nx = long(Nx*2)
     New_Ny = long(2*Ny)
     DEVICE,SET_RESOLUTION=[New_Ny,New_Nx]
     erase

     tvimg = rebin(img, New_Ny, New_Nx,/sample)
     tvscl, tvimg, /device

     tvimg=TVRD()
     set_plot,'ION'
     loadct, 39, /silent
     tv,tvimg,0,-1
     
     foundNeXus = 1

 endif else begin

     set_plot, 'z'             
     erase

     tvimg=TVRD()
     set_plot,'ION'
     loadct, 39, /silent
     tv,tvimg,0,-1

 endelse

result = [strcompress(foundNexus),strcompress(Ntof), tmp_output_file_name]

return, result
END










