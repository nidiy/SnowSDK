package snow.utils.debugDrag 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.LineSegment;
	import flash.geom.Vector3D;
	public class DragLine extends ObjectContainer3D
	{
		private var coordinateLine:SegmentSet;
		private var x_Dir:Mesh;
		private var y_Dir:Mesh;
		private var z_Dir:Mesh;
		private var box:Mesh;
		public function DragLine(staticLightPicker:StaticLightPicker=null)
		{
			super()
			coordinateLine = new SegmentSet();
			coordinateLine.addSegment(new LineSegment(new Vector3D(0, 0, 0, 0), new Vector3D(30, 0, 0, 0), 0xFFFFFF, 0xFF0000, 2));
			coordinateLine.addSegment(new LineSegment(new Vector3D(0, 0, 0, 0), new Vector3D(0, 30, 0, 0), 0xFFFFFF, 0x0000FF, 2));
			coordinateLine.addSegment(new LineSegment(new Vector3D(0, 0, 0, 0), new Vector3D(0, 0, 30, 0), 0xFFFFFF, 0x00FF00, 2));
			addChild(coordinateLine);
			coordinateLine.mouseEnabled = false;
			x_Dir = new Mesh(new ConeGeometry(4, 8, 10, 1), new ColorMaterial(0xFF0000));
			x_Dir.mouseEnabled = true;
			x_Dir.name = "x_Dir";
			x_Dir.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			y_Dir = new Mesh(new ConeGeometry(4, 8, 10, 1), new ColorMaterial(0x0000FF));
			y_Dir.name = "y_Dir";
			y_Dir.mouseEnabled = true;
			y_Dir.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			z_Dir = new Mesh(new ConeGeometry(4, 8, 10, 1), new ColorMaterial(0x00FF00));
			z_Dir.mouseEnabled = true;
			z_Dir.name = "z_Dir";
			z_Dir.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			box = new Mesh(new CubeGeometry(4, 4, 4), new ColorMaterial(0x5A5A5A))			
			box.name = "box";
			addChild(box)
			addChild(x_Dir)
			addChild(y_Dir)
			addChild(z_Dir)
			x_Dir.x = 30;
			x_Dir.rotationZ = -90;
			y_Dir.y = 30;
			z_Dir.z = 30;
			z_Dir.rotationX = 90;
			this.mouseEnabled = true;
			if (staticLightPicker)
			{
			    x_Dir.material.lightPicker = staticLightPicker
				y_Dir.material.lightPicker=staticLightPicker
				z_Dir.material.lightPicker=staticLightPicker
				box.material.lightPicker=staticLightPicker
			}
			
			
		}
		
	}

}