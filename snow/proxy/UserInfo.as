package snow.proxy 
{
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;	
	import ghostcat.events.PropertyChangeEvent;
	import ghostcat.util.Util;
	import ghostcat.util.data.LocalStorage;
	import ghostcat.util.data.ObjectProxy;	
	import snow.event.UserEvent;	
	[Event(name = "sign_in", type = "snow.event.UserEvent;")]
	[Event(name = "sign_out", type = "snow.event.UserEvent;")]
	[Event(name = "property_change", type = "ghostcat.events.PropertyChangeEvent")]
	/**
	 * ...
	 * @author Tim
	 */
	public class UserInfo extends EventDispatcher
	{
		private static const key:String = "16446ce0-7fec-49f8-bcf6-c023cabdadf6";
		
		public static var isLogin:Boolean = false;
		public static var instance:UserInfo = null;
		//初始化管理器
		public static function init():UserInfo
		{
			if (instance) return instance;
			instance = new UserInfo();
			return instance;
		}
		private var _token:String =null;		
		private var _data:Object = null;
		private var objectProxy:ObjectProxy = null;
		private var localStorage:LocalStorage;
		private var typelocalStorage:LocalStorage;
		public function UserInfo() 
		{
			localStorage = new LocalStorage("token");
			typelocalStorage=new LocalStorage("loginType")
		}
		private function onPropertyChangeHandler(event:PropertyChangeEvent):void 
		{
			event.source = null;
			duplicate[event.property] = _data[event.property];
			var clone:PropertyChangeEvent = event.clone() as PropertyChangeEvent;
			clone.source = null;
			this.dispatchEvent(clone);
		}
		/**
		 * 需要key密钥才能更新用户信息;
		 * @param	value
		 * @param	key
		 */
		public function updata(value:Object):void
		{
			if (value == null) return;
			if (objectProxy)
			{
				objectProxy.data = null;
				objectProxy.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChangeHandler)
				objectProxy = null;
			}
			_data = value;
			_token = _data.token;
			//成生一个数据副本
			duplicate = Util.copy(_data);
			localStorage.setValue(_token);
			objectProxy = new ObjectProxy(_data);
			objectProxy.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,onPropertyChangeHandler);
			isLogin = true;
			this.dispatchEvent(new UserEvent(UserEvent.SIGN_IN,uid,nickname,this.data));
		}
		/**
		 * 用户退出时调用此方法
		 * @param	key
		 */
		public function quit(key:String):void
		{
			if (objectProxy)
			{
				objectProxy.data = null;
				objectProxy.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChangeHandler)
				objectProxy = null;
			}
			this.dispatchEvent(new UserEvent(UserEvent.SIGN_OUT,uid, nickname));
			isLogin = false;				
			localStorage.setValue(null);
			localStorage.sharedObject.clear()
			_token = null;
			_data = null;
			duplicate = null;
		}
		/**
		 * 用户数据需密码
		 * @param	key
		 * @return
		 */
		public function getData(key:String):Object
		{
			return objectProxy;
		}
		/**
		 * 用户的Token
		 */
		public function get token():String 
		{
			if (_token!=null) 
			{
				return _token;
			}	
			trace("从本地记录中读取");
			return localStorage.getValue();
		}	
		/**
		 * 用户ID
		 */
		public function get uid():String 
		{
			return duplicate.id;
		}	
		/**
		 * 用户名称
		 */
		public function get name():String 
		{
			return duplicate.name;
		}
		/**
		 * 头像
		 */
		public function get headimgurl():String
		{
			return duplicate.headimgurl;
		}		
		/**
		 * 头像
		 */
		public function get head():String
		{
			return duplicate.headimgurl;
		}
		private var duplicate:Object
		/**
		 * 用户数据副本
		 * 数据为 Object类型，具体数据时请取data的属性 如: var image:ImageLoader= new ImageLoader();
		 * image.source=data.source;
		 * 具体字段，请查看数据字段表;
		 */
		public function get data():Object 
		{
			return Util.copy(_data);
		}
		/**
		 * 用户类型
		 */
		public function get type():int 
		{
			return duplicate.type;
		}
		/**
		 * 登录类型   0 游客|1微信
		 */
		public function get loginType():int 
		{
			return int(typelocalStorage.getValue());
		}
		/**
		 * 性别  1为男性，2为女性
		 */
		public function get sex():uint 
		{
			return duplicate.sex;
		}
		/**
		 * 昵称
		 */
		public function get nickname():String 
		{
			return duplicate.nickname;
		}
		/**
		 * 省份
		 */
		public function get province():String 
		{
			return duplicate.province;
		}
		/**
		 * 城市
		 */
		public function get city():String 
		{
			return duplicate.city;
		}		
		/**
		 *国家
		 */
		public function get country():String 
		{
			return duplicate.country;
		}	
		/**
		 * 语言
		 */
		public function get language():String 
		{
			return duplicate.language;
		}
	}
}