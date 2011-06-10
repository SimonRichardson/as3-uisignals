package org.osflash.ui.display
{
	import org.osflash.dom.element.IDOMNode;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIDisplayObjectContainer extends UIDisplayObject
	{
		
		/**
		 * @private
		 */
		private var _displayObjectContainer : DisplayObjectContainer;
		
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
		public function UIDisplayObjectContainer(displayObject : DisplayObject)
		{
			super(displayObject);
			
			if(!(displayObject is DisplayObjectContainer))
				throw new ArgumentError('Given value must extend DisplayObjectContainer');
			else
			{
				_hasScrollRect = false;
				_displayObjectContainer = DisplayObjectContainer(displayObject);
			}
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function addAt(node : IDOMNode, index : int) : IDOMNode
		{
			const domNode : IDOMNode = super.addAt(node, index);
			
			if(domNode is UIDisplayObject)
			{
				const uiDisplayObject : UIDisplayObject = UIDisplayObject(domNode);
				const displayObject : DisplayObject = uiDisplayObject.displayObject;
				if(null == displayObject)
					throw new ArgumentError('UIDisplayObject displayObject can not be null');
				
				if(!_displayObjectContainer.contains(displayObject))
					_displayObjectContainer.addChild(displayObject);
			}
			
			return domNode;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAt(index : int) : IDOMNode
		{
			const domNode : IDOMNode = super.removeAt(index);
			
			if(domNode is UIDisplayObject)
			{
				const uiDisplayObject : UIDisplayObject = UIDisplayObject(domNode);
				const displayObject : DisplayObject = uiDisplayObject.displayObject;
				if(null == displayObject)
					throw new ArgumentError('UIDisplayObject displayObject can not be null');
				
				if(_displayObjectContainer.contains(displayObject))
					_displayObjectContainer.removeChild(displayObject);
			}
			
			return domNode;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get displayObjectContainer() : DisplayObjectContainer
		{
			return _displayObjectContainer;
		}
		
		/**
		 * Get the scrollRect
		 * @see flash.display.DisplayObjectContainer#scrollRect
		 */
		public function get scrollRect() : Rectangle { return _displayObjectContainer.scrollRect; }
		public function set scrollRect(value : Rectangle) : void
		{
			_displayObjectContainer.scrollRect = value;
			
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
