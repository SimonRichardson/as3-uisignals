package org.osflash.ui.display
{
	import org.osflash.dom.dom_namespace;
	import org.osflash.dom.element.DOMDocument;
	import org.osflash.dom.element.IDOMNode;
	import org.osflash.ui.display.grid.ISpatialGrid;
	import org.osflash.ui.display.grid.QuadTree;
	import org.osflash.ui.signals.ISignalManager;
	import org.osflash.ui.signals.ISignalRoot;
	import org.osflash.ui.signals.ISignalTarget;
	import org.osflash.ui.signals.SignalManager;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
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
		private var _container : Sprite;
		
		/**
		 * @private
		 */
		private var _signalManager : ISignalManager;
		
		/**
		 * @private
		 */
		private var _grid : ISpatialGrid;
				
		public function UIDocument(stage : Stage, useGrid : Boolean = true)
		{
			super();
			
			if(null == stage)
				throw new ArgumentError('Given value can not be null');
			
			_stage = stage;
			
			_container = new Sprite();
			_stage.addChild(_container);
			
			_signalManager = new SignalManager(this);
			
			if(useGrid)	_grid = new QuadTree(stage.stageWidth, stage.stageHeight);
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
				
				if(!_container.contains(displayObject))
					_container.addChild(displayObject);
				
				if(null != _grid) _grid.add(uiDisplayObject);
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
				
				if(_container.contains(displayObject))
					_container.removeChild(displayObject);
				
				if(null != _grid) _grid.remove(uiDisplayObject);
			}
			
			return domNode;
		}
		
		/**
		 * @inheritDoc
		 */
		public function captureTarget(point : Point) : ISignalTarget
		{
			var index : int;
			var target : ISignalTarget;
			
			if(null != _grid)
			{
				// Implement a very simple static grid algorithm here!
				_grid.integrate();
				const targets : Vector.<ISignalTarget> = _grid.getItemsUnderPoint(point);
				if(null != targets)
				{
					index = targets.length;
					while(--index > -1)
					{
						const signalTarget : ISignalTarget = targets[index];
						target = signalTarget.captureTarget(point);
						if(null != target) return target;
					}			
				}
			}
			else
			{
				use namespace dom_namespace;
				const elements : Vector.<IDOMNode> = children;
				if(null != elements)
				{
					index = elements.length;
					while(--index > -1)
					{
						const element : IDOMNode = elements[index];
						if(element is ISignalTarget)
						{
							target = ISignalTarget(element).captureTarget(point);
							if(null != target) return target;
						}
					}
				}
			}
			
			return this;
		}
								
		/**
		 * @inheritDoc
		 */
		public function get stage() : Stage { return _stage; }
		
		/**
		 * @inheritDoc
		 */
		public function get displayObjectContainer() : DisplayObjectContainer { return _container; }
		
		/**
		 * @inheritDoc
		 */
		public function get signalManager() : ISignalManager { return _signalManager; }
		
		/**
		 * @private
		 */
		public function get signalParent() : ISignalTarget { return null; }
		
		/**
		 * @private
		 */
		public function get signalFlags() : int { return 0; }
	}
}
