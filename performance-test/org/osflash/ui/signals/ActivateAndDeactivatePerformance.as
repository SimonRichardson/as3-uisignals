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
			document = new UIDocument(stage);
			
			for(var i : int = 0; i<10; i++)
			{
				const circle : Circle = new Circle();
				circle.signals.mouseClickSignal.add(handleMouseClickSignal);
				
				const radius : int = circle.radius;
				const diameter : int = radius * 2;
				
				circle.x = (Math.random() * (800 - diameter));
				circle.y = (Math.random() * (800 - diameter));
				
				document.add(circle);
			}
		}
		
		private function handleMouseClickSignal(target : ISignalTarget, mousePos : Point) : void
		{
			trace('Target:' + target + ' at position :' + mousePos);
		}
	}
}
