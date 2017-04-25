package snow.app.core 
{
	import snow.mvc.interfaces.IMediator;
	/**
	 * ...
	 * @author WebCity3D
	 */
	public interface IActiveMediator extends IMediator
	{
		function setSize(newWidth:Number,newHeigth:Number):void
		
		function updata():void
		function onRender():void
		
	     /**
		 * 是锁定false为解锁,true为锁定
		 */
		function set lock(value:Boolean):void
		function get lock():Boolean		
		
		function set activation(value:Boolean):void
		function get activation():Boolean
		
		function set x(value:Number):void
		function get x():Number
		
		function set y(value:Number):void
		function get y():Number
		
		function set autoSize(value:Boolean):void
		function get autoSize():Boolean
		/**
		 * 清除所有对像及资源
		 */
		function dispose():void	
		
	}

}