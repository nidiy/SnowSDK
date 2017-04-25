package snow.app.utils 
{
	import away3d.containers.ObjectContainer3D;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.net.LocalConnection;
	import flash.system.System;
	/**
	 * webcity2013-05-21处理方法工具集
	 * @webcity2013-05-21处理方法工具集
	 */
	public class Handle 
	{
		/**
		 * 获取相对路径 返为数组索引0为路径,索引1为文件名称
		 * @param	url
		 * @return
		 */
		public static function getURL(url:String):Array
		{

			var num:int = url.lastIndexOf('/');
			var path:String = url.substring(0,num + 1);
			var name:String = url.substring((num + 1),url.length);
			return [path,name];
		}
		public static function getRootURL(url:String):String
		{
			var num:int = url.lastIndexOf('/');
			var path:String = url.substring(0, num + 1);
			return path
		}
		/**
		 * 复制动态对象
		 * @param	value
		 * @return
		 */
		public static function copyObject(value:Object):Object
		{
			var tempObj:Object = new Object()
			for (var item:Object in value) 
			{
				tempObj[item] = value[item];
			}
			return tempObj;
		}
		/**
		 * 合并两个动态对象
		 * 
		 * @param obj1	对象1
		 * @param obj2	对象2
		 * @return 
		 * 
		 */
		public static function unionObject(obj1:Object,obj2:Object):Object
		{
			var result:Object = new Object();
			var key:*;
			for (key in obj1)
				result[key] = obj1[key];
			
			for (key in obj2)
				result[key] = obj2[key];
				
			return result;
		}
		public static function getTime():String
		{
			var times:String;
			var date:Date = new Date()
			var array:Array = String(date).split(" ")
			times = array[5] + "年" + (date.month+1) + "月" + array[2] + "日 " + array[3];
			return times
		}
		public static function getTime_name():String
		{
			var times:String;
			var date:Date = new Date()
			var array:Array = String(date).split(" ")
			times = array[5] + "_" + (date.month+1) + "_" + array[2] + "_" + array[3];
			return times
		}		
		public static function getTimeName():String
		{
			var times:String;
			var date:Date = new Date()
			var array:Array = String(date).split(" ")
			var s:String = array[3];
			var myPattern:RegExp = /:/g;  
			s = s.replace(myPattern, ""); 	
			times = array[5] + "" + (date.month+1) + "" + array[2] + "" +s;
			return times
		}
		public static function deleteRecycle():void
		{
            System.gc();
			try
			{
				(new LocalConnection).connect("foo");
			}
			catch (e:Error)
			{
				trace(System.totalMemory / (1024 * 1024) + "MB");
			}
		}
		/**
		 * 固定大小
		 * @param	Original
		 * @param	width
		 * @param	height
		 * @param	destory
		 * @param	tb
		 * @return
		 */
		public static function bitmapDataGotoSize(Original:BitmapData,width:Number=100,height:Number=100,destory:Boolean=false,tb:Boolean=false):BitmapData
		{
			var rioW:Number = 1;
			var rioH:Number = 1;
			rioW = width / Original.width;
			rioH = height / Original.height;
			var bd:BitmapData = new BitmapData(width,height,Original.transparent,0);
			var matrix:Matrix = new Matrix();
			matrix.scale(rioW, rioH);
			bd.draw(Original,matrix);
			if (destory)
			{
				Original.dispose();
				Original = null;
			}
			return bd;
		}
		/**
		 * 限制在设定大小内自动缩放
		 * @param	Original
		 * @param	width
		 * @param	height
		 * @param	destory
		 * @param	tb
		 * @return
		 */
		public static function bitmapDataSize(Original:BitmapData,width:Number,height:Number,destory:Boolean=false,tb:Boolean=false):BitmapData
		{
			var rio:Number = 1;
			if(Original.width >= Original.height)
			{
				rio =width/Original.width;
			}
			else
			{
				rio =height/Original.height;
			}			
			var bd:BitmapData = new BitmapData(Original.width*rio,Original.height*rio,Original.transparent,0);
			var matrix:Matrix = new Matrix();
			matrix.scale(rio, rio);
			bd.draw(Original,matrix);
			if (destory)
			{
				Original.dispose();
				Original = null;
			}
			return bd;
		}		
		public static function bitmapDataForSize(Original:BitmapData,width:Number,height:Number,destory:Boolean=false,tb:Boolean=false):BitmapData
		{
			var rio:Number = 1;
			if(width>=height)
			{
				rio =width/Original.width;
			}
			else
			{
				rio =height/Original.height;
			}			
			var bd:BitmapData = new BitmapData(Original.width*rio,Original.height*rio,Original.transparent,0);
			var matrix:Matrix = new Matrix();
			matrix.scale(rio, rio);
			bd.draw(Original,matrix);
			if (destory)
			{
				Original.dispose();
				Original = null;
			}
			return bd;
		}
		public static function bitmapDataOfTwo(Original:BitmapData, width:Number=0, height:Number=0, destory:Boolean = false):BitmapData
		{
			if (Original == null) return null;
			var rioX:Number = 1;
			var rioY:Number = 1;
			if (width==0)
			{
				width = getNextPowerOfTwo(Original.width)
				if (width > 2048) width = 2048;
			}
			if (height==0)
			{
				height = getNextPowerOfTwo(Original.height)
				if (height > 2048) height = 2048;
			}
			rioX =width/Original.width;
			rioY = height/Original.height;		
			var bd:BitmapData = new BitmapData(width,height,Original.transparent,0);
			var matrix:Matrix = new Matrix();
			matrix.scale(rioX, rioY);
			bd.draw(Original,matrix,null,null,null,true);
			if (destory)
			{
				Original.dispose();
				Original=null;
			}
			return bd;
		}
		public static const CHAR:String="0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
		public static const CHAR_NUM:String="0123456789"
		public static function getChar(len:int):String
		{
			var char:String = "";
			for (var i:int = 0; i < len; i++) 
			{	
				char+=String(CHAR).charAt(int(Math.random() * 62));
			}
			return char;
		}		
		public static function getNum(len:int):String
		{
			var char:String = "";
			for (var i:int = 0; i < len; i++) 
			{	
				char+=String(CHAR_NUM).charAt(int(Math.random() * 10));
			}
			return char;
		}
		public static function getDayTime():String
		{
			var data:Date = new Date();
			var year:Number = data.getFullYear();
			var month:Number = data.getMonth();
			var date:Number = data.getDate();
			var day:Number = data.getDay();
			var huor:Number = data.getHours();
			var minute:Number = data.getMinutes();
			var second:Number = data.getSeconds();
			var days:Array = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
			var times:String = year+"-"+(month+1)+"-"+date+" "+huor+":"+minute+":"+second + " "+days[day];
			return times;
		}
		public static function validatemobile(phone:String):Boolean
	    { 
		   if(phone.length==0) 
		   { 
			  return false; 
		   } 
		   if(phone.length!=11) 
		   { 
			   return false; 
		   } 
				  
		   var myreg:RegExp = /^13[0-9]{9}$|14[0-9]{9}$|15[0-9]{9}$|18[0-9]{9}$/; 
		   if(!myreg.test(phone)) 
		   { 
			   return false; 
		   }
		   return true;
	    } 
		public static function initSpace(object3d:ObjectContainer3D,value:Object):void
		{
			if (value.x) object3d.x = value.x;
			if (value.y) object3d.y = value.y;
			if (value.z) object3d.z = value.z;
			
			if (value.scaleX) object3d.scaleX = value.scaleX;
			if (value.scaleZ) object3d.scaleZ = value.scaleZ;
			if (value.scaleY) object3d.scaleY = value.scaleY;
			
			if (value.rotationX) object3d.rotationX = value.rotationX;
			if (value.rotationY) object3d.rotationY = value.rotationY;
			if (value.rotationZ) object3d.rotationZ = value.rotationZ;
		}
		/**
		 * 调整亮度
		 * brite为亮度值 -255~255
		 */
		public static function adjustBrightness(rgb:uint, brite:Number):uint
		{
			var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);			
			return RGB(r,g,b);
		} 
		/**
		 * 合并颜色值
		 * @param r	红
		 * @param g	绿
		 * @param b	蓝
		 * 
		 */	
		public static function RGB(r:uint,g:uint,b:uint):uint
		{
			return (r << 16) | (g << 8) | b;
		}
		public static function computTime(value:Number):String
		{
			var hou_str:String = "";
			var min_str:String = "";
			var sec_str:String = "";
			var hours:Number= Math.floor(value / 3600);
			var minute:Number = Math.floor(value / 60);
			var second:Number= Math.round(value % 60);
			if (hours >= 10)
			{
				hou_str=String(hours);
			}else
			{
				hou_str = "0" + hours;
			}
			if (minute >= 10)
			{
				min_str = String(minute);
			}
			else
			{
				min_str = "0" + minute;
			}
			if (second >= 10)
			{
				sec_str = String(second);
			}
			else
			{
				sec_str = "0" + second;
			}
			return hou_str + ":" + min_str + ":" + sec_str;
		}
		
	}

}