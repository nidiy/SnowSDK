package snow.app.core 
{
	/**
	 * ...
	 * @author YouJiMap
	 */
	public interface IAppSprite
	{
		
		/**
		 * 状态控制activation为false为不激活，true为激活
		 */
		function set activation(value:Boolean):void
		function get activation():Boolean
		/**
		 * 是锁定false为解锁,true为锁定
		 */
		function set lock(value:Boolean):void
		function get lock():Boolean
		/**
		 * 刷新APP
		 */
		function updata():void
		function onRender():void
		function setSize(newWidth:Number,newHeigth:Number):void
		/**
		 * 清除所有对像及资源
		 */
		function dispose():void		
	}

}