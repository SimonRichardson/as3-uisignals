package org.osflash.ui.utils
{
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public final class SignalManagerFrameRate
	{
		
		/**
		 * @private
		 */
		private var _min : int;
		
		/**
		 * @private
		 */
		private var _max : int;
		
		/**
		 * SignalManagerFrameRate constructor to give an indiciation of what the frameRate
		 * should be when active and deactive.
		 * 
		 * @param min int value when deactive
		 * @param max int value when active
		 */
		public function SignalManagerFrameRate(min : int = 5, max : int = 60)
		{
			_min = min;
			_max = max;
		}
		
		/**
		 * Min value when the SignalManager is deactivated.
		 * @param value int
		 * @return int
		 */
		public function get min() : int { return _min; }
		public function set min(value : int) : void { _min = value; }
		
		/**
		 * Max value when the SignalManager is activated.
		 * @param value int
		 * @return int
		 */
		public function get max() : int { return _max; }
		public function set max(value : int) : void { _max = value; }
	}
}
