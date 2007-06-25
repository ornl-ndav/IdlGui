package gov.ornl.sns.iontools;

public class ThingsToDoWhenThreadIsDone {

  static void doWhenMainPlotIsDone() {    
    //activate refresh button
    DataReduction.transferRefreshButton.setEnabled(true);
    ParametersToKeep.bNeedToRefreshListOfFiles = true;
    activateOtherPlotsWidgets(DataReduction.bFoundNexus);
    
  }
  
  static void doWhenLoadctIsDone() {
    //activate refresh button
    DataReduction.transferRefreshButton.setEnabled(true);
    ParametersToKeep.bNeedToRefreshListOfFiles = true;
  }
    
  static void doWhenDataReductionIsDone() {
    //activate refresh button
    DataReduction.transferRefreshButton.setEnabled(true);
    ParametersToKeep.bNeedToRefreshListOfFiles = true;
  }

  static void doWhenCreatePidFileIsDone() {
    //activate refresh button
    DataReduction.transferRefreshButton.setEnabled(true);
    ParametersToKeep.bNeedToRefreshListOfFiles = true;
  }

  /*
   * This function activates the comboBoxes and the two buttons
   * CLEAR and RESET
   */
  static void activateOtherPlotsWidgets(boolean bActivate) {
    CreateOtherPlotsPanel.clearButton.setEnabled(bActivate);
    CreateOtherPlotsPanel.refreshButton.setEnabled(bActivate);
    CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.setEnabled(bActivate);
    CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.setEnabled(bActivate);
}


}
