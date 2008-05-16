;this function plots the 1D and 2D data of the Normalizatio file only
PRO REFreduction_Plot1D2DNormalizationFile, Event
;plot the 2D data file (default old view)
REFreduction_Plot2DNormalizationFile, Event
;plot the 1D data file
REFreduction_Plot1DNormalizationFile, Event
END

;this function plots the 1D and 2D data of the Normalizatio file only
;This function is reached by the batch mode
PRO REFreduction_Plot1D2DNormalizationFile_batch, Event
;plot the 2D data file (default old view)
REFreduction_Plot2DNormalizationFile_batch, Event
;plot the 1D data file
REFreduction_Plot1DNormalizationFile_batch, Event
END
