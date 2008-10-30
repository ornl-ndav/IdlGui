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

;##############################################################################
;******************************************************************************

PRO FitCEFunction, Event, flt0, flt1, flt2

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

; Compute the second degree polynomial fit to the data:
cooef = POLY_FIT(flt0, $
                 flt1, $
                 1, $
                 MEASURE_ERRORS = flt2, $
                 SIGMA          = sigma) ;standard error

(*(*global).CEcooef) = cooef
(*global).show_CE_fit = 1

;;show original data
;loadct,3
;window,0
;plot,flt0,flt1

;;now calculate data on new coordinates
;N_new = 100
;x_new = findgen(N_new)/N_new
;y_new = cooef(2)*x_new^2 + cooef(1)*x_new + cooef(0)

;;overplot new data in red
;oplot,x_new,y_new,color=200,thick=1.5

END

;******************************************************************************
;******************************************************************************

PRO FitOrder_n_Function, Event, flt0, flt1, flt2, index, order_n

;retrieve global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

; Compute the second degree polynomial fit to the data:
cooef = POLY_FIT(flt0, flt1, order_n, MEASURE_ERRORS=flt2, $
   SIGMA=sigma,/double)

fit_cooef_ptr = (*global).fit_cooef_ptr
*fit_cooef_ptr[index] = cooef
(*global).fit_cooef_ptr = fit_cooef_ptr
(*global).show_other_fit = 1

END

;******************************************************************************
;******************************************************************************

PRO ref_scale_fit
END
