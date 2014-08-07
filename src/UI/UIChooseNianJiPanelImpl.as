package UI {
	import com.greensock.TweenLite;

	import data.ConfigManager;
	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.events.MouseEvent;

	import tbzb.ui.UIChooseNianJiPanel;

	import utils.common.component.display.AbstractDisplayObject;

	public class UIChooseNianJiPanelImpl extends AbstractDisplayObject {
		private static var uiChooseNianJiPanel:UIChooseNianJiPanel;
		private static var btns:Vector.<UIChooseBtnImpl>;
		private static var activeBtn:UIChooseBtnImpl;

		public function UIChooseNianJiPanelImpl() {
			btns = new Vector.<UIChooseBtnImpl>();
			uiChooseNianJiPanel = new UIChooseNianJiPanel();
			uiChooseNianJiPanel.back_btn.addEventListener(MouseEvent.CLICK, onClickBackBtnEventHandler);
			addChild(uiChooseNianJiPanel);
		}

		private function onClickBackBtnEventHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.UIChooseNianJiPanelEvent, {type: "back"}));
		}

		public function initBtns(bookInfo:BookInfo, banbielist:Object, choose_nj:String = ""):void {
			var i:int = 0;
			var marginTop:int = 135;
			var marginLeft:int = 70;
			for (var index:String in banbielist) {
				var btn:UIChooseBtnImpl = new UIChooseBtnImpl(ConfigManager.baseInfo.grade[index], {index: index});
				btn.addEventListener(MouseEvent.CLICK, onClickHandler);
				btn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
				btn.x = marginLeft + i % 4 * (btn.width + 30);
				btn.y = marginTop + int(i / 4) * (btn.height + 30);
				var tt:String;
				if (choose_nj != "") {
					tt = choose_nj;
				} else {
					tt = bookInfo.grade;
				}
				if (tt == index) {
					activeBtn = btn;
					btn.gotoActive();
				}
				addChild(btn);
				btn.alpha = 0;
				btn.y += 10;
				TweenLite.to(btn, 0.1, {y: "-10", alpha: 1, delay: i * 0.05});
				btns.push(btn);
				i++;
			}
		}

		private function onClickHandler(e:MouseEvent):void {
			if (activeBtn) {
				activeBtn.gotoMouseOut();
			}
			var btn:UIChooseBtnImpl = e.currentTarget as UIChooseBtnImpl;
			btn.gotoActive();
			activeBtn = btn;
			dispatchEvent(new UIEvent(UIEvent.UIChooseNianJiPanelEvent, {type: "choose", njIndex: activeBtn.getData().index}));
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
