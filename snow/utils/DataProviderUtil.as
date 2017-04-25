package snow.utils 
{
	import feathers.data.ListCollection;
	/**
	 * ...
	 * @author WebCity
	 */
	public class DataProviderUtil 
	{
		
		public static function refreshDataProvider(target:ListCollection,source:ListCollection):void
		{

	        var length:int =source.length;
			var souLength:int =target.length;
			
			var obj:Object = null;
			var upObj:Object = null;
			var space:int = Math.abs(souLength - length);
			if (souLength > length)
			{
				for (var j:int = 0; j <space; j++) 
				{
					target.pop();
				}
			}
			for (var i:int = 0; i <length; i++) 
			{
				obj = source.getItemAt(i);
				if (i >= souLength)
				{
					target.addItem(obj)
					
				}else{
					
					upObj = target.getItemAt(i);
					copy(upObj,obj)
					target.updateItemAt(i)
				}
			}
			source.removeAll();	
		}
		public static function copy(target:Object,source:Object):void
		{
			for (var key:* in target)
			{
				delete target[key];
			}
			for (var value:* in source)
			{
				target[value] = source[value];
			}
			source = null;
		}
		
	}

}