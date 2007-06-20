package gov.ornl.sns.iontools;

public class OtherPlotsUtils {

  /*
   * This functions checks that the selection is valid 
   */
  static boolean isSelectionValid(int xmin, int xmax, int ymin, int ymax) {
    if (xmin == 0 && xmax == 0 && ymin == 0 && ymax ==0) {
      return false;
    } else {
      return true;
    }
  }
  
  /*
   * Checks that 0 <= TBinMin <= Ntof and TBinMin <= TBinMax <= Ntof
   */
  static boolean isTBinMinMaxCorrect(int TBinMin, int TBinMax) {
    
    int NTof = Integer.parseInt(DataReduction.sNtof);
    if (0 <= TBinMin &&
        TBinMin < NTof &&
        TBinMin <= TBinMax &&
        TBinMax < NTof) {
      return true;
    } else {
      return false;
    }
          
  }
  
}
