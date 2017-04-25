package snow.app.core 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * APP的基本信息
	 * @author HBinNet
	 */
	public class Info extends EventDispatcher 
	{
		protected var _name:String = "";
		protected var _id:String = "";
		protected var _version:String = "1.0";
		protected var _developers:String = "";
		protected var _appClass:String ="";
		protected var _description:String = "";
		protected var _logos:Array = [];
		protected var _debug:Boolean = false;
		protected var _configURL:String=""
		public function Info() 
		{
			
		}		
		public function get developers():String 
		{
			return _developers;
		}		
		public function set developers(value:String):void 
		{
			_developers = value;
			change()
		}		
		public function get version():String 
		{
			return _version;
		}		
		public function set version(value:String):void 
		{
			_version = value;
			change()
		}		
		public function get id():String 
		{
			return _id;
		}		
		public function set id(value:String):void 
		{
			_id = value;
			change()
		}		
		public function get name():String 
		{
			return _name;
		}		
		public function set name(value:String):void 
		{
			_name = value;
			change()
		}
		
		public function get appClass():String 
		{
			return _appClass;
		}
		
		public function set appClass(value:String):void 
		{
			_appClass = value;
			change()
		}
		
		public function get description():String 
		{
			return _description;
		}
		
		public function set description(value:String):void 
		{
			_description = value;
			change()
		}
		
		public function get logos():Array 
		{
			return _logos;
		}
		
		public function set logos(value:Array):void 
		{
			_logos = value;
			change()
		}
		
		public function get debug():Boolean 
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void 
		{
			_debug = value;
			change()
		}
		
		public function get configURL():String 
		{
			return _configURL;
		}
		
		public function set configURL(value:String):void 
		{
			_configURL = value;
			change()
		}
		protected function change():void
		{
			this.dispatchEvent(new Event(Event.CHANGE))
		}
		
	}

}