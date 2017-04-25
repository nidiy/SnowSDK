package snow.app.view.mediator
{
	import starling.core.Starling;
	import snow.app.core.IActiveMediator;

	public interface IStarlingMediator extends IActiveMediator
	{
		function getStarling():Starling;
	}
}