package snow.app.core
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	
	import snow.app.event.AppEvent;
	import snow.app.manager.Manager;

	/**
	 *  所有控制器及APP基类
	 *  1. 新的基类依然继承的原生Sprite，但增加了stage3DManager管理器，及stage3DProxy  3D视图控制器方便使用  
	 *  2. 支持Starling与away3d同时使用
	 */
	public class AppSprite extends Sprite implements IAppSprite
	{		
		protected var _lock:Boolean = false;
		protected var _activation:Boolean = true;
		protected var _width:int=512;
		protected var _height:int=512;
		protected var stage3DManager:Stage3DManager;
		protected var stage3DProxy:Stage3DProxy;
		public var isNative:Boolean = false;
		protected var _bitmapData:BitmapData
		public var appLayer:String = App.MID;
		protected var _autoSize:Boolean = true;
		public function get autoSize():Boolean{return _autoSize;}
		public function set autoSize(value:Boolean):void{_autoSize = value;}
		
		public function AppSprite() 
		{
			super()
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		/**
		 * 对像增加到舞台上后执行
		 * @param	e
		 */
		protected function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedStage);
			//判断管理器中stage3DManager是否为空
			if (Manager.stage3DManager!=null&&Manager.stage3DProxy!=null)
			{
				//为空则引用管里器中的stage3DManager,stage3DProxy(分别为stage3D层管理,及视图管理)
				stage3DManager = Manager.stage3DManager;
				stage3DProxy = Manager.stage3DProxy;
				initMilieu();
			}
			else
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.frameRate = 60;
				Manager.stage3DManager = stage3DManager = Stage3DManager.getInstance(stage);
				Manager.stage3DProxy = stage3DProxy = stage3DManager.getFreeStage3DProxy(false, Context3DProfile.STANDARD_CONSTRAINED);		
				stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated, false, 10, true);
				//抗锯齿系数
			    stage3DProxy.antiAlias = Manager.ANTIALIAS;
				//背景色
			    stage3DProxy.color = Manager.COLOR;
			}
		}
		
		protected function onRemovedStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedStage);
			this.addEventListener(Event.ADDED_TO_STAGE,onInitStage);
		}
		protected function onInitStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onInitStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedStage);
		}
		/**
		 * 3D环镜初始化完成(只当初始Manager.stage3DManager为空时才会执行)
		 * @param	e
		 */
		protected function onContextCreated(e:Stage3DEvent):void 
		{
			stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);			
			stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.RESIZE,onUserStageResize,false,int.MAX_VALUE,true);
			onUserStageResize();
			initMilieu();
		}		
		private function onEnterFrame(e:Event):void 
		{
			onRender();
		}
		/**
		 * 在3D环境已有的情况下初始化自身环镜
		 */
		protected function initMilieu():void
		{
			this.dispatchEvent(new AppEvent(AppEvent.INIT_MILIEU, null));
		}
		protected function onUserStageResize(e:Event = null):void 
		{
			Manager.stage3DProxy.width = stage.stageWidth;
			Manager.stage3DProxy.height = stage.stageHeight;
		}
		
		public function getViewPort():Rectangle
		{
			return stage3DProxy.viewPort.clone();
		}
		
		public function set activation(value:Boolean):void
		{
			_activation = value;
		}
		/**
		 * 状态控制activation为false为不激活，true为激活
		 */
		public function get activation():Boolean
		{
			return _activation;
		}
		public function set lock(value:Boolean):void
		{
			_lock = value;
		}
		/**
		 * 是否锁定true为解锁,false为锁定
		 */
		public function get lock():Boolean
		{
			return _lock;
		}
		override public function set x(value:Number):void 
		{
			super.x = value;
			this.draw();
		}
		override public function set y(value:Number):void 
		{
			super.y = value;
			this.draw();
		}		
		override public function set alpha(value:Number):void 
		{
			super.alpha = value;
			this.draw();
		}
		/**
		 * 设置与获取宽度
		 */
		override public function get width():Number 
		{
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			if (_width == value) return;
			_width = value;
			draw();
		}
		public function setSize(newWidth:Number, newHeigth:Number):void
		{
			this._width = newWidth;
			this._height = newHeigth;
			draw();
		}
		/**
		 * 设置与获取高度
		 */
		override public function get height():Number 
		{
			return _height;
		}		
		override public function set height(value:Number):void 
		{
			if (_height == value) return;
			_height = value;
			draw();
		}
		
		public function get bitmapData():BitmapData 
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void 
		{
			_bitmapData = value;
		}
		/**
		 * 清除所有对像及资源
		 */
		public function dispose():void
		{
            this.removeEventListener(Event.ADDED_TO_STAGE, onInitStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedStage);
			this.removeChildren();
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			this.stage3DManager = null;
			this.stage3DProxy = null;
		}
		
		public function updata():void
		{
			
		}
		/**
		 * 刷新,或渲染,此方法可能会被不断执行
		 */
		public function onRender():void
		{
			
		}
		/**
		 * 绘制显示,设置大小与位移时发生变化
		 */
		protected function draw():void
		{
			
		}
		
	}

}