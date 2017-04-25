package snow.mvc.core
{
	import snow.mvc.interfaces.IModel;
	import snow.mvc.interfaces.IProxy;
	
	import snow.mvc.interfaces.*;
	import snow.mvc.interfaces.IFacade;
	public class Model implements IModel
	{
		protected static var instance:IModel;
		protected const SINGLETON_MSG:String = "Model Singleton already constructed!";
		
		public static function getInstance() : IModel 
		{
			instance = new Model( );
			return instance;
		}
		
		protected var _facade:IFacade
		protected var proxyMap:Array;
		public function Model( )
		{
			proxyMap = new Array();	
			initializeModel();
		}
		protected function initializeModel():void 
		{
			
		}
		public function registerProxy(proxy:IProxy):void
		{
			if (proxy.facade == null) proxy.facade = this.facade;
			proxyMap[proxy.getProxyName()] = proxy;
			proxy.onRegister();
		}
		public function retrieveProxy( proxyName:String ):IProxy
		{
			return proxyMap[ proxyName ];
		}
		public function hasProxy(proxyName:String):Boolean
		{
			return proxyMap[ proxyName ] != null;
		}
		public function removeProxy(proxyName:String) : IProxy
		{
			var proxy:IProxy = proxyMap [proxyName] as IProxy;
			proxyMap[proxyName] = null;
			proxy.onRemove();
			return proxy;
		}		
		public function get facade():IFacade 
		{
			return _facade;
		}		
		public function set facade(value:IFacade):void 
		{
			_facade = value;
		}

	}
}