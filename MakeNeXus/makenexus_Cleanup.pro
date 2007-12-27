PRO makenexus_Cleanup, Main_Base

Widget_Control, Main_Base, get_uvalue=global

;clean up stagingArea folder
StagingArea = (*global).staging_folder
cmd = 'rm -f ' + StagingArea + '/*.*'
spawn, cmd

END
