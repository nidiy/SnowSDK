package snow.utils 
{
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author tim
	 */
	public class TriggerIsInteractsWith 
	{
		
		public function TriggerIsInteractsWith() 
		{
			
		}
		public static function Trigger(target:DisplayObject,callBack:Function):void
		{
			target.stage.addEventListener(TouchEvent.TOUCH, oTargetTouch)
			function oTargetTouch(e:TouchEvent):void 
			{
				var touch:Touch = e.getTouch(target.stage)
				if (touch == null) return;
				if (touch.phase == TouchPhase.BEGAN)
				{
					if (!e.interactsWith(target))
					{
						target.stage.removeEventListener(TouchEvent.TOUCH, oTargetTouch)
						if (callBack != null) callBack();
					}
				}
			}
		}
		
	}

}