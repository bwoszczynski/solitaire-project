package view 
{
	import base.BackButtonAction;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ToggleButton;
	import feathers.controls.ToggleSwitch;
	import feathers.core.ToggleGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.themes.SteelSolitaireTheme;
	import manager.BackButtonManager;
	import manager.GlobalAssetManager;
	import manager.GlobalDispatcher;
	import minigame.logic.LogicHelper;
	import player.PlayerModel;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import treefortress.sound.SoundAS;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class SettingsPopup extends BasePopupView 
	{
		private var _deckCardsSwitch:ToggleSwitch;
		private var _deckCardsToggleGroup:ToggleGroup;
		private var _gameTypeToggleGroup:ToggleGroup;
		private var _gameTypeSwitch:ToggleSwitch;
		private var _soundsToggleGroup:ToggleGroup;
		private var _soundsSwitch:ToggleSwitch;
		private var _hintToggleGroup:ToggleGroup;
		private var _hintSwitch:ToggleSwitch;
		
		public function SettingsPopup() 
		{
			super();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MAIN_MENU_SETTINGS_POPUP_ACTION, this));
			
			_headerText.text = "SETTINGS";
			
			var settingsContainer:LayoutGroup = new LayoutGroup();
			var layout:VerticalLayout = new VerticalLayout();
				layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
				layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
				layout.gap = 20;
				layout.paddingTop = 70;
				//layout.paddingLeft = layout.paddingRight = 10;
				//layout.lastGap = 20;
				settingsContainer.layout = layout;
			var horizontalLayout:HorizontalLayout = new HorizontalLayout();
				horizontalLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
				horizontalLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				horizontalLayout.gap = 20;
				
			settingsContainer.width = _bg.width = 560;
			settingsContainer.height = _bg.height = 600;
			_graphicsContainer.addChild(settingsContainer);
			
			//var text:TextField = new TextField(_bg.width - 20, 40, "DECK CARDS", SteelSolitaireTheme.MAIN_FONT, 36, 0x835D25, true);
			//settingsContainer.addChild(text);
			
			var cont:LayoutGroup = new LayoutGroup();
				cont.width = _bg.width;
				cont.layout = horizontalLayout;
				
			var toggleButton:ToggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_DECK_CARDS_ONE_BUTTON;
				cont.addChild(toggleButton);
				
			_deckCardsToggleGroup = new ToggleGroup();
			_deckCardsToggleGroup.addItem(toggleButton);
				
				_deckCardsSwitch = new ToggleSwitch();
				_deckCardsSwitch.styleName = SteelSolitaireTheme.SETTINGS_SWITCH;
				_deckCardsSwitch.addEventListener(Event.CHANGE, onDeckCardsSwitchChange);
				cont.addChild(_deckCardsSwitch);
				
				toggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_DECK_CARDS_THREE_BUTTON;
				
				cont.addChild(toggleButton);
				
				_deckCardsToggleGroup.addItem(toggleButton);
				_deckCardsToggleGroup.addEventListener(Event.CHANGE, onDeckCardsNumChange);				
				_deckCardsToggleGroup.selectedIndex = LogicHelper.DECK_SHOWN_CARDS == 1 ? 0 : 1;
				
			settingsContainer.addChild(cont);
			
			//text = new TextField(_bg.width - 20, 40, "GAME TYPE", SteelSolitaireTheme.MAIN_FONT, 36, 0x835D25, true);
			//settingsContainer.addChild(text);
			var line:Image = new Image(GlobalAssetManager.instance.assetManager.getTexture("popupLine"));
				settingsContainer.addChild(line);
			
			cont = new LayoutGroup();
			cont.width = _bg.width;
			cont.layout = horizontalLayout;
				toggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_TIME_BUTTON;
				cont.addChild(toggleButton);
				
				_gameTypeToggleGroup = new ToggleGroup();
				_gameTypeToggleGroup.addItem(toggleButton);
				
				_gameTypeSwitch = new ToggleSwitch();
				_gameTypeSwitch.styleName = SteelSolitaireTheme.SETTINGS_SWITCH;
				_gameTypeSwitch.addEventListener(Event.CHANGE, onGameTypeSwitchChange);
				cont.addChild(_gameTypeSwitch);
				
				toggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_MOVES_BUTTON;
				cont.addChild(toggleButton);
				
				_gameTypeToggleGroup.addItem(toggleButton);
				_gameTypeToggleGroup.addEventListener(Event.CHANGE, onGameTypeChange);
				
				_gameTypeToggleGroup.selectedIndex = PlayerModel.instance.gameType == PlayerModel.TIME_GAME ? 0 : 1;
			settingsContainer.addChild(cont);
			
				line = new Image(GlobalAssetManager.instance.assetManager.getTexture("popupLine"));
				settingsContainer.addChild(line);
				
			cont = new LayoutGroup();
			cont.width = _bg.width;
			cont.layout = horizontalLayout;
			
				toggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_MUTE_OFF_BUTTON;
				cont.addChild(toggleButton);
				
				_soundsToggleGroup = new ToggleGroup();
				_soundsToggleGroup.addItem(toggleButton);
				
				_soundsSwitch = new ToggleSwitch();
				_soundsSwitch.styleName = SteelSolitaireTheme.SETTINGS_SWITCH;
				_soundsSwitch.addEventListener(Event.CHANGE, onSoundSwitchChange);
				cont.addChild(_soundsSwitch);
				
				toggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_MUTE_ON_BUTTON;
				cont.addChild(toggleButton);
				
				_soundsToggleGroup.addItem(toggleButton);
				_soundsToggleGroup.addEventListener(Event.CHANGE, onSoundsChange);
				
				_soundsToggleGroup.selectedIndex = PlayerModel.instance.mute ? 1 : 0;
			settingsContainer.addChild(cont);
				
			line = new Image(GlobalAssetManager.instance.assetManager.getTexture("popupLine"));
				settingsContainer.addChild(line);
				
			cont = new LayoutGroup();
			cont.width = _bg.width;
			cont.layout = horizontalLayout;
			
				toggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_HINT_OFF_BUTTON;
				cont.addChild(toggleButton);
				
				_hintToggleGroup = new ToggleGroup();
				_hintToggleGroup.addItem(toggleButton);
				
				_hintSwitch = new ToggleSwitch();
				_hintSwitch.styleName = SteelSolitaireTheme.SETTINGS_SWITCH;
				_hintSwitch.addEventListener(Event.CHANGE, onHintSwitchChange);
				cont.addChild(_hintSwitch);
				
				toggleButton = new ToggleButton();
				toggleButton.styleName = SteelSolitaireTheme.SETTINGS_HINT_ON_BUTTON;
				cont.addChild(toggleButton);
				
				_hintToggleGroup.addItem(toggleButton);
				_hintToggleGroup.addEventListener(Event.CHANGE, onHintChange);
				
				_hintToggleGroup.selectedIndex = PlayerModel.instance.hint ? 1 : 0;
			settingsContainer.addChild(cont);
			
			
			
			
			_header.x = int(_bg.width / 2 - _header.width / 2);
			
			prepareOkButton();
		}
		
		override protected function shown():void 
		{
			//super.shown();
			dispatchEventWith(POPUP_SHOWN);
		}
		
		override public function clean():void 
		{
			_deckCardsSwitch.removeEventListeners();
			_deckCardsSwitch.removeFromParent(true);
			
			//_deckCardsToggleGroup.removeAllItems();
			_deckCardsToggleGroup.removeEventListeners();
			
			//_gameTypeToggleGroup.removeAllItems();
			_gameTypeToggleGroup.removeEventListeners();
			
			_gameTypeSwitch.removeEventListeners();
			_gameTypeSwitch.removeFromParent(true);
			
			//_soundsToggleGroup.removeAllItems();
			_soundsToggleGroup.removeEventListeners();
			
			_soundsSwitch.removeEventListeners();
			_soundsSwitch.removeFromParent(true);
			
			//_hintToggleGroup.removeAllItems();
			_hintToggleGroup.removeEventListeners();
			
			_hintSwitch.removeEventListeners();
			_hintSwitch.removeFromParent(true);
			
			dispatchEventWith(POPUP_HIDDEN, false,  _exitData);			
			this.removeChildren(0, -1, true);
			this.removeFromParent(true);
			Starling.juggler.removeTweens(_graphicsContainer);
		}
		
		private function onHintChange(e:Event):void 
		{
			var toggleGroup:ToggleGroup = ToggleGroup(e.currentTarget);
			var hint:Boolean = toggleGroup.selectedIndex == 0 ? false : true;
			
			PlayerModel.instance.saveDataByName(PlayerModel.HINT, hint);
			
			_hintSwitch.setSelectionWithAnimation(toggleGroup.selectedIndex == 1);
		}
		
		private function onHintSwitchChange(e:Event):void 
		{
			_hintToggleGroup.selectedIndex = _hintSwitch.isSelected ? 1 : 0;
		}
		
		private function onSoundSwitchChange(e:Event):void 
		{
			_soundsToggleGroup.selectedIndex = _soundsSwitch.isSelected ? 1 : 0;
		}
		
		private function onSoundsChange(e:Event):void 
		{
			var toggleGroup:ToggleGroup = ToggleGroup(e.currentTarget);
			var mute:Boolean = toggleGroup.selectedIndex == 1 ? true : false;
			
			PlayerModel.instance.saveDataByName(PlayerModel.MUTE, mute);
			
			SoundAS.group("sounds").mute = mute;
			
			_soundsSwitch.setSelectionWithAnimation(toggleGroup.selectedIndex == 1);
		}
		
		private function onGameTypeSwitchChange(e:Event):void 
		{
			_gameTypeToggleGroup.selectedIndex = _gameTypeSwitch.isSelected ? 1 : 0;
		}
		
		private function onDeckCardsSwitchChange(e:Event):void 
		{
			_deckCardsToggleGroup.selectedIndex = _deckCardsSwitch.isSelected ? 1 : 0;
		}
		
		private function onGameTypeChange(e:Event):void 
		{
			var toggleGroup:ToggleGroup = ToggleGroup(e.currentTarget);
			PlayerModel.instance.gameType = toggleGroup.selectedIndex == 0 ? PlayerModel.TIME_GAME : PlayerModel.MOVES_GAME;
			
			PlayerModel.instance.saveDataByName(PlayerModel.GAME_TYPE, PlayerModel.instance.gameType);
			
			_gameTypeSwitch.setSelectionWithAnimation(toggleGroup.selectedIndex == 1);
		}
		
		private function onDeckCardsNumChange(e:Event):void 
		{
			var toggleGroup:ToggleGroup = ToggleGroup(e.currentTarget);
			LogicHelper.DECK_SHOWN_CARDS = toggleGroup.selectedIndex == 0 ? 1 : 3;
			
			PlayerModel.instance.saveDataByName(PlayerModel.DECK_SHOWN_CARDS, LogicHelper.DECK_SHOWN_CARDS);
			
			_deckCardsSwitch.setSelectionWithAnimation(toggleGroup.selectedIndex == 1);
		}	
		
		override public function hide():void 
		{
			super.hide();
			
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MAIN_MENU_BACK_ACTION));
			
		}
		
	}

}