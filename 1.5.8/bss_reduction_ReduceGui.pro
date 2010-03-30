;==============================================================================
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
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
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
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO BSSreduction_EnableOrNotFields, Event, type, force_enabled

IF (n_elements(force_enabled) NE 0) THEN BEGIN
    ActivateStatus = force_enabled
ENDIF ELSE BEGIN
;Value of button
    ActivateStatus = isButtonSelectedAndEnabled(Event,type)
ENDELSE

CASE (type) OF
    'tibc_for_sd_button': BEGIN
        text_unames = ['tibc_for_sd_value_text','tibc_for_sd_error_text']
    END
    'tibc_for_bd_button': BEGIN
        text_unames = ['tibc_for_bd_value_text','tibc_for_bd_error_text']
    END
    'tibc_for_nd_button': BEGIN
        text_unames = ['tibc_for_nd_value_text','tibc_for_nd_error_text']
    END
    'tibc_for_ecd_button': BEGIN
        text_unames = ['tibc_for_ecd_value_text','tibc_for_ecd_error_text']
    END
    'csfds_button': BEGIN
        text_unames = ['csfds_value_text']
    END
    'tzsp_button': BEGIN
        text_unames = ['tzsp_value_text','tzsp_error_text']
    END
    'tzop_button': BEGIN
        text_unames = ['tzop_value_text','tzop_error_text']
    END
    'eha_button': BEGIN
        text_unames = ['eha_min_text','eha_max_text', 'eha_bin_text']
    END
    'gifw_button': BEGIN
        text_unames = ['gifw_value_text','gifw_error_text']
    END
    'wocpsamn_button': BEGIN
        text_unames = ['wa_min_text','wa_max_text','wa_bin_width_text']
        activate_button, Event, 'wa_label', ActivateStatus
    END
    'niw_button': BEGIN
        text_unames = ['nisw_field','niew_field']
    END
    'te_button': BEGIN
        text_unames = ['te_low_field','te_high_field']
    END
    'tibc_for_scatd_button': BEGIN
        text_unames = ['tibc_for_scatd_value_text','tibc_for_scatd_error_text']
    END
    'tib_tof_button': BEGIN
        text_unames = ['tibtof_channel1_text', $
                       'tibtof_channel2_text', $
                       'tibtof_channel3_text',$
                       'tibtof_channel4_text']
    END
    'csbss_button': BEGIN
        text_unames = ['csbss_value_text','csbss_error_text']
    END
    'csn_button': BEGIN
        text_unames = ['csn_value_text','csn_error_text']
    END
    'bcs_button': BEGIN
        text_unames = ['bcs_value_text','bcs_error_text']
    END
    'bcn_button': BEGIN
        text_unames = ['bcn_value_text','bcn_error_text']
    END
    'cs_button': BEGIN
        text_unames = ['cs_value_text','cs_error_text']
    END
    'cn_button': BEGIN
        text_unames = ['cn_value_text','cn_error_text']
    END
    'tof_cutting_button': BEGIN
        text_unames = ['tof_cutting_min_text','tof_cutting_max_text']
    END
    ELSE: BEGIN
        text_unames  = ['']
    END
ENDCASE

IF ((size(text_unames))(1) GE 1 AND $
    text_unames[0] NE '') THEN BEGIN
    new_text_unames = [text_unames,text_unames + '_label']
    sz=(size(new_text_unames))(1)
    FOR i=0,(sz-1) DO BEGIN
        activate_button, Event, new_text_unames[i], ActivateStatus
    ENDFOR
ENDIF

END




;This procedure upate the GUI
PRO BSSreduction_ReduceUpdateGui, Event

;If there is a normalization run then activate in tab3
;Normalization Integration Start and End Wavelength (Angstroms)
widgets = ['niw_button']
NDFiles = getTextFieldValue(Event,'ndf_list_of_runs_text')
IF (NDFiles NE '') THEN BEGIN ;activate widgets
    activate_status = 1
ENDIF ELSE BEGIN ;desactivate widgets
    activate_status = 0
ENDELSE
sz = (size(widgets))(1)
FOR i=0,(sz-1) DO BEGIN
    activate_button, Event, widgets[i], activate_status
ENDFOR
IF (activate_status EQ 0) THEN BEGIN
    BSSreduction_EnableOrNotFields, Event, widgets[0]
ENDIF

;If dsback is not null, then activate in tab3
;Low and High values that bracket the elastic peak
widgets = ['te_button']
DSBFiles = getTextFieldValue(Event,'dsb_list_of_runs_text')
IF (DSBFiles NE '') THEN BEGIN ;activate widgets
    activate_status = 1
ENDIF ELSE BEGIN ;desactivate widgets
    activate_status = 0
ENDELSE
sz = (size(widgets))(1)
FOR i=0,(sz-1) DO BEGIN
    activate_button, Event, widgets[i], activate_status
ENDFOR
IF (activate_status EQ 0) THEN BSSreduction_EnableOrNotFields, Event, widgets[0]

;update or not the intermediate files flags
BSSreduction_Reduce_waio_button, Event

END

