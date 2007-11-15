PRO BSSselection_CreateConfigFile, global

ConfigFileName = (*global).DefaultConfigFileName
openw, 1, ConfigFileName

;Input
sz = N_TAGS(((*global).Configuration.Input))
TagNames = tag_names((*global).Configuration.Input)
FOR I=0,(sz-1) DO BEGIN
    text = TagNames[i] + ' ' + strcompress((*global).Configuration.Input.(i),/remove_all)
    printf, 1, text
ENDFOR

;Reduce
sz = N_TAGS(((*global).Configuration.Reduce))
FOR I=0,(sz-1) DO BEGIN
    sz2 = N_TAGS((*global).Configuration.Reduce.(i))
    TagNames = tag_names((*global).Configuration.Reduce.(i))
    sz = (size(TagNames))(1)
    FOR j=0,(sz-1) DO BEGIN
        text = TagNames[j] + ' ' + strcompress((*global).Configuration.Reduce.(i).(j),/remove_all)
        printf, 1, text
    ENDFOR
ENDFOR

close, 1
free_lun, 1

END
