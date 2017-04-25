package snow.app.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author HBinNet
	 */
	public class VideoEvent extends Event 
	{
		public static const COMPLETE:String = "complete";
		public static const START:String = "start";
		public static const STOP:String = "Stop";
		public static const PAUSE:String = "pause";
		public static const STREAM_NOT_FOUND:String = "streamNotFound";
		public static const BUFFER_EMPTY:String = "bufferEmpty";
		public static const BUFFER_FULL:String = "bufferFull";
		public static const SEEK_COMPLETE:String = "seekComplete";
		public static const CLOSE:String = "close";
		
		public function VideoEvent(type:String) 
		{
			super(type)
		}
		
	}

}