package minigame 
{
	import base.BackButtonAction;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.core.PopUpManager;
	import feathers.layout.HorizontalLayout;
	import feathers.themes.SteelSolitaireTheme;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import manager.BackButtonManager;
	import manager.GlobalAssetManager;
	import manager.GlobalDispatcher;
	import manager.GlobalJuggler;
	import minigame.card.CardView;
	import minigame.deck.Deck;
	import minigame.field.EmptyField;
	import minigame.logic.LogicCard;
	import minigame.logic.LogicHelper;
	import minigame.logic.LogicManager;
	import minigame.slot.CardSlot;
	import minigame.ui.MinigameTimer;
	import player.PlayerModel;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import treefortress.sound.SoundAS;
	import view.BasePopupView;
	import view.BaseSceneView;
	import view.GlobalView;
	import view.MinigameMenuPopup;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class MinigameView extends BaseSceneView
	{
		static public const Y_OFFSET:int = CardView.CARD_HEIGHT + 60;		
		static public const CHECK_MOVE:String = "checkMove";
		static public const TABLE:String = "table";
		static public const SLOT:String = "slot";
		static public const CHECK_SLOT:String = "checkSlot";
		static public const EMPTY_FIELD:String = "emptyField";
		static public const CHECK_EMPTY_FIELD:String = "checkEmptyField";
		static public const UNDO:String = "undo";
		static public const DECK_CLICKED:String = "deckClicked";
		static public const UNDO_SLOT_CARD:String = "undoSlotCard";
		static public const UNDO_EMPTY_FIELD:String = "undoEmptyField";
		static public const FORCE_SHOW_DECK_CARD:String = "forceShowDeckCard";
		static public const START_NEW_GAME:String = "startNewGame";
		static public const REPLAY_GAME:String = "replayGame";
		static public const CHECK_END_GAME:String = "checkEndGame";
		static public const DECK_RESET:String = "deckReset";
		static public const LAYOUT_RESTORE_Y_BORDER:int = 540;
		static public const LAYOUT_Y_BORDER:int = 570;
		static public const LAYOUT_RESTORE_LAST_Y_BORDER:int = 590;
		static public const LAYOUT_LAST_Y_BORDER:int = 630;
		static public const SHOW_MINIGAME_MENU_POPUP:String = "showMinigameMenuPopup";
		static public var SHOWN_CARD_OFFSET:int = 0;
		static public var SHOWN_CARD_Y_OFFSET:int = 0;
		static public var SHOWN_CARD_DECK_OFFSET:int = 0;
		private var _allCards:Vector.<CardView>;
		private var _movingCards:Vector.<CardView>;
		private var _deck:Deck;
		private var _deckCards:Vector.<CardView>;
		private var _visibleDeckCards:Vector.<CardView>;
		private var _slots:Vector.<CardSlot>;
		private var _emptyFields:Vector.<EmptyField>;
		private var _undoButton:Button;
		private var _menuButton:Button;
		private var _timer:MinigameTimer;
		private var _buttonsContainer:LayoutGroup;
		private var _paused:Boolean;
		private var _layoutedColumns:Array;
		
		public function MinigameView() 
		{				
			GlobalDispatcher.instance.addEventListener(CardView.CARD_MOVING, forceMoveCard);
			GlobalDispatcher.instance.addEventListener(CardView.STOP_DRAG, stopDragCard);
		
			_layoutedColumns = [];
			_allCards = new Vector.<CardView>();
			_movingCards = new Vector.<CardView>();
			
			SHOWN_CARD_OFFSET = (GlobalView.WIDTH - 50 - (LogicManager.NUM_COLUMNS * CardView.CARD_WIDTH)) / (LogicManager.NUM_COLUMNS - 1);
			SHOWN_CARD_Y_OFFSET = 35;
			SHOWN_CARD_DECK_OFFSET = 30;			
		}
		
		private function forceMoveCard(e:Event):void 
		{
			var touchX:Number = e.data["touchX"];
			var touchY:Number = e.data["touchY"];
			//var movingCard:LogicCard = e.data["movingCard"];
			
			for each (var item:CardView in _movingCards) 
			{
				item.x = touchX - item.dragOffsetX;
				item.y = touchY - item.dragOffsetY;
			}
			
		}
		
		public function prepareSlots():void 
		{
			_slots = new Vector.<CardSlot>();
			
			for (var i:int = 0; i < LogicHelper.SLOTS_NUM; i++) 
			{
				_slots[i] = new CardSlot();
				_slots[i].x = int(GlobalView.WIDTH / 2 + (CardView.CARD_WIDTH * i) + ((SHOWN_CARD_OFFSET-2) * i) - (CardView.CARD_WIDTH / 2));
				_slots[i].y = _deck.y;
				_slots[i].num = i;
				addChild(_slots[i]);				
			}
		}
		
				
		public function prepareEmptyFields():void 
		{
			_emptyFields = new Vector.<EmptyField>();
			
			var numCol:int = LogicManager.NUM_COLUMNS;
			var field:EmptyField;
			
			for (var i:int = 0; i < numCol; i++) 
			{
				var offset_x:int = (GlobalView.WIDTH - (numCol * CardView.CARD_WIDTH + numCol * SHOWN_CARD_OFFSET  - SHOWN_CARD_OFFSET)) / 2;
				
				field = new EmptyField();
				field.num = i;
				field.x = offset_x + (i * CardView.CARD_WIDTH + i * SHOWN_CARD_OFFSET);
				field.y = Y_OFFSET;
				addChild(field);
				
				_emptyFields.push(field);
			}
			//_emptyFields.reverse();
		}
		
		public function prepareTableCards(columns:Vector.<Vector.<LogicCard>>):void 
		{
			var offset:Number;
			var card:CardView;
			var numCol:int = LogicManager.NUM_COLUMNS;
			var xBorder:int = (GlobalView.WIDTH / 2) - ((211 + 10 + 209 + 10 + 209) / 2);
			//trace((numCol * CardView.CARD_WIDTH + numCol * SHOWN_CARD_OFFSET))
			var firstLayoutedColumn:int = 0;
			
			var offset_x:int = (GlobalView.WIDTH - (numCol * CardView.CARD_WIDTH + numCol * SHOWN_CARD_OFFSET  - SHOWN_CARD_OFFSET)) / 2;
			var columnsLength:int = columns.length;
			var columLeng:int;
			
			for (var i:int = 0; i < columnsLength; i++) 
			{
				columLeng = columns[i].length;
				for (var j:int = 0; j < columLeng; j++) 
				{
					card = new CardView(columns[i][j]);
						card.x =offset_x + (i * CardView.CARD_WIDTH + i * SHOWN_CARD_OFFSET);
						
						if (card.x + CardView.CARD_WIDTH > xBorder && _layoutedColumns.indexOf(i) == -1 && i < LogicManager.NUM_COLUMNS - firstLayoutedColumn)
						{
							if (firstLayoutedColumn == 0)
								firstLayoutedColumn = i;
								
							_layoutedColumns.push(i);
						}
						
						card.y = Y_OFFSET + j * (SHOWN_CARD_Y_OFFSET / 2);
							
						if (j - 1 >= 0)
							card.y += columns[i][j - 1].isShown ? SHOWN_CARD_Y_OFFSET : 0;
						if (card.logicCard.isShown)
							card.flip(true);
						
							card.setCardPosition(card.x, card.y);
						
					addChild(card);
					
					_allCards.push(card);
				}
			}			
		}
		
		private function stopDragCard(e:Event):void 
		{			
			var surface:Number;
			var resultRect:Rectangle;
			var dragedCard:CardView = e.data as CardView;
			
			//check if card can be placed
			//var array:Array = [];
			var destinationCard:CardView;
			var prevSurface:Number = 0;
			var type:String;
			var slot:CardSlot;
			var emptyField:EmptyField;
			
			
			for each(var field:EmptyField in _emptyFields)
			{
				if (field.isAvailable)
				{
					resultRect = dragedCard.getBounds(this).intersection(field.getBounds(this));
					surface = resultRect.width * resultRect.height;
					
					if (resultRect && surface != 0 && surface >= prevSurface)
					{
						prevSurface = surface;
						emptyField = field;
					}
				}
			}
			
			for each(var cardSlot:CardSlot in _slots)
			{
				resultRect = dragedCard.getBounds(this).intersection(cardSlot.getBounds(this));
				surface = resultRect.width * resultRect.height;
				
				if (resultRect && surface != 0 && surface >= prevSurface)
				{
					prevSurface = surface;
					slot = cardSlot;
				}
			}
			
			for each (var card:CardView in _allCards) 
			{
				if (_movingCards.indexOf(card) == -1 && card != dragedCard && card.logicCard.isShown && isLastCard(card))
				{
					resultRect = dragedCard.getBounds(this).intersection(card.getBounds(this));
					surface = resultRect.width * resultRect.height;
					
					if (resultRect && surface != 0 && surface >= prevSurface)
					{
						prevSurface = surface;
						destinationCard = card;
						slot = null;
						emptyField = null;
					}
				}
			}
			
			if (slot)
				checkSlot(dragedCard, slot, SLOT);
			else if (emptyField)
				checkEmptyField(dragedCard, emptyField, EMPTY_FIELD);
			else
				checkMove(dragedCard, destinationCard, dragedCard.logicCard.type);
		}
		
		public function isLastCard(card:CardView):Boolean 
		{
			var result:Boolean = true;
			
			for each (var item:CardView in _allCards) 
			{
				if (item.logicCard.column == card.logicCard.column && item.logicCard.position > card.logicCard.position && item.logicCard.currentSlotNum < 0)
					result = false;
			}
			
			return result;
		}
		
		private function checkEmptyField(dragedCard:CardView, field:EmptyField, type:String):void 
		{
			if (!field)
			{
				moveCard(dragedCard, null);
				return;
			}
			
			dispatchEventWith(CHECK_EMPTY_FIELD, false, { dragedCard: dragedCard, field:field, checkType:type } );
		}
		
		private function checkSlot(dragedCard:CardView, slot:CardSlot, type:String):void 
		{
			if (!slot)
			{
				moveCard(dragedCard, null);
				return;
			}
			
			dispatchEventWith(CHECK_SLOT, false, { dragedCard: dragedCard, slot:slot, checkType:type } );
		}
		
		private function checkMove(dragedCard:CardView, destinationCard:CardView, type:String):void 
		{
			if (!destinationCard)
			{
				moveCard(dragedCard, null);
				placeDragedCards(null, -1);
				return;
			}
			
			dispatchEventWith(CHECK_MOVE, false, { dragedCard: dragedCard, destinationCard:destinationCard, checkType:type } );
		}
		
		public function moveCard(dragedCard:CardView, destinationCard:CardView):void 
		{
			if (!destinationCard)
			{
				if (dragedCard.logicCard.currentSlotNum < 0)
					dragedCard.moveAnim();
				else
					_slots[dragedCard.logicCard.currentSlotNum].putCardInSlot(dragedCard);
				return;
			}
			
			//dragedCard.setCardPosition(destinationCard.positionX, destinationCard.positionY + SHOWN_CARD_OFFSET);
			//dragedCard.moveAnim();
		}
		
		public function setMovingCards(cardsVector:Vector.<LogicCard>, touchX:Number, touchY:Number):void 
		{
			_movingCards = new Vector.<CardView>();
			
			for each (var movingCard:LogicCard in cardsVector) 
			{
				for each (var tableCard:CardView in _allCards) 
				{
					if (tableCard.logicCard == movingCard && tableCard.logicCard.currentSlotNum < 0)
					{
						if (tableCard.parent)
							tableCard.parent.setChildIndex(tableCard, tableCard.parent.numChildren - 1);
						
						tableCard.dragOffsetX = touchX - tableCard.x;
						tableCard.dragOffsetY = touchY - tableCard.y;
						
						_movingCards.push(tableCard);
					}
				}
			}
		}
		
		public function placeDragedCards(dataVector:Vector.<Object>, destinationCardX:Number = -1):void 
		{
			if (!dataVector)
			{				
				for each (var item:CardView in _movingCards) 
				{
					item.moveAnim();
				}
			}
			else
			{				
				for each (var data:Object in dataVector) 
				{
					for each (var card:CardView in _allCards)
					{
						if (data["column"] == card.logicCard.column && data["position"] == card.logicCard.position && card.logicCard.currentSlotNum < 0)
						{	
							var isShownValues:Point = data["prevCardShownValues"];
							
							var tmpY:int = Y_OFFSET + isShownValues.x * SHOWN_CARD_Y_OFFSET + isShownValues.y * (SHOWN_CARD_Y_OFFSET / 2);
								
							card.setCardPosition(destinationCardX,  tmpY);
							
							card.moveAnim();
						}
					}
				}
			}
				
			_movingCards.length = 0;
		}
		
		public function flipCard(cardToFlip:LogicCard):void 
		{
			for each (var card:CardView in _allCards) 
			{
				if (card.logicCard == cardToFlip)
					card.flip(true);
			}
		}		
				
		public function prepareDeck(deck:Vector.<LogicCard>):void 
		{
			var container:Sprite = new Sprite();
			var img:Image = new Image(GlobalAssetManager.instance.assetManager.getTexture("emptySlot"));
			container.addChild(img);
			img = new Image(GlobalAssetManager.instance.assetManager.getTexture("cardBack"));
			img.x = 4;
			img.y = 7;
			container.addChild(img);
			
			_deck = new Deck();
			_deck.defaultSkin = container;
			_deck.addEventListener(Event.TRIGGERED, deckClickedHandler);
			
			_deck.x = int(GlobalView.WIDTH / 2 - (CardView.CARD_WIDTH * 3) - (SHOWN_CARD_OFFSET * 3) - (CardView.CARD_WIDTH /2));
			_deck.y = 30;
			
			addChild(_deck);
			
			_deckCards = new Vector.<CardView>();
			_visibleDeckCards = new Vector.<CardView>();
			
			var cardView:CardView;
			
			for each (var logicCard:LogicCard in deck) 
			{
				cardView = new CardView(logicCard);
				_deckCards.push(cardView);
			}
		}
		
		private function deckClickedHandler(e:Event):void 
		{
			var shownCardsCounter:int = 0;
			
			for each (var cardView:CardView in _visibleDeckCards) 
			{
				if (cardView.parent == this)
					shownCardsCounter++;
					
				if (cardView.logicCard.isShown)
				{
					cardView.logicCard.isShown = false;					
				}
				cardView.flip(false);
				cardView.removeFromParent();
			}
			
			dispatchEventWith(DECK_CLICKED, false, { byUndo: e ? false : true, shownCards: shownCardsCounter } );
			
			var card:CardView;
			shownCardsCounter = 0;
			//show next cards
			var cardsNum:int = _deckCards.length;
			if (cardsNum)
			{
				
				SoundAS.group("sounds").play("cardReturned");
				
				for (var i:int = 0; i < LogicHelper.DECK_SHOWN_CARDS; i++) 
				{
					if (i < cardsNum)
					{
						card = _deckCards.pop();						
						card.flip(true);
						card.y = _deck.y + 7;
						card.x = _deck.x + CardView.CARD_WIDTH + SHOWN_CARD_DECK_OFFSET + i * SHOWN_CARD_DECK_OFFSET;
						card.setCardPosition(card.x, card.y);
						addChild(card);
						
						shownCardsCounter++;
						//_visibleDeckCards.unshift(card);
						_visibleDeckCards.push(card);
					}
				}
				if (!_deckCards.length)
					Sprite(_deck.defaultSkin).getChildAt(1).alpha = 0;
				
				var visibleCardsLength:int = _visibleDeckCards.length;
				if (visibleCardsLength)
					_visibleDeckCards[visibleCardsLength - 1].logicCard.isShown = true;				
			}
			else
			{
				SoundAS.group("sounds").play("putOnTable");
				SoundAS.group("sounds").play("deckShuffled");
				// DECK RESET
				dispatchEventWith(DECK_RESET);
				
				if (_visibleDeckCards.length)
					Sprite(_deck.defaultSkin).getChildAt(1).alpha = 1;
				while (_visibleDeckCards.length)
				{
					card = _visibleDeckCards.shift();
					card.flip(false);
					card.removeFromParent();
					_deckCards.unshift(card);
				}
				
			}
			
			dispatchEventWith(CHECK_END_GAME);
				
		}

		public function undoClickDeck(shownCards:int):void 
		{
			var nextCardNum:int;
			var counter:int = 0;
			
			for each (var cardView:CardView in _visibleDeckCards) 
			{
				if (cardView.parent == this)
					counter++;
				if (cardView.logicCard.isShown)
				{
					cardView.logicCard.isShown = false;					
				}
				cardView.flip(false);
				cardView.removeFromParent();
			}
				
			if (counter)
			{
				Sprite(_deck.defaultSkin).getChildAt(1).alpha = 1;
				
				var card:CardView;
				while (counter)
				{
					card = _visibleDeckCards.pop();
					_deckCards.push(card);
					counter--;
				}
				
				nextCardNum = Math.min(_visibleDeckCards.length, shownCards);
				counter = 0;
				if (nextCardNum)
				{					
					while (counter < nextCardNum)
					{
						card = _visibleDeckCards[_visibleDeckCards.length - nextCardNum + counter]
						card.flip(true);
						card.y = _deck.y + 7;
						card.x = _deck.x + CardView.CARD_WIDTH + SHOWN_CARD_DECK_OFFSET + counter * SHOWN_CARD_DECK_OFFSET;
						card.setCardPosition(card.x, card.y);
						addChild(card);
										
						counter++;
					}
					card.logicCard.isShown = true;
				}
			}
			else
			{
				Sprite(_deck.defaultSkin).getChildAt(1).alpha = 0;
				nextCardNum = Math.min(_deckCards.length, shownCards);
				while (_deckCards.length > nextCardNum)
				{
					card = _deckCards.pop();					
					_visibleDeckCards.push(card);
				}
				deckClickedHandler(null);
			}
			
		}
		
		public function removeCardFromDeck(dragedCard:CardView, addToAllCards:Boolean = true):void 
		{			
			var cardIndex:int = _visibleDeckCards.indexOf(dragedCard);
			if (cardIndex != -1)
			{
				
				_visibleDeckCards.splice(cardIndex, 1);
				if (cardIndex > 0)
				{
					if (_visibleDeckCards.length)
						_visibleDeckCards[cardIndex - 1].logicCard.isShown = true;
					else
						_visibleDeckCards[cardIndex].logicCard.isShown = true;
				}
				
				if (addToAllCards)
					_allCards.push(dragedCard);
				
				
				var flag:Boolean = false;
					
				for each (var visibleCard:CardView in _visibleDeckCards) 
				{
					if (visibleCard.parent == this)
						flag = true;
				}	
				if (!flag && _visibleDeckCards.length)
				{
					var card:CardView = _visibleDeckCards[_visibleDeckCards.length - 1];
					
					card.flip(true);
						card.logicCard.isShown = true;
						card.y = _deck.y + 7;
						card.x = _deck.x + CardView.CARD_WIDTH + SHOWN_CARD_DECK_OFFSET;
						card.setCardPosition(card.x, card.y);
						addChild(card);
						
						dispatchEventWith(FORCE_SHOW_DECK_CARD, false, card );
				}		
			}
		}
		
		public function removeCardFromAllCards(dragedCard:CardView):void 
		{
			var cardIndex:int = _allCards.indexOf(dragedCard);
			if (cardIndex != -1)
			{
				_allCards.splice(cardIndex, 1);
			}
		}
		
		public function updateEmptyFieldStatus(fieldNum:int, isAvailable:Boolean):void 
		{
			_emptyFields[fieldNum].isAvailable = isAvailable;
			_emptyFields[fieldNum].alpha = isAvailable ? 1 : 0;
		}
		
		public function prepareButtons():void 
		{
			_buttonsContainer = new LayoutGroup();
			var layout:HorizontalLayout = new HorizontalLayout();
				layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
				layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
				layout.gap = 10;
				_buttonsContainer.layout = layout;
			
				
			_timer = new MinigameTimer();
			GlobalJuggler.instance.minigameJuggler.add(_timer);
			
			_buttonsContainer.addChild(_timer);
			_undoButton = new Button();
			_undoButton.label = "UNDO";
			_undoButton.styleName = SteelSolitaireTheme.MINIGAME_SIMPLE_BUTTON;
			_undoButton.addEventListener(Event.TRIGGERED, onUndoHandler);
			_buttonsContainer.addChild(_undoButton);
			
			_menuButton = new Button();
			_menuButton.label = "MENU";
			_menuButton.styleName = SteelSolitaireTheme.MINIGAME_SIMPLE_BUTTON;
			_menuButton.x = 209 + 10;
			_menuButton.addEventListener(Event.TRIGGERED, onLeaveGameHandler);
			_buttonsContainer.addChild(_menuButton);			
			
			addChild(_buttonsContainer);
			_buttonsContainer.width = GlobalView.WIDTH;
			_buttonsContainer.y = GlobalView.HEIGHT - 65;
		}		
		
		private function onUndoHandler(e:Event):void 
		{
			dispatchEventWith(UNDO);
		}
		
		public function showMenuPopup():void
		{
			if (!_paused)
			{
				var popup:MinigameMenuPopup = PopUpManager.addPopUp(new MinigameMenuPopup()) as MinigameMenuPopup;
					popup.addEventListener(BasePopupView.POPUP_HIDDEN, onHideMenuHandler);
			
				pause();
			}
		}
		
		private function onLeaveGameHandler(e:Event):void 
		{
			showMenuPopup();
		}
		
		public function pause():void
		{
			Starling.juggler.remove(GlobalJuggler.instance.minigameJuggler);
			_paused = true;
		}
		
		public function resume():void
		{
			Starling.juggler.add(GlobalJuggler.instance.minigameJuggler);	
			_paused = false;
		}
		
		private function onHideMenuHandler(e:Event):void 
		{
			resume();
			
			var data:Object = e.data;
			var type:String = e.data["type"];
			
			switch (type)
			{
				case BasePopupView.CANCEL:
				{
					
					break;
				}
				case MinigameMenuPopup.MAIN_MENU:
				{
					PlayerModel.instance.saveGameLostData();
					GlobalDispatcher.instance.dispatchEventWith(GlobalDispatcher.INIT_MENU);
					break;
				}
				case MinigameMenuPopup.REPLAY:
				{
					PlayerModel.instance.saveGameLostData();
					dispatchEventWith(MinigameView.REPLAY_GAME);
					break;
				}
				case MinigameMenuPopup.NEW_GAME:
				{
					PlayerModel.instance.saveGameLostData();
					dispatchEventWith(MinigameView.START_NEW_GAME);
					break;
				}
			}
		}
		
		override public function dispose():void 
		{
			GlobalJuggler.instance.minigameJuggler.remove(_timer);
			_timer.removeFromParent(true);
			
			_deck.removeEventListener(Event.TRIGGERED, deckClickedHandler);
			GlobalDispatcher.instance.removeEventListener(CardView.CARD_MOVING, forceMoveCard);
			GlobalDispatcher.instance.removeEventListener(CardView.STOP_DRAG, stopDragCard);
			
			_undoButton.removeEventListeners();
			_undoButton.removeFromParent(true);
			_undoButton = null;
			
			_menuButton.removeEventListeners();
			_menuButton.removeFromParent(true);
			_menuButton = null;
			
			_allCards = null;
			_movingCards = null;
			
			_deck.removeEventListeners();
			_deck.removeFromParent(true);
			
			_deckCards = null;
			_visibleDeckCards = null;
		
			for each (var cardSlot:CardSlot in _slots) 
			{
				cardSlot.removeFromParent(true);
			}
			_slots = null;
			
			for each (var field:EmptyField in _emptyFields) 
			{
				field.removeFromParent(true);
			}
			_emptyFields = null;
		
			this.removeChildren(0, -1, true);
			
			super.dispose();
		}
		
		public function unselectCards(exception:CardView = null):void 
		{
			for each (var card:CardView in _allCards) 
			{
				if(card != exception)
					card.unselect();
			}
			
			for each (card in _visibleDeckCards) 
			{
				if(card != exception)
					card.unselect();
			}
			
			for each (var slot:CardSlot in _slots) 
			{
				slot.unselect();
			}
			
			for each (var field:EmptyField in _emptyFields) 
			{
				field.unselect();
			}
			
			_deck.unselect();
		}
		
		public function selectCards(cardsVector:Vector.<LogicCard>):void 
		{
			for each (var card:LogicCard in cardsVector) 
			{
				for each (var tableCard:CardView in _allCards) 
				{
					if (tableCard.logicCard == card)
					{
						tableCard.select();
					}
				}
			}
						
		}
		
		public function sortCardsInColumn(num:int):void 
		{
			//var vect:Vector.<CardView> = new Vector.<CardView>();
			var array:Array = [];
			for each (var tableCard:CardView in _allCards) 
			{
				if (tableCard.logicCard.column == num && tableCard.logicCard.currentSlotNum < 0)
					array.push(tableCard);
			}
			
			//vect.sort(function (cardA:CardView, cardB:CardView):Boolean { return cardA.y > cardB.y } );
			array.sortOn("positionY", Array.NUMERIC);
			
			for each (var item:CardView in array) 
			{
				if (item.parent)
					item.parent.setChildIndex(item, item.parent.numChildren - 1);
			}
		}
		
		public function getCardViewByLogic(logicCard:LogicCard):CardView 
		{
			var retCard:CardView;
			
			for each (var item:CardView in _allCards) 
			{
				if (item.logicCard == logicCard)
					retCard = item;
			}
			
			return retCard;
		}
		
		public function addToAllCards(cardView:CardView):void 
		{
			if (_allCards.indexOf(cardView) == -1)
				_allCards.push(cardView);
		}
		
		public function getEmptyFieldByNum(column:int):EmptyField 
		{
			return _emptyFields[column];
		}
		
		public function putCardBackInDeck(cardView:CardView):void 
		{
			for each (var card:CardView in _visibleDeckCards) 
			{
				if (card.logicCard.isShown)
				{
					card.logicCard.isShown = false;					
				}
			}
			cardView.logicCard.forceLayout = false;
			cardView.logicCard.isShown = true;
			cardView.logicCard.type = LogicManager.DECK;
			cardView.logicCard.column = -1;
			cardView.logicCard.position = -1;
			
			if (_allCards.indexOf(cardView) != -1)
				_allCards.splice(_allCards.indexOf(cardView), 1);
				
			var counter:int = 0;
					
			for each (var visibleCard:CardView in _visibleDeckCards) 
			{
				if (visibleCard.parent == this)
					counter++;
			}	
			
			
			var cardX:int = _deck.x + CardView.CARD_WIDTH + SHOWN_CARD_DECK_OFFSET + counter * SHOWN_CARD_DECK_OFFSET;
			var cardY:int = _deck.y + 7;
			cardView.setCardPosition(cardX, cardY);
			cardView.moveAnim();
			_visibleDeckCards.push(cardView);
			if (cardView.parent)
				cardView.parent.setChildIndex(cardView, cardView.parent.numChildren - 1);
			
		}
		
		public function forceHideCardInDeck(cardView:CardView):void 
		{
			cardView.logicCard.isShown = true;
			cardView.logicCard.type = LogicManager.DECK;
			cardView.logicCard.column = -1;
			cardView.logicCard.position = -1;
			cardView.flip(false);
			cardView.removeFromParent();
			
			if (_visibleDeckCards.indexOf(cardView) != -1)
				_visibleDeckCards.splice(_visibleDeckCards.indexOf(cardView), 1);
				
			//_deckCards.unshift(cardView);
			_visibleDeckCards.push(cardView);
		}
		
		public function applyPlayerSettings():void 
		{
			PlayerModel.instance.gameType == PlayerModel.MOVES_GAME ? _timer.showMoves() : _timer.showTimer();
			_timer.updateMoves(0);
		}
		
		public function get timer():MinigameTimer 
		{
			return _timer;
		}
		
		public function get visibleDeckCards():Vector.<CardView> 
		{
			return _visibleDeckCards;
		}
		
		public function get slots():Vector.<CardSlot> 
		{
			return _slots;
		}
		
		public function get emptyFields():Vector.<EmptyField> 
		{
			return _emptyFields;
		}
		
		public function get deck():Deck 
		{
			return _deck;
		}
		
		public function get buttonsContainer():LayoutGroup 
		{
			return _buttonsContainer;
		}
		
		public function get layoutedColumns():Array 
		{
			return _layoutedColumns;
		}
		
		public function get deckCards():Vector.<CardView> 
		{
			return _deckCards;
		}
		
	}

}