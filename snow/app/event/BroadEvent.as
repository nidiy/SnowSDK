package snow.app.event 
{
	import flash.events.Event;
	
	//主要跟全局事件发送器配合,使用data可做为发送数据使用
	
	public class BroadEvent extends Event 
	{
		/**
		 * 打开应用
		 */
		public static const APP_OPEN:String = "appOpen";
		public static const APP_OPEN_COMPLETE:String = "appOpenComplete";
		
		public static const APP_ADD_MANAGE:String = "appAddManage"
		
		public static const APP_UPDATA:String="appUpdata"		
		/**
		 * 关闭应用
		 */
		public static const APP_CLOSE:String = "appClose";
		public static const APP_CLOSE_COMPLETE:String = "appCloseComplete";
		
		public static const LOCK_DEFAULT_APP:String="LockDefaultApp"
		public static const UNLOCK_DEFAULT_APP:String="unLockDefaultApp"
		
		/**
		 * 所有应用被关闭
		 */
		public static const APP_ALL_CLOSE:String="appAllClose"
		
		//系统返回
		public static const SYSTEM_BACK:String = "systemBack";
		
		//返回主界面
		public static const HOME:String = "home";
		
		//切换3D场景
		public static const FOR_SCENE3D:String = "forScene3D";
		
		//增加&&删除目标位置-主要用于智能返回功能
		public static const ADD_TARGET:String = "addTarget";
		public static const REMOVE_TARGET:String = "removeTarget";
		
		//打开与关闭全局播放器
		public static const OWNER_PLAYER_OPEN:String = "ownerPlayerOpen";		
		public static const OWNER_PLAYER_CLOSE:String = "ownerPlayerClose";
		
		
		//用于收藏库
		public static const ADD_KEEP_DATA:String = "addKeepData";
		public static const REPEAT_KEEP_DATA:String = "repeatKeepData";
		public static const REMOVE_KEEP_DATA:String = "removeKeepData";
		
		//用于存储目标对像
		public static const ADD_TOP_TARGET:String = "addTopTarget";
		public static const REMOVE_TOP_TARGET:String = "removeTopTarget";
		
		
		public static const HID_SYSTEM_GUI:String = "hidSystemGui";
		public static const SHOW_SYSTEM_GUI:String = "showSystemGui";
		
		
		public static const ROBOT_TALK:String = "RobotTalk";
		public static const ROBOT_TALK_COMPLETE:String = "RobotTalkComplete";
		public static const ROBOT_START_TALK:String = "RobotStartTalk";
		public static const LOGIN_SUCCESSFUL:String="LOGIN_SUCCESSFUL"
		
		protected var _data:Object;
		
		public function BroadEvent(eventType:String,eventData:Object=null) 
		{
			super(eventType);
			_data = eventData;
		}
		public function get data():Object
		{
			return _data;
		}
		
	}

}