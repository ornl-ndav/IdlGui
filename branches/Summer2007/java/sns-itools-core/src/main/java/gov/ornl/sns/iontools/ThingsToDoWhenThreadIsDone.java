package gov.ornl.sns.iontools;

public class ThingsToDoWhenThreadIsDone {

  static void doWhenMainPlotIsDone() {    
    //activate refresh button
    DataReduction.transferRefreshButton.setEnabled(true);
    ParametersToKeep.bNeedToRefreshListOfFiles = true;
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
}
