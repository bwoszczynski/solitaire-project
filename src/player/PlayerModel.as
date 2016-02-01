package player 
{
	import flash.net.SharedObject;
	import minigame.logic.LogicHelper;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class PlayerModel 
	{
		static public const PLAYER_DATA:String = "playerData";
		static public const GAME_TYPE:String = "gameType";
		static public const MOVES_GAME:String = "movesGame";
		static public const WON:String = "won";
		static public const MOVES_COUNTER:String = "movesCounter";
		static public const TIME_GAME:String = "timeGame";
		static public const BEST_TIME:String = "bestTime";
		static public const LOST:String = "lost";
		static public const DECK_SHOWN_CARDS:String = "deckShownCards";
		static public const MUTE:String = "mute";
		static public const HINT:String = "hint";
		
		private static var _instance:PlayerModel;
		
		private var _gameType:String = TIME_GAME;
		private var _playerData:SharedObject;
		
		public function PlayerModel()
		{
			_playerData = SharedObject.getLocal(PLAYER_DATA);
		}
		
		public function loadData():void
		{	
			//clearData();
			if (_playerData.data[GAME_TYPE])
			{
				_gameType = _playerData.data[GAME_TYPE];
				LogicHelper.DECK_SHOWN_CARDS = int(_playerData.data[DECK_SHOWN_CARDS]) == 0 ? LogicHelper.DECK_SHOWN_CARDS : int(_playerData.data[DECK_SHOWN_CARDS]);
			}
			else
			{
				saveDataByName(GAME_TYPE, _gameType, false );
				saveDataByName(MOVES_GAME, {}, false );
				saveDataByName(TIME_GAME, {}, false );
				saveDataByName(DECK_SHOWN_CARDS, LogicHelper.DECK_SHOWN_CARDS, false);
				saveDataByName(MUTE, false, false);
				saveDataByName(HINT, true, true);
			}
		}
		
		public function clearData():void
		{
			_playerData.clear();
			_playerData.flush();			
		}
		
		public function saveDataByName(dataName:String, value:Object, flush:Boolean = true):void
		{
			_playerData.data[dataName] = value;
			if (flush)
				_playerData.flush();
		}
		
		public function saveGameWonData(movesCounter:int, currentGameTime:Number):void 
		{
			var type:String = _gameType;
			
				if (_playerData.data[type][WON])
					_playerData.data[type][WON]++;
				else
					_playerData.data[type][WON] = 1;
			
			if (_gameType == MOVES_GAME)
			{
				if (_playerData.data[MOVES_GAME][MOVES_COUNTER])
				{
					var prevMaxMoves:int = _playerData.data[MOVES_GAME][MOVES_COUNTER];
					if (prevMaxMoves > movesCounter)
						_playerData.data[MOVES_GAME][MOVES_COUNTER] = movesCounter;
				}
				else
					_playerData.data[MOVES_GAME][MOVES_COUNTER] = movesCounter;				
			}
			else
			{
				if (_playerData.data[TIME_GAME][BEST_TIME])
				{
					var prevBestTime:Number = _playerData.data[TIME_GAME][BEST_TIME];
					if (prevBestTime < currentGameTime)
						_playerData.data[TIME_GAME][BEST_TIME] = currentGameTime;
				}
				else
					_playerData.data[TIME_GAME][BEST_TIME] = currentGameTime;	
			}
			
			_playerData.flush();
		}
		
		public function saveGameLostData():void 
		{
			var type:String = _gameType;
			
			if (_playerData.data[type][LOST])
				_playerData.data[type][LOST]++;
			else
				_playerData.data[type][LOST] = 1;
				
			_playerData.flush();
		}
		
		public function gamesNum(gameType:String, resultType:String):int 
		{
			return int(_playerData.data[gameType][resultType]);
		}
		
		public function getRatioByType(gameType:String):Number 
		{
			var ratio:Number = int(_playerData.data[gameType][WON]) / (int(gamesNum(gameType, WON)) + int(gamesNum(gameType, LOST)));
				ratio = isNaN(ratio) ? 0 : ratio;
				
			return 100 * ratio;
		}
		
		public function clearStatisticsData():void 
		{
			saveDataByName(MOVES_GAME, {}, false );
			saveDataByName(TIME_GAME, {}, true );
		}
		
		public function get hint():Boolean 
		{
			return Boolean(_playerData.data[HINT]);
		}
		
		public function get mute():Boolean 
		{
			return Boolean(_playerData.data[MUTE]);
		}
		
		public function get smallestMovesNum():int 
		{
			return int(_playerData.data[MOVES_GAME][MOVES_COUNTER]);
		}
		
		public function get allGamesNum():int
		{
			return int(_playerData.data[MOVES_GAME][WON]) + int(_playerData.data[MOVES_GAME][LOST]) + int(_playerData.data[TIME_GAME][WON]) + int(_playerData.data[TIME_GAME][LOST]);
		}
		
		public function get allWonGamesNum():int
		{
			return int(_playerData.data[MOVES_GAME][WON]) + int(_playerData.data[TIME_GAME][WON]);
		}
		
		public function get allLostGamesNum():int
		{
			return int(_playerData.data[MOVES_GAME][LOST]) + int(_playerData.data[TIME_GAME][LOST]);
		}
		
		public function get allRatio():Number
		{
			var ratio:Number = 100 * (allWonGamesNum / allGamesNum);
			ratio = isNaN(ratio) ? 0 : ratio;
			
			return ratio;
		}
		
		public function get bestTime():Number
		{
			return isNaN(Number(_playerData.data[TIME_GAME][BEST_TIME])) ? 0 : Number(_playerData.data[TIME_GAME][BEST_TIME]);
		}
		
		static public function get instance():PlayerModel 
		{
			if (!_instance)
				_instance = new PlayerModel();
				
			return _instance;
		}
		
		public function get gameType():String 
		{
			return _gameType;
		}
		
		public function set gameType(value:String):void 
		{
			_gameType = value;
		}
	}

}