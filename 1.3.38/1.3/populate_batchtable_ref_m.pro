pro populate_BatchTable_ref_m, BatchTable, ClassInstance
    compile_opt idl2
    
  MainDataRunNumber = ClassInstance->getMainDataRunNumber()
  DataSpinState = ClassInstance->getDataPath()
  MainNormRunNumber = ClassInstance->getMainNormRunNumber()
  NormSpinState = ClassInstance->getNormPath()
  
  
  end