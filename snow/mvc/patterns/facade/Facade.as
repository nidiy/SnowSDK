package snow.mvc.patterns.facade
{

	import snow.mvc.core.*;
	import snow.mvc.interfaces.*;
	import snow.mvc.core.Controller;
	import snow.mvc.core.Model;
	import snow.mvc.core.View;
	import snow.mvc.interfaces.IController;
	import snow.mvc.interfaces.IFacade;
	import snow.mvc.interfaces.IMediator;
	import snow.mvc.interfaces.IModel;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.IProxy;
	import snow.mvc.interfaces.IView;
	import snow.mvc.patterns.observer.Notification;
	
	public class Facade implements IFacade
	{
	
		protected var _controller:IController;
		protected var _model:IModel;
		protected var _view	:IView;		
		protected static var instance:IFacade;		
		protected const SINGLETON_MSG:String = "Facade Singleton already constructed!";
		
		
		public function Facade( ) {
			
			initializeFacade();	
		}
		protected function initializeFacade(  ):void {
			initializeModel();
			initializeView();
			initializeController();
		}
		public static function getInstance():IFacade {
			instance = new Facade( );
			return instance;
		}
		protected function initializeController():void {
			controller = Controller.getInstance();
			controller.facade = this;
		}
		protected function initializeModel():void {
			model = Model.getInstance();
			model.facade = this;
		}
		protected function initializeView():void {
			view = View.getInstance();
			view.facade = this;
		}
		public function registerCommand(notificationName:String, commandClassRef:Class ):void 
		{
			controller.registerCommand(notificationName, commandClassRef );
		}
		public function removeCommand(notificationName:String ):void 
		{
			controller.removeCommand(notificationName );
		}
		public function hasCommand(notificationName:String ) : Boolean
		{
			return controller.hasCommand(notificationName);
		}
		public function registerProxy ( proxy:IProxy ):void	
		{
			model.registerProxy ( proxy );	
		}
		public function retrieveProxy ( proxyName:String ):IProxy 
		{
			return model.retrieveProxy ( proxyName );	
		}
		public function removeProxy ( proxyName:String ):IProxy 
		{
			var proxy:IProxy;
			if ( model != null) proxy = model.removeProxy ( proxyName );
			return proxy
		}
		public function hasProxy( proxyName:String ) : Boolean
		{
			return model.hasProxy( proxyName );
		}
		public function registerMediator( mediator:IMediator ):void 
		{
			if ( view != null ) view.registerMediator( mediator );
		}
		public function retrieveMediator( mediatorName:String ):IMediator 
		{
			return view.retrieveMediator( mediatorName ) as IMediator;
		}
		public function removeMediator( mediatorName:String ) : IMediator 
		{
			var mediator:IMediator;
			if ( view != null ) mediator = view.removeMediator( mediatorName );			
			return mediator;
		}
		public function hasMediator( mediatorName:String ) : Boolean
		{
			return view.hasMediator( mediatorName );
		}
		public function sendNotification( notificationName:String, body:Object=null, type:String=null ):void 
		{
			notifyObservers( new Notification( notificationName, body, type ) );
		}
		public function notifyObservers ( notification:INotification ):void {
			if ( view != null ) view.notifyObservers( notification );
		}		
		public function get controller():IController 
		{
			return _controller;
		}		
		public function set controller(value:IController):void 
		{
			_controller = value;
		}		
		public function get model():IModel 
		{
			return _model;
		}		
		public function set model(value:IModel):void 
		{
			_model = value;
		}		
		public function get view():IView 
		{
			return _view;
		}		
		public function set view(value:IView):void 
		{
			_view = value;
		}
	
	}
}