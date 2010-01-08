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

	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	/**
	 * This class contains some functions for FrameLabels.
	 * 
	 * @author Bart (bart[at]mediamonks.com)
	 */
	public class FrameLabelUtils 
	{

		public static function getFrameForLabel(clip:MovieClip, label:String):int
		{
			for each(var frameLabel:FrameLabel in clip.currentLabels)
			{
				if(frameLabel.name == label)
				{
					return frameLabel.frame;	
				}	
			}	
			return 1;
		}

		public static function hasLabel(clip:MovieClip, label:String):Boolean
		{
			for each(var frameLabel:FrameLabel in clip.currentLabels)
			{
				if(frameLabel.name == label)
				{
					return true;	
				}	
			}	
			return false;
		}

		public static function hasLabels(clip:MovieClip, ...labels):Boolean
		{
			if ((labels as Array).length == 0) throwError(new ArgumentError('zero labels'));
			
			for each(var frameLabel:FrameLabel in clip.currentLabels)
			{
				var ind:int = (labels as Array).indexOf(frameLabel.name);
				if(ind > -1)
				{
					(labels as Array).splice(ind, 1);
					if((labels as Array).length == 0)
					{
						return true;
					}
				}
			}
			return false;
		}

		public static function getLabel(clip:MovieClip, label:String):FrameLabel
		{
			for each(var frameLabel:FrameLabel in clip.currentLabels)
			{
				if(frameLabel.name == label)
				{
					return frameLabel;	
				}	
			}	
			throwError(new TempleArgumentError(FrameLabelUtils, 'unknown label ' + label));
			return null;
		}
		/**
		 * Get the last frame of a section of timeline started by label
		 */
		public static function getLastFrameOfSection(clip:MovieClip, label:String):int
		{
			var start:FrameLabel = FrameLabelUtils.getLabel(clip, label);
			var closest:int = clip.totalFrames;
			if(closest == start.frame)
			{
				//label is on last frame
				return closest;
			}
			
			for each(var frameLabel:FrameLabel in clip.currentLabels)
			{
				if(frameLabel.frame > start.frame && frameLabel.frame < closest)
				{
					closest = frameLabel.frame;	
				}	
			}
			return closest != clip.totalFrames ? closest -1 : clip.totalFrames;
		}

		public static function dumpLabels(clip:MovieClip):String
		{
			var str:String = '';
			for each(var frameLabel:FrameLabel in clip.currentLabels)
			{
				str += frameLabel.frame + ':' + frameLabel.name + '\n';
			}	
			return str;
		}
		
		public static function toString():String
		{
			return getClassName(FrameLabelUtils);
		}
	}
}
