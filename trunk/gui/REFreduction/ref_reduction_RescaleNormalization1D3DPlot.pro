;This function is reached each time a new angle is loaded for either
;x or y axis. When the scale is changed for x,y and z (linear/log) and
;when a new min or max value is entered for Z-axis
PRO REFreduction_RescaleNormalization1D3DPlot, Event
END

;This function reset the x-axis of data 1D_3D plot
PRO REFreduction_ResetNormalization1D3DPlotXaxis, Event
END

;This function reset the y-axis of data 1D_3D plot
PRO REFreduction_ResetNormalization1D3DPlotYaxis, Event
END

;This function reset the z-axis of data 1D_3D plot
PRO REFreduction_ResetNormalization1D3DPlotZaxis, Event
END

;This function is reached when the user interacts with the google type
;orientation tool
PRO REFreduction_RotateNormalization1D3DPlot_Orientation, Event, Axis, RotationFactor
END

;This function is reached when the RESET button inside the google type
;orientation tool is clicked.
PRO REFreduction_ResetNormalization1D3DPlot_OrientationReset, Event
END
