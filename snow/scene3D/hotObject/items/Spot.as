package snow.scene3D.hotObject.items 
{
	import away3d.bounds.AxisAlignedBoundingBox;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.MovieAssetTexture;
	import flash.events.Event;
	import flash.display.Shape
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author ...
	 */
	public class Spot extends ObjectItme 
	{
		
		protected var texture:MovieAssetTexture
		public function Spot() 
		{
			super();
		}		
		override public function set data(value:Object):void 
		{
			_data = value;
			texture = new MovieAssetTexture(_data.url, 30)
			texture.addEventListener(Event.COMPLETE,onImageComplete)
		}		
		private function onImageComplete(e:Event):void 
		{
			var planeGeometry:PlaneGeometry = new PlaneGeometry();
			planeGeometry.width = texture.bitmapData.width;
			planeGeometry.height = texture.bitmapData.height;
		    var mesh:Mesh = new Mesh(planeGeometry, new TextureMaterial(texture));
			mesh.mouseEnabled = true;
			mesh.material.bothSides = true;
			TextureMaterial(mesh.material).alphaBlending = true;
			this.addChild(mesh)			
			this.dispatchEvent(new Event(Event.COMPLETE, true));			
			worldBounds = mesh.worldBounds;
		}
		override public function disposeAsset():void 
		{
			texture.dispose()
			this.getChildAt(0).disposeAsset()
			super.disposeAsset();
		}
		
		
	}

}