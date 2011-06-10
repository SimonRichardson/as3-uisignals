package org.osflash.ui.display.base
{
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.MovieClip;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalMovieClip extends MovieClip implements ISignalDisplay
	{
		
		/**
		 * @private
		 */
		private var _target : ISignalTarget;
		
		/**
		 * 
		 */
		public function SignalMovieClip(target : ISignalTarget)
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
