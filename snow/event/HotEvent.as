package snow.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author WebCity
	 */
	public class HotEvent extends Event 
	{
		public static const CLICK_HOT:String="clickhot"
		public var data:Object;
		public function HotEvent(type:String,_data:Object=null) 
		{
			data = _data;
			super(type)
		}
		
	}

}