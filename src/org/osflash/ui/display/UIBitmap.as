package org.osflash.ui.display
{
	import org.osflash.ui.display.base.SignalBitmap;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIBitmap extends UIDisplayObject
	{

		public function UIBitmap()
		{
			super(new SignalBitmap(this));
		}
	}
}
