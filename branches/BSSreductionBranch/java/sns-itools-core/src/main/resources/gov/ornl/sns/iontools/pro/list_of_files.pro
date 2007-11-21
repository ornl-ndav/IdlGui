FUNCTION LIST_OF_FILES, tmp_folder

;cmd = '/usr/bin/find '
;cmd += tmp_folder
;cmd += ' -type f'

print, tmp_folder
cmd = 'ls '
cmd += tmp_folder
spawn, cmd, listening
return, listening
end
