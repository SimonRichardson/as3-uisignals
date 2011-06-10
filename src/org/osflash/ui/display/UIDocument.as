package org.osflash.ui.display
{
	import org.osflash.dom.element.DOMDocument;
	import org.osflash.dom.element.IDOMNode;
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
