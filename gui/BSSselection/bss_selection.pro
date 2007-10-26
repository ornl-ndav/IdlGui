PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

VERSION = 'VERSION: BSSselection1.0.0'
loadct,5

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({processing : 'PROCESSING',$
                   ok : 'OK',$
                   failed : 'FAILED',$
                   bank1: ptr_new(0L),$ ;array of bank1 data (Ntof, Nx, Ny)
                   bank2: ptr_new(0L),$ ;array of bank2 data (Ntof, Nx, Ny)
                   nexus_bank1_path : '/entry/bank1/data',$ ;nxdir path to bank1 data
                   nexus_bank2_path : '/entry/bank2/data',$ ;nxdir path to bank2 data
                   Nx : 56,$
                   Ny : 64,$
                   Xfactor : 15,$ ;coefficient in X direction for rebining img
                   Yfactor : 4,$ ; coefficient in Y direction for rebining img
                   DefaultPath : '~/local/BSS/',$ ;default path where to look for the file
                   DefaultFilter : '*.nxs'$ ;default filter for the nexus file
                  })

XYfactor = {Xfactor:(*global).Xfactor, Yfactor:(*global).Yfactor}

MainBaseSize  = [50,200,880,800]
MainBaseTitle = 'BSS selection tool'
        
;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME='MAIN_BASE',$
                         SCR_XSIZE=MainBaseSize[2],$
                         SCR_YSIZE=MainBaseSize[3],$
                         XOFFSET=MainBaseSize[0],$
                         YOFFSET=MainBaseSize[1],$
                         TITLE=MainBaseTitle,$
                         SPACE=0,$
                         XPAD=0,$
                         YPAD=2)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;add version to program
version_label = widget_label(MAIN_BASE,$
                             XOFFSET=700,$
                             YOFFSET=2,$
                             VALUE=VERSION,$
                             FRAME=0)

MakeGuiMainTab, MAIN_BASE, MainBaseSize, XYfactor

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

END


; Empty stub procedure used for autoloading.
pro bss_selection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





