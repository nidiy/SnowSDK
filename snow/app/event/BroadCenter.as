package snow.app.event {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * 全局事件发送与接收器，不能实例化
	 * 相当于可在任何地方发送，可在任何地方接收,此事件为广播事件
	 */
	public class BroadCenter extends EventDispatcher{
		private static var _dispatcher:BroadCenter = null;
		private static var ifOpen:Boolean = false;
		public static function get dispatcher():BroadCenter {

			if (_dispatcher == null) {
				ifOpen = ! ifOpen;
				_dispatcher = new BroadCenter;
				ifOpen = ! ifOpen;
			}
			return BroadCenter._dispatcher;
		}
		public function BroadCenter() {

			if (! ifOpen) {
				throw new Error("无法实例化");
			}
		}
	}
}