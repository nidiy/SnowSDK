package snow.scene3D 
{
	import caurina.transitions.Tweener;
	import feathers.controls.Alert;
	import flash.geom.Point;
	import starling.events.Event
	import flash.events.EventDispatcher;
	import snow.app.model.DataProvider;
	import snow.app.view.mediator.MVCView3DMediator;
	import snow.app.event.BroadCenter
	import snow.app.event.BroadEvent;
	/**
	 * 3D热点控制管理
	 * @author ...
	 */
	public class I3DHotManager extends EventDispatcher 
	{
		
		private var _dataProvider:DataProvider
		protected var _view:MVCView3DMediator
		public function I3DHotManager(v:MVCView3DMediator=null) 
		{
			_view = v;
		}
		public function sendEvent(value:String,data:Object):void
		{
			BroadCenter.dispatcher.dispatchEvent(new BroadEvent(value,data))
		}
		public  function sendID(value:String):void
		{
			if (_dataProvider == null) return;			
			var temp:Object = _dataProvider.getItemAtByField("hotID", value)
			if (temp != null)
			{
			    sendEvent(temp.addEvent, temp)
			  
			}else
			{
				Alert.show("此热点没有交互信息")
			}
		}		
		
		private function onParameterClose(e:Event):void 
		{
			if(_view)_view.activation = true;
		}
		public function get dataProvider():DataProvider 
		{
			return _dataProvider;
		}		
		public function set dataProvider(value:DataProvider):void 
		{
			_dataProvider = value;
		}
		
	}
}