package snow.mvc.interfaces
{
	import snow.mvc.interfaces.IFacade
	public interface INotifier
	{
		function sendNotification( notificationName:String, body:Object = null, type:String = null ):void;
		function get facade():IFacade 
		function set facade(value:IFacade):void 
	}
}