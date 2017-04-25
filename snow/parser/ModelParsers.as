package snow.parser
{
	import away3d.containers.View3D;
	import away3d.debug.data.TridentLines;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FresnelEnvMapMethod;
	import away3d.materials.methods.LightMapMethod;
	import away3d.materials.methods.PlanarReflectionMethod;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.textures.CubeReflectionTexture;
	import away3d.textures.MovieAssetTexture;
	import away3d.textures.PlanarReflectionTexture;
	import away3d.textures.VideoTexture;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import ghostcat.text.FilePath;
	import snow.parser.EnvMapmanage
	import snow.parser.LightsData;
	import starling.utils.Color;
	import snow.utils.Effect;
	import snow.utils.Handle;
	import flash.utils.setInterval
	
	/**
	 * ...
	 * @author WebCity
	 */
	public class ModelParsers
	{
		protected var _lightsData:LightsData
		protected var _envMapmanage:EnvMapmanage
		protected var _view:View3D
		protected var extList:String = "MP4,mp4,flv,FLV,MOV,mov,F4V,f4v"
		protected var realList:Vector.<PlanarReflectionTexture> = new Vector.<PlanarReflectionTexture>
		protected var videoTextures:Vector.<VideoTexture> = new Vector.<VideoTexture>
		protected var materials:Vector.<TextureMaterial> = new Vector.<TextureMaterial>;
		protected var mesh:Mesh
		protected var reflectionTexture:CubeReflectionTexture
		protected var fresnelMethod:FresnelEnvMapMethod
		
		public function ModelParsers(v:View3D = null)
		{
			_view = v;
			//initRealTime()
		}
		
		protected function initRealTime():void
		{
			// create reflection texture with a dimension of 256x256x256
			reflectionTexture = new CubeReflectionTexture(1024);
			reflectionTexture.farPlaneDistance = 3000;
			reflectionTexture.nearPlaneDistance = 1;
			// center the reflection at (0, 100, 0) where our reflective object will be
			reflectionTexture.position = new Vector3D(0, 100, 0);
			fresnelMethod = new FresnelEnvMapMethod(reflectionTexture, 0.5);
			fresnelMethod.normalReflectance = 1;
			fresnelMethod.fresnelPower = 2;
		}
		
		public function addEffect(_mesh:Mesh, _data:Object):void
		{
			if (_data == null) return;
			if (_mesh == null) return;
			this.mesh = _mesh;
			if (_data.type == "texture")
			{
				if (_mesh.material == null) _mesh.material = new TextureMaterial();
				if (!(_mesh.material is TextureMaterial))
				{
					_mesh.material = new TextureMaterial();
				}
				if (_data.value is String)
				{
					var url:String = String(_data.value);
					if (url && url != "")
					{
						var filePath:FilePath = new FilePath(url)
						if (extList.indexOf(filePath.extension) >= 0)
						{
							var videoTexture:VideoTexture
							videoTexture = new VideoTexture(url, _data.width, _data.height)
							videoTexture.autoPlay = true;
							TextureMaterial(_mesh.material).texture = videoTexture
							videoTexture.player.play();
							videoTexture.player.volume = _data.volume;
							videoTextures.push(videoTexture)
						}
						else
						{
							if (_mesh.material.extra && _mesh.material.extra.isload == true)
							{
								new MaterialLoader(TextureMaterial(_mesh.material), url)
							}
							else
							{
								_mesh.material = new TextureMaterial(new MovieAssetTexture(url))
								_mesh.material.extra = new Object();
								_mesh.material.extra.isload = true;
							}
							getTexture(TextureMaterial(_mesh.material), _data)
							return;
							
						}
					}
				}
				else if (_data.value is BitmapData)
				{
					var bitmapData:BitmapData = BitmapData(_data.value);
					bitmapData = Handle.bitmapDataOfTwo(bitmapData);
					TextureMaterial(_mesh.material).texture = new BitmapTexture(bitmapData);
					getTexture(TextureMaterial(_mesh.material), _data)
					return;
				}
				getTexture(TextureMaterial(_mesh.material), _data)
				return;
				
			}
			else if (_data.type == "color")
			{
				var color:uint = uint(_data.value);
				var alpha:Number = Number(_data.alpha);
				if (_mesh.material is ColorMaterial)
				{
					Effect.colorEffect(ColorMaterial(_mesh.material), color)
				}
				else
				{
					_mesh.material = new ColorMaterial(color, alpha);
				}
				getColor(_mesh.material as ColorMaterial, _data)
				return;
				
			}
			else
			{
				if (_mesh.material is ColorMaterial)
				{
					getColor(_mesh.material as ColorMaterial, _data)
					
				}
				else
				{
					getTexture(_mesh.material as TextureMaterial, _data)
				}
			}
		
		}
		
		protected function getTexture(texture:TextureMaterial, data:Object):void
		{
			if (data.lightPicker)
			{
				var lightID:String = data.lightPicker;
				if (_lightsData != null)
				{
					var lightObj:Object = _lightsData.dataProvider.getItemAtByField("id", lightID)
					if (lightObj && lightObj.lightPicker)
					{
						texture.lightPicker = lightObj.lightPicker;
					}
				}
			}
			//处理法线贴图及阴影贴图				
			if (data.normalMap != null && data.normalMap != "")
			{
				if (texture.normalMap)
				{
					texture.normalMap.dispose();
					texture.normalMap = null;
				}
				new TextureLoader(texture, data.normalMap, "normalMap")
			}
			//影阴贴图
			if (data.specularMap != null && data.specularMap != "")
			{
				if (texture.specularMap)
				{
					texture.specularMap.dispose();
					texture.specularMap = null;
				}
				new TextureLoader(texture, data.specularMap, "specularMap")
			}
			if (data.alphaBlending && data.alphaBlending != "") texture.alphaBlending = (data.alphaBlending == "true" ? true : false);
			if (data.bothSides && data.bothSides != "") texture.bothSides = (data.bothSides == "true" ? true : false);
			if (data.mipmap && data.mipmap != "") texture.mipmap = (data.mipmap == "false" ? false : true);
			if (data.repeat && data.repeat != "") texture.repeat = (data.repeat == "false" ? false : true);
			
			if (data.alpha)
			{
				texture.alpha = Number(data.alpha)
			}
			else
			{
				texture.alpha = 1;
			}
			if (data.blendMode)
			{
				texture.blendMode = data.blendMode
			}
			else
			{
				texture.blendMode = BlendMode.NORMAL
			}
			if (data.gloss) texture.gloss = Number(data.gloss);
			if (data.ambient) texture.ambient = Number(data.ambient);
			if (data.specular) texture.specular = Number(data.specular);
			
			if (data.ambientColor) texture.ambientColor = uint(data.ambientColor);
			if (data.specularColor) texture.specularColor = uint(data.specularColor);
			
			var envAlpha:Number = data.envAlpha;
			var envID:String = data.envID;
			if (envID != null && envID != "real" && _envMapmanage)
			{
				var envMap:EnvMapMethod = _envMapmanage.getEnvMapMethod(envID, envAlpha);
				if (envMap)
				{
					var tempEnvMap:EnvMapMethod = texture.getMethodAt(0) as EnvMapMethod
					if (tempEnvMap)
					{
						texture.removeMethod(tempEnvMap)
						tempEnvMap = null;
					}
					texture.addMethodAt(envMap, 0)
				}
				
			}
			else if (envID == "real")
			{
				var reflectionTexture:PlanarReflectionTexture = new PlanarReflectionTexture()
				var reflectionMethod:PlanarReflectionMethod = new PlanarReflectionMethod(reflectionTexture, envAlpha);
				realList.push(reflectionTexture)
				TextureMaterial(texture).addMethod(reflectionMethod)
				var _mesh:Mesh = new Mesh(mesh.geometry, TextureMaterial(texture));
				if (data.ry) _mesh.y = data.ry;
				if (data.rz) _mesh.z = data.rz;
				if (data.rx) _mesh.x = data.rx;
				if (data.rrX) _mesh.rotationX = data.rrX;
				if (data.rrY) _mesh.rotationY = data.rrY;
				if (data.rrZ) _mesh.rotationZ = data.rrZ;
				reflectionTexture.applyTransform(_mesh.sceneTransform)
			}
			var aoID:String = data.aoID;
			var useSecondaryUV:Boolean = data.useSecondaryUV = "false" ? false : true;
			var aoblendMode:String = data.aoblendMode;
			var lightMap:LightMapMethod;
			
			if (aoID != null && aoID != "" && _envMapmanage)
			{
				for (var i:int = 0; i < texture.numMethods; i++)
				{
					if (texture.getMethodAt(i) is LightMapMethod)
					{
						texture.removeMethod(texture.getMethodAt(i))
						break;
					}
				}
				lightMap = _envMapmanage.getlightMapMethod(aoID);
				if (lightMap) texture.addMethod(lightMap);
				
			}
			else if (aoID == "null")
			{
				for (i = 0; i < texture.numMethods; i++)
				{
					if (texture.getMethodAt(i) is LightMapMethod)
					{
						texture.removeMethod(texture.getMethodAt(i))
						break;
					}
				}
			}
		}
		
		protected function getColor(texture:ColorMaterial, data:Object):void
		{
			if (data.lightPicker)
			{
				var lightID:String = data.lightPicker;
				if (_lightsData != null)
				{
					var lightObj:Object = _lightsData.dataProvider.getItemAtByField("id", lightID)
					if (lightObj && lightObj.lightPicker)
					{
						texture.lightPicker = lightObj.lightPicker;
					}
				}
			}
			
			//处理法线贴图及阴影贴图				
			if (data.normalMap != null && data.normalMap != "")
			{
				if (texture.normalMap)
				{
					texture.normalMap.dispose();
					texture.normalMap = null;
				}
				new TextureLoader(texture, data.normalMap, "normalMap")
					//texture.normalMap = new MovieAssetTexture(data.normalMap);
			}
			
			//影阴贴图
			if (data.specularMap != null && data.specularMap != "")
			{
				if (texture.specularMap)
				{
					texture.specularMap.dispose()
					texture.specularMap = null;
				}
				new TextureLoader(texture, data.specularMap, "specularMap")
					//texture.specularMap = new MovieAssetTexture(data.specularMap);
			}			
			texture.alphaBlending = (data.alphaBlending == "true" ? true : false);
			texture.bothSides = (data.bothSides == "true" ? true : false);
			texture.mipmap = (data.mipmap == "false" ? false : true);
			texture.repeat = (data.repeat == "false" ? false : true);			
			if (data.alpha)
			{
				texture.alpha = Number(data.alpha)
			}
			else
			{
				texture.alpha = 1;
			}
			if (data.blendMode)
			{
				texture.blendMode = data.blendMode
			}
			else
			{
				texture.blendMode = BlendMode.NORMAL
			}
			
			if (data.gloss) texture.gloss = Number(data.gloss);
			if (data.ambient) texture.ambient = Number(data.ambient);
			if (data.specular) texture.specular = Number(data.specular);
			
			if (data.ambientColor) texture.ambientColor = uint(data.ambientColor);
			if (data.specularColor) texture.specularColor = uint(data.specularColor);
			
			var envAlpha:Number = data.envAlpha;
			var envID:String = data.envID;
			if (envID != null && envID != "real" && _envMapmanage)
			{
				var envMap:EnvMapMethod = _envMapmanage.getEnvMapMethod(envID, envAlpha);
				if (envMap)
				{
					if (texture.getMethodAt(0) && texture.getMethodAt(0) is EnvMapMethod)
					{
						texture.removeMethod(texture.getMethodAt(0))
					}
					texture.addMethodAt(envMap, 0)
				}
				
			}
			else if (envID == "real")
			{
				var reflectionTexture:PlanarReflectionTexture = new PlanarReflectionTexture()
				var reflectionMethod:PlanarReflectionMethod = new PlanarReflectionMethod(reflectionTexture, envAlpha);
				realList.push(reflectionTexture)
				ColorMaterial(texture).addMethodAt(reflectionMethod, 0)
				var _mesh:Mesh = new Mesh(mesh.geometry, ColorMaterial(texture));
				if (data.ry) _mesh.y = data.ry;
				if (data.rz) _mesh.z = data.rz;
				if (data.rx) _mesh.x = data.rx;
				if (data.rrX) _mesh.rotationX = data.rrX;
				if (data.rrY) _mesh.rotationY = data.rrY;
				if (data.rrZ) _mesh.rotationZ = data.rrZ;
				reflectionTexture.applyTransform(_mesh.sceneTransform)
			}
			var aoID:String = data.aoID;
			var useSecondaryUV:Boolean = data.useSecondaryUV = "false" ? false : true;
			var aoblendMode:String = data.aoblendMode;
			var lightMap:LightMapMethod
			if (aoID != null && aoID != "" && _envMapmanage)
			{
				for (var i:int = 0; i < texture.numMethods; i++)
				{
					if (texture.getMethodAt(i) is LightMapMethod)
					{
						texture.removeMethod(texture.getMethodAt(i))
						break;
					}
				}
				lightMap = _envMapmanage.getlightMapMethod(aoID);
				if (lightMap) texture.addMethod(lightMap);
			}
			else if (aoID == "null")
			{
				for (i = 0; i < texture.numMethods; i++)
				{
					if (texture.getMethodAt(i) is LightMapMethod)
					{
						texture.removeMethod(texture.getMethodAt(i))
						break;
					}
				}
			}
		}
		
		public function get lightsData():LightsData
		{
			return _lightsData;
		}
		
		public function set lightsData(value:LightsData):void
		{
			_lightsData = value;
		}
		
		public function get envMapmanage():EnvMapmanage
		{
			return _envMapmanage;
		}
		
		public function set envMapmanage(value:EnvMapmanage):void
		{
			_envMapmanage = value;
		}
		
		public function get view():View3D
		{
			return _view;
		}
		
		public function set view(value:View3D):void
		{
			_view = value;
		}
		
		public function updata():void
		{
			for (var i:int = 0; i < realList.length; i++)
			{
				realList[i].render(_view)
			}
		
		}
		
		public function dispose():void
		{
			for (var i:int = 0; i < materials.length; i++)
			{
				if (materials[i])
				{
					if (materials[i].texture)
					{
						materials[i].texture.dispose();
						materials[i].texture = null;
					}
					if (materials[i].specularMap)
					{
						materials[i].specularMap.dispose();
					}
					if (materials[i].normalMap)
					{
						materials[i].normalMap.dispose();
					}
					materials[i].dispose();
					materials[i] = null;
				}
			}
			for (var j:int = 0; j < realList.length; j++)
			{
				if (realList[j])
				{
					realList[j].dispose();
					realList[j] = null;
				}
			}
			realList.length = 0;
			realList = null;
			materials.length = 0;
			materials = null;
			videoTextures.length = 0;
			videoTextures = null;
			_envMapmanage = null;
			_lightsData = null;
			_view = null;
		}
	}

}
import away3d.materials.MaterialBase;
import away3d.materials.TextureMaterial;
import away3d.textures.BitmapTexture;
import away3d.textures.Texture2DBase;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;

internal class MaterialLoader
{
	protected var loader:Loader
	protected var material:TextureMaterial
	
	public function MaterialLoader(material:TextureMaterial, url:String)
	{
		this.material = material
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete)
		loader.load(new URLRequest(url))
	}
	
	private function onImageComplete(e:Event):void
	{
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageComplete)
		var bitmapData:BitmapData = Bitmap(loader.content).bitmapData;
		if (material)
		{
			if (material.texture == null)
			{
				material.texture = new BitmapTexture(bitmapData)
			}
			else
			{
				BitmapTexture(material.texture).bitmapData = bitmapData;
			}
		}
		bitmapData = null;
		this.material = null;
		loader.removeChildren();
		loader.unload();
		loader = null;
	}
}

internal class TextureLoader
{
	protected var loader:Loader
	protected var material:MaterialBase
	protected var type:String = "normalMap"
	
	public function TextureLoader(material:MaterialBase, url:String, type:String = "normalMap")
	{
		this.material = material;
		this.type = type;
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete)
		loader.load(new URLRequest(url))
	}
	
	private function onImageComplete(e:Event):void
	{
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageComplete)
		var bitmapData:BitmapData = Bitmap(loader.content).bitmapData;
		if (type == "normalMap")
		{
			material["normalMap"] = new BitmapTexture(bitmapData)
		}
		else
		{
			material["specularMap"] = new BitmapTexture(bitmapData)
		}
		bitmapData = null;
		this.material = null;
		loader.removeChildren();
		loader.unload();
		loader = null;
	}
}