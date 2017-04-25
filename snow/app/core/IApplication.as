package snow.app.core 
{
	import flash.display.BitmapData;
	import snow.app.controller.AppController;
	import snow.app.controller.IAppController;
	import snow.app.core.Info;
	import snow.mvc.interfaces.IFacade;
	/**
	 * ...
	 * @author HBinNet
	 */
	public interface IApplication extends IFacade 
	{
		/**
		 * 获取APP信息
		 */
		function close():void		
	    function set path(value:String):void
		function get path():String
		
		function set indexAt(value:int):void
		function get indexAt():int
		
	    function set info(value:Info):void
		function get info():Info
		function stop():void
		function play():void		
		function snapshot():BitmapData
		function addControll(value:AppController):void
	}

}