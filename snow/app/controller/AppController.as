package snow.app.controller 
{
	import snow.app.core.App;
	import snow.app.core.AppSprite;
	import snow.app.core.IActiveMediator;
	import snow.app.core.IAppSprite;
	import snow.mvc.interfaces.ICommand;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.INotifier;
	/**
	 * ...
	 * @author HBinNet
	 */
	public class AppController extends AppSprite implements ICommand, INotifier,IAppSprite
	{
		protected var application:App
		protected var _control:IActiveMediator
		protected var _facade:IFacade
		//default top  bottom
		public function AppController() 
		{
			super()
		}		
		public function execute(notification:INotification):void 
		{
			this.application = this.facade as App;
			this.application.addControll(this);
			this.application.addChild(this);
		}
		public function sendNotification( notificationName:String, body:Object = null, type:String = null ):void
		{
			if (this.application) this.application.sendNotification(notificationName, body, type);
		}
		
		public function get facade():IFacade 
		{
			return _facade
		}
		public function set facade(value:IFacade):void
		{
			if (_facade == value) return;
			_facade = value;
		}
		public function refreshScale():void
		{
			
		}
	}
}