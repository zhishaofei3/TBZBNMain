package UI {
	import data.infos.PageInfo;

	import events.UIEvent;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;

	public class Page extends Sprite {
		private var id:int;
		private var pageInfo:PageInfo;
		private var w:Number;
		private var h:Number;

		private var smallImgLoader:Loader;
		private var bigImgLoader:Loader;

		private var smallImgBmp:Bitmap;
		private var bigImgBmp:Bitmap;

		public function Page(_id:int, _pageInfo:PageInfo, _w:Number, _h:Number) {
			id = _id;
			pageInfo = _pageInfo;
			w = _w;
			h = _h;
			loadSmallImg();
			loadBigImg();
			addEventListener(MouseEvent.CLICK, onClickPageHandler);
			doubleClickEnabled = true;
			mouseEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickHandler);
		}

		private function onClickPageHandler(e:MouseEvent):void {
			var pX:Number = e.currentTarget.mouseX / this.width;
			var pY:Number = e.currentTarget.mouseY / this.height;
			dispatchEvent(new UIEvent(UIEvent.Page, {type: "click", px: pX, py: pY, page: id}));
		}

		private function loadSmallImg():void {
			smallImgLoader = new Loader();
			smallImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSmallCompleteHandler);
			if (Security.sandboxType == Security.LOCAL_TRUSTED) {
				smallImgLoader.load(new URLRequest(pageInfo.smallURL));
			} else {
				var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
				smallImgLoader.load(new URLRequest(pageInfo.smallURL), context);
			}
		}

		private function onLoadSmallCompleteHandler(e:Event):void {
			smallImgBmp = e.target.content;
			smallImgBmp.width = w;
			smallImgBmp.height = h;
			smallImgBmp.smoothing = true;
			addChild(smallImgBmp);
			pageInfo.smallImgBmp = smallImgBmp;
			smallImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadSmallCompleteHandler);
		}

		public function update(_w:Number, _h:Number):void {
			w = _w;
			h = _h;
			if (bigImgBmp) {
				bigImgBmp.width = w;
				bigImgBmp.height = h;
			}
			if (smallImgBmp) {
				smallImgBmp.width = w;
				smallImgBmp.height = h;
			}
		}

		private function loadBigImg():void {
			bigImgLoader = new Loader();
			bigImgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadBigProgressHandler);
			bigImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBigCompleteHandler);
			if (Security.sandboxType == Security.LOCAL_TRUSTED) {
				bigImgLoader.load(new URLRequest(pageInfo.bigURL));
			} else {
				var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
				bigImgLoader.load(new URLRequest(pageInfo.bigURL), context);
			}
		}

		private function onLoadBigProgressHandler(e:ProgressEvent):void {
			var percentLoaded:Number = Math.round(e.bytesLoaded / e.bytesTotal * 100);
			dispatchEvent(new UIEvent(UIEvent.Page, {type: "loadProgress", data: {id: id, percentLoaded: percentLoaded}}));
		}

		private function onLoadBigCompleteHandler(e:Event):void {
			e.target.removeEventListener(ProgressEvent.PROGRESS, onLoadBigProgressHandler);
			e.target.removeEventListener(Event.COMPLETE, onLoadBigCompleteHandler);
			bigImgBmp = e.target.content;
			bigImgBmp.width = w;
			bigImgBmp.height = h;
			bigImgBmp.smoothing = true;
			addChild(bigImgBmp);

			//移除小图
			smallImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadSmallCompleteHandler);
			if (smallImgBmp && contains(smallImgBmp)) {
				removeChild(smallImgBmp);
			}
			pageInfo.bigImgBmp = bigImgBmp;

			if (parent) {
				var mc:MovieClip = this.parent as MovieClip;//book_root["pload_" + i]
				mc.loadedtype = e.target.contentType;
				mc.loadedflag = true;
				if (mc.loadedtype == "application/x-shockwave-flash") {
					var tmpPageMC:MovieClip = mc.loader.content;
					if (mc.parent == null) {
						tmpPageMC.gotoAndStop(1);
					} else {
						tmpPageMC.gotoAndPlay(2);
					}
				}
				dispatchEvent(new UIEvent(UIEvent.Page, {type: "loadComplete", data: {id: id, mc: mc}}));
			}
		}

		private function onDoubleClickHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.Page, {type: "doubleClick"}));
		}
	}
}
