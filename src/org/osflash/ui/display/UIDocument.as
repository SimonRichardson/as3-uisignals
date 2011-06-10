package org.osflash.ui.display
{
	import org.osflash.dom.dom_namespace;
	import org.osflash.dom.element.DOMDocument;
	import org.osflash.dom.element.IDOMNode;
	import org.osflash.ui.display.base.ISignalDisplay;
	import org.osflash.ui.signals.ISignalManager;
	import org.osflash.ui.signals.ISignalRoot;
	import org.osflash.ui.signals.ISignalTarget;
	import org.osflash.ui.signals.SignalManager;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIDocument extends DOMDocument implements ISignalRoot
	{
		
		/**
		 * @private
		 */
		private var _stage : Stage;
		
		/**
		 * @private
		 */
		private var _signalManager : ISignalManager;
		
		public function UIDocument(stage : Stage)
		{
			super();
			
			if(null == stage)
				throw new ArgumentError('Given value can not be null');
			
			_stage = stage;
			_signalManager = new SignalManager(this);
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
				
				if(!_stage.contains(displayObject))
					_stage.addChild(displayObject);
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
				
				if(_stage.contains(displayObject))
					_stage.removeChild(displayObject);
			}
			
			return domNode;
		}
		
		/**
		 * @inheritDoc
		 */
		public function captureTarget(point : Point) : ISignalTarget
		{
			const elements : Vector.<IDOMNode> = dom_namespace::children;
			
			if(null == elements)
			{
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
						const container : UIDisplayObjectContainer = 
																UIDisplayObjectContainer(element);
						const display : DisplayObjectContainer = container.displayObjectContainer;
						if(display.visible)
						{
							target = captureRecursive(display, point);
							if(null != target) return target;
						}
					}
				}
			}
			
			return this;
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
		public function get stage() : Stage { return _stage; }
		
		/**
		 * @inheritDoc
		 */
		public function get displayObjectContainer() : DisplayObjectContainer { return _stage; }
		
		/**
		 * @inheritDoc
		 */
		public function get signalManager() : ISignalManager { return _signalManager; }
	}
}
