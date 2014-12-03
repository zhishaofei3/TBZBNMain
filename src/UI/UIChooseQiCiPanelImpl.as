package UI {
	import com.greensock.TweenLite;

	import data.infos.BookInfo;

	import events.UIEvent;

	import fl.data.DataProvider;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextFormat;

	import tbzb.ui.UIChooseQiCiPanel;

	import utils.common.component.display.AbstractDisplayObject;

	public class UIChooseQiCiPanelImpl extends AbstractDisplayObject {
		private static var uiChooseQiciPanel:UIChooseQiCiPanel;
		private static var nianjiIndex:String;
		private static var kemuIndex:String;
		private static var banbenIndex:String;

		public function UIChooseQiCiPanelImpl() {
			uiChooseQiciPanel = new UIChooseQiCiPanel();
			uiChooseQiciPanel.tip.alpha = 0;
			addChild(uiChooseQiciPanel);
		}

		public function initBtns(bookInfo:BookInfo, issuelist:Object, data:Object):void {
			nianjiIndex = data.gradeid;
			kemuIndex = data.subjectid;
			banbenIndex = data.versionid;
			var dp:DataProvider = new DataProvider();
			for (var i:String in issuelist) {
				var item:Object = issuelist[i];
				dp.addItem({year: item.year, num: item.num, issuename:item.issuename, data: i});
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
			uiChooseQiciPanel.qici_combo.width = 160;
			uiChooseQiciPanel.qici_combo.dropdown.rowHeight = 28;
			uiChooseQiciPanel.tip.ok_btn.addEventListener(MouseEvent.CLICK, onClickOkBtnHandler);
			TweenLite.to(uiChooseQiciPanel.tip, 0.3, {alpha: 1, y: "-20"});
			uiChooseQiciPanel.back_btn.addEventListener(MouseEvent.CLICK, onClickBackBtnEventHandler);
		}

		private function onClickBackBtnEventHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.UIChooseQiCiPanelEvent, {type: "back", njIndex: nianjiIndex, kmIndex: kemuIndex, bbIndex: banbenIndex}));
		}

		private function labelFunction(item:Object):String {
			return item.issuename;
		}

		private function onChangeQiShuHandler(e:Event):void {
			ExternalInterface.call("flashCallJs", {type:"paperId", data:uiChooseQiciPanel.qici_combo.selectedItem.data});
//			ExternalInterface.call("function(){window.location.href='/paper-" + uiChooseQiciPanel.qici_combo.selectedItem.data + ".html';}")
		}

		public function comboxOpen():void {
			uiChooseQiciPanel.qici_combo.open();
		}

		private function onClickOkBtnHandler(e:MouseEvent):void {
			uiChooseQiciPanel.qici_combo.selectedIndex = 0;
			ExternalInterface.call("flashCallJs", {type:"paperId", data:uiChooseQiciPanel.qici_combo.selectedItem.data});
//			ExternalInterface.call("function(){window.location.href='/paper-" + uiChooseQiciPanel.qici_combo.selectedItem.data + ".html';}")
		}
	}
}
