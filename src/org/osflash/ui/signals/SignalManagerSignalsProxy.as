package org.osflash.ui.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public final class SignalManagerSignalsProxy
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
		
		/**
		 * @private
		 */
		private var _gesturePanSignal : Signal;
		
		/**
		 * @private
		 */
		private var _gestureRotateSignal : Signal;
		
		/**
		 * @private
		 */
		private var _gestureSwipeSignal : Signal;
		
		/**
		 * @private
		 */
		private var _gestureZoomSignal : Signal;

		/**
		 * @inheritDoc
		 */
		public function get focusInSignal() : ISignal
		{
			if(null == _focusInSignal) 
				_focusInSignal = new Signal(ISignalTarget, ISignalTarget);
			return _focusInSignal;
		}
		
		/**
		 * @private
		 */
		public function get isFocusInSignalActive() : Boolean
		{
			return null != _focusInSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get focusOutSignal() : ISignal
		{
			if(null == _focusOutSignal) 
				_focusOutSignal = new Signal(ISignalTarget);
			return _focusOutSignal;
		}
		
		/**
		 * @private
		 */
		public function get isFocusOutSignalActive() : Boolean
		{
			return null != _focusOutSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseDownSignal() : ISignal
		{
			if(null == _mouseDownSignal) 
				_mouseDownSignal = new Signal(ISignalTarget, Point);
			return _mouseDownSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseDownSignalActive() : Boolean
		{
			return null != _mouseDownSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseMoveSignal() : ISignal
		{
			if(null == _mouseMoveSignal) 
				_mouseMoveSignal = new Signal(ISignalTarget, Point, Boolean);
			return _mouseMoveSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseMoveSignalActive() : Boolean
		{
			return null != _mouseMoveSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseUpSignal() : ISignal
		{
			if(null == _mouseUpSignal)
				_mouseUpSignal = new Signal(ISignalTarget, Point);
			return _mouseUpSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseUpSignalActive() : Boolean
		{
			return null != _mouseUpSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseClickSignal() : ISignal
		{
			if(null == _mouseClickSignal)
				_mouseClickSignal = new Signal(ISignalTarget, Point);
			return _mouseClickSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseClickSignalActive() : Boolean
		{
			return null != _mouseClickSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseWheelSignal() : ISignal
		{
			if(null == _mouseWheelSignal)
				_mouseWheelSignal = new Signal(ISignalTarget, Point, Number, Boolean);
			return _mouseWheelSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseWheelSignalActive() : Boolean
		{
			return null != _mouseWheelSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseDragOutSignal() : ISignal
		{
			if(null == _mouseDragOutSignal)
				_mouseDragOutSignal = new Signal(ISignalTarget, Point);
			return _mouseDragOutSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseDragOutSignalActive() : Boolean
		{
			return null != _mouseDragOutSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseDragInSignal() : ISignal
		{
			if(null == _mouseDragInSignal)
				_mouseDragInSignal = new Signal(ISignalTarget, Point);
			return _mouseDragInSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseDragInSignalActive() : Boolean
		{
			return null != _mouseDragInSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseOutSignal() : ISignal
		{
			if(null == _mouseOutSignal)
				_mouseOutSignal = new Signal(ISignalTarget, Point);
			return _mouseOutSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseOutSignalActive() : Boolean
		{
			return null != _mouseOutSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get mouseInSignal() : ISignal
		{
			if(null == _mouseInSignal)
				_mouseInSignal = new Signal(ISignalTarget, Point);
			return _mouseInSignal;
		}
		
		/**
		 * @private
		 */
		public function get isMouseInSignalActive() : Boolean
		{
			return null != _mouseInSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get keyDownSignal() : ISignal
		{
			if(null == _keyDownSignal)
				_keyDownSignal = new Signal(ISignalTarget, KeyboardEvent);
			return _keyDownSignal;
		}
		
		/**
		 * @private
		 */
		public function get isKeyDownSignalActive() : Boolean
		{
			return null != _keyDownSignal;
		}

		/**
		 * @inheritDoc
		 */
		public function get keyUpSignal() : ISignal
		{
			if(null == _keyUpSignal)
				_keyUpSignal = new Signal(ISignalTarget, KeyboardEvent);
			return _keyUpSignal;
		}
		
		/**
		 * @private
		 */
		public function get isKeyUpSignalActive() : Boolean
		{
			return null != _keyUpSignal;
		}
		
		/**
		 * @private
		 */
		public function get gesturePanSignal() : ISignal
		{
			if(null == _gesturePanSignal)
				_gesturePanSignal = new Signal();
			return _gesturePanSignal;
		}
		
		/**
		 * @private
		 */
		public function isGesturePanSignalActive() : Boolean
		{
			return null != _gesturePanSignal;
		}
		
		/**
		 * @private
		 */
		public function get gestureRotateSignal() : ISignal
		{
			if(null == _gestureRotateSignal)
				_gestureRotateSignal = new Signal();
			return _gestureRotateSignal;
		}
		
		/**
		 * @private
		 */
		public function isGestureRotateSignalActive() : Boolean
		{
			return null != _gestureRotateSignal;
		}
		
		/**
		 * @private
		 */
		public function get gestureSwipeSignal() : ISignal
		{
			if(null == _gestureSwipeSignal)
				_gestureSwipeSignal = new Signal();
			return _gestureSwipeSignal;
		}
		
		/**
		 * @private
		 */
		public function isGestureSwipeSignalActive() : Boolean
		{
			return null != _gestureSwipeSignal;
		}
		
		/**
		 * @private
		 */
		public function get gestureZoomSignal() : ISignal
		{
			if(null == _gestureZoomSignal)
				_gestureZoomSignal = new Signal();
			return _gestureZoomSignal;
		}
		
		/**
		 * @private
		 */
		public function isGestureZoomSignalActive() : Boolean
		{
			return null != _gestureZoomSignal;
		}
	}
}
