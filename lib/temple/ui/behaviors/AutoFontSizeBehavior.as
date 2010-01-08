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

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * Autosize the font to fit in a TextField. 
	 * 
	 * @example
	 * <listing version="3.0">
	 * new AutoFontSizeBehavior(textField);
	 * </listing>
	 * 
	 * <p>The AutoFontSizeBehavior is automaticly triggered if an Event.CHANGE event dispatched by the TextField.
	 * You can also update the AutoFontSizeBehavior manually by calling update().</p>
	 * 
	 * <p>If the TextField is destructed the AutoFontSizeBehavior will automatic be destructed.</p>
	 * 
	 * Orginial class by Jankees van Woezik
	 * http://blog.base42.nl/2009/08/13/automatic-font-size-adjuster/
	 * 
	 * @author Jankees van Woezik, Thijs Broerse
	 */
	public class AutoFontSizeBehavior extends AbstractDisplayObjectBehavior 
	{
		private static const _dictionary:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the AutoFontSizeBehavior of a TextField if the TextField has AutoFontSizeBehavior. Otherwise null is returned.
		 */
		public static function getInstance(target:TextField):AutoFontSizeBehavior
		{
			return AutoFontSizeBehavior._dictionary[target] as AutoFontSizeBehavior;
		}
		
		private var _maximalFontSize:Number;
		private var _minimalFontSize:uint;
		private var _currentFontSize:Number;
		private var _previousText:String;
		private var _maximalHeight:Number;
		
		/**
		 * Adds AutoFontSizeBehavior to a TextField
		 * @param textField the TextField that needs te be autosized
		 * @param maximalFontSize the maximal size of the font in the TextField. If NaN the current size of the font is used.
		 * @param minimalFontSize the minimal size of the font in the TextField.
		 * @param willUpdateOnInput indicates if the text in the TextField could be updated and the AutoFontSizeBehavior would update the fontsize.
		 */
		public function AutoFontSizeBehavior(textField:TextField, maximalFontSize:Number = NaN, minimalFontSize:uint = 9, willUpdateOnInput:Boolean = true)
		{
			super(textField);
			
			if(AutoFontSizeBehavior._dictionary[target]) throwError(new TempleError(this, target + " already has AutoFontSizeBehavior"));
			
			AutoFontSizeBehavior._dictionary[target] = this;
			
			this._minimalFontSize = minimalFontSize;
			
			if(isNaN(maximalFontSize)) maximalFontSize = Number(textField.getTextFormat().size);
			
			this._currentFontSize = this._maximalFontSize = maximalFontSize;
			this._previousText = "";
			this._maximalHeight = textField.height;
			
			this.update();
			
			if(willUpdateOnInput)
			{
				textField.addEventListener(Event.CHANGE, this.handleTextFieldChange);
				textField.addEventListener(KeyboardEvent.KEY_UP, this.handleTextFieldChange);
				textField.addEventListener(TextEvent.TEXT_INPUT, this.handleTextFieldChange);
			}
		}
		
		/**
		 * Updates the size of the font of the TextField.
		 * The AutoFontSizeBehavior will set the maximal fontsize that will fit in the TextField 
		 */
		public function update():void
		{
			this.textField.scrollV = 0;
 
			if(this._previousText.length > this.textField.length)
			{
                this.setFontSize(this._maximalFontSize);
			}
 
			while (this._maximalHeight < this.textField.textHeight + (4 * this.textField.numLines)) 
			{ 
				if (this._currentFontSize <= this._minimalFontSize) break;
				this.setFontSize(this._currentFontSize - 0.5);
			}
 
			if(this._currentFontSize <= this._minimalFontSize) 
			{
				this.textField.text = this._previousText;
			} 
			else 
			{
				this._previousText = this.textField.text;
			}
		}

		/**
		 * Returns a reference of the TextField of the AutoFontSizeBehavior
		 */
		public function get textField():TextField
		{
			return this.target as TextField;
		}
		
		/**
		 * The maximal size of the font of the TextField
		 */
		public function get maximalFontSize():Number
		{
			return this._maximalFontSize;
		}
		
		/**
		 * @private
		 */
		public function set maximalFontSize(value:Number):void
		{
			this._maximalFontSize = value;
		}
		
		/**
		 * The minimal size of the font of the TextField
		 */
		public function get minimalFontSize():uint
		{
			return this._minimalFontSize;
		}
		
		/**
		 * @private
		 */
		public function set minimalFontSize(value:uint):void
		{
			this._minimalFontSize = value;
		}
		
		private function setFontSize(size:Number):void 
		{
			this._currentFontSize = size;
 
			var currentTextFormat:TextFormat = this.textField.getTextFormat();
			currentTextFormat.size = this._currentFontSize;
 
			this.textField.setTextFormat(currentTextFormat);
			this.textField.defaultTextFormat = currentTextFormat;
		}
		
		private function handleTextFieldChange(event:Event):void
		{
			this.update();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this.target) delete AutoFontSizeBehavior._dictionary[this.target];
			
			if(this.textField)
			{
				this.textField.removeEventListener(Event.CHANGE, this.handleTextFieldChange);
				this.textField.removeEventListener(KeyboardEvent.KEY_UP, this.handleTextFieldChange);
				this.textField.removeEventListener(TextEvent.TEXT_INPUT, this.handleTextFieldChange);
			}
			super.destruct();
		}
	}
}