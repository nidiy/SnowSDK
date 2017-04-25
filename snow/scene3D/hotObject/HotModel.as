package snow.scene3D.hotObject 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;
	import flash.events.Event;
	import snow.scene3D.hotObject.items.ModelItme;
	import snow.scene3D.hotObject.items.ObjectItme;
	
	public class HotModel extends Hot
	{
		protected var cont:int = 0;
		public function HotModel() 
		{
			super();
		}	
		protected var modelItme:ModelItme
		override public function set data(value:XMLList):void
		{
		   _data = value;
		  length = value.length();
		  var j:int = 0;
		  var i:int = 0;
		  for (i = 0; i < length; i++) 
		  {
			  modelItme = new ModelItme();
			  modelItme.addEventListener(Event.COMPLETE,onComplete)
			  itmeGroup.push(modelItme);
			  var objModel:Object = new Object();
			  objModel.id = value[i].@id;
			  objModel.label = value[i].@label;
			  objModel.openLight=value[i].@openLight;
			  objModel.url = value[i].@url.toString();
			  
			  modelItme.x = objModel.x = int(value[i].@x);
			  modelItme.y = objModel.y = int(value[i].@y);
			  modelItme.z = objModel.z = int(value[i].@z);
			  
			  modelItme.rotationX=objModel.rotationX = value[i].@rotationX;
			  modelItme.rotationZ=objModel.rotationZ = value[i].@rotationZ;
			  modelItme.rotationY=objModel.rotationY = value[i].@rotationY;
			  
			  modelItme.scaleX=objModel.scaleX = value[i].@scaleX;
			  modelItme.scaleY=objModel.scaleY = value[i].@scaleY;
			  modelItme.scaleZ=objModel.scaleZ = value[i].@scaleZ;
			  
			  objModel.alphaBlending = value[i].@alphaBlending;
			  objModel.mipmap = value[i].@mipmap;
			  objModel.mouseEnabled = value[i].@mouseEnabled;
			  
			  objModel.tip = value[i].@tip;		  
			  
			  objModel.rotBool = value[i].@rotBool;
			  var mapXmlList:XMLList = value[i].child("map").children()
			  var maplength:int = mapXmlList.length();
			  for (j= 0; j <maplength; j++)
			  {
				  objModel[mapXmlList[j].@name] = mapXmlList[j].@value;
			  }
			  objModel.Motion = value[i].child("Motion").children();
			  modelItme.data = objModel;
			  this.addChild(modelItme);
			  modelItme.addEventListener(MouseEvent3D.CLICK, onClick3D)
			}
		}		
		private function onComplete(e:Event):void 
		{
			cont++
			if (cont >= length)
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
				  itmeGroup[i].addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
				itmeGroup[i].staticLightPicker = _staticLightPicker;
			}
		}
		private function onClick3D(e:MouseEvent3D):void
		{
			
		}
		private function onMouseDown(e:MouseEvent3D):void
		{
			_drag3DTool.object3D =ObjectContainer3D(e.target);
		}
		override public function disposeAsset():void 
		{
			if(modelItme)modelItme.removeEventListener(Event.COMPLETE,onComplete)
			super.disposeAsset();
		}
		
	}

}