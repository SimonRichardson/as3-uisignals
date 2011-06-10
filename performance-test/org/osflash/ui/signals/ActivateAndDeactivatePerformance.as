package org.osflash.ui.signals
{
	import org.osflash.ui.display.UIDocument;
	import org.osflash.ui.signals.support.Circle;

	import flash.display.Sprite;
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
			
			for(var i : int = 0; i<100; i++)
			{
				const circle : Circle = new Circle();
				
				const radius : int = circle.radius;
				const diameter : int = radius * 2;
				
				circle.x = (Math.random() * (800 - diameter)) + radius;
				circle.y = (Math.random() * (800 - diameter)) + radius;
				
				document.add(circle);
			}
		}
	}
}
