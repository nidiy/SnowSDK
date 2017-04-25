package snow.scene3D.hotObject 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D
	import flash.events.Event;
	import snow.scene3D.hotObject.items.MovieItme;
	import snow.scene3D.hotObject.items.ObjectItme;
	public class HotMovie extends Hot
	{
		public function HotMovie() 
		{
			super();
		}		
		override public function set data(value:XMLList):void
		{
			_data = value;
			length = _data.length();
			for (var i:int = 0; i <length; i++) 
			{
				var objMovie:Object = new Object();
				var movieItme:MovieItme = new MovieItme();
				
				objMovie.id = value[i].@id;
				objMovie.label = value[i].@label;
				objMovie.url = value[i].@url.toString();
				objMovie.volume =value[i].@volume;
				
				objMovie.width = value[i].@width;
				objMovie.height = value[i].@height;
				
				objMovie.videoWidth = value[i].@videoWidth;
				objMovie.videoHeight = value[i].@videoHeight;
				
				objMovie.tip = value[i].@tip;
				
				movieItme.x = objMovie.x = value[i].@x;
				movieItme.y = objMovie.y = value[i].@y;
				movieItme.z = objMovie.z = value[i].@z;
				
				movieItme.rotationX = objMovie.rotationX = value[i].@rotationX;
				movieItme.rotationY = objMovie.rotationY = value[i].@rotationY;
				movieItme.rotationZ = objMovie.rotationZ = value[i].@rotationZ;
				
				
				
				movieItme.data = objMovie;
				itmeGroup.push(movieItme)
				this.addChild(movieItme)
				movieItme.addEventListener(MouseEvent3D.CLICK, onClick3D)
			}
			this.dispatchEvent(new Event(Event.COMPLETE,true));
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