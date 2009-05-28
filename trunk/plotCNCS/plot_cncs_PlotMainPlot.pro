FUNCTION retrieveFirstBankData, NexusFileName, $
                                BankNumber
path    = '/entry/bank' + STRCOMPRESS(BankNumber,/REMOVE_ALL) + '/data'
fileID  = H5F_OPEN(NexusFileName)
fieldID = H5D_OPEN(fileID, path)
data    = H5D_READ(fieldID)
RETURN, data
END

;-------------------------------------------------------------------------------
FUNCTION retrieveBottomBankData, NexusFileName, $
                                 Ntof, $
                                 progressBar, $
                                 Nstep, $
                                 step, $
                                 progressBarCancel

fileID  = H5F_OPEN(NexusFileName)
result  = lonarr(Ntof,128,38*8)
FOR i=0,37 DO BEGIN
    path          = '/entry/bank' + STRCOMPRESS(i+1,/REMOVE_ALL) + '/data'
    fieldID       = H5D_OPEN(fileID, path)
    data          = H5D_READ(fieldID)
    result[0,0,i*8] = data
    IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
        progressBarCancel = 1
        RETURN,result
    ENDIF
ENDFOR
H5F_CLOSE, fileID
RETURN, result
END

;-------------------------------------------------------------------------------
FUNCTION retrieveMiddleBankData, NexusFileName, $
                                 Ntof, $
                                 progressBar, $
                                 Nstep, $
                                 step, $
                                 progressBarCancel

fileID  = H5F_OPEN(NexusFileName)
result  = lonarr(Ntof,128,39*8)
FOR i=0,38 DO BEGIN
    path     = '/entry/bank' + STRCOMPRESS(i+39,/REMOVE_ALL) + '/data'
    fieldID  = H5D_OPEN(fileID, path)
    data     = H5D_READ(fieldID)
    result[0,0,i*8] = data
    IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
        progressBarCancel = 1
        RETURN,result
    END
ENDFOR
;     IF (i EQ 31) THEN BEGIN
;         path          = '/entry/bankM' + STRCOMPRESS(i+1,/REMOVE_ALL) + 'A/data'
;         fieldID       = H5D_OPEN(fileID, path)
;         data          = H5D_READ(fieldID)
;         result[0,0,31*8] = data
;         IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
;             progressBarCancel = 1
;             RETURN,result
;         END
;         path          = '/entry/bankM' + STRCOMPRESS(i+1,/REMOVE_ALL) + 'B/data'
;         fieldID       = H5D_OPEN(fileID, path)
;         data          = H5D_READ(fieldID)
;         result[0,0,32*8] = data
;         IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
;             progressBarCancel = 1
;             RETURN,result
;         ENDIF
;     ENDIF ELSE BEGIN
;         path          = '/entry/bankM' + STRCOMPRESS(i+1,/REMOVE_ALL) + '/data'
;         fieldID       = H5D_OPEN(fileID, path)
;         data          = H5D_READ(fieldID)
;         IF (i LT 31) THEN BEGIN
;             result[0,0,i*8] = data
;         ENDIF
;         IF (i GT 31) THEN BEGIN
;             result[0,0,(i+1)*8] = data
;         ENDIF
;         IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
;             progressBarCancel = 1
;             RETURN,result
;         ENDIF
;    ENDELSE
H5F_CLOSE, fileID
RETURN, result
END

;-------------------------------------------------------------------------------
FUNCTION retrieveTopBankData, NexusFileName, $
                              Ntof, $
                              progressBar, $
                              Nstep, $
                              step, $
                              progressBarCancel

fileID  = H5F_OPEN(NexusFileName)
result  = lonarr(Ntof,128,38*8)
FOR i=0,37 DO BEGIN
    path          = '/entry/bank' + STRCOMPRESS(i+78,/REMOVE_ALL) + '/data'
    fieldID       = H5D_OPEN(fileID, path)
    data          = H5D_READ(fieldID)
    result[0,0,i*8] = data
    IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
        progressBarCancel = 1
        RETURN,result
    ENDIF
ENDFOR
H5F_CLOSE, fileID
RETURN, result
END

;-------------------------------------------------------------------------------
FUNCTION getIMGfromNexus, NexusFileName, progressBar, Nstep, progressBarCancel

;retrieve bank1 data
step       = float(0)           ;0 step so far
bank1      = retrieveFirstBankData(NexusFileName, 1)
Ntof       = (size(bank1))(1)
img        = lonarr(Ntof,128,50*8)
IF (progressBarCancel) THEN RETURN, img
;progressBar->Update,(++step/Nstep)*100
IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
    progressBarCancel = 1
    RETURN, img
ENDIF

;retrieve data from Bottom Bank
progressBar->SetLabel, 'Retrieving Data ...'
BottomBank = retrieveBottomBankData(NexusFileName, $
                                    Ntof, $
                                    progressBar, $
                                    Nstep, $
                                    step,$ 
                                    progressBarCancel)
IF (progressBarCancel) THEN RETURN, img
img[0,0,0] = BottomBank
IF (UpdateProgressBar(progressBar,(float(++step)/Nstep)*100)) THEN BEGIN
    progressBarCancel = 1
    RETURN, img
ENDIF

RETURN, img
END

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

PRO MakeGuiMainPLot_Event, event

WIDGET_CONTROL, event.top, GET_UVALUE=global1

CASE event.id OF

;selection of mbar button - DAS view
    widget_info(event.top, FIND_BY_UNAME='plot_das_view_button_mbar'): begin
        plotDASviewFullInstrument, global1
        activateWidget, event, 'tof_scale_button', 0
        (*global1).real_or_tof =0 
    end

;selection of mbar button - tof view 
    widget_info(event.top, FIND_BY_UNAME='plot_tof_view_button_mbar'): begin
        plotTOFviewFullInstrument, global1
        activateWidget, event, 'tof_scale_button', 1
        (*global1).real_or_tof = 1
    end

;tof scale /9
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d9'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 9
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 9)'
        widget_control, id, set_value= title
    end

;tof scale /8
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d8'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 8
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 8)'
        widget_control, id, set_value= title
    end

;tof scale /7
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d7'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 7
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 7)'
        widget_control, id, set_value= title
    end

;tof scale /6
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d6'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 6
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 6)'
        widget_control, id, set_value= title
    end

;tof scale /5
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d5'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 5
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 5)'
        widget_control, id, set_value= title
    end

;tof scale /4
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d4'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 4
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 4)'
        widget_control, id, set_value= title
    end

;tof scale /3
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d3'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 3
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 3)'
        widget_control, id, set_value= title
    end

;tof scale /2
    widget_info(event.top, FIND_BY_UNAME='tof_scale_d2'): begin
        (*global1).Ytof = (*global1).Ytof_untouched / 2
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (/ 2)'
        widget_control, id, set_value= title
    end

;tof scale reset
    widget_info(event.top, FIND_BY_UNAME='tof_scale_reset'): begin
        (*global1).Ytof = (*global1).Ytof_untouched
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 1)'
        widget_control, id, set_value= title
    end

;tof scale *2
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m2'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 2
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 2)'
        widget_control, id, set_value= title
    end

;tof scale *3
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m3'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 3
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 3)'
        widget_control, id, set_value= title
    end

;tof scale *4
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m4'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 4
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 4)'
        widget_control, id, set_value= title
    end

;tof scale *5
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m5'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 5
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 5)'
        widget_control, id, set_value= title
    end

;tof scale *6
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m6'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 6
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 6)'
        widget_control, id, set_value= title
    end

;tof scale *7
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m7'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 7
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 7)'
        widget_control, id, set_value= title
    end

;tof scale *8
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m8'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 8
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 8)'
        widget_control, id, set_value= title
    end

;tof scale *9
    widget_info(event.top, FIND_BY_UNAME='tof_scale_m9'): begin
        (*global1).Ytof = (*global1).Ytof_untouched * 9
        plotTOFviewFullInstrument, global1
        id = widget_info(event.top,find_by_uname='tof_scale_button')
        title = (*global1).tof_scale_title + ' (* 9)'
        widget_control, id, set_value= title
    end

;Main plot
    widget_info(event.top, FIND_BY_UNAME='main_plot'): begin
        MainPlotInteraction, Event
        IF (Event.press EQ 1) THEN BEGIN ;mouse pressed
            X = Event.X
            Y = Event.Y
            index = getBankIndex(Event, X, Y)
            IF (index NE -1) THEN BEGIN
                bankName = getBank(Event)
                PlotBank, (*(*global1).img), $ ;launch the bank view
                  index, $
                  bankName, $
                  (*global1).real_or_tof
            ENDIF
        ENDIF
    END

ELSE:
ENDCASE

END

;==============================================================================
PRO plotGridMainPlot, global1

;retrieve values from inside structure
Xfactor = (*global1).Xfactor
Yfactor = (*global1).Yfactor
Xcoeff  = (*global1).Xcoeff
Ycoeff  = (*global1).Ycoeff
off     = (*global1).off
xoff    = (*global1).xoff

;##########################################
;PLOT BANKS GRID ##########################
;##########################################
;;plot grid of bottom bank
color  = 100
for i=0,(50-1) do begin
    plots, i*(Xcoeff)+i*off+xoff    , off       , /device, color=color
    plots, i*(Xcoeff)+i*off+xoff    , Ycoeff+off, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, Ycoeff+off, /device, color=color, /continue
    plots, (i+1)*(Xcoeff)+i*off+xoff, off       , /device, color=color, /continue
    plots, i*(Xcoeff)+i*off+xoff    , off       , /device, color=color, /continue
endfor

END

;==============================================================================
PRO plotDASviewFullInstrument, global1

;retrieve values from inside structure
img     = (*(*global1).img)
Xfactor = (*global1).Xfactor
Yfactor = (*global1).Yfactor
Xcoeff  = (*global1).Xcoeff
Ycoeff  = (*global1).Ycoeff
off     = (*global1).off
xoff    = (*global1).xoff
wbase   = (*global1).wBase

;main data array
tvimg = total(img,1)
tvimg = transpose(tvimg)

;change title
id = widget_info(wBase,find_by_uname='main_plot_base')
widget_control, id, base_set_title= (*global1).main_plot_real_title

;select plot area
id = widget_info(wBase,find_by_uname='main_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value
ERASE

;isolate various banks of data
bank = lonarr(8,128)
;plot bottom  banks
for i=0,(50-1) do begin
    bank = tvimg[i*8:(i+1)*8-1,*]
    bank_rebin = rebin(bank,8*Xfactor, 128L*Yfactor,/sample)
    tvscl, bank_rebin, /device, i*(Xcoeff)+i*off+xoff,  off
endfor

;plot grid
plotGridMainPlot, global1
END






PRO plotTOFviewFullInstrument, global1

;##########################################################
;############# Plot x,tof integrated over y ###############
;##########################################################

;retrieve values from inside structure
img     = (*(*global1).img)
Xfactor = (*global1).Xfactor
Yfactor = (*global1).Yfactor
Xcoeff  = (*global1).Xcoeff
Ycoeff  = (*global1).Ycoeff
off     = (*global1).off
xoff    = (*global1).xoff
img     = (*(*global1).img)
wBase   = (*global1).wBase
Ytof    = (*global1).Ytof
Y_factor_display = 2 ;this allow the tof to fill up exactly the vertical space allowed

;change title
id = widget_info(wBase,find_by_uname='main_plot_base')
widget_control, id, base_set_title= (*global1).main_plot_tof_title

;select plot area
id = widget_info(wBase,find_by_uname='main_plot')
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value
ERASE

;find out the range of non-zero values using the first non-empty bank
;bank_index = 49
bank_index = 0
;img = [1000,128,920]
tvimg1     = total(img,2)       ;tvimg1 = [1000,920]
tvimg1     = transpose(tvimg1)  ;tvimg1 = [920,1000]
ngt0 = 0
WHILE (ngt0 EQ 0) DO BEGIN
;sum the 8 tubes together
    tvimg2     = tvimg1[bank_index*8:(bank_index+1)*8-1,*]
    tvimg2     = total(tvimg2,1)
    NZindexes  = WHERE(tvimg2 GT 0, ngt0)
    bank_index++
ENDWHILE
index_start = NZindexes[0]
index_stop  = NZindexes[ngt0-1]

;keep only all data between index_start and index_stop
tvimg2     = tvimg1[*,index_start:index_stop]
Npts       = (size(tvimg2))(2) ;number of tof that survive the where GT 0 routine
dim_new    = Ytof            ;number of points we want in the Y axis (tof here)
ds         = Npts/dim_new      ;resulting downsampling ratio - how many points 
;dim_new    *= 2
;to become one point

;isolate various banks of data
;plot bottom  banks
for i=0,(38-1) do begin
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    IF (ds LT (size(bank))(1)) THEN BEGIN
        bank_smooth  = smooth(bank,ds,/edge)
    ENDIF ELSE BEGIN
        bank_smooth = bank
    ENDELSE
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new*Y_factor_display)
    tvscl, bank_congrid, /device, i*(Xcoeff)+i*off+xoff, off
endfor

;plot middle banks
yoff   = Ycoeff + 2*off
for i=38,68 do begin
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    bank_smooth  = smooth(bank,ds,/edge)
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new*Y_factor_display)
    tvscl, bank_congrid, /device, (i-38)*(Xcoeff)+(i-38)*off+xoff, yoff
endfor

;plot 32A and 32B of middle banks
i = 70 ;32B (bottom one)
bank         = tvimg2[i*8:(i+1)*8-1,*]
bank_smooth  = smooth(bank,ds,/edge)
bank_congrid = congrid(bank_smooth,Xcoeff,dim_new)
tvscl, bank_congrid, /device, (i-39)*(Xcoeff)+(i-39)*off+xoff, yoff

i = 69 ;32A (top one)
bank         = tvimg2[i*8:(i+1)*8-1,*]
bank_smooth  = smooth(bank,ds,/edge)
bank_congrid = congrid(bank_smooth,Xcoeff,dim_new)
tvscl, bank_congrid, /device, (i-38)*(Xcoeff)+(i-38)*off+xoff, yoff+Ycoeff/2

;plot 33 to 38 of middle banks
FOR i=71,76 DO BEGIN
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    bank_smooth  = smooth(bank,ds,/edge)
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new*Y_factor_display)
    tvscl, bank_congrid, /device, (i-39)*(Xcoeff)+(i-39)*off+xoff, yoff
ENDFOR

;plot top banks
yoff   = 2*Ycoeff + 3*off
for i=77,114 do begin
    bank         = tvimg2[i*8:(i+1)*8-1,*]
    bank_smooth  = smooth(bank,ds,/edge)
    bank_congrid = congrid(bank_smooth,Xcoeff,dim_new*Y_factor_display)
    tvscl, bank_congrid, /device, (i-77)*(Xcoeff)+(i-77)*off+xoff, yoff
endfor

;plot grid
plotGridMainPlot, global1

END



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO PlotMainPlot, histo_mapped_file
;build gui
wBase = ''
MakeGuiMainPlot, wBase

global1 = ptr_new({ histo_file_name:      histo_mapped_file,$
                    real_or_tof:          0,$;0:REAL das view, 1:tof view
                    tof_scale_title:      'TOF scale',$
                    Xfactor:              4,$
                    Yfactor:              2,$
                    Yfactor_untouched:    2,$
                    Xcoeff:               8 * 4,$
                    Ycoeff:               128L * 2,$
                    Ytof:                 128L * 2,$
                    Ytof_untouched:       128L*2,$
                    off:                  5,$
                    xoff:                 10,$
                    img:                  ptr_new(0L),$
                    main_plot_real_title: 'Real View of Instrument (Y vs X integrated over TOF)',$
                    main_plot_tof_title:  'TOF View (TOF vs X integrated over Y)',$
                    wbase:                wbase})

file_ext = ' - File: ' + histo_mapped_file
(*global1).main_plot_real_title += file_ext
(*global1).main_plot_tof_title += file_ext

WIDGET_CONTROL, wBase, SET_UVALUE = global1
XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5

;open file
openr,u,histo_mapped_file,/get
fs=fstat(u)
Nx = long(38*8*3+8)
Ny = long(128)
Nimg = long(Nx*Ny)
Ntof = fs.size/(Nimg*4L)

;read data
data = lonarr(Ntof*Nimg)
readu,u,data
close, u
free_lun,u

indx1 = where(data GT 0, ngt0)
img = intarr(Ntof,Ny,Nx)
IF (ngt0 GT 0) THEN BEGIN
    img(indx1) = data(indx1)
ENDIF

(*(*global1).img)= img

;plot das view of full instrument
plotDASviewFullInstrument, global1

END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO PlotMainPlotFromNexus, NexusFileName
;build gui
wBase = ''
MakeGuiMainPlot, wBase

global1 = ptr_new({ NexusFileName:         NexusFileName,$
                    real_or_tof:           0,$;0:REAL das view, 1:tof view
                    tof_scale_title:       'TOF scale',$
                    Xfactor:               4,$
                    Yfactor:               2,$
                    Yfactor_untouched:     2,$
                    Xcoeff:                8 * 4,$
                    Ycoeff:                128L * 2,$
                    Ytof:                  128L * 2,$
                    Ytof_untouched:        128L*2,$
                    off:                   5,$
                    xoff:                  10,$
                    img:                   ptr_new(0L),$
                    main_plot_real_title:  'Real View of Instrument (Y vs X integrated over TOF)',$
                    main_plot_tof_title:   'TOF View (TOF vs X integrated over Y)',$
                    wbase:                 wbase})

file_ext = ' - File: ' + NexusFileName
(*global1).main_plot_real_title += file_ext
(*global1).main_plot_tof_title += file_ext

WIDGET_CONTROL, wBase, SET_UVALUE = global1
XMANAGER, "MakeGuiMainPlot", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK

DEVICE, DECOMPOSED = 0
loadct, 5

Nstep  = FLOAT(50) ;number of steps
progressBarCancel = 0
progressBar = OBJ_NEW("SHOWPROGRESS", $
                      XOFFSET = 100, $
                      YOFFSET = 50, $
                      XSIZE   = 200,$
                      TITLE   = 'Loading Data',$
                      /CANCELBUTTON)
progressBar->SetColor, 250
progressBar->SetLabel, 'Retrieving Ntof ...'
progressBar->Start

img = getIMGfromNexus(NexusFileName, progressBar, Nstep, progressBarCancel)
(*(*global1).img)= img

;plot das view of full instrument
progressBar->SetLabel, 'Generating Plot ...'
plotDASviewFullInstrument, global1

progressBar->Destroy
Obj_Destroy, progressBar

END
