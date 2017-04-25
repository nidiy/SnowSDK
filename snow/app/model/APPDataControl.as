package snow.app.model 
{
	import snow.app.core.App;
	import snow.app.core.Info;
	import snow.app.model.DataControl;
	import snow.utils.XMLUtil;
	/**
	 * ...
	 * @author 
	 */
	public class APPDataControl extends DataControl 
	{
		protected var _info:Info;
		protected var ascriptLoader:AScriptLoader
		protected var app:App;
		public function APPDataControl(name:String,data:Object) 
		{
			super(name,data)
			ascriptLoader=new AScriptLoader()
		}
		override protected function loadAppData():void 
		{
			initAppInfo();
			loadAscript(_config.ascript.children());
			super.loadAppData();
		}	
		protected function initAppInfo():void
		{
			var tempinfo:Info = new Info();
			tempinfo.name =_config.name.toString();
			tempinfo.id = _config.id.toString();
			tempinfo.appClass = _config.appClass.toString();
			tempinfo.version =_config.version.toString();
			tempinfo.developers =_config.developers.toString();
			tempinfo.description = _config.description.toString();
			tempinfo.debug = (_config.debug.toString() == "true"?true:false);
			tempinfo.configURL=_configURL
			var icons:XMLList = _config.icons.children();
			var length:int = icons.length();
			for (var i:int = 0; i <length; i++) 
			{
				tempinfo.logos.push(String(icons[i]));
			}
			info = tempinfo
		}
		public var defaultClass:String = "";
		public function loadAscript(children:XMLList):void 
		{
			var length:int = children.length();
			for (var i:int = 0; i < length; i++)
			{
				var item:Object = { };
				XMLUtil.attributesToObject(children[i], item)
				if (!(item.urlType && item.urlType == "all"))
				{
					
					item.url= this.PATH+item.url;
				}	
				if (item.defaultClass&&item.defaultClass != "")
				{
					defaultClass = item.defaultClass;
				}
				ascriptLoader.enqueue(item.url);
			}
		}
		override protected function onDataProgress(value:Number):void 
		{
			if (app.onProgress!=null) app.onProgress(value);
			if (value >= 1)
			{
				if (ascriptLoader.length > 0)
				{
					ascriptLoader.loadQnqueue(ascriptLoaderComplete);
				}else
				{
					ascriptLoaderComplete();
				}
			}
		}
		protected function ascriptLoaderComplete():void
		{
			if (this.onDataComplete != null)
			{
				this.onDataComplete();
				
			}else if (this.app.onDataComplete != null) 
			{
				this.app.onDataComplete();
			}
		}
		override public function onRegister():void 
		{
			super.onRegister();
			app = this.facade as App;
			this.loadConfig(data as String);
		}
		
		public function get info():Info 
		{
			return _info;
		}
		
		public function set info(value:Info):void 
		{
			_info = value;
			this.app.info = _info;
		}
		override public function onRemove():void 
		{
			ascriptLoader = null;
			this.app = null;
			this._info = null;
			super.onRemove();
		}
	}

}