/**
 * @exampleText
 * 
 * <p>This is an example about how to use the KeyMapper</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/KeyMapperExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/KeyMapperExample.swf</a></p>
 */
package  
{
	import temple.core.CoreSprite;
	import temple.utils.KeyCode;
	import temple.utils.KeyMapper;

	/**
	 * @author Thijs Broerse
	 */
	public class KeyMapperExample extends CoreSprite 
	{
		private var _sprite:CoreSprite;
		
		public function KeyMapperExample()
		{
			super();
			
			// Create a new Sprite
			this._sprite = new CoreSprite();
			this._sprite.graphics.beginFill(0x000000);
			this._sprite.graphics.drawRect(0, 0, 20, 20);
			this._sprite.graphics.endFill();
			this.addChild(this._sprite);
			this._sprite.x = 200;
			this._sprite.y = 200;
			
			// Create a KeyMapper to control the Sprite with the keyboard 
			var keyMapper:KeyMapper = new KeyMapper(this.stage);
			
			// Use cursor keys to move left, right, up and down
			keyMapper.map(KeyCode.LEFT, this.moveLeft);
			keyMapper.map(KeyCode.RIGHT, this.moveRight);
			keyMapper.map(KeyCode.UP, this.moveUp);
			keyMapper.map(KeyCode.DOWN, this.moveDown);
			
			// use Shift key to move even faster
			keyMapper.map(KeyCode.LEFT + KeyMapper.SHIFT, this.moveLeftFast);
			keyMapper.map(KeyCode.RIGHT + KeyMapper.SHIFT, this.moveRightFast);
			keyMapper.map(KeyCode.UP + KeyMapper.SHIFT, this.moveUpFast);
			keyMapper.map(KeyCode.DOWN + KeyMapper.SHIFT, this.moveDownFast);
		}

		private function moveLeft():void
		{
			this._sprite.x -= 1;
		}

		private function moveRight():void
		{
			this._sprite.x += 1;
		}

		private function moveUp():void
		{
			this._sprite.y -= 1;
		}

		private function moveDown():void
		{
			this._sprite.y += 1;
		}
	
		private function moveLeftFast():void
		{
			this._sprite.x -= 20;
		}

		private function moveRightFast():void
		{
			this._sprite.x += 20;
		}

		private function moveUpFast():void
		{
			this._sprite.y -= 20;
		}

		private function moveDownFast():void
		{
			this._sprite.y += 20;
		}
	}
}
