package UI {
	import com.greensock.TweenLite;

	import data.infos.BookInfo;

	import fl.data.DataProvider;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextFormat;

	import tbzb.ui.UIChooseQiCiPanel;

	import utils.common.component.display.AbstractDisplayObject;

	public class UIChooseQiCiPanelImpl extends AbstractDisplayObject {
		private static var uiChooseQiciPanel:UIChooseQiCiPanel;

		public function UIChooseQiCiPanelImpl() {
			uiChooseQiciPanel = new UIChooseQiCiPanel();
			uiChooseQiciPanel.tip.alpha = 0;
			addChild(uiChooseQiciPanel);
		}

		public function initBtns(bookInfo:BookInfo, issuelist:Object):void {
			var dp:DataProvider = new DataProvider();
			for (var i:String in issuelist) {
				var item:Object = issuelist[i];
				dp.addItem({year: item.year, num: item.num, data: i});
			}
			dp.sortOn(["year", "num"], Array.NUMERIC | Array.DESCENDING);

			uiChooseQiciPanel.qici_combo.tabEnabled = false;
			uiChooseQiciPanel.qici_combo.prompt = "请选择期数";
			uiChooseQiciPanel.qici_combo.dataProvider = dp;
			uiChooseQiciPanel.qici_combo.labelFunction = labelFunction;
			uiChooseQiciPanel.qici_combo.addEventListener(Event.CHANGE, onChangeQiShuHandler);

			var tfm:TextFormat = new TextFormat();
			tfm.font = "simsun";
			tfm.size = 12;
			uiChooseQiciPanel.qici_combo.setStyle("textFormat", tfm);
			uiChooseQiciPanel.qici_combo.dropdown.setRendererStyle("height", 200);
			uiChooseQiciPanel.qici_combo.dropdown.setRendererStyle("textFormat", tfm);
			uiChooseQiciPanel.qici_combo.dropdown.rowHeight = 28;
			uiChooseQiciPanel.tip.ok_btn.addEventListener(MouseEvent.CLICK, onClickOkBtnHandler);
			TweenLite.to(uiChooseQiciPanel.tip, 0.6, {alpha: 1, y: "-20"});
		}

		private function labelFunction(item:Object):String {
			return item.year + "年第" + item.num + "期";
		}

		private function onChangeQiShuHandler(e:Event):void {
			ExternalInterface.call("function(){window.location.href='/swfEmbed?id=" + uiChooseQiciPanel.qici_combo.selectedItem.data + "';}")
		}

		public function comboxOpen():void {
			uiChooseQiciPanel.qici_combo.open();
		}

		private function onClickOkBtnHandler(e:MouseEvent):void {
			uiChooseQiciPanel.qici_combo.selectedIndex = 0;
			ExternalInterface.call("function(){window.location.href='/swfEmbed?id=" + uiChooseQiciPanel.qici_combo.selectedItem.data + "';}")
		}
	}
}