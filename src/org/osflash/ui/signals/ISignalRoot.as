package org.osflash.ui.signals
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface ISignalRoot extends ISignalTarget
	{
		
		/**
		 * The Stage which the IUIEventRoot belongs to.
		 */
		function get stage() : Stage;

		/**
		 * The InteractiveObject at root level.
		 */
		function get displayObjectContainer() : DisplayObjectContainer;
	}
}
