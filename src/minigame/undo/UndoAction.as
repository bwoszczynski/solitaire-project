package minigame.undo 
{
	import minigame.card.CardView;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class UndoAction 
	{
		public static var ACTIONS_COUNTER:int = 0;
		
		private var _flipDestinationCard:Boolean;
		private var _checkType:String;
		private var _destination:Object;
		private var _dragedCard:CardView;
		private var _additionalData:Object;
		
		public function UndoAction() 
		{
			ACTIONS_COUNTER++;
		}
		
		public function get dragedCard():CardView 
		{
			return _dragedCard;
		}
		
		public function set dragedCard(value:CardView):void 
		{
			_dragedCard = value;
		}
		
		public function get destination():Object 
		{
			return _destination;
		}
		
		public function set destination(value:Object):void 
		{
			_destination = value;
		}
		
		public function get checkType():String 
		{
			return _checkType;
		}
		
		public function set checkType(value:String):void 
		{
			_checkType = value;
			//trace("ADD TO UNDO ", ACTIONS_COUNTER, _checkType)
		}
		
		public function get flipDestinationCard():Boolean 
		{
			return _flipDestinationCard;
		}
		
		public function set flipDestinationCard(value:Boolean):void 
		{
			_flipDestinationCard = value;
		}
		
		public function get additionalData():Object 
		{
			return _additionalData;
		}
		
		public function set additionalData(value:Object):void 
		{
			_additionalData = value;
		}
		
	}

}