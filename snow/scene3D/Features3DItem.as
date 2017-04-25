package snow.scene3D 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;
	import com.greensock.TweenMax;
	import flash.events.EventDispatcher;
	import snow.event.Scene3DEvent;
	import snow.utils.debugDrag.Drag3DTool;
	import snow.utils.Handle;
	import snow.utils.XMLUtil;
	/**
	 * ...
	 * @author WebCity
	 */
	public class Features3DItem extends ObjectContainer3D 
	{
		protected var _config:XMLList
		protected var object3ds:Vector.<MD53DObject> = new Vector.<MD53DObject>
		public var dispatcher:EventDispatcher = new EventDispatcher()
		protected var _debug:Boolean
		protected var _drag3DTool:Drag3DTool
		public function Features3DItem() 
		{
			super();
		}	
		public function get config():XMLList 
		{
			return _config;
		}		
		public function set config(value:XMLList):void 
		{
			_config = value;
			if (_config.toString() == "") return;
			if (_config.toString() == "null")
			{
				empty()
				return;
			}
			empty()
			var length:int = _config.length();
			var temp:Object
			for (var i:int = 0; i <length; i++) 
			{
				temp = new Object();
				XMLUtil.attributesToObject(_config[i], temp)
				temp.xmllist = _config[i].children();
				var md53dObject:MD53DObject = new MD53DObject()
				md53dObject.extra=temp;
				md53dObject.mouseEnabled = true;
				md53dObject.name = temp.name;
				md53dObject.load(temp.url);
				md53dObject.addEventListener(MouseEvent3D.CLICK, onClick3D)
				md53dObject.addEventListener(MouseEvent3D.MOUSE_OVER, onOver3D)
				md53dObject.addEventListener(MouseEvent3D.MOUSE_UP, onUp3D)
				md53dObject.addEventListener(MouseEvent3D.MOUSE_OUT, onOut3D)
				md53dObject.addEventListener(MouseEvent3D.MOUSE_DOWN, onDown3D)
				Handle.initSpace(md53dObject,temp);
				addChild(md53dObject);
				object3ds.push(md53dObject)
			}
			upStatus()
		}	
		
		private function onDown3D(e:MouseEvent3D):void 
		{
		   var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
           TweenMax.to(obj3d, 0.3, { scaleX:0.9, scaleY:0.9, scaleZ:0.9 } )
		}		
		private function onOut3D(e:MouseEvent3D):void 
		{
		    var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
            TweenMax.to(obj3d,0.3,{scaleX:1,scaleY:1,scaleZ:1})
		}
		
		private function onUp3D(e:MouseEvent3D):void 
		{
			var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
           TweenMax.to(obj3d,0.3,{scaleX:1,scaleY:1,scaleZ:1})
		}
		
		private function onOver3D(e:MouseEvent3D):void 
		{
			var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
			TweenMax.to(obj3d,0.3,{scaleX:1.2,scaleY:1.2,scaleZ:1.2})
		}
		
		
		public function get debug():Boolean 
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void 
		{
			_debug = value;
			upStatus();
		}		
		public function get drag3DTool():Drag3DTool 
		{
			return _drag3DTool;
		}		
		public function set drag3DTool(value:Drag3DTool):void 
		{
			_drag3DTool = value;
		}
		protected function upStatus():void
		{
			if (_debug)
			{
				for (var i:int = 0; i <object3ds.length; i++) 
				{
					object3ds[i].addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown3D)
				}
			}else
			{
				for (var j:int = 0; j <object3ds.length; j++) 
				{
					object3ds[j].removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown3D)
				}
			}
		}		
		private function onMouseDown3D(e:MouseEvent3D):void 
		{
			if (_drag3DTool == null) return;
			_drag3DTool.object3D = ObjectContainer3D(e.currentTarget);
		}
		protected function empty():void
		{
			while (object3ds.length) 
			{
				object3ds[object3ds.length - 1].disposeAsset();
				object3ds.pop();
			}
			object3ds.length = 0;
		}
		private function onClick3D(e:MouseEvent3D):void 
		{
			if (_debug) return;			
			var tempObj:Object = ObjectContainer3D(e.currentTarget).extra;
			dispatcher.dispatchEvent(new Scene3DEvent(Scene3DEvent.CLICK3D,tempObj))
		}
		
	}

}