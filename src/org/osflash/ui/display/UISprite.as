package org.osflash.ui.display
{
	import org.osflash.ui.display.base.SignalSprite;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UISprite extends UIDisplayObjectContainer
	{
		
		public function UISprite()
		{
			super(new SignalSprite(this));
		}
	}
}
