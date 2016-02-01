package manager 
{
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class GlobalDispatcher extends EventDispatcher
	{
		static public const INIT_MINIGAME:String = "initMinigame";
		static public const INIT_MENU:String = "initMenu";
		private static var _instance:GlobalDispatcher;
		
		public function GlobalDispatcher() 
		{
			
		}
		
		public function init():void 
		{
			
		}
		
		static public function get instance():GlobalDispatcher 
		{
			if (!_instance)
				_instance = new GlobalDispatcher();
				
			return _instance;
		}
		
	}

}