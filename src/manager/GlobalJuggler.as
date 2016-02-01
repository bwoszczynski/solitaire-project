package manager 
{
	import starling.animation.Juggler;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class GlobalJuggler 
	{
		private static var _instance:GlobalJuggler;
		
		private var _menuJuggler:Juggler;
		private var _minigameJuggler:Juggler;
		
		public function GlobalJuggler() 
		{
			
		}
		
		public function init():void
		{
			_menuJuggler = new Juggler();
			_minigameJuggler = new Juggler();
		}
		
		static public function get instance():GlobalJuggler 
		{
			if (!_instance)
				_instance = new GlobalJuggler();
				
			return _instance;
		}
		
		public function get menuJuggler():Juggler 
		{
			return _menuJuggler;
		}
		
		public function get minigameJuggler():Juggler 
		{
			return _minigameJuggler;
		}
		
	}

}