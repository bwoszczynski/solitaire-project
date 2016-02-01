package minigame.slot 
{
	import feathers.controls.Button;
	import interfaces.ISelectable;
	import manager.GlobalAssetManager;
	import manager.GlobalDispatcher;
	import manager.GlobalJuggler;
	import minigame.card.CardView;
	import minigame.logic.LogicCard;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import treefortress.sound.SoundAS;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class CardSlot extends Sprite implements ISelectable
	{
		public var num:int;
		static public const CARD_SLOT_SELECTED:String = "cardSlotSelected";
		
		private var _lastLogicCard:Vector.<LogicCard>;
		private var _selectButton:Button;
		private var _glow:Image;
		
		public function CardSlot() 
		{
			_lastLogicCard = new Vector.<LogicCard>();
			
			var img:Image = new Image(GlobalAssetManager.instance.assetManager.getTexture("emptySlot"));
			_glow = new Image(GlobalAssetManager.instance.assetManager.getTexture("cardGlow"));
			_glow.alignPivot();
			
			_glow.x = -10;
			_glow.y = -7;			
			_glow.visible = false;
			_glow.touchable = false;
			
			_glow.x += _glow.pivotX;
			_glow.y += _glow.pivotY;
			
			_selectButton = new Button();
			_selectButton.defaultSkin = img;
			_selectButton.soundName = "putOnTable";
			_selectButton.addEventListener(Event.TRIGGERED, onSlotSelectedHandler);
			addChild(_selectButton);
			
			addChild(_glow);
			setStartGlowValues();
		}
		private function onSlotSelectedHandler(e:Event):void 
		{
			GlobalDispatcher.instance.dispatchEventWith(CARD_SLOT_SELECTED, false, this);	
		}
			
		public function select(withAnim:Boolean = false):void
		{
			this.setChildIndex(_glow, numChildren - 1);
			_glow.visible = true;
			
			
			if (withAnim)
			{
				_glow.alpha = 0;
				var tween:Tween = new Tween(_glow, 0.6);
					tween.scaleTo(1.2);
					tween.fadeTo(1);
					tween.reverse = true;
					tween.repeatCount = 0;
					GlobalJuggler.instance.minigameJuggler.add(tween);
			}
		}
		
		public function unselect():void
		{
			setStartGlowValues();
		}
		
		public function putCardInSlot(cardView:CardView):void
		{
			//cardView.logicCard.column = -2;
			//cardView.logicCard.position = -2;
			if (cardView.parent)
				cardView.parent.setChildIndex(cardView, cardView.parent.numChildren - 1);
			cardView.logicCard.currentSlotNum = this.num;
			cardView.logicCard.forceLayout = false;
		//	cardView.touchable = false;
			
			cardView.setCardPosition(this.x + 4, this.y + 7);
			
			var tween:Tween = new Tween(cardView, 0.12);
				tween.moveTo(this.x + 4, this.y + 7);
				tween.onComplete = showSlotAnim;
				tween.onCompleteArgs = [cardView];
				
				GlobalJuggler.instance.minigameJuggler.add(tween);
			
			if (_lastLogicCard.indexOf(cardView.logicCard) == -1)
				_lastLogicCard.push(cardView.logicCard);
		}
		
		private function showSlotAnim(cardView:CardView):void 
		{
			SoundAS.group("sounds").play("cardInSlot");
				
			setStartGlowValues();
			_glow.visible = true;
			
			var tween:Tween = new Tween(_glow, 0.3);
				tween.scaleTo(1.3);
				tween.fadeTo(0);
				tween.onComplete = setStartGlowValues;
				GlobalJuggler.instance.minigameJuggler.add(tween);
				GlobalDispatcher.instance.dispatchEventWith(CardView.LAYOUT_COLUMNS, false, _lastLogicCard[_lastLogicCard.length - 1]);
		}
		
		public function setStartGlowValues():void 
		{
			GlobalJuggler.instance.minigameJuggler.removeTweens(_glow);
			_glow.visible = false;
			_glow.scaleX = _glow.scaleY = 1.1;
			_glow.alpha = 1;
		}
		
		public function get lastLogicCard():LogicCard 
		{
			if (_lastLogicCard.length)
				return _lastLogicCard[_lastLogicCard.length - 1];
			else
				return null;
		}
		
		public function removeLastLogicCard(forceCard:LogicCard = null):void
		{
			if (forceCard)
			{
				if (_lastLogicCard.length && _lastLogicCard[_lastLogicCard.length - 1] == forceCard)
					_lastLogicCard.pop();
			}
			else
				_lastLogicCard.pop();
		}
		
		override public function dispose():void 
		{
			GlobalJuggler.instance.minigameJuggler.removeTweens(_glow);
			_selectButton.removeEventListeners();
			_selectButton.removeFromParent(true);
			_selectButton = null;
		
			_lastLogicCard = null;
			removeChildren(0, -1, true);
			
			super.dispose();
		}
		
		public function getLastCardView():CardView 
		{
			if (this.numChildren)
			{
				return this.getChildAt(this.numChildren - 1) as CardView;
			}
			else
				return null;
		}
		
	}

}