package scenes {

	import com.greensock.TweenLite;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import utils.common.util.DisObjUtil;

	public class LayerManager extends Sprite {
		public static var bgContainer:Sprite;
		public static var doubleBookContainer:Sprite;
		public static var singleBookContainer:Sprite;
		public static var toolBarContainer:Sprite;
		public static var btnsContainer:Sprite;
		public static var huiContainer:Sprite;
		public static var tipContainer:Sprite;

		public static var tipSprite:Sprite;

		public function LayerManager() {
		}

		public static function initView(cont:Sprite):void {
			bgContainer = new Sprite();
			cont.addChild(bgContainer);
			doubleBookContainer = new Sprite();
			cont.addChild(doubleBookContainer);
			singleBookContainer = new Sprite();
			cont.addChild(singleBookContainer);
			btnsContainer = new Sprite();
			cont.addChild(btnsContainer);
			toolBarContainer = new Sprite();
			cont.addChild(toolBarContainer);
			huiContainer = new Sprite();
			cont.addChild(huiContainer);
			tipContainer = new Sprite();
			cont.addChild(tipContainer);
		}

		public static function clearContainer(container:DisplayObjectContainer):void {
			DisObjUtil.removeAllChildren(container);
		}

		public static function showTip(con:Sprite):void {
			tipSprite = con;
			tipContainer.addChild(con);
//			con.scaleX = 0.5;
//			con.scaleY = 0.5;
//			TweenLite.to(con, 0.2, {transformAroundCenter: {scaleX: 1, scaleY: 1}});
			TweenLite.to(con, 1, {alpha: 1, glowFilter:{color:0x91e600, alpha:1, blurX:10, blurY:10}});
			DisObjUtil.toStageCenter(con);
			TBZBNMain.hui(true);
			TBZBNMain.huiToolBar(true);
			TBZBNMain.st.addEventListener(MouseEvent.CLICK, onStageClickHandler);
		}

		private static function onStageClickHandler(e:MouseEvent):void {
			var targetName:String = e.target.name;
			if (targetName == "stagehui" || targetName == "toolbarhui") {
				TBZBNMain.st.removeEventListener(MouseEvent.CLICK, onStageClickHandler);
				hideTip();
			}
		}

		public static function hideTip():void {
			if (tipSprite && tipContainer.contains(tipSprite)) {
				tipContainer.removeChild(tipSprite);
			}
			TBZBNMain.hui(false);
			TBZBNMain.huiToolBar(false);
		}
	}
}
