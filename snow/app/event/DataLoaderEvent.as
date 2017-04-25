package snow.app.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @HBinNet 
	 */
	public class DataLoaderEvent extends Event 
	{
		public static const DATA_COMPLETE:String = "dataComplete";
		public static const DATA_INIT_COMPLETE:String = "dataInitComplete";
		public static const DATA_ALL_COMPLETE:String = "dataAllComplete";
		public static const DATA_STOP_LOAD:String = "dataStopLoad";
		public static const DATA_START_LOAD:String = "dataStartLoad";
		public var data:Object
		public function DataLoaderEvent(type:String,data:Object=null) 
		{
			super(type)
			this.data = data;
		}
		
	}

}