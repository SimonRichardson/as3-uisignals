package org.osflash.ui.display
{
	import org.osflash.dom.element.DOMDocument;
	import org.osflash.dom.element.IDOMNode;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class UIDocument extends DOMDocument
	{
		
		/**
		 * @private
		 */
		private var _stage : Stage;
		
		public function UIDocument(stage : Stage)
		{
			super();
			
			if(null == stage)
				throw new ArgumentError('Given value can not be null');
			
			_stage = stage;
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
		public function get stage() : Stage { return _stage; }
	}
}
