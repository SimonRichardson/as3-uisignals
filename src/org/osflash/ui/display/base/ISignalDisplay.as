package org.osflash.ui.display.base
{
	import org.osflash.ui.signals.ISignalTarget;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface ISignalDisplay
	{
		
		function get target() : ISignalTarget;
	}
}
