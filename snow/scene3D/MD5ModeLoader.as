package snow.scene3D 
{
	import adobe.utils.CustomActions;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.BindingTag;
	import away3d.entities.Mesh;
	import away3d.events.AnimationStateEvent;
	import away3d.events.AnimatorEvent;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.textures.MovieAssetTexture;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout
	import flash.utils.setInterval
	import flash.utils.clearTimeout
	import ghostcat.text.FilePath;
	import snow.app.model.DataProvider;
	import snow.event.Scene3DEvent;
	import snow.parser.ModelParsers;
	import snow.utils.debugDrag.Drag3DTool;
	import snow.utils.XMLUtil;
	/**
	 * 模型解析器
	 * ...
	 * @author 
	 */
	public class MD5ModeLoader extends ObjectContainer3D 
	{
		public static const MESH_ACTION_COMPLETE:String = "meshActioComplete";
		public static const ALL_LOAD_COMPLETE:String = "allLoadComplete";
		public var dispatcher:EventDispatcher
		
		
		
		protected var loadXML:URLLoader
		protected var _md53Dobjects:Vector.<MD53DObject> = null;
		protected var _pendantMeshs:Vector.<MD53DObject> = null;
		protected var _defaultAction:String = ""
		protected var _autoTimeGap:int = 5000;
		protected var _autoActions:Array = new Array();
		private var stateTransition:CrossfadeTransition = new CrossfadeTransition(0.5);
		
		protected var meshSum:int = 0;
		protected var actionSum:int = 0;
		protected var materialSum:int = 0;
		protected var pendantSum:int = 0;
		protected var dispatcherSum:int = 0;
		
		protected var urlRequest:URLRequest;
		protected var loadNum:int = 0;
		protected var loaderAction:Loader3D;
		private var loadmeshAll:Boolean = false;
		protected var _alpha:Number = 1;
		protected var timeID:uint = 0
		
		protected var actionDictionary:DataProvider=new DataProvider()
		protected var meshDictionary:DataProvider = new DataProvider();
		protected var materialDictionary:DataProvider = new DataProvider();
		protected var pendantDictionary:DataProvider = new DataProvider();
		protected var dispatcherDictionary:DataProvider = new DataProvider();
		
		protected var _modelParsers:ModelParsers
		protected var actionNum:int = 0;
		protected var actionCom:int = 0;
		protected var _debug:Boolean = false;
		protected var _drag3DTool:Drag3DTool
		protected var _interactive:Boolean = false;
		
		public var rootURL:String = "";
		protected var isStopLoad:Boolean = false;
		public var onObject3DHandler:Function=null
		public function MD5ModeLoader(interactive:Boolean=false) 
		{
			super();
			createObject();
			this._interactive = interactive;
			dispatcher = new EventDispatcher();
			initObject()
		}
		protected function createObject():void
		{
			_md53Dobjects = new Vector.<MD53DObject>;
			_pendantMeshs = new Vector.<MD53DObject>;
		}
		protected function initObject():void
		{
			urlRequest = new URLRequest();
			loadXML = new URLLoader();
			loadXML.addEventListener(Event.COMPLETE, onXMLComplete);
			
			loaderAction = new Loader3D();
			loaderAction.addEventListener(AssetEvent.ASSET_COMPLETE, onAnimationComplete)
		}
		protected function onXMLComplete(e:Event):void 
		{
		    var xmldata:XML = XML(e.target.data);
			initData(xmldata)			
		}
		public function initData(xmldata:XML):void
		{
			_defaultAction = xmldata["defaultAction"].@name;
			_autoTimeGap = xmldata.auto.@timeGap;
			var autos:String=xmldata.auto.@action
			_autoActions = autos.split(",");
			_interactive = xmldata.interactive == "true"?true:false;
			debug = xmldata.debug == "true"?true:false;
			
			var meshXMLlist:XMLList = xmldata.mesh.children();
			meshSum = meshXMLlist.length();			
			var tempData:Object
			for (var i:int = 0; i <meshSum; i++) 
			{
				tempData = new Object();
				XMLUtil.attributesToObject(meshXMLlist[i],tempData)
				XMLUtil.xmlToObject(meshXMLlist[i], tempData)
				tempData.url= rootURL+tempData.url;
				meshDictionary.addItem(tempData)
			}
			var actionXMLList:XMLList = xmldata.action.children();
			actionSum = actionXMLList.length();
			for (var j:int = 0; j <actionSum; j++) 
			{
				tempData = new Object();
				XMLUtil.attributesToObject(actionXMLList[j], tempData);
				XMLUtil.xmlToObject(actionXMLList[j], tempData);
			    tempData.url= rootURL+tempData.url;
				actionDictionary.addItem(tempData)
			}			
			var materialXMLList:XMLList = xmldata.material.children();
			materialSum = materialXMLList.length();
			for (var k:int = 0; k <materialSum; k++) 
			{
				tempData = new Object();
				XMLUtil.attributesToObject(materialXMLList[k], tempData);
				XMLUtil.xmlToObject(materialXMLList[k], tempData);
				if (tempData.type!="color")
				{
					tempData.value= rootURL+tempData.value;
				}
				materialDictionary.addItem(tempData)
			}
			var pendantXMLList:XMLList = xmldata.pendant.children();
			pendantSum = pendantXMLList.length();
			for (var l:int = 0; l <pendantSum; l++) 
			{
				tempData = new Object();
				XMLUtil.attributesToObject(pendantXMLList[l],tempData);
				XMLUtil.xmlToObject(pendantXMLList[l], tempData);
				tempData.url= rootURL+tempData.url;
				pendantDictionary.addItem(tempData)
			}
			var dispatcherXMLList:XMLList = xmldata.dispatcher.children();
			dispatcherSum = dispatcherXMLList.length();
			for (var m:int = 0; m < dispatcherSum; m++) 
			{
				tempData = new Object()
				XMLUtil.attributesToObject(dispatcherXMLList[m], tempData);
				XMLUtil.xmlToObject(dispatcherXMLList[m], tempData);
				if (tempData.data != null)
				{
				    tempData.data = new Object();
					XMLUtil.xmlToObject(XML(dispatcherXMLList[m].data), tempData.data);
					
				}
				dispatcherDictionary.addItem(tempData)
			}
			if(isStopLoad)return
			loadMD5();			
			
		}
		/**
		 * 初始化显示对像空间坐标信息
		 * @param	object3d
		 * @param	value
		 */
		protected function initSpace(object3d:ObjectContainer3D,value:Object):void
		{
			if (object3d == null) return;
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
		private var md53D:MD53DObject
		protected function loadMD5():void
		{
			if (isStopLoad) return;
			
			var extra:Object=meshDictionary.getItemAt(loadNum)
			md53D = new MD53DObject();
			md53D.extra = extra;
			md53D.mouseEnabled = _debug;
			if (extra.eventName && extra.eventName != "")
			{
				md53D.mouseEnabled = _interactive;
				md53D.addEventListener(MouseEvent3D.MOUSE_OVER, onOver3D)
				md53D.addEventListener(MouseEvent3D.MOUSE_UP, onUp3D)
				md53D.addEventListener(MouseEvent3D.MOUSE_OUT, onOut3D)
				md53D.addEventListener(MouseEvent3D.MOUSE_DOWN, onDown3D)
			}			
			md53D.name =extra.name;
			md53D.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onMD5ObjectComplete)
			md53D.addEventListener(LoaderEvent.LOAD_ERROR, onMD5ObjectComplete)
			if (!_debug)
			{
				md53D.addEventListener(MouseEvent3D.CLICK, onObject3DClick)
			}
			var url:String=extra.url
			md53D.load(url);
			initSpace(md53D,extra)
			_md53Dobjects.push(md53D)		
		}
		private function onMD5ObjectComplete(e:LoaderEvent):void 
		{
			if(isStopLoad)return
			e.target.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,onMD5ObjectComplete)
			loadNum++;
			if (loadNum >=meshSum)
			{
				loadNum = 0;
				loadmeshAll=true;
				LoadAction();
				return;
			}
			loadMD5()
		}		
		private function onAnimationComplete(event:AssetEvent):void 
		{
			if (event.asset.assetType == AssetType.ANIMATION_NODE) 
			{
				var node:SkeletonClipNode = event.asset as SkeletonClipNode;
				var name:String = event.asset.assetNamespace;
				node.name = name
				if (name == _defaultAction)
				{
					node.looping = true
				}else
				{
					node.looping = false
					node.addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE,onPlaybackComplete)
				}
				for (var i:int = 0; i < _md53Dobjects.length; i++) 
				{
					if ( _md53Dobjects[i].animationSet)
					{
				      _md53Dobjects[i].animationSet.addAnimation(node);
					}
				}
				loadNum++;
				LoadAction();
			}
		}
		protected var resetBool:Boolean = true;
		protected function onPlaybackComplete(e:AnimationStateEvent):void 
		{
			if (SkeletonAnimator(e.animator).activeState != e.animationState) return;
			actionNum++
			if (actionNum >=actionCom)
			{
				if (playlisting)
				{
					resetPlays()
					
				}else
				{
				   reset()
				}
			}
		}
		private function LoadAction():void
		{
			if(isStopLoad)return
			if (loadNum >=actionSum)
			{
				allMeshModelComplete();
				return;
			}
			urlRequest.url = actionDictionary.getItemAt(loadNum).url;
			var ns:String = actionDictionary.getItemAt(loadNum).name;
			loaderAction.load(urlRequest, null, ns, new MD5AnimParser());
		}
		/**
		 * 初始化材质信息
		 */
		protected function initMaterial():void
		{
			if (_modelParsers)
			{
				var mL:int = materialDictionary.length;
				var tempData:Object
				var m_name:String
				for (var i:int = 0; i <mL; i++) 
				{
					tempData = materialDictionary.getItemAt(i)
					m_name = tempData.name;
					setNameItem(m_name,tempData)
				}
			}
		}
		/**
		 * 加载骨骼绑定物体
		 */
		private function loadPendant():void
		{
			if (loadNum >=pendantSum)
			{
				allPendantModelComplete();
				return;
			}
			var extra:Object=pendantDictionary.getItemAt(loadNum)
			var pendantMesh:MD53DObject = new MD53DObject();
			pendantMesh.mouseEnabled = _debug;
			if (extra.eventName && extra.eventName != "")
			{
				pendantMesh.mouseEnabled = _interactive;
				pendantMesh.addEventListener(MouseEvent3D.MOUSE_OVER, onOver3D)
				pendantMesh.addEventListener(MouseEvent3D.MOUSE_UP, onUp3D)
				pendantMesh.addEventListener(MouseEvent3D.MOUSE_OUT, onOut3D)
				pendantMesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onDown3D)
			}		
			_pendantMeshs.push(pendantMesh)
			pendantMesh.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onPendantMeshComplete)
			if (!_debug)pendantMesh.addEventListener(MouseEvent3D.CLICK,onObject3DClick)
			var url:String = extra.url
			pendantMesh.extra = extra;
			pendantMesh.name =extra.name;
			initSpace(pendantMesh,extra)
			pendantMesh.load(url);
			
		}
		private function onPendantMeshComplete(e:LoaderEvent):void 
		{
			var pendantMesh:MD53DObject = e.currentTarget as MD53DObject
			pendantMesh.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,onPendantMeshComplete)
			var skeletonName:String = pendantDictionary.getItemAt(loadNum).target;
			var index:int = -1;
			var length:int = _md53Dobjects.length;
			var tempmd53Dobject:MD53DObject = null;
			for (var i:int = 0; i <length; i++) 
			{
				index = _md53Dobjects[i].animator.skeleton.jointIndexFromName(skeletonName)
				if (index != -1)
				{
					tempmd53Dobject = _md53Dobjects[i];
					break;
				}
			}
			var bindingTag:BindingTag = _md53Dobjects[0].animator.addBindingTagByIndex(index)
			if (bindingTag)
			{
			   bindingTag.addChild(pendantMesh);
			}
			loadNum++
			loadPendant();
		}
		private function allPendantModelComplete():void 
		{
			updata()
			//所有加载完成
		}
		/**
		 * 所有Mesh加载完成
		 */
		protected function allMeshModelComplete():void
		{
			if (isStopLoad) return;
    		for (var i:int = 0; i < _md53Dobjects.length; i++) 
			{
				addChild(_md53Dobjects[i])
			}
			loadNum = 0;
			initMaterial()
			loadPendant();
		    if (_defaultAction != "") play(_defaultAction);
			this.dispatchEvent(new Event(MD5ModeLoader.MESH_ACTION_COMPLETE));
		}
		public function load(configURL:String):void
		{
			if (configURL.indexOf("http://") != -1)
			{
				var last:int = configURL.lastIndexOf("/");
				if (last != -1)
				{
					rootURL = configURL.substr(0, last + 1);
				}
				
			}else
			{
				var filePath:FilePath = new FilePath(configURL)
				rootURL = filePath.getPath();
			}
			
			urlRequest.url = configURL;
			loadXML.load(urlRequest)
		}
		protected var isReset:Boolean = true;
		/**
		 * 播放动画 name动画名称  looping 是否循环 speed播放速度
		 * @param	name
		 * @param	looping
		 * @param	speed
		 */
		public function play(name:String = null,looping:Boolean=true,speed:Number=1,isReset:Boolean=true):void
		{
			if (_md53Dobjects == null)
			{
				clearTimeout(timeID);
				return;
			}
			if (name == null) return;
			clearTimeout(timeID);
			this.isReset = isReset;
			var names:Vector.<String>
			actionCom = 0;
			for (var i:int = 0; i < _md53Dobjects.length; i++) 
			{
				if (_md53Dobjects[i].animationSet == null) continue;
				names = _md53Dobjects[i].animationSet.animationNames
				if (names&&names.indexOf(name) != -1)
				{
					actionCom++;
					_md53Dobjects[i].animator.playbackSpeed = speed;
					_md53Dobjects[i].animator.play(name, stateTransition, 0)
					SkeletonClipNode(_md53Dobjects[i].animationSet.getAnimation(name)).looping = looping;
				}
			}
		}
		/**
		 * 重置动画，一般会返回到默认动画
		 */
		public function reset():void
		{
			if (!isReset) return;
			actionNum = 0;
			plsysIndex = 0;
			playlisting = false;
			clearTimeout(timeID);
			if (_defaultAction == "") return;
			play(_defaultAction)
			timeID = setTimeout(random,_autoTimeGap)			
			resetBool = true;
		}
		protected var contI:int=-1
		public function random():void
		{
			if (_autoActions == null) return;
			var index:int = 0
			if (_autoActions.length > 1)
			{
				index= Math.random() * _autoActions.length;
				while (contI==index)
				{
				  index= Math.random() * _autoActions.length;
				}
			}
			contI = index
			play(_autoActions[index],false)
		}
		public function stop():void
		{
		    for (var i:int = 0; i < _md53Dobjects.length; i++) 
			{
				if (_md53Dobjects[i].animationSet == null) continue;
				_md53Dobjects[i].animator.stop()
			}
		}
		protected var playlisting:Boolean = false;
		protected var _players:Array=null;
		protected var _gapTime:Number=0;
		protected var plooping:Boolean = false;
		protected var randoming:Boolean = false;
		protected var plsysIndex:int = 0;
		/**
		 * 播放动作序列，names需要播放序列名称组,looping是否循环播放序列,每个动作间隔时间,
		 * @param	names
		 * @param	looping
		 * @param	gapTime
		 */
		public function plays(names:Array = null,looping:Boolean=true,gapTime:Number=1000,randoming:Boolean=false):void
		{
			this._players = names;
			this._gapTime = gapTime;
			this.plooping = looping;
			this.randoming = randoming;
			var _names:String = "";
			var index:int=0
			if (_players != null&&_players.length!=0)
			{
				playlisting = true;
				if (looping)
				{
					if (randoming)
					{
					   index= Math.random() * names.length;
					}else
					{
						if (plsysIndex >= names.length)plsysIndex = 0;
						index = plsysIndex;
						plsysIndex++;
					}
					_names = names[index];
					
				}else
				{
					if (randoming)
					{
					   index= Math.random() * names.length;
					}else
					{
						index =0
					}
					_names = names.splice(index, 1)[0];
				}
				play(_names,false)
			}else
			{
				reset();
			}
		}
		public function resetPlays():void
		{
			actionNum = 0;
			clearTimeout(timeID);
			if (!_defaultAction == ""&&_gapTime>0)
			{
			    play(_defaultAction)
			}
			timeID = setTimeout(plays,_gapTime,_players,plooping,_gapTime,randoming)			
			resetBool = true;
		}
		public function get defaultAction():String 
		{
			return _defaultAction;
		}		
		public function get md53Dobjects():Vector.<MD53DObject> 
		{
			return _md53Dobjects;
		}	
		public function get modelParsers():ModelParsers 
		{
			return _modelParsers;
		}		
		public function set modelParsers(value:ModelParsers):void 
		{
			_modelParsers = value;
			if (loadmeshAll)
			{
				initMaterial();
			}
		}		
		public function get debug():Boolean 
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void 
		{
			_debug = value;
			updata();
		}		
		public function get drag3DTool():Drag3DTool 
		{
			return _drag3DTool;
		}		
		public function set drag3DTool(value:Drag3DTool):void 
		{
			_drag3DTool = value;
		}
		
		public function get interactive():Boolean 
		{
			return _interactive;
		}
		
		public function set interactive(value:Boolean):void 
		{
			_interactive = value;
		}
		public function updata():void
		{
			var _length:int = _md53Dobjects.length;
			for (var i:int = 0; i < _length; i++) 
			{
				if (_debug)
				{
					_md53Dobjects[i].addEventListener(MouseEvent3D.MOUSE_DOWN, Object3DDownHandler)
					
				}else
				{
					_md53Dobjects[i].removeEventListener(MouseEvent3D.MOUSE_DOWN, Object3DDownHandler)
				}
			}
			_length = _pendantMeshs.length;
			for (var j:int = 0; j <_length; j++) 
			{
				if (_debug)
				{
					_pendantMeshs[j].addEventListener(MouseEvent3D.MOUSE_DOWN, Object3DDownHandler)
					
				}else
				{
					_pendantMeshs[j].removeEventListener(MouseEvent3D.MOUSE_DOWN,Object3DDownHandler)
				}
			}			
		}		
		
		private function onDown3D(e:MouseEvent3D):void 
		{
		   var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
		   	if (!isInitScale)
			{
				isInitScale = true;
				initScaleX=obj3d.scaleX
				initScaleY=obj3d.scaleY
				initScaleZ=obj3d.scaleZ
			}
           TweenMax.to(obj3d, 0.3, { scaleX:initScaleX-0.1, scaleY:initScaleY-0.1, scaleZ:initScaleZ-0.1 } );
		}		
		private function onOut3D(e:MouseEvent3D):void 
		{
		    var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
            TweenMax.to(obj3d,0.3,{scaleX:initScaleX,scaleY:initScaleY,scaleZ:initScaleZ})
		}
		
		private function onUp3D(e:MouseEvent3D):void 
		{
			var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
           TweenMax.to(obj3d,0.3,{scaleX:initScaleX,scaleY:initScaleY,scaleZ:initScaleZ})
		}
		protected var initScaleX:Number = 1
		protected var initScaleY:Number = 1
		protected var initScaleZ:Number = 1
		
		protected var isInitScale:Boolean = false;
		private function onOver3D(e:MouseEvent3D):void 
		{
			var obj3d:ObjectContainer3D = ObjectContainer3D(e.currentTarget)
			if (!isInitScale)
			{
				isInitScale = true;
				initScaleX=obj3d.scaleX
				initScaleY=obj3d.scaleY
				initScaleZ=obj3d.scaleZ
			}
			TweenMax.to(obj3d, 0.3, { scaleX:initScaleX + 0.2, scaleY:initScaleY + 0.2, scaleZ:initScaleZ + 0.2} );
		}		
		private function Object3DDownHandler(e:MouseEvent3D):void 
		{
			if (_drag3DTool == null) return;
			var object3D:ObjectContainer3D=ObjectContainer3D(e.target);
			_drag3DTool.object3D = object3D;
		}				
		private function onObject3DClick(e:MouseEvent3D):void 
		{
			var object3D:ObjectContainer3D = ObjectContainer3D(e.target);
			var tempData:Object = object3D.extra;
			trace(tempData.eventName)
			if (tempData == null) return;
			var eventName:String = tempData.eventName;
			var _data:Object= this.dispatcherDictionary.getItemAtByField("eventName", eventName);
			if (_data == null) return;
			dispatcher.dispatchEvent(new Scene3DEvent(Scene3DEvent.CLICK3D, _data))
			this.dispatchEvent(new Scene3DEvent(Scene3DEvent.CLICK3D, _data))
			if(onObject3DHandler!=null)onObject3DHandler(_data)
		}
		public function addMeshURL(url:String):void
		{
			
		}
		public function addMesh(_mesh:Mesh,data:Object):void
		{
			var item:MD53DObject = new MD53DObject()
			item.mesh = _mesh
			initSpace(item,data)
			addChild(item)
			_md53Dobjects.push(item);
			if (_modelParsers)
			{
				_modelParsers.addEffect(_mesh, data);
			}
		}
		public function getNameItem(name:String):MD53DObject
		{
			var length:int = _md53Dobjects.length;
			for (var j:int = 0; j <length; j++) 
			{
				if (_md53Dobjects[j].name == name)
				{
					return _md53Dobjects[j];
					
				}else
				{				
					if (_md53Dobjects[j].getNameMesh(name)) return _md53Dobjects[j];
				}
			}
			var klength:int = _pendantMeshs.length;
			for (var i:int = 0; i <klength; i++) 
			{
				if (_pendantMeshs[i].name == name)
				{
					return _pendantMeshs[i];
					
				}else
				{			
					if (_pendantMeshs[i].getNameMesh(name)!=null) return _pendantMeshs[i];
				}
			}
			return null;
		}
		public function setNameItem(name:String, data:Object):MD53DObject
		{
			var temp3DObject:MD53DObject = getNameItem(name);
			var tempMesh:Mesh= null;
			if (data.type == "model")
			{
				var meshURL:String = data.value
				if (meshURL != "")
				{
					if (temp3DObject&&temp3DObject.extra.value!=meshURL)
					{
						if (data.isComplete && data.isComplete == "true")
						{
							var index:int = _md53Dobjects.indexOf(temp3DObject);
							if (index != -1)
							{
								_md53Dobjects.splice(index, 1);
							}
							temp3DObject.dispose();
							temp3DObject = null;	
							
							temp3DObject = new MD53DObject()
							temp3DObject.extra = data;
							temp3DObject.name = name;
							temp3DObject.load(meshURL)
							addChild(temp3DObject);
							_md53Dobjects.push(temp3DObject)
							
						}else
						{
							if (temp3DObject.name == name)
							{
								tempMesh=temp3DObject.mesh;
							}else
							{
								tempMesh = temp3DObject.getNameMesh(name);
							}
							if (tempMesh.extra != null)
							{
								if (tempMesh.extra.value!= meshURL)
								{
									replaceMesh(tempMesh, meshURL)
									tempMesh.extra = data;
								}
							}else
							{
								tempMesh.extra = data;
								replaceMesh(tempMesh,meshURL)
							}
							
							
						}
						
					}else if(temp3DObject==null)
					{
						var item3d:MD53DObject = new MD53DObject()
						item3d.extra = data;
						item3d.name = name;
						item3d.load(meshURL)
						addChild(item3d);
						_md53Dobjects.push(item3d)
						temp3DObject=item3d;
					}
				}
				
			}else
			{
				if (temp3DObject == null) return null;
				if (_modelParsers)
				{
					if (temp3DObject.name == name)
					{
						tempMesh = temp3DObject.mesh;
					}else
					{
						tempMesh = temp3DObject.getNameMesh(name);
					}
					if (data.type != null)
					{
					   _modelParsers.addEffect(tempMesh, data);
					}
				}
				
			}
			if (temp3DObject.name == name)
			{
				initSpace(temp3DObject,data)
			}else
			{
				tempMesh = temp3DObject.getNameMesh(name);
				initSpace(tempMesh,data)
			}
			return temp3DObject;
		}
		public function replaceMesh(_mesh:Mesh, url:String):void
		{
			var loader3d:Loader3D = new Loader3D()
			loader3d.addEventListener(AssetEvent.GEOMETRY_COMPLETE, onGeometryComplete)
			loader3d.addEventListener(LoaderEvent.LOAD_ERROR, onGeometryLoadError)
			loader3d.load(new URLRequest(url))
		    function onGeometryComplete(e:AssetEvent):void 
			{
				if (e.asset.assetType == AssetType.GEOMETRY)
				{
					_mesh.geometry = e.asset as Geometry;
				}
			}
			function onGeometryLoadError(e:LoaderEvent):void 
			{
				
			}
			
		}
		protected var isDispose:Boolean = false;
		override public function disposeAsset():void 
		{
			clearTimeout(timeID);
			isDispose = true;
			if (_modelParsers)_modelParsers.dispose();
			isStopLoad = true;
			if (md53D)
			{
				md53D.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onMD5ObjectComplete)
				md53D.removeEventListener(LoaderEvent.LOAD_ERROR, onMD5ObjectComplete)
			}
			
			while (numChildren > 0)
			{
				getChildAt(0).disposeAsset();
			}			
			if(actionDictionary)actionDictionary.removeAll();
		    if(meshDictionary)meshDictionary.removeAll();
		    if(materialDictionary)materialDictionary.removeAll();
		    if(pendantDictionary)pendantDictionary.removeAll();
		    if(dispatcherDictionary)dispatcherDictionary.removeAll();
		
			if(_autoActions)_autoActions.length = 0;
			if(_md53Dobjects)_md53Dobjects.length = 0;
			if(_pendantMeshs)_pendantMeshs.length = 0;
			
			actionDictionary = null;
			meshDictionary = null;
			materialDictionary = null;
			pendantDictionary = null;
			dispatcherDictionary = null;
			
			_autoActions = null;
			_md53Dobjects = null;
			_pendantMeshs = null;
			_drag3DTool = null;
			_modelParsers = null;
			super.disposeAsset();
		}
	}

}