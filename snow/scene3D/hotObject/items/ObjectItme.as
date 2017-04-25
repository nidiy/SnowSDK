package snow.scene3D.hotObject.items 
{
	import away3d.bounds.BoundingVolumeBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.lightpickers.StaticLightPicker;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout
	import flash.utils.clearTimeout;
	/**
	 * ...
	 * @author FDTest
	 */
	public class ObjectItme extends ObjectContainer3D 
	{
		protected var _data:Object;
		protected var _staticLightPicker:StaticLightPicker;
		protected var _view3d:View3D;
		protected var _isVR:Boolean;
		protected var _worldBounds:BoundingVolumeBase = null;
		public function ObjectItme() 
		{
			super()
		}
		override public function set mouseChildren(value:Boolean):void
		{
			super.mouseChildren = value;
			for (var i:int = 0; i < this.numChildren; i++)
			{
				getChildAt(i).mouseEnabled=value;
			}
		}	
		override public function disposeAsset():void 
		{
			super.disposeAsset();
			while (this.numChildren > 0)
			{
			   getChildAt(this.numChildren-1).disposeAsset()
			}
		}
		public function stop():void
		{
			
		}
		public function play():void
		{
			
		}
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
		}		
		public function get staticLightPicker():StaticLightPicker 
		{
			return _staticLightPicker;
		}		
		public function set staticLightPicker(value:StaticLightPicker):void 
		{
			_staticLightPicker = value;
		}
		public function get view3d():View3D 
		{
			return _view3d;
		}		
		public function set view3d(value:View3D):void 
		{
			_view3d = value;
		}
		
		public function get isVR():Boolean 
		{
			return _isVR;
		}
		
		public function set isVR(value:Boolean):void 
		{
			_isVR = value;
		}
		
		public function get worldBounds():BoundingVolumeBase 
		{
			return _worldBounds;
		}
		
		public function set worldBounds(value:BoundingVolumeBase):void 
		{
			_worldBounds = value;
		}
		protected var timeID:uint = 0;
		protected var timeDownID:uint = 0;
		protected var isTest:Boolean = false;
		protected var isOver:Boolean = false;
		public function hitTest():void 
		{
			//if (!mouseEnabled) return;
			if (!_isVR) return;
			if (worldBounds == null) return;			
			var point:Point = new Point(_view3d.width / 2, _view3d.height / 2);
			var maxvector3D:Vector3D = _view3d.project(worldBounds.max)
			maxvector3D.x += maxvector3D.x;
			var minvector3D:Vector3D = _view3d.project(worldBounds.min)
			minvector3D.x += minvector3D.x;
			var rect:Rectangle = new Rectangle(minvector3D.x, maxvector3D.y, (maxvector3D.x - minvector3D.x), (minvector3D.y - maxvector3D.y));
			if (rect.containsPoint(point))
			{
				if (isTest) return;
				isTest = true;
				timeID = setTimeout(sendClick3D, 2000)
				timeDownID=setTimeout(sendDown3D, 1200)
				this.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OVER));
				isOver = true;
				
			}else
			{
				isTest = false;
				clearTimeout(timeID);
				if (isOver)
				{
					isOver = false;
				    this.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT));
				}
			}
		}		
		private function sendDown3D():void 
		{
			clearTimeout(timeDownID);
			if (isOver) this.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_DOWN));
		}
		public function sendClick3D():void
		{
			clearTimeout(timeID);
			if(isOver)this.dispatchEvent(new MouseEvent3D(MouseEvent3D.CLICK))
			
		}
	}

}