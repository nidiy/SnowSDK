package snow.mvc.core
{
	import snow.mvc.core.*;
	import snow.mvc.interfaces.*;
	import snow.mvc.patterns.observer.*;
	import snow.mvc.interfaces.ICommand;
	import snow.mvc.interfaces.IController;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.INotification;
	
	public class Controller implements IController
	{
		protected const SINGLETON_MSG : String = "Controller Singleton already constructed!";
		protected static var instance : IController;
		public static function getInstance() : IController
		{
			instance = new Controller( );
			return instance;
		}		
		protected var _facade:IFacade
		public function Controller()
		{
			commandMap = new Array();
		}
		protected function initializeController() : void 
		{
			this.facade.view = View.getInstance();
		}
		public function executeCommand( note : INotification ) : void
		{
			var commandClassRef:Class =commandMap[note.getName()];
			if (commandClassRef == null) return;

			var commandInstance:ICommand = new commandClassRef() as ICommand;
			commandInstance.facade = this.facade;
			commandInstance.execute(note);
		}
		public function registerCommand( notificationName : String, commandClassRef : Class ) : void
		{
			if (this.facade == null) return;
			if (this.facade.view == null) initializeController();
			if ( commandMap[ notificationName ] == null ) {
				this.facade.view.registerObserver( notificationName, new Observer( executeCommand, this ) );
			}
			commandMap[ notificationName ] = commandClassRef;
		}
		public function hasCommand(notificationName:String ) : Boolean
		{
			return commandMap[ notificationName ] != null;
		}
		public function removeCommand( notificationName : String ) : void
		{
			commandMap[ notificationName ] = null;
		}
		protected var commandMap:Array;		
		
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