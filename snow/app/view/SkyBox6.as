package snow.app.view 
{
	import adobe.utils.CustomActions;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry
	import away3d.textures.BitmapTexture;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import snow.app.utils.TextureTool;
	import flash.utils.setTimeout
	/**
	 * ...
	 * @author HBin
	 */
	public class SkyBox6 extends ObjectContainer3D 
	{
		protected var _bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>();
		protected var boxPlanes:Vector.<BoxPlane> = new Vector.<BoxPlane>;
		protected var spaceDataList:Vector.<Object> = new Vector.<Object>;
		public var URL:String = ""
		//加载顺序
		protected var sequence:Array = [2, 3, 1, 0, 4, 5];
		protected var _source:String = ""
		protected var miniImageLoader:Loader
		public function SkyBox6(value:int=2048) 
		{
			var spaceData1:Object = new Object();
			spaceData1.x = 0;
			spaceData1.y = 1;
			spaceData1.z = 0;
			spaceData1.rotationX = 180;
			spaceData1.rotationY = 180;
			spaceData1.rotationZ = 0;
			spaceDataList.push(spaceData1)			
			
			var spaceData2:Object = new Object();
			spaceData2.x = 1;
			spaceData2.y = 0;
			spaceData2.z = 0;
			spaceData2.rotationZ = 90;
			spaceData2.rotationX = 0;
			spaceData2.rotationY = 90;
			spaceDataList.push(spaceData2)
			
			
			var spaceData3:Object = new Object();
			spaceData3.x = 0;
			spaceData3.y = 0;
			spaceData3.z = -1;
			spaceData3.rotationX = 90;
			spaceData3.rotationY = 0;
			spaceData3.rotationZ = 180;
			spaceDataList.push(spaceData3)
			
			
			var spaceData4:Object = new Object();
			spaceData4.x = -1;
			spaceData4.y = 0;
			spaceData4.z = 0;
			spaceData4.rotationX = 0;
			spaceData4.rotationY = -90;
			spaceData4.rotationZ = -90;
			spaceDataList.push(spaceData4)
			
			var spaceData5:Object = new Object();
			spaceData5.x = 0;
			spaceData5.y = -1;
			spaceData5.z = 0;
			spaceData5.rotationX = 0;
			spaceData5.rotationY = 180;
			spaceData5.rotationZ = 0;
			spaceDataList.push(spaceData5)
			
			
		    var spaceData6:Object = new Object();
			spaceData6.x = 0;
			spaceData6.y = 0;
			spaceData6.z = 1;
			spaceData6.rotationX = -90;
			spaceData6.rotationY = 0;
			spaceData6.rotationZ = 180;
			spaceDataList.push(spaceData6)
			
			var mesh:BoxPlane
			for (var i:int = 0; i < 6; i++) 
			{
				mesh= new BoxPlane(value)				
				mesh.x = int(spaceDataList[i].x*value/2);
				mesh.y = int(spaceDataList[i].y*value/2);
				mesh.z = int(spaceDataList[i].z*value/2);				
				mesh.rotationX = spaceDataList[i].rotationX;
				mesh.rotationY = spaceDataList[i].rotationY;
				mesh.rotationZ = spaceDataList[i].rotationZ;				
				addChild(mesh);
				boxPlanes[i] = mesh;
			}
			miniImageLoader = new Loader();
			miniImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onMiniImageComplete)
		}		
		private function onMiniImageComplete(e:Event):void 
		{
			isComplete = true;
			this.dispatchEvent(e.clone())
			var tempBitmapData:BitmapData = Bitmap(miniImageLoader.content).bitmapData;			
			bitmapDatas=TextureTool.skyBoxTextureList(tempBitmapData)
		}
		override public function disposeAsset():void 
		{
			if (loaderImage)
			{
				loaderImage.unload();
				loaderImage.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageComplete);
				loaderImage.contentLoaderInfo.removeEventListener(Event.OPEN, onOpen);
				loaderImage = null;
			}
			if (xmlLoader)
			{
				xmlLoader.removeEventListener(Event.COMPLETE, onXMLComplete)
				xmlLoader = null;
			}
			while (_bitmapDatas.length)
			{
				_bitmapDatas[0].dispose();
				_bitmapDatas[0] = null;
				_bitmapDatas.shift();
			}		
			_bitmapDatas.length = 0;
			_bitmapDatas = null;
			
			while (boxPlanes.length)
			{
				boxPlanes[0].disposeAsset();
				boxPlanes.shift();
			}
			boxPlanes.length = 0;
			boxPlanes = null;			
			
			spaceDataList.length = 0;
			spaceDataList = null;
			super.disposeAsset();
		}
		public function get bitmapDatas():Vector.<BitmapData> 
		{
			return _bitmapDatas;
		}
		
		public function set bitmapDatas(value:Vector.<BitmapData>):void 
		{
			if (value == null) return;
			remove();
			_bitmapDatas = value;
			var bitmapData:BitmapData
			var w:Number = 0;
			var h:Number = 0;
			var si:int=0
			for (var i:int = 0; i <_bitmapDatas.length; i++) 
			{
				si=sequence[i]
				bitmapData = _bitmapDatas[si];
				w = bitmapData.width/4;
				h = bitmapData.height/4;
				var index:int = 0;
				for (var j:int = 0; j <4; j++) 
				{
					for (var k:int = 0; k <4; k++) 
					{
						var temp:BitmapData = new BitmapData(w,h)
						temp.copyPixels(bitmapData,new Rectangle(j*w,k*h,w,h),new Point(0,0))
						boxPlanes[si].upImageAt(temp,index)
						index++;
					}
				}
				bitmapData.dispose();
				bitmapData = null;
			}
			_bitmapDatas.length = 0;
			initXML();
		}		
		public function get source():String 
		{
			return _source;
		}
		protected var isComplete:Boolean = false;	
		public function set source(value:String):void 
		{
			if (_source == value) return;
			_source = value;
			URL = _source;
			if (!isComplete)
			{
			   miniImageLoader.load(new URLRequest(_source+"minMap.jpg"))
			}else
			{
				initXML();
			}
		}
		public function remove():void
		{
			cont = 0;
			while (urls.length) 
			{
				urls.shift();
			}
			urls = new Array();
			if (loaderImage)
			{
				loaderImage.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageComplete)
				loaderImage.contentLoaderInfo.removeEventListener(Event.OPEN,onOpen)
				loaderImage.unloadAndStop()
				loaderImage.unload();
				loaderImage.removeChildren()
				loaderImage = null;
			}
			
		}
		protected var xmlLoader:URLLoader 
		protected var urls:Array = [];
		protected var loaderImage:Loader
		protected var cont:int = 0;
		protected var isNew:Boolean = false;
		protected function initXML():void
		{
			remove()		
			if (xmlLoader)
			{
				xmlLoader.close()
				xmlLoader.removeEventListener(Event.COMPLETE, onXMLComplete)
				xmlLoader = null;
			}
			isComplete = false;
			xmlLoader= new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,onXMLComplete)
			xmlLoader.load(new URLRequest(URL+"imageXML.xml"))
		}
		private function onImageComplete(e:Event):void 
		{
			isOpen = false;
			var bitmapData:BitmapData=Bitmap(e.target.content).bitmapData
			var i:int = int(cont / 16);
			var si:int=sequence[i]
			var index:int = cont % 16;
			//trace("si::" + si+"<  >"+"index::"+index+"<  >"+LoaderInfo(e.target).url);
			boxPlanes[si].upImageAt(bitmapData, index)
			cont++;
			nextLoad(cont)
			bitmapData = null;
		}
		private function onXMLComplete(e:Event):void 
		{		
			loaderImage = new Loader();			
			loaderImage.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageComplete);
			loaderImage.contentLoaderInfo.addEventListener(Event.OPEN,onOpen);
			
			var xml:XML = XML(xmlLoader.data)
			urls = new Array();
			var xmlList:XMLList = xml.children();
			var length:int = xmlList.length();
			for (var i:int = 0; i <length; i++) 
			{
				urls[i] = URL + xmlList[i].@url + "";
			}
			cont = 0;
			nextLoad(cont)
		}		
		private function onOpen(e:Event):void 
		{
			isOpen = true;
		}
		protected var isOpen:Boolean = false;
		protected function nextLoad(i:int):void
		{
			if (i >= urls.length)
			{
				remove();
				return;
				
			}
			if (loaderImage) 
			{
				loaderImage.load(new URLRequest(urls[i]));
			}
		}
		
	}

}