package gov.ornl.sns.iontools;

public class SettingsTabAction {

  /*
   * This function is triggered when the user press enter on the Not xml text field of the settings tab
   */
   static void validateNotXmlTextField() { 
   
     String sValue = DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.getText();
     try {
       int iValue = Integer.parseInt(sValue);
       DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.setBackground(IParameters.TEXT_BOX_RIGHT_FORMAT);
       ParametersToKeep.iNbrInfoLinesNotXmlToDisplayed = iValue;
     } catch (Exception e) {
       ParametersToKeep.iNbrInfoLinesNotXmlToDisplayed = IParameters.i_NO_RMD_NBR_LINE_DISPLAYED;
       DataReduction.nbrInfoLinesDisplayedNotXmlFilesTextField.setBackground(IParameters.TEXT_BOX_WRONG_FORMAT);      
     }
   }
   
   /*
    * This function is trigerred when the user press enter on the Xml text field of the settings tab
    */
   static void validateXmlTextField() {
     
     String sValue = DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.getText();
     try {
       int iValue = Integer.parseInt(sValue);
       DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.setBackground(IParameters.TEXT_BOX_RIGHT_FORMAT);
       ParametersToKeep.iNbrInfoLinesXmlToDisplayed = iValue;
     } catch (Exception e) {
       ParametersToKeep.iNbrInfoLinesXmlToDisplayed = IParameters.i_RMD_NBR_LINE_DISPLAYED;
       DataReduction.nbrInfoLinesDisplayedXmlFilesTextField.setBackground(IParameters.TEXT_BOX_WRONG_FORMAT);
     }
   }
  
}
