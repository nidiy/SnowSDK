package snow.app.manager
{
	import com.greensock.TweenLite;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import away3d.core.managers.Stage3DProxy;
	
	import ghostcat.util.display.BitmapUtil;
	
	import snow.app.core.App;
	import snow.app.event.BroadCenter;
	import snow.app.event.BroadEvent;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * APP切换动画及效果
	 * @author
	 */
	public class APPEffectManage extends EventDispatcher 
	{
		public static var effectContainer:Sprite = new Sprite();		
		public var isEffect:Boolean = false;
		public var appRectangle:Rectangle;
		protected var isStop:Boolean = false;
		protected var effectTime:Number = 0.4;
		protected var delayTime:Number = 0.2;
		public function APPEffectManage() 
		{
			
		}
		public function open(appLoader:AppLoader):void
		{
			if (!isEffect)
			{
				appLoader.run(); 
				return;
			}			
			appLoader.pause();			
			if (appLoader.bitmapData)
			{
				var image:Bitmap
				image = new Bitmap(appLoader.bitmapData);
				effectContainer.addChildAt(image,0)
				image.alpha = 1;
				image.x = -image.width;
				TweenLite.to(image, effectTime, {delay:delayTime, x:0, onComplete:onOpenComplete, onCompleteParams:[image, appLoader]})
			}else
			{
				appLoader.run();
				appLoader.app.x = OSConfig.stage.stageWidth;
				TweenNano.to(appLoader.app,effectTime,{delay:delayTime,x:0})
			}
			
		}
		public function close(appLoader:AppLoader,isAll:Boolean=false):void
		{
			if (!isEffect) 
			{
				appLoader.close();
				return;
			}			
			if (appLoader.bitmapData)
			{
				appLoader.bitmapData.dispose();
				appLoader.bitmapData = null;
			}
			var bitmapData:BitmapData = appLoader.app.snapshot();			
			var maxW:Number = bitmapData.width;
			var maxH:Number = bitmapData.height;
			var image:Bitmap = new Bitmap(bitmapData);
			image.width=maxW;
			image.height = maxH;
			appLoader.bitmapData = bitmapData;
			effectContainer.addChild(image);
			image.alpha = 1;
			TweenLite.to(image, effectTime, {delay:delayTime, alpha:0, x:maxW, onComplete:onCloseComplete, onCompleteParams:[image, appLoader, isAll]});
			setTimeout(appLoader.pause, 70);
			trace("动画关闭")
			isStop = true;
		}
		public function stop(appLoader:AppLoader):void
	    {
			if (!isEffect)
			{
				appLoader.pause();
				if (!appLoader.isSupporter)
				{
					appLoader.stop();
				}
				return;
			}			
			if (appLoader.bitmapData)
			{
				appLoader.bitmapData.dispose();
				appLoader.bitmapData = null;
			}		
			var bitmapData:BitmapData = appLoader.app.snapshot()	
			var maxW:Number = bitmapData.width;
			var maxH:Number = bitmapData.height;			
			var image:Bitmap = new Bitmap(bitmapData)
			image.width = maxW;
			image.height = maxH;
			appLoader.bitmapData = bitmapData;
			effectContainer.addChild(image)
			image.alpha = 1;
			image.x = 0;
			var gapx:Number;
			TweenLite.to(image,effectTime, {delay:delayTime,x:image.width,onComplete:onStopComplete, onCompleteParams:[image] } )			
			setTimeout(appLoader.pause, 70)
			isStop = true;
			if (!appLoader.isSupporter)
			{
				appLoader.stop();
			}		
			
		}
		protected function onStopComplete(value:Bitmap):void
		{
			isStop = false;
			effectContainer.removeChild(value)
			value=null;
		}		
		protected function onOpenComplete(value:Bitmap,appLoader:AppLoader):void
		{
			appLoader.run();
			TweenLite.to(value, 0.3,
			{   
				alpha:0,
				onComplete:function():void
				{
					effectContainer.removeChild(value)
					value = null;
					trace("打开完成！")
				}
			});	
			appLoader=null;
		}
		protected function onCloseComplete(value:Bitmap,appLoader:AppLoader,isAll:Boolean):void
		{
			isStop = false;
			effectContainer.removeChild(value)
			value = null;
			appLoader.close();
			appLoader = null;
			if (isAll)
			{
				effectContainer.removeChildren();
			}
			trace("动画关闭完成")
		}
	}
}