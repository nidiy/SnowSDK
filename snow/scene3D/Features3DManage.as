package snow.scene3D 
{
	import away3d.containers.ObjectContainer3D;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import snow.app.model.DataProvider;
	import snow.event.Scene3DEvent;
	import snow.utils.debugDrag.Drag3DTool;
	/**
	 * ...
	 * @author WebCity
	 */
	public class Features3DManage extends ObjectContainer3D 
	{
		protected var _url:String = ""
		protected var _loadXML:URLLoader
		protected var _config:XML
		protected var _fsname:String = ""
		protected var _id:String = ""
		protected var items:Vector.<Features3DItem> = new Vector.<Features3DItem>
		protected var names:Array = new Array();
		protected var datas:DataProvider
		protected var _debug:Boolean = false;
		protected var _drag3DTool:Drag3DTool
		public  var dispatcher:EventDispatcher = new EventDispatcher()
		public var onIsFeatures:Function
		public function Features3DManage()
		{
			super()
			_loadXML = new URLLoader();
			_loadXML.addEventListener(Event.COMPLETE, onXMLComplete)
			datas = new DataProvider();
		}
		private function onXMLComplete(e:Event):void 
		{
			config = XML(_loadXML.data);
		}
		public function get url():String 
		{
			return _url;
		}		
		public function set url(value:String):void 
		{
			//加载前须清空掉之前的
			empty();
			_url = value;
			if (_url && _url == "") return;
			_loadXML.load(new URLRequest(_url))
		}
		public function get config():XML 
		{
			return _config;
		}		
		public function set config(value:XML):void 
		{
			_config = value;
			for (var i:int = 0; i < names.length; i++) 
			{
				var diy:Dictionary=names[i]
				createFeatures(diy.name, diy.id);
			}
		}		
		public function get debug():Boolean 
		{
			return _debug;
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
		public function setFeatures(fsn:String=null,id:String=null):void
		{
			if (fsn && fsn == "") return;
			if (id == null) return;
			if (fsn == "null") 
			{
				empty();
				return;
			}
			if (_config == null)
			{
				var diy:Dictionary = new Dictionary()
				diy["name"] = fsn;
				diy["id"] = id;
				names.push(diy);
				
			}else
			{
				createFeatures(fsn,id)
			}
		}
		/**
		 * 创建卖点
		 */
		protected function createFeatures(ns:String,id:String):void
		{
			var xmlList:XMLList = _config.children().(attribute("name") == ns);
			if (xmlList.toXMLString() != "")
			{
				var features3DItem:Features3DItem = getFsItem(ns)
				if (features3DItem&&features3DItem.id == id) return;
				var fsXMLList:XMLList = xmlList.children().(attribute("id") == id)
				var config:String = fsXMLList.toXMLString();
				if (features3DItem)
				{
					features3DItem.config = fsXMLList.children();
					features3DItem.id = id;
					return;
				}
				if (config!="")
				{
					features3DItem = new Features3DItem();
					features3DItem.dispatcher.addEventListener(Scene3DEvent.CLICK3D,onItemClick3DHandler)
					features3DItem.debug = _debug;
					features3DItem.drag3DTool = _drag3DTool;
					
					features3DItem.name = ns;
					features3DItem.id = id;
					features3DItem.config = fsXMLList.children();
					items.push(features3DItem);
					addChild(features3DItem)					
				}
				if (onIsFeatures != null) onIsFeatures();
			}
		}
		private function onItemClick3DHandler(e:Scene3DEvent):void 
		{
			dispatcher.dispatchEvent(new Scene3DEvent(Scene3DEvent.CLICK3D, e.data));
		}
		protected function getFsItem(value:String):Features3DItem
		{
			var length:int = items.length;
			for (var i:int = 0; i <length; i++) 
			{
				if (items[i].name == value)
				{
					return items[i];
				}
			}
			return null;
		}
		protected function empty():void
		{
			while (items.length) 
			{
				items[items.length - 1].removeEventListener(Scene3DEvent.CLICK3D,onItemClick3DHandler);
				items[items.length - 1].disposeAsset();
				items.pop();
			}
		}
		
	}

}