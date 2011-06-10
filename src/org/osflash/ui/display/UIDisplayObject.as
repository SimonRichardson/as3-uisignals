package org.osflash.ui.display
{
	import org.osflash.dom.element.DOMNode;
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIDisplayObject extends DOMNode implements ISignalTarget
	{
		
		/**
		 * @private
		 */
		private var _displayObject : DisplayObject;
		
		/**
		 * @private
		 */
		private var _hasScrollRect : Boolean;
		
		/**
		 * @private
		 */
		private var _scrollRect : Rectangle;
		
		/**
		 * Construtor for the UIDisplayObject
		 * 
		 * @param displayObject DisplayObject to encapsulate
		 */
		public function UIDisplayObject(displayObject : DisplayObject)
		{
			super(displayObject.name);
			
			_displayObject = displayObject;
			
			if(null != _displayObject.scrollRect) scrollRect = _displayObject.scrollRect;
		}
		
		/**
		 * @inheritDoc
		 */
		public function captureTarget(point : Point) : ISignalTarget
		{
			if(!_displayObject.visible) return null;
			
			if(_hasScrollRect)
			{
				_scrollRect.x = x;
				_scrollRect.y = y;
				
				if(null != _displayObject.parent)
				{
					if(!_scrollRect.containsPoint(_displayObject.parent.globalToLocal(point)))
						return null;
				}
			}
			
			return hitAreaContainsPoint(point) ? this : null;
		}
		
		/**
		 * Tests whether or not the given point is in the hitarea of the current
		 * object.
		 * 
		 * @param point The point to test in global coordinates.
		 * @return <code>true</code> if the point is inside the hit area; <code>false</code> otherwise.
		 */
		protected function hitAreaContainsPoint(point : Point) : Boolean
		{
			if(null == _displayObject.stage) return false;
			else return _displayObject.getRect(_displayObject.stage).containsPoint(point);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get displayObject() : DisplayObject
		{
			return _displayObject;
		}
				
		/**
		 * @inheritDoc
		 */
		public function get x() : int { return _displayObject.x; }
		public function set x(value : int) : void { _displayObject.x = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get y() : int { return _displayObject.y; }
		public function set y(value : int) : void { _displayObject.y = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get width() : int { return _displayObject.width; }
		public function set width(value : int) : void { _displayObject.width = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get height() : int { return _displayObject.height; }
		public function set height(value : int) : void { _displayObject.height = value; }
		
		/**
		 * @inheritDoc
		 */	
		override public function set name(value : String) : void
		{
			super.name = value;
			
			if(null != _displayObject)
				_displayObject.name = super.name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasScrollRect() : Boolean { return _hasScrollRect; }
		
		/**
		 * Get the scrollRect
		 * @see flash.display.DisplayObject#scrollRect
		 */
		public function get scrollRect() : Rectangle { return _displayObject.scrollRect; }
		public function set scrollRect(value : Rectangle) : void
		{
			_displayObject.scrollRect = value;
			
			if(null == value)
				_hasScrollRect = false;
			else
			{
				_hasScrollRect = true;
				
				if(null == _scrollRect)
					_scrollRect = new Rectangle();
				
				_scrollRect.width = value.width;
				_scrollRect.height = value.height;
			}
		}
	}
}
