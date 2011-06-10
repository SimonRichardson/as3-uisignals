package org.osflash.ui.display
{
	import flash.display.Graphics;
	import flash.display.Shape;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIShape extends UIDisplayObject
	{
		
		/**
		 * @private
		 */
		private var _graphics : Graphics;
		
		public function UIShape()
		{
			const shape : Shape = new Shape();
			_graphics = shape.graphics;
			
			super(shape);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get graphics() : Graphics { return _graphics; }
	}
}
