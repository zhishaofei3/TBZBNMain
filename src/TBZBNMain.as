package {

	import UI.Bg;
	import UI.PageFlipClass;
	import UI.SingleFlipClass;
	import UI.ToolBar;
	import UI.UIChooseBanBenPanelImpl;
	import UI.UIChooseKeMuPanelImpl;
	import UI.UIChooseNianJiPanelImpl;
	import UI.UIChooseQiCiPanelImpl;

	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;

	import data.BookMode;
	import data.ConfigManager;
	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.ui.Keyboard;

	import scenes.LayerManager;

	import tbzb.ui.LeftFanYeBtn;
	import tbzb.ui.RightFanYeBtn;
	import tbzb.ui.UIDaanBtn;
	import tbzb.ui.UIDatiBtn;
	import tbzb.ui.UIZhoubaoBtn;

	import utils.common.util.DisObjUtil;

	[SWF(backgroundColor="0xF0F0F0", width=1000, height=600, frameRate="24")]
	public class TBZBNMain extends Sprite {
		private static var mypageflip:PageFlipClass;
		private static var singleflip:SingleFlipClass;
		public static var nowpage:int = 0;//当前页数 用于显示页数提示
		private static var b_width:Number;//图书的宽
		private static var b_height:Number;//图书的高
		private static var sb_width:Number;//单本图书的宽
		private static var sb_height:Number;//单本图书的高
		private static var book_container:MovieClip;
		private static var single_book_container:MovieClip;
		public static var stage_width:Number = 1000;//舞台宽(即时更新)
		public static var stage_height:Number = 600;//舞台高(即时更新)
		private static var bg:Bg;
		private static var toolBar:ToolBar;
		private static var datiBtn:UIDatiBtn;
		private static var zhoubaoBtn:UIZhoubaoBtn;
		private static var daanBtn:UIDaanBtn;
		private static var leftFanYeBtn:LeftFanYeBtn;
		private static var rightFanYeBtn:RightFanYeBtn;
		private static var huiContainer:Sprite;

		private static var DANYEKONGBAI:int = 210;//单页两边空白

		private static var canShowAnswer:Boolean;
		private static var fangdaxishu:int;//1 2 3

		public static var st:Stage;
		private static var _mode:String;
		public static var lastAD:Boolean;

		public function TBZBNMain() {
			trace("1234nihao");
			st = stage;
			TweenPlugin.activate([TransformAroundCenterPlugin, GlowFilterPlugin]);
			stage.align = StageAlign.TOP_LEFT;
			st.scaleMode = StageScaleMode.NO_SCALE;

			Security.allowDomain("*");
			Security.allowInsecureDomain("*");

			_mode = BookMode.DOUBLE;
			fangdaxishu = 1;

			var allContainer:Sprite = new Sprite();
			LayerManager.initView(allContainer);
			addChild(allContainer);

			ConfigManager.init();
		}

		public static function setBookConfig(bookInfo:BookInfo):void {
			stage_width = st.stageWidth;
			stage_height = st.stageHeight;

			bg = new Bg();
			LayerManager.bgContainer.addChild(bg);
			bg.resize();

			b_height = (stage_height - 50);
			b_width = b_height * 0.66;
			//书容器
			book_container = new MovieClip();
			book_container.x = (stage_width - 2 * b_width) / 2;
			book_container.y = 50;
			LayerManager.doubleBookContainer.addChild(book_container);

			sb_width = (stage_width - DANYEKONGBAI);
			sb_height = sb_width / 0.66;

			single_book_container = new MovieClip();
			single_book_container.x = (stage_width - sb_width) / 2;
			single_book_container.y = 50;
			LayerManager.singleBookContainer.addChild(single_book_container);

			//多页
			mypageflip = new PageFlipClass();//翻页控件
			mypageflip.book_root = book_container;//初始化书容器
			mypageflip.onLoadinit = onLoadinit;//开始加载调用函数
			mypageflip.onLoading = onLoading;//加载中调用函数
			mypageflip.onLoadEnd = onLoadEnd;//加载完成
			mypageflip.bookInfo = bookInfo;//设置图书xml
			//
			mypageflip.onPageEnd = onPageEnd;//翻页动作结束
			mypageflip.InitBook(b_width, b_height);
			mypageflip.addEventListener(UIEvent.PageFilpClassEvent, onPageFilpEventHandler);

			//单页
			singleflip = new SingleFlipClass();
			singleflip.book_root = single_book_container;
			singleflip.onLoadEnd = onLoadEnd;//加载完成
			singleflip.onPageEnd = onPageEnd;//翻页完成
			singleflip.bookInfo = bookInfo;//设置图书xml
			singleflip.InitBook(sb_width, sb_height);
			singleflip.setVisible(false);
			singleflip.addEventListener(UIEvent.SingleFlipEvent, onSingleFlipEventHandler);

			st.focus = st;
			st.addEventListener(Event.FULLSCREEN, onFullScreenEvent);
			st.addEventListener(Event.RESIZE, resizeHandler);
			st.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			st.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);

			datiBtn = new UIDatiBtn();
			datiBtn.addEventListener(MouseEvent.CLICK, onClickDatiHandler);
			LayerManager.btnsContainer.addChild(datiBtn);
			datiBtn.x = book_container.x + book_container.width + 20;
			datiBtn.y = 70;

			zhoubaoBtn = new UIZhoubaoBtn();
			zhoubaoBtn.addEventListener(MouseEvent.CLICK, onClickZhouBaoBtnHandler);
			zhoubaoBtn.visible = false;
			LayerManager.btnsContainer.addChild(zhoubaoBtn);
			zhoubaoBtn.x = book_container.x + book_container.width + 20;
			zhoubaoBtn.y = 70;

			daanBtn = new UIDaanBtn();
			daanBtn.addEventListener(MouseEvent.CLICK, onClickDaanBtnHandler);
			daanBtn.visible = false;
			LayerManager.btnsContainer.addChild(daanBtn);
			daanBtn.x = book_container.x + book_container.width + 20;
			daanBtn.y = 70;

			leftFanYeBtn = new LeftFanYeBtn();
			leftFanYeBtn.addEventListener(MouseEvent.CLICK, onClickLeftFanYeBtnHandler);
			LayerManager.btnsContainer.addChild(leftFanYeBtn);
			rightFanYeBtn = new RightFanYeBtn();
			rightFanYeBtn.addEventListener(MouseEvent.CLICK, onClickRightFanYeBtnHandler);
			LayerManager.btnsContainer.addChild(rightFanYeBtn);

			huiContainer = new Sprite();
			LayerManager.huiContainer.addChild(huiContainer);

			toolBar = new ToolBar();
			toolBar.addEventListener(UIEvent.ToolBarEvent, onToolBarEvent);
			LayerManager.toolBarContainer.addChild(toolBar);
			toolBar.resize();
			toolBar.initBookTxts();
			toolBar.setModeBtnMode(mode);
			toolBar.setSuoXiaoBtnEnable(false);

			leftFanYeBtn.x = book_container.x - leftFanYeBtn.width - 20;
			rightFanYeBtn.x = book_container.x + book_container.width + 20;
			leftFanYeBtn.y = rightFanYeBtn.y = (stage_height - 50 - leftFanYeBtn.height) / 2 + 50;

			refrushToolBar();
			ConfigManager.getBanBieList();//获取年级、科目、版本信息
		}

		private static function onClickZhouBaoBtnHandler(e:MouseEvent):void {
			showAnswer(false);
		}

		public static function onClickDaanBtnHandler(e:MouseEvent):void {
			showAnswer(true);
		}

		private static function onSingleFlipEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "doubleClick":
					if (mode == BookMode.DOUBLE) {
						return;
					}
					leftFanYeBtn.alpha = rightFanYeBtn.alpha = 1;
					setMode(BookMode.DOUBLE, nowpage);
					break;
				default :
					break;
			}
		}

		private static function onClickDatiHandler(e:MouseEvent):void {
			tuichuquanping();
			if (ConfigManager.userInfo) {
				datiBtn.visible = false;
				ExternalInterface.call("flashCallJs", {type: "dati", data: ConfigManager.userInfo});
			} else {
				ExternalInterface.call("flashCallJs", {type: "datiweidenglu"});
			}
		}

		private static function onPageFilpEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "click":
					var px:Number = e.data.px;
					var py:Number = e.data.py;
					var page:int = e.data.page;
					if (page > 0 && page <= mypageflip.book_totalpage - 1) {
						setMode(BookMode.SINGLE, page);
						singleflip.setTargetY(py);
					}
					break;
				default :
					break;
			}
		}

		private static function onMouseWheelHandler(e:MouseEvent):void {
			if (_mode == BookMode.SINGLE) {
				singleflip.movePage(e.delta);
			}
		}

		private static function onClickLeftFanYeBtnHandler(e:MouseEvent):void {
			fanye("zuo");
		}

		private static function onClickRightFanYeBtnHandler(e:MouseEvent):void {
			fanye("you");
		}

		private static function onToolBarEvent(e:UIEvent):void {
			switch (e.data.type) {
				case "shuangye":
					if (mode == BookMode.DOUBLE) {
						return;
					}
					leftFanYeBtn.alpha = rightFanYeBtn.alpha = 1;
					setMode(BookMode.DOUBLE, nowpage);
					break;
				case "danye":
					if (mode == BookMode.SINGLE) {
						return;
					}
					setMode(BookMode.SINGLE, nowpage);
					break;
				case "fangda":
					setFangDaSuoXiao("fangda");
					break;
				case "suoxiao":
					setFangDaSuoXiao("suoxiao");
					break;
				case "zuofanye":
					fanye("zuo");
					break;
				case "youfanye":
					fanye("you");
					break;
				case "quanping":
					quanping();
					break;
				case "tuichuquanping":
					tuichuquanping();
					break;
				case "genggaibanmian":
					genggaibanmian();
					break;
				default :
					break;
			}
		}

		private static function genggaibanmian():void {
			alertChooseNianjiPanel();
		}

		private static var chooseNianJiPanel:UIChooseNianJiPanelImpl;
		private static var chooseKeMuPanel:UIChooseKeMuPanelImpl;
		private static var chooseBanBenPanel:UIChooseBanBenPanelImpl;
		private static var chooseQiCiPanel:UIChooseQiCiPanelImpl;

		private static function alertChooseNianjiPanel(nj:String = ""):void {
			chooseNianJiPanel = new UIChooseNianJiPanelImpl();
			chooseNianJiPanel.initBtns(ConfigManager.bookInfo, ConfigManager.banbielist, nj);
			chooseNianJiPanel.addEventListener(UIEvent.UIChooseNianJiPanelEvent, onChoseNianJiPanelEventHandler);
			LayerManager.showTip(chooseNianJiPanel);
		}

		private static function onChoseNianJiPanelEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "choose":
					var njIndex:String = e.data.njIndex;
					LayerManager.hideTip();
					alertChooseKeMuPanel(njIndex);
					break;
				case "back":
					LayerManager.hideTip();
					break;
			}
		}

		public static function alertChooseKeMuPanel(njIndex:String, km:String = ""):void {
			chooseKeMuPanel = new UIChooseKeMuPanelImpl();
			chooseKeMuPanel.initBtns(ConfigManager.bookInfo, njIndex, km);
			chooseKeMuPanel.addEventListener(UIEvent.UIChooseKeMuPanelEvent, onChoseKeMuPanelEventHandler);
			LayerManager.showTip(chooseKeMuPanel);
		}

		private static function onChoseKeMuPanelEventHandler(e:UIEvent):void {
			var njIndex:String = "";
			switch (e.data.type) {
				case "choose":
					njIndex = e.data.njIndex;
					var kmIndex:String = e.data.kmIndex;
					LayerManager.hideTip();
					alertChooseBanBenPanel(njIndex, kmIndex);
					break;
				case "back":
					njIndex = e.data.njIndex;
					LayerManager.hideTip();
					alertChooseNianjiPanel(njIndex);
					break;
			}
		}

		private static function alertChooseBanBenPanel(njIndex:String, kmIndex:String, bb:String = ""):void {
			chooseBanBenPanel = new UIChooseBanBenPanelImpl();
			chooseBanBenPanel.initBtns(ConfigManager.bookInfo, njIndex, kmIndex, bb);
			chooseBanBenPanel.addEventListener(UIEvent.UIChooseBanBenPanelEvent, onChoseBanBenPanelEventHandler);
			LayerManager.showTip(chooseBanBenPanel);
		}

		private static function onChoseBanBenPanelEventHandler(e:UIEvent):void {
			var njIndex:String = "";
			var kmIndex:String = "";
			switch (e.data.type) {
				case "choose":
					var bbIndex:String = e.data.bbIndx;
					njIndex = e.data.njIndex;
					kmIndex = e.data.kmIndex;
					LayerManager.hideTip();
					ConfigManager.getQiCiList({gradeid: njIndex, subjectid: kmIndex, versionid: bbIndex}, "panel");
					chooseQiCiPanel = new UIChooseQiCiPanelImpl();
					LayerManager.showTip(chooseQiCiPanel);
					break;
				case "back":
					njIndex = e.data.njIndex;
					kmIndex = e.data.kmIndex;
					LayerManager.hideTip();
					alertChooseKeMuPanel(njIndex, kmIndex);
					break;
			}
		}

		private static function alertChooseQiCiPanelList(issuelist:Object, data:Object):void {
			chooseQiCiPanel.initBtns(ConfigManager.bookInfo, issuelist, data);
			chooseQiCiPanel.addEventListener(UIEvent.UIChooseQiCiPanelEvent, onChoseQiCiPanelEventHandler);
			chooseQiCiPanel.comboxOpen();
		}

		private static function onChoseQiCiPanelEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "back":
					var njIndex:String = e.data.njIndex;
					var kmIndex:String = e.data.kmIndex;
					var bbIndex:String = e.data.bbIndex;
					LayerManager.hideTip();
					alertChooseBanBenPanel(njIndex, kmIndex, bbIndex);
					break;
			}
		}

		private static function setFangDaSuoXiao(type:String):void {
			if (type == "fangda") {
				if (mode == BookMode.DOUBLE) {
					fangdaxishu = 1;
					setMode(BookMode.SINGLE, nowpage);
				} else if (fangdaxishu < 3) {
					fangdaxishu++;
				} else if (fangdaxishu == 3) {
					return;
				}
			} else if (type == "suoxiao") {
				if (mode == BookMode.DOUBLE) {
					return;
				} else if (mode == BookMode.SINGLE) {
					if (fangdaxishu == 1) {
						setMode(BookMode.DOUBLE, nowpage);
						return;
					} else if (fangdaxishu > 1) {
						fangdaxishu--;
					}
				}
			}

			leftFanYeBtn.alpha = rightFanYeBtn.alpha = 1;
			if (fangdaxishu == 1) {
				DANYEKONGBAI = 210;
			} else if (fangdaxishu == 2) {
				DANYEKONGBAI = 110;
				leftFanYeBtn.alpha = rightFanYeBtn.alpha = 0.7;
			} else if (fangdaxishu == 3) {
				DANYEKONGBAI = 30;
				leftFanYeBtn.alpha = rightFanYeBtn.alpha = 0.7;
			}
			resizeHandler();
			refrushToolBar();
		}

		private static function onFullScreenEvent(e:FullScreenEvent):void {
			if (e.fullScreen) {
				toolBar.setQuanPingBtnVisible(false);
			} else {
				toolBar.setQuanPingBtnVisible(true);
			}
		}

		private static function quanping():void {
			st.displayState = StageDisplayState.FULL_SCREEN;
		}

		private static function tuichuquanping():void {
			st.displayState = StageDisplayState.NORMAL;
		}

		private static function onKeyDownHandler(e:KeyboardEvent):void {
			if (nowpage < 0) {
				return;
			}
			if (e.keyCode == Keyboard.RIGHT) {
				if (mode == BookMode.DOUBLE) {
					fanye("zuo");
				} else if (mode == BookMode.SINGLE) {
					fanye("you");
				}
			} else if (e.keyCode == Keyboard.LEFT) {
				if (mode == BookMode.DOUBLE) {
					fanye("you");
				} else if (mode == BookMode.SINGLE) {
					fanye("zuo");
				}
			} else if (e.keyCode == Keyboard.UP) {
				if (mode == BookMode.SINGLE) {
					singleflip.moveUp();
				}
			} else if (e.keyCode == Keyboard.DOWN) {
				if (mode == BookMode.SINGLE) {
					singleflip.moveDown();
				}
			} else if (e.keyCode == Keyboard.SPACE) {
				if (mode == BookMode.SINGLE) {
					setMode(BookMode.DOUBLE, nowpage);
				} else {
					setMode(BookMode.SINGLE, nowpage);
				}
			}
		}

		private static function fanye(fangxiang:String):void {
			if (mode == BookMode.DOUBLE) {
				if (fangxiang == "zuo") {
					if (nowpage >= 2) {
						nowpage -= 2;
					}
				} else {
					if (nowpage <= mypageflip.book_totalpage - 2) {
						nowpage += 2;
					}
//					if (!ConfigManager.userInfo) {//没登录 只能看一半
//						if (nowpage >= Math.ceil(mypageflip.book_totalpage / 2)) {
//							nowpage -= 2;
//							ExternalInterface.call("flashCallJs", {type: "yibanweidenglu"});
//							return;
//						}
//					}
				}
				mypageflip.PageGoto(nowpage);
			} else if (mode == BookMode.SINGLE) {
				if (fangxiang == "zuo") {
					if (nowpage > 1) {
						nowpage--;
						singleflip.PageGoto(nowpage);
					}
				} else {
					if (nowpage <= mypageflip.book_totalpage - 2) {
						nowpage++;
//						if (!ConfigManager.userInfo) {//没登录 只能看一半
//							if (nowpage >= Math.ceil(mypageflip.book_totalpage / 2)) {
//								nowpage--;
//								ExternalInterface.call("flashCallJs", {type: "yibanweidenglu"});
//								return;
//							}
//						}
						singleflip.PageGoto(nowpage);
					}
				}
			}
			refrushToolBar();
		}

		private static function resizeHandler(e:Event = null):void {
			b_height = (st.stageHeight - 50);
			b_width = b_height * 0.66;

			stage_width = st.stageWidth;
			stage_height = st.stageHeight;
			book_container.x = (stage_width - 2 * b_width) / 2;
			book_container.y = 50;

			sb_width = (stage_width - DANYEKONGBAI);
			if (sb_width < 700) {
				sb_width = 700;//设置最小宽度
			}
			sb_height = sb_width / 0.66;
			single_book_container.x = (stage_width - sb_width) / 2;
			single_book_container.y = 50;

			mypageflip.setSize(b_width, b_height);
			singleflip.setSize(sb_width, sb_height);

			bg.resize();
			toolBar.resize();

			if (mode == BookMode.DOUBLE) {
				leftFanYeBtn.x = book_container.x - leftFanYeBtn.width - 20;
				rightFanYeBtn.x = book_container.x + book_container.width + 20;
				datiBtn.x = book_container.x + book_container.width + 20;
				zhoubaoBtn.x = book_container.x + book_container.width + 20;
				daanBtn.x = book_container.x + book_container.width + 20;
			} else if (mode == BookMode.SINGLE) {
				leftFanYeBtn.x = 10;
				rightFanYeBtn.x = stage_width - rightFanYeBtn.width - 10;
				datiBtn.x = stage_width - datiBtn.width - 20;
				zhoubaoBtn.x = stage_width - datiBtn.width - 20;
				daanBtn.x = stage_width - datiBtn.width - 20;
			}
			leftFanYeBtn.y = rightFanYeBtn.y = (stage_height - 50 - leftFanYeBtn.height) / 2 + 50;
		}

		//开始加载时调用的函数
		private static function onLoadinit(pageMC:MovieClip):void {
			var loadMC:Loadmc = new Loadmc();
			if (pageMC.isWidthPage) {
				var tmpMC:MovieClip = pageMC.brotherMC;
				tmpMC.loadmc["bg"].width = b_width + b_width;
				tmpMC.loadmc["bg"].height = b_height;
				tmpMC.loadmc.x = b_width;
				tmpMC.loadmc.y = b_height * 0.5;
			}
			loadMC.bg.width = b_width;
			loadMC.bg.height = b_height;
			loadMC.x = b_width * 0.5;
			loadMC.y = b_height * 0.5;

			pageMC.loadmc = loadMC;
			pageMC.addChild(loadMC);
		}

		//加载过程中调用的函数
		private static function onLoading(pageMC:MovieClip, loadedPercent:Number):void {
			pageMC.loadmc.pText.text = loadedPercent;
		}

		//加载完毕后调用的函数
		private static function onLoadEnd(pageMC:MovieClip):void {
			pageMC.removeChild(pageMC.loadmc);
		}

		//翻页完成后调用的函数
		private static function onPageEnd():void {
			if (mode == BookMode.DOUBLE) {
				nowpage = mypageflip.book_page;
			} else if (mode == BookMode.SINGLE) {
				nowpage = singleflip.book_page;
			}
			refrushToolBar();
			if (nowpage > 0) {
				ExternalInterface.call("flashCallJs", {type: "fanye", data: nowpage});
			}
		}

		public static function refrushToolBar():void {
			var pageString:String;
			if (mode == BookMode.DOUBLE) {
				var leftPageNum:String = (mypageflip.book_page == 0) ? "" : String(mypageflip.book_page);
				var rightPageNum:String = (mypageflip.book_page + 1) > (mypageflip.book_totalpage - 1) ? "" : String(mypageflip.book_page + 1);
				if (leftPageNum == "") {
					pageString = rightPageNum + "/" + (mypageflip.book_totalpage - 1);
				} else if (rightPageNum == "") {
					pageString = leftPageNum + "/" + (mypageflip.book_totalpage - 1);
				} else {
					pageString = leftPageNum + "-" + rightPageNum + "/" + (mypageflip.book_totalpage - 1);
				}
				toolBar.setPrevBtnEnable(mypageflip.book_page != 0);
				toolBar.setNextBtnEnable(mypageflip.book_page != (mypageflip.book_totalpage - 1));
				if (mypageflip.book_page != 0) {
					DisObjUtil.enable(leftFanYeBtn);
				} else {
					DisObjUtil.disable(leftFanYeBtn);
				}
				if (mypageflip.book_page != (mypageflip.book_totalpage - 1)) {
					DisObjUtil.enable(rightFanYeBtn);
				} else {
					DisObjUtil.disable(rightFanYeBtn);
				}
			} else if (mode == BookMode.SINGLE) {
				if (nowpage < 0) {
					toolBar.setPrevBtnEnable(false);
					toolBar.setNextBtnEnable(false);
					DisObjUtil.disable(leftFanYeBtn);
					DisObjUtil.disable(rightFanYeBtn);
					pageString = "答案";
				} else {
					pageString = nowpage + "/" + (mypageflip.book_totalpage - 1);
					toolBar.setPrevBtnEnable(nowpage != 1);
					toolBar.setNextBtnEnable(nowpage != (mypageflip.book_totalpage - 1));
					if (nowpage != 1) {
						DisObjUtil.enable(leftFanYeBtn);
					} else {
						DisObjUtil.disable(leftFanYeBtn);
					}
					if (nowpage != (mypageflip.book_totalpage - 1)) {
						DisObjUtil.enable(rightFanYeBtn);
					} else {
						DisObjUtil.disable(rightFanYeBtn);
					}
				}
			}
			toolBar.setPageTxt(pageString);

			if (mode == BookMode.DOUBLE) {
				toolBar.setFangDaBtnEnable(true);
				toolBar.setSuoXiaoBtnEnable(false);
			} else if (mode == BookMode.SINGLE) {
				toolBar.setSuoXiaoBtnEnable(true);
				toolBar.setFangDaBtnEnable(true);
				if (fangdaxishu == 1 && nowpage < 0) {
					toolBar.setSuoXiaoBtnEnable(false);
				}
				if (fangdaxishu == 3) {
					toolBar.setFangDaBtnEnable(false);
				}
			}
		}

		public static function get mode():String {
			return _mode;
		}

		public static function setMode(value:String, page:int):void {
			_mode = value;
			if (_mode == BookMode.DOUBLE) {
				singleflip.setVisible(false);
				mypageflip.setVisible(true);
				mypageflip.PageGoto(page);
			} else if (_mode == BookMode.SINGLE) {
				singleflip.setVisible(true);
				mypageflip.setVisible(false);
				singleflip.PageGoto(page);
			}
			toolBar.setModeBtnMode(_mode);
			refrushToolBar();
			resizeHandler();
		}

		public static function getQiCiList(issuelist:Object, type:String, data:Object):void {
			if (type == "toolbar") {
				toolBar.updateQiCiList(issuelist, data);
			} else if (type == "panel") {
				alertChooseQiCiPanelList(issuelist, data);
			}
		}

		public static function hui(b:Boolean):void {
			if (b) {
				if (huiContainer.numChildren == 0) {
					var sp:Sprite = DisObjUtil.getNoneInteractiveBG(stage_width, stage_height, 0.5);
					sp.name = "stagehui";
					huiContainer.addChild(sp);
				}
			} else {
				DisObjUtil.removeAllChildren(huiContainer);
			}
		}

		public static function huiToolBar(b:Boolean):void {
			toolBar.hui(b);
		}

		public static function showAnswer(b:Boolean):void {
			if (b) {
				canShowAnswer = true;
				nowpage = -10;
				zhoubaoBtn.visible = true;
				daanBtn.visible = false;
			} else {
				nowpage = 1;
				zhoubaoBtn.visible = false;
				daanBtn.visible = true;
			}
			setMode(BookMode.SINGLE, nowpage);
		}

		public static function showDatiBtn():void {
			datiBtn.visible = true;
		}

	}
}
