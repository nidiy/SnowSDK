package snow.app.controller 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import snow.mvc.interfaces.INotification;
	import snow.app.core.App;
	/**
	 * Starling
	 * ...
	 * @author WebCity3D
	 */
	public class View3DControl extends AppController
	{
		protected var rootClass:Class
		public function View3DControl() 
		{
		    super()
		}
		override public function execute(notification:INotification):void 
		{
			this.rootClass = notification.getBody() as Class;
			super.execute(notification);
					
		}
		override protected function initMilieu():void 
		{
			super.initMilieu();
			if (rootClass == null) return;
			this._control = new rootClass();
			_control.autoSize = App(this.facade).autoSize;
			this.facade.registerMediator(_control);
			stage.addChild(DisplayObject(_control));
			_control.activation = _activation;
			//新加
			if (_control.autoSize) draw();
		}	
		override public function set activation(value:Boolean):void 
		{
			_activation = value;
			if (_control)_control.activation = _activation;
		}
		override public function updata():void 
		{
			super.updata();
			if (_control != null)
			{
			   _control.updata();
			}
		}
		override public function onRender():void
		{
			if (_control!=null)
			{
				_control.onRender()
			}
		}
/*		override protected function onUserStageResize(e:flash.events.Event = null):void 
		{
			this._width=this.stage.stageWidth;
			this._height=this.stage.stageHeight
			draw()
		}*/
		override protected function draw():void 
		{
			if (_control != null)
			{
				_control.setSize(_width, _height);
			}
		}
		/**
		 * 清空对像及断开所有引用
		 */
		override public function dispose():void 
		{
		    super.dispose()
			_lock = true;
			if (_control!=null)
			{
				_control.dispose()
			}
			_control = null;
			rootClass = null;
		}
		
	}

}