package org.osflash.ui.display.grid
{
	import org.osflash.ui.display.UIDisplayObject;
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public class QuadTree implements ISpatialGrid
	{

		/**
		 * @private
		 */
		private var _nodes : Vector.<UIDisplayObject>;
		
		/**
		 * @private
		 */	
		private var _quad : QuadTreeQuadrant;
		
		/**
		 * @private
		 */
		private var _maxLevels : int = 4;
		
		public function QuadTree(width : int, height : int)
		{
			_nodes = new Vector.<UIDisplayObject>();
			
			_quad = new QuadTreeQuadrant(new Rectangle(0, 0, width, height), _maxLevels);
		}

		/**
		 * @inheritDoc
		 */
		public function add(node : UIDisplayObject) : UIDisplayObject
		{
			if (_nodes.indexOf(node) >= 0)
				throw new Error('ISignalTarget already exists');

			_nodes.push(node);

			return node;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(node : UIDisplayObject) : UIDisplayObject
		{
			const index : int = _nodes.indexOf(node);
			if (index == -1)
				throw new Error('No such ISignalTarget');
			
			const result : Vector.<UIDisplayObject> = _nodes.splice(index, 1);
			if(result.length == 0)
				throw new Error('Remove mismatch');
			
			const displayNode : UIDisplayObject = result[0];
			if(displayNode != node)
				throw new Error('Remove mismatch');
			
			return node;
		}

		/**
		 * @inheritDoc
		 */
		public function integrate() : void
		{
			_quad.clearAll();
			
			for each(var node : UIDisplayObject in _nodes)
			{
				_quad.insert(node);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemsUnderPoint(point : Point) : Vector.<ISignalTarget>
		{
			const quadrant : QuadTreeQuadrant = _quad.getQuadContainsPoint(point);
			if(null != quadrant) return quadrant.nodes;
			else return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function draw(graphics : Graphics, point : Point) : void
		{
			_quad.draw(graphics, point);
		}
				
		/**
		 * @inheritDoc
		 */
		public function get width() : Number { return _quad.width; }
		public function set width(value : Number) : void { _quad.width = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get height() : Number { return _quad.height; }
		public function set height(value : Number) : void { _quad.height = value; }
	}
}
