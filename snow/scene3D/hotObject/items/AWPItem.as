package snow.scene3D.hotObject.items 
{
	import away3d.entities.Mesh;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	import away3d.textures.TextureProxyBase;
	import feathers.controls.Alert;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author webcity3d
	 */
	public class AWPItem extends ObjectItme 
	{
		private var particleGroup:ParticleGroup
		protected var textureList:Vector.<TextureProxyBase>
		private var loader:AssetLoader 
		public function AWPItem() 
		{
			super()
			textureList = new Vector.<TextureProxyBase>
			loader= new AssetLoader();
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAnimation);
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onComplete);
			loader.addEventListener(LoaderEvent.LOAD_ERROR, onError);
		}		
		override public function set data(value:Object):void 
		{
			_data = value;
			loader.load(new URLRequest(String(_data.url)));
		}		
		private function onError(e:LoaderEvent):void 
		{
			Alert.show(e.message,"加载错误url:"+e.url+"")
		}
		private function onComplete(e:LoaderEvent):void 
		{
			loader.removeEventListener(AssetEvent.ASSET_COMPLETE, onAnimation);
			loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onComplete);
			loader.removeEventListener(LoaderEvent.LOAD_ERROR, onError);
			this.dispatchEvent(new Event(Event.COMPLETE,true))
		}
		private function onAnimation(e:AssetEvent):void
		{
			if (e.asset.assetType == AssetType.CONTAINER && e.asset is ParticleGroup)
			{
				particleGroup = e.asset as ParticleGroup;
				addChild(particleGroup);
				particleGroup.animator.start();
			}
			if (e.asset.assetType == AssetType.MESH)
			{
				var mesh:Mesh = e.asset as Mesh
				mesh.mouseEnabled = true;
				if (worldBounds == null)
				{
					worldBounds = mesh.worldBounds;
				}else
				{
					var max:Vector3D = mesh.worldBounds.max;
					var min:Vector3D = mesh.worldBounds.min;
					worldBounds.fromExtremes(min.x, min.y, min.z, max.x, max.y, max.z);
				}
			}
			if (e.asset.assetType == AssetType.TEXTURE)
			{
				var texture:TextureProxyBase= e.asset as TextureProxyBase
				textureList.push(texture)
			}
		}
		override public function disposeAsset():void 
		{
			while (textureList.length)
			{
				textureList[textureList.length-1].dispose();
				textureList[textureList.length-1] = null;
				textureList.pop();
			}
			if (particleGroup)
			{
				particleGroup.animator.stop();
				particleGroup.disposeAsset();
			}
			super.disposeAsset();
		}
		
	}

}