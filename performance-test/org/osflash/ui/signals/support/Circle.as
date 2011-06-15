package org.osflash.ui.signals.support
{
	import org.osflash.ui.display.UIShape;
	import org.osflash.ui.signals.ISignalTarget;

	import flash.geom.Point;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class Circle extends UIShape
	{
		public static const UP : int = 0xff00ff;
		
		public static const DOWN : int = 0x00ff00;
		
		public static const OVER : int = 0x00ffff; 
		
		
		/**
		 * @private
		 */
		private var _radius : int;
		
		/**
		 * @private
		 */
		private var _colour : int;
		
		/**
		 * @private
		 */
		private var _position : Point;
		
		public function Circle(radius : int)
		{
			_radius = radius;
			_colour = UP;
			
			_position = new Point();
			
			draw();
			
			signals.mouseDownSignal.add(handleMouseDownSignal);
			signals.mouseInSignal.add(handleMouseInSignal);
			signals.mouseOutSignal.add(handleMouseOutSignal);
			signals.mouseUpSignal.add(handleMouseUpSignal);
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function captureTarget(point : Point) : ISignalTarget
		{
			if(!displayObject.visible || !enabled) return null;
						
			const local : Point = displayObject.globalToLocal(point);
			const dx : Number = local.x - _position.x;
			const dy : Number = local.y - _position.y;
			const distance : Number = Math.sqrt((dx * dx) + (dy * dy));
			
			draw();
			
			const inside : Boolean = (distance <= _radius);
			graphics.lineStyle(inside ? 2 : 1, inside ? 0x0099ff : 0xff00ff, inside ? 1 : 0.3);
			graphics.moveTo(_position.x, _position.y);
			graphics.lineTo(local.x, local.y);
			
			return (distance <= _radius) ? this : null;
		}
		
		/**
		 * @private
		 */
		private function draw() : void
		{
			graphics.clear();
			graphics.beginFill(_colour, 0.1);
			graphics.lineStyle(1, _colour, 0.5);
			graphics.drawCircle(_radius, _radius, _radius);
			graphics.endFill();
		}
		
		/**
		 * @private
		 */
		private function handleMouseDownSignal(target : ISignalTarget, mousePos : Point) : void
		{
			_colour = DOWN;
			
			draw();
			
			target;
			mousePos;
		}
		
		/**
		 * @private
		 */
		private function handleMouseInSignal(	target : ISignalTarget, 
												mousePos : Point, 
												mouseDown : Boolean
												) : void
		{
			_colour = mouseDown ? DOWN : OVER;
			
			draw();
			
			target;
			mousePos;
		}
		
		/**
		 * @private
		 */
		private function handleMouseOutSignal(	target : ISignalTarget, 
												mousePos : Point, 
												mouseDown : Boolean
												) : void
		{
			_colour = mouseDown ? DOWN : UP;
			
			draw();
			
			target;
			mousePos;
		}
		
		/**
		 * @private
		 */
		private function handleMouseUpSignal(target : ISignalTarget, mousePos : Point) : void
		{
			_colour = UP;
			
			draw();	
			
			target;
			mousePos;
		}
		
		/**
		 * Get the radius
		 * @return int
		 */
		public function get radius() : int { return _radius; }
		
		/**
		 * @inheritDoc
		 */
		override public function set x(value : int) : void
		{
			super.x = value;
			
			_position.x = x + _radius;
			_position.y = y + _radius;
			
			_position = displayObject.globalToLocal(_position);
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function set y(value : int) : void
		{
			super.y = value;
			
			_position.x = x + _radius;
			_position.y = y + _radius;
			
			_position = displayObject.globalToLocal(_position);
		}
	}
}
