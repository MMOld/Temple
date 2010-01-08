/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 */

package temple.utils 
{
	import temple.core.CoreObject;
	import temple.data.collections.HashMap;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;

	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	/**
	 * Class for directly coupling Keyboard events to actions, without having to bother about event filtering
	 * 
	 * @example
	 * <listing version="3.0">
	 * keyMapper = new KeyMapper(this.stage);
	 * keyMapper.map(Keyboard.ENTER, this.submit);
	 * keyMapper.map(Keyboard.ESCAPE, this.cancel);
	 * </listing>
	 * 
	 * <p>It is also possible to map key combinations with the Shift, Alt and/or Control key.</p>
	 * 
	 * <listing version="3.0">
	 * keyMapper = new KeyMapper(this.stage);
	 * keyMapper.map(KeyCode.D | KeyMapper.CONTROL, Delegate.create(Destructor.destruct, null, this));
	 * keyMapper.map(KeyCode.R | KeyMapper.CONTROL, Memory.logRegistry);
	 * </listing>
	 * 
	 * Make sure to clean up when you're done:
	 * <listing version="3.0">
	 * keyMapper.destruct();
	 * </listing>
	 * 
	 * @author Thijs Broerse
	 */
	public class KeyMapper extends CoreObject 
	{
		/**
		 * Added when the shift-key is down while pressing a key
		 */
		public static const SHIFT:uint = 2<<10;
		
		/**
		 * Added when the control-key is down while pressing a key
		 */
		public static const CONTROL:uint = 2<<11;
		
		/**
		 * Added when the alt-key is down while pressing a key
		 */
		public static const ALT:uint = 2<<12;
		
		private var _map:HashMap;
		private var _stage:Stage;
		
		/**
		 * Creates a new KeyMapper instance
		 * @param stage a reference to the stage. Needed for handling KeyBoardEvents
		 * @param keyboardEvent pass KeyboardEvent.KEY_UP (default) if you want to listen for KEY_UP events,
		 * otherwise pass KeyboardEvent.KEY_DOWN if you want to listen for KEY_DOWN events.
		 */
		public function KeyMapper(stage:Stage, keyboardEvent:String = KeyboardEvent.KEY_UP) 
		{
			if(!stage) throwError(new TempleArgumentError(this, "stage can not be null"));
			
			if(keyboardEvent != KeyboardEvent.KEY_UP && keyboardEvent != KeyboardEvent.KEY_DOWN)
			{
				throwError(new TempleArgumentError(this, "invalid value for keyboardEvent '" + keyboardEvent + "'"));
			}
			this._map = new HashMap("KeyMapper");
			this._stage = stage;
			this._stage.addEventListener(keyboardEvent, this.handleKeyEvent);
		}

		/**
		 * Add a key to a function
		 */
		public function map(key:uint, method:Function):void 
		{
			if(this._map[key]) throwError(new TempleError(this, "You already mapped key '" + String.fromCharCode(key) + "' (" + key + ")"));
			
			this._map[key] = method;
		}
		
		/**
		 * Removes the function of a key
		 */
		public function unmap(key:uint):void 
		{
			delete this._map[key];
		}

		private function handleKeyEvent(event:KeyboardEvent):void 
		{
			var keyCode:uint = event.keyCode;
			if(event.shiftKey) keyCode |= KeyMapper.SHIFT;
			if(event.altKey) keyCode |= KeyMapper.ALT;
			if(event.ctrlKey) keyCode |= KeyMapper.CONTROL;
			
			if (this._map[keyCode]) this._map[keyCode]();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void 
		{
			if(this._stage)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_UP, this.handleKeyEvent);
				this._stage = null;
			}
			
			this._map = null;
			
			super.destruct();
		}
	}
}
