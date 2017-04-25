package snow.scene3D.hotObject.items 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.ControllerBase;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.assets.AssetType
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.SkyBoxMaterial
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.textures.MovieAssetTexture;
	import away3d.events.LoaderEvent
	import away3d.textures.TextureProxyBase;
	import feathers.controls.Alert
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	public class ModelItme extends ObjectItme 
	{
		private var modeLoader:Loader3D
		private var sprite:Sprite
		protected var motionNum:int = 0;
		protected var i:int = 0;
		protected var value:String = ""
		protected var textureList:Vector.<TextureProxyBase>
		public function ModelItme() 
		{
			super();
			textureList=new Vector.<TextureProxyBase>
			sprite=new Sprite()
		}	
		override public function set data(value:Object):void
		{
			_data = value;
			modeLoader = new Loader3D();
			modeLoader.addEventListener(AssetEvent.ASSET_COMPLETE, onModeComplete)
			modeLoader.addEventListener(LoaderEvent.RESOURCE_COMPLETE,onResourceComplete)
			modeLoader.addEventListener(LoaderEvent.LOAD_ERROR,onLoaderEvent)
			modeLoader.load(new URLRequest(_data.url))			
		    
		}		
		private function onResourceComplete(e:LoaderEvent):void 
		{
			addChild(modeLoader)	
			modeLoader.removeEventListener(AssetEvent.ASSET_COMPLETE, onModeComplete)
			modeLoader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,onResourceComplete)
			modeLoader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoaderEvent)
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onLoaderEvent(e:LoaderEvent):void 
		{
			Alert.show(e.message);
		}
	    private function onModeComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.MESH) {
			    var _mesh:Mesh = event.asset as Mesh;
				_mesh.mouseEnabled = true;
				if (staticLightPicker)
				{
					_mesh.material.lightPicker = staticLightPicker;
				}
				if (worldBounds == null)
				{
					worldBounds = _mesh.worldBounds;
					
				}else
				{
					var max:Vector3D = _mesh.worldBounds.max;
					var min:Vector3D = _mesh.worldBounds.min;
					worldBounds.fromExtremes(min.x, min.y, min.z, max.x, max.y, max.z);
				}
			}
			if (event.asset.assetType == AssetType.TEXTURE)
			{
				var texture:TextureProxyBase= event.asset as TextureProxyBase
				textureList.push(texture)
			}
		}
		override public function disposeAsset():void
		{
			super.disposeAsset();
			modeLoader.removeEventListener(AssetEvent.ASSET_COMPLETE, onModeComplete)
			modeLoader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,onResourceComplete)
			modeLoader.removeEventListener(LoaderEvent.LOAD_ERROR,onLoaderEvent)
			while (textureList.length)
			{
				textureList[textureList.length-1].dispose();
				textureList[textureList.length-1] = null;
				textureList.pop();
			}	
			modeLoader.disposeAsset();
			modeLoader = null;
			_data = null;
			
		}
		
	}

}