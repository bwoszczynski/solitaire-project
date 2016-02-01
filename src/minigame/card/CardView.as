package minigame.card 
{
	import feathers.controls.Button;
	import feathers.dragDrop.DragData;
	import feathers.dragDrop.DragDropManager;
	import feathers.dragDrop.IDragSource;
	import feathers.dragDrop.IDropTarget;
	import feathers.events.DragDropEvent;
	import interfaces.ISelectable;
	import manager.GlobalAssetManager;
	import manager.GlobalDispatcher;
	import manager.GlobalJuggler;
	import minigame.logic.LogicCard;
	import minigame.logic.LogicHelper;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.HAlign;
	import treefortress.sound.SoundAS;
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public class CardView extends Sprite implements ISelectable
	{
		private var _front:Sprite;
		private var _back:Sprite;
		private var _logicCard:LogicCard;
		private var _dragQuad:Quad;		
		private var _dragOffsetX:Number;
		private var _dragOffsetY:Number;
		private var _positionY:Number;
		private var _positionX:Number;
		static public const CARD_WIDTH:Number = 119;
		static public const CARD_HEIGHT:Number = 153;
		static public const STOP_DRAG:String = "stopDrag";
		static public const CARD_MOVING:String = "cardMoving";
		static public const START_DRAG:String = "startDrag";
		static public const CARD_SELECTED:String = "cardSelected";
		static public const QUICK_MOVE:String = "quickMove";
		static public const LAYOUT_COLUMNS:String = "layoutColumns";
		static private const X_OFFSET:Number = 10;
		private var _touchTime:Number;
		private var _glow:Image;
		private var _selectButton:Button;
		private var _prevDisplayIndex:int;
		private var _clickCounter:int;
		private var _prevTouchTime:Number;
		private var _soundPlayed:Boolean;
		
		public function CardView(logic:LogicCard) 
		{
			var img:Image;
			
			_logicCard = logic;
			
			_front = new Sprite();
			img = new Image(GlobalAssetManager.instance.assetManager.getTexture("cardEmpty"));
			_front.addChild(img);
			img = new Image(GlobalAssetManager.instance.assetManager.getTexture("symbolBig_" + _logicCard.suit.toLowerCase()));
			img.alignPivot();
			img.x = int(_front.width / 2);
			img.y = int(_front.height / 2) + 10;
			_front.addChild(img);
			
			img = new Image(GlobalAssetManager.instance.assetManager.getTexture(_logicCard.value + "_" + getColorBySuit(_logicCard.suit)));
			img.alignPivot();
			img.x = img.width - 10;
			img.y = img.height - 10;
			_front.addChild(img);
			
			
			img = new Image(GlobalAssetManager.instance.assetManager.getTexture("symbolSmall_" + _logicCard.suit.toLowerCase()));
			img.x = CARD_WIDTH - img.width - X_OFFSET;
			img.y = X_OFFSET;
			_front.addChild(img);
			/*
			img = new Image(GlobalAssetManager.instance.assetManager.getTexture("symbolSmall_" + _logicCard.suit.toLowerCase()));
			img.x = CARD_WIDTH - img.width - X_OFFSET;
			img.scaleY = -1;
			img.y = CARD_HEIGHT - int(img.height * 1.5);
			_front.addChild(img);*/
			
			addChild(_front);
			
			_back = new Sprite();
			img = new Image(GlobalAssetManager.instance.assetManager.getTexture("cardBack"));
			_back.addChild(img);
			addChild(_back);
			
			/*var text:TextField = new TextField(_front.width, 30, logic.value + " " + logic.suit, "Arial", 14);
				text.hAlign = HAlign.LEFT;
				text.autoScale = true;
				text.y = 5;
				addChild(text);*/
				
			_dragQuad = new Quad(CARD_WIDTH, CARD_HEIGHT);
			_dragQuad.alpha = 0;			
			this.addEventListener(TouchEvent.TOUCH, onCardDragHandler);
			
			_selectButton = new Button();
				_selectButton.defaultSkin = _dragQuad;
				_selectButton.addEventListener(Event.TRIGGERED, onCardSelectedHandler);
				_selectButton.soundName = null;
			addChild(_selectButton);			
			
			// change that to graphics!!!!
			_glow = new Image(GlobalAssetManager.instance.assetManager.getTexture("cardGlow"));
			_glow.alignPivot();
			_glow.x = -14;
			_glow.y = -13;
			_glow.touchable = false;
			
			_glow.visible = false;
			
			_glow.x += _glow.pivotX;
			_glow.y += _glow.pivotY;
			addChild(_glow);
			
			_clickCounter = 0;
		}	
		
		private function getColorBySuit(suit:String):String 
		{
			if (suit == LogicHelper.HEARTS || suit == LogicHelper.DIAMONDS)
				return "red";
			else
				return "black";
		}
		
		private function onCardSelectedHandler(e:Event):void 
		{				
		}
		
		public function select(withAnim:Boolean = false):void
		{
			_glow.visible = true;
			
			
			if (withAnim)
			{
				_glow.alpha = 0;
				var tween:Tween = new Tween(_glow, 0.6);
					tween.scaleTo(1.1);
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
		
		public function setStartGlowValues():void 
		{
			GlobalJuggler.instance.minigameJuggler.removeTweens(_glow);
			_glow.visible = false;
			_glow.scaleX = _glow.scaleY = 1;
			_glow.alpha = 1;
		}
		
		private function dragCompleteHandler(e:DragDropEvent):void 
		{
			trace(e);
		}
		
		private function dragStartHandler(e:DragDropEvent):void 
		{
			trace(e);
		}
		
		private function onCardDragHandler(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this, null);
			if (touch != e.touches[0])
				return;
			if (touch && this._logicCard.isShown)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{	
					_touchTime = touch.timestamp;
					_dragOffsetX = (touch.globalX - this.x);
					_dragOffsetY = (touch.globalY - this.y);
					if (this.parent)
					{
						_prevDisplayIndex = this.parent.getChildIndex(this);
						this.parent.setChildIndex(this, this.parent.numChildren - 1);
					}
						
					GlobalDispatcher.instance.dispatchEventWith(START_DRAG, false, { touchX: touch.globalX, touchY: touch.globalY, movingCard: this._logicCard } );
				}
				else if (touch.phase == TouchPhase.MOVED)
				{			
					if (!_soundPlayed)
					{
						_soundPlayed = true;
						SoundAS.group("sounds").play("cardPicked");
					}
					this.x = touch.globalX - _dragOffsetX;
					this.y = touch.globalY - _dragOffsetY;
					
					GlobalDispatcher.instance.dispatchEventWith(CARD_MOVING, false, { touchX: touch.globalX, touchY: touch.globalY, movingCard: this._logicCard});
				}
				else if (touch.phase == TouchPhase.ENDED)
				{		
					_soundPlayed = false;
					if (Math.abs(_touchTime - touch.timestamp) > 0.08 && (Math.abs(this.x - _positionX) + Math.abs(this.y - _positionY)) > 4)
					{
						_clickCounter = 0;
						unselect();
					}
					else
					{				
						SoundAS.group("sounds").play("cardPicked");
						//if (this.parent && _prevDisplayIndex <= this.parent.numChildren - 1)
							//this.parent.setChildIndex(this, _prevDisplayIndex);
						if (_logicCard.currentSlotNum < 0)
							moveAnim();
						select();
						GlobalDispatcher.instance.dispatchEventWith(CARD_SELECTED, false, this);
						_clickCounter++;
						
						if (_clickCounter == 2)
						{
							trace(Math.abs(_prevTouchTime - touch.timestamp));
							if (Math.abs(_prevTouchTime - touch.timestamp) < 0.30 && this._logicCard.currentSlotNum < 0)
							{
								trace("QUICK MOVE ");
								GlobalDispatcher.instance.dispatchEventWith(QUICK_MOVE, false, this);
								_clickCounter = 0;
							}
							else
								_clickCounter = 1;
						}
						
						_prevTouchTime = _touchTime;
						return;
					}
						
					GlobalDispatcher.instance.dispatchEventWith(STOP_DRAG, false, this);
				}
			}
		}
		
		public function flip(front:Boolean):void
		{
			_front.visible = false;
			_back.visible = false;
			
			_front.visible = front;
			_back.visible = !_front.visible;
		}		
		
		public function moveAnim(withEvent:Boolean = true, delay:Number = 0):void 
		{
			//this.touchable = false;
			var tween:Tween = new Tween(this, 0.12);
				tween.moveTo(_positionX, _positionY);
				if (delay)
					tween.delay = delay;
				
				tween.onComplete = cardPut;
				tween.onCompleteArgs = [withEvent];
				GlobalJuggler.instance.minigameJuggler.add(tween);
		}
		
		private function cardPut(withEvent:Boolean):void 
		{
			//this.touchable = true;
			if (withEvent)
			{
				SoundAS.group("sounds").play("cardReturned");
				
				GlobalDispatcher.instance.dispatchEventWith(LAYOUT_COLUMNS, false, _logicCard);
			}
		}
		
		public function setCardPosition(x:int, y:int):void 
		{
			_positionX = x;
			_positionY = y;
		}
		
		public function clean():void
		{
		
		}
		
		public function get logicCard():LogicCard 
		{
			return _logicCard;
		}
		
		public function get positionY():Number 
		{
			return _positionY;
		}
		
		public function get positionX():Number 
		{
			return _positionX;
		}
		
		public function get dragOffsetX():Number 
		{
			return _dragOffsetX;
		}
		
		public function set dragOffsetX(value:Number):void 
		{
			_dragOffsetX = value;
		}
		
		public function get dragOffsetY():Number 
		{
			return _dragOffsetY;
		}
		
		public function set dragOffsetY(value:Number):void 
		{
			_dragOffsetY = value;
		}
		
		override public function dispose():void 
		{
			GlobalJuggler.instance.minigameJuggler.removeTweens(_glow);
			_selectButton.removeEventListeners();
			_selectButton.removeFromParent(true);
			_selectButton = null;
			
			_front = null;
			_back = null;
			
			this.removeEventListener(TouchEvent.TOUCH, onCardDragHandler);
			this.removeChildren(0, -1, true);
			
			super.dispose();
		}
	}

}