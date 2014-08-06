package UI {
	import com.greensock.TweenLite;

	import data.ConfigManager;
	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.events.MouseEvent;

	import tbzb.ui.UIChooseBanBenPanel;

	import utils.common.component.display.AbstractDisplayObject;

	public class UIChooseBanBenPanelImpl extends AbstractDisplayObject {
		private static var uiChooseBanBenPanel:UIChooseBanBenPanel;
		private static var btns:Vector.<UIChooseBtnImpl>;
		private static var activeBtn:UIChooseBtnImpl;
		public static var nianjiIndex:int;
		public static var kemuIndex:int;

		public function UIChooseBanBenPanelImpl() {
			btns = new Vector.<UIChooseBtnImpl>();
			uiChooseBanBenPanel = new UIChooseBanBenPanel();
			addChild(uiChooseBanBenPanel);
		}

		public function initBtns(bookInfo:BookInfo, njIndex:int, kmIndex:int):void {
			nianjiIndex = njIndex;
			kemuIndex = kmIndex;
			var banbenObj:Object = ConfigManager.banbielist[njIndex][kmIndex];
			var marginTop:int = 135;
			var marginLeft:int = 70;
			for (var i:int = 0; i < banbenObj.length; i++) {
				var version:Object = ConfigManager.baseInfo.version;
				var btn:UIChooseBtnImpl = new UIChooseBtnImpl(version[banbenObj[i]], {index: banbenObj[i]});
				btn.addEventListener(MouseEvent.CLICK, onClickHandler);
				btn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
				btn.x = marginLeft + i % 4 * (btn.width + 30);
				btn.y = marginTop + int(i / 4) * (btn.height + 30);
				if (bookInfo.version == banbenObj[i]) {
					activeBtn = btn;
					btn.gotoActive();
				}
				addChild(btn);
				btn.alpha = 0;
				TweenLite.to(btn, 0.3, {alpha: 1, delay: i * 0.1});
				btns.push(btn);
			}
		}

		private function onClickHandler(e:MouseEvent):void {
			if (activeBtn) {
				activeBtn.gotoMouseOut();
			}
			var btn:UIChooseBtnImpl = e.currentTarget as UIChooseBtnImpl;
			btn.gotoActive();
			activeBtn = btn;
			dispatchEvent(new UIEvent(UIEvent.UIChooseBanBenPanelEvent, {type: "choose", kmIndex: kemuIndex, njIndex: nianjiIndex, bbIndx: activeBtn.getData().index}));
		}

		private function onMouseOverHandler(e:MouseEvent):void {
			var btn:UIChooseBtnImpl = e.currentTarget as UIChooseBtnImpl;
			if (btn.getCurrentFrame() != 3) {
				btn.gotoMouseOver();
			}
		}

		private function onMouseOutHandler(e:MouseEvent):void {
			var btn:UIChooseBtnImpl = e.currentTarget as UIChooseBtnImpl;
			if (btn.getCurrentFrame() != 3) {
				btn.gotoMouseOut();
			}
		}
	}
}