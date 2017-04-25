package snow.mvc.patterns.command 
{

	import snow.mvc.interfaces.*;
	import snow.mvc.interfaces.ICommand;
	import snow.mvc.interfaces.INotification;
	import snow.mvc.interfaces.INotifier;
	import snow.mvc.patterns.observer.Notifier;
	
	public class SimpleCommand extends Notifier implements ICommand, INotifier 
	{
		
		public function execute( notification:INotification ) : void
		{
			
		}
								
	}
}