package snow.parser 
{
	import adobe.utils.CustomActions;
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import snow.app.model.DataProvider;
	
	/**
	 * 场景灯光解析器1.0
	 * 2013/8/21 11:49
	 * @author 
	 */
	public class LightsData extends ObjectContainer3D 
	{
		protected var _dataProvider:DataProvider
		protected var lightDataProvider:DataProvider
		protected var _xmlConfig:XML
		protected var lightBases:Vector.<LightBase>=new Vector.<LightBase>
		public function LightsData() 
		{
			super()
			_dataProvider = new DataProvider()
			lightDataProvider = new DataProvider();
		}	
		override public function disposeAsset():void 
		{
			super.disposeAsset();
			for (var i:int = 0; i <lightBases.length; i++) 
			{
				lightBases[i].disposeAsset();
			}
			lightBases.length = 0;
			lightBases = null;
			_dataProvider.removeAll()
			_dataProvider = null;
			_xmlConfig = null;
		}
		public function get dataProvider():DataProvider 
		{
			return _dataProvider;
		}		
		public function set dataProvider(value:DataProvider):void 
		{
			_dataProvider = value;
		}
		public function getNameLight(_name:String):LightBase
		{
			var l:int=lightBases.length
			for (var i:int = 0; i <l; i++) 
			{
				if (lightBases[i].id == _name)
				{
					return lightBases[i];
				}
			}
			return null;
		}
		public function get xmlConfig():XML 
		{
			return _xmlConfig;
		}		
		public function set xmlConfig(value:XML):void 
		{
			_xmlConfig = value;
			var lightXMLList:XMLList = XMLList(_xmlConfig.child("lights").children());
			var length:int = lightXMLList.length();
			for (var i:int = 0; i <length; i++) 
			{
				var lightObject:Object = new Object();
				lightObject.id = lightXMLList[i].id;
				if (lightXMLList[i].type == "pointlight")
				{
					var pointLight:PointLight = new PointLight();
					pointLight.id=""+lightXMLList[i].id
					pointLight.x =Number(lightXMLList[i].x);
					pointLight.y =Number(lightXMLList[i].y);
					pointLight.z =Number(lightXMLList[i].z);
					
					pointLight.color = RGBroColor(lightXMLList[i].color);
					pointLight.ambientColor = RGBroColor(lightXMLList[i].ambientColor);
					
					pointLight.diffuse = Number(lightXMLList[i].diffuse);
					pointLight.specular =Number(lightXMLList[i].specular);
					pointLight.ambient =Number(lightXMLList[i].ambient);
					
					
					pointLight.radius =Number(lightXMLList[i].radius);
					pointLight.fallOff = Number(lightXMLList[i].fallOff);
					lightBases.push(pointLight)
					addChild(pointLight)
					
					lightObject.light = pointLight;
					
					
				}else if (lightXMLList[i].type == "directionallight")
				{
					var directionallight:DirectionalLight = new DirectionalLight();
					directionallight.id=""+lightXMLList[i].id
					lightBases.push(directionallight)
					directionallight.x = Number(lightXMLList[i].x);
					directionallight.y = Number(lightXMLList[i].y);
					directionallight.z = Number(lightXMLList[i].z);
					
					directionallight.color = RGBroColor(lightXMLList[i].color);
					directionallight.ambientColor = RGBroColor(lightXMLList[i].ambientColor);
					
					directionallight.diffuse = Number(lightXMLList[i].diffuse);
					directionallight.specular = Number(lightXMLList[i].specular);
					directionallight.ambient = Number(lightXMLList[i].ambient);
					
					
					directionallight.direction = Position(lightXMLList[i].direction);
					addChild(directionallight)
					
					lightObject.light = directionallight;
				}
				lightDataProvider.addItem(lightObject);
			}
			var lightPickersXMLlist:XMLList = XMLList(_xmlConfig.lightPickers.StaticLightPicker.children());
			length = lightPickersXMLlist.length();
			for (var j:int = 0; j <length; j+=2) 
			{
				var pickerOjbect:Object = new Object();
				pickerOjbect.id = lightPickersXMLlist[j];
				var _names:String = lightPickersXMLlist[j + 1];
				var namesArr:Array = new Array;
			    namesArr = _names.split(",", _names.length);
				
				var arraLight:Array = new Array;
				for (var k:int = 0; k <namesArr.length; k++) 
				{
					arraLight.push(lightDataProvider.getItemAtByField("id",namesArr[k]).light)
				}				
				var staticLightPicker:StaticLightPicker = new StaticLightPicker(arraLight)
				pickerOjbect.lightPicker = staticLightPicker;
				_dataProvider.addItem(pickerOjbect);
			}
			this.dispatchEvent(new Event(Event.COMPLETE))
			
		}
		public static function RGBroColor(value:String):uint
		{
			var valueArr:Array = new Array();
			valueArr = value.split(",", value.length);
			var color:String = "0x" + uint(valueArr[0]).toString(16) + uint(valueArr[1]).toString(16) + uint(valueArr[2]).toString(16);
			return uint(color)
		}
		public static function Position(value:String):Vector3D
		{
			var valueArr:Array = new Array  ;
			valueArr = value.split(",", value.length);
			var pos:Vector3D = new Vector3D(Number(valueArr[0]), Number(valueArr[1]), Number(valueArr[2]));
			return pos;
		}
		public static function onBoolean(value:String):Boolean
		{
			return (value == "true"?true:false);
		}
		
	}

}