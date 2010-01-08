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

	/**
	 * This class contains some functions for Strings.
	 * 
	 * @author Arjan van Wijk
	 */
	public class StringUtils 
	{

		public static function repeat(source:String, amount:int):String
		{
			var ret:String = '';
			for(var i:int = 0;i < amount;i++)
			{
				ret += source;
			}
			return ret;
		}

		public static function trimWhite(value:String):String
		{
			var arr:Array = value.split('');
			
			for(var i:int = value.length - 1;arr[i] == ' ';--i)
			{
				arr.pop();
			}
			
			for(i = 0;arr[i] == ' ';++i)
			{
				arr.shift();
			}
			
			return arr.join('');
		}

		public static function padLeft(subject:String, length:int, fillChar:String = ' '):String
		{
			if(subject.length < length)
			{
				var iLim:Number = length - subject.length;
				for(var i:Number = 0;i < iLim;i++)
				{
					subject = fillChar + subject;
				}
			}
			return subject;
		}

		public static function padRight(subject:String, length:int, fillChar:String = ' '):String
		{
			if(subject.length < length)
			{
				var iLim:Number = length - subject.length;
				for(var i:Number = 0;i < iLim;i++)
				{
					subject += fillChar;
				}
			}
			return subject;
		}

		public static function toUpperCase(value:String):String
		{
			return value.toUpperCase();
		}

		/**
		 * replaces all tabs, newlines spaces to just one space
		 * Should work the same as ignore whitespace for XML 
		 */
		public static function ignoreWhiteSpace(string:String):String
		{
			return string.replace(/[\t\r\n]|\s\s/g, "");
		}

		/**
		 *	Does a case insensitive compare or two strings and returns true if
		 *	they are equal.
		 * 
		 *	@param s1 The first string to compare.
		 *
		 *	@param s2 The second string to compare.
		 *
		 *	@returns A boolean value indicating whether the strings' values are 
		 *	equal in a case sensitive compare.	
		 */			
		public static function stringsAreEqual(s1:String, s2:String, 
											caseSensitive:Boolean):Boolean
		{
			if(caseSensitive)
			{
				return (s1 == s2);
			}
			else
			{
				return (s1.toUpperCase() == s2.toUpperCase());
			}
		}

		/**
		 *	Removes whitespace from the front and the end of the specified
		 *	string.
		 * 
		 *	@param input The String whose beginning and ending whitespace will
		 *	will be removed.
		 *
		 *	@returns A String with whitespace removed from the begining and end	
		 */			
		public static function trim(input:String):String
		{
			return StringUtils.ltrim(StringUtils.rtrim(input));
		}

		/**
		 *	Removes whitespace from the front of the specified string.
		 * 
		 *	@param input The String whose beginning whitespace will will be removed.
		 *
		 *	@returns A String with whitespace removed from the begining	
		 */	
		public static function ltrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = 0;i < size;i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}

		/**
		 *	Removes whitespace from the end of the specified string.
		 * 
		 *	@param input The String whose ending whitespace will will be removed.
		 *
		 *	@returns A String with whitespace removed from the end	
		 */	
		public static function rtrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = size;i > 0;i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}

		/**
		 *	Determines whether the specified string begins with the spcified prefix.
		 * 
		 *	@param input The string that the prefix will be checked against.
		 *
		 *	@param prefix The prefix that will be tested against the string.
		 *
		 *	@returns True if the string starts with the prefix, false if it does not.
		 */	
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0, prefix.length));
		}	

		/**
		 *	Determines whether the specified string ends with the spcified suffix.
		 * 
		 *	@param input The string that the suffic will be checked against.
		 *
		 *	@param prefix The suffic that will be tested against the string.
		 *
		 *	@returns True if the string ends with the suffix, false if it does not.
		 */	
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}	

		/**
		 *	Removes all instances of the remove string in the input string.
		 * 
		 *	@param input The string that will be checked for instances of remove
		 *	string
		 *
		 *	@param remove The string that will be removed from the input string.
		 *
		 *	@returns A String with the remove string removed.
		 */	
		public static function remove(input:String, remove:String):String
		{
			return StringUtils.replace(input, remove, "");
		}

		/**
		 * Removes all instances of the remove string in the input string.
		 * @param source The string that will be checked for instances of remove
		 * @param remove The string that will be removed from the input string.
		 * @param caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		 * 
		 * TODO: Merge with remove()
		 */
		public static function remove2(source:String, remove:String, caseSensitive:Boolean = true):String
		{
			if (source == null) return '';
			var rem:String = escapePattern(remove);
			var flags:String = (!caseSensitive) ? 'ig' : 'g';
			return source.replace(new RegExp(rem, flags), '');
		}

		private static function escapePattern(pattern:String):String 
		{
			// RM: might expose this one, I've used it a few times already.
			return pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		/**
		 *	Replaces all instances of the replace string in the input string
		 *	with the replaceWith string.
		 * 
		 *	@param input The string that instances of replace string will be 
		 *	replaces with removeWith string.
		 *
		 *	@param replace The string that will be replaced by instances of 
		 *	the replaceWith string.
		 *
		 *	@param replaceWith The string that will replace instances of replace
		 *	string.
		 *
		 *	@returns A new String with the replace string replaced with the 
		 *	replaceWith string.
		 */
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//change to StringBuilder
			var sb:String = new String();
			var found:Boolean = false;

			var sLen:Number = input.length;
			var rLen:Number = replace.length;

			for (var i:Number = 0;i < sLen;i++)
			{
				if(input.charAt(i) == replace.charAt(0))
				{   
					found = true;
					for(var j:Number = 0;j < rLen;j++)
					{
						if(!(input.charAt(i + j) == replace.charAt(j)))
						{
							found = false;
							break;
						}
					}

					if(found)
					{
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			return sb;
		}

		/*
		 * Replace template fields in a String 
		 * 
		 *	@param input The string that instances of replace string will be 
		 *	replaces with removeWith string.
		 *
		 *	@param templateHash Object which property-names will be replaced with those values
		 *	{name:'Henk',age:'12'}
		 *	
		 */
		public static function replaceTemplateFields(input:String, templateHash:Object):String
		{
			for (var key:String in templateHash)
			{
				input = StringUtils.replace(input, '{' + key + '}', templateHash[key]);
			}
			return input;
		}

		/**
		 * Same as replaceTemplateFields but can also handle typed objects
		 * 
		 * Replaces vars in a String. Vars defined between {}: '{var}'.
		 * Searches for a value in de object with the same name as the var
		 * 
		 * @example
		 * 
		 * trace(StringUtils.replaceVars("hi, my name is {name}", {name:'Thijs'});
		 * 
		 * outputs: hi, my name is Thijs
		 * 
		 */
		public static function replaceVars(string:String, object:Object, debug:Boolean = false):String
		{
			if(string == null) throwError(new TempleArgumentError(StringUtils, "String can not be null"));
			if(object == null) throwError(new TempleArgumentError(StringUtils, "Object can not be null"));
			
			return string.replace(/\{\w*\}/gi, function ():String
			{
				var prop:String = (arguments[0] as String).substr(1, (arguments[0] as String).length - 2);
				if(object != null && object.hasOwnProperty(prop) && object[prop] != null) return object[prop];
				if(debug) return '*VALUE NOT FOUND*';
				return '';
			});
		}

		/**
		 * Returns everything after the first occurrence of the provided character in the string.
		 */
		public static function afterFirst(source:String, character:String):String 
		{
			if (source == null) 
			{ 
				return ''; 
			}
			var idx:int = source.indexOf(character);
			if (idx == -1) 
			{ 
				return ''; 
			}
			idx += character.length;
			return source.substr(idx);
		}

		/**
		 * Returns everything after the last occurence of the provided character in source.
		 */
		public static function afterLast(source:String, character:String):String 
		{
			if (source == null) 
			{ 
				return ''; 
			}
			var idx:int = source.lastIndexOf(character);
			if (idx == -1) 
			{ 
				return ''; 
			}
			idx += character.length;
			return source.substr(idx);
		}

		/**
		 * Returns everything before the first occurrence of the provided character in the string.
		 */
		public static function beforeFirst(source:String, character:String):String 
		{
			if (source == null) 
			{ 
				return ''; 
			}
			var characterIndex:int = source.indexOf(character);
			if (characterIndex == -1) 
			{ 
				return ''; 
			}
			return source.substr(0, characterIndex);
		}

		/**
		 * Returns everything before the last occurrence of the provided character in the string.
		 */
		public static function beforeLast(source:String, character:String):String 
		{
			if (source == null) 
			{ 
				return ''; 
			}
			var characterIndex:int = source.lastIndexOf(character);
			if (characterIndex == -1) 
			{ 
				return ''; 
			}
			return source.substr(0, characterIndex);
		}

		/**
		 * Returns everything after the first occurance of start and before the first occurrence of end in the given string.
		 */
		public static function between(source:String, start:String, end:String):String 
		{
			var str:String = '';
			if (source == null) 
			{ 
				return str; 
			}
			var startIdx:int = source.indexOf(start);
			if (startIdx != -1) 
			{
				startIdx += start.length; 
				
				var endIdx:int = source.indexOf(end, startIdx);
				if (endIdx != -1) 
				{ 
					str = source.substr(startIdx, endIdx - startIdx); 
				}
			}
			return str;
		}

		/**
		 * Description, Utility method that intelligently breaks up your string,
		 * allowing you to create blocks of readable text.
		 * This method returns you the closest possible match to the p_delim paramater,
		 * while keeping the text length within the p_len paramter.
		 * If a match can't be found in your specified length an  '...' is added to that block,
		 * and the blocking continues untill all the text is broken apart.
		 * @param source The string to break up.
		 * @param len Maximum length of each block of text.
		 * @param delim delimter to end text blocks on, default = '.'
		 */
		public static function block(source:String, len:uint, delim:String = "."):Array
		{
			var array:Array = new Array();
			if (source == null || !contains(source, delim)) return array;
			
			var chrIndex:uint = 0;
			var strLen:uint = source.length;
			var replPatt:RegExp = new RegExp("[^" + escapePattern(delim) + "]+$");
			while (chrIndex < strLen)
			{
				var subString:String = source.substr(chrIndex, len);
				if (!contains(subString, delim))
				{
					array.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				array.push(subString);
				chrIndex += subString.length;
			}
			return array;
		}

		/**
		 * Capitallizes all words in a string
		 * @param source The string.
		 */
		public static function capitalize(source:String):String
		{
			return StringUtils.ltrim(source).replace(/^[^\s:,.\-'"]|(?<=[\s:,.\-'"])[^\s:,.\-'"]/g, StringUtils._upperCase);
		}

		private static function _upperCase(char:String, ...args):String
		{
			return char.toUpperCase();
		}

		/**
		 * Returns a string with the first character of source capitalized, if that character is alphabetic.
		 */
		public static function ucFirst(source:String):String
		{
			return source.substr(0, 1).toUpperCase() + source.substr(1);
		}

		/**
		 * Determines whether the specified string contains any instances of char.
		 */
		public static function contains(source:String, char:String):Boolean
		{
			if (source == null) return false;
			return source.indexOf(char) != -1;
		}

		/**
		 * Determines the number of times a charactor or sub-string appears within the string.
		 * @param source The string.
		 * @param char The character or sub-string to count.
		 * @param caseSensitive (optional, default is true) A boolean flag to indicate if the search is case sensitive.
		 */
		public static function countOf(source:String, char:String, caseSensitive:Boolean = true):uint 
		{
			if (source == null) 
			{ 
				return 0; 
			}
			char = escapePattern(char);
			var flags:String = (!caseSensitive) ? 'ig' : 'g';
			return source.match(new RegExp(char, flags)).length;
		}

		/**
		 * Counts the total amount of words in a text
		 * NOTE: does only work correctly for English texts
		 * TODO: fix for all languages (see capitalize for nice RegExp)
		 */
		public static function countWords(source:String):uint
		{
			if (source == null) return 0;
			return source.match(/\b\w+\b/g).length;
		}

		/**
		 * Levenshtein distance (editDistance) is a measure of the similarity between two strings. The distance is the number of deletions, insertions, or substitutions required to transform source into target.
		 */
		public static function editDistance(source:String, target:String):uint 
		{
			var i:uint;

			if (source == null) source = '';
			if (target == null) target = '';

			if (source == target) return 0;

			var d:Array = new Array();
			var cost:uint;
			var n:uint = source.length;
			var m:uint = target.length;
			var j:uint;

			if (n == 0) return m;
			if (m == 0) return n;

			for (i = 0;i <= n;i++) d[i] = new Array();
			for (i = 0;i <= n;i++) d[i][0] = i;
			for (j = 0;j <= m;j++) d[0][j] = j;

			for (i = 1;i <= n;i++)
			{
				var s_i:String = source.charAt(i - 1);
				for (j = 1;j <= m;j++) 
				{

					var t_j:String = target.charAt(j - 1);

					if (s_i == t_j) 
					{ 
						cost = 0; 
					}
					else 
					{ 
						cost = 1; 
					}

					d[i][j] = StringUtils._minimum(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost);
				}
			}
			return d[n][m];
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint 
		{
			return Math.min(a, Math.min(b, Math.min(c, a)));
		}

		/**
		 * Determines whether the specified string contains text.
		 */
		public static function hasText(string:String):Boolean
		{
			var str:String = removeExtraWhitespace(string);
			return !!str.length;
		}

		/**
		 * Determines whether the specified string contains any characters.
		 */
		public static function isEmpty(string:String):Boolean
		{
			if (string == null) return true;
			return !string.length;
		}

		/**
		 * Determines whether the specified string is numeric.
		 */
		public static function isNumeric(string:String):Boolean
		{
			if (string == null) return false;
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(string);
		}

		/**
		 * Replaces invalid HTML (for Flash) to Flash HTML
		 */
		public static function replaceHTML(string:String):String
		{
			return string.replace(/<.*?>/g, StringUtils.replaceTag);
		}

		private static function replaceTag(tag:String, ...args):String
		{
			// check tag
			switch(String(tag.match(/(?<=\<|\<\/)\w+/g)[0]).toLowerCase())
			{
				// allowed tags
				case "a":
				case "b":
				case "br":
				case "font":
				case "img":
				case "i":
				case "li":
				case "p":
				case "span":
				case "textformat":
				case "ul":
					return tag;
					break;
				
				// tags to be replaced
				case "strong":
					return tag.replace("strong", "b");
					break;
				case "em":
					return tag.replace("em", "i");
					break;
			}
			
			return '';
		}

		/**
		 * Properly cases' the string in "sentence format".
		 */
		public static function properCase(source:String):String
		{
			if (source == null) 
			{ 
				return ''; 
			}
			var str:String = source.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		 * Escapes all of the characters in a string to create a friendly "quotable" sting
		 */
		public static function quote(source:String):String
		{
			var regx:RegExp = /[\\"\r\n]/g;
			return '"' + source.replace(regx, _quote) + '"'; //"
		}

		private static function _quote(source:String, ...args):String
		{
			switch (source)
			{
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		/**
		 * Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the specified string.
		 */
		public static function removeExtraWhitespace(source:String):String
		{
			if (source == null) return '';
			var str:String = trim(source);
			return str.replace(/\s+/g, ' ');
		}

		/**
		 * Returns the specified string in reverse character order.
		 */
		public static function reverse(source:String):String
		{
			if (source == null) return '';
			return source.split('').reverse().join('');
		}

		/**
		 * Returns the specified string in reverse word order.
		 */
		public static function reverseWords(source:String):String
		{
			if (source == null) return '';
			return source.split(/\s+/).reverse().join('');
		}

		/**
		 * Determines the percentage of similiarity, based on editDistance
		 */
		public static function similarity(source:String, target:String):Number 
		{
			var ed:uint = editDistance(source, target);
			var maxLen:uint = Math.max(source.length, target.length);
			if (maxLen == 0)
			{
				return 100;
			}
			else
			{
				return (1 - ed / maxLen) * 100;
			}
		}

		/**
		 * Remove's all &lt; and &gt; based tags from a string
		 */
		public static function stripTags(source:String):String
		{
			if (source == null) 
			{ 
				return ''; 
			}
			return source.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		 * Swaps the casing of a string.
		 */
		public static function swapCase(p_string:String):String
		{
			if (p_string == null) return '';
			return p_string.replace(/(\w)/, _swapCase);
		}

		private static function _swapCase(char:String, ...args):String
		{
			var lowChar:String = char.toLowerCase();
			var upChar:String = char.toUpperCase();
			switch (char) 
			{
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return char;
			}
		}

		/**
		 * Returns a string truncated to a specified length with optional suffix
		 * @param source The string.
		 * @param len The length the string should be shortend to
		 * @param suffix (optional, default=...) The string to append to the end of the truncated string.
		 */
		public static function truncate(source:String, len:uint, suffix:String = "..."):String 
		{
			if (source == null) return '';
			len -= suffix.length;
			var trunc:String = source;
			if (trunc.length > len)
			{
				trunc = trunc.substr(0, len);
				if ((/[^\s]/ as RegExp).test(source.charAt(len)))
				{
					trunc = StringUtils.rtrim(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += suffix;
			}

			return trunc;
		}

		public static function toString():String
		{
			return getClassName(StringUtils);
		}
	}
}