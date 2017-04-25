package snow.app.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class AppEvent extends Event 
	{
		public static const APP_ADD_COMPLETE:String = "appAddComplete";
		public static const INIT_MILIEU:String = "initMilieu";
		public static const APP_COMPLETE:String = "appComplete";
		public static const APP_INFO_CHANGE:String = "appInfoChange";
		public var data:Object
		public function AppEvent(type:String,_data:Object=null) 
		{
			data = _data;
			super(type)
		}
		
	}

}