package snow.app.model.loader 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import ghostcat.text.FilePath;
	import snow.app.model.DataProvider;
	import flash.system.ApplicationDomain
	import snow.app.event.DataChangeEvent;
	import snow.app.event.DataLoaderEvent;
	/**
	 * 资源加载器基类
	 * @author 
	 */
	public class LoaderControl extends EventDispatcher implements ILoader
	{
		protected var loaderContext:LoaderContext;
		protected var _dataProvider:DataProvider
		protected var loader:Loader;
		protected var dataLoader:URLLoader;
		protected var urlQuest:URLRequest
		
		protected var extList:String = "jpg,JPG,PNG,png,SWF,swf,flv,FLV,MP4,mp4"
		
		protected var index:uint = 0;
		protected var loadNum:uint = 0;
		protected var sumNum:uint = 0;
		protected var id:String = null;
		protected var stopIndex:int = 0;
		public function LoaderControl() 
		{
			loaderContext=new LoaderContext(true,ApplicationDomain.currentDomain,null)
			loader = new Loader();
			dataLoader = new URLLoader();
			urlQuest = new URLRequest();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteMedia)
			dataLoader.addEventListener(Event.COMPLETE, onCompleteData)
		}
		/**
		 * 加载对列存储器,主要用于存储需要加载的资源对像,每个资源对象Object
		 */
		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
			sumNum = _dataProvider.length;
		}
		/**
		 * <p>加载队列存储器,主要用于存储需要加载的资源对像,每个资源对象类型为Object其中</p>
		 * <p>每个Object对象中包含mime、resURL、resID</p>
		 * <p>mime资源类型:  类型只能data(文本类型,如:txt,xml,html等文本类信息),media(显示对象类型如：swf,png,jpg等媒体资源)</p>
		 * resURL:  为资源链接地址
		 * resID:   为资源ID
		 * 例:  var obj:Object = new Object();
			    obj.resURL = "res/webcity.swf"
			    obj.resID = "res"
			    obj.mime = "media"
			    dataProvider.addItem(obj)
				如此则增加了一个加载队列,队列增加完成且使用start()方法启动加载
				加载完成后资源将存储在对像的res属性中如: obj.res 
		 */
		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}
		/**
		 *通过资源ID查找该资源是否已经加载好
		 * @param	value
		 * @return
		 */
		public function find(value:String):Boolean
		{
			if (_dataProvider.getItemAtByField("resID", value).res != null)
			{
				return true;
				
			}else {
				
				return false;
			}
		}
		/**
		 * 加载对应ID资源，若当前加载的资源ID与需加载的ID相同则直接加载，若不同则查找资源ID对应的加载对列的索引 value需要加载的ID号
		 * @param	value
		 */
		public function loadID(value:String):void
		{
			if (id == value)
			{
				return 
			}else
			{
				stopIndex = loadNum;
				loadNum = _dataProvider.getItemIndexByField("resID", value);
				next(loadNum);
			}
		}
		protected function next(k:int):void
		{
			if (index<sumNum)
			{
				if (k<sumNum)
				{
			       var obj:Object = _dataProvider.getItemAt(k)
			       urlQuest.url = obj.resURL;
			       id = obj.resID;
				   if (find(id))
				   {
					   loadNum++;
					   next(loadNum)
				   }else {					  
					 var filePath:FilePath = new FilePath(urlQuest.url)
					 if (extList.indexOf(filePath.extension) >= 0)
					 {
				        loader.load(urlQuest,loaderContext);
					   
			         }else
			         {
						dataLoader.load(urlQuest);			
			         }
				   }
				}else
				{
					next(stopIndex)
				}
			}else
			{
				allComplete()
			}
		}
		private function allComplete():void
		{
			stopIndex = loadNum;
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.DATA_ALL_COMPLETE, null));			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteMedia)
			dataLoader.removeEventListener(Event.COMPLETE, onCompleteData)
		}
		private function onCompleteMedia(e:Event):void
		{
			_dataProvider.getItemAt(loadNum).res = e.target.content;
			index++;
			loadNum++;
			next(loadNum);
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.DATA_COMPLETE,id));
		}
		private function onCompleteData(e:Event):void
		{
			_dataProvider.getItemAt(loadNum).res = e.target.data;
			index++
			loadNum++;
			next(loadNum);
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.DATA_COMPLETE,id));
		}
		/**
		 * 关闭加载器
		 */
		public function close():void
		{
			pause()
		}
		public function pause():void
		{
		    stopIndex=loadNum;
			try {
				loader.close()
				dataLoader.close();				
			}catch (e:Error)
			{
				
	        }
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.DATA_STOP_LOAD,null));			
		}
		/**
		 * 开始加载
		 */
		public function start():void
		{
			//stopIndex = 0;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteMedia);
			dataLoader.addEventListener(Event.COMPLETE,onCompleteData);
			sumNum = _dataProvider.length;
			next(stopIndex);
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.DATA_START_LOAD,null));
		}
		/**
		 * 卸掉加载器加载所有资源
		 */
		public function unload():void
		{
			close();
		    _dataProvider.removeAll();
			_dataProvider = null;
		}
		
	}

}