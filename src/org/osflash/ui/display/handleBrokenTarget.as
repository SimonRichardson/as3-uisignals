package org.osflash.ui.display
{
	import org.osflash.ui.signals.ISignalTarget;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	/**
	 * @author Simon Richardson - simon@ustwo.co.uk
	 */
	internal function handleBrokenTarget(target: ISignalTarget, displayObject: DisplayObject) : void
	{
		if(!(displayObject is Bitmap) && (displayObject.width > 0.0 && displayObject.height > 0.0))
		{
			try
			{
				var graphics: Graphics = Graphics( displayObject[ 'graphics' ] );
				
				graphics.lineStyle( 1.0, 0xff0000, 1.0 );
				
				graphics.drawRect( 0.0, 0.0, displayObject.width, displayObject.height );
				
				graphics.moveTo( 0.0, 0.0 );
				graphics.lineTo( displayObject.width, displayObject.height );
				
				graphics.moveTo( 0.0, displayObject.height );
				graphics.lineTo( displayObject.width, 0.0 );
			}
			catch( error: Error ) {}
		}
		
		displayObject.transform.colorTransform = new ColorTransform( 1.0, 0.25, 0.25, 1.0, 0x80 );
		
		return;
		
		throw new Error('IUISignalTarget object is broken. Probably it has been added to the ' + 
									'stage instead of UISignalManager.root.\nTarget: ' + target );
	}
}
