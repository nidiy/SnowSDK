package snow.tool 
{
	import feathers.data.ListCollection;
	import ghostcat.util.data.XMLUtil;
	/**
	 * ...
	 * @author 
	 */
	public class DataProviderTools 
	{
		public static function createListCollection(xml:XML):ListCollection
		{
			var data:ListCollection = new ListCollection();
			if (xml!= null)
			{
				var xmllist:XMLList = xml.child("ListCollection").children()
				var length:int = xmllist.length();
				var item:Object = null;
				for (var i:int = 0; i <length; i++) 
				{
					item = {};
					XMLUtil.attributesToObject(xmllist[i] as XML, item)
					data.addItem(item)
				}
			}
			return data
		}
		
	}

}