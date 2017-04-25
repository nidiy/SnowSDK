package snow.utils.debugDrag 
{
	/**
	 * ...
	 * @author 
	 */
	public interface IDrag 
	{
		function get data():Object
		function set data(value:Object):void
		
		function get updata():Function
		function set updata(value:Function):void
	}

}