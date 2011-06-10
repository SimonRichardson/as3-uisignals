package org.osflash.ui.display.base
{
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.Shape;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalShape extends Shape implements ISignalDisplay
	{
		
		/**
		 * @private
		 */
		private var _target : ISignalTarget;
		
		/**
		 * 
		 */
		public function SignalShape(target : ISignalTarget)
		{
			super();
			
			if(null == target) throw new ArgumentError('Given value can not be null');
			_target = target;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get target() : ISignalTarget { return _target; }
	}
}
