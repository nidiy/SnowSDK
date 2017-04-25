package snow.app.core 
{
	import parser.Script;
	import snow.app.event.AppEvent;
	import snow.app.model.APPDataControl;
	/**
	 * ...
	 * @author tim
	 */
	public class AScriptWebApp extends WebApp 
	{
		private var _scriptURL:String
		private var appdataControl:APPDataControl;
		public function AScriptWebApp() 
		{
			super()
		}
		override protected function initMilieu():void 
		{
			this.initializeFacade();
			trace("AScriptWebApp=>initMilieu");
			runApp();
		}	
		public function runApp():void
		{
			this.onDataComplete = loadAppComplete
			appdataControl = new APPDataControl("APPDataControl",_scriptURL);
			this.registerProxy(appdataControl)
		}		
		protected function loadAppComplete():void
		{
			super.initMilieu();
			if (appdataControl.defaultClass != "")Script.New(appdataControl.defaultClass,this);		    
			this.dispatchEvent(new AppEvent(AppEvent.APP_COMPLETE,info));
		}
		override public function dispose():void
		{
			this.removeProxy("APPDataControl");
			appdataControl = null;
			super.dispose();
		}		
		public function get scriptURL():String 
		{
			return _scriptURL;
		}		
		public function set scriptURL(value:String):void 
		{
			_scriptURL = value;
		}
		
	}

}