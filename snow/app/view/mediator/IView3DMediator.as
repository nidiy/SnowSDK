package snow.app.view.mediator
{
	import away3d.containers.View3D;
	import snow.app.core.IActiveMediator;

	public interface IView3DMediator extends IActiveMediator
	{
		function getView3D():View3D;
	}
}