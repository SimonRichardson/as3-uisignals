package org.osflash.ui.display
{
	import org.osflash.dom.dom_namespace;
	import org.osflash.dom.element.IDOMNode;
	import org.osflash.ui.display.base.ISignalDisplay;
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
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
		override public function captureTarget(point : Point) : ISignalTarget
		{
			if(!_displayObjectContainer.visible) return null;
			
			if(hasScrollRect)
			{
				scrollRect.x = x;
				scrollRect.y = y;
				
				if(null != _displayObjectContainer.parent)
				{
					const local : Point = _displayObjectContainer.parent.globalToLocal(point);
					if(!scrollRect.containsPoint(local))
						return null;
				}
			}

			const elements : Vector.<IDOMNode> = dom_namespace::children;
			
			var target : ISignalTarget;
			var index : int = elements.length;
			while(--index > -1)
			{
				const element : IDOMNode = elements[index];
				if(element is ISignalTarget)
				{
					target = ISignalTarget(element).captureTarget(point);
					if(null != target) return target;
				}
				else if(element is UIDisplayObjectContainer)
				{
					const container : UIDisplayObjectContainer = UIDisplayObjectContainer(element);
					const display : DisplayObjectContainer = container.displayObjectContainer;
					if(display.visible)
					{
						target = captureRecursive(display, point);
						if(null != target) return target;
					}
				}
			}
			
			return hitAreaContainsPoint(point) ? this : null;
		}
		
		/**
		 * @private
		 */
		private function captureRecursive(	container : DisplayObjectContainer, 
											point : Point
											) : ISignalTarget
		{

			var childContainer : DisplayObjectContainer;
			var target : ISignalTarget;

			var index : int = container.numChildren;
			while(--index > -1)
			{
				const child : DisplayObject = container.getChildAt(index);
				if(child is ISignalDisplay)
				{
					const signal : ISignalDisplay = ISignalDisplay(child);
					target = signal.target.captureTarget(point);
					if(null != target) return target;
				}
				else if(child is DisplayObjectContainer)
				{
					childContainer = DisplayObjectContainer(child);

					if(childContainer.visible)
					{
						target = captureRecursive(childContainer, point);
						if(null != target) return target;
					}
				}
			}

			return null;
		}
				
		/**
		 * @inheritDoc
		 */
		public function get displayObjectContainer() : DisplayObjectContainer
		{
			return _displayObjectContainer;
		}
	}
}
