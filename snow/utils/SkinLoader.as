package snow.utils 
{
	import feathers.core.DefaultPopUpManager;
	import feathers.core.FeathersControl;
	import feathers.core.FocusManager;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.core.ToolTipManager;
	import feathers.text.FontStylesSet;
	import snowui.engine.UIBuilder;
	import snowui.engine.style.StyleBuilder;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.text.TextFormat;
	import starling.utils.Align;
	import snow.app.model.DataControl;

	/**
	 * 实例  
	 * var skinloader:SkinLoader=new SkinLoader()
	 * skinloader.loadConfig("skin.xml") //皮肤XML路径
	 * skinLoader.onDataComplete =onSkinComplete;//皮肤加载完成后回调
	 * 皮肤加载器
	 * @author Tim
	 */
	public class SkinLoader extends DataControl 
	{
		
		public function SkinLoader() 
		{
			super()
		}
		override protected function onDataProgress(value:Number):void 
		{
			if (value >= 1)
			{
				initObject()
			}
		}
		protected var uiBuilder:UIBuilder
		protected var styleBuilder:StyleBuilder
		protected var defaultTextRenderer:String = "StageTextTextEditor";
		protected var defaultTextEditor:String = "TextFieldTextEditor";
		private var popUpOverlayColor:uint = 0x000000;
		private var popUpOverlayalpha:Number = 0.5;
		private var popUpOverlayTime:Number = 0.5;
		private var defaultFont:String = "微软雅黑";
		private var defaultFontSize:int =10;
		private var defaultFontColor:uint = 0x262626;
		private var defaultFontHorizontalAlign:String = Align.LEFT;
		private var defaultFontVerticalAlign:String = Align.CENTER;
		private var xmllist:XMLList;
		private function initObject():void 
		{
			
			var GlobalsXML:XML = _assetManager.getXml("GlobalsSetting");
			if (GlobalsXML!=null)
			{
				defaultTextRenderer = GlobalsXML.defaultTextRenderer.toString();
				defaultTextEditor = GlobalsXML.defaultTextEditor.toString();
				
				defaultFont = GlobalsXML.defaultFont.toString();				
				defaultFontSize = int(GlobalsXML.defaultFontSize);				
				defaultFontColor = uint(GlobalsXML.defaultFontColor);				
				FeathersControl.defaultTextRendererFactory = textRendererFactory;
				FeathersControl.defaultTextEditorFactory = textEditorFactory;
			}	
			var color:String = GlobalsXML.popUpOverlayColor
			if (color != "") popUpOverlayColor = uint(color)
			
			//var alpha:String = GlobalsXML.popUpOverlayalpha
			//if (alpha != "") popUpOverlayalpha = Number(alpha)
			
			var time:String = GlobalsXML.popUpOverlayTime
			if (time != "") popUpOverlayTime = Number(time)
			
			//web端使用
			FocusManager.setEnabledForStage(Starling.current.stage, true);
			ToolTipManager.setEnabledForStage(Starling.current.stage, true);
			
			PopUpManager.overlayFactory = popUpOverlayFactory;
			
			if (!uiBuilder)
			{
				uiBuilder = UIBuilder.openInstance();
			}
			uiBuilder.assetManager = _assetManager;
			var styleList:XML = _assetManager.getXml("StyleList");
			xmllist = styleList.children();
			loadData(xmllist);
			_assetManager.loadQueue(onStyleListProgress)			
			styleBuilder = new StyleBuilder(uiBuilder);
			
		}		
		private function onStyleListProgress(value:Number):void 
		{
			if (value >= 1)
			{
				initSkin();
			}
		}
		private function initSkin():void
		{
			var length:int = xmllist.length();
			var styleXML:XML = null;
			for (var i:int = 0; i <length; i++) 
			{
				var assetName:String = "" + xmllist[i].@name;
				styleXML = _assetManager.getXml(assetName);
				styleBuilder.createStyle(styleXML);
			}			
			if (onDataComplete != null)
			{
				onDataComplete();
			}
		}
		private function textEditorFactory():ITextEditor
		{
			var TextEditorClass:Class = UIBuilder.controlTabel[defaultTextEditor];
			
			var textEditor:ITextEditor = new TextEditorClass();
			textEditor.fontStyles = new FontStylesSet();
			textEditor.fontStyles.format=new TextFormat(defaultFont,defaultFontSize,defaultFontColor,defaultFontHorizontalAlign,defaultFontVerticalAlign)
			return textEditor;
		}		
		private function textRendererFactory():ITextRenderer
		{
			var TextRendererClass:Class = UIBuilder.controlTabel[defaultTextRenderer];
			var textRenderer:ITextRenderer = new TextRendererClass();
			textRenderer.fontStyles = new FontStylesSet();
			textRenderer.fontStyles.format=new TextFormat(defaultFont,defaultFontSize,defaultFontColor,defaultFontHorizontalAlign,defaultFontVerticalAlign)
			return textRenderer;
		}
		protected  function popUpOverlayFactory():DisplayObject
		{
			trace("><<><><><><><>>>>>>>>>>>>>>>>>>")
			var quad:Quad = new Quad(16, 16, popUpOverlayColor);
			quad.alpha =0;
			var hideTween:Tween = new Tween(quad,popUpOverlayTime, Transitions.EASE_OUT);
			hideTween.animate("alpha",popUpOverlayalpha);
			Starling.juggler.add(hideTween);
			return quad;
		}
		
		
	}

}