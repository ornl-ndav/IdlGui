function GetIonDataFiles, extension

    if (n_elements(extension) eq 0) then extension = '*' $
    else extension = "*"+extension
    dataDir = "/var/www/html/j35ion/java/IonData"
    fileNames = FILE_SEARCH(dataDir,extension)
    return, FILE_BASENAME(fileNames)

end
