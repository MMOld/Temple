/**
 * @exampleText Example of a value object class that can parse a XML file.
 */
package vo 
{
	import temple.data.xml.IXMLParsable;

	public class PersonData implements IXMLParsable 
	{
		private var _id:uint;
		private var _name:String;
		private var _age:uint;
		private var _gender:String;
		
		public function parseXML(xml:XML):Boolean
		{
			// map XML values to properties
			this._id = xml.@id;
			this._name = xml['name'];
			this._age = xml['age'];
			this._gender = xml['gender'];
			
			// check if id and name are filled
			return this._id && this._name != null;
		}
		
		public function get id():uint
		{
			return this._id;
		}
		
		public function get name():String
		{
			return this._name;
		}
		
		public function get age():uint
		{
			return this._age;
		}
		
		public function get gender():*
		{
			return this._gender;
		}
	}
}
