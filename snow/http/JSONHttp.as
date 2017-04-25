package snow.http
{

	/**
	 * JSONHttp
	 *
	 */
	public class JSONHttp extends Http
	{
		public function JSONHttp()
		{
			super();
		}

		override public function reset(errorCode:int,data:Object):void
		{
			
			trace("JSONHttp::reset=>" + data);
			var jsonData:Object = JSON.parse(data as String);		
			super.reset(errorCode, jsonData);						
			
		}
	}
}