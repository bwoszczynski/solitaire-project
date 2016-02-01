package view 
{
	import base.BackButtonAction;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feathers.themes.SteelSolitaireTheme;
	import flash.desktop.NativeApplication;
	import manager.BackButtonManager;
	import manager.GlobalDispatcher;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class ExitAppPopup extends BasePopupView 
	{
		
		public function ExitAppPopup(data:Object = null) 
		{
			super();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MAIN_MENU_EXIT_APP_POPUP_ACTION, this));
			
			_headerText.text = "EXIT GAME";
			
			var infoText:TextField = new TextField( 450, 230, "Are you sure \nyou want to leave?", SteelSolitaireTheme.MAIN_FONT, 46, 0xA08770, true);
				infoText.autoScale = true;
				
			_bg.addChild(infoText);
			_bg.width = 450;
			_bg.height = 250;
			
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
			//super.clean();
			//AdMobManager.instance.hideAd();
			dispatchEventWith(POPUP_HIDDEN, false,  _exitData);			
			this.removeChildren(0, -1, true);
			this.removeFromParent(true);
			Starling.juggler.removeTweens(_graphicsContainer);
		}
		
		override public function prepareOkButton():void 
		{
			//super.prepareOkButton();
			var cont:LayoutGroup = new LayoutGroup();
			var layout:HorizontalLayout = new HorizontalLayout();
				layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				layout.gap = 15;
				cont.layout = layout;
				cont.width = _bg.width;			
				
			var button:Button = new Button();
				button.styleName = SteelSolitaireTheme.POPUP_SIMPLE_BUTTON;
				button.label = "OK";				
				button.addEventListener(Event.TRIGGERED, function():void { NativeApplication.nativeApplication.exit(0)} );
				cont.addChild(button);
				_graphicsContainer.addChild(cont);
				
				button = new Button();
				button.styleName = SteelSolitaireTheme.POPUP_SIMPLE_BUTTON;
				button.label = "CANCEL";				
				button.addEventListener(Event.TRIGGERED, function():void { hide() } );
				cont.addChild(button);
				_graphicsContainer.addChild(cont);
				
				cont.y = _bg.height - button.height + 5;
		}
		
		override public function hide():void 
		{
			super.hide();
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MAIN_MENU_BACK_ACTION));
			
		}
		
	}

}