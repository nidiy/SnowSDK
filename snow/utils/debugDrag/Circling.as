package snow.utils.debugDrag 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.TorusGeometry;
	
	public class Circling extends ObjectContainer3D
	{
		private var rotX:Mesh;
		private var rotY:Mesh;
		private var rotZ:Mesh;
		public function Circling(staticLightPicker:StaticLightPicker=null)
		{
			super();
			rotX = new Mesh(new TorusGeometry(12, 1, 30, 4), new ColorMaterial(0xFF0000));
			rotX.mouseEnabled = true;
			rotX.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			rotX.name="rotX"
			rotY = new Mesh(new TorusGeometry(12, 1, 30, 4), new ColorMaterial(0x0000FF));
			rotY.mouseEnabled = true;
			rotY.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			rotY.name="rotY"
			addChild(rotX);
			rotX.rotateTo(0,0,0)
			addChild(rotY);
			rotX.rotateTo(90, 90, 0)
			this.mouseEnabled = true;
			this.y = 0;
			this.z = 0;
			this.x = 0;
		}	
		
	}

}