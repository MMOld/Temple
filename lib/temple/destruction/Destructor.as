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

package temple.destruction 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;

	/**
	 * The Destructor is a helper class for destruction. It can destruct several types of objects.
	 * 
	 * <p>All methods are static so therefore this class does not need to be instantiated</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class Destructor 
	{
		/**
		 * Recursively destructs the object and all his descendants
		 */
		public static function destruct(object:*):void
		{
			if (!object) return;
			
			if (object is IDestructable)
			{
				IDestructable(object).destruct();
			}
			else if (object is DisplayObject)
			{
				if (IEventDispatcher(object).hasEventListener(DestructEvent.DESTRUCT))
				{
					IEventDispatcher(object).dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
				}
				
				if (object is DisplayObjectContainer)
				{
					if (object is MovieClip)
					{
						MovieClip(object).stop();
					}
					Destructor.destructChildren(DisplayObjectContainer(object));
				}
				
				if (DisplayObject(object).parent)
				{
					if (DisplayObject(object).parent is Loader)
					{
						Loader(DisplayObject(object).parent).unload();
					}
					else
					{
						DisplayObject(object).parent.removeChild(object);
					}
				}
			}
		}

		/**
		 * Recursivly destructs all children, grantchildren, grantgrantchildren, etc. of an displayobject
		 */
		public static function destructChildren(object:DisplayObjectContainer):void
		{
			if (object is Loader)
			{
				Loader(object).unload();
				return;
			}
			
			for (var i:int = object.numChildren-1; i >= 0 ; i--)
			{
				// if child is removed by another destructable, skip this index
				if (i >= object.numChildren) continue;
				
				Destructor.destruct(object.getChildAt(i));
			}
		}
	}
}
