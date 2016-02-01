package minigame.logic 
{
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class LogicCard 
	{
		public var suit:String;
		public var value:String;
		public var column:int;
		public var position:int;
		public var isShown:Boolean;
		public var type:String;
		public var currentSlotNum:int;
		public var forceLayout:Boolean;
		
		public function LogicCard(description:Object) 
		{
			suit = description["suit"];
			value = description["value"];
			
			column = -1;
			position = -1;
			isShown = false;
			type = "deck";
			currentSlotNum = -1;
			forceLayout = false;
		}
		
	}

}