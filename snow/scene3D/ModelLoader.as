package snow.scene3D 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	/**
	 * ...
	 * @author 
	 */
	public class ModelLoader extends ObjectContainer3D 
	{
		protected var _data:Object
		protected var _md53dobjects:Vector.<MD53DObject>
		public function ModelLoader() 
		{
			super();
			_md53dobjects=new Vector.<MD53DObject>
		}		
		public function get data():Object 
		{
			return _data;
		}		
		public function set data(value:Object):void 
		{
			_data = value
		}		
		public function get md53dobjects():Vector.<MD53DObject> 
		{
			return _md53dobjects;
		}
		public function addMeshURL(url:String):void
		{
			if (url == "") return;			
			var md53d:MD53DObject = new MD53DObject();
			md53d.load(url);
			_md53dobjects.push(md53d)
			addChild(md53d);
		}
		public function addMesh(_mesh:Mesh):void
		{
			if (_mesh == null) return;
		}
		public function getNameMesh(_name:String):Mesh
		{
			return null
		}
		
	}

}