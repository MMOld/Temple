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
	import temple.core.CoreObject;

	import flash.events.Event;

	/**
	 * Delay a function call with one or more frames. Use this when initializing a SWF or a bunch of DisplayObjects, to enable the player to do its thing.	Usually a single frame delay will do the job, since the next enterFrame will come when all other jobs are finished.
	 * To execute function 'init' after 1 frame, use:
	 * 
	 * @example
	 * <listing version="3.0">
	 * new FrameDelay(init);
	 * </listing>
	 * 
	 * To execute function 'init' after 10 frames, use:
	 * <listing version="3.0">
	 * new FrameDelay(init, 10);
	 * </listing>
	 * 
	 * To call function 'setProps' with parameters, executed after 1 frame:
	 * <listing version="3.0">
	 * new FrameDelay(setProps, 1, [shape, 'alpha', 0]);
	 * </listing>
	 * 
	 * <listing version="3.0">
	 * private function setProps (shape:Shape, property:String, value:Number):void
	 * {
	 * 		shape[property] = value;
	 * }
	 * </listing>
	 */
	public final class FrameDelay extends CoreObject
	{
		private var _isDone:Boolean = false;
		private var _currentFrame:int;
		private var _callback:Function;
		private var _params:Array;

		/**
		 * Creates a new FrameDelay. Starts the delay immediately.
		 * @param callback the callback function to be called when done waiting
		 * @param frameCount the number of frames to wait; when left out, or set to 1 or 0, one frame is waited
		 * @param params list of parameters to pass to the callback function
		 */
		public function FrameDelay(callback:Function, frameCount:int = 1, params:Array = null) 
		{
			this._currentFrame = frameCount;
			this._callback = callback;
			this._params = params;
			this._isDone = (isNaN(frameCount) || (frameCount <= 1));
			FramePulse.addEnterFrameListener(handleEnterFrame);
		}


		/**
		 * Handle the Event.ENTER_FRAME event.
		 * Checks if still waiting - when true: calls callback function.
		 * @param event not used
		 */
		private function handleEnterFrame(event:Event):void 
		{
			if (this._isDone) 
			{
				FramePulse.removeEnterFrameListener(this.handleEnterFrame);
				if (this._params == null) 
				{
					this._callback();
				}
				else 
				{
					this._callback.apply(null, this._params);
				}
			}
			else 
			{
				this._currentFrame--;
				this._isDone = (this._currentFrame <= 1);
			}
		}
		
		/**
		 * Release reference to creating object.
		 * Use this to remove a FrameDelay object that is still running when the creating object will be removed.
		 */
		override public function destruct():void 
		{
			FramePulse.removeEnterFrameListener(handleEnterFrame);
			
			this._callback = null;
			this._params = null;
			
			super.destruct();
		}
	}
}