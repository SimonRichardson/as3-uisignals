package org.osflash.ui.display.grid
{
	import org.osflash.ui.display.UIDisplayObject;
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	public interface ISpatialGrid
	{
		
		function add(node : UIDisplayObject) : UIDisplayObject;
		
		function remove(node : UIDisplayObject) : UIDisplayObject;

		function integrate() : void;

		function getItemsUnderPoint(point : Point) : Vector.<ISignalTarget>;
		
		function draw(graphics : Graphics, point : Point) : void;
		
		function get width() : Number;
		function set width(value : Number) : void;
		
		function get height() : Number;
		function set height(value : Number) : void;
	}
}
