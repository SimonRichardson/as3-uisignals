package org.osflash.ui.display.base
{
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.Sprite;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalSprite extends Sprite implements ISignalDisplay
	{
		
		/**
		 * @private
		 */
		private var _target : ISignalTarget;
		
		/**
		 * 
		 */
		public function SignalSprite(target : ISignalTarget)
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
