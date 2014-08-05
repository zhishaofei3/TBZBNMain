package UI {
	import data.BookMode;
	import data.ConfigManager;
	import data.infos.BookInfo;

	import events.UIEvent;

	import fl.data.DataProvider;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	import tbzb.ui.CenterBtns;
	import tbzb.ui.UITopToolbar;

	import utils.common.util.DisObjUtil;

	public class ToolBar extends Sprite {
		private var toolbar:UITopToolbar;
		private var btns:CenterBtns;

		private var huiToolBarContainer:Sprite;

		public function ToolBar() {
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onStage(e:Event):void {
			toolbar = new UITopToolbar();
			addChild(toolbar);
			btns = toolbar.centerBtns;
			btns.shuangye_btn.addEventListener(MouseEvent.CLICK, onShuangYeHandler);
			btns.danye_btn.addEventListener(MouseEvent.CLICK, onDanYeHandler);
			btns.fangda_btn.addEventListener(MouseEvent.CLICK, onFangDaHandler);
			btns.suoxiao_btn.addEventListener(MouseEvent.CLICK, onSuoXiaoHandler);
			btns.zuofanye_btn.addEventListener(MouseEvent.CLICK, onZuoFanYeBtnHandler);
			btns.yema_mc.addEventListener(MouseEvent.CLICK, onYeMaHandler);
			btns.youfanye_btn.addEventListener(MouseEvent.CLICK, onYouFanYeHandler);
			btns.quanping_btn.addEventListener(MouseEvent.CLICK, onQuanPingHandler);
			btns.tuichuquanpnig_btn.addEventListener(MouseEvent.CLICK, onTuiChuQuanPingHandler);
			btns.qishuTip_mc.visible = false;
			var tfm:TextFormat = new TextFormat();
			tfm.font = "simsun";
			tfm.size = 12;
			btns.qishu.height = btns.nianji.height = btns.kemu.height = btns.banben.height = 24;

			btns.qishu.focusEnabled = false;
			btns.nianji.focusEnabled = false;
			btns.kemu.focusEnabled = false;
			btns.banben.focusEnabled = false;
			btns.qishu.width = 115;
			btns.nianji.setStyle("textFormat", tfm);
			btns.nianji.dropdown.setRendererStyle("textFormat", tfm);
			btns.kemu.setStyle("textFormat", tfm);
			btns.kemu.dropdown.setRendererStyle("textFormat", tfm);
			btns.banben.setStyle("textFormat", tfm);
			btns.banben.dropdown.setRendererStyle("textFormat", tfm);
			btns.qishu.setStyle("textFormat", tfm);
			btns.qishu.dropdown.setRendererStyle("textFormat", tfm);

			huiToolBarContainer = new Sprite();
			toolbar.addChild(huiToolBarContainer);
		}

		public function resize():void {
			if (stage) {
				toolbar.toolbarBg.width = stage.stageWidth;
				toolbar.centerBtns.x = (stage.stageWidth - toolbar.centerBtns.width) / 2;
			}
		}

		private function onShuangYeHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "shuangye"}));
		}

		private function onDanYeHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "danye"}));
		}

		private function onFangDaHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "fangda"}));
		}

		private function onSuoXiaoHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "suoxiao"}));
		}

		private function onZuoFanYeBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "zuofanye"}));
		}

		private function onYeMaHandler(e:MouseEvent):void {
		}

		private function onYouFanYeHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "youfanye"}));
		}

		private function onQuanPingHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "quanping"}));
		}

		private function onTuiChuQuanPingHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.ToolBarEvent, {type: "tuichuquanping"}));
		}

		public function setQuanPingBtnVisible(b:Boolean):void {
			if (b) {
				btns.quanping_btn.visible = true;
				btns.tuichuquanpnig_btn.visible = false;
			} else {
				btns.quanping_btn.visible = false;
				btns.tuichuquanpnig_btn.visible = true;
			}
		}

		public function setPageTxt(s:String):void {
			btns.yema_mc.page_txt.text = s;
		}

		public function setModeBtnMode(s:String):void {
			btns.shuangye_btn.addEventListener(MouseEvent.CLICK, onShuangYeHandler);
			btns.danye_btn.addEventListener(MouseEvent.CLICK, onDanYeHandler);
			DisObjUtil.enable(btns.shuangye_btn);
			DisObjUtil.enable(btns.danye_btn);
			if (s == BookMode.DOUBLE) {
				btns.shuangye_btn.gotoAndStop(2);
				btns.danye_btn.gotoAndStop(1);
			} else if (s == BookMode.SINGLE) {
				btns.shuangye_btn.gotoAndStop(1);
				btns.danye_btn.gotoAndStop(2);
				if (TBZBNMain.nowpage < 0) {
					DisObjUtil.disable(btns.shuangye_btn);
					DisObjUtil.disable(btns.danye_btn);
					btns.shuangye_btn.removeEventListener(MouseEvent.CLICK, onShuangYeHandler);
					btns.danye_btn.removeEventListener(MouseEvent.CLICK, onDanYeHandler);
				}
			}
		}

		public function setFangDaBtnEnable(b:Boolean):void {
			if (b) {
				DisObjUtil.enable(btns.fangda_btn);
				btns.fangda_btn.addEventListener(MouseEvent.CLICK, onFangDaHandler);
			} else {
				DisObjUtil.disable(btns.fangda_btn);
				btns.fangda_btn.removeEventListener(MouseEvent.CLICK, onFangDaHandler);
			}
		}

		public function setSuoXiaoBtnEnable(b:Boolean):void {
			if (b) {
				DisObjUtil.enable(btns.suoxiao_btn);
				btns.suoxiao_btn.addEventListener(MouseEvent.CLICK, onSuoXiaoHandler);
			} else {
				DisObjUtil.disable(btns.suoxiao_btn);
				btns.suoxiao_btn.removeEventListener(MouseEvent.CLICK, onSuoXiaoHandler);
			}
		}

		public function setPrevBtnEnable(b:Boolean):void {
			if (b) {
				DisObjUtil.enable(btns.zuofanye_btn);
				btns.zuofanye_btn.addEventListener(MouseEvent.CLICK, onZuoFanYeBtnHandler);
			} else {
				DisObjUtil.disable(btns.zuofanye_btn);
				btns.zuofanye_btn.removeEventListener(MouseEvent.CLICK, onZuoFanYeBtnHandler);
			}
		}

		public function setNextBtnEnable(b:Boolean):void {
			if (b) {
				DisObjUtil.enable(btns.youfanye_btn);
				btns.youfanye_btn.addEventListener(MouseEvent.CLICK, onYouFanYeHandler);
			} else {
				DisObjUtil.disable(btns.youfanye_btn);
				btns.youfanye_btn.removeEventListener(MouseEvent.CLICK, onYouFanYeHandler);
			}
		}

		//期数
		public function updateQiShuList(issuelist:Object, s:String):void {
			var bookInfo:BookInfo = ConfigManager.bookInfo;
			var dp:DataProvider = new DataProvider();
			for (var i:String in issuelist) {
				var item:Object = issuelist[i];
				dp.addItem({year: item.year, num: item.num, data: i});
			}
			dp.sortOn(["year", "num"], Array.NUMERIC | Array.DESCENDING);
			btns.qishu.dataProvider = dp;
//			btns.qishu.prompt = bookInfo.year + "年第" + bookInfo.num + "期";
			btns.qishu.labelFunction = issueLabelFunction;
			btns.qishu.addEventListener(Event.CHANGE, onChangeQiShuHandler);

			if (s == "show") {
				btns.qishu.selectedIndex = 0;
				showQiushiTip();
			} else {
				btns.qishu.prompt = bookInfo.year + "年第" + bookInfo.num + "期";
			}
		}

		private function issueLabelFunction(item:Object):String {
			return item.year + "年第" + item.num + "期";
		}

		private function onChangeQiShuHandler(e:Event = null):void {
//			var host:String = ExternalInterface.call("function(){return location.host;}");
//			ExternalInterface.call("function(){window.location.href='http://" + host + "/swfEmbed?id=" + btns.qishu.selectedItem.data + "';}")
			ExternalInterface.call("function(){window.location.href='/swfEmbed?id=" + btns.qishu.selectedItem.data + "';}")
		}

		//年级
		public function updateNianjiList():void {
			var bookInfo:BookInfo = ConfigManager.bookInfo;
			var banbielist:Object = ConfigManager.banbielist;
			var dp:DataProvider = new DataProvider();
			for (var i:String in banbielist) {
				dp.addItem({index: i});
			}
			btns.nianji.dataProvider = dp;
			for (var j:int = 0; j < dp.length; j++) {
				if (dp.getItemAt(j).index == bookInfo.grade) {
					btns.nianji.selectedIndex = j;
					break;
				}
			}
			btns.nianji.labelFunction = nianjiLabelFunction;
			btns.nianji.addEventListener(Event.CHANGE, onChangeNianJiHandler);
		}

		private function nianjiLabelFunction(item:Object):String {
			return ConfigManager.baseInfo.grade[item.index];
		}

		private function onChangeNianJiHandler(e:Event):void {
			updateKemuList();
			updateBanbenList();
			ConfigManager.getQiCiList();
		}

		//科目 保留原来的
		public function updateKemuList():void {
			var bookInfo:BookInfo = ConfigManager.bookInfo;
			var banbielist:Object = ConfigManager.banbielist;
			var dp:DataProvider = new DataProvider();
			var nianjiSelectedItemIndex:String = btns.nianji.selectedItem.index;
			var kemuObj:Object = banbielist[nianjiSelectedItemIndex];
			for (var i:String in kemuObj) {
				dp.addItem({index: i});
			}

			var oldObj:Object = btns.kemu.selectedItem;
			btns.kemu.dataProvider = dp;
			var j:int;
			if (!oldObj) { //如果第一次进入（没有选择）
				for (j = 0; j < dp.length; j++) {
					if (dp.getItemAt(j).index == bookInfo.subject) {
						btns.kemu.selectedIndex = j;
						break;
					}
				}
			} else { //如果上次选择了，并且有，就用上次的结果
				var isChoose:Boolean;
				for (j = 0; j < dp.length; j++) {
					if (dp.getItemAt(j).index == oldObj.index) {
						btns.kemu.selectedIndex = j;
						isChoose = true;
						break;
					}
				}
				if (!isChoose) {
					btns.kemu.selectedIndex = 0;
				}
			}
			btns.kemu.labelFunction = kemuLabelFunction;
			btns.kemu.addEventListener(Event.CHANGE, onChangeKeMuHandler);
		}

		private function kemuLabelFunction(item:Object):String {
			return ConfigManager.baseInfo.subject[item.index];
		}

		private function onChangeKeMuHandler(e:Event):void {
			updateBanbenList();
			ConfigManager.getQiCiList();
		}

		public function updateBanbenList():void {
			var bookInfo:BookInfo = ConfigManager.bookInfo;
			var banbielist:Object = ConfigManager.banbielist;
			var dp:DataProvider = new DataProvider();
			var nianjiSelectedItemIndex:String = btns.nianji.selectedItem.index;
			var kemuSelectedItemIndex:String = btns.kemu.selectedItem.index;
			var banbenObj:Object = banbielist[nianjiSelectedItemIndex][kemuSelectedItemIndex];
			for (var s:String in banbenObj) {
				dp.addItem({index: banbenObj[s]});
			}

			var oldObj:Object = btns.banben.selectedItem;
			btns.banben.dataProvider = dp;
			var j:int;
			if (!oldObj) { //如果第一次进入（没有选择）
				for (j = 0; j < dp.length; j++) {
					if (dp.getItemAt(j).index == bookInfo.version) {
						btns.banben.selectedIndex = j;
						break;
					}
				}
			} else { //如果上次选择了，并且有，就用上次的结果
				var isChoose:Boolean;
				for (j = 0; j < dp.length; j++) {
					if (dp.getItemAt(j).index == oldObj.index) {
						btns.banben.selectedIndex = j;
						isChoose = true;
						break;
					}
				}
				if (!isChoose) {
					btns.banben.selectedIndex = 0;
				}
			}
			btns.banben.labelFunction = banbenLabelFunction;
			btns.banben.addEventListener(Event.CHANGE, onChangeBanBenHandler);
		}

		private function banbenLabelFunction(item:Object):String {
			return ConfigManager.baseInfo.version[item.index];
		}

		private function onChangeBanBenHandler(e:Event):void {
			ConfigManager.getQiCiList("show");
			stage.focus = stage;
		}

		public function showQiushiTip():void {
			btns.qishu.open();
			btns.qishu.addEventListener(Event.CLOSE, onQiShuCloseHandler);
			btns.qishuTip_mc.visible = true;
			btns.qishuTip_mc.ok_btn.addEventListener(MouseEvent.CLICK, onShowQishuOkBtnHandler);
			TBZBNMain.huiQita(true);
		}

		private function onShowQishuOkBtnHandler(e:MouseEvent):void {
			onChangeQiShuHandler();
			btns.qishuTip_mc.ok_btn.removeEventListener(MouseEvent.CLICK, onShowQishuOkBtnHandler);
			TBZBNMain.huiQita(false);
		}

		private function onQiShuCloseHandler(e:Event):void {
			TBZBNMain.huiQita(false);
			btns.qishu.removeEventListener(Event.CLOSE, onQiShuCloseHandler);
			setTimeout(function ():void {
				btns.qishuTip_mc.visible = false;
				btns.qishuTip_mc.ok_btn.removeEventListener(MouseEvent.CLICK, onShowQishuOkBtnHandler);
			}, 200);
		}

		public function getQianSanCombomBox():Object {
			return {
				gradeid: btns.nianji.selectedItem.index,
				subjectid: btns.kemu.selectedItem.index,
				versionid: btns.banben.selectedItem.index
			}
		}

		public function hui(b:Boolean):void {
			if (b) {
				var sp:Sprite = DisObjUtil.getNoneInteractiveBG(toolbar.toolbarBg.width, toolbar.toolbarBg.height, 0.2);
				huiToolBarContainer.addChild(sp);
			} else {
				DisObjUtil.removeAllChildren(huiToolBarContainer);
			}
		}
	}
}












