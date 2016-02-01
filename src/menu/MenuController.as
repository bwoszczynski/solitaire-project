package menu 
{
	import base.BackButtonAction;
	import interfaces.IController;
	import manager.BackButtonManager;
	import manager.GlobalDispatcher;
	import starling.events.Event;
	import view.BaseSceneView;
	/**
	 * ...
	 * @author Bartosz Woszczynski
	 */
	public class MenuController implements IController
	{
		private var _sceneView:MenuView;
		public function MenuController() 
		{
			
		}
		
		public function init(data:Object = null):void 
		{
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MAIN_MENU_BACK_ACTION));
			
			_sceneView = new MenuView();
			_sceneView.addEventListener(MenuView.PLAY, onPlayHandler);			
		}
		
		private function onPlayHandler(e:Event):void 
		{
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.REMOVE_BACK_ACTION);
			GlobalDispatcher.instance.dispatchEventWith(GlobalDispatcher.INIT_MINIGAME);
		}
		
		public function clean():void 
		{
			_sceneView.removeEventListeners();
			_sceneView.removeFromParent(true);
		}
		
		public function get sceneView():BaseSceneView 
		{
			return _sceneView;
		}
	}

}