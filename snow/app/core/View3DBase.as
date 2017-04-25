package snow.app.core 
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.misc.SingleFileLoader;
	import away3d.loaders.parsers.ParticleGroupParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.loaders.parsers.Parsers;
	import away3d.primitives.CubeGeometry;
	import flash.display.DisplayObjectContainer;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	/**
	 * ...
	 * @author thb
	 */
	public class View3DBase extends AppSprite 
	{
		protected static var isInitMilieu:Boolean = false;
		protected var view3d:View3D;
		protected var camera3D:Camera3D;
		protected var scene3D:Scene3D;
		
		protected var light:DirectionalLight;
		protected var cameraLight:PointLight;
		protected var lightPicker:StaticLightPicker;
		public var addLight:Boolean = false;
		public function View3DBase() 
		{
			super()
			if (!isInitMilieu)
			{
				SingleFileLoader.enableParser(ParticleGroupParser);			
				Parsers.enableAllBundled()
				isInitMilieu = true;
			}
			camera3D = new Camera3D();
			scene3D = new Scene3D();
			view3d = new View3D(scene3D, camera3D);
			view3d.shareContext = true;
			camera3D.lens = new PerspectiveLens(OSConfig.fieldOfView,10);
			camera3D.lens.near =OSConfig.near;
			camera3D.lens.far = OSConfig.far;
		}
		override protected function initMilieu():void 
		{
			super.initMilieu();
			view3d.stage3DProxy = this.stage3DProxy
		    this.addChild(view3d)
			if (addLight) initLight();
			if (autoSize) draw();
		}
		protected function test():void
		{
		    var mesh:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0xFFCC33))
			mesh.rotationY = 45;
			view3d.scene.addChild(mesh)
		}
		/**
		 * 初始化灯光
		 */
		protected function initLight():void
		{
			trace("创建了灯光！")
    		this.light = new DirectionalLight(0, 0, 0);
			this.light.color = 0xFFFFFF;			
			this.cameraLight = new PointLight();
			this.cameraLight.color = 0xFFFFFF;			
			this.lightPicker = new StaticLightPicker([this.cameraLight,this.light]);
		}
		override public function onRender():void 
		{
			if (!_lock&&view3d != null&&view3d.stage3DProxy)
			{
				view3d.render()
			}
		}
		override public function set activation(value:Boolean):void 
		{
			if (_activation == value) return;
			mouseEnabled=_activation = value;
			if (view3d)
			{
			   if (_activation)
			   {
				   view3d.mouse3DManager.enableMouseListeners(view3d)
				   view3d.touch3DManager.enableTouchListeners(view3d)
				   
			   }else
			   {
				   view3d.mouse3DManager.disableMouseListeners(view3d)
				   view3d.touch3DManager.disableTouchListeners(view3d)
			   }
			}
		}
		override public function set mouseEnabled(value:Boolean):void 
		{
			super.mouseEnabled = value;
			this.mouseChildren = value;
		}
		protected var parentDisplay:DisplayObjectContainer
		protected var AtIndex:int = 0;
		override public function set lock(value:Boolean):void 
		{
			super.lock = value;
			if (_lock)
			{
				if (this.parent == null) return;
				parentDisplay = this.parent
				AtIndex=this.parent.getChildIndex(this)
				this.parent.removeChild(this);
			}else
			{
				if (parentDisplay == null) return;
				parentDisplay.addChildAt(this,AtIndex);
			}
		}
		override protected function draw():void 
		{

			if (view3d != null && view3d.stage3DProxy)
			{
				view3d.width = _width;
				view3d.height = _height;
				view3d.render();
			}
		}	
		override public function dispose():void 
		{
			super.dispose();
			if (lightPicker!=null)
			{
				lightPicker.dispose()
			}
			lightPicker = null;
			light = null;
			cameraLight = null;
			if (view3d)
			{
				if (view3d.camera)
				{
					view3d.camera.disposeAsset();
				}
				if (view3d.parent)
					view3d.parent.removeChild(view3d);
				view3d.removeChildren()
				view3d.dispose()
				view3d = null
			}
		}
	}

}