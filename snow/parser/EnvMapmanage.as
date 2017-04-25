package snow.parser 
{
	import adobe.utils.CustomActions;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.LightMapMethod;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import snow.app.model.DataProvider;
	import snow.utils.TextureTool;
	import flash.utils.Dictionary
	import snow.utils.XMLUtil;
	/**
	 * ...
	 * @author 
	 */
	public class EnvMapmanage extends EventDispatcher 
	{
		protected var _config:XML
		protected var _loader:Loader
		protected var dictionary:Dictionary
		protected var cubeTextures:Vector.<BitmapCubeTexture>;
		protected var lightMapMethods:Array = [];
		protected var loadNum:int = 0;
		protected var sumNum:int = 0;
		protected var dataProvider:DataProvider
		public var rootURL:String = "";
		public function EnvMapmanage() 
		{
			dataProvider = new DataProvider();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete)
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError)
			dictionary = new Dictionary();
			cubeTextures = new Vector.<BitmapCubeTexture>;
		}		
		private function onComplete(e:Event):void 
		{
			var map:BitmapData = Bitmap(e.target.content).bitmapData;
			if (dictionary[loadNum].type == "AO")
			{
				createlightMapMethod(map)
			}else
			{
			    createEnvMap(map)
			}
			loadNum++
			if (loadNum>=sumNum)
			{
				allComplete()
				return;
			}
			loadMap(loadNum)
		}
		protected function createEnvMap(bitmapData:BitmapData):void
		{
			var cubeMap:BitmapCubeTexture = TextureTool.BitmapCubeMaterial(bitmapData)
			cubeMap.id=dictionary[loadNum].id;
			cubeTextures.push(cubeMap);
		}
		protected function createlightMapMethod(bitmapData:BitmapData):void
		{
			var lightMapMethod:LightMapMethod = new LightMapMethod(new BitmapTexture(bitmapData));
			lightMapMethod.id = dictionary[loadNum].id;
			lightMapMethods.push(lightMapMethod)
		}
		private function onIOError(e:IOErrorEvent):void 
		{
			loadNum++
			if (loadNum>=sumNum)
			{
				allComplete()
				return;
			}
			loadMap(loadNum)
		}	
		private function allComplete():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE))
		}
		public function get config():XML 
		{
			return _config;
		}		
		public function set config(value:XML):void 
		{
			_config = value;
			var xmlList:XMLList = _config.children();
			var length:uint = xmlList.length();
			sumNum = length;
			for (var i:int = 0; i <length ; i++) 
			{
				dictionary[i] = new Object();
				XMLUtil.attributesToObject(xmlList[i],dictionary[i])
				XMLUtil.xmlToObject(xmlList[i], dictionary[i])
			}
			loadMap(loadNum);
		}
		public function loadMap(num:int):void
		{
			var url:String =rootURL+dictionary[num].url;
			_loader.load(new URLRequest(url))
		}
		public function getEnvMapMethod(id:String,alpha:Number=0.5):EnvMapMethod
		{
			var UID:String = id + alpha;
			var tempObj:Object = dataProvider.getItemAtByField("UID", UID)
			if (tempObj != null&&tempObj.envMap)
			{
				return EnvMapMethod(tempObj.envMap);
			}
			var cubeMap:BitmapCubeTexture = null;
			var lh:int = cubeTextures.length;
			for (var i:int = 0; i <lh; i++) 
			{
				if (cubeTextures[i].id == id)
				{
					cubeMap = cubeTextures[i];
					break;
				}
			}
			if (cubeMap == null) return null;
			tempObj = new Object();
			var envMap:EnvMapMethod = new EnvMapMethod(cubeMap, alpha)
			tempObj.UID = UID;
			tempObj.envMap = envMap;
			dataProvider.addItem(tempObj)
			return envMap;
		}
		public function getlightMapMethod(id:String):LightMapMethod
		{
			var length:int = lightMapMethods.length;
			var lightMapMethod:LightMapMethod
			for (var i:int = 0; i < length; i++) 
			{
				lightMapMethod = lightMapMethods[i] as LightMapMethod;
				if (lightMapMethod.id == id)
				{
				   return lightMapMethod
				}
			}
			return null;
		}
		public function dispose():void
		{
			var el:int = dataProvider.length;
			for (var j:int = 0; j < el; j++) 
			{
				EnvMapMethod(dataProvider.getItemAt(j).envMap).dispose();
			}
			dataProvider.removeAll();
			var cl:int = cubeTextures.length;
			for (var i:int = 0; i < cl; i++) 
			{
				cubeTextures[i].dispose();
				cubeTextures[i] = null;
			}
			while (lightMapMethods.length)
			{
				LightMapMethod(lightMapMethods[0]).texture.dispose()
			    lightMapMethods[0] = null
				lightMapMethods.shift();
			}
			cubeTextures.length = 0;
			cubeTextures = null;
			dictionary = null;
		}
	}

}