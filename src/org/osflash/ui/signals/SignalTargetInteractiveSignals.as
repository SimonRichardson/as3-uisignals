package org.osflash.ui.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class SignalTargetInteractiveSignals
	{
		
		/**
		 * @private
		 */
		private var _focusInSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _focusOutSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseDownSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseMoveSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseUpSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseClickSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseWheelSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseDragOutSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseDragInSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseOutSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _mouseInSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _keyDownSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _keyUpSignal : ISignal;
		
		public function SignalTargetInteractiveSignals()
		{
			// TODO : Make this on demand!
			_focusInSignal = new Signal(ISignalTarget, ISignalTarget);
			_focusOutSignal = new Signal(ISignalTarget, ISignalTarget);
			_mouseDownSignal = new Signal(ISignalTarget, Point);
			_mouseMoveSignal = new Signal(ISignalTarget, Point, Boolean);
			_mouseUpSignal = new Signal(ISignalTarget, Point);
			_mouseClickSignal = new Signal(ISignalTarget, Point);
			_mouseWheelSignal = new Signal(ISignalTarget, Point, Number, Boolean);
			_mouseDragOutSignal = new Signal(ISignalTarget, Point);
			_mouseDragInSignal = new Signal(ISignalTarget, Point);
			_mouseOutSignal = new Signal(ISignalTarget, Point);
			_mouseInSignal = new Signal(ISignalTarget, Point);
			_keyDownSignal = new Signal(ISignalTarget, KeyboardEvent);
			_keyUpSignal = new Signal(ISignalTarget, KeyboardEvent);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focusInSignal() : ISignal { return _focusInSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get focusOutSignal() : ISignal { return _focusOutSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseDownSignal() : ISignal { return _mouseDownSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseMoveSignal() : ISignal { return _mouseMoveSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseUpSignal() : ISignal { return _mouseUpSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseClickSignal() : ISignal { return _mouseClickSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseWheelSignal() : ISignal { return _mouseWheelSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseDragOutSignal() : ISignal { return _mouseDragOutSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseDragInSignal() : ISignal { return _mouseDragInSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseOutSignal() : ISignal { return _mouseOutSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get mouseInSignal() : ISignal { return _mouseInSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get keyDownSignal() : ISignal { return _keyDownSignal; }
		
		/**
		 * @inheritDoc
		 */
		public function get keyUpSignal() : ISignal { return _keyUpSignal; }
	}
}
