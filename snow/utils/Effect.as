package snow.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.*; 
	import com.greensock.easing.*;
	import away3d.materials.ColorMaterial;
	/**
	 * ...
	 * @author 
	 */
	public class Effect 
	{
		/**
		 * 缓动完成事件
		 */
		public static const SLOW_TO_COMPLETE:String = "slowToComplete";
		
		public function Effect() 
		{
			
		}
		public static function upWard(sprite:Sprite,value:int=50,time:Number=0.4,zTime:Number=0.1):void
		{
			var length:int = sprite.numChildren;
			for (var i:int = 0; i < length; i++)
			{
				sprite.getChildAt(i).alpha = 0;
				var diy:int = sprite.getChildAt(i).y;
				sprite.getChildAt(i).y = diy + value*(i+1);
				TweenMax.to(sprite.getChildAt(i),time+zTime*i,{alpha:1,y:diy})
			}
		}		
		public static function leftWard(sprite:Sprite, value:int = 50, time:Number = 0.4, zTime:Number = 0.1):void
		{
			var length:int = sprite.numChildren;
			for (var i:int = 0; i < length; i++)
			{
				sprite.getChildAt(i).alpha = 0;
				var diy:int = sprite.getChildAt(i).x;
				sprite.getChildAt(i).x = diy + value*(i+1);
				TweenMax.to(sprite.getChildAt(i), time + zTime * i, { alpha:1, x:diy } )
			}
			
		}	
		/**
		 * 缓动
		 * @param	sprite 					缓动的items
		 * @param	initPoint				从一个起始点出现
		 * @param	value					容器之间拉扯的间距
		 * @param	time					初始延时
		 * @param	zTime					累计延时
		 * @param	undulateNumber			设置弹跳的个数
		 * @param	onComplete				完成后调用的函数
		 */
		public static function BubbleFountain(sprite:Sprite, initPoint:uint=500, value:int = 200, time:Number = 0.5, zTime:Number = .1, undulateNumber:uint = 0, onComplete:Function = null):void
		{
			sprite.mouseChildren = false;
			var length:int = sprite.numChildren;
			var objectNumber:Array = [];
			for (var i:int = 0; i < length; i++)
			{
				var object:Object = sprite.getChildAt(i);
				objectNumber.push([object, object.y]); 
				object.alpha = 0;
				var diy:int = object.y;
				object.y = initPoint + value * (i + 1);
				if (i == length -1) 
				{
					TweenLite.to(object, time + zTime * i, { y: diy, ease:Cubic.easeInOut,onComplete: resumeFunction()} );
					TweenMax.to(object,time+(zTime + 0.3) * (i + 1),{alpha:1})
				}
				else
				{
					TweenLite.to(object,  time + zTime * i, { y: diy, ease:Cubic.easeInOut});
					TweenMax.to(object,time+(zTime + 0.3) *(i + 1),{alpha:1})
				}
			}
			 
			var orderPlay:int = 0;
			function resumeFunction():void
			{
				sprite.mouseChildren = true;
				for (var i:int = 0; i < undulateNumber; i++)
				{
					var object:Object = objectNumber[i][0];
					var diy:int = objectNumber[i][1] - (value / 4);
					TweenMax.to(object, time + zTime , { y: diy,  onComplete: reSetSwzi } )
				}
				if (onComplete != null) 
				{
					onComplete();
				}
				
			}
			
			function reSetSwzi():void
			{
				var object:Object = objectNumber[orderPlay][0];
				var diy:int = objectNumber[orderPlay][1];
				TweenMax.to(object, time + zTime * (undulateNumber - 1) , { y: diy, ease:Back.easeOut, onComplete: RestoreSettings} )
				orderPlay ++;
			}
			
			function RestoreSettings():void
			{
				DisplayObject(sprite).dispatchEvent(new Event(Event.COMPLETE));
			}
			
		}		
		/**
		 * W8界面算法
		 * @param	sprite
		 * @param	value
		 * @param	time
		 * @param	zTime
		 */
		public static function window8Ward(sprite:Sprite, value:int = 50, time:Number = 0.3, zTime:Number = 0.1):void
		{
			var length:int = sprite.numChildren;
			var number:int = length;
			var SpriteArray:Array = [];
			var spriteWidth:Number;
			for (var i:int = 0; i < length; i++)
			{
				spriteWidth = sprite.getChildAt(i).width;
				sprite.getChildAt(i).alpha = 0;
				sprite.getChildAt(i).scaleX = 0.9;
				sprite.getChildAt(i).scaleY = 0.9 ;
				var diy:int = sprite.getChildAt(i).x;
				for (var j:int = 1 + i; j < number; j++) 
				{
					if (sprite.getChildAt(i).x - sprite.getChildAt(j).x < spriteWidth && sprite.getChildAt(i).x - sprite.getChildAt(j).x >= -(spriteWidth - sprite.getChildAt(j).width ) && sprite.getChildAt(i) != sprite.getChildAt(j))
					{
						for (var k:int = 0; k < SpriteArray.length; k++) 
						{
							if (sprite.getChildAt(j) === SpriteArray[k])
							{
								break;
							}
						}
						if (sprite.getChildAt(j) !== SpriteArray[k]) 
						{
							sprite.getChildAt(j).alpha = 0;
							sprite.getChildAt(j).scaleX = 0.9;
							sprite.getChildAt(j).scaleY = 0.9 ;
							var diy1:int = sprite.getChildAt(j).x;
							sprite.getChildAt(j).x = diy1 + value * (i);
							TweenMax.to(sprite.getChildAt(j), time + zTime * i, {x:diy1, scaleX:1 , scaleY:1 } )
							TweenMax.to(sprite.getChildAt(j), time + zTime * i + .2, { alpha:1} )
						}
						SpriteArray.push(sprite.getChildAt(j));
						length --;
					}
				}
				sprite.getChildAt(i).x = diy + value * (i);
				TweenMax.to(sprite.getChildAt(i), time + zTime * i, { x:diy ,scaleX:1 ,scaleY:1} )
				TweenMax.to(sprite.getChildAt(i), time + zTime * i + .2, { alpha:1 } )
			}
		}
		public static function leftEffectAPP(child:DisplayObject,parent:DisplayObjectContainer):void
		{
			var tempBitmap:BitmapData = new BitmapData(child.stage.stageWidth,child.stage.stageHeight, true, 0)
			tempBitmap.draw(child)
			var bitmap:Bitmap = new Bitmap(tempBitmap)
			parent.addChild(bitmap)
			bitmap.x = child.stage.stageHeight;
			bitmap.alpha=0
			TweenLite.to(bitmap, 0.6, {x:0,alpha:1,onComplete:onLeftComplete } )
			function onLeftComplete():void
			{
				bitmap.parent.removeChild(bitmap)
				bitmap.bitmapData.dispose()
				bitmap = null;
				child.visible = true;
			}
		}
		public static function rightEffectAPP(child:DisplayObject,parent:DisplayObjectContainer):void
		{
			var tempBitmap:BitmapData = new BitmapData(child.stage.stageWidth,child.stage.stageHeight, true, 0)
			tempBitmap.draw(child)
			child.visible = false;
			var bitmap:Bitmap = new Bitmap(tempBitmap)
			parent.addChild(bitmap)
			TweenLite.to(bitmap, 0.5, {x:bitmap.width, alpha:0,onComplete:onLeftComplete } )
			function onLeftComplete():void
			{
				bitmap.parent.removeChild(bitmap)
				bitmap.bitmapData.dispose()
				bitmap = null;
			}
		}
		public static function colorEffect(colorMaterial:Object,color:uint,time:Number=0.5):void 
		{
			var colors:Object = {value:colorMaterial.color};
			TweenMax.to(colors,time, { hexColors: { value:color }, onUpdate:drawGradient } );
			function drawGradient():void
			{
			   colorMaterial.color = colors.value;
			}
		}
		
	}

}