package gov.ornl.sns.iontools;

import javax.swing.*;

public class TabUtils {

	/*
	 * Remove special foreground of all tabs
	 */
	public static void removedAllTabColor() {
		
		//remove color of selection tab
		for (int i=0; i<4; i++) {
			removeForegroundColor(DataReduction.selectionTab, i);
		}
		
		//remove color of main tab
		for (int i=0; i<3; i++) {
			removeForegroundColor(DataReduction.tabbedPane,i);
		}

		//remove color of extra plot tabs
		for (int i=0; i<5; i++) {
			removeForegroundColor(DataReduction.extraPlotsTabbedPane,i);
		}
	}
		
	/*
	 * remove special foreground color of tab if tab is selected 
	 */
	public static void removeColorWhenClicked(JTabbedPane tabbedTab) {
		int iSelectedIndex = tabbedTab.getSelectedIndex();
		removeForegroundColor(tabbedTab,iSelectedIndex);
	}
	
	/*
	 * remove special foreground color of parent tab when all child tab 
	 * has been checked
	 */
	public static void removeColorOfParentTab(JTabbedPane parentTab, JTabbedPane childTab) {
		
		//remove color of child tab selected (visisble)
		removeColorWhenClicked(childTab);
		
		//if all the child tab has been checked, remove color of parent tab
		//int iSelectedParentIndex = parentTab.getSelectedIndex();
		//int iSelectedChildIndex = childTab.getSelectedIndex();
		int iSelectedChildIndexNbr = childTab.getTabCount();
		boolean bAllTabChecked = isAllTabChecked(childTab, iSelectedChildIndexNbr);
		if (bAllTabChecked) {
			removeColorWhenClicked(parentTab);
		}
		
	}
	
	/*
	 * This function check if all the tabs of the childTab has been reviewed
	 */
	private  static boolean isAllTabChecked(JTabbedPane childTab, int iSelectedChildIndexNbr) {
		boolean bAllTabChecked = true;
		for (int i=0; i<iSelectedChildIndexNbr; ++i) {
			if (childTab.getForegroundAt(i)==IParameters.TAB_FOREGROUND_NEW) {
				return false;
			}
		}
		return bAllTabChecked;
	}
	
	/*
	 * This function will show that some of the information contains in that tab
	 * has been modified
	 */
	public static void addBackgroundColorToTab(JTabbedPane tabbedTab, int index) {
		tabbedTab.setBackgroundAt(index,IParameters.TAB_BACKGROUND_NEW);
	}
	
	/*
	 * This function removes background to selected tab
	 */
	public static void removeBackgroundColorToTab(JTabbedPane tabbedTab, int index) {
		tabbedTab.setBackgroundAt(index,IParameters.TAB_BACKGROUND_OLD);
	}
	
	/*
	 * Change the color of font of selected tab
	 */
	public static void addForegroundColor(JTabbedPane tabbedTab, int index) {
		tabbedTab.setForegroundAt(index, IParameters.TAB_FOREGROUND_NEW);
	}
	
	/*
	 * Reset the color of font of selected tab
	 */
	public static void removeForegroundColor(JTabbedPane tabbedTab, int index) {
		tabbedTab.setForegroundAt(index, IParameters.TAB_FOREGROUND_OLD);
	}
		
}
