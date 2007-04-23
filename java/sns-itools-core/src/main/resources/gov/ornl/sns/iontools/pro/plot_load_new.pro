pro plot_load_new, fname

    fname = "/var/www/html/j35ion/java/IonData/" + fname
    data = bytarr(512)

    openr, unit,fname, /get
    readu, unit, data


    plot, data

    free_lun, unit

end


