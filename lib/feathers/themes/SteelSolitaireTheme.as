package feathers.themes 
{
	import feathers.controls.Button;
	import feathers.controls.ToggleButton;
	import feathers.controls.ToggleSwitch;
	import feathers.core.PopUpManager;
	import feathers.core.ToggleGroup;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.text.BitmapFontTextFormat;
	import flash.text.TextFormatAlign;
	import manager.GlobalAssetManager;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class SteelSolitaireTheme extends StyleNameFunctionTheme 
	{
		static public const MENU_PLAY_BUTTON:String = "menuPlayButton";
		static public const MENU_SIMPLE_BUTTON:String = "menuSimpleButton";
		static public const MINIGAME_SIMPLE_BUTTON:String = "minigameSimpleButton";
		static public const MAIN_FONT:String = "Bespoke_0";
		static public const POPUP_SIMPLE_BUTTON:String = "popupSimpleButton";
		static public const SETTINGS_DECK_CARDS_ONE_BUTTON:String = "settingsDeckCardsOneButton";
		static public const SETTINGS_DECK_CARDS_THREE_BUTTON:String = "settingsDeckCardsThreeButton";
		static public const SETTINGS_TIME_BUTTON:String = "settingsTimeButton";
		static public const SETTINGS_MOVES_BUTTON:String = "settingsMovesButton";
		static public const SETTINGS_SWITCH:String = "settingsSwitch";
		static public const SETTINGS_MUTE_ON_BUTTON:String = "settingsMuteOnButton";
		static public const SETTINGS_MUTE_OFF_BUTTON:String = "settingsMuteOffButton";
		static public const SETTINGS_HINT_OFF_BUTTON:String = "settingsHintOffButton";
		static public const SETTINGS_HINT_ON_BUTTON:String = "settingsHintOnButton";
		private var _menuPlayButtonTexture:Texture;0
		private var _menuSimpleButtonTexture:Texture;
		private var _minigameSimpleButtonTexture:Texture;
		private var _minigameSimpleButtonDownTexture:Texture;
		private var _menuSimpleButtonDownTexture:Texture;
		private var _menuPlayButtonDownTexture:Texture;
		private var _buttonSettingsDeckOneCard:Texture;
		private var _buttonSettingsDeckOneCardsSelected:Texture;
		private var _buttonSettingsDeckThreeCards:Texture;
		private var _buttonSettingsDeckThreeCardsSelected:Texture;
		private var _buttonSettingsMoves:Texture;
		private var _buttonSettingsMovesSelected:Texture;
		private var _buttonSettingsTime:Texture;
		private var _buttonSettingsTimeSelected:Texture;
		private var _buttonMenuPlayTextFormat:BitmapFontTextFormat;
		private var _buttonMinigameTextFormat:BitmapFontTextFormat;
		private var _buttonMenuSimpleTextFormat:BitmapFontTextFormat;
		private var _popupSimpleButtonTexture:Texture;
		private var _popupSimpleButtonDownTexture:Texture;
		private var _buttonPopupSimpleTextFormat:BitmapFontTextFormat;
		private var _defaultTrackTexture:Texture;
		private var _defaultTrackThumb:Texture;
		private var _buttonSettingsMuteOnSelected:Texture;
		private var _buttonSettingsMuteOn:Texture;
		private var _buttonSettingsMuteOffSelected:Texture;
		private var _buttonSettingsMuteOff:Texture;
		private var _buttonSettingsHintOnSelected:Texture;
		private var _buttonSettingsHintOn:Texture;
		private var _buttonSettingsHintOffSelected:Texture;
		private var _buttonSettingsHintOff:Texture;
		
		public function SteelSolitaireTheme() 
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			initializeTextFormats();
			initializeTextures();
			initializeStyleProviders();		
			
			PopUpManager.overlayFactory = function ():Quad {
				var quad:Quad = new Quad(10, 10, 0x000000);
					quad.alpha = 0.75;					
				return quad;
			}
		}
		
		private function initializeTextures():void 
		{
			_menuPlayButtonTexture = GlobalAssetManager.instance.assetManager.getTexture("mainMenuPlayButton");
			_menuPlayButtonDownTexture = GlobalAssetManager.instance.assetManager.getTexture("mainMenuPlayButtonDown");
			_menuSimpleButtonTexture = GlobalAssetManager.instance.assetManager.getTexture("mainMenuSimpleButton");
			_menuSimpleButtonDownTexture = GlobalAssetManager.instance.assetManager.getTexture("mainMenuSimpleButtonDown");
			_minigameSimpleButtonTexture = GlobalAssetManager.instance.assetManager.getTexture("minigameSipleButton");
			_minigameSimpleButtonDownTexture = GlobalAssetManager.instance.assetManager.getTexture("minigameSipleButtonDown");
			_popupSimpleButtonTexture = GlobalAssetManager.instance.assetManager.getTexture("popupSimpleBUtton");
			_popupSimpleButtonDownTexture = GlobalAssetManager.instance.assetManager.getTexture("popupSimpleBUttonDown");
			_buttonSettingsDeckOneCard = GlobalAssetManager.instance.assetManager.getTexture("settingsOneCardButton");
			_buttonSettingsDeckOneCardsSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsOneCardSelectedButton");
			_buttonSettingsDeckThreeCards = GlobalAssetManager.instance.assetManager.getTexture("settingsThreeCardsButton");
			_buttonSettingsDeckThreeCardsSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsThreeCardsSelectedButton");
			_buttonSettingsMoves = GlobalAssetManager.instance.assetManager.getTexture("settingsMovesModeButton");
			_buttonSettingsMovesSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsMovesModeSelectedButton");
			_buttonSettingsTime = GlobalAssetManager.instance.assetManager.getTexture("settingsTimeModeButton");
			_buttonSettingsTimeSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsTimeModeSelectedButton");
			_defaultTrackTexture = GlobalAssetManager.instance.assetManager.getTexture("settingsSliderBg");
			_defaultTrackThumb = GlobalAssetManager.instance.assetManager.getTexture("settingsSliderButton");			
			_buttonSettingsMuteOff = GlobalAssetManager.instance.assetManager.getTexture("settingsSoundOnButton");
			_buttonSettingsMuteOffSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsSoundOnSelectedButton");
			_buttonSettingsMuteOn = GlobalAssetManager.instance.assetManager.getTexture("settingsSoundOffButton");
			_buttonSettingsMuteOnSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsSoundOffSelectedButton");			
			_buttonSettingsHintOff = GlobalAssetManager.instance.assetManager.getTexture("settingsNoHintButton");
			_buttonSettingsHintOffSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsNoHintSelectedButton");
			_buttonSettingsHintOn = GlobalAssetManager.instance.assetManager.getTexture("settingsHintButton");
			_buttonSettingsHintOnSelected = GlobalAssetManager.instance.assetManager.getTexture("settingsHintSelectedButton");
			
		}
		
		private function initializeStyleProviders():void
		{
			this.getStyleProviderForClass(Button).setFunctionForStyleName(MENU_PLAY_BUTTON, this.setMenuPlayButtonStyle);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(MENU_SIMPLE_BUTTON, this.setMenuSimpleButtonStyle);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(MINIGAME_SIMPLE_BUTTON, this.setMinigameSimpleButtonStyle);
			this.getStyleProviderForClass(Button).setFunctionForStyleName(POPUP_SIMPLE_BUTTON, this.setPopupSimpleButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_DECK_CARDS_ONE_BUTTON, this.setSettingsDeckCardsOneButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_DECK_CARDS_THREE_BUTTON, this.setSettingsDeckCardsThreeButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_TIME_BUTTON, this.setSettingsTimeButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_MOVES_BUTTON, this.setSettingsMovesButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_MUTE_OFF_BUTTON, this.setSettingsMuteOffButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_MUTE_ON_BUTTON, this.setSettingsMuteOnButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_HINT_OFF_BUTTON, this.setSettingsHintOffButtonStyle);
			this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName(SETTINGS_HINT_ON_BUTTON, this.setSettingsHintOnButtonStyle);
			this.getStyleProviderForClass(ToggleSwitch).setFunctionForStyleName(SETTINGS_SWITCH, this.setSettingsSwitchStyle);
		}
		
		private function initializeTextFormats():void 
		{
			_buttonMenuPlayTextFormat = new BitmapFontTextFormat(MAIN_FONT, 86, 0xFFFFFF, TextFormatAlign.CENTER);
			_buttonMinigameTextFormat = new BitmapFontTextFormat(MAIN_FONT, 52, 0xFFFFFF, TextFormatAlign.CENTER);
			_buttonMenuSimpleTextFormat = new BitmapFontTextFormat(MAIN_FONT, 46, 0xFFFFFF, TextFormatAlign.CENTER);
			_buttonPopupSimpleTextFormat = new BitmapFontTextFormat(MAIN_FONT, 42, 0xFFFFFF, TextFormatAlign.CENTER);
		}
		protected function setSettingsHintOffButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsHintOff;
			skinSelector.defaultSelectedValue = _buttonSettingsHintOffSelected;
			
			button.stateToSkinFunction = skinSelector.updateValue;
			
		}
		
		protected function setSettingsHintOnButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsHintOn;
			skinSelector.defaultSelectedValue = _buttonSettingsHintOnSelected;
			
			
			button.stateToSkinFunction = skinSelector.updateValue;
			
		}
		
		protected function setSettingsMuteOffButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsMuteOff;
			skinSelector.defaultSelectedValue = _buttonSettingsMuteOffSelected;
			
			button.stateToSkinFunction = skinSelector.updateValue;
			
		}
		
		protected function setSettingsMuteOnButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsMuteOn;
			skinSelector.defaultSelectedValue = _buttonSettingsMuteOnSelected;
			
			
			button.stateToSkinFunction = skinSelector.updateValue;
			
		}
		
		protected function setSettingsSwitchStyle(button:ToggleSwitch):void
		{
			button.showLabels = false;
			button.onTrackFactory = defaultTrackFactory;
			button.offTrackFactory = defaultTrackFactory;
			
			button.thumbFactory = defaultThumbFactory;
		}
		private function defaultThumbFactory():Button
		{
			var onTrack:Button = new Button();
			onTrack.defaultSkin = new Image( _defaultTrackThumb );
			return onTrack;
		}
		
		private function defaultTrackFactory():Button
		{
			var onTrack:Button = new Button();
			onTrack.defaultSkin = new Image( _defaultTrackTexture );
			return onTrack;
		}
		
		protected function setSettingsMovesButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsMoves;
			skinSelector.defaultSelectedValue = _buttonSettingsMovesSelected;
			
			button.stateToSkinFunction = skinSelector.updateValue;
		}
		
		protected function setSettingsTimeButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsTime;
			skinSelector.defaultSelectedValue = _buttonSettingsTimeSelected;
			
			button.stateToSkinFunction = skinSelector.updateValue;
		}
		
		protected function setSettingsDeckCardsOneButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsDeckOneCard;
			skinSelector.defaultSelectedValue = _buttonSettingsDeckOneCardsSelected;
			
			button.stateToSkinFunction = skinSelector.updateValue;
			
		}
		
		protected function setSettingsDeckCardsThreeButtonStyle(button:ToggleButton):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _buttonSettingsDeckThreeCards;
			skinSelector.defaultSelectedValue = _buttonSettingsDeckThreeCardsSelected;
			
			
			button.stateToSkinFunction = skinSelector.updateValue;
			
		}
		
		protected function setPopupSimpleButtonStyle(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _popupSimpleButtonTexture;
			skinSelector.setValueForState(_popupSimpleButtonTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(_popupSimpleButtonDownTexture, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 161,
				height: 55
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			
			button.defaultLabelProperties.textFormat = _buttonPopupSimpleTextFormat;
			
		}
		
		protected function setMinigameSimpleButtonStyle(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _minigameSimpleButtonTexture;
			skinSelector.setValueForState(_minigameSimpleButtonTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(_minigameSimpleButtonDownTexture, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 209,
				height: 70
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			
			button.defaultLabelProperties.textFormat = _buttonMinigameTextFormat;
			button.paddingLeft = 15;
			button.paddingRight = 15;
		}
		
		protected function setMenuPlayButtonStyle(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _menuPlayButtonTexture;
			skinSelector.setValueForState(_menuPlayButtonTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(_menuPlayButtonDownTexture, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 322,
				height: 113
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			
			button.defaultLabelProperties.textFormat = _buttonMenuPlayTextFormat;
			
		}
		
		protected function setMenuSimpleButtonStyle(button:Button):void
		{
			var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = _menuSimpleButtonTexture;
			skinSelector.setValueForState(_menuSimpleButtonTexture, Button.STATE_HOVER, false);
			skinSelector.setValueForState(_menuSimpleButtonDownTexture, Button.STATE_DOWN, false);
			skinSelector.displayObjectProperties =
			{
				width: 322,
				height: 80
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			
			button.defaultLabelProperties.textFormat = _buttonMenuSimpleTextFormat;
			
		}
	}

}