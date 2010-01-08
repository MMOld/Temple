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

package temple.debug.errors 
{
	import temple.debug.log.Log;

	/**
	 * Error thrown when a error in the Temple occurs.
	 * The TempleError will automatic Log the error message.
	 * 
	 * @author Thijs Broerse
	 */
	public class TempleError extends Error implements ITempleError
	{
		private var _sender:Object;
		
		/**
		 * Creates a new TempleError
		 * @param sender The object that gererated the error. If the Error is gererated in a static function, use the toString function of the class
		 * @param message The error message
		 * @param id The id of the error
		 */
		public function TempleError(sender:Object, message:*, id:* = 0)
		{
			this._sender = sender;
			super(message, id);
			
			Log.error("'" + message + "' id:" + id + "\n" + this.getStackTrace(), String(sender));
		}
		
		/**
		 * @inheritDoc
		 */
		public function get sender():Object
		{
			return this._sender;
		}
	}
}
	