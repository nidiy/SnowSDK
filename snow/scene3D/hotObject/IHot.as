package snow.scene3D.hotObject 
{
	import away3d.materials.lightpickers.StaticLightPicker;
	import snow.utils.debugDrag.Drag3DTool;
	
	public interface IHot
	{
		function get data():XMLList
		function set data(value:XMLList):void
		
		function get debug():Boolean
		function set debug(value:Boolean):void
		
		
	    function get drag3DTool():Drag3DTool 
		function set drag3DTool(value:Drag3DTool):void    
		
		function get staticLightPicker():StaticLightPicker 
		function set staticLightPicker(value:StaticLightPicker):void 		
		
		function updata():void
	}
	
}