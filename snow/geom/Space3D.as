package snow.geom 
{
	import flash.geom.Vector3D;
	/**
	 * 
	 */
	public class Space3D extends Vector3D 
	{
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		protected var _scaleZ:Number;
		protected var _rotationX:Number=0;
		protected var _rotationY:Number=0;
		protected var _rotationZ:Number=0;
		public function Space3D(x:Number=0,y:Number=0,z:Number=0,scaleX:Number=1,scaleY:Number=1,scaleZ:Number=1) 
		{
			super(x, y, z, 0)
			_scaleX = scaleX;
			_scaleY = scaleY;
			_scaleZ = scaleZ;
		}		
		public function get scaleX():Number 
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void 
		{
			_scaleX = value;
		}
		
		public function get scaleY():Number 
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void 
		{
			_scaleY = value;
		}
		
		public function get scaleZ():Number 
		{
			return _scaleZ;
		}
		
		public function set scaleZ(value:Number):void 
		{
			_scaleZ = value;
		}
		
		public function get rotationX():Number 
		{
			return _rotationX;
		}
		
		public function set rotationX(value:Number):void 
		{
			_rotationX = value;
		}
		
		public function get rotationY():Number 
		{
			return _rotationY;
		}
		
		public function set rotationY(value:Number):void 
		{
			_rotationY = value;
		}
		
		public function get rotationZ():Number 
		{
			return _rotationZ;
		}
		
		public function set rotationZ(value:Number):void 
		{
			_rotationZ = value;
		}
		public function addSpace(a:Space3D):Space3D 
		{
			var vector3D:Vector3D = new Vector3D(a.x, a.y, a.z, a.w)
			vector3D = super.add(vector3D);
			
			var space3D:Space3D = new Space3D();
			
			space3D.x = vector3D.x;
			space3D.y = vector3D.y;
			space3D.z = vector3D.z;
			
			space3D.scaleX = a.scaleX + this.scaleX
			space3D.scaleY = a.scaleY + this.scaleY
			space3D.scaleZ = a.scaleZ + this.scaleZ
			
			return space3D;
		}
		
	}

}