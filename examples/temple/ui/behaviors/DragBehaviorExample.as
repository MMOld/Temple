/**
 * @exampleText
 * 
 * <p>This is an example about how to implement the DragBehavior.</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/DragBehaviorExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/ui/behaviors/DragBehaviorExample.swf</a></p>
 */
package  
{
	import temple.ui.behaviors.DragBehavior;
	import temple.core.CoreSprite;

	import flash.display.Sprite;

	public class DragBehaviorExample extends CoreSprite 
	{
		public function DragBehaviorExample()
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
			
			// add DragBehavior to make te sprite draggable
			new DragBehavior(sprite);
		}
	}
}
