package org.osflash.ui.display.base
{
	import org.osflash.ui.signals.ISignalTarget;
	import flash.display.Bitmap;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalBitmap extends Bitmap implements ISignalDisplay
	{
		
		/**
		 * @private
		 */
		private var _target : ISignalTarget;
		
		/**
		 * 
		 */
		public function SignalBitmap(target : ISignalTarget)
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
