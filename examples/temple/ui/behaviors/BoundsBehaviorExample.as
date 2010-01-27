/**
 * @exampleText
 * 
 * <p>This is an example about how to the BoundsBehavior works.</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/BoundsBehaviorExample.swf</a></p>
 */
package  
{
	import flash.geom.Rectangle;
	import temple.ui.behaviors.DragBehavior;
	import temple.core.CoreSprite;

	import flash.display.Sprite;

	public class BoundsBehaviorExample extends CoreSprite 
	{
		public function BoundsBehaviorExample()
		{
			super();
			
			// Create a new Sprite
			var sprite:Sprite = new Sprite();
			
			// Draw a rectangle so we can see something
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawRect(0, 0, 50, 50);
			sprite.graphics.endFill();
			
			// add to stage
			this.addChild(sprite);
			
			// add DragBehavior with bounds to make te sprite draggable within the bounds
			new DragBehavior(sprite, new Rectangle(100, 100, 200, 200));
		}
	}
}
