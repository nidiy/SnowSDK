package snow.scene3D.hotObject 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.lightpickers.StaticLightPicker;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import ghostcat.text.FilePath;
	import snow.event.HotEvent;
	import snow.scene3D.hotObject.items.AWPItem;
	import snow.scene3D.hotObject.items.ModelItme;
	import snow.scene3D.hotObject.items.MovieItme;
	import snow.scene3D.hotObject.items.ObjectItme;
	import snow.scene3D.hotObject.items.Spot;
	import snowui.engine.utils.XMLUtil;
	import snow.utils.debugDrag.Drag3DTool
	/**
	 * WebCity3D品牌旗舰店馆内热点控制器v1.0
	 * 主要支持功能
	 * 1.闪光点 (支持外部自定义,可使用swf,jpg,gif,png等媒体文件)
	 * 2.相册(支持外部加载)
	 * 3.视频播放器
	 * 4.按扭组件
	 */
	public class HotController extends ObjectContainer3D 
	{
		public static const IMAGES:Array = ["JPG", "PNG", "png", "jpg"];
		public static const AWP:Array = ["awp", "AWP"];
		public static const MODEL:Array = ["awd", "AWD", "3ds", "3DS", "obj", "OBJ", "dae", "DAE"];
		public static const VIDEO:Array = ["flv", "FLV", "mp4", "MP4"];
		
		protected var HotList:Vector.<ObjectItme> = new Vector.<ObjectItme>;
		protected var _drag3DTool:Drag3DTool;
		protected var _debug:Boolean
		protected var _staticLightPicker:StaticLightPicker
		protected var content:int = 0;
		protected var lengthSum:int = 0;
		public var onClickHandler:Function;
		protected var _config:XML;
		protected var _rootURL:String;
		protected var _view3D:View3D
		protected var _isVR:Boolean = false;
		protected var isStop:Boolean = false;
		protected var urlloader:URLLoader;
		protected var _source:String = "";
		public function HotController(v3d:View3D) 
		{
			super();
			_view3D = v3d;
			urlloader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE, onConfigLoadComplete);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, onConfigLoadError);
		}
		
		private function onConfigLoadError(e:IOErrorEvent):void 
		{
			
		}
		
		private function onConfigLoadComplete(e:Event):void 
		{
			
		}
		public function stop():void
		{
			isStop=true
			for (var i:int = 0; i < HotList.length; i++) 
			{
				HotList[i].stop();
			}
		}
		public function play():void
		{
			isStop = false;
		    for (var i:int = 0; i < HotList.length; i++) 
			{
				HotList[i].play();
			}
		}
		public function get debug():Boolean 
		{
			return _debug;
		}		
		public function set debug(value:Boolean):void 
		{
			_debug = value;
			updata()
		}		
		public function get drag3DTool():Drag3DTool 
		{
			return _drag3DTool;
		}		
		public function set drag3DTool(value:Drag3DTool):void 
		{
			_drag3DTool = value;
			updata()
		}		
		public function get staticLightPicker():StaticLightPicker 
		{
			return _staticLightPicker;
		}		
		public function set staticLightPicker(value:StaticLightPicker):void 
		{
			_staticLightPicker = value;
			updata()
		}
		
		public function get config():XML 
		{
			return _config;
		}
		
		public function set config(value:XML):void 
		{
			_config = value;
		}
		
		public function get rootURL():String 
		{
			return _rootURL;
		}
		
		public function set rootURL(value:String):void 
		{
			_rootURL = value;
		}
		
		public function get isVR():Boolean 
		{
			return _isVR;
		}
		
		public function set isVR(value:Boolean):void 
		{
			_isVR = value;
			for (var i:int = 0; i < HotList.length; i++) 
			{
				HotList[i].isVR = _isVR;
			}
		}
		
		public function get source():String 
		{
			return _source;
		}
		
		public function set source(value:String):void 
		{
			if (_source == value) return;
			_source = value;
			var url:String = "";
			if (_source.indexOf("http://"))
			{
				url = _source;
			}else
			{
				url = _rootURL + _source;
			}
			urlloader.load(new URLRequest(url))
			
		}
		public function forHot(id:String):void
		{
			clear()
			if (id == "") return;
			var xmllist:XMLList = _config.children().(attribute("aid") == id);
			if (xmllist.toXMLString() == "") return;
			var length:int = xmllist.length();
			for (var i:int = 0; i < length; i++) 
			{
				
				var item:Object = { };
				XMLUtil.attributesToObject(xmllist[i],item)
				XMLUtil.xmlToObject(xmllist[i], item)
				var url:String = item.url
				if (url == "")
				{
					continue;
				}
				var extension:String = "";
				var lasts:Array = url.split(".")
				if (lasts.length > 0)
				{
				   extension = lasts[lasts.length - 1];
				   
				}else
				{
					continue;
				}				
				if (url.indexOf("http://") == -1)
				{
					item.url = _rootURL + url;
				}				
				if (IMAGES.indexOf(extension) !=-1)
				{
					var spot:Spot = new Spot();
					spot.data = item
					spot.view3d = _view3D;
					spot.isVR=_isVR
					initSpace(spot,item)
					this.addChild(spot)
					HotList.push(spot)
					if (item.event && item.event != "")
					{
					    spot.addEventListener(MouseEvent3D.CLICK, onHotClickHandler);
					    spot.addEventListener(MouseEvent3D.MOUSE_OVER, onHotOverHandler);
					    spot.addEventListener(MouseEvent3D.MOUSE_OUT, onHotOutHandler);
					    spot.addEventListener(MouseEvent3D.MOUSE_MOVE, onHotMoveHandler);
					    spot.addEventListener(MouseEvent3D.MOUSE_DOWN, onHotDownHandler);
					}
					
				}else if (AWP.indexOf(extension) !=-1)
				{
					var awp:AWPItem = new AWPItem();
					awp.data = item;
					awp.isVR = _isVR;
					awp.view3d = _view3D;
					initSpace(awp, item)
					this.addChild(awp)
					HotList.push(awp);
					if (item.event && item.event != "")
					{
					    awp.addEventListener(MouseEvent3D.CLICK,onHotClickHandler)
					    awp.addEventListener(MouseEvent3D.MOUSE_OVER,onHotOverHandler)
					    awp.addEventListener(MouseEvent3D.MOUSE_OUT,onHotOutHandler)
					    awp.addEventListener(MouseEvent3D.MOUSE_MOVE, onHotMoveHandler)
					    awp.addEventListener(MouseEvent3D.MOUSE_DOWN, onHotDownHandler)
					}
					
				}else if (MODEL.indexOf(extension) !=-1)
				{
					var models:ModelItme = new ModelItme();
					models.data = item;
					models.isVR = _isVR;
					models.view3d = _view3D;
					initSpace(models, item)
					this.addChild(models)
					HotList.push(models)
					if (item.event && item.event != "")
					{
					    models.addEventListener(MouseEvent3D.CLICK, onHotClickHandler);
					    models.addEventListener(MouseEvent3D.MOUSE_OVER, onHotOverHandler);
					    models.addEventListener(MouseEvent3D.MOUSE_OUT, onHotOutHandler);
					    models.addEventListener(MouseEvent3D.MOUSE_MOVE, onHotMoveHandler);
					    models.addEventListener(MouseEvent3D.MOUSE_DOWN, onHotDownHandler);
					}
					
				}else if (VIDEO.indexOf(extension) !=-1)
				{
					var movieItme:MovieItme = new MovieItme();
					movieItme.data = item;
					movieItme.isVR = _isVR;
					movieItme.view3d = _view3D;
					initSpace(movieItme, item);
					addChild(movieItme)
					HotList.push(movieItme)
					if (item.event && item.event != "")
					{
						movieItme.addEventListener(MouseEvent3D.CLICK, onHotClickHandler);
					    movieItme.addEventListener(MouseEvent3D.MOUSE_OVER, onHotOverHandler);
					    movieItme.addEventListener(MouseEvent3D.MOUSE_OUT, onHotOutHandler);
					    movieItme.addEventListener(MouseEvent3D.MOUSE_MOVE, onHotMoveHandler);
					    movieItme.addEventListener(MouseEvent3D.MOUSE_DOWN, onHotDownHandler);
					}
				}
			}
		}		
		public function hitTest():void
		{
			if (isStop) return;
			for (var i:int = 0; i < HotList.length; i++) 
			{
				HotList[i].hitTest();
			}
		}
		private function onHotDownHandler(e:MouseEvent3D):void 
		{
			trace("Down")
		}		
		private function onHotMoveHandler(e:MouseEvent3D):void 
		{
			trace("Move")
		}		
		private function onHotOutHandler(e:MouseEvent3D):void 
		{
			trace("Out")
		}		
		private function onHotOverHandler(e:MouseEvent3D):void 
		{
			trace("Over")
		}
		private function onHotClickHandler(e:MouseEvent3D):void 
		{
			var objectItme:ObjectItme = e.currentTarget as ObjectItme
			this.dispatchEvent(new HotEvent(HotEvent.CLICK_HOT,objectItme.data));
		}
		protected function initSpace(object:ObjectContainer3D,item:Object):void
		{
			if (item.x) object.x = item.x;
			if (item.y) object.y = item.y;
			if (item.z) object.z = item.z;
			
			if (item.rotationX) object.rotationX = item.rotationX;
			if (item.rotationZ) object.rotationZ = item.rotationZ;
			if (item.rotationY) object.rotationY = item.rotationY;
			
			if (item.scaleX) object.scaleX = item.scaleX;
			if (item.scaleY) object.scaleY = item.scaleY;
			if (item.scaleZ) object.scaleZ = item.scaleZ;
		}
		private function onComplete(e:Event):void 
		{
			content++
			if (content>lengthSum)
			{
				content = 0;
				allComplete()
			}
		}
		public function updata():void
		{
			
		}
		public function clear():void
		{
			while (HotList.length > 0)
			{
				this.removeChildAt(HotList.length-1)
				HotList.pop().disposeAsset();
			}
		}
		override public function disposeAsset():void 
		{
			clear()
			super.disposeAsset();
		}
		protected function allComplete():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}