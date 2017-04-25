package snow.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import away3d.textures.BitmapCubeTexture
	import ghostcat.display.movieclip.MovieClipCacher
	import starling.textures.Texture;
	/*贴图处理工具
	 */
	public class TextureTool 
	{
		//天空盒6面图处理
		public static function skyBoxTextureList(data:BitmapData):Vector.<BitmapData>
		{
			var length:int = data.width / 3;
			var bitmapList:Vector.<BitmapData> = new Vector.<BitmapData>();
			var mode:Array = [[0, 1, 0],
			                  [1, 1, 1],
			                  [0, 1, 0],
			                  [0, 1, 0]];
							  
		    var vl:int=0,hl:int = 0;
			for (vl = 0; vl < 4; vl++) 
			{
				for (hl = 0; hl < 3; hl++)
				{
					if (mode[vl][hl])
					{
				      var bmp:BitmapData = new BitmapData(length,length);
				      bmp.copyPixels(data, new Rectangle(hl * length, vl * length, length, length), new Point());
					  var bitMap:BitmapData = Handle.bitmapDataOfTwo(bmp, getNextPowerOfTwo(length), getNextPowerOfTwo(length), true);
					  bitmapList.push(bitMap);
					}
				}
			}
			data.dispose()
			data = null;
			return bitmapList;
		}
		//Box贴图处理
		public static function BitmapCubeMaterial(data:BitmapData):BitmapCubeTexture
		{
			var bitmapList:Vector.<BitmapData> = TextureTool.skyBoxTextureList(data)
			var data5:BitmapData = bitmapList[5]			
			var dataTemp:BitmapData = new BitmapData(data5.width, data5.height);						
			var matrix:Matrix=new Matrix()
			matrix.rotate(Math.PI);
			matrix.translate(data5.width,data5.height)
			dataTemp.draw(data5,matrix);
			bitmapList.pop().dispose();
			data5.dispose()
			data5 = null;
			bitmapList.push(dataTemp);
			var bitmapCube:BitmapCubeTexture=new BitmapCubeTexture(bitmapList[3], bitmapList[1],bitmapList[0], bitmapList[4],bitmapList[2], bitmapList[5]);
			return bitmapCube;
		}
		public static function MovieClipBitmaps(mc:MovieClip,assetCom:Function):void
		{
			var movieClipCacher:MovieClipCacher = new MovieClipCacher(mc)
			movieClipCacher.addEventListener(Event.COMPLETE, function onAssetComplete(e:Event):void
			{
				assetCom(movieClipCacher.result)
			})
		}
	}

}