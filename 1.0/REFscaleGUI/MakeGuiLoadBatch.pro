PRO MakeGuiLoadBatch, STEPS_TAB, StepsTabSize

;*******************************************************************************
;Define Parameters
;*******************************************************************************
sLoadBatchBase = { size  : [0,0,StepsTabSize[2:3]],$
                   uname : 'load_batch_base',$
                   title : 'LOAD BATCH'}

;*******************************************************************************
;Build GUI
;*******************************************************************************
wLoadBatchBase = WIDGET_BASE(STEPS_TAB,$
                           UNAME     = sLoadBatchBase.uname,$
                           XOFFSET   = sLoadBatchBase.size[0],$
                           YOFFSET   = sLoadBatchBase.size[1],$
                           SCR_XSIZE = sLoadBatchBase.size[2],$
                           SCR_YSIZE = sLoadBatchBase.size[3],$
                           TITLE     = sLoadBatchBase.title)
END
