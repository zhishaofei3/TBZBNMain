package UI {
	import com.greensock.TweenLite;

	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import utils.common.util.DisObjUtil;

	public class SingleFlipClass extends Sprite {
		public var book_root:MovieClip;
		public var onLoadEnd:Function;
		public var onPageEnd:Function;
		public var bookInfo:BookInfo;

		private var book_width:Number;
		private var book_height:Number;
		private var page:Page;

		public var book_totalpage:Number;//总页数
		public var book_page:Number;//当前页

		private var status:String;

		private var py:Number;

		public function SingleFlipClass() {
			status = "loading";
			py = -1;
		}

		public function InitBook(w:Number, h:Number):void {
			book_width = w;
			book_height = h;
			book_totalpage = bookInfo.pageInfoList.length - 1;
			book_page = 0;
		}

		public function setSize(w:int, h:int):void {
			book_width = w;
			book_height = h;
			if (page) {
				page.update(w, h);
				if (page.y > 0) {
					page.y = 0;
				}
				if ((page.y - TBZBNMain.stage_height) < -h) {
					page.y = -h + TBZBNMain.stage_height - 50;
				}
			}
		}

		public function movePage(delta:int):void {
			if (status == "zhengchang") {
				page.y += delta * 15;
//				trace("page.y " + page.y);
//				trace("page.height " + page.height);
//				trace("book_root.height " + book_root.height);
//				trace("TBZBNMain.nowpage " + TBZBNMain.nowpage);
//				if (page.y > 0 && TBZBNMain.nowpage > 1) {
//					trace("上一页");
//					status = "loading";
//					dispatchEvent(new UIEvent(UIEvent.SingleFilpEvent, {type: "prev"}));
//					return;
//				} else if (((page.y - TBZBNMain.stage_height + 50) < (-book_root.height)) && (book_page < bookInfo.pageInfoList.length - 2)) {
//					trace("下一页");
//					status = "loading";
//					dispatchEvent(new UIEvent(UIEvent.SingleFilpEvent, {type: "next"}));
//					return;
//				}
				if (page.y > 0) {
					page.y = 0;
				}
				if ((page.y - TBZBNMain.stage_height + 50) < -book_root.height) {
					page.y = -book_root.height + TBZBNMain.stage_height - 50;
				}
			}
		}

		public function PageGoto(topage:Number):void {
			if (topage == -10) {
				book_page = -10;
			} else {
				if (topage < 1) {
					topage = 1;
				}
				if (topage > bookInfo.pageInfoList.length - 1) {
					topage = bookInfo.pageInfoList.length - 1;
				}
				book_page = topage;
			}
			pageUp();
		}

		private function pageUp():void {
			DisObjUtil.removeAllChildren(book_root);
			if (book_page == -10) {
				page = new Page(book_page, bookInfo.answer, book_width, book_height);
			} else {
				page = new Page(book_page, bookInfo.pageInfoList[book_page], book_width, book_height);
			}
			page.addEventListener(UIEvent.Page, onPageEventHandler);
			book_root.addChild(page);
			onPageEnd();
		}

		private function onPageEventHandler(e:UIEvent):void {
			var data:Object = e.data;
			switch (data.type) {
				case "loadProgress":
//					if (onLoading) {
//						onLoading(page, data.data.percentLoaded);
//					}
					break;
				case "loadComplete":
					if (Boolean(onLoadEnd)) {
//						onLoadEnd(data.data.mc);
						status = "zhengchang";
					}
					if (py != -1) {
						page.y = -book_root.height * py + (TBZBNMain.stage_height - 50) / 2;
						if (page.y > 0) {
							page.y = 0;
						}
						if ((page.y - TBZBNMain.stage_height) < -book_root.height) {
							page.y = -book_root.height + TBZBNMain.stage_height - 50;
						}
						py = -1;
					}
					break;
				case "doubleClick":
						dispatchEvent(new UIEvent(UIEvent.SingleFlipEvent, {type:"doubleClick"}));
					break;
				default :
					break;
			}
		}

		public function setVisible(b:Boolean):void {
			book_root.visible = b;
			if (b) {
				book_root.alpha = 0;
				TweenLite.to(book_root, 0.3, {alpha: 1});
			} else {
				book_root.alpha = 1;
				TweenLite.to(book_root, 0.3, {alpha: 0});
			}
		}

		public function setTargetY(_py:Number):void {
			py = _py;
		}

		public function moveUp():void {
			movePage(3);
		}

		public function moveDown():void {
			movePage(-3);
		}
	}
}
