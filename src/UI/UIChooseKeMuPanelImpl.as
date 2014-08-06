package UI {
	import com.greensock.TweenLite;

	import data.ConfigManager;
	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.events.MouseEvent;

	import tbzb.ui.UIChooseKeMuPanel;

	import utils.common.component.display.AbstractDisplayObject;

	public class UIChooseKeMuPanelImpl extends AbstractDisplayObject {
		private static var uiChooseKeMuPanel:UIChooseKeMuPanel;
		private static var btns:Vector.<UIChooseBtnImpl>;
		private static var activeBtn:UIChooseBtnImpl;
		public static var nianjiIndex:int;

		public function UIChooseKeMuPanelImpl() {
			btns = new Vector.<UIChooseBtnImpl>();
			uiChooseKeMuPanel = new UIChooseKeMuPanel();
			addChild(uiChooseKeMuPanel);
		}

		public function initBtns(bookInfo:BookInfo, njIndex:String, choose_km:String):void {
			nianjiIndex = int(njIndex);
			var kemuObj:Object = ConfigManager.banbielist[njIndex];
			var i:int = 0;
			var marginTop:int = 135;
			var marginLeft:int = 70;
			for (var index:String in kemuObj) {
				var btn:UIChooseBtnImpl = new UIChooseBtnImpl(ConfigManager.baseInfo.subject[index], {index: index});
				btn.addEventListener(MouseEvent.CLICK, onClickHandler);
				btn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
				btn.x = marginLeft + i % 4 * (btn.width + 30);
				btn.y = marginTop + int(i / 4) * (btn.height + 30);
				var tt:String;
				if (choose_km != "") {
					tt = choose_km;
				} else {
					tt = bookInfo.subject;
				}
				if (tt == index) {
					activeBtn = btn;
					btn.gotoActive();
				}
				addChild(btn);
				btn.alpha = 0;
				btn.y += 10;
				TweenLite.to(btn, 0.3, {y:"-10", alpha: 1, delay: i * 0.1});
				btns.push(btn);
				i++;
			}
			uiChooseKeMuPanel.back_btn.addEventListener(MouseEvent.CLICK, onClickBackBtnEventHandler);
		}

		private function onClickBackBtnEventHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.UIChooseKeMuPanelEvent, {type: "back", njIndex: nianjiIndex}));
		}

		private function onClickHandler(e:MouseEvent):void {
			if (activeBtn) {
				activeBtn.gotoMouseOut();
			}
			var btn:UIChooseBtnImpl = e.currentTarget as UIChooseBtnImpl;
			btn.gotoActive();
			activeBtn = btn;
			dispatchEvent(new UIEvent(UIEvent.UIChooseKeMuPanelEvent, {type: "choose", kmIndex: activeBtn.getData().index, njIndex:nianjiIndex}));
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
