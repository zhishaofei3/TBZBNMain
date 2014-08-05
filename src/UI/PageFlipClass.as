package UI {
	import com.greensock.TweenLite;

	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class PageFlipClass extends EventDispatcher {
		//可设置或可调用接口,页数以单页数计算~---------------------------------------
		public var bookInfo:BookInfo;
		public var book_root:MovieClip;//装载book的MC
		public var book_totalpage:Number;//总页数
		public var book_TimerNum:Number = 30;//Timer的间隔时间
		public var book_page:Number;//当前页
		public var onLoadinit:Function = null;//加载外部影片或图片时调用
		public var onLoading:Function = null;//正在加载外部影片或图片时调用
		public var onLoadEnd:Function = null;//加载外部影片或图片完毕时调用
		public var onPageEnd:Function = null;   //翻页动作结束时调用
		//PageGoto:Function;//翻页跳转
		//PageDraw:Function;//绘制缩略图
		//InitBook:Function;//初始化
		//END!!--------------------------------------------------------------------

		public var book_width:Number;
		public var book_height:Number;
		private var book_topage:Number;

		private var book_CrossGap:Number;
		private var bookArray_layer1:Array;
		private var bookArray_layer2:Array;

		private var book_TimerFlag:String = "stop";
		private var book_TimerArg0:Number = 0;
		private var book_TimerArg1:Number = 0;
		private var u:Number;
		private var book_px:Number = 0;
		private var book_py:Number = 0;
		private var book_toposArray:Array;
		private var book_myposArray:Array;
		private var book_timer:Timer;

		private var Bmp0:BitmapData;
		private var Bmp1:BitmapData;
		private var bgBmp0:BitmapData;
		private var bgBmp1:BitmapData;

		private var pageMC:Sprite = new Sprite();
		private var bgMC:Sprite = new Sprite();

		private var render0:Shape = new Shape();
		private var render1:Shape = new Shape();
		private var shadow0:Shape = new Shape();
		private var shadow1:Shape = new Shape();

		private var Mask0:Shape = new Shape();
		private var Mask1:Shape = new Shape();

		private var p1:Point;
		private var p2:Point;
		private var p3:Point;
		private var p4:Point;

		private var limit_point1:Point;
		private var limit_point2:Point;

		//**init Parts------------------------------------------------------------------------
		public function InitBook(w:Number, h:Number):void {
			book_width = w;
			book_height = h;
			book_totalpage = bookInfo.pageInfoList.length - 1;
			book_page = book_topage = 0;
			book_CrossGap = Math.sqrt(book_width * book_width + book_height * book_height);

			p1 = new Point(0, 0);
			p2 = new Point(0, book_height);
			p3 = new Point(book_width + book_width, 0);
			p4 = new Point(book_width + book_width, book_height);

			limit_point1 = new Point(book_width, 0);
			limit_point2 = new Point(book_width, book_height);

			book_toposArray = [p3, p4, p1, p2];
			book_myposArray = [p1, p2, p3, p4];

			book_root.addChild(pageMC);
			book_root.addChild(bgMC);
//			SeFilter(pageMC);
//			SeFilter(bgMC);

			book_root.addChild(Mask0);
			book_root.addChild(Mask1);

			book_root.addChild(render0);
			book_root.addChild(shadow0);
			book_root.addChild(render1);
			book_root.addChild(shadow1);

			SetLoadMC();
			SetPageMC(book_page);
			book_timer = new Timer(book_TimerNum, 0);
//			book_root.stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseOnDown);
//			book_root.stage.addEventListener(MouseEvent.MOUSE_UP, MouseOnUp);
			book_timer.addEventListener(TimerEvent.TIMER, bookTimerHandler);
		}

		public function setSize(w:int, h:int):void {
			this.book_width = w;
			this.book_height = h;
			this.book_CrossGap = Math.sqrt(this.book_width * this.book_width + this.book_height * this.book_height);
			this.p1.x = 0;
			this.p1.y = 0;
			this.p2.x = 0;
			this.p2.y = this.book_height;
			this.p3.x = this.book_width * 2;
			this.p3.y = 0;
			this.p4.x = this.book_width * 2;
			this.p4.y = this.book_height;
			this.limit_point1.x = this.book_width;
			this.limit_point1.y = 0;
			this.limit_point2.x = this.book_width;
			this.limit_point2.y = this.book_height;
			this.book_toposArray = [this.p3, this.p4, this.p1, this.p2];
			this.book_myposArray = [this.p1, this.p2, this.p3, this.p4];
			for (var i:int = 0; i <= book_totalpage; i++) {
				Page(book_root["pload_" + i].page).update(w, h);
			}
			if (book_root["pload_" + (book_page + 1)]) {
				book_root["pload_" + (book_page + 1)].x = book_width;
			}
		}

		//End init------------------------------------------------------------------------

		//**DrawPage Parts------------------------------------------------------------------------
		private function DrawPage(num:Number, _movePoint:Point, bmp1:BitmapData, bmp2:BitmapData):void {
			//var _movePoint:Point=new Point(mouseX,mouseY);
			var _actionPoint:Point;

			var book_array:Array;
			var book_Matrix1:Matrix = new Matrix();
			var book_Matrix2:Matrix = new Matrix();
			var Matrix_angle:Number;

			if (num == 1) {
				_movePoint = CheckLimit(_movePoint, limit_point1, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point2, book_CrossGap);

				book_array = GetBook_array(_movePoint, p1, p2);
				_actionPoint = book_array[1];
				GeLayer_array(_movePoint, _actionPoint, p1, p2, limit_point1, limit_point2);

				DrawShadowShap(shadow0, Mask0, book_width * 1.5, book_height * 4, p1, _movePoint, [p1, p3, p4, p2], 0.5);
				DrawShadowShap(shadow1, Mask1, book_width * 1.5, book_height * 4, p1, _movePoint, bookArray_layer1, 0.45);

				Matrix_angle = angle(_movePoint, _actionPoint) + 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = book_array[3].x;
				book_Matrix1.ty = book_array[3].y;

				book_Matrix2.tx = p1.x;
				book_Matrix2.ty = p1.y;
			} else if (num == 2) {
				_movePoint = CheckLimit(_movePoint, limit_point2, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point1, book_CrossGap);

				book_array = GetBook_array(_movePoint, p2, p1);
				_actionPoint = book_array[1];
				GeLayer_array(_movePoint, _actionPoint, p2, p1, limit_point2, limit_point1);

				DrawShadowShap(shadow0, Mask0, book_width * 1.5, book_height * 4, p2, _movePoint, [p1, p3, p4, p2], 0.5);
				DrawShadowShap(shadow1, Mask1, book_width * 1.5, book_height * 4, p2, _movePoint, bookArray_layer1, 0.45);

				Matrix_angle = angle(_movePoint, _actionPoint) - 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = book_array[2].x;
				book_Matrix1.ty = book_array[2].y;

				book_Matrix2.tx = p1.x;
				book_Matrix2.ty = p1.y;
			} else if (num == 3) {
				_movePoint = CheckLimit(_movePoint, limit_point1, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point2, book_CrossGap);

				book_array = GetBook_array(_movePoint, p3, p4);
				_actionPoint = book_array[1];
				GeLayer_array(_movePoint, _actionPoint, p3, p4, limit_point1, limit_point2);

				DrawShadowShap(shadow0, Mask0, book_width * 1.5, book_height * 4, p3, _movePoint, [p1, p3, p4, p2], 0.5);
				DrawShadowShap(shadow1, Mask1, book_width * 1.5, book_height * 4, p3, _movePoint, bookArray_layer1, 0.4);

				Matrix_angle = angle(_movePoint, _actionPoint) + 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = _movePoint.x;
				book_Matrix1.ty = _movePoint.y;

				book_Matrix2.tx = limit_point1.x;
				book_Matrix2.ty = limit_point1.y;
			} else {
				_movePoint = CheckLimit(_movePoint, limit_point2, book_width);
				_movePoint = CheckLimit(_movePoint, limit_point1, book_CrossGap);

				book_array = GetBook_array(_movePoint, p4, p3);
				_actionPoint = book_array[1];
				GeLayer_array(_movePoint, _actionPoint, p4, p3, limit_point2, limit_point1);

				DrawShadowShap(shadow0, Mask0, book_width * 1.5, book_height * 4, p4, _movePoint, [p1, p3, p4, p2], 0.5);
				DrawShadowShap(shadow1, Mask1, book_width * 1.5, book_height * 4, p4, _movePoint, bookArray_layer1, 0.4);

				Matrix_angle = angle(_movePoint, _actionPoint) - 90;
				book_Matrix1.rotate((Matrix_angle / 180) * Math.PI);
				book_Matrix1.tx = _actionPoint.x;
				book_Matrix1.ty = _actionPoint.y;

				book_Matrix2.tx = limit_point1.x;
				book_Matrix2.ty = limit_point1.y;
			}
			//trace(bookArray_layer2)
			DrawShape(render1, bookArray_layer1, bmp1, book_Matrix1);
			DrawShape(render0, bookArray_layer2, bmp2, book_Matrix2);
		}

		private function CheckLimit($point:Point, $limitPoint:Point, $limitGap:Number):Point {
			var $Gap:Number = Math.abs(pos($limitPoint, $point));
			var $Angle:Number = angle($limitPoint, $point);
			if ($Gap > $limitGap) {
				var $tmp1:Number = $limitGap * Math.sin(($Angle / 180) * Math.PI);
				var $tmp2:Number = $limitGap * Math.cos(($Angle / 180) * Math.PI);
				$point = new Point($limitPoint.x - $tmp2, $limitPoint.y - $tmp1);
			}
			return $point;
		}

		private function GetBook_array($point:Point, $actionPoint1:Point, $actionPoint2:Point):Array {
			var array_return:Array = [];
			var $Gap1:Number = Math.abs(pos($actionPoint1, $point) * 0.5);
			var $Angle1:Number = angle($actionPoint1, $point);
			var $tmp1_2:Number = $Gap1 / Math.cos(($Angle1 / 180) * Math.PI);
			var $tmp_point1:Point = new Point($actionPoint1.x - $tmp1_2, $actionPoint1.y);

			var $Angle2:Number = angle($point, $tmp_point1) - angle($point, $actionPoint2);
			var $Gap2:Number = pos($point, $actionPoint2);
			var $tmp2_1:Number = $Gap2 * Math.sin(($Angle2 / 180) * Math.PI);
			var $tmp2_2:Number = $Gap2 * Math.cos(($Angle2 / 180) * Math.PI);
			var $tmp_point2:Point = new Point($actionPoint1.x + $tmp2_2, $actionPoint1.y + $tmp2_1);

			var $Angle3:Number = angle($tmp_point1, $point);
			var $tmp3_1:Number = book_width * Math.sin(($Angle3 / 180) * Math.PI);
			var $tmp3_2:Number = book_width * Math.cos(($Angle3 / 180) * Math.PI);

			var $tmp_point3:Point = new Point($tmp_point2.x + $tmp3_2, $tmp_point2.y + $tmp3_1);
			var $tmp_point4:Point = new Point($point.x + $tmp3_2, $point.y + $tmp3_1);

			array_return.push($point);
			array_return.push($tmp_point2);
			array_return.push($tmp_point3);
			array_return.push($tmp_point4);

			return array_return;
		}

		private function GeLayer_array($point1:Point, $point2:Point, $actionPoint1:Point, $actionPoint2:Point, $limitPoint1:Point, $limitPoint2:Point):void {
			var array_layer1:Array = [];
			var array_layer2:Array = [];
			var $Gap1:Number = Math.abs(pos($actionPoint1, $point1) * 0.5);
			var $Angle1:Number = angle($actionPoint1, $point1);

			var $tmp1_1:Number = $Gap1 / Math.sin(($Angle1 / 180) * Math.PI);
			var $tmp1_2:Number = $Gap1 / Math.cos(($Angle1 / 180) * Math.PI);

			var $tmp_point1:Point = new Point($actionPoint1.x - $tmp1_2, $actionPoint1.y);
			var $tmp_point2:Point = new Point($actionPoint1.x, $actionPoint1.y - $tmp1_1);

			var $tmp_point3:Point = $point2;

			var $Gap2:Number = Math.abs(pos($point1, $actionPoint2));
			//---------------------------------------------
			if ($Gap2 > book_height) {
				array_layer1.push($tmp_point3);
				//
				var $pos:Number = Math.abs(pos($tmp_point3, $actionPoint2) * 0.5);
				var $tmp3:Number = $pos / Math.cos(($Angle1 / 180) * Math.PI);
				$tmp_point2 = new Point($actionPoint2.x - $tmp3, $actionPoint2.y);

			} else {
				array_layer2.push($actionPoint2);
			}
			array_layer1.push($tmp_point2);
			array_layer1.push($tmp_point1);
			array_layer1.push($point1);
			bookArray_layer1 = array_layer1;

			array_layer2.push($limitPoint2);
			array_layer2.push($limitPoint1);
			array_layer2.push($tmp_point1);
			array_layer2.push($tmp_point2);
			bookArray_layer2 = array_layer2;
		}

		private function DrawShape(shape:Shape, point_array:Array, myBmp:BitmapData, matr:Matrix):void {
			var num:int = point_array.length;
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(myBmp, matr, false, true);
			shape.graphics.moveTo(point_array[0].x, point_array[0].y);
			for (var i:int = 1; i < num; i++) {
				shape.graphics.lineTo(point_array[i].x, point_array[i].y);
			}
			shape.graphics.endFill();
		}

		private function DrawShadowShap(shape:Shape, maskShape:Shape, g_width:Number, g_height:Number, $point1:Point, $point2:Point, $maskArray:Array, $arg:Number):void {
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x000000, 0x000000];
			var alphas1:Array = [0, 0.5];
			var alphas2:Array = [0.5, 0];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			var spreadMethod:String = SpreadMethod.PAD;
			var myscale:Number;
			var myalpha:Number;

			shape.graphics.clear();
			matr.createGradientBox(g_width, g_height, (0 / 180) * Math.PI, -g_width * 0.5, -g_height * 0.5);

			shape.graphics.beginGradientFill(fillType, colors, alphas1, ratios, matr, spreadMethod);
			shape.graphics.drawRect(-g_width * 0.5, -g_height * 0.5, g_width * 0.5, g_height);
			shape.graphics.beginGradientFill(fillType, colors, alphas2, ratios, matr, spreadMethod);
			shape.graphics.drawRect(0, -g_height * 0.5, g_width * 0.5, g_height);

			shape.x = $point2.x + ($point1.x - $point2.x) * $arg;
			shape.y = $point2.y + ($point1.y - $point2.y) * $arg;
			shape.rotation = angle($point1, $point2);
			myscale = Math.abs($point1.x - $point2.x) * 0.5 / book_width;
			myalpha = 1 - myscale * myscale;

			shape.scaleX = myscale + 0.1;
			shape.alpha = myalpha + 0.1;

			var tmp_Bmp:BitmapData = new BitmapData(book_width * 2, book_height, true, 0x0);
			DrawShape(maskShape, $maskArray, tmp_Bmp, new Matrix());
			shape.mask = maskShape;
		}

		//End DrawPage------------------------------------------------------------------------

		//**Setting Parts------------------------------------------------------------------------
		private function SeFilter(diso:DisplayObject):void {
			var filter:DropShadowFilter = new DropShadowFilter();
			filter.blurX = filter.blurY = 10;
			filter.alpha = 0.5;
			filter.distance = 0;
			filter.angle = 0;
			diso.filters = [filter];
		}

		private function SetLoadMC():void {
			var u1:String;
			var u2:String;

			for (var i:int = 0; i <= book_totalpage; i++) {
				book_root["pload_" + i] = new MovieClip();
				book_root["pload_" + i].id = i;
				book_root["pload_" + i].loadedflag = false;
				book_root["pload_" + i].loadedtype = "";
				book_root["pload_" + i].brotherMC = null;

				if (i > 1 && (bookInfo.pageInfoList.length > (i + 1))) {
					u1 = bookInfo.pageInfoList[i].bigURL;
					u2 = bookInfo.pageInfoList[i + 1].bigURL;
					if (u1 == u2) {
						book_root["pload_" + i].brotherMC = book_root["pload_" + (i + 1)];
					}
				}

				var page:Page = new Page(i, bookInfo.pageInfoList[i], book_width, book_height);//传入pageInfo，开始加载图片
				page.addEventListener(UIEvent.Page, onPageEventHandler);
				book_root["pload_" + i].page = page;
				book_root["pload_" + i].addChild(page);
				if (Boolean(onLoadinit)) {
					onLoadinit(book_root["pload_" + i]);
				}
			}
		}

		private function onPageEventHandler(e:UIEvent):void {
			var data:Object = e.data;
			switch (data.type) {
				case "loadProgress":
					if (onLoading != null) {
						onLoading(book_root["pload_" + data.data.id], data.data.percentLoaded);
					}
					break;
				case "loadComplete":
					if (onLoadEnd != null) {
						onLoadEnd(data.data.mc);
					}
					break;
				case "click":
					var px:Number = data.px;
					var py:Number = data.py;
					var pageNum:int = data.page;
					dispatchEvent(new UIEvent(UIEvent.PageFilpClassEvent, {type: "click", px: px, py: py, page: pageNum}));
					break;
				default :
					break;
			}
		}

		private function SetPageMC(pageNum:Number):void {
			var p_mc1:MovieClip = new MovieClip();
			var p_mc2:MovieClip = new MovieClip();
			var MC_content1:MovieClip;
			var MC_content2:MovieClip;

			if (pageNum >= 0 && pageNum <= book_totalpage) {// > 0
				p_mc1 = book_root["pload_" + pageNum];
			}
			if ((pageNum + 1) > 0 && (pageNum + 1) <= book_totalpage) {
				p_mc2 = book_root["pload_" + (pageNum + 1)];
			}

			pageMC.addChild(p_mc1);
			pageMC.addChild(p_mc2);
			p_mc1.x = p_mc1.y = 0;
			p_mc2.x = book_width;
			p_mc2.y = 0;
			if (p_mc1.loadedflag == true && p_mc1.loadedtype == "application/x-shockwave-flash") {
				MC_content1 = p_mc1.loader.content;
				MC_content1.gotoAndPlay(2);
			}
			if (p_mc2.loadedflag == true && p_mc2.loadedtype == "application/x-shockwave-flash") {
				MC_content2 = p_mc2.loader.content;
				MC_content2.gotoAndPlay(2);
			}
		}

		//End Setting------------------------------------------------------------------------

		//**MouseEvent Parts------------------------------------------------------------------------
//		private function MouseOnDown(e:Event):void {
//			if (book_TimerFlag != "stop" || e.target.hasEventListener(MouseEvent.CLICK)) {
//				//不处于静止状态
//				return;
//			}
//			//mouseOnDown时取area绝对值;
//			book_TimerArg0 = MouseFindArea(new Point(book_root.mouseX, book_root.mouseY));
//			book_TimerArg0 = book_TimerArg0 < 0 ? -book_TimerArg0 : book_TimerArg0;
//			if (book_TimerArg0 == 0) {
//				//不在area区域
//				return;
//			} else if ((book_TimerArg0 == 1 || book_TimerArg0 == 2) && book_page <= 1) {
//				//向左翻到顶
//				return;
//			} else if ((book_TimerArg0 == 3 || book_TimerArg0 == 4) && book_page >= book_totalpage) {
//				//向右翻到顶
//				return;
//			} else {
//				book_TimerFlag = "startplay";
//				PageUp();
//			}
//		}
//
//		private function MouseOnUp(e:Event):void {
//			if (book_TimerFlag == "startplay") {
//				//处于mousedown状态时
//				book_TimerArg1 = MouseFindArea(new Point(book_root.mouseX, book_root.mouseY));
//				book_TimerFlag = "autoplay";
//			}
//		}
//
//		private function MouseFindArea(point:Point):Number {
//			/* 取下面的四个区域,返回数值:
//			 *   --------------------
//			 *  | -1|     |     | -3 |
//			 *  |---      |      ----|
//			 *  |     1   |   3      |
//			 *  |---------|----------|
//			 *  |     2   |   4      |
//			 *  |----     |      ----|
//			 *  | -2 |    |     | -4 |
//			 *   --------------------
//			 */
//			var tmpn:Number;
//			var minx:Number = 0;
//			var maxx:Number = book_width + book_width;
//			var miny:Number = 0;
//			var maxy:Number = book_height;
//			var areaNum:Number = 50;
//
//			if (point.x > minx && point.x <= maxx * 0.5) {
//				tmpn = (point.y > miny && point.y <= (maxy * 0.5)) ? 1 : (point.y > (maxy * 0.5) && point.y < maxy) ? 2 : 0;
//				if (point.x <= (minx + areaNum)) {
//					tmpn = (point.y > miny && point.y <= (miny + areaNum)) ? -1 : (point.y > (maxy - areaNum) && point.y < maxy) ? -2 : tmpn;
//				}
//				return tmpn;
//			} else if (point.x > (maxx * 0.5) && point.x < maxx) {
//				tmpn = (point.y > miny && point.y <= (maxy * 0.5)) ? 3 : (point.y > (maxy * 0.5) && point.y < maxy) ? 4 : 0;
//				if (point.x >= (maxx - areaNum)) {
//					tmpn = (point.y > miny && point.y <= (miny + areaNum)) ? -3 : (point.y > (maxy - areaNum) && point.y < maxy) ? -4 : tmpn;
//				}
//				return tmpn;
//			}
//			return 0;
//		}
		//End MouseEvent------------------------------------------------------------------------

		//**Page Parts------------------------------------------------------------------------
		public function PageGoto(topage:Number):void {
//			trace("book_totalpage " + book_totalpage);
//			trace("topage " + topage);
			topage = topage % 2 == 1 ? topage - 1 : topage;
			var n:Number = topage - book_page;
			if (book_TimerFlag == "stop" && topage >= 0 && topage <= book_totalpage && n != 0) {
				book_TimerArg0 = n < 0 ? 1 : 3;
				book_TimerArg1 = -1;
				book_topage = topage > book_totalpage ? book_totalpage : topage;
				book_TimerFlag = "autoplay";
				pageUp();
			}
		}

		public function PageDraw(pageNum:Number):BitmapData {//获取本页的缩略图
			var myBmp:BitmapData = new BitmapData(book_width, book_height, true, 0x000000);
			if (pageNum >= 0 && pageNum <= book_totalpage) {
				myBmp.draw(book_root["pload_" + pageNum]);
			}
			return myBmp;
		}

		private function pageUp():void {
			var page1:Number;
			var page2:Number;
			var page3:Number;
			var page4:Number;
			var point_mypos:Point = book_myposArray[book_TimerArg0 - 1];
			var b0:Bitmap;
			var b1:Bitmap;

			if (book_TimerArg0 == 1 || book_TimerArg0 == 2) {
				book_topage = book_topage == book_page ? book_page - 2 : book_topage;
				page1 = book_page;
				page2 = book_topage + 1;
				page3 = book_topage;
				page4 = book_page + 1;
			} else if (book_TimerArg0 == 3 || book_TimerArg0 == 4) {
				book_topage = book_topage == book_page ? book_page + 2 : book_topage;
				page1 = book_page + 1;
				page2 = book_topage;
				page3 = book_page;
				page4 = book_topage + 1;
			}
			book_px = point_mypos.x;
			book_py = point_mypos.y;

			Bmp0 = PageDraw(page1);
			Bmp1 = PageDraw(page2);
			bgBmp0 = PageDraw(page3);
			bgBmp1 = PageDraw(page4);

			b0 = new Bitmap(bgBmp0);
			b1 = new Bitmap(bgBmp1);
			b1.x = book_width;
			bgMC.addChild(b0);
			bgMC.addChild(b1);
			bgMC.visible = false;
			book_timer.start();
		}

		//End Page------------------------------------------------------------------------

		//**Timer Parts------------------------------------------------------------------------
		private function bookTimerHandler(e:TimerEvent):void {
			var point_topos:Point = book_toposArray[book_TimerArg0 - 1];
			var point_mypos:Point = book_myposArray[book_TimerArg0 - 1];

			var tmpMC0:MovieClip;
			var tmpageMC0:MovieClip;

			var tox:Number;
			var toy:Number;
			var toflag:Number;
			var tmpx:Number;
			var tmpy:Number;

			bgMC.visible = true;

			while (pageMC.numChildren > 0) {
				pageMC.removeChildAt(0);
				if (book_page >= 0 && book_page <= book_totalpage) {
					tmpMC0 = book_root["pload_" + book_page];
					if (tmpMC0.loadedflag == true && tmpMC0.loadedtype == "application/x-shockwave-flash") {
						tmpageMC0 = tmpMC0.loader.content;
						tmpageMC0.gotoAndStop(1);
					}
				}
				if ((book_page + 1) >= 0 && (book_page + 1) <= book_totalpage) {
					tmpMC0 = book_root["pload_" + (book_page + 1)];
					if (tmpMC0.loadedflag == true && tmpMC0.loadedtype == "application/x-shockwave-flash") {
						tmpageMC0 = tmpMC0.loader.content;
						tmpageMC0.gotoAndStop(1);
					}
				}
			}
			if (book_TimerFlag == "startplay") {
				u = 0.4;
				render0.graphics.clear();
				render1.graphics.clear();
				book_px = int((render0.mouseX - book_px) * u + book_px);
				book_py = int((render0.mouseY - book_py) * u + book_py);

				DrawPage(book_TimerArg0, new Point(book_px, book_py), Bmp1, Bmp0);
				//book_timer.stop();
			} else if (book_TimerFlag == "autoplay") {
				render0.graphics.clear();
				render1.graphics.clear();
				if (Math.abs(point_topos.x - book_px) > book_width && book_TimerArg1 > 0) {
					//不处于点翻区域并且翻页不过中线时
					tox = point_mypos.x;
					toy = point_mypos.y;
					toflag = 0;
				} else {
					tox = point_topos.x;
					toy = point_topos.y;
					toflag = 1;
				}
				tmpx = int(tox - book_px);
				tmpy = int(toy - book_py);

				if (book_TimerArg1 < 0) {
					//处于点翻区域时
					u = 0.3;//降低加速度
					book_py = arc(book_width, tmpx, point_topos.y);
				} else {
					u = 0.4;//原始加速度
					book_py = tmpy * u + book_py;
				}
				book_px = tmpx * u + book_px;

				DrawPage(book_TimerArg0, new Point(book_px, book_py), Bmp1, Bmp0);

				if (tmpx == 0 && tmpy == 0) {
					render0.graphics.clear();
					render1.graphics.clear();
					shadow0.graphics.clear();
					shadow1.graphics.clear();

					Bmp0.dispose();
					Bmp1.dispose();
					bgBmp0.dispose();
					bgBmp1.dispose();

					while (bgMC.numChildren > 0) {
						bgMC.removeChildAt(0);
					}
					book_topage = toflag == 1 ? book_topage : book_page;
					book_page = book_topage;

					SetPageMC(book_page);

					book_TimerFlag = "stop";//恢得静止状态
					if (onPageEnd != null) {
						onPageEnd();
					}

					bgMC.visible = false;
					book_timer.reset();
				}
			}
		}

		//End Timer ------------------------------------------------------------------------

		//**Tools Parts------------------------------------------------------------------------
		private function arc(arg_R:Number, arg_N1:Number, arg_N2:Number):Number {
			//------圆弧算法-----------------------
			var arg:Number = arg_R * 2;
			var r:Number = arg_R * arg_R + arg * arg;
			var a:Number = Math.abs(arg_N1) - arg_R;
			var R_arg:Number = arg_N2 - (Math.sqrt(r - a * a) - arg);
			return R_arg;
		}

		private function angle(p1:Point, p2:Point):Number {
			var tmp_x:Number = p1.x - p2.x;
			var tmp_y:Number = p1.y - p2.y;
			var tmp_angle:Number = Math.atan2(tmp_y, tmp_x) * 180 / Math.PI;
			tmp_angle = tmp_angle < 0 ? tmp_angle + 360 : tmp_angle;
			return tmp_angle;
		}

		private function pos(p1:Point, p2:Point):Number {
			var tmp_x:Number = p1.x - p2.x;
			var tmp_y:Number = p1.y - p2.y;
			var tmp_s:Number = Math.sqrt(tmp_x * tmp_x + tmp_y * tmp_y);
			return p1.x > p2.x ? tmp_s : -tmp_s;
		}

		//End Tools------------------------------------------------------------------------
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
	}
}