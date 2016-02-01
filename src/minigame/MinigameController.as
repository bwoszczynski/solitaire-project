package minigame 
{
	import base.BackButtonAction;
	import feathers.core.PopUpManager;
	import flash.automation.ActionGenerator;
	import flash.desktop.NativeApplication;
	import flash.system.System;
	import interfaces.IController;
	import interfaces.ISelectable;
	import manager.BackButtonManager;
	import manager.GlobalDispatcher;
	import manager.GlobalJuggler;
	import minigame.card.CardView;
	import minigame.field.EmptyField;
	import minigame.logic.LogicCard;
	import minigame.logic.LogicHelper;
	import minigame.logic.LogicManager;
	import minigame.slot.CardSlot;
	import minigame.undo.UndoAction;
	import player.PlayerModel;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import view.BasePopupView;
	import view.BaseSceneView;
	import view.EndGamePopup;
	import view.GlobalView;
	import view.MinigameMenuPopup;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class MinigameController implements IController
	{
		private var _sceneView:MinigameView;
		private var _logicManager:LogicManager;
		private var _prevSelectedCard:CardView;
		private var _undoActions:Vector.<UndoAction>;
		private var _movesCounter:int;
		private var _deckRotationCounter:int;
		private var _movesLeft:Vector.<Object>;
		private var _hintDelay:IAnimatable;
		
		public function MinigameController() 
		{
			
		}
		
		public function init(data:Object = null):void
		{
			Starling.juggler.add(GlobalJuggler.instance.minigameJuggler);
			GlobalDispatcher.instance.dispatchEventWith(BackButtonManager.PREPARE_BACK_ACTION, false, new BackButtonAction(BackButtonManager.MINIGAME_BACK_ACTION));
			
			_sceneView = new MinigameView();
			_sceneView.addEventListener(MinigameView.CHECK_MOVE, onCheckMove);
			_sceneView.addEventListener(MinigameView.CHECK_SLOT, onCheckSlot);
			_sceneView.addEventListener(MinigameView.CHECK_EMPTY_FIELD, onCheckEmptyField);
			_sceneView.addEventListener(MinigameView.UNDO, onUndo);
			_sceneView.addEventListener(MinigameView.DECK_CLICKED, onClickDeck);
			_sceneView.addEventListener(MinigameView.FORCE_SHOW_DECK_CARD, onForceShowDeckCard);
			_sceneView.addEventListener(MinigameView.START_NEW_GAME, onStartNewGame);
			_sceneView.addEventListener(MinigameView.REPLAY_GAME, onReplayGame);
			_sceneView.addEventListener(MinigameView.CHECK_END_GAME, onCheckEndGame);
			_sceneView.addEventListener(MinigameView.DECK_RESET, onDeckResetGame);
			
			var replay:Boolean = (data && data["replay"] == true) ? true : false;
			_logicManager = new LogicManager(replay);
			_undoActions = new Vector.<UndoAction>();
			
			_movesCounter = 0;
			_deckRotationCounter = 2;
			
			_sceneView.prepareEmptyFields();
			_sceneView.prepareTableCards(_logicManager.columns);
			_sceneView.prepareDeck(_logicManager.deck);
			_sceneView.prepareSlots();
			_sceneView.prepareButtons();
			_sceneView.applyPlayerSettings();
			
			checkEndGame();
			
			GlobalDispatcher.instance.addEventListener(CardView.START_DRAG, startDragCard);
			GlobalDispatcher.instance.addEventListener(CardView.CARD_SELECTED, selectCards);
			GlobalDispatcher.instance.addEventListener(CardView.QUICK_MOVE, checkQuickMove);
			GlobalDispatcher.instance.addEventListener(EmptyField.EMPTY_FIELD_SELECTED, clickEmptyField);
			GlobalDispatcher.instance.addEventListener(CardSlot.CARD_SLOT_SELECTED, clickCardSlot);
			GlobalDispatcher.instance.addEventListener(MinigameView.SHOW_MINIGAME_MENU_POPUP, onShowMinigameMenu);
			
			//NativeApplication.nativeApplication.addEventListener("activate", onActivate);
			NativeApplication.nativeApplication.addEventListener("deactivate", onDeactivate);
			
		}
		
		private function onDeactivate(e:Object):void 
		{
			_sceneView.showMenuPopup();
		}
		
		private function onShowMinigameMenu(e:Event):void 
		{
			_sceneView.showMenuPopup();
		}
	
		private function checkIfCanRestore(card:CardView, yBorder:int):Boolean 
		{
			var columnLength:int = _logicManager.columns[card.logicCard.column].length;
			var shownCounter:int = 0;
			var hiddenCounter:int = 0;
			var nextLogicCard:LogicCard;
			var nextCard:CardView;
			var posY:int;
			
			for (var i:int = 0; i < columnLength; i++) 
			{
				nextLogicCard = _logicManager.columns[card.logicCard.column][i];
				
				nextCard = _sceneView.getCardViewByLogic(nextLogicCard);
				nextLogicCard.forceLayout = false;			
				
				if (i > 0)
				{
					if (_logicManager.columns[card.logicCard.column][i - 1].isShown)
						shownCounter++;
					else
						hiddenCounter++;
				}
				
				posY = MinigameView.Y_OFFSET + shownCounter * MinigameView.SHOWN_CARD_Y_OFFSET + hiddenCounter * (MinigameView.SHOWN_CARD_Y_OFFSET / 2);
			}
			
			if (posY >= yBorder)
				return false;
			else
				return true;
		}
		
		private function startHintDelay():void 
		{
			if (PlayerModel.instance.hint)
				_hintDelay = GlobalJuggler.instance.minigameJuggler.delayCall(showtHint, LogicHelper.HINT_DELAY);
		}
		
		private function showtHint():void 
		{			
			stopHintDelay();
			
			if (_movesLeft)
			{
				//trace("Hint");
				_sceneView.unselectCards();
				
				var card:CardView;
				for each (var item:Object in _movesLeft) 
				{
					ISelectable(item).select(true);
					if (item is CardView)
					{
						card = item as CardView;
						
						if (card.logicCard.column >= 0)
						{
							for each (var nextCard:LogicCard in _logicManager.columns[card.logicCard.column]) 
							{
								if (nextCard.position > card.logicCard.position)
									_sceneView.getCardViewByLogic(nextCard).select(true);
							}
						}
					}
				}
			}
		}
		
		private function stopHintDelay():void
		{
			if (_hintDelay)
				GlobalJuggler.instance.minigameJuggler.remove(_hintDelay);
		}
		
		private function onDeckResetGame(e:Event):void 
		{
			_deckRotationCounter--;
		}
		
		private function onCheckEndGame(e:Event):void 
		{
			checkEndGame();
		}
		
		private function changeMovesCounter(value:int):void
		{
			_movesCounter += value;
			_sceneView.timer.updateMoves(_movesCounter);
		}
		
		private function onReplayGame(e:Event):void 
		{
			var viewParent:DisplayObjectContainer = _sceneView.parent;
			this.cleanMinigame();
			this.init( { replay: true } );
			
			viewParent.addChild(_sceneView);
		}
		
		private function onStartNewGame(e:Event):void 
		{
			var viewParent:DisplayObjectContainer = _sceneView.parent;
			this.cleanMinigame();
			this.init();
			
			viewParent.addChild(_sceneView);
		}
		
		private function onForceShowDeckCard(e:Event):void 
		{
			var undoAction:UndoAction = prepareUndoAction(null, { }, MinigameView.FORCE_SHOW_DECK_CARD);
				undoAction.additionalData = e.data as CardView;
				_undoActions.push(undoAction);
		}
		
		private function onClickDeck(e:Event):void 
		{
			if (e.data && !e.data["byUndo"])
			{
				var shownCards:int = e.data["shownCards"];
				
				if (_sceneView.visibleDeckCards.length || _sceneView.deckCards.length)
				{
					changeMovesCounter(1);
					
					var undoAction:UndoAction = prepareUndoAction(null, { }, MinigameView.DECK_CLICKED);
						undoAction.additionalData = shownCards;
					_undoActions.push(undoAction);
				}
				
			}
			
			_sceneView.unselectCards();
			_prevSelectedCard = null;
		}
		
		private function checkQuickMove(e:Event):void 
		{
			var card:CardView = e.data as CardView;
			var cardColumn:int = card.logicCard.column;
			var resultType:String;
			var result:Boolean;
			
			if (!_sceneView.isLastCard(card))
				return;
			
			var tmpBoolResult:Boolean;
			for each (var slot:CardSlot in _sceneView.slots) 
			{
				result = checkSlot( { dragedCard: card, slot: slot, checkType: card.logicCard.type } );
				if (result)
				{
					card.unselect();
					break;
				}
				/*tmpBoolResult = _logicManager.checkSlot(card.logicCard, slot, LogicManager.TABLE, true);
				if (tmpBoolResult)
				{
					resultType = LogicManager.TABLE;
					
					result = new Vector.<Object>();
					result.push(_sceneView.getCardViewByLogic(columnCard), slot);
				}*/
			}
			
			if (cardColumn >= 0)
				_sceneView.sortCardsInColumn(cardColumn);
			_prevSelectedCard = null;
		}
		
		private function clickCardSlot(e:Event):void 
		{
			var cardSlot:CardSlot = e.data is CardSlot ? e.data as CardSlot : _sceneView.slots[e.data];
			var result:Boolean;
			
			_sceneView.unselectCards();
			
			if (_prevSelectedCard)
			{				
				result = checkSlot({dragedCard: _prevSelectedCard, slot: cardSlot, checkType: _prevSelectedCard.logicCard.type});
			}
			
			_sceneView.sortCardsInColumn(cardSlot.num);
			_prevSelectedCard = null;
		}
		
		private function clickEmptyField(e:Event):void 
		{
			var emptyField:EmptyField = e.data as EmptyField;
			var result:Boolean;
			
			_sceneView.unselectCards();
			
			if (_prevSelectedCard)
			{				
				result = checkEemptyField({dragedCard: _prevSelectedCard, field: emptyField, checkType: _prevSelectedCard.logicCard.type});
			}
			
			_sceneView.sortCardsInColumn(emptyField.num);	
			_prevSelectedCard = null;
		}
		
		private function selectCards(e:Event):void 
		{
			stopHintDelay();
			startHintDelay();
			
			var selectedCard:CardView = e.data as CardView;
			var result:Boolean;
			
			_sceneView.unselectCards(selectedCard);
			
			if (selectedCard.logicCard.type == LogicManager.DECK || selectedCard.logicCard.currentSlotNum >= 0)
			{
				if (selectedCard.logicCard.currentSlotNum >= 0 && _prevSelectedCard)
				{
					result = checkSlot( {dragedCard: _prevSelectedCard, slot: _sceneView.slots[selectedCard.logicCard.currentSlotNum], checkType: _prevSelectedCard.logicCard.type } );
					
					if (result)
					{
						_sceneView.sortCardsInColumn(_prevSelectedCard.logicCard.column);
						_sceneView.unselectCards();
						_prevSelectedCard = null;
						return;
					}					
				}
				selectedCard.select();
				
				_prevSelectedCard = selectedCard;
				return;
			}
			var cardsVector:Vector.<LogicCard> = new Vector.<LogicCard>();
			
			for each (var item:LogicCard in _logicManager.columns[selectedCard.logicCard.column])
			{
				if (selectedCard.logicCard.column == item.column && selectedCard.logicCard.position < item.position && item.isShown)
				{
					cardsVector.push(item);
				}
			}
			
			_sceneView.selectCards(cardsVector);
			
			if (_prevSelectedCard)
			{
				result = checkMove({dragedCard: _prevSelectedCard, destinationCard: selectedCard, checkType: _prevSelectedCard.logicCard.type});
			}
			
			if (!result)
				_prevSelectedCard = selectedCard;
			else
			{
				_sceneView.sortCardsInColumn(selectedCard.logicCard.column);
				_sceneView.unselectCards();
				_prevSelectedCard = null;
			}
		}
		
		private function onUndo(e:Event):void 
		{
			var destinationCard:CardView;
			var cardView:CardView;
			var cardSlot:CardSlot;
			var emptyField:EmptyField;
			var checkType:String;
			
			if (!_undoActions.length)
			{
				UndoAction.ACTIONS_COUNTER = 0;
				return;
			}
				
			var undoAction:UndoAction = _undoActions.pop();
			
			if (undoAction)
			{
				_sceneView.unselectCards();
				_deckRotationCounter = 2;
				checkEndGame();
				
				//trace("UNDO ACTION ", UndoAction.ACTIONS_COUNTER, undoAction.checkType);
				UndoAction.ACTIONS_COUNTER--;
				if (undoAction.destination is CardView && undoAction.checkType != LogicManager.DECK)
				{
					checkType = LogicManager.TABLE;
					
					destinationCard = CardView(undoAction.destination);
					if (undoAction.flipDestinationCard)
					{
						destinationCard.logicCard.isShown = false;
						destinationCard.flip(false);
					}
					
					if (undoAction.checkType == MinigameView.UNDO_SLOT_CARD)
					{
						cardSlot = undoAction.additionalData as CardSlot;
						cardSlot.removeLastLogicCard();
						
						cardView = undoAction.dragedCard;
						//cardView.logicCard.currentSlotNum = -1;
							//cardView.removeFromParent();
							//cardView.x = cardSlot.x + 4;
							//cardView.y = cardSlot.y + 7;
							//cardView.logicCard.isShown = true;
							//cardView.touchable = true;
							//_sceneView.addChild(cardView);
							//NEW CHANGE
							//_sceneView.addToAllCards(cardView);
							
							//_logicManager.columns[cardView.logicCard.column].push(cardView.logicCard);
							
							//_logicManager.columns[destinationCard.logicCard.column].push(cardView.logicCard);
					}
					else if (undoAction.checkType == MinigameView.UNDO_EMPTY_FIELD)
					{
						emptyField = undoAction.additionalData as EmptyField;
						_sceneView.updateEmptyFieldStatus(emptyField.num, true);
					}
					
					checkMove( { dragedCard: undoAction.dragedCard, destinationCard: undoAction.destination, checkType: checkType }, true );
					_sceneView.sortCardsInColumn(destinationCard.logicCard.column);
					_sceneView.unselectCards();
					changeMovesCounter(-1);
				}
				else if (undoAction.destination is EmptyField)
				{
					checkType = LogicManager.TABLE;
					
					emptyField = EmptyField(undoAction.destination);
					_sceneView.updateEmptyFieldStatus(emptyField.num, false);
					
					if (undoAction.checkType == MinigameView.UNDO_SLOT_CARD)
					{
						cardSlot = undoAction.additionalData as CardSlot;
						cardSlot.removeLastLogicCard();
						
						cardView = undoAction.dragedCard;
						//cardView.logicCard.currentSlotNum = -1;
							//cardView.removeFromParent();
							//cardView.x = cardSlot.x + 4;
							//cardView.y = cardSlot.y + 7;
							//cardView.logicCard.isShown = true;
							//cardView.touchable = true;
							//_sceneView.addChild(cardView);
							//NEW CHANGE
							//_sceneView.addToAllCards(cardView);
							//_logicManager.columns[cardView.logicCard.column].push(cardView.logicCard);
					}
					else if (undoAction.checkType == MinigameView.UNDO_EMPTY_FIELD)
					{
						emptyField = undoAction.additionalData as EmptyField;
						_sceneView.updateEmptyFieldStatus(emptyField.num, true);
					}
					
					checkEemptyField( { dragedCard: undoAction.dragedCard, field: undoAction.destination, checkType: checkType }, true );
					//_sceneView.sortCardsInColumn(destinationCard.logicCard.column);
					_sceneView.unselectCards();
					changeMovesCounter(-1);
				}
				else if (undoAction.dragedCard && undoAction.dragedCard.logicCard && undoAction.checkType != LogicManager.DECK && undoAction.dragedCard.logicCard.currentSlotNum >= 0)
				{
					cardView = undoAction.dragedCard;
					if (undoAction.additionalData is CardSlot)
					{
						cardSlot = undoAction.additionalData as CardSlot;
						cardSlot.removeLastLogicCard();
					}
					
					
					checkSlot({ dragedCard: cardView, slot: undoAction.destination, checkType: cardView.logicCard.type }, true);
					
					_sceneView.unselectCards();
					changeMovesCounter(-1);
				}
				else if (!undoAction.checkType && undoAction.destination is CardSlot)
				{
					cardView = undoAction.dragedCard;
					
					if (undoAction.additionalData is EmptyField)
					{
						emptyField = undoAction.additionalData as EmptyField;
						_sceneView.updateEmptyFieldStatus(emptyField.num, true);
					}
					
					checkSlot({ dragedCard: cardView, slot: undoAction.destination, checkType: cardView.logicCard.type }, true);
					
					_sceneView.unselectCards();
					changeMovesCounter(-1);
				}				
				else if (undoAction.checkType == LogicManager.DECK)
				{
					cardView = undoAction.dragedCard;
					destinationCard = CardView(undoAction.destination);
					
					if (undoAction.additionalData is CardSlot)
					{
						cardSlot = undoAction.additionalData as CardSlot;
						cardSlot.removeLastLogicCard();
						cardView.logicCard.currentSlotNum = -1;
						//cardView = undoAction.dragedCard;
							//cardView.removeFromParent();
							//cardView.x = cardSlot.x + 4;
							//cardView.y = cardSlot.y + 7;
							//cardView.logicCard.isShown = true;
							//cardView.touchable = true;
							//_sceneView.addChild(cardView);
							//_sceneView.addToAllCards(cardView);
							//_logicManager.columns[cardView.logicCard.column].push(cardView.logicCard);
					}
					else if (undoAction.additionalData is EmptyField)
					{
						emptyField = undoAction.additionalData as EmptyField;
						_sceneView.updateEmptyFieldStatus(emptyField.num, true);
					}
					if (destinationCard && destinationCard.logicCard.column >= 0)
					{
						var index:int = _logicManager.columns[destinationCard.logicCard.column].indexOf(cardView.logicCard);
						if ( index != -1)
						{
							_logicManager.columns[destinationCard.logicCard.column].splice(index, 1);
						}
					}
					_logicManager.updateShownStatus();
					_sceneView.putCardBackInDeck(cardView);
					_sceneView.unselectCards();
					changeMovesCounter(-1);
				}
				else if (undoAction.checkType == MinigameView.DECK_CLICKED)
				{
					var shownCards:int = undoAction.additionalData as int;
					_sceneView.undoClickDeck(shownCards);
					changeMovesCounter(-1);
				}
				else if (undoAction.checkType == MinigameView.FORCE_SHOW_DECK_CARD)
				{
					cardView = undoAction.additionalData as CardView;
					_sceneView.forceHideCardInDeck(cardView);
					
					//on complete
					onUndo(null);
				}
				
				stopHintDelay();
				startHintDelay();
			}
				
			
		}
		
		private function startDragCard(e:Event):void 
		{
			stopHintDelay();
			
			_sceneView.unselectCards();
			
			var touchX:Number = e.data["touchX"];
			var touchY:Number = e.data["touchY"];
			var movingCard:LogicCard = e.data["movingCard"];
			
			var cardsVector:Vector.<LogicCard> = new Vector.<LogicCard>();
			if (movingCard.type == LogicManager.DECK || movingCard.column < 0 || movingCard.currentSlotNum >= 0)
				return;
			
			for each (var item:LogicCard in _logicManager.columns[movingCard.column])
			{
				if (movingCard.column == item.column && movingCard.position < item.position && item.isShown)
				{
					cardsVector.push(item);
				}
			}
			
			_sceneView.setMovingCards(cardsVector, touchX, touchY);
		}
		
		private function onCheckEmptyField(e:Event):void 
		{
			checkEemptyField(e.data);			
		}
		
		private function checkEemptyField(data:Object, byUndo:Boolean = false):Boolean 
		{
			var dragedCard:CardView = data["dragedCard"];
			var field:EmptyField = data["field"];
			var checkType:String = data["checkType"];
			var dragedCardType:String = dragedCard.logicCard.type;
			var fieldNum:int = field.num;
			var result:Vector.<Object>;
			var numCol:int = LogicManager.NUM_COLUMNS;
			var undoAction:UndoAction;
			var slotNum:int = -1;
			
			if (!byUndo)
				undoAction = prepareUndoAction(dragedCard, field, MinigameView.UNDO_EMPTY_FIELD);
			
			slotNum = dragedCard.logicCard.currentSlotNum;
			
			result = _logicManager.checkEmptyField(dragedCard.logicCard, fieldNum, checkType, byUndo);
			
			if (result)
			{				
				if (undoAction)
				{
					changeMovesCounter(1);
					_undoActions.push(undoAction);
				}
					
				//put down moving cards
				var cardPosition:int = (GlobalView.WIDTH - (numCol * CardView.CARD_WIDTH + numCol * MinigameView.SHOWN_CARD_OFFSET  - MinigameView.SHOWN_CARD_OFFSET)) / 2;
				cardPosition += fieldNum * CardView.CARD_WIDTH + fieldNum * MinigameView.SHOWN_CARD_OFFSET;
				
				if (dragedCardType == LogicManager.DECK)
					_sceneView.removeCardFromDeck(dragedCard);
				
				if (slotNum >= 0 && dragedCard.logicCard.currentSlotNum < 0)
					_sceneView.slots[slotNum].removeLastLogicCard(dragedCard.logicCard);
					
				_sceneView.placeDragedCards(result, cardPosition);
				
				var cardToFlip:LogicCard = _logicManager.updateShownStatus();
				_sceneView.flipCard(cardToFlip);
				updateEmptyFieldsStatus();
				
				checkEndGame();				
			}
			else
			{
				_sceneView.moveCard(dragedCard, null);
				_sceneView.placeDragedCards(null);
			}
			
			return result ? true : false;
		}
		
		private function onCheckSlot(e:Event):void 
		{
			checkSlot(e.data)
		}
		
		private function checkSlot(data:Object, byUndo:Boolean = false):Boolean 
		{
			var dragedCard:CardView = data["dragedCard"]; 
			var slot:CardSlot = data["slot"];
			var checkType:String = data["checkType"];
			var result:Boolean;
			var undoAction:UndoAction;
			
			if (!byUndo)
				undoAction = prepareUndoAction(dragedCard, slot, MinigameView.UNDO_SLOT_CARD);
				
			result = _logicManager.checkSlot(dragedCard.logicCard, slot, checkType);
			
			if (result)
			{
				if (undoAction)
				{
					changeMovesCounter(1);
					_undoActions.push(undoAction);
				}
				
				if (dragedCard.logicCard.currentSlotNum >= 0)
					_sceneView.slots[dragedCard.logicCard.currentSlotNum].removeLastLogicCard();
					
				
				slot.putCardInSlot(dragedCard);
				
				if (dragedCard.logicCard.column == -1)
					_sceneView.removeCardFromDeck(dragedCard);
				//else
					//_sceneView.removeCardFromAllCards(dragedCard);
					
				var cardToFlip:LogicCard = _logicManager.updateShownStatus();
				_sceneView.flipCard(cardToFlip);
				updateEmptyFieldsStatus();
				
				checkEndGame();				
				
			}
			else
			{
				_sceneView.moveCard(dragedCard, null);
				_sceneView.placeDragedCards(null);
				
			}
			
			return result;
		}
		
		private function onCheckMove(e:Event):void 
		{
			checkMove(e.data);
		}
		
		private function checkMove(data:Object, byUndo:Boolean = false):Boolean 
		{
			var dragedCard:CardView = data["dragedCard"]; 
			var destinationCard:CardView = data["destinationCard"];
			var checkType:String = data["checkType"];
			var result:Vector.<Object>;
			var undoAction:UndoAction;
			var slotNum:int = -1;
			//trace("DRAGGED: ", dragedCard.logicCard.value, dragedCard.logicCard.suit, dragedCard.logicCard.column, dragedCard.logicCard.position);
			//trace("FROM LOGIC: ", _logicManager.columns[dragedCard.logicCard.column][dragedCard.logicCard.position].value, _logicManager.columns[dragedCard.logicCard.column][dragedCard.logicCard.position].suit);
			if (!byUndo)
				undoAction = prepareUndoAction(dragedCard, destinationCard, checkType);
			slotNum = dragedCard.logicCard.currentSlotNum;
			
			result = _logicManager.checkMove(dragedCard.logicCard, destinationCard.logicCard, checkType, byUndo);
			
			if (result)
			{
				if (undoAction)
				{
					changeMovesCounter(1);
					_undoActions.push(undoAction);
				}
				
				if (checkType == LogicManager.DECK)
				{
					_sceneView.removeCardFromDeck(dragedCard);
				}
				if (slotNum >= 0 && dragedCard.logicCard.currentSlotNum < 0)
					_sceneView.slots[slotNum].removeLastLogicCard(dragedCard.logicCard);
					
				_sceneView.placeDragedCards(result, destinationCard.positionX);
				
				var cardToFlip:LogicCard = _logicManager.updateShownStatus();
				_sceneView.flipCard(cardToFlip);
				updateEmptyFieldsStatus();
				
				checkEndGame();
			}
			else
			{
				_sceneView.moveCard(dragedCard, null);
				_sceneView.placeDragedCards(null);
				checkEndGame();
			}
			
			return result ? true : false;
		}
		
		private function checkEndGame():void 
		{
			_movesLeft = checkAvailableMove();
			
			if (_movesLeft)
				_deckRotationCounter = 2;
			
			if (_movesLeft || _deckRotationCounter && _logicManager.availableCards)
			{
				if (!_movesLeft && _deckRotationCounter && _logicManager.availableCards)
				{
					_movesLeft = new Vector.<Object>();
					_movesLeft.push( _sceneView.deck);
					
					trace("only move: deck click");
				}
				
				stopHintDelay();
				startHintDelay();
				//it's not yet the end
				trace("moves left");
			}
			else
			{
				var status:String = LogicHelper.WON;
				
				for each (var column:Vector.<LogicCard> in _logicManager.columns) 
				{
					if (column.length)
						status = LogicHelper.LOST;
				}
				
				trace("game ended: ", status);
				GlobalJuggler.instance.minigameJuggler.delayCall(showEndPopup, 0.3, status);
				
				if (status == LogicHelper.WON)
				{
					LogicHelper.prevShuffledArray = null;
					PlayerModel.instance.saveGameWonData(_movesCounter, _sceneView.timer.currentGameTime);
				}
			}
			
		}
		
		private function showEndPopup(status:String):void 
		{
			var popup:EndGamePopup;
			_sceneView.pause();		
			
			if (status == LogicHelper.WON)
			{
				//game won
				popup = PopUpManager.addPopUp(new EndGamePopup({won: true, moves: _movesCounter, time: _sceneView.timer.currentGameTime})) as EndGamePopup;
				
			}
			else
			{
				//game lost
				popup = PopUpManager.addPopUp(new EndGamePopup({won: false})) as EndGamePopup;
				
			}
				
			popup.addEventListener(BasePopupView.POPUP_HIDDEN, onHideMenuHandler);
		}
		
		private function onHideMenuHandler(e:Event):void 
		{
			_sceneView.resume();
			
			var data:Object = e.data;
			var type:String = e.data["type"];
			var won:Boolean = e.data["won"];
			
			switch (type)
			{
				case BasePopupView.CANCEL:
				{
					_deckRotationCounter = 2;
					break;
				}
				case MinigameMenuPopup.MAIN_MENU:
				{
					if (!won)
						PlayerModel.instance.saveGameLostData();
					GlobalDispatcher.instance.dispatchEventWith(GlobalDispatcher.INIT_MENU);
					break;
				}
				case MinigameMenuPopup.REPLAY:
				{	
					if (!won)
						PlayerModel.instance.saveGameLostData();
					onReplayGame(null);
					break;
				}
				case MinigameMenuPopup.NEW_GAME:
				{
					if (!won)
						PlayerModel.instance.saveGameLostData();
					onStartNewGame(null);
					break;
				}
			}
		}
		
		private function checkAvailableMove():Vector.<Object> 
		{
			var tmpResult:Vector.<Object>;
			var tmpBoolResult:Boolean;			
			var result:Vector.<Object> = null;
			var boolResult:Boolean;
			var resultType:String;
			
			//check visible deck card
			if (_sceneView.visibleDeckCards.length)
			{	
				var deckCard:LogicCard = _sceneView.visibleDeckCards[_sceneView.visibleDeckCards.length - 1].logicCard;
				for each (var column:Vector.<LogicCard> in _logicManager.columns) 
				{
					if(column.length)
					{
						tmpResult = _logicManager.checkMove(deckCard, column[column.length - 1], LogicManager.DECK, false, true);
						if (tmpResult)
						{
							resultType = LogicManager.DECK;
							
							result = new Vector.<Object>();
							result.push(_sceneView.visibleDeckCards[_sceneView.visibleDeckCards.length - 1], _sceneView.getCardViewByLogic(column[column.length - 1]));
						}
					}
				}
				
				for each (var slot:CardSlot in _sceneView.slots) 
				{
					tmpBoolResult = _logicManager.checkSlot(deckCard, slot, LogicManager.DECK, true);
					if (tmpBoolResult)
					{
						resultType = LogicManager.DECK;
						boolResult = tmpBoolResult;
						
						result = new Vector.<Object>();
						result.push( _sceneView.visibleDeckCards[_sceneView.visibleDeckCards.length - 1], slot);
					}
				}
				
				for each (var field:EmptyField in _sceneView.emptyFields) 
				{
					tmpResult = _logicManager.checkEmptyField(deckCard, field.num, LogicManager.DECK, false, true);
					if (tmpResult)
					{
						resultType = LogicManager.DECK;
						result = tmpResult;
						
						result = new Vector.<Object>();
						result.push(_sceneView.visibleDeckCards[_sceneView.visibleDeckCards.length - 1], field);
					}
				}
			}
			//check table cards
			for each (column in _logicManager.columns) 
			{
				if(column.length)
				{
					for each (var columnCard:LogicCard in column) 
					{
						for each (var columnToCheck:Vector.<LogicCard> in _logicManager.columns) 
						{
							if (!columnToCheck.length)
								continue;
							tmpResult = _logicManager.checkMove(columnCard, columnToCheck[columnToCheck.length - 1], LogicManager.TABLE, false, true);
							if (tmpResult)
							{
								if (columnCard.position > 0 && column[columnCard.position - 1].isShown && column[columnCard.position - 1].value == columnToCheck[columnToCheck.length - 1].value)
								{
									//check parent card to prevent moving card from one to another and not making any progres
									for each (slot in _sceneView.slots) 
									{
										var additionalBoolResult:Boolean = _logicManager.checkSlot(column[columnCard.position - 1], slot, LogicManager.TABLE, true);
										if (additionalBoolResult)
										{
											resultType = LogicManager.TABLE;
											
											result = new Vector.<Object>();
											//result.push( _sceneView.getCardViewByLogic(column[columnCard.position - 1]), slot);
										
											result.push( _sceneView.getCardViewByLogic(columnCard), _sceneView.getCardViewByLogic(columnToCheck[columnToCheck.length - 1]));
								
										}
										else
										{
											//trace("endless move");
										}
									}
								}
								else
								{
									resultType = LogicManager.TABLE;
									
									result = new Vector.<Object>();
									result.push( _sceneView.getCardViewByLogic(columnCard), _sceneView.getCardViewByLogic(columnToCheck[columnToCheck.length - 1]));
								}
							}
						}
						
						for each (field in _sceneView.emptyFields) 
						{
							tmpResult = _logicManager.checkEmptyField(columnCard, field.num, LogicManager.TABLE, false, true);
							if (tmpResult && columnCard.position != 0)
							{
								resultType = LogicManager.TABLE;
								
								result = new Vector.<Object>();
								result.push(_sceneView.getCardViewByLogic(columnCard), field);
							}
						}
					}
					
					for each (slot in _sceneView.slots) 
					{
						tmpBoolResult = _logicManager.checkSlot( column[column.length - 1], slot, LogicManager.TABLE, true);
						if (tmpBoolResult)
						{
							resultType = LogicManager.TABLE;
							
							result = new Vector.<Object>();
							result.push(_sceneView.getCardViewByLogic(columnCard), slot);
						}
					}
					
				}
				
			}
			
			return result;
		}
		
		private function prepareUndoAction(dragedCard:CardView, destination:Object, checkType:String):UndoAction 
		{
			var undoAction:UndoAction;
			var logicCard:LogicCard;
			var destinationCard:CardView;
			var emptyField:EmptyField;
			
			
			if(dragedCard && dragedCard.logicCard.currentSlotNum >= 0)
			{
				undoAction = new UndoAction();
				undoAction.dragedCard = dragedCard;
				undoAction.destination = _sceneView.slots[dragedCard.logicCard.currentSlotNum];
				if (checkType == MinigameView.UNDO_SLOT_CARD)
					undoAction.additionalData = destination;
				else if (checkType == MinigameView.UNDO_EMPTY_FIELD)
					undoAction.additionalData = destination
			}
			else if (dragedCard && dragedCard.logicCard.column >= 0 && dragedCard.logicCard.position > 0 && checkType != LogicManager.DECK) 
			{				
						
				//move card or cards to antoher card on the table
				
				logicCard = _logicManager.columns[dragedCard.logicCard.column][dragedCard.logicCard.position - 1];
				destinationCard = _sceneView.getCardViewByLogic(logicCard);				
				
				undoAction = new UndoAction();
				undoAction.dragedCard = dragedCard;
				undoAction.destination = destinationCard;
				undoAction.flipDestinationCard = destinationCard ? !destinationCard.logicCard.isShown : false;
				undoAction.checkType = checkType;
				if (checkType == MinigameView.UNDO_SLOT_CARD)
					undoAction.additionalData = destination as CardSlot;
				else if (checkType == MinigameView.UNDO_EMPTY_FIELD)
					undoAction.additionalData = destination as EmptyField;
			}
			else if (dragedCard && dragedCard.logicCard.column >= 0 && dragedCard.logicCard.position == 0 && checkType != LogicManager.DECK) // card from empty slot
			{
				emptyField = _sceneView.getEmptyFieldByNum(dragedCard.logicCard.column);
				
				undoAction = new UndoAction();
				undoAction.dragedCard = dragedCard;
				undoAction.destination = emptyField;
				undoAction.checkType = checkType;
				if (checkType == MinigameView.UNDO_SLOT_CARD)
					undoAction.additionalData = destination as CardSlot;
				else if (checkType == MinigameView.UNDO_EMPTY_FIELD)
					undoAction.additionalData = destination as EmptyField;
			}
			else if (dragedCard && dragedCard.logicCard.column == -1 && dragedCard.logicCard.position == -1)
			{
				undoAction = new UndoAction();
				undoAction.dragedCard = dragedCard;
				undoAction.destination = destination is CardView ? destination : dragedCard;
				undoAction.checkType = LogicManager.DECK;
				if (checkType == MinigameView.UNDO_SLOT_CARD)
					undoAction.additionalData = destination as CardSlot;
				else if (checkType == MinigameView.UNDO_EMPTY_FIELD)
					undoAction.additionalData = destination as EmptyField;
			}
			else if (checkType == MinigameView.DECK_CLICKED)
			{
				undoAction = new UndoAction();
				undoAction.checkType = checkType;
			}
			else if (checkType == MinigameView.FORCE_SHOW_DECK_CARD)
			{
				undoAction = new UndoAction();
				undoAction.checkType = checkType;
			}
			return undoAction;
		}
		
		private function updateEmptyFieldsStatus():void 
		{
			for (var i:int = 0; i < LogicManager.NUM_COLUMNS; i++) 
			{
				if (!_logicManager.columns[i].length)
					_sceneView.updateEmptyFieldStatus(i, true);
				else
					_sceneView.updateEmptyFieldStatus(i, false);
			}
		}
		
		public function clean():void 
		{			
			cleanMinigame();
			LogicHelper.prevShuffledArray = null;
		}
		
		private function cleanMinigame():void 
		{
			NativeApplication.nativeApplication.removeEventListener("deactivate", onDeactivate);
			
			GlobalDispatcher.instance.removeEventListener(CardView.START_DRAG, startDragCard);
			GlobalDispatcher.instance.removeEventListener(CardView.CARD_SELECTED, selectCards);
			GlobalDispatcher.instance.removeEventListener(EmptyField.EMPTY_FIELD_SELECTED, clickEmptyField);
			GlobalDispatcher.instance.removeEventListener(CardSlot.CARD_SLOT_SELECTED, clickCardSlot);
			GlobalDispatcher.instance.removeEventListener(CardView.QUICK_MOVE, checkQuickMove);
			GlobalDispatcher.instance.removeEventListener(MinigameView.SHOW_MINIGAME_MENU_POPUP, onShowMinigameMenu);
			
			_sceneView.removeEventListener(MinigameView.CHECK_MOVE, onCheckMove);
			_sceneView.removeEventListener(MinigameView.CHECK_SLOT, onCheckSlot);
			_sceneView.removeEventListener(MinigameView.CHECK_EMPTY_FIELD, onCheckEmptyField);
			_sceneView.removeEventListener(MinigameView.DECK_CLICKED, onClickDeck);
			_sceneView.removeEventListener(MinigameView.FORCE_SHOW_DECK_CARD, onForceShowDeckCard);
			_sceneView.removeEventListener(MinigameView.START_NEW_GAME, onStartNewGame);
			_sceneView.removeEventListener(MinigameView.REPLAY_GAME, onReplayGame);
			_sceneView.removeEventListener(MinigameView.CHECK_END_GAME, onCheckEndGame);
			_sceneView.removeEventListener(MinigameView.DECK_RESET, onDeckResetGame);
			_sceneView.removeFromParent(true);	
		
			_movesLeft = null;
			
			stopHintDelay();
			
			_hintDelay = null;
			
			GlobalJuggler.instance.minigameJuggler.purge();
			Starling.juggler.remove(GlobalJuggler.instance.minigameJuggler);
			
			_logicManager.clean();
			_logicManager = null;

			_sceneView = null;
			System.gc();
		}
		
		public function get sceneView():BaseSceneView 
		{
			return _sceneView;
		}
		
	}

}