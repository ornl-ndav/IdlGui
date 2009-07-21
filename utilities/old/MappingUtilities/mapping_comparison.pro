PRO mapping_comparison

fileDAS = "~/tmp/deleteme.eqsans.dasmapping"
fileTS  = "~/tmp/deleteme.eqsans.dasmapping"

;read fileDAS
  OPENR,u,fileTS,/get
  fs=FSTAT(u)
  N = fs.size/(4L)

  ;read data
  data = DBLARR(N)
  READU,u,data
  CLOSE, u
  FREE_LUN,u

print, data[0:100]

END
