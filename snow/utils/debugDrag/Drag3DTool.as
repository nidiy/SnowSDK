package snow.utils.debugDrag 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.materials.lightpickers.StaticLightPicker;
	import controllers.IController;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import away3d.events.MouseEvent3D
	/**
	 * WebCity调试器1.0
	 * 主要支持X,Y,Z rotationY，rotationX更改
	 * 
	 */
	public class Drag3DTool extends ObjectContainer3D implements IDrag 
	{
		
		private var dragObject3D:ObjectContainer3D;
		private var dragLine:DragLine;
		private var circling:Circling;
		private var _view:View3D
		private var dir:String = ""
		private var conX:Number = 0;
		private var conY:Number = 0;
		private var conZ:Number = 0;
		protected var _speed:int = 10;
		protected var _data:Object = new Object();
		protected var _cameraControl:IController
		protected var _staticLightPicker:StaticLightPicker
		
		protected var _updata:Function
		public function Drag3DTool(view:View3D,icontrol:IController=null)
		{
			super();
			_view = view;
			_view.addEventListener(Event.ADDED_TO_STAGE,onAddToStage)			
			if (icontrol)
			{
				cameraControl = icontrol;
			}
		}		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			_view.stage.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick)
		}
		
		private function onDoubleClick(e:MouseEvent):void 
		{
			if(_cameraControl)
		       _cameraControl.activate = true;
			object3D = null;
		}
		public function set object3D(value:ObjectContainer3D):void
		{
			if (dragObject3D != value)
			{
				if (dragObject3D != null)
				{
					dragObject3D.mouseChildren = true;
					dragObject3D.mouseEnabled = true;
				}
			}
			if (value != null)
			{
				if (dragLine==null||circling==null)
				{
					dragLine = new DragLine(_staticLightPicker);
			        circling = new Circling(_staticLightPicker);
			        addChild(dragLine)
			        addChild(circling)
				}
				dragObject3D = value;
				dragObject3D.mouseChildren = false;
				dragObject3D.mouseEnabled = false;
				this.position = dragObject3D.position
				try
				{
					_data["label"] = dragObject3D["data"].label.toString();
					_data["id"] = dragObject3D["data"].id;
				}catch (e:Error)
				{
					if (dragObject3D.extra)
					{
						_data["label"]=dragObject3D.extra.label
						_data["id"]=dragObject3D.extra.id
					}else
					{
						_data["label"] = dragObject3D.name;
						_data["id"]=dragObject3D.id
					}
				}
				_data.x = dragObject3D.x;
				_data.y = dragObject3D.y;
				_data.z = dragObject3D.z;
				
				_data.rotationX = dragObject3D.rotationY;
				_data.rotationY = dragObject3D.rotationY;
				_data.rotationZ = dragObject3D.rotationZ;
				
				_data.scaleX = dragObject3D.scaleX
				_data.scaleY = dragObject3D.scaleY
				_data.scaleZ = dragObject3D.scaleZ
				
				this.rotationY = 135+_view.camera.rotationY;
				this.addEventListener(MouseEvent3D.MOUSE_DOWN, onDragLineDown)
				dragObject3D.mouseEnabled = false;
				if(_updata!=null)
			      _updata(_data)
			}else
			{
				if (dragObject3D != null)
				{
				  	dragObject3D.mouseChildren = true;
					dragObject3D.mouseEnabled = true;
				}
				if (dragLine != null&&circling!=null)
				{
				  dragLine.disposeAsset()
				  circling.disposeAsset()
				  dragLine = null;
				  circling = null;
				}
			}
		}
		private function onDragLineDown(e:MouseEvent3D):void
		{
			if(_cameraControl)
			   _cameraControl.activate = false;
			dir = e.object.name;
			conX = _view.stage.mouseX;
			conY = _view.stage.mouseY;
			_view.addEventListener(MouseEvent.MOUSE_MOVE, onMove)
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, onUp)
		}	
		private function onMove(e:MouseEvent):void
		{
			if (dir == "x_Dir")
			{
				if (conX - e.stageX > 0)
				{
					this.x-=_speed;
				}
				if(conX - e.stageX <0)
				{
					this.x+=_speed;
				}
				conX=e.stageX
			}else if (dir == "y_Dir")
			{
				if (conY - e.stageY > 0)
				{
					this.y+=_speed;
				}
				if(conY - e.stageY <0)
				{
					this.y-=_speed;
				}
				conY=e.stageY
			}else if (dir == "z_Dir")
			{
				if (conX - e.stageX > 0)
				{
					this.z-=_speed;
				}
				if(conX - e.stageX <0)
				{
					this.z+=_speed;
				}
				conX = e.stageX;
			}else if (dir == "rotY")
			{
				if (conX - e.stageX > 0)
				{
					dragObject3D.rotationY++;
				}
				if(conX - e.stageX <0)
				{
					dragObject3D.rotationY--;
				}
				conX=e.stageX
				
			}else if (dir == "rotX")
			{
			    if (conY - e.stageY > 0)
				{
					dragObject3D.rotationX++;
				}
				if(conY - e.stageY <0)
				{
					dragObject3D.rotationX--;
				}
				conY=e.stageY
			}
			dragObject3D.position = this.position
			_data.x = dragObject3D.x;
			_data.y = dragObject3D.y;
			_data.z = dragObject3D.z;
			
			_data.rotationX = dragObject3D.rotationX;
			_data.rotationY = dragObject3D.rotationY;
			_data.rotationZ = dragObject3D.rotationZ;
			
			_data.scaleX = dragObject3D.scaleX
			_data.scaleY = dragObject3D.scaleY
			_data.scaleZ = dragObject3D.scaleZ
			if(_updata!=null)
			   _updata(_data)
		}
		private function onUp(e:MouseEvent):void
		{
			_view.removeEventListener(MouseEvent.MOUSE_MOVE, onMove)
			_view.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp)
		}
		
		public function get object3D():ObjectContainer3D
		{
			return dragObject3D;
		}
		
		public function get data():Object 
		{
			return _data;
		}		
		public function set data(value:Object):void 
		{
			_data = value;
			this.x=dragObject3D.x = _data.x;
			this.y=dragObject3D.y = _data.y;
			this.z=dragObject3D.z = _data.z;
			
			dragObject3D.rotationY = _data.rotationX;
			dragObject3D.rotationY = _data.rotationY;
			dragObject3D.rotationZ = _data.rotationZ;
			
			dragObject3D.scaleX = _data.scaleX;
			dragObject3D.scaleY = _data.scaleY;
			dragObject3D.scaleZ = _data.scaleZ;
			
		}
		
		public function get speed():int 
		{
			return _speed;
		}
		
		public function set speed(value:int):void 
		{
			_speed = value;
		}
		
		public function get cameraControl():IController 
		{
			return _cameraControl;
		}
		
		public function set cameraControl(value:IController):void 
		{
			_cameraControl = value;
		}
		
		public function get staticLightPicker():StaticLightPicker 
		{
			return _staticLightPicker;
		}
		
		public function set staticLightPicker(value:StaticLightPicker):void 
		{
			_staticLightPicker = value;
		}		
		public function get updata():Function 
		{
			return _updata;
		}
		public function set updata(value:Function):void 
		{
			_updata = value;
		}
		
	}

}