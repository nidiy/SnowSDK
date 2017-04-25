package snow.app.controller 
{
	import feathers.core.ValidationQueue;
	import flash.accessibility.Accessibility;
	
	import snow.app.core.IActiveMediator;
	import snow.app.manager.Manager;
	import snow.mvc.interfaces.INotification;
	import flash.display3D.Context3DProfile;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import flash.events.Event;

	/**
	 * Starling
	 * ...
	 * @author WebCity3D
	 */
	public class StarlingControl extends AppController
	{
		protected var rootClass:Class

		protected var _starling:Starling;

		public function StarlingControl() 
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
			if (Starling.current == null)
			{
				Starling.multitouchEnabled = true;
			}
			_starling = new Starling(rootClass, this.stage, stage3DProxy.viewPort, stage3DProxy.stage3D, "auto", Context3DProfile.STANDARD_EXTENDED);
			_starling.shareContext = true;
            //_starling.showStats = true;
			_starling.supportHighResolutions = true;
			_starling.skipUnchangedFrames = true;
			_starling.addEventListener(starling.events.Event.ROOT_CREATED,onRootCreatedhandler)
			stage3DProxy.bufferClear = true;
		}
		override public function updata():void 
		{
			super.updata();
			if (_control != null)
			{
			   _control.updata();
			}
		}
		override public function set activation(value:Boolean):void 
		{
			_activation = value;
			if (_control)_control.activation = _activation;
		}
		override public function set lock(value:Boolean):void 
		{
			if (_lock == value) return;
			_lock = value;
			if (_control)
			{
				_control.lock = _lock;
				mouseEnabled = !_lock;
			}
		}
		protected function onRootCreatedhandler(e:starling.events.Event):void 
		{
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreatedhandler)
			_control = IActiveMediator(_starling.root);
			_control.activation = _activation;
			this.facade.registerMediator(_control);
			_starling.start();
			draw();
		}
		override protected function onRemovedStage(e:flash.events.Event):void
		{
			super.onRemovedStage(e)
			trace("onRemovedStage::StarlingControl");
		}		
		override protected function onInitStage(e:flash.events.Event):void
		{
			trace("onInitStage::StarlingControl");
			super.onInitStage(e);
		}
		
		override public function onRender():void
		{
			if (!_lock&&_starling!=null)
			{
				Manager.stage3DProxy.clearDepthBuffer();
				if (_starling && _starling.root)
				{
					_starling.nextFrame();
					_control.onRender();
				}
			}
		}		
		override protected function draw():void 
		{
			super.draw();
			if (_control != null)
			{
				_control.x = this.x;
				_control.y = this.y;
				DisplayObject(_control).alpha = this.alpha;
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
				_control.dispose();
			}
			if (_starling)
			{
				var validationQueue:ValidationQueue = ValidationQueue.forStarling(_starling);
				if (validationQueue!=null) validationQueue.dispose();
				
				_starling.dispose();
				_starling = null;
			}
			this.facade = null;
			_control = null;
			rootClass = null;
		}
		
	}

}