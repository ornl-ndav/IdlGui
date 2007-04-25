package gov.ornl.sns.iontools;



public class MouseSelection {

	private int x1;
	private int y1;
	private int x2;
	private int y2;
		
	public void testFunction() {
			System.out.println("I'm in testFunction");
	}
	
	/*
	 *******************************************
	 * Mouse Listener Implementation
	 */

	/*
	public void mousePressed(com.rsi.ion.IONDrawable drawable, int X, int Y, 
	                    long when, int mask)
	  {
	      if (IONfoundNexus.toString().compareTo("0") != 0) {

		  if (X < 0) {X = 0;};
		  if (Y < NyMin*2) {Y = NyMin*2;};
		  if (X > Nx*2) {X = 2*Nx-1;};
		  if (Y > 2*NyMax) {Y = 2*Ny-1;};
		  
		  
		  if (modeSelected.compareTo("signalSelection") == 0) {
		      signal_x1 = X;
		      signal_y1 = Y;
		  } else if (modeSelected.compareTo("back1Selection") == 0) {
		      back1_x1 = X;
		      back1_y1 = Y;
		  } else if (modeSelected.compareTo("back2Selection") == 0) {
		      back2_x1 = X;
		      back2_y1 = Y;
		  } else {
		      info_x = X;
		      info_y = Y;
		  }

		  c_xval1 = (int) X / 2;
		  c_yval1 = (int) (607-Y)/2;
		  
		  c_plot.addIONMouseListener(this, com.rsi.ion.IONMouseListener.ION_MOUSE_ANY);
	      }
	      return;
	  }

	*/
}
