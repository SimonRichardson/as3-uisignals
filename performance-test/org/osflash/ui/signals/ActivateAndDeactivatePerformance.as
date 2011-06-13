package org.osflash.ui.signals
{
	import org.osflash.ui.display.UIDocument;
	import org.osflash.ui.signals.support.Circle;

	import flash.display.Sprite;
	import flash.geom.Point;
	[SWF(backgroundColor="#FFFFFF", frameRate="60", width="800", height="800")]
	public class ActivateAndDeactivatePerformance extends Sprite
	{
		
		/**
		 * @private
		 */
		private var document : UIDocument;

		public function ActivateAndDeactivatePerformance()
		{
			document = new UIDocument(stage, true);
			document.signals.mouseDownSignal.add(handleMouseDownSignal);
			
			for(var i : int = 0; i<1000; i++)
			{
				const circle : Circle = new Circle();
				circle.signals.mouseDownSignal.add(handleMouseDownSignal);
				
				const radius : int = circle.radius;
				const diameter : int = radius * 2;
				
				circle.x = (Math.random() * (800 - diameter));
				circle.y = (Math.random() * (800 - diameter));
				
				document.add(circle);
			}
			
			document.invalidate();
		}
		
		private function handleMouseDownSignal(target : ISignalTarget, mousePos : Point) : void
		{
			trace('Target:' + target + ' at position :' + mousePos);
		}
	}
}
