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

package temple.core 
{
	import temple.destruction.IDestructableEventDispatcher;
	import temple.ui.IDisplayObject;

	import flash.geom.Point;

	/**
	 * The ICoreDisplayObjects extends Flash native DisplayObject classes, like
	 * Sprite, MovieClip and Loader. The ICoreDisplayObjects extends ICoreObject 
	 * and are enhanced with some basic functionality, like a better stage and 
	 * parent check and ‘autoAlpha’.
	 * 
	 * <p>Even when an ICoreDisplayObject is not on the stage he has a stage. 
	 * Since he get his stage reference from the StageProvider who holds a global 
	 * reference to the stage.</p>
	 * 
	 * <p>ICoreDisplayObject are ‘auto-destructed’ if the SWF is unloaded. When a 
	 * ICoreDisplayObject is destructed we will call also destruct his children, 
	 * grant-children etcetera.</p>
	 * 
	 * @see temple.utils.StageProvider
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreDisplayObject extends IDisplayObject, ICoreObject, IDestructableEventDispatcher
	{
		/**
		 * Returns true if this object is on the Stage, false if not
		 * Needed since .stage can't be trusted for timeline objects.
		 * 
		 * The stage property can be filled even when the ICoreDisplayObject is not on the stage. The ICoreDisplayObject gets the stage from the StageProvider
		 */
		function get onStage():Boolean;

		/**
		 * Returns true if this object has a parent
		 * 
		 * Needed since .parent can't be trusted for timeline objects
		 */
		function get hasParent():Boolean;
	
		/**
		 * Same as alpha, but the visible property will automaticly be set. When value is 0 visible will be false, else visible will be true.
		 * If alpha > 0, but visible == false, then autoAlpha will return 0
		 */
		function get autoAlpha():Number;

		/**
		 * @private
		 */
		function set autoAlpha(value:Number):void;

		/**
		 * Get or set to position of the object as a Point. It is not possible to set x and/or y directy by point.
		 */
		function get position():Point;
		
		/**
		 * @private
		 */
		function set position(value:Point):void;

		/**
		 * Get and set scaleX and scaleY in one property. If scaleX is not the same as scaleY NaN is returned
		 */
		function get scale():Number;
		
		/**
		 * @private
		 */
		function set scale(value:Number):void;
		
		
	}
}
