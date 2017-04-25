package snow.mvc.interfaces
{
	
	public interface IView 
	{

		function registerObserver ( noteName:String, observer:IObserver ) : void;
		function notifyObservers( note:INotification ) : void;		
		function registerMediator( mediator:IMediator ) : void;
		function retrieveMediator( mediatorName:String ) : IMediator;
		function removeMediator( mediatorName:String ) : IMediator;		
		function hasMediator( mediatorName:String ) : Boolean;		
		function get facade():IFacade		
		function set facade(value:IFacade):void 
		
	}
	
}