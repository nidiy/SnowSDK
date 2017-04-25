package snow.mvc.interfaces
{

	public interface IFacade
	{
		function sendNotification( notificationName:String, body:Object = null, type:String = null ):void;
		
		function registerProxy( proxy:IProxy ) : void;
		
		function retrieveProxy( proxyName:String ) : IProxy;
		
		function removeProxy( proxyName:String ) : IProxy;
		
		function hasProxy( proxyName:String ) : Boolean;
		
		function registerCommand( noteName : String, commandClassRef : Class ) : void;
		
		function removeCommand( notificationName:String ): void;
		
		function hasCommand( notificationName:String ) : Boolean;
		
		function registerMediator(mediator:IMediator ) : void;
		
		function retrieveMediator(mediatorName:String ) : IMediator;
		
		function removeMediator( mediatorName:String ) : IMediator;
		
		function hasMediator( mediatorName:String ) : Boolean;
		
		function get controller():IController 		
		function set controller(value:IController):void 
		
		function get model():IModel 		
		function set model(value:IModel):void 	
		
		function get view():IView 	
		function set view(value:IView):void 

	}
}