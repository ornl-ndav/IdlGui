function GET_LIST_OF_PID_FILES, path, pid_file_extension

cmd = "ls " + path + "*" + pid_file_extension
spawn, cmd, listening

list_of_files = listening
    
return, list_of_files
end
