package snow.mvc.interfaces
{

	public interface INotification
	{
		
		function getName():String;

		function setBody( body:Object ):void;
		
		function getBody():Object;
		
		function setType( type:String ):void;
		
		function getType():String;

		function toString():String;
	}
}