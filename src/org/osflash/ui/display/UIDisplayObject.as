package org.osflash.ui.display
{
	import flash.display.DisplayObject;
	import org.osflash.dom.element.DOMNode;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIDisplayObject extends DOMNode
	{
		
		/**
		 * @private
		 */
		private var _displayObject : DisplayObject;
		
		/**
		 * Construtor for the UIDisplayObject
		 * 
		 * @param displayObject DisplayObject to encapsulate
		 */
		public function UIDisplayObject(displayObject : DisplayObject)
		{
			super(displayObject.name);
			
			_displayObject = displayObject;
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
			
			_displayObject.name = super.name;
		}
	}
}
