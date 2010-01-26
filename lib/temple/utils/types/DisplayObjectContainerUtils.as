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

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * This class contains some functions for DisplayObjectContainers.
	 * 
	 * @author Thijs Broerse
	 */
	public class DisplayObjectContainerUtils 
	{
		/**
		 * Searches the display list for a child of a specific type. Returns the first found child
		 * 
		 * @param container The DisplayObjectContainer that has the child
		 * @param type the Class of the child to find
		 * @param recursive is set to true also children (and grantchildren etc) will be searched for the type
		 * 
		 * @return the first child of the type
		 */
		public static function findChildOfType(container:DisplayObjectContainer, type:Class, recursive:Boolean = false):DisplayObject
		{
			var child:DisplayObject;
			var leni:int = container.numChildren;
			for (var i:int = 0;i < leni;i++) 
			{
				child = container.getChildAt(i);
				
				if(child is type)
				{
					return child;
				}
				else if (recursive && child is DisplayObjectContainer)
				{
					child = DisplayObjectContainerUtils.findChildOfType(child as DisplayObjectContainer, type, recursive);
					if(child != null) return child;
				}
			}
			return null;
		}

		/**
		 * Searches for a child with a specific name. Throws an TempleArgumentError if no child is found
		 * 
		 * @param container the DisplayObjectContainer which contains the child
		 * @param name the name of the child to find
		 * 
		 * @return the child with the name
		 */
		public static function getChildByName(container:DisplayObjectContainer, name:String):DisplayObject
		{
			if(container == null) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'container is null while looking for \'' + name + '\''));	

			var child:DisplayObject = container.getChildByName(name);
			if(child == null)
			{
				throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'cannot find a child named \'' + name + '\' in container \'' + container + '\''));	
			}
			return child;
		}

		/**
		 * Finds a TextField with a specific name. Throws an TempleArgumentError if no child is found or if the object is not a TextField
		 * 
		 * @param container the DisplayObjectContainer which contains the TextField
		 * @param name the name of the TextField to find
		 * 
		 *  @return the TextField with the name
		 */
		public static function getTextField(container:DisplayObjectContainer, name:String):TextField
		{
			var child:DisplayObject = DisplayObjectContainerUtils.getChildByName(container, name);
			if(!(child is TextField))
			{
				throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'the child named \'' + name + '\' in container \'' + container + '\' is not a TextField'));
			}
			return child as TextField;
		}

		/**
		 * Finds a TextField with a specific name. Throws an ArgumentError if no child is found or if the object is not a TextField
		 * 
		 * @param container the DisplayObjectContainer which contains the DisplayObjectContainer with holderName
		 * @param holderName the name of the DisplayObjectContainer which contains the TextField
		 * @param name the name of the TextField to find
		 * 
		 *  @return the TextField with the name
		 */
		public static function getNestedTextField(container:DisplayObjectContainer, holderName:String, name:String):TextField
		{
			var child:DisplayObject = DisplayObjectContainerUtils.getChildByName(container, holderName);
			if(!(child is DisplayObjectContainer))
			{
				throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'the container named \'' + holderName + '\' in container \'' + container + '\' is not a DisplayObjectContainer'));
			}
			return DisplayObjectContainerUtils.getTextField(DisplayObjectContainer(child), name);
		}

		/**
		 * Finds a MovieClip with a specific name. Throws an TempleArgumentError if no child is found or if the object is not a MovieClip
		 * 
		 * @param container the DisplayObjectContainer which contains the MovieClip
		 * @param name the name of the MovieClip to find
		 * 
		 * @return the MovieClip with the name
		 */
		public static function getMovieClip(container:DisplayObjectContainer, name:String):MovieClip
		{
			var child:DisplayObject = DisplayObjectContainerUtils.getChildByName(container, name);
			if(!(child is MovieClip))
			{
				throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'the child named \'' + name + '\' in container \'' + container + '\' is not a MovieClip'));
			}
			return child as MovieClip;
		}

		/**
		 * Disables the mouse on all children, works the quite same as mouseChildren = false, but you can enable some children after this
		 */
		public static function mouseDisableChildren(container:DisplayObjectContainer, recursive:Boolean = true):void
		{
			if(container == null) return;
			
			container.mouseChildren = true;
			
			var child:DisplayObject;
			
			var leni:int = container.numChildren;
			for (var i:int = 0;i < leni ;i++)
			{
				child = container.getChildAt(i);
				
				if(child is InteractiveObject)
				{
					InteractiveObject(child).mouseEnabled = false;
					
					if(recursive && child is DisplayObjectContainer)
					{
						DisplayObjectContainer(child).mouseChildren = true;
						DisplayObjectContainerUtils.mouseDisableChildren(DisplayObjectContainer(child));
					}
				}
			}
		}

		/**
		 * Reset scaling of container
		 */
		public static function resetScaling(container:DisplayObjectContainer):void
		{
			var len:int = container.numChildren;
			for (var i:int = 0;i < len ;i++)
			{
				container.getChildAt(i).width *= container.scaleX;
				container.getChildAt(i).height *= container.scaleY;
			}
			container.scaleX = container.scaleY = 1;
		}

		public static function toString():String
		{
			return getClassName(DisplayObjectContainerUtils);
		}
	}
}
