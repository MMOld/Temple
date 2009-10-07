/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2009 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	THIS LIBRARY IS IN PRIVATE BETA, THEREFORE THE SOURCES MAY NOT BE
 *	REDISTRIBUTED IN ANY WAY.
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
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * The StageProvider has a global reference to the stage.
	 * 
	 * The stage has te be set before is can be used.
	 * 
	 * @author Thijs Broerse
	 */
	public class StageProvider 
	{
		private static var _STAGE:Stage;
		
		public static function get stage():Stage
		{
			return StageProvider._STAGE;
		}
		
		public static function set stage(value:Stage):void
		{
			if(value == null)
			{
				throwError(new TempleArgumentError(StageProvider.toString(), "Stage cannot be set to null"));
			}
			else if(StageProvider._STAGE == null)
			{
				StageProvider._STAGE = value;
				StageProvider._STAGE.addEventListener(FullScreenEvent.FULL_SCREEN, StageProvider.handleFullScreen, false, int.MAX_VALUE, true);
			}
		}
		
		private static function handleFullScreen(event:FullScreenEvent):void
		{
			if(event.fullScreen)
			{
				StageProvider._STAGE.addEventListener(KeyboardEvent.KEY_DOWN, StageProvider.handleKeyDown, false, int.MAX_VALUE, true);
				StageProvider._STAGE.addEventListener(Event.ENTER_FRAME, StageProvider.handleFrameDelay);
			}
		}
		
		/**
		 * Stop KeyboardEvent for SPACE, since this one is caused by a bug
		 * http://bugs.adobe.com/jira/browse/FP-814
		 */
		private static function handleKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.SPACE)	event.stopImmediatePropagation();
		}
		
		private static function handleFrameDelay(event:Event):void
		{
			StageProvider._STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, StageProvider.handleKeyDown);
			StageProvider._STAGE.removeEventListener(Event.ENTER_FRAME, StageProvider.handleFrameDelay);
		}

		public static function toString():String
		{
			return 'temple.utils.StageProvider';
		}
	}
}
