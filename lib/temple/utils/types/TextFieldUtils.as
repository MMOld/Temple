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
	import temple.debug.getClassName;

	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * This class contains some functions for TextFields.
	 * 
	 * @author Thijs Broerse
	 */
	public class TextFieldUtils 
	{
		private static const _MAGICAL_TEXTWIDTH_PADDING:Number = 3;

		/**
		 * Trims the text to fit a given textfield.  
		 * @param textField the TextField to set the new text to
		 * @param abbreviatedString the text that indicates that trimming has occurred; commonly this is "..."  
		 */  
		public static function trimTextFieldText(textField:TextField, abbreviatedString:String = "..."):void 
		{
			var text:String = textField.text;
			var trimLength:int = text.length;
			
			while (textField.multiline && textField.textHeight > textField.height || !textField.multiline && textField.textWidth + TextFieldUtils._MAGICAL_TEXTWIDTH_PADDING > textField.width)
			{ 
				--trimLength;
				text = text.substr(0, trimLength);
				text += abbreviatedString;
				textField.text = text;
			}
		}

		/**
		 * Creates a new TextField with the same layout
		 */
		public static function copy(textField:TextField):TextField
		{
			var t:TextField = new TextField();
			
			t.antiAliasType = textField.antiAliasType;
			t.autoSize = textField.autoSize;
			t.defaultTextFormat = textField.defaultTextFormat;
			t.embedFonts = textField.embedFonts;
			t.gridFitType = textField.gridFitType;
			t.mouseWheelEnabled = textField.mouseWheelEnabled;
			t.multiline = textField.multiline;
			t.selectable = textField.selectable;
			t.sharpness = textField.sharpness;
			t.styleSheet = textField.styleSheet;
			t.text = textField.text;
			t.textColor = textField.textColor;
			t.thickness = textField.thickness;
			t.type = textField.type;
			t.wordWrap = textField.wordWrap;
			t.width = textField.width;
			t.height = textField.height;
			t.x = textField.x;
			t.y = textField.y;
			
			t.setTextFormat(textField.getTextFormat());
			return t; 
		}

		/**
		 * Checks if a TextField uses a TextFormat
		 */
		public static function usesTextFormat(textField:TextField):Boolean
		{
			return (textField.getTextFormat() != null);				
		}

		public static function usesStyleSheet(textField:TextField):Boolean
		{
			return (textField.styleSheet != null);				
		}

		/**
		 * TODO: Refactor this
		 */
		public static function getFontSize(textField:TextField):Number
		{
			if(textField.text == "") return 0;
			var usesStyleSheet:Boolean = usesStyleSheet(textField);
			var usesOneTextFormat:Boolean = usesTextFormat(textField);

			if(!usesOneTextFormat && !usesStyleSheet)
			{
				throw new Error("Getting fontSize only works when you use one TextFormat or a StyleSheet");				
			}
			if(!usesStyleSheet)
			{
				var textFormat:TextFormat = textField.getTextFormat();
				return textFormat.size as Number;
			}
			else
			{
				var avarageSize:Number = 0;
				var styles:Array = textField.styleSheet.styleNames;
				var i:int = styles.length;
				while(i--)
				{
					var styleName:String = styles[i];

					var styleObject:Object = textField.styleSheet.getStyle(styleName);
					avarageSize += styleObject.fontSize;
				}
				avarageSize = avarageSize / styles.length;
				return avarageSize;
			}
		}

		/**
		 * TODO: Refactor this
		 */
		public static function setFontSize(fontSize:Number, textField:TextField):void
		{
			var usesStyleSheet:Boolean = usesStyleSheet(textField);
			var usesOneTextFormat:Boolean = usesTextFormat(textField);
			if(!usesOneTextFormat && !usesStyleSheet)
			{
				throw new Error("setting fontSize only works when you use one TextFormat or a StyleSheet");				
			}
			if(!usesStyleSheet)
			{
				var textFormat:TextFormat = textField.getTextFormat();
				textFormat.size = fontSize;
				textField.setTextFormat(textFormat);
			}
			else
			{
				// Because stylesheets usualy work with multiple sizes, we use the differance.
				var prevFontSize:Number = getFontSize(textField);
				var sizeDiff:Number = fontSize - prevFontSize;
				
				var styles:Array = textField.styleSheet.styleNames;
				var i:int = styles.length;
				while(i--)
				{
					var styleName:String = styles[i];
					var styleObject:Object = textField.styleSheet.getStyle(styleName);
					styleObject.fontSize = Number(styleObject.fontSize) + sizeDiff;
					textField.styleSheet.setStyle(styleName, styleObject);
				}
				textField.styleSheet = textField.styleSheet;
			}
		}

		public static function toString():String
		{
			return getClassName(TextFieldUtils);
		}
	}
}
