package snow.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Tim
	 */
	public class UserEvent extends Event 
	{
		public static const SIGN_IN:String = "sign_in";
		public static const SIGN_OUT:String = "sign_out";
		
		public var data:Object = null;
		public var uid:String = null;
		public var name:String = null;
		public function UserEvent(type:String,uid:String,name:String=null,data:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			this.data = data;
			this.uid = uid;
			this.name = name;
		}
		
	}

}