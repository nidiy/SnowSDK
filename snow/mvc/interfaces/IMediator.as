package snow.mvc.interfaces
{
	

	public interface IMediator
	{
		
		function getMediatorName():String;
		
		function getViewComponent():Object;
		
		function setViewComponent( viewComponent:Object ):void;
		
		function listNotificationInterests( ):Array;
		
		function handleNotification( notification:INotification ):void;
		
		function onRegister( ):void;
		
		function onRemove( ):void;
		
	    function get facade():IFacade 
		function set facade(value:IFacade):void 
		
	}
}