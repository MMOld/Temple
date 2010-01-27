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

package temple.utils.types 
{
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.debug.getClassName;
	import temple.utils.FrameDelay;
	import temple.utils.TimeOut;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * This class contains some functions for MovieClips.
	 * 
	 * @author Arjan van Wijk (arjan at mediamonks dot com)
	 */
	public final class MovieClipUtils 
	{
		/**
		 * Stores all playing movieclip as [movieclip] = speed
		 */
		private static var _CLIP_DICTIONARY:Dictionary;

		/**
		 * Delays a MovieClip from playing for an amount of frames/miliseconds
		 * 
		 * @param clip MovieClip
		 * @param delay Delay in frames (or miliseconds when useFrames is set to false)
		 * @param useFrames	Use frames or miliseconds
		 */
		public static function wait(movieclip:MovieClip, delay:uint, frameBased:Boolean = true):void
		{
			movieclip.stop();
			
			if (frameBased)
			{
				new FrameDelay(movieclip.play, delay);
			}
			else
			{
				new TimeOut(movieclip.play, delay);
			}
		}

		/**
		 * Play a MovieClip at a given speed (forwards or backwards)
		 * 
		 * @param clip		MovieClip
		 * @param speed		int				speed indication (negative for backwards playing)
		 */
		public static function play(movieclip:MovieClip, speed:int = 1):void
		{
			MovieClipUtils.stop(movieclip);
			
			if (speed != 0)
			{
				if (MovieClipUtils._CLIP_DICTIONARY == null) MovieClipUtils._CLIP_DICTIONARY = new Dictionary(true);
				
				movieclip.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				
				MovieClipUtils._CLIP_DICTIONARY[movieclip] = speed;
			}
		}
		
		/**
		 * Plays a movieclip backwards
		 */
		public static function playBackwards(movieclip:MovieClip):void
		{
			MovieClipUtils.play(movieclip, -1);
		}
		
		private static function handleEnterFrame(event:Event):void
		{
			var movieclip:MovieClip = MovieClip(event.target);
			var speed:int = MovieClipUtils._CLIP_DICTIONARY[movieclip];
			
			movieclip.gotoAndStop(movieclip.currentFrame + speed);
			
			if (movieclip.currentFrame == 1 || movieclip.currentFrame == movieclip.totalFrames)
			{
				MovieClipUtils.stop(movieclip);
			}
		}

		/**
		 * Stops a MovieClip and removes the play-enterFrame
		 * 
		 * @param movieclip the MovieClip to stop
		 * @param callStop if set to true (default) the 'stop()' method will also be called on the MovieClip.
		 */
		public static function stop(movieclip:MovieClip, callStop:Boolean = true):void
		{
			if(callStop) movieclip.stop();
			if (MovieClipUtils._CLIP_DICTIONARY != null && MovieClipUtils._CLIP_DICTIONARY[movieclip] != null) movieclip.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * Recursively stop() all nested MovieClips through all clip's DisplayObjectContianers)
		 * 
		 * Note: Does not affect argument
		 */
		public static function deepStop(clip:DisplayObjectContainer):void
		{
			if(clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'null clip'));
			
			var num:int = clip.numChildren;
			for(var i:int=0;i<num;i++)
			{
				var disp:DisplayObject = clip.getChildAt(i);
				if(disp is DisplayObjectContainer)
				{
					MovieClipUtils.deepStop(DisplayObjectContainer(disp));
					if(disp is MovieClip)
					{
						MovieClip(disp).stop();
					}
				}
			}
		}
		
		/**
		 * Recursively play() all nested MovieClips through all clip's DisplayObjectContianers)
		 * 
		 * Note: Does not affect argument
		 */
		public static function deepPlay(clip:DisplayObjectContainer):void
		{
			if(clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'null clip'));
			
			var num:int = clip.numChildren;
			for(var i:int=0;i<num;i++)
			{
				var disp:DisplayObject = clip.getChildAt(i);
				if(disp is DisplayObjectContainer)
				{
					if(disp is MovieClip)
					{
						MovieClip(disp).play();
					}
					MovieClipUtils.deepPlay(DisplayObjectContainer(disp));
				}
			}
		}
		
		/**
		 * Recursively nextFrames all nested MovieClips through all children DisplayObjectContianers), with option for looping
		 * 
		 * Usefull in a enterFrame if a gotoAndStop on parent timeline stops nested anims
		 * 
		 * Last-resort util: may screw up synced nested anims
		 * 
		 * Note: Does not affect argument
		 */
		public static function deepNextFrame(clip:DisplayObjectContainer, loop:Boolean=false):void
		{
			if(clip == null) throwError(new TempleArgumentError(MovieClipUtils, 'Clip cannot be null'));
			
			var num:int = clip.numChildren;
			for(var i:int=0;i<num;i++)
			{
				var disp:DisplayObject = clip.getChildAt(i);
				if(disp is DisplayObjectContainer)
				{
					if(disp is MovieClip)
					{
						var mc:MovieClip = MovieClip(disp);
						if(mc.currentFrame == mc.totalFrames)
						{
							if(loop)
							{
								mc.gotoAndStop(1);
							}
						}
						else
						{
							mc.nextFrame();
						}
					}
					MovieClipUtils.deepNextFrame(DisplayObjectContainer(disp), loop);
				}
			}
		}
		
		public static function toString():String
		{
			return getClassName(MovieClipUtils);
		}
	}
}
