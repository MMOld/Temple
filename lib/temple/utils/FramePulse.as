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

/*
Copyright 2007 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

package temple.utils 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Class to generate onEnterFrame events.
	 * @example
	 * <listing version="3.0">	
	 * FramePulse.addEnterFrameListener(handleEnterFrame);
	 * 
	 * // function that handles onEnterFrame events
	 * public function handleEnterFrame (event:Event) : void {
	 * 	
	 * // code goes here...
	 * }
	 * </listing>
	 * 
	 * To stop receiving the onEnterFrame event:
	 * <listing version="3.0">	
	 * FramePulse.removeEnterFrameListener(handleEnterFrame);
	 * </listing>
	 */

	public class FramePulse extends EventDispatcher 
	{
		private static var _sprite:Sprite;

		/**
		 * Add a listener to the FramePulse
		 * @param handler function to be called on enterframe, with parameter FramePulseEvent
		 */
		public static function addEnterFrameListener(handler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			if (FramePulse._sprite == null) 
			{
				FramePulse._sprite = new Sprite();
			}
			FramePulse._sprite.addEventListener(Event.ENTER_FRAME, handler, useCapture, priority, useWeakReference);
		}

		/**
		 * Remove a listener from the FramePulse
		 * @param handler function that was previously added
		 */
		public static function removeEnterFrameListener(handler:Function, useCapture:Boolean = false):void 
		{
			if (FramePulse._sprite != null) 
			{
				FramePulse._sprite.removeEventListener(Event.ENTER_FRAME, handler, useCapture);
			}
		}
	}
}