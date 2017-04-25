package snow.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author WebCity
	 */
	public class Scene3DEvent extends Event 
	{
		public static const CLICK3D:String = "click_Scene3D"
		public static const OPEN_VR:String = "openVR";
		public var data:Object;
		public function Scene3DEvent(type:String,_data:Object=null) 
		{
			data = _data;
			super(type)
		}
		
	}

}