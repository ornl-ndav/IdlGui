;define path to dependencies and current folder
CD , CURRENT=CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/reader_writer_routines/'
cd, IdlUtilitiesPath
.run gettok.pro
.run is_ieee_big.pro
.run fxparpos.pro
.run fxaddpar.pro
.run fxmove.pro
.run fxpar.pro
.run fxposit.pro
.run ieee_to_host.pro
.run mrd_skip.pro
.run mrd_struct.pro
.run valid_num.pro
.run mrd_hread.pro
.run match.pro
.run mrdfits.pro

.run sxdelpar.pro
.run hprint.pro
.run fits_open.pro
.run fits_close.pro
.run strn.pro
.run sxpar.pro
.run textopen.pro
.run textclose.pro
.run fits_info.pro
.run fits_help.pro

.run sxaddpar.pro
.run fits_write.pro

cd, CurrentFolder
.run fits_reader.pro
