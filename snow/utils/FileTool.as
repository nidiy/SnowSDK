package snow.utils 
{
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
    import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import ghostcat.text.FilePath;
	/**
	 * ...
	 * @author 
	 */
	public class FileTool 
	{
		
		public static function LoadFileXML(url:String,mode:String=FileMode.READ):XML
		{
			var data:String
			var file:File= File.applicationStorageDirectory.resolvePath(url)
			var fileSM:FileStream=new FileStream()
			fileSM.open(file, mode)
			data = fileSM.readUTFBytes(fileSM.bytesAvailable)
			fileSM.close();
			return XML(data)
		}
		/**
		 * 应用程序的专用存储目录是否存在此文件
		 * @param	url
		 * @return
		 */
		public static function existStorage(url:String):Boolean
		{
			var file:File = File.applicationStorageDirectory.resolvePath(url)
			return file.exists;
		}
		public static function existApp(url:String):Boolean
		{
			var file:File = File.applicationDirectory.resolvePath(url)
			return file.exists;
		}
		public static function getStorageDirectory(url:String):String
		{
			var file:File = File.applicationStorageDirectory.resolvePath(url)
			return file.url;
		}
		public static function SaveFileXML(url:String,data:String,mode:String=FileMode.WRITE):void
		{
			var file:File
			var fileSM:FileStream=new FileStream()				
			file= new File(File.applicationStorageDirectory.resolvePath(url).nativePath)
			fileSM.open(file,mode)
			fileSM.writeUTFBytes(data)
			fileSM.close();
		}
		public static function SaveFileImage(url:String, data:BitmapData, mode:String = FileMode.WRITE):String
		{
			var file:File
			var fileSM:FileStream = new FileStream()
			var filePath:FilePath = new FilePath(url);
			var bytArray:ByteArray
			if (!data.transparent)
			{
				bytArray=data.encode(data.rect,new JPEGEncoderOptions())
			}else
			{
				bytArray=data.encode(data.rect,new PNGEncoderOptions(true))
			}				
			file= new File(File.applicationStorageDirectory.resolvePath(url).nativePath)
			fileSM.open(file,mode)
			fileSM.writeBytes(bytArray)
			fileSM.close();
			return file.nativePath;
		}
		public static function saveBitmapData(url:String, data:BitmapData, mode:String = FileMode.UPDATE):File
		{
			var file:File= File.applicationStorageDirectory.resolvePath(url);
			var fileSM:FileStream = new FileStream()
			var filePath:FilePath = new FilePath(url);
			var bytArray:ByteArray
			if (!data.transparent)
			{
				bytArray=data.encode(data.rect,new JPEGEncoderOptions())
			}else
			{
				bytArray=data.encode(data.rect,new PNGEncoderOptions(true))
			}
			fileSM.open(file,mode)
			fileSM.writeBytes(bytArray)
			fileSM.close();
			return file;
		}
		public static function saveFile(url:String,bytes:ByteArray,mode:String = FileMode.WRITE):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(url);
			var fileStream:FileStream = new FileStream()
			fileStream.open(file,mode)
			fileStream.writeBytes(bytes)
			fileStream.close();
			file.cancel();
			file = null;
			fileStream=null
		}
		public static function LoadFileImage(url:String, mode:String = FileMode.READ):ByteArray
		{
			var data:ByteArray = new ByteArray();
			var file:File= File.applicationStorageDirectory.resolvePath(url);
			var fileSM:FileStream=new FileStream()
			//文件是否存在
			if (!file.exists)
			{
				return null
			}
			fileSM.open(file, mode)
		    fileSM.readBytes(data)
			fileSM.close();
			return data
		}		
		/**
		 *  删除文件
		 * @param	url
		 */
		public static function deleteFile(url:String):Boolean
		{
			var file:File = File.applicationStorageDirectory.resolvePath(url);
			if (file.exists)
			{
			   file.deleteFileAsync();
			   return true;
			}
			return false
		}
		
	}

}