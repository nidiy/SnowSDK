package snow.utils 
{
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	import deng.fzip.FZipEvent;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import ghostcat.text.FilePath;
	import spine.SkeletonData;
	import spine.SkeletonJson;
	import spine.atlas.Atlas;
	import spine.attachments.AtlasAttachmentLoader;
	import spine.attachments.AttachmentLoader;
	import spine.starling.SkeletonAnimation;
	import spine.starling.StarlingTextureLoader;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * Spine动画加载器，可直接加载byts数据
	 * @author Tim
	 */
	public class SpineLoader extends FeathersControl 
	{
		
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();
		private static const HELPER_RECTANGLE2:Rectangle = new Rectangle();
		
		public var jsonData:String;
		public var atlasData:String;		
		public var TankAtlasTexture:BitmapData;
		protected var _skeletonData:SkeletonData
		protected var _atlas:Atlas
		protected var bmpBytes:ByteArray
		protected var _skeleton:SkeletonAnimation
		protected var fzip:FZip
		protected var _source:Object = null;		
		public var isAutoPlay:Boolean = true;		
		public var actionGroup:String = "";		
		public var groupGap:Number = 1000;		
		public var isRandom:Boolean = true;		
		public var defaultAction:String;
		protected var index:int = 0;
		public function SpineLoader() 
		{
			fzip = new FZip();
			fzip.addEventListener(FZipEvent.FILE_LOADED, onFileLoaded);
			fzip.addEventListener(FZipErrorEvent.PARSE_ERROR,onParseError);
			fzip.addEventListener(flash.events.Event.COMPLETE,onFileComplete)
		}		
		public function load(request:URLRequest):void
		{
			fzip.load(request);
		}
		public function loadBytes(bytes:ByteArray):void
		{
			fzip.loadBytes(bytes)
		}
		private function onParseError(e:FZipErrorEvent):void 
		{
			this.dispatchEventWith(starling.events.Event.IO_ERROR)
		}		
		private function onFileLoaded(e:FZipEvent):void 
		{
			var fileName:String = e.file.filename;
			var path:FilePath = new FilePath(fileName)
			var tempBytes:ByteArray;
			tempBytes = e.file.content;
			if (path.extension == "png")
			{
				bmpBytes =tempBytes;
				
			}else if(path.extension=="json")
			{
				jsonData = tempBytes.readUTFBytes(tempBytes.length);
				
			}else if(path.extension=="atlas")
			{
				atlasData = tempBytes.readUTFBytes(tempBytes.length);
			}
			this.dispatchEventWith(FeathersEventType.PROGRESS)
		}
		private function onFileComplete(e:flash.events.Event):void 
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoaderComplete)
			loader.loadBytes(bmpBytes)
		}
		
		private function onLoaderComplete(e:flash.events.Event):void 
		{
			TankAtlasTexture = e.target.content.bitmapData;
			initSkeleton()
		}
		protected function initSkeleton():void
		{
			fzip.close();
			trace("动画加载完成")
			var attachmentLoader:AttachmentLoader;
			_atlas = new Atlas(atlasData, new StarlingTextureLoader(TankAtlasTexture));			
			attachmentLoader = new AtlasAttachmentLoader(_atlas);
			var json:SkeletonJson = new SkeletonJson(attachmentLoader);
			_skeletonData= json.readSkeletonData(jsonData);			
			_skeleton = new SkeletonAnimation(_skeletonData);
			if (isAutoPlay)
			{
			    _skeleton.state.setAnimation(0, _skeletonData.animations[0], true);	
			}
			this.addChild(_skeleton);
			Starling.juggler.add(_skeleton);
			this.dispatchEventWith(starling.events.Event.COMPLETE,false,_skeleton);
		}		
		public function get skeleton():SkeletonAnimation 
		{
			return _skeleton;
		}		
		public function get skeletonData():SkeletonData 
		{
			return _skeletonData;
		}	
		public function get atlas():Atlas 
		{
			return _atlas;
		}
		
		public function get source():Object 
		{
			return _source;
		}
		
		public function set source(value:Object):void 
		{
			_source = value;
			if (_source is String)
			{
				load(new URLRequest(String(_source)));
				
			}else if (_source is ByteArray)
			{
				loadBytes(ByteArray(_source))
			}
		}		
		override public function dispose():void 
		{
			if (_atlas)_atlas.dispose();
			_atlas = null;
			_skeletonData = null;
			_skeleton = null;
			super.dispose();
		}
		public function stop():void
		{
			Starling.juggler.remove(_skeleton);
		}
		public function play():void
		{
			Starling.juggler.add(_skeleton);
		}
	}

}