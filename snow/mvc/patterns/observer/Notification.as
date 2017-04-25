package snow.mvc.patterns.observer
{
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.*;
	public class Notification implements INotification
	{
		
		public function Notification( name:String, body:Object=null, type:String=null )
		{
			this.name = name;
			this.body = body;
			this.type = type;
		}
		public function getName():String
		{
			return name;
		}
		public function setBody(body:Object ):void
		{
			this.body = body;
		}
		public function getBody():Object
		{
			return body;
		}
		public function setType(type:String):void
		{
			this.type = type;
		}
		public function getType():String
		{
			return type;
		}
		public function toString():String
		{
			var msg:String = "Notification Name: "+getName();
			msg += "\nBody:"+(( body == null )?"null":body.toString());
			msg += "\nType:"+(( type == null )?"null":type);
			return msg;
		}		
		private var name:String;
		private var type:String;
		private var body:Object;
		
	}
}