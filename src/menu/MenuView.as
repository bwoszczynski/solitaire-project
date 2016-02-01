package menu 
{
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.core.PopUpManager;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.SteelSolitaireTheme;
	import manager.GlobalAssetManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import view.BaseSceneView;
	import view.GlobalView;
	import view.SettingsPopup;
	import view.StatisticsPopup;
	/**
	 * ...
	 * @author Bartosz Woszczynski
	 */
	public class MenuView extends BaseSceneView
	{
		static public const PLAY:String = "play";
		private var _mainContainer:LayoutGroup;
		private var _playButton:Button;
		private var _statisticsButton:Button;
		private var _moreGamesButton:Button;
		
		public function MenuView() 
		{
			_mainContainer = new LayoutGroup();
			
			var layout:AnchorLayout = new AnchorLayout();
			_mainContainer.layout = layout;
			_mainContainer.width = GlobalView.WIDTH;
			_mainContainer.height = GlobalView.HEIGHT;
			addChild(_mainContainer);
			
			var container:LayoutGroup = new LayoutGroup();
			var layoutData:AnchorLayoutData = new AnchorLayoutData();
			var img:Image =  new Image(GlobalAssetManager.instance.assetManager.getTexture("mainMenuGameLogo"));
				container.addChild(img);
				layoutData.top = 25;
				layoutData.horizontalCenter = 0;
				container.layoutData = layoutData;				
			_mainContainer.addChild(container);
			
			var centerList:LayoutGroup = new LayoutGroup();
			var listLayout:HorizontalLayout = new HorizontalLayout();
				listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
				listLayout.gap = 15;
				centerList.layout = listLayout;
				
				layoutData = new AnchorLayoutData();
				layoutData.horizontalCenter = 0;
				layoutData.verticalCenter = 30;
				centerList.layoutData = layoutData;
				_mainContainer.addChild(centerList);
				
				img = new Image(GlobalAssetManager.instance.assetManager.getTexture("mainMenuPicture"));
				centerList.addChild(img);
				
			var buttonList:LayoutGroup = new LayoutGroup();
			var buttonListLayout:VerticalLayout = new VerticalLayout();
				buttonListLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				buttonListLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
				buttonListLayout.firstGap = 25;
				buttonListLayout.gap = 5;
				buttonList.layout = buttonListLayout;
				
				_playButton = new Button();	
				_playButton.styleName = SteelSolitaireTheme.MENU_PLAY_BUTTON;
				_playButton.label = "PLAY!";
				_playButton.addEventListener(Event.TRIGGERED, onPlayHandler);
				buttonList.addChild(_playButton);
				
				_statisticsButton = new Button();	
				_statisticsButton.styleName = SteelSolitaireTheme.MENU_SIMPLE_BUTTON;
				_statisticsButton.label = "STATISTICS";
				_statisticsButton.addEventListener(Event.TRIGGERED, onStatisticsHandler);
				buttonList.addChild(_statisticsButton);
				
				_moreGamesButton = new Button();	
				_moreGamesButton.styleName = SteelSolitaireTheme.MENU_SIMPLE_BUTTON;
				_moreGamesButton.label = "SETTINGS";
				_moreGamesButton.addEventListener(Event.TRIGGERED, onSettingsHandler);
				buttonList.addChild(_moreGamesButton);
				
				centerList.addChild(buttonList);
				
				container = new LayoutGroup();
				container.layoutData = new AnchorLayoutData(20, NaN, NaN, 20);
				img = new Image(GlobalAssetManager.instance.assetManager.getTexture("steelFeatherLogo"));
				container.addChild(img);
				_mainContainer.addChild(container);
		}
		
		private function onSettingsHandler(e:Event):void 
		{
			PopUpManager.addPopUp(new SettingsPopup());
			
		}
		
		private function onStatisticsHandler(e:Event):void 
		{
			PopUpManager.addPopUp(new StatisticsPopup());
		}
		
		private function onPlayHandler(e:Event):void 
		{
			dispatchEventWith(PLAY);
		}
		
		override public function dispose():void 
		{
			_mainContainer.removeChildren(0, -1, true);
			_mainContainer.removeFromParent(true);
			
			_playButton.removeEventListeners();
			_playButton.removeFromParent(true);
			
			_statisticsButton.removeEventListeners();
			_statisticsButton.removeFromParent(true);
			
			_moreGamesButton.removeEventListeners();
			_moreGamesButton.removeFromParent(true);
			
			super.dispose();
		}
	}

}