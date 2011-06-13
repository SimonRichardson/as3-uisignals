package org.osflash.ui.display
{
	import org.osflash.ui.display.base.SignalShape;

	import flash.display.Graphics;
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
			const shape : SignalShape = new SignalShape(this);
			_graphics = shape.graphics;
			
			super(shape);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get graphics() : Graphics { return _graphics; }
	}
}
