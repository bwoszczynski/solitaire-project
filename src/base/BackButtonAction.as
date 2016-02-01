package base 
{
	import view.BasePopupView;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class BackButtonAction 
	{
		public var type:String;
		public var popup:BasePopupView;
		
		public function BackButtonAction(actionType:String, shownPopup:BasePopupView = null) 
		{
			type = actionType;
			popup = shownPopup;
		}
		
	}

}