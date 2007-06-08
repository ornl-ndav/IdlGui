Function NXSUMMARY, run_number, instrument, full_path_to_config_file

cmd = 'findnexus -i' + instrument
cmd += " " + run_number
spawn, cmd, nexus_full_path


cmd = "nxsummary " + nexus_full_path[0]
cmd += " --config " + full_path_to_config_file
spawn, cmd, listening

return, listening
end
