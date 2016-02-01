package minigame.logic 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class LogicHelper 
	{
		//spades (♠), hearts (♥), diamonds (♦), clubs (♣)
		public static const SPADES:String = "SPADES";
		public static const HEARTS:String = "HEARTS";
		public static const DIAMONDS:String = "DIAMONDS";
		public static const CLUBS:String = "CLUBS";
		
		public static const allCards:Array = [ 
												{ suit: "SPADES", value: "2" },	
												{ suit: "SPADES", value: "3" },
												{ suit: "SPADES", value: "4" },
												{ suit: "SPADES", value: "5" },
												{ suit: "SPADES", value: "6" },
												{ suit: "SPADES", value: "7" },
												{ suit: "SPADES", value: "8" },
												{ suit: "SPADES", value: "9" },
												{ suit: "SPADES", value: "10" },
												{ suit: "SPADES", value: "J" },
												{ suit: "SPADES", value: "Q" },
												{ suit: "SPADES", value: "K" },
												{ suit: "SPADES", value: "A" },
												
												{ suit: "HEARTS", value: "2" },	
												{ suit: "HEARTS", value: "3" },
												{ suit: "HEARTS", value: "4" },
												{ suit: "HEARTS", value: "5" },
												{ suit: "HEARTS", value: "6" },
												{ suit: "HEARTS", value: "7" },
												{ suit: "HEARTS", value: "8" },
												{ suit: "HEARTS", value: "9" },
												{ suit: "HEARTS", value: "10" },
												{ suit: "HEARTS", value: "J" },
												{ suit: "HEARTS", value: "Q" },
												{ suit: "HEARTS", value: "K" },
												{ suit: "HEARTS", value: "A" },
												
												{ suit: "DIAMONDS", value: "2" },	
												{ suit: "DIAMONDS", value: "3" },
												{ suit: "DIAMONDS", value: "4" },
												{ suit: "DIAMONDS", value: "5" },
												{ suit: "DIAMONDS", value: "6" },
												{ suit: "DIAMONDS", value: "7" },
												{ suit: "DIAMONDS", value: "8" },
												{ suit: "DIAMONDS", value: "9" },
												{ suit: "DIAMONDS", value: "10" },
												{ suit: "DIAMONDS", value: "J" },
												{ suit: "DIAMONDS", value: "Q" },
												{ suit: "DIAMONDS", value: "K" },
												{ suit: "DIAMONDS", value: "A" },
												
												{ suit: "CLUBS", value: "2" },	
												{ suit: "CLUBS", value: "3" },
												{ suit: "CLUBS", value: "4" },
												{ suit: "CLUBS", value: "5" },
												{ suit: "CLUBS", value: "6" },
												{ suit: "CLUBS", value: "7" },
												{ suit: "CLUBS", value: "8" },
												{ suit: "CLUBS", value: "9" },
												{ suit: "CLUBS", value: "10" },
												{ suit: "CLUBS", value: "J" },
												{ suit: "CLUBS", value: "Q" },
												{ suit: "CLUBS", value: "K" },
												{ suit: "CLUBS", value: "A" },
		
		];
		
		public static var VALUES_PARSER:Dictionary = new Dictionary();
							VALUES_PARSER["2"] = 2;
							VALUES_PARSER["3"] = 3;
							VALUES_PARSER["4"] = 4;
							VALUES_PARSER["5"] = 5;
							VALUES_PARSER["6"] = 6;
							VALUES_PARSER["7"] = 7;
							VALUES_PARSER["8"] = 8;
							VALUES_PARSER["9"] = 9;
							VALUES_PARSER["10"] = 10;
							VALUES_PARSER["J"] = 11;
							VALUES_PARSER["Q"] = 12;
							VALUES_PARSER["K"] = 13;
							VALUES_PARSER["A"] = 1;
							
		public static var DECK_SHOWN_CARDS:int = 3;
		public static const SLOTS_NUM:int = 4;
		static public const WON:String = "won";
		static public const LOST:String = "lost";
		static public const HINT_DELAY:int = 10;
		static public var prevShuffledArray:Array;
		
	}

}