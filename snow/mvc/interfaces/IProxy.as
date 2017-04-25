package snow.mvc.interfaces
{
	
	public interface IProxy
	{
		

		function getProxyName():String;
		
		function setData( data:Object ):void;
		
		function getData():Object; 
		
		function onRegister( ):void;

		function onRemove( ):void;
		
	    function get facade():IFacade 
		
		function set facade(value:IFacade):void 
	}
}