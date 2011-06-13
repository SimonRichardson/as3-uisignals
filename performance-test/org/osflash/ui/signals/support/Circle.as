package org.osflash.ui.signals.support
{
	import org.osflash.ui.signals.ISignalTarget;

	import flash.geom.Point;
	import org.osflash.ui.display.UIShape;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class Circle extends UIShape
	{
		
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
		
		public function Circle()
		{
			_radius = (Math.random() * 50) + 50;
			_colour = Math.random() * 0xff;
			
			_position = new Point();
			
			graphics.beginFill(_colour, 0.2);
			graphics.lineStyle(1, 0x0099ff, 0.2);
			graphics.drawCircle(_radius, _radius, _radius);
			graphics.endFill();
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function captureTarget(point : Point) : ISignalTarget
		{
			if(!displayObject.visible) return null;
						
			const local : Point = displayObject.globalToLocal(point);
			const dx : Number = local.x - _position.x;
			const dy : Number = local.y - _position.y;
			const distance : Number = Math.sqrt((dx * dx) + (dy * dy));
			
			graphics.clear();
			graphics.beginFill(_colour, 0.2);
			graphics.lineStyle(1, 0x0000ff, 0.2);
			graphics.drawCircle(_radius, _radius, _radius);
			graphics.endFill();
			
			const inside : Boolean = (distance <= _radius);
			graphics.lineStyle(inside ? 2 : 1, inside ? 0x0099ff : 0xff00ff, inside ? 1 : 0.3);
			graphics.moveTo(_position.x, _position.y);
			graphics.lineTo(local.x, local.y);
			
			if(distance <= _radius) return this;
			
			return null;
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
