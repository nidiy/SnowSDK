package snow.utils 
{
	import flash.geom.Point;
	import starling.display.DisplayObject;
	//动态设置注册点
	public class DynamicRegistration
	{
		//需更改的注册点位置
		private var _point:Point;
		//更改注册的显示对象
		private var _target:DisplayObject;
		
		private var _scaleX:Number;
		private var _scaleY:Number;
		
		private var _x:Number;
		private var _y:Number;
		
		private var _width:Number;
		private var _height:Number;
		
		function DynamicRegistration(target:DisplayObject=null)
		{
			if (target != null)
			{
			  this._target = target;
			  
			  _scaleX = target.scaleX
			  _scaleY = target.scaleY
			  
			  _x = target.x;
			  _y = target.y;
			  
			  _width = target.width;
			  _height = target.height;
			}
		}
		
		public function set point(value:Point):void
		{
			_point=value;
		}
		public function get point():Point
		{
			return _point
		}
		
		public function set target(value:DisplayObject):void
		{
			this._target = value;
			_scaleX = target.scaleX
			_scaleY = target.scaleY
			  
			_x = target.x;
			_y = target.y;
			  
			_width = target.width;
			_height = target.height;
		}
		public function get target():DisplayObject
		{
			return this._target;
		}
		
		//scaleX缩放
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
			updata("scaleX",_scaleX)
		}
	    public function get scaleX():Number
		{
			return _scaleX
		}
		//scaleY缩放
		public function set scaleY(value:Number):void
		{
			_scaleY = value;
			updata("scaleY",_scaleY)
		}
		public function get scaleY():Number
		{
			return _scaleY
		}
		//X位移
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			_x = value;
			updata("x",_x)
		}
		//Y位移
		public function set y(value:Number):void
		{
			_y = value;
			updata("y",_y)
		}
		public function get y():Number
		{
			return _y;
		}
		//width控制
	    public function set width(value:Number):void
		{
			_width = value;
			updata("width",_width)
		}
		public function get width():Number
		{
			return _width;
		}
		//height控制
		public function set height(value:Number):void
		{
			_height = value;
			updata("height",_height)
		}
		public function get height():Number
		{
			return _height;
		}
		
		
		//设置显示对象的属性
		protected function updata(prop:String,value:Number):void
		{
			if (_target != null)
			{
			  //转换为全局坐标
			  var A:Point = _target.parent.globalToLocal(_target.localToGlobal(_point));
				 _target[prop] = value;
				 //再重新计算全局坐标
				 var B:Point = _target.parent.globalToLocal(_target.localToGlobal(_point));
				 //把注册点从B点移到A点
				 _target.x +=  A.x - B.x;
				 _target.y +=  A.y - B.y;
			 // }
			}
		}
	}
}