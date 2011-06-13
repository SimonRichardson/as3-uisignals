package org.osflash.ui.display.grid
{
	import org.osflash.ui.display.UIDisplayObject;
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class QuadTreeQuadrant
	{
		
		/**
		 * @private
		 */
		private var _rect : Rectangle;
		
		/**
		 * @private
		 */
		private var _level : int;
		
		/**
		 * @private
		 */
		private var _q0 : QuadTreeQuadrant;
		
		/**
		 * @private
		 */
		private var _q1 : QuadTreeQuadrant;
		
		/**
		 * @private
		 */
		private var _q2 : QuadTreeQuadrant;
		
		/**
		 * @private
		 */
		private var _q3 : QuadTreeQuadrant;
		
		/**
		 * @private
		 */
		private var _leaf : Boolean;
		
		/**
		 * @private
		 */
		private var _nodes : Vector.<ISignalTarget>;
		
		public function QuadTreeQuadrant(bounds : Rectangle, level : int)
		{
			_rect = bounds;
			_level = level;
			
			if(_level > 0)
			{
				_leaf = false;
				
				const quadLevel : int = _level - 1;
				
				const qw : Number = _rect.width * 0.5;
				const qh : Number = _rect.height * 0.5;
				
				const q0 : Rectangle = new Rectangle(_rect.x, 		_rect.y, 		qw, qh);
				const q1 : Rectangle = new Rectangle(_rect.x + qw, 	_rect.y, 		qw, qh);
				const q2 : Rectangle = new Rectangle(_rect.x, 		_rect.y + qh, 	qw, qh);
				const q3 : Rectangle = new Rectangle(_rect.x + qw, 	_rect.y + qh, 	qw, qh);
				
				_q0 = new QuadTreeQuadrant(q0, quadLevel);
				_q1 = new QuadTreeQuadrant(q1, quadLevel);
				_q2 = new QuadTreeQuadrant(q2, quadLevel);
				_q3 = new QuadTreeQuadrant(q3, quadLevel);
			}
			else
			{
				_leaf = true;
				_nodes = new Vector.<ISignalTarget>();
			}
		}
		
		public function insert(target : UIDisplayObject) : void
		{
			if(_leaf) 
			{
				if(_nodes.indexOf(target) == -1) 
					_nodes.push(target);
			}
			else
			{			
				if(_q0.rect.intersects(target.bounds))
					_q0.insert(target);
				
				if(_q1.rect.intersects(target.bounds))
					_q1.insert(target);
				
				if(_q2.rect.intersects(target.bounds))
					_q2.insert(target);
				
				if(_q3.rect.intersects(target.bounds))
					_q3.insert(target);
			}
		}
		
		public function clearAll() : void
		{
			if(_leaf) _nodes.length = 0;
			else
			{
				_q0.clearAll();
				_q1.clearAll();
				_q2.clearAll();
				_q3.clearAll();
			}
		}
		
		public function getQuadContainsPoint(point : Point) : QuadTreeQuadrant
		{
			if(_leaf) return _rect.containsPoint(point) ? this : null;
			else
			{
				if(_q0.rect.containsPoint(point))
					return _q0.getQuadContainsPoint(point);
				else if(_q1.rect.containsPoint(point))
					return _q1.getQuadContainsPoint(point);
				else if(_q2.rect.containsPoint(point))
					return _q2.getQuadContainsPoint(point);
				else if(_q3.rect.containsPoint(point))
					return _q3.getQuadContainsPoint(point);
			}
			
			return null;
		}
		
		public function draw(graphics : Graphics, point : Point) : void
		{
			if(_leaf) 
			{
				const contains : Boolean = _rect.containsPoint(point);
				if(contains) graphics.beginFill(0x00ee00, 0.3);
				
				graphics.lineStyle(1, 0x1d1d1d, 0.5);
				graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
				
				if(contains) graphics.endFill();
			}
			else
			{
				_q0.draw(graphics, point);
				_q1.draw(graphics, point);
				_q2.draw(graphics, point);
				_q3.draw(graphics, point);
			}
		}
		
		public function get x() : Number { return _rect.x; }
		public function set x(value : Number) : void 
		{ 
			if(_rect.x == value) return;
			
			_rect.x = value; 
		}
		
		public function get y() : Number { return _rect.y; }
		public function set y(value : Number) : void 
		{ 
			if(_rect.y == value) return;
			
			_rect.y = value; 
		}
		
		public function get width() : Number { return _rect.width; }
		public function set width(value : Number) : void
		{
			if(_rect.width == value) return;
			
			_rect.width = value;
			
			if(!_leaf)
			{
				const qw : Number = _rect.width * 0.5;
				
				_q0.width = qw;
				_q1.width = qw;
				_q2.width = qw;
				_q3.width = qw;
				
				_q1.x = qw;
				_q3.x = qw;
			} 
		}
		
		public function get height() : Number { return _rect.height; }
		public function set height(value : Number) : void
		{
			if(_rect.height == value) return;
			
			_rect.height = value;
			
			if(!_leaf)
			{
				const qh : Number = _rect.height * 0.5;
				
				_q0.height = qh;
				_q1.height = qh;
				_q2.height = qh;
				_q3.height = qh;
				
				_q2.y = qh;
				_q3.y = qh;
			} 
		}
		
		internal function get rect() : Rectangle { return _rect; }
		
		internal function get nodes() : Vector.<ISignalTarget> { return _nodes; }
	}
}
