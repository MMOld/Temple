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

package temple.data.flashvars 
{
	import temple.core.CoreObject;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.utils.types.BooleanUtils;

	/**
	 * A FlashVar is an internal class used by the FlashVars to store information about 
	 * the loaderinfo.parameters.
	 */
	internal class FlashVar extends CoreObject
	{ 
		private var _name:String;
		private var _value:*;
		private var _defaultValue:*;
		private var _type:Class;
		private var _external:Boolean;

		public function FlashVar(name:String, value:*, fromHTML:Boolean = false)
		{
			this._name = name;
			this._value = value;
			this._external = fromHTML;
		}

		/**
		 * The name of the FlashVar
		 */
		public function get name():String
		{
			return this._name;
		}

		/**
		 * The value of the FlashVar. If the value is not set by the LoaderInfo, the defaultValue is returned.
		 */
		public function get value():*
		{
			switch (this._type)
			{
				default:
				{	
					this.logWarn("value: can't convert to " + this._type + ", result will be a String");
					// no break
				}
				case null:
				case String:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : this._value;
				}
			
				case Boolean:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : BooleanUtils.getBoolean(this._value);
				}
			
				case Number:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : Number(this._value);
				}
			
				case int:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : int(this._value);
				}
			
				case Array:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : String(this._value).split(',');
				}
			
				case XML:
				{
					return (this._value == '' || this._value == undefined) && this._defaultValue ? this._defaultValue : XML(this._value);
				}
			}
			return this._value;
		}

		/**
		 * The defaultValue, used when the value is not set by the LoaderInfo.
		 */
		public function set defaultValue(value:*):void
		{
			this._defaultValue = value;
			
			if (this._type && this._defaultValue)
			{
				if (!(this._defaultValue is this._type)) throwError(new TempleArgumentError(this, 'defaultValue [' + this._defaultValue + '] is not of type ' + this._type));
			}
		}

		/**
		 * The type of the value. Possible values are: String, Boolean, Number, int, Array and XML
		 */
		public function get type():Class
		{
			return this._type;
		}

		/**
		 * @private
		 */
		public function set type(value:Class):void
		{
			this._type = value;
		}

		/**
		 * Indicates if the value is set by the loaderInfo.parameters (true) of the default is used (false)
		 */
		public function get external():Boolean
		{
			return this._external;
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + "(name='" + this._name + "', default='" + this._defaultValue + "', value='" + this._value + "', type='" + this._type + "', external=" + this._external + ")";
		}
	}
}
