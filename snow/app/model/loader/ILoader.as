package snow.app.model.loader 
{
	import snow.app.model.DataProvider;
	
	/**
	 * ...
	 * @author 
	 */
	public interface ILoader 
	{
		function close():void
		function start():void
		function pause():void
		function unload():void
		
		function set dataProvider(value:DataProvider):void
		function get dataProvider():DataProvider;
		
		function find(value:String):Boolean;
		function loadID(value:String):void
	}
	
}