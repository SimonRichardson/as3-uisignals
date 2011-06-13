package org.osflash.ui.display
{
	import org.osflash.ui.display.base.SignalMovieClip;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIMovieClip extends UIDisplayObjectContainer
	{

		public function UIMovieClip()
		{
			super(new SignalMovieClip(this));
		}

	}
}
