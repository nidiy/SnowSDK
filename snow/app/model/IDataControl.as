package snow.app.model 
{
	import snow.app.core.App;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IDataControl
	{
		function set config(value:XML):void
		function get config():XML
	}
	
}