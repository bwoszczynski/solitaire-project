package minigame.logic 
{
	import flash.geom.Point;
	import minigame.slot.CardSlot;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class LogicManager 
	{
		static public const NUM_COLUMNS:int = 7;		
		static public const TABLE:String = "table";
		static public const DECK:String = "deck";
		
		private var _deck:Vector.<LogicCard>;
		private var _columns:Vector.<Vector.<LogicCard>>;
		private var _slots:Vector.<Vector.<LogicCard>>;
		
		public function LogicManager(replay:Boolean = false) 
		{
			_deck = shuffleCards(replay);
			
			_columns = new Vector.<Vector.<LogicCard>>();
			
			_slots = new Vector.<Vector.<LogicCard>>();
			for (var i:int = 0; i < LogicHelper.SLOTS_NUM; i++) 
			{
				_columns[i] = new Vector.<LogicCard>();
			}
			
			distributeCards();
		}
		
		public function checkEmptyField(dragedCard:LogicCard, fieldNum:int, checkType:String, skipLogic:Boolean = false, logicCheckOnly:Boolean = false, skipCardShownStatus:Boolean = false):Vector.<Object>
		{
			var cardToMove:LogicCard;
			var resultCards:Vector.<Object>;
			
			var result:Boolean = false;
			
			if (!logicCheckOnly)
			{				
				if (dragedCard.currentSlotNum >= 0)
				{
					if (((_columns[fieldNum].length == 0 && dragedCard.value == "K") && (dragedCard.isShown || skipCardShownStatus)) || skipLogic)
					{
							resultCards = new Vector.<Object>();							
							
							cardToMove = dragedCard;
							cardToMove.type = TABLE;
							cardToMove.column = fieldNum;
							cardToMove.position = _columns[fieldNum].length;
							cardToMove.currentSlotNum = -1;
							_columns[fieldNum].push(cardToMove);
							
							resultCards.push( { column: cardToMove.column, position: cardToMove.position, prevCardShownValues: getIsShownValues(cardToMove.column, cardToMove.position) } );
						
					}
					
					return resultCards;
				}
			}
			
			if (((_columns[fieldNum].length == 0 && dragedCard.value == "K") && (dragedCard.isShown || skipCardShownStatus)) || skipLogic)
			{
				resultCards = new Vector.<Object>();
				// add to proper column, remove from prev column
				if (dragedCard.column >= 0)
				{
					var numCardsToMove:int = _columns[dragedCard.column].length - dragedCard.position;
					
					var dragedCardColumn:int = dragedCard.column;
						
					if (!logicCheckOnly)
					{
						while (numCardsToMove)
						{
							cardToMove = _columns[dragedCardColumn].splice(_columns[dragedCardColumn].length - numCardsToMove, 1)[0];
							cardToMove.column = fieldNum;
							cardToMove.position = _columns[fieldNum].length;
							_columns[fieldNum].push(cardToMove);
							
							resultCards.push( { column: cardToMove.column, position: cardToMove.position, prevCardShownValues: getIsShownValues(cardToMove.column, cardToMove.position)} );
							
							numCardsToMove--;
						}
					}
					else
						resultCards.push( { logicCheckOnly: true } );
				}
				else
				{
					if (!logicCheckOnly)
					{
						cardToMove = dragedCard;
						cardToMove.type = TABLE;
						cardToMove.column = fieldNum;
						cardToMove.position = _columns[fieldNum].length;
						_columns[fieldNum].push(cardToMove);
						
						resultCards.push( { column: cardToMove.column, position: cardToMove.position, prevCardShownValues: getIsShownValues(cardToMove.column, cardToMove.position) } );
					}
					else
						resultCards.push( { logicCheckOnly: true } );
				}
				if (!resultCards.length)
					resultCards = null;
			}
			
			
			return resultCards;
		}
		
		
		public function checkSlot(dragedCard:LogicCard, slot:CardSlot, checkType:String, logicCheckOnly:Boolean = false, skipCardShownStatus:Boolean = false):Boolean 
		{
			if (!dragedCard.isShown && !skipCardShownStatus)
				return false;
				
			var result:Boolean = false;
			
			if (!slot.lastLogicCard && dragedCard.value == "A")
			{
				if (!logicCheckOnly)
				{
					if (dragedCard.column >= 0 && dragedCard.currentSlotNum < 0)
						_columns[dragedCard.column].pop();
				}
					result = true;
				
			}
			else if (slot.lastLogicCard)
			{
				if (slot.lastLogicCard.suit == dragedCard.suit && LogicHelper.VALUES_PARSER[dragedCard.value] - LogicHelper.VALUES_PARSER[slot.lastLogicCard.value] == 1)
				{
					if (!logicCheckOnly)
					{
						if (dragedCard.column >= 0 && dragedCard.currentSlotNum < 0)
							_columns[dragedCard.column].pop();
					}
					result = true;
				}
				
			}
			
			return result;
		}
		
		public function checkMove(dragedCard:LogicCard, destinationCard:LogicCard, checkType:String, skipLogic:Boolean = false, logicCheckOnly:Boolean = false, skipCardShownStatus:Boolean = false):Vector.<Object> 
		{
			var cardToMove:LogicCard;
			var resultCards:Vector.<Object>;
			
			if (!logicCheckOnly)
			{				
				if (dragedCard.currentSlotNum >= 0)
				{
					if ((!checkColor(dragedCard.suit, destinationCard.suit) && (dragedCard.isShown || skipCardShownStatus) ) || skipLogic)
					{
						if ((isLastCard(destinationCard) && LogicHelper.VALUES_PARSER[destinationCard.value] != 1 && LogicHelper.VALUES_PARSER[dragedCard.value] - LogicHelper.VALUES_PARSER[destinationCard.value] == -1) || skipLogic)
						{
							resultCards = new Vector.<Object>();							
							
							cardToMove = dragedCard;
							cardToMove.type = TABLE;
							cardToMove.column = destinationCard.column;
							cardToMove.position = _columns[destinationCard.column].length;
							cardToMove.currentSlotNum = -1;
							_columns[destinationCard.column].push(cardToMove);
							
							resultCards.push( { column: cardToMove.column, position: cardToMove.position, prevCardShownValues: getIsShownValues(cardToMove.column, cardToMove.position) } );
						
						}
					}
					
					return resultCards;
				}
			}
			
			switch(checkType)
			{
				case TABLE:
				{
					if ((!checkColor(dragedCard.suit, destinationCard.suit) && (dragedCard.isShown || skipCardShownStatus))|| skipLogic)
					{
						if ((isLastCard(destinationCard) && LogicHelper.VALUES_PARSER[destinationCard.value] != 1 && LogicHelper.VALUES_PARSER[dragedCard.value] - LogicHelper.VALUES_PARSER[destinationCard.value] == -1) || skipLogic)
						{
							resultCards = new Vector.<Object>();
							// add to proper column, remove from prev column
							var numCardsToMove:int = _columns[dragedCard.column].length - dragedCard.position;
							cardToMove;
							var dragedCardColumn:int = dragedCard.column;
							
							if (!logicCheckOnly)
							{
								while (numCardsToMove)
								{
									//cardToMove = _columns[dragedCard.column].pop();
									if (destinationCard.column != dragedCardColumn)
									{
										cardToMove = _columns[dragedCardColumn].splice(_columns[dragedCardColumn].length - numCardsToMove, 1)[0];
										cardToMove.column = destinationCard.column;
										cardToMove.position = _columns[destinationCard.column].length;
										_columns[destinationCard.column].push(cardToMove);
									
										resultCards.push( { column: cardToMove.column, position: cardToMove.position, prevCardShownValues: getIsShownValues(cardToMove.column, cardToMove.position)} );
									}
									numCardsToMove--;
								}
							}
							else
								resultCards.push( { logicCheckOnly: true } );
								
							if (!resultCards.length)
								resultCards = null;
						}
					}
					break;
				}
				case DECK:
				{
					if ((!checkColor(dragedCard.suit, destinationCard.suit) && (dragedCard.isShown || skipCardShownStatus) ) || skipLogic)
					{
						if (isLastCard(destinationCard) && LogicHelper.VALUES_PARSER[destinationCard.value] != 1 && LogicHelper.VALUES_PARSER[dragedCard.value] - LogicHelper.VALUES_PARSER[destinationCard.value] == -1)
						{
							resultCards = new Vector.<Object>();
							
							if (!logicCheckOnly)
							{
								
								cardToMove = dragedCard;
								cardToMove.type = TABLE;
								cardToMove.column = destinationCard.column;
								cardToMove.position = _columns[destinationCard.column].length;
								_columns[destinationCard.column].push(cardToMove);
								
								resultCards.push( { column: cardToMove.column, position: cardToMove.position, prevCardShownValues: getIsShownValues(cardToMove.column, cardToMove.position) } );
							}
							else
								resultCards.push( { logicCheckOnly: true } );
						}
					}
					break;
				}
			}
			
			return resultCards;
		}
		
		private function isLastCard(destinationCard:LogicCard):Boolean 
		{
			var columnLength:int = _columns[destinationCard.column].length;
			
			if (destinationCard.column >= 0 && destinationCard.position == columnLength - 1)
				return true
			else
				return false;
		}
		
		/**
		 * 
		 * @param	column
		 * @param	position
		 * @return point with x as show cards number and y as hidden cards number
		 */
		private function getIsShownValues(column:int, position:int):Point
		{
			var result:Point = new Point();
			for each (var item:LogicCard in _columns[column])
			{
				if (item.position < position)
				{
					if (item.isShown)
						result.x++;
					else
						result.y++;
				}
			}
			return result;
		}
		
		public function updateShownStatus():LogicCard 
		{
			var cardToFlip:LogicCard;
			
			for each (var card:Vector.<LogicCard> in _columns) 
			{
				if (card.length == 1)
				{
					if (!card[0].isShown)
					{
						card[0].isShown = true;
						cardToFlip = card[0];
					}
				}
				else if(card.length > 1)
				{
					if (!card[card.length - 2].isShown && !card[card.length - 1].isShown)
					{
						card[card.length - 1].isShown = true;
						cardToFlip = card[card.length - 1];
					}
				}
			}
			
			return cardToFlip;
		}
		
		/**
		 * Checks color (NOT SUIT) 
		 * 	e.g.
		 *	 spades (♠) == clubs (♣)
		 * 	 hearts (♥) == diamonds (♦), 
		 * @param	firstType
		 * @param	secondType
		 * @return
		 */
		private function checkColor(firstType:String, secondType:String):Boolean
		{
			var result:Boolean = false;
			
			if ((firstType == LogicHelper.HEARTS || firstType == LogicHelper.DIAMONDS) && (secondType == LogicHelper.HEARTS || secondType == LogicHelper.DIAMONDS))
				result = true;
			else if  ((firstType == LogicHelper.SPADES || firstType == LogicHelper.CLUBS) && (secondType == LogicHelper.SPADES || secondType == LogicHelper.CLUBS))
				result = true;
				
			return result;
		}
		
		private function distributeCards():void
		{
			for (var i:int = 0; i < NUM_COLUMNS; i++) 
			{
				_columns[i] = new Vector.<LogicCard>();
				
				for (var j:int = 0; j < i + 1; j++) 
				{
					var logicCard:LogicCard = _deck.shift();
						logicCard.column = NUM_COLUMNS - j - 1;
						logicCard.position = logicCard.column - _columns[j].length;
						logicCard.type = TABLE;
					_columns[j].unshift(logicCard);
				}
				logicCard.isShown = true;				
			}
			_columns.reverse();
		}
		
		private function shuffleCards(replay:Boolean):Vector.<LogicCard>
		{
			var array:Array = LogicHelper.allCards.concat();
			var shuffledArray:Array = [];
			var retVect:Vector.<LogicCard> = new Vector.<LogicCard>();
			
			while (shuffledArray.length != array.length)
			{
				var index:int = Math.floor(Math.random() * array.length);
				
				if (shuffledArray.indexOf(index) == -1)
					shuffledArray.push(index);				
			}
			// NEEDS TO BE COMMENTED OUT
			//predefined set of cards
			//shuffledArray = [11, 40, 27, 37, 47, 51, 35, 33, 15, 5, 50, 8, 45, 19, 16, 43, 49, 24, 42, 6, 21, 7, 13, 38, 30, 34, 29, 0, 9, 36, 22, 31, 25, 41, 32, 48, 14, 28, 1, 23, 17, 20, 4, 26, 18, 10, 44, 46, 39, 12, 3, 2];
			//shuffledArray = [48,26,14,41,32,29,49,38,30,10,46,33,50,35,23,16,7,5,6,19,9,51,25,22,21,4,0,37,39,17,34,2,28,42,12,43,13,1,47,44,31,15,20,11,24,40,18,27,8,3,36,45];
			//shuffledArray = [42,21,24,34,25,41,44,20,3,18,35,27,11,39,33,14,47,40,51,4,10,6,49,46,48,8,30,29,50,32,28,37,12,2,1,23,22,31,5,15,13,38,19,9,17,45,26,36,7,16,43,0];
			//shuffledArray = [27,26,18,43,22,34,47,12,28,8,0,6,45,30,38,31,35,48,42,32,44,13,41,14,36,50,7,11,33,4,25,16,29,51,15,21,9,49,17,46,2,39,40,24,1,37,23,10,3,19,5,20];
			trace(shuffledArray);
			if (replay)
				shuffledArray = LogicHelper.prevShuffledArray;
			
			LogicHelper.prevShuffledArray = shuffledArray;
			
			for each (var item:int in shuffledArray) 
			{
				retVect.push(new LogicCard(array[item]));
			}
			
			return retVect;
		}
		
		public function clean():void 
		{
			_deck = null;
			_columns = null;
			_slots = null;
		}
		
		public function get columns():Vector.<Vector.<LogicCard>> 
		{
			return _columns;
		}
		
		public function get deck():Vector.<LogicCard> 
		{
			return _deck;
		}
		
		public function get availableCards():Boolean 
		{
			var result:Boolean = false;
			
			for each (var item:Vector.<LogicCard> in _columns) 
			{
				if (item.length)
					result = true;
			}
			
			return result;
		}
	}

}