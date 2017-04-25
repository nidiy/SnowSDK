package snow.mvc.patterns.proxy
{
	import snow.mvc.interfaces.INotifier;
	import snow.mvc.interfaces.IProxy;
	import snow.mvc.patterns.observer.Notifier;
	import snow.mvc.interfaces.*;
	import snow.mvc.patterns.observer.*;
	public class Proxy extends Notifier implements IProxy, INotifier
	{

		public static var NAME:String = 'Proxy';
		private static var index:int = 0;
		public function Proxy( proxyName:String=null, data:Object=null ) 
		{
			this.proxyName = (proxyName != null)?proxyName:NAME+index;
			index++;
			if (data != null) setData(data);
		}
		public function getProxyName():String 
		{
			return proxyName;
		}		
		public function setData( data:Object ):void 
		{
			this.data = data;
		}		
		public function getData():Object 
		{
			return data;
		}
		public function onRegister():void{}
		public function onRemove():void{}	
		protected var proxyName:String;
		protected var data:Object;
	}
}