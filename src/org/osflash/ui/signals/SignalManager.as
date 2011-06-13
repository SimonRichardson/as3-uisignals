package org.osflash.ui.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.natives.NativeSignal;
	import org.osflash.ui.utils.SignalManagerFrameRate;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public final class SignalManager implements ISignalManager
	{
		
		private const REPEAT_THRESHOLD : int = 500;

		private const REPEAT_TIMEOUT : int = 125;
		
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
		private var _hoverTargets : Vector.<ISignalTarget>;
		
		/**
		 * @private
		 */
		private var _hoverTargetIndexs : Vector.<int>;
		
		/**
		 * @private
		 */
		private var _dragTargets : Vector.<ISignalTarget>;
		
		/**
		 * @private
		 */
		private var _dragTargetIndexs : Vector.<int>;
		
		/**
		 * @private
		 */
		private var _repeatThreshold : Timer;
		
		/**
		 * @private
		 */
		private var _repeatTimeout : Timer;
		
		/**
		 * @private
		 */
		private var _repeatCount : int;
		
		/**
		 * @private
		 */
		private var _keyTable : Vector.<Boolean>;
		
		/**
		 * @private
		 */
		private var _keyDown : Boolean;
		
		/**
		 * @private
		 */
		private var _keyDownSpace : Boolean;
		
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
		 * @private
		 */
		private var _nativeMouseLeaveSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeMouseWheelSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeRepeatThresholdSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeRepeatTimeoutSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeKeyDownSignal : ISignal;
		
		/**
		 * @private
		 */
		private var _nativeKeyUpSignal : ISignal;

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
			
			_hoverTargets = new Vector.<ISignalTarget>();
			_hoverTargetIndexs = new Vector.<int>();
			
			_dragTargets = new Vector.<ISignalTarget>();
			_dragTargetIndexs = new Vector.<int>();
			
			_frameRate = new SignalManagerFrameRate();
			
			_nativeActivateSignal = new NativeSignal(_stage, Event.ACTIVATE);
			_nativeActivateSignal.add(handleActiveSignal);
			
			_nativeDeactivateSignal = new NativeSignal(_stage, Event.DEACTIVATE);
			_nativeEnterFrameSignal = new NativeSignal(_stage, Event.ENTER_FRAME);
			
			_nativeMouseDownSignal = new NativeSignal(_stage, MouseEvent.MOUSE_DOWN, MouseEvent);
			_nativeMouseMoveSignal = new NativeSignal(_stage, MouseEvent.MOUSE_MOVE, MouseEvent);
			_nativeMouseUpSignal = new NativeSignal(_stage, MouseEvent.MOUSE_UP, MouseEvent);
			_nativeMouseLeaveSignal = new NativeSignal(_stage, Event.MOUSE_LEAVE);
			_nativeMouseWheelSignal = new NativeSignal(_stage, MouseEvent.MOUSE_WHEEL, MouseEvent);
			
			_nativeKeyDownSignal = new NativeSignal(_stage, KeyboardEvent.KEY_DOWN, KeyboardEvent);
			_nativeKeyUpSignal = new NativeSignal(_stage, KeyboardEvent.KEY_UP, KeyboardEvent);
			
			_repeatCount = 0;
			
			_repeatThreshold = new Timer(REPEAT_THRESHOLD, 1);
			_nativeRepeatThresholdSignal = new NativeSignal(_repeatThreshold, TimerEvent.TIMER);
			
			_repeatTimeout = new Timer(REPEAT_TIMEOUT, 0);
			_nativeRepeatTimeoutSignal = new NativeSignal(_repeatThreshold, TimerEvent.TIMER);
			
			_keyTable = new Vector.<Boolean>();
			for (var i : int = 0;i < 0x100; i++)
			{
				_keyTable[i] = false;
			}
			_keyDown = false;
			_keyDownSpace = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function stealCapture(target : ISignalTarget) : void
		{
			_lastTarget = target;
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
				target.signals.focusOutSignal.dispatch(_focus, target);
			}
			
			if(null == child)
				_focus = null;
			else
			{
				const focusOut : ISignalTarget = _focus;
				const focusIn : ISignalTarget = child;
				
				_focus = child;
				_focus.signals.focusInSignal.dispatch(focusOut, focusIn);
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
			_nativeMouseLeaveSignal.add(handleMouseLeaveSignal);
			_nativeMouseWheelSignal.add(handleMouseWheelSignal);
			
			_nativeKeyDownSignal.add(handleKeyDownSignal);
			_nativeKeyUpSignal.add(handleKeyUpSignal);
			
			_nativeRepeatThresholdSignal.add(handleRepeatThresholdSignal);
			_nativeRepeatTimeoutSignal.add(handleRepeatTimeoutSignal);
		}
		
		/**
		 * @private
		 */
		private function handleDeactivateSignal(event : Event) : void
		{
			_enabled = false;
			
			_stage.frameRate = _frameRate.min;
			
			_nativeEnterFrameSignal.remove(handleEnterFrameSignal);
			_nativeMouseDownSignal.remove(handleMouseDownSignal);
			_nativeMouseMoveSignal.remove(handleMouseMoveSignal);
			_nativeMouseUpSignal.remove(handleMouseUpSignal);
			_nativeMouseLeaveSignal.remove(handleMouseLeaveSignal);
			_nativeMouseWheelSignal.remove(handleMouseWheelSignal);
			
			_nativeKeyDownSignal.remove(handleKeyDownSignal);
			_nativeKeyUpSignal.remove(handleKeyUpSignal);
			
			_nativeRepeatThresholdSignal.remove(handleRepeatThresholdSignal);
			_nativeRepeatTimeoutSignal.remove(handleRepeatTimeoutSignal);
			
			if(_mouseDown) handleMouseUpSignal(null);
			if(_keyDown) handleKeyDownSignal(null);
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
				
				currentTarget.signals.mouseDownSignal.dispatch(currentTarget, _mouseDownPos);
				
				if((currentTarget.signalFlags & SignalFlags.REPEAT_MOUSE_DOWN) != 0)
				{
					_repeatThreshold.reset();
					_repeatThreshold.start();
				}
			}
			
			_lastTarget = currentTarget;
			
			// TODO : log out a target here!
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
			const currentTarget : ISignalTarget = _mouseDown ? _lastTarget : getTarget(_mousePos);
			_hoverTarget = currentTarget;

			handleHovering(currentTarget);
			handleDragInOut();

			if (_mouseLastPos.x != _mousePos.x || _mouseLastPos.y != _mousePos.y)
			{
				currentTarget.signals.mouseMoveSignal.dispatch(currentTarget, _mouseDownPos, _mouseDown);

				_mouseLastPos.x = _mousePos.x;
				_mouseLastPos.y = _mousePos.y;
			}
		}
		
		/**
		 * @private
		 */
		private function handleMouseUpSignal(event : MouseEvent) : void
		{
			if(_repeatThreshold.running) _repeatThreshold.reset();
			if(_repeatTimeout.running) _repeatTimeout.reset();
			
			_mouseDown = false;
			
			_mousePos.x = (null == event ? _stage.mouseX : event.stageX);
			_mousePos.y = (null == event ? _stage.mouseY : event.stageY);
			
			_mouseUpPos.x = _mousePos.x;
			_mouseUpPos.y = _mousePos.y;
			
			const total : int = _dragTargets.length;
			for(var i : int = 0; i < total; i++)
			{
				const target : ISignalTarget = _dragTargets[i];
				target.signals.mouseDragOutSignal.dispatch(target, _mousePos, _mouseDown);
			}
			
			const currentTarget : ISignalTarget = _lastTarget;
			if(null != currentTarget)
			{
				currentTarget.signals.mouseUpSignal.dispatch(currentTarget, _mouseUpPos);
				
				if((currentTarget.signalFlags & SignalFlags.RECEIVE_CLICK_EVENTS) != 0)
				{
					if(getTarget(_mousePos) == currentTarget)
					{
						currentTarget.signals.mouseClickSignal.dispatch(	currentTarget, 
																			_mouseDownPos
																			);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function handleMouseLeaveSignal(event : Event) : void
		{
			if(_mouseDown) handleMouseUpSignal(null);
		}
		
		/**
		 * @private
		 */
		private function handleMouseWheelSignal(event : MouseEvent) : void
		{
			_hoverTarget.signals.mouseWheelSignal.dispatch(	_hoverTarget, 
															_mousePos, 
															event.delta, 
															_mouseDown
															);
		}
		
		/**
		 * @private
		 */
		private function handleRepeatThresholdSignal(event : Event) : void
		{
			_repeatCount = 0;
			
			_repeatTimeout.delay = REPEAT_TIMEOUT;
			
			_repeatTimeout.reset();
			_repeatTimeout.start();
		}
		
		/**
		 * @private
		 */
		private function handleRepeatTimeoutSignal(event : Event) : void
		{
			if(null == _lastTarget)
			{
				_repeatTimeout.reset();
				return;
			}
			
			_repeatCount++;
			
			if(0x10 == _repeatCount) _repeatTimeout.delay *= 0.5;
			if(0x20 == _repeatCount) _repeatTimeout.delay *= 0.5;
		
			_lastTarget.signals.mouseDownSignal.dispatch(_lastTarget, _mouseDownPos);
		}
		
		/**
		 * @private
		 */
		private function handleKeyDownSignal(event : KeyboardEvent) : void
		{
			if(null == event) event = new KeyboardEvent(KeyboardEvent.KEY_UP);
			
			_keyTable[int(event.keyCode & 0xff)] = true;
			
			_keyDown = true;
			_keyDownSpace = 0x20 == event.keyCode;
			
			if(null != _focus)
				_focus.signals.keyDownSignal.dispatch(_focus, event);
		}
		
		/**
		 * @private
		 */
		private function handleKeyUpSignal(event : KeyboardEvent) : void
		{
			_keyTable[int(event.keyCode & 0xff)] = false;
			
			_keyDown = false;
			_keyDownSpace = false;
			
			if(null != _focus)
				_focus.signals.keyUpSignal.dispatch(_focus, event);
		}
		
		/**
		 * @private
		 */
		private function handleHovering(currentTarget : ISignalTarget) : void
		{
			if(_mouseDown) return;
			
			var exists : Boolean = false;
			
			const total : int = _hoverTargets.length;
			for(var i : int = 0; i<total; i++)
			{
				const target : ISignalTarget = _hoverTargets[i];
				if(currentTarget != target)
				{
					var activeTarget : ISignalTarget = currentTarget;
					while(activeTarget != target)
					{
						if(null == activeTarget)
						{
							_hoverTargetIndexs.push(i);
							
							target.signals.mouseOutSignal.dispatch(target, _mousePos, _mouseDown);
							break;
						}
						
						activeTarget = activeTarget.signalParent;
					}
				}
				else exists = true;
			}
			
			if(!exists && null != currentTarget)
			{
				_hoverTargets.push(currentTarget);
				
				currentTarget.signals.mouseInSignal.dispatch(target, _mousePos, _mouseDown);
			}
			
			var index : int = _hoverTargetIndexs.length;
			while(--index > -1)
			{
				const id : int = _hoverTargetIndexs[index];
				if(id < 0 || id >= _hoverTargets.length) continue;
				_hoverTargets.splice(id, 1);
			}
		}
		
		/**
		 * @private
		 */
		private function handleDragInOut() : void
		{
			if(!_mouseDown) return;
			
			const currentTarget : ISignalTarget = getTarget(_mousePos);
			
			var exists : Boolean = false;
			
			const total : int = _dragTargets.length;
			for(var i : int = 0; i<total; i++)
			{
				const target : ISignalTarget = _dragTargets[i];
				if(currentTarget != target)
				{
					var activeTarget : ISignalTarget = currentTarget;
					while(activeTarget != target)
					{
						if(null == activeTarget)
						{
							_dragTargetIndexs.push(i);
							
							target.signals.mouseDragOutSignal.dispatch(	target, 
																		_mousePos, 
																		_mouseDown
																		);
							break;
						}
						
						activeTarget = activeTarget.signalParent;
					}
				}
				else exists = true;
			}
			
			
			if(!exists && null != currentTarget)
			{
				_dragTargets.push(currentTarget);
				
				if((currentTarget.signalFlags & SignalFlags.RECEIVE_DRAG_EVENTS) != 0)
				{
					_dragTargets.push(currentTarget);
					
					currentTarget.signals.mouseDragInSignal.dispatch(	currentTarget, 
																		_mousePos, 
																		_mouseDown
																		);
				}
			}
			
			var index : int = _dragTargetIndexs.length;
			while(--index > -1)
			{
				const id : int = _dragTargetIndexs[index];
				if(id < 0 || id >= _dragTargets.length) continue;
				_dragTargets.splice(id, 1);
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
