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

package temple.ui.behaviors 
{
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.ui.layout.Align;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Dispatched when the TextField is aligned
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * The VerticalAlignTextFieldBehavior adds vertical alignment to a TextField.
	 * <p>When the text of the TextField is changed, the position of the TextField will be changed to give it the correct vertical alignment</p> 
	 * 
	 * @author Thijs Broerse
	 */
	public class VerticalAlignTextFieldBehavior extends AbstractDisplayObjectBehavior 
	{
		private var _align:String;
		private var _top:Number;
		private var _middle:Number;
		private var _bottom:Number;
		
		public function VerticalAlignTextFieldBehavior(target:TextField, align:String, autoSize:String = 'left')
		{
			super(target);
			
			this._top = target.y;
			this._bottom = target.y + target.height;
			this._middle = target.y + target.height * .5;
			
			switch(autoSize)
			{
				case TextFieldAutoSize.CENTER:
				case TextFieldAutoSize.LEFT:
				case TextFieldAutoSize.RIGHT:
					target.autoSize = autoSize;
					break;
				
				default:
					throwError(new TempleError(this, "Invalid value for autoSize: '" + autoSize + "', autoSize must be 'left', 'right' or 'center'"));
					break;
			}
			
			this.align = align;
			target.addEventListener(Event.CHANGE, this.handleTextFieldChange);
		}
		
		/**
		 * The vertical alignement. Possible values: Align.TOP, Align.MIDDLE, Align.BOTTOM
		 */
		public function get align():String
		{
			return this._align;
		}
		
		/**
		 * @private
		 */
		public function set align(value:String):void
		{
			switch(value)
			{
				case Align.TOP:
				case Align.MIDDLE:
				case Align.BOTTOM:
					this._align = value;
					this.doAlign();
					break;
				default:
					throwError(new TempleError(this, "Invalid value for align: '" + value + "'"));
					break;
			}
		}
		
		/**
		 * The initial top of the TextField
		 */
		public function get top():Number
		{
			return this._top;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set top(value:Number):void
		{
			this._top = value;
		}
		
		/**
		 * The initial middle of the TextField
		 */
		public function get middle():Number
		{
			return this._middle;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set middle(value:Number):void
		{
			this._middle = value;
		}
		
		/**
		 * The initial bottom of the TextField
		 */
		public function get bottom():Number
		{
			return this._bottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bottom(value:Number):void
		{
			this._bottom = value;
		}
		
		private function handleTextFieldChange(event:Event):void
		{
			this.doAlign();
		}

		private function doAlign():void
		{
			switch(this._align)
			{
				case Align.TOP:
					this.displayObject.y = this._top;
					break;
				case Align.BOTTOM:
					this.displayObject.y = this._bottom - this.displayObject.height;
					break;
				case Align.MIDDLE:
					this.displayObject.y = this._top + (this._bottom - this._top) * .5 - this.displayObject.height * .5;
					break;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this.displayObject) this.displayObject.removeEventListener(Event.CHANGE, this.handleTextFieldChange);
			
			super.destruct();
		}
	}
}
