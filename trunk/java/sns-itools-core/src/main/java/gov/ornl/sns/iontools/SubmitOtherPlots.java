package gov.ornl.sns.iontools;

public class SubmitOtherPlots implements Runnable{

    private String cmd = null;
  
    public SubmitOtherPlots(String cmd) {
      this.cmd = cmd;
    }
  
    public void run() {

    //ProcessingInterfaceWithGui.displayProcessingMessage("Plot in progress");
      System.out.println("cmd is: " + this.cmd);
      IonUtils.executeCmd(this.cmd);

    }
  
  
  
}
