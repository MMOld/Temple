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
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.debug.getClassName;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;

	/**
	 * This class contains some functions for the Stage.
	 * 
	 * @author Thijs Broerse
	 */
	public final class StageUtils 
	{
		/**
		 * Returns the most left x value of the stage, whatever the stageAlign is.
		 */
		public static function getStageLeft(stage:Stage):Number
		{
			if(stage == null) throwError(new TempleArgumentError(StageUtils.toString(), "Stage can't be null"));
			
			var originalWidth:Number;
			
			if(stage.numChildren)
			{
				originalWidth = DisplayObject(stage.getChildAt(0)).loaderInfo.width;
			}
			else
			{
				var s:Sprite = new Sprite();
				stage.addChild(s);
				originalWidth = s.loaderInfo.width;
				stage.removeChild(s);
			}
			switch(stage.align)
			{
				case '':
				case StageAlign.TOP:
				case StageAlign.BOTTOM:
					return (stage.stageWidth - originalWidth) * -.5;
					break;
				
				case StageAlign.TOP_LEFT:
				case StageAlign.LEFT:
				case StageAlign.BOTTOM_LEFT:
					return 0;
					break;
				
				case StageAlign.TOP_RIGHT:
				case StageAlign.RIGHT:
				case StageAlign.BOTTOM_RIGHT:
					return originalWidth - stage.stageWidth;
					break;
				
				default:
					throwError(new TempleError(StageUtils, "unknow stageAlign '" + stage.align + "'"));
					break;
			}
			return NaN;
		}
		
		/**
		 * Returns the most right x value of the stage, whatever the stageAlign is.
		 */
		public static function getStageRight(stage:Stage):Number
		{
			if(stage == null) throwError(new TempleArgumentError(StageUtils.toString(), "Stage can't be null"));
			
			var originalWidth:Number;
			
			if(stage.numChildren)
			{
				originalWidth = DisplayObject(stage.getChildAt(0)).loaderInfo.width;
			}
			else
			{
				var s:Sprite = new Sprite();
				stage.addChild(s);
				originalWidth = s.loaderInfo.width;
				stage.removeChild(s);
			}
			switch(stage.align)
			{
				case '':
				case StageAlign.TOP:
				case StageAlign.BOTTOM:
					return stage.stageWidth - (stage.stageWidth - originalWidth) * .5;
					break;
				
				case StageAlign.TOP_LEFT:
				case StageAlign.LEFT:
				case StageAlign.BOTTOM_LEFT:
					return stage.stageWidth;
					break;
				
				
				case StageAlign.TOP_RIGHT:
				case StageAlign.RIGHT:
				case StageAlign.BOTTOM_RIGHT:
					return originalWidth;
					break;
				
				default:
					throwError(new TempleError(StageUtils, "unknow stageAlign '" + stage.align + "'"));
					break;
			}
			return NaN;
		}

		/**
		 * Returns the most top y value of the stage, whatever the stageAlign is.
		 */
		public static function getStageTop(stage:Stage):Number
		{
			if(stage == null) throwError(new TempleArgumentError(StageUtils.toString(), "Stage can't be null"));
			
			var originalHeight:Number;
			
			if(stage.numChildren)
			{
				originalHeight = DisplayObject(stage.getChildAt(0)).loaderInfo.height;
			}
			else
			{
				var s:Sprite = new Sprite();
				stage.addChild(s);
				originalHeight = s.loaderInfo.width;
				stage.removeChild(s);
			}
			switch(stage.align)
			{
				case '':
				case StageAlign.LEFT:
				case StageAlign.RIGHT:
					return (stage.stageHeight - originalHeight) * -.5;
					break;

				case StageAlign.TOP_LEFT:
				case StageAlign.TOP:
				case StageAlign.TOP_RIGHT:
					return 0;
					break;
				
				case StageAlign.BOTTOM_LEFT:
				case StageAlign.BOTTOM:
				case StageAlign.BOTTOM_RIGHT:
					return originalHeight - stage.stageHeight;
					break;
				
				default:
					throwError(new TempleError(StageUtils, "unknow stageAlign '" + stage.align + "'"));
					break;
			}
			return NaN;
		}
		
		/**
		 * Returns the most bottom y value of the stage, whatever the stageAlign is.
		 */
		public static function getStageBottom(stage:Stage):Number
		{
			if(stage == null) throwError(new TempleArgumentError(StageUtils.toString(), "Stage can't be null"));
			
			var originalHeight:Number;
			
			if(stage.numChildren)
			{
				originalHeight = DisplayObject(stage.getChildAt(0)).loaderInfo.height;
			}
			else
			{
				var s:Sprite = new Sprite();
				stage.addChild(s);
				originalHeight = s.loaderInfo.width;
				stage.removeChild(s);
			}
			switch(stage.align)
			{
				case '':
				case StageAlign.LEFT:
				case StageAlign.RIGHT:
					return stage.stageHeight - (stage.stageHeight - originalHeight) * .5;
					break;

				case StageAlign.TOP_LEFT:
				case StageAlign.TOP:
				case StageAlign.TOP_RIGHT:
					return stage.stageHeight;
					break;
				
				case StageAlign.BOTTOM_LEFT:
				case StageAlign.BOTTOM:
				case StageAlign.BOTTOM_RIGHT:
					return originalHeight;
					break;
				
				default:
					throwError(new TempleError(StageUtils, "unknow stageAlign '" + stage.align + "'"));
					break;
			}
			return NaN;
		}
		
		public static function toString():String
		{
			return getClassName(StageUtils);
		}
	}
}
