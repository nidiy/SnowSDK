package snow.scene3D.hotObject 
{
	import away3d.containers.ObjectContainer3D;
    import away3d.events.MouseEvent3D;
	import flash.events.Event;
	import snow.scene3D.hotObject.items.Spot;
	/**
	 * ...
	 * @author ...
	 */
	public class HotSpot extends Hot 
	{
		protected var content:int = 0;
		public function HotSpot() 
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
				objSpot.id = value[i].@id;
				objSpot.label = value[i].@label;
				objSpot.url = value[i].@url;
				
				objSpot.x = value[i].@x;
				objSpot.y = value[i].@y;
				objSpot.z = value[i].@z;
				
				objSpot.rotationX = value[i].@rotationX;
				objSpot.rotationY = value[i].@rotationY;
				objSpot.rotationZ = value[i].@rotationZ;
				objSpot.width = value[i].@width;
				objSpot.height = value[i].@height;
				var spot:Spot = new Spot();
				spot.addEventListener(Event.COMPLETE,onComplete)
				itmeGroup.push(spot)
				spot.data = objSpot;
				spot.x = objSpot.x;
				spot.y = objSpot.y;
				spot.z = objSpot.z;
				spot.rotationX = objSpot.rotationX;
				spot.rotationY = objSpot.rotationY;
				spot.rotationZ = objSpot.rotationZ;
				this.scene.addChild(spot)
				spot.addEventListener(MouseEvent3D.CLICK, onClick3D)
			}
		}		
		private function onComplete(e:Event):void 
		{
			content++
			if (content >= length)
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
			
		}
		private function onMouseDown(e:MouseEvent3D):void
		{
			_drag3DTool.object3D =ObjectContainer3D(e.target);
		}
		
	}

}