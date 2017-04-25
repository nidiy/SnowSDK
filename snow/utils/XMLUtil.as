package snow.utils
{
	import flash.utils.ByteArray;

	/**
	 * XML辅助类 
	 */
	public final class XMLUtil
	{
		public static function createFrom(source:*):XML
		{
			if (source is Class)
				source = new source();
			
			if (source is ByteArray)
			{
				try
				{
					(source as ByteArray).uncompress();
				}
				catch (e:Error)
				{}
				source = source.toString();
			}
			
			if (source is String)
			{
				//去掉额外的文件首字符
				while (source.substr(0,1) != "<")
					source = source.substr(1);
				return new XML(source);
			}
			return null;
		}	
		public static function toXMLString(xml:*):String
		{
			if (xml == null)
			{
				return "null";
			}
			return xml.toXMLString();
		}
		public static function children(xml:*):XMLList
		{
			return xml.children();
		}
		public static function length(xmlList:XMLList):int
		{
			return xmlList.length()
		}
		public static function appendChild(xml:*, child:Object):XML
		{
			return XML(xml).appendChild(child)
		}		
		public static function attributeAt(xml:XML, attributeName:*,value:*):void
		{
			xml["@" + attributeName] = value;
		}	
		public static function attributeAtName(xml:*,attributeName:*,attributeValue:*):XMLList
		{
			if (xml == null) return null;
			if (xml.length() == 0) return null;
			var xmllist:XMLList = xml.(attribute(attributeName) == attributeValue);
			if (xmllist.toXMLString() == "") return null;
			return xmllist
		}	
		public static function attributes(xml:XML):XMLList
		{
			return xml.attributes()
		}	
		public static function child(xml:XML,propertyName:Object):XMLList
		{
			return xml.child(propertyName)
		}	
		public static function childIndex(xml:XML):int
		{
			return xml.childIndex()
		}	
		public static function comments(xml:XML):XMLList
		{
			return xml.comments()
		}	
		public static function replace(xml:XML,propertyName:Object,value:XML):XML
		{
			return xml.replace(propertyName,value)
		}
		public static function setChildren(xml:XML,propertyName:Object):XML
		{
			return xml.setChildren(propertyName)
		}		
		public static function propertyIsEnumerable(xml:XML, p:String):Boolean
		{
			return xml.propertyIsEnumerable(p)
		}
		public static function parent(xml:XML):*
		{
			return xml.parent();
		}
		public static function copy(xml:XML):XML
		{
			return xml.copy();
		}
		public static function insertChildAfter(xml:XML, child1:Object, child2:Object):*
		{
			return xml.insertChildAfter(child1,child2)
		}		
		public static function insertChildBefore(xml:XML, child1:Object, child2:Object):*
		{
			return xml.insertChildBefore(child1,child2)
		}	
		public static function elements(xml:XML,name:Object="*"):XMLList
		{
			return xml.elements(name)
		}		
		public static function getXMLListLength(xmllist:XMLList):int
		{
			return xmllist.length();
		}
		public static function attributesToObject(xml:*,result:Object = null):Object
		{
			if (!result)
				result = new Object();
			
			for each (var xml:XML in xml.attributes())
				result[xml.name().toString()] = xml.toString();
			
			return result;
		}
		public static function xmllistToArray(xmllist:XMLList,result:Array=null):Array
		{
			if(!result)
				result = new Array();
			var length:int = xmllist.length();
			for (var i:int = 0; i <length; i++) 
			{
				var item:Object = {};
				xmlToObject(xmllist[i],item);
				attributesToObject(xmllist[i],item);
				result.push(item);
			}
			return result;
		}
		public static function xmlToObject(xml:*,result:Object = null):Object
		{
			if (!result)
				result = new Object();
			for each (var xml:XML in xml.children())
				result[xml.name().toString()] = xml.toString();
			return result;
		}
		public static function objectToXML(obj:Object, result:XML=null,filter:Array=null):XML
		{
			if (!result)
				result = <xml/>;
			for (var key:String in obj)
			{
				if (filter)
				{
					if (filter.indexOf(key)==-1)
					{
					   result[key] = obj[key];	
					}
					
				}else {
					if (obj[key] is Array)
					{
						var array:Array = obj[key];
						for (var i:int = 0; i <array.length; i++) 
						{
							var xml:XML=XML("<"+key+"/>")
							result.appendChild(objectToXML(array[i],xml))
						}
						
					}else if (obj[key] is String || obj[key] is Number || obj[key] is uint || obj[key] is int || obj[key] is Boolean)
					{
						result["@"+key] = obj[key];	
					}else
					{
						xml=XML("<"+key+"/>")
						result.appendChild(objectToXML(obj[key],xml))
					}
					
				}
			}
			return result;
		}
		public static function objectToAttributes(obj:Object,result:XML = null,filter:Array=null):XML
		{
			if (!result)
				result = <xml/>;
			
			for (var key:String in obj)
			{
				if (filter)
				{
					if (filter.indexOf(key)==-1)
					{
					   result["@" + key] = obj[key];
					}
					
				}else
				{
					result["@" + key] = obj[key];
				}
			}
			
			return result;
		}
		
		public static function childrenToAttributes(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.children())
				result["@" + xml.name().toString()] = xml.toString();
			
			return result;
		}
		
		public static function attributesToChildren(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.attributes())
			{
				var child:XML = <xml/>
				child.setName(xml.name());
				child.appendChild(xml.toString());
				result.appendChild(child);
			}
			return result;
		}
	}
}