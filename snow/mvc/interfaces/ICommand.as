package snow.mvc.interfaces
{
	public interface ICommand
	{
		function execute(notification:INotification):void;
		function get facade():IFacade 		
		function set facade(value:IFacade):void 
	}
}