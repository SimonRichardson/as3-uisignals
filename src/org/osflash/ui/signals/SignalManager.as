package org.osflash.ui.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.ui.utils.SignalManagerFrameRate;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public final class SignalManager implements ISignalManager
	{
		
		/**
		 * @private
		 */
		private var _focus : ISignalTarget;
		
		/**
		 * @private
		 */
		private var _lastTarget : ISignalTarget;
		
		/**
		 * @private
		 */
		private var _hoverTarget : ISignalTarget;
		
		/**
		 * @private
		 */
		private var _root : ISignalRoot;
		
		/**
		 * @private
		 */
		private var _stage : Stage;
		
		/**
		 * @private
		 */
		private var _enabled : Boolean;
		
		/**
		 * @private
		 */
		private var _frameRate : SignalManagerFrameRate;
		
		/**
		 * @private
		 */
		private var _mouseDown : Boolean;
		
		/**
		 * @private
		 */
		private var _mousePos : Point;
		
		/**
		 * @private
		 */
		private var _mouseUpPos : Point;
		
		/**
		 * @private
		 */
		private var _mouseLastPos : Point;
				
		/**
		 * @private
		 */
		private var _mouseDownPos : Point;
		
		/**
		 * @private
		 */
		private var _nativeActivateSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeDeactivateSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeEnterFrameSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeMouseDownSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeMouseMoveSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeMouseUpSignal : ISignal;

		/**
		 * SignalManager Constructor.
		 * @param root ISignalRoot need to manage all the different elements.
		 */
		public function SignalManager(root : ISignalRoot)
		{
			if(null == root) throw new ArgumentError('Given root can not be null');
			if(null == root.stage) throw new ArgumentError('Given root.stage can not be null');
			
			_root = root;
			_stage = root.stage;
			
			_stage.stageFocusRect = false;
			
			_mousePos = new Point();
			_mouseUpPos = new Point();
			_mouseLastPos = new Point();
			_mouseDownPos = new Point();
			
			_frameRate = new SignalManagerFrameRate();
			
			_nativeActivateSignal = new NativeSignal(_stage, Event.ACTIVATE);
			_nativeActivateSignal.add(handleActiveSignal);
			
			_nativeDeactivateSignal = new NativeSignal(_stage, Event.DEACTIVATE);
			_nativeEnterFrameSignal = new NativeSignal(_stage, Event.ENTER_FRAME);
			
			_nativeMouseDownSignal = new NativeSignal(_stage, MouseEvent.MOUSE_DOWN, MouseEvent);
			_nativeMouseMoveSignal = new NativeSignal(_stage, MouseEvent.MOUSE_MOVE, MouseEvent);
			_nativeMouseUpSignal = new NativeSignal(_stage, MouseEvent.MOUSE_UP, MouseEvent);
		}
		
		/**
		 * @inheritDoc
		 */
		public function reset() : void
		{
			_focus = null;
		}
		
		/**
		 * @private
		 */
		private function getTarget(point : Point) : ISignalTarget
		{
			var currentTarget : ISignalTarget = _root;
			var lastTarget : ISignalTarget = null;
			
			while(currentTarget != lastTarget)
			{
				lastTarget = currentTarget;
				currentTarget = currentTarget.captureTarget(point);
				
				if(null == currentTarget) return lastTarget;
			}
			
			return currentTarget;
		}
		
		/**
		 * @private
		 */
		private function setFocus(child : ISignalTarget) : void
		{
			if ( null == _stage.focus || !( _stage.focus is TextField ) )
				_stage.focus = _root.displayObjectContainer;
			
			if(_focus == child)	return;
			
			var target : ISignalTarget;
			if(null != _focus)
			{
				target = _focus;
				// TODO : Dispatch focusOutSignal
			}
			
			if(null == child)
				_focus = null;
			else
			{
				//const focusOut : ISignalTarget = _focus;
				//const focusIn : ISignalTarget = child;
				
				_focus = child;
				// TODO : Dispatch focusInSignal
			}
		}
		
		/**
		 * @private
		 */
		private function handleActiveSignal(event : Event) : void
		{
			_enabled = true;
			
			_stage.frameRate = _frameRate.max;
			
			_nativeDeactivateSignal.add(handleDeactivateSignal);
			_nativeEnterFrameSignal.add(handleEnterFrameSignal);
			_nativeMouseDownSignal.add(handleMouseDownSignal);
			_nativeMouseMoveSignal.add(handleMouseMoveSignal);
			_nativeMouseUpSignal.add(handleMouseUpSignal);
		}
		
		/**
		 * @private
		 */
		private function handleDeactivateSignal(event : Event) : void
		{
			_enabled = false;
			
			_stage.frameRate = _frameRate.min;
			
			_nativeMouseDownSignal.remove(handleMouseDownSignal);
			_nativeMouseMoveSignal.remove(handleMouseMoveSignal);
			_nativeMouseUpSignal.remove(handleMouseUpSignal);
		}
		
		/**
		 * @private
		 */
		private function handleEnterFrameSignal(event : Event) : void
		{
			handleMouseMove();
		}
		
		/**
		 * @private
		 */
		private function handleMouseDownSignal(event : MouseEvent) : void
		{
			if(_mouseDown)
			{
				// TODO : Warn about an invalid sequence here.
				
				handleMouseUpSignal(null);
			}
			
			_mouseDown = true;
			
			_mousePos.x = (null == event ? _stage.mouseX : event.stageX);
			_mousePos.y = (null == event ? _stage.mouseY : event.stageY);
			
			_mouseDownPos.x = _mousePos.x;
			_mouseDownPos.y = _mousePos.y; 
			
			const currentTarget : ISignalTarget = getTarget(_mousePos);
			if(null != currentTarget)
			{
				setFocus(currentTarget);
				
				// TODO : Dispatch mouseDownSignal
			}
		}
		
		/**
		 * @private
		 */
		private function handleMouseMoveSignal(event : MouseEvent) : void
		{
			_mousePos.x = (null == event ? _stage.mouseX : event.stageX);
			_mousePos.y = (null == event ? _stage.mouseY : event.stageY);
			
			handleMouseMove();
		}
		
		/**
		 * @private
		 */
		private function handleMouseMove() : void
		{
			const currentChild : ISignalTarget = _mouseDown ? _lastTarget : getTarget(_mousePos);
			_hoverTarget = currentChild;

			//handleHovering(currentChild);
			//handleDragInOut();

			if (_mouseLastPos.x != _mousePos.x || _mouseLastPos.y != _mousePos.y)
			{
				// TODO : dispatch mouseMoveSignal

				_mouseLastPos.x = _mousePos.x;
				_mouseLastPos.y = _mousePos.y;
			}
		}
		
		/**
		 * @private
		 */
		private function handleMouseUpSignal(event : MouseEvent) : void
		{
			_mouseDown = false;
			
			_mousePos.x = (null == event ? _stage.mouseX : event.stageX);
			_mousePos.y = (null == event ? _stage.mouseY : event.stageY);
			
			_mouseUpPos.x = _mousePos.x;
			_mouseUpPos.y = _mousePos.y;
			
			var currentChild : ISignalTarget = _lastTarget;
			if(null != currentChild)
			{
				// TODO : dispatch mouseUpSignal
				
				if(getTarget(_mousePos) == currentChild)
				{
					// TODO : dispatch mouseClickSignal
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focus() : ISignalTarget { return _focus; }
		public function set focus(value : ISignalTarget) : void	{ _focus = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get root() : ISignalRoot { return _root; }
		
		/**
		 * @inheritDoc
		 */
		public function get enabled() : Boolean { return _enabled; }
		
		/**
		 * @inheritDoc
		 */
		public function get frameRate() : SignalManagerFrameRate { return _frameRate; }
	}
}
