package org.osflash.ui.signals
{
	import org.osflash.ui.utils.SignalManagerFrameRate;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface ISignalManager
	{
		
		function stealCapture(target : ISignalTarget) : void;
		
		function reset() : void;
		
		function get focus() : ISignalTarget;
		function set focus(value : ISignalTarget) : void;
		
		function get root() : ISignalRoot;
		
		function get enabled() : Boolean;
		
		function get frameRate() : SignalManagerFrameRate;
	}
}
