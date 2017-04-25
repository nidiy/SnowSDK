package snow.scene3D.hotObject 
{
	import away3d.containers.ObjectContainer3D
	import away3d.materials.lightpickers.StaticLightPicker;
	import snow.scene3D.hotObject.items.ObjectItme;
	import snow.utils.debugDrag.Drag3DTool;
	/**
	 * Webcity3Dv1.0热点基类
	 * @author ...
	 */
	public class Hot extends ObjectContainer3D implements IHot
	{
		
		protected var _data:XMLList
		protected var length:int = 0;
		protected var itmeGroup:Vector.<ObjectItme> = new Vector.<ObjectItme>();
		protected var _debug:Boolean
		protected var _drag3DTool:Drag3DTool=null
		protected var _staticLightPicker:StaticLightPicker
		public function Hot() 
		{
			super();
		}
	    public function get data():XMLList
		{
			return _data;
		}
		public function set data(value:XMLList):void
		{
			_data = value;
		}
		public function get debug():Boolean
		{
			return _debug
		}
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		public function get drag3DTool():Drag3DTool 
		{
			return _drag3DTool;
		}
		
		public function set drag3DTool(value:Drag3DTool):void 
		{
			_drag3DTool = value;
		}
		public function updata():void
		{
			
		}		
		public function get staticLightPicker():StaticLightPicker 
		{
			return _staticLightPicker;
		}
		
		public function set staticLightPicker(value:StaticLightPicker):void 
		{
			_staticLightPicker = value;
		}
		override public function disposeAsset():void 
		{
			super.disposeAsset();
			var dis:ObjectContainer3D
			while (itmeGroup.length>0)
			{
				dis = itmeGroup[itmeGroup.length - 1];
				dis.parent.removeChild(dis)
				dis.disposeAsset();
				itmeGroup.pop()
				dis=null
			}
		}
	}

}