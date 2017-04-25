package snow.app.controller
{
	import feathers.utils.ScreenDensityScaleFactorManager;

	public class AppStarlingControl extends StarlingControl
	{
		public var scalefactor:ScreenDensityScaleFactorManager;		
		public function AppStarlingControl()
		{
			super();
		}
		
		override protected function initMilieu():void 
		{
			super.initMilieu();			
			scalefactor = new ScreenDensityScaleFactorManager(_starling);
		}
		override public function refreshScale():void 
		{
			super.refreshScale();
			scalefactor.reset(_starling);
		}
		
	}
}