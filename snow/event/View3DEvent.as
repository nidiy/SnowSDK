package snow.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class View3DEvent extends Event 
	{
		public static const IS_OPEN_VR:String = "isOpenVR"
		public var data:Object;
		public function View3DEvent(type:String,_data:Object=null) 
		{
			data = _data;
			super(type)
		}
		
	}

}