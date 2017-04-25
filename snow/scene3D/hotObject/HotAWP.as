package snow.scene3D.hotObject 
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;
	
	import ghostcat.util.data.XMLUtil;
	
	import snow.scene3D.hotObject.Hot;
	import snow.scene3D.hotObject.items.AWPItem;
	import snow.scene3D.hotObject.items.ObjectItme;

	/**
	 * ...
	 * @author ...
	 */
	public class HotAWP extends Hot 
	{
		protected var cont:int = 1;
		public var onClickHandler:Function
		public function HotAWP() 
		{
			super();
		}		
		override public function set data(value:XMLList):void 
		{
			_data = value;
		    length = value.length();
			for (var i:int = 0; i <length; i++) 
			{
				var objSpot:Object = new Object();				
				XMLUtil.attributesToObject(value[i], objSpot)
				XMLUtil.xmlToObject(value[i], objSpot)
				if (objSpot.data)
				{
					objSpot.data = new Object()
					XMLUtil.xmlToObject(XML(value[i].data), objSpot.data)
				}				
				var spot:AWPItem = new AWPItem();
				spot.addEventListener(Event.COMPLETE,onComplete,true)
				itmeGroup.push(spot)
				spot.data = objSpot;
				
				spot.x = objSpot.x;
				spot.y = objSpot.y;
				spot.z = objSpot.z;
				
				spot.rotationX = objSpot.rotationX;
				spot.rotationY = objSpot.rotationY;
				spot.rotationZ = objSpot.rotationZ;
				
				spot.scaleX = objSpot.scaleX;				
				spot.scaleY = objSpot.scaleY;
				spot.scaleZ = objSpot.scaleZ;
				
				this.addChild(spot)
				spot.addEventListener(MouseEvent3D.CLICK, onClick3D)
				spot.addEventListener(MouseEvent3D.MOUSE_OVER, onOver3D)
				spot.addEventListener(MouseEvent3D.MOUSE_UP, onUp3D)
				spot.addEventListener(MouseEvent3D.MOUSE_OUT, onOut3D)
				spot.addEventListener(MouseEvent3D.MOUSE_DOWN, onDown3D)
			}
		}		
		private function onDown3D(e:MouseEvent3D):void 
		{
		   var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
		   	if (!isInitScale)
			{
				isInitScale = true;
				initScaleX=obj3d.scaleX
				initScaleY=obj3d.scaleY
				initScaleZ=obj3d.scaleZ
			}
           TweenMax.to(obj3d, 0.3, { scaleX:initScaleX-0.1, scaleY:initScaleY-0.1, scaleZ:initScaleZ-0.1 } );
		}		
		private function onOut3D(e:MouseEvent3D):void 
		{
		    var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
            TweenMax.to(obj3d,0.3,{scaleX:initScaleX,scaleY:initScaleY,scaleZ:initScaleZ})
		}
		
		private function onUp3D(e:MouseEvent3D):void 
		{
			var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
           TweenMax.to(obj3d,0.3,{scaleX:initScaleX,scaleY:initScaleY,scaleZ:initScaleZ})
		}
		protected var initScaleX:Number = 1
		protected var initScaleY:Number = 1
		protected var initScaleZ:Number = 1
		
		protected var isInitScale:Boolean = false;
		private function onOver3D(e:MouseEvent3D):void 
		{
			var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
			if (!isInitScale)
			{
				isInitScale = true;
				initScaleX=obj3d.scaleX
				initScaleY=obj3d.scaleY
				initScaleZ=obj3d.scaleZ
			}
			TweenMax.to(obj3d, 0.3, { scaleX:initScaleX + 0.2, scaleY:initScaleY + 0.2, scaleZ:initScaleZ + 0.2} );
		}
		
		private function onComplete(e:Event):void 
		{
			cont++
			if (cont <= length)
			{
				this.dispatchEvent(new Event(Event.COMPLETE,true));
			}
		}
		override public function updata():void
		{
			var length:int = itmeGroup.length;
			for (var i:int = 0; i < length; i++) 
			{
				if(_debug)
				  itmeGroup[i].addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown)
			}
		}
		private function onClick3D(e:MouseEvent3D):void
		{
			if (!_debug && onClickHandler != null)
			{
				ObjectItme(e.target).removeEventListener(MouseEvent3D.CLICK, onClick3D)			
				onClickHandler(ObjectItme(e.target).data)
				ObjectItme(e.target).addEventListener(MouseEvent3D.CLICK, onClick3D)
			}
		}
		private function onMouseDown(e:MouseEvent3D):void
		{
			_drag3DTool.object3D =ObjectContainer3D(e.target);
		}
		
	}

}