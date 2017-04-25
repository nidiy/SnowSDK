package snow.app.view 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author HBin
	 */
	public class BoxPlane extends ObjectContainer3D 
	{
		protected var bitmapTextures:Vector.<BitmapTexture> = new Vector.<BitmapTexture>
		protected var textureMaterial:Vector.<TextureMaterial> = new Vector.<TextureMaterial>
		public function BoxPlane(value:Number=2048) 
		{
			super()
			var gap:Number = value /4;
			var index:int = 0;
			var mesh:Mesh
			var texture:BitmapTexture
			for (var i:int = 0; i < 4; i++) 
			{
				for (var j:int = 0; j <4; j++) 
				{
					texture=new BitmapTexture(new BitmapData(8,8))
					mesh = new Mesh(new PlaneGeometry(gap,gap),new TextureMaterial(texture,true,false,false))
					textureMaterial.push(mesh.material);
					mesh.x = (gap * ( -2 + i) + gap / 2);
					mesh.z = (gap * (2-j)-gap / 2);
					addChild(mesh)
					bitmapTextures[index] = texture;
					index++;
				}
			}
		}
		public function upImageAt(data:BitmapData, index:int):void
		{
			bitmapTextures[index].bitmapData = data;
/*			textureMaterial[index].alpha = 0.1;
			TweenMax.to(textureMaterial[index],0.5,{alpha:1})*/			
		}
		override public function disposeAsset():void 
		{
			for (var i:int = 0; i <bitmapTextures.length; i++) 
			{
				bitmapTextures[i].dispose();
				bitmapTextures[i] = null;
			}			
			bitmapTextures.length = 0;
			bitmapTextures=null
			for (i = 0; i <textureMaterial.length; i++) 
			{
				textureMaterial[i].dispose();
				textureMaterial[i] = null;
			}
			textureMaterial.length = 0;
			textureMaterial = null;
			
			while (this.numChildren) 
			{
				if (this.getChildAt(0) is Mesh)
				{
					(this.getChildAt(0) as Mesh).material = null;
				}
				this.getChildAt(0).disposeAsset();
			}
			super.disposeAsset();
		}
		
	}

}