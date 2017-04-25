package snow.scene3D.hotObject.items 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.SimpleVideoPlayer;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.NativeVideoTexture;
	import away3d.textures.VideoTexture
	import away3d.utils.Cast
	import flash.utils.setTimeout
	
	public class MovieItme extends ObjectItme
	{
		private var mesh:Mesh;
		private var natveVideoTexture:NativeVideoTexture
		public function MovieItme()
		{
			super();
		}		
		override public function set data(value:Object):void
		{
			_data = value;
			natveVideoTexture = new NativeVideoTexture(_data.url, true, true)	
			if (_data.volume) natveVideoTexture.player.volume = _data.volume;
			var textureMaterial:TextureMaterial = new TextureMaterial(natveVideoTexture,true,false,false)			
			textureMaterial.bothSides = true;
			mesh = new Mesh(new PlaneGeometry(1024, 768), textureMaterial);
			mesh.mouseEnabled = true;
			addChild(mesh);
			natveVideoTexture.player.play()	
			worldBounds = mesh.worldBounds;
			
		}
		override public function stop():void
		{
			natveVideoTexture.player.pause();
		}
		override public function play():void
		{
			natveVideoTexture.player.play();
		}
		override public function disposeAsset():void
		{
			super.disposeAsset()
			natveVideoTexture.player.stop();
			natveVideoTexture.dispose()
			mesh.disposeAsset();
		}
		
	}

}