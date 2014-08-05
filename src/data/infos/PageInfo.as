package data.infos {
	import flash.display.Bitmap;

	public class PageInfo {
		private var _smallURL:String;
		private var _bigURL:String;
		private var _smallImgBmp:Bitmap;
		private var _bigImgBmp:Bitmap;

		public function PageInfo(tURL:String, bURL:String) {
			_smallURL = tURL;
			_bigURL = bURL;
		}

		public function get smallURL():String {
			return _smallURL;
		}

		public function set smallURL(value:String):void {
			_smallURL = value;
		}

		public function get bigURL():String {
			return _bigURL;
		}

		public function set bigURL(value:String):void {
			_bigURL = value;
		}

		public function get smallImgBmp():Bitmap {
			return _smallImgBmp;
		}

		public function set smallImgBmp(value:Bitmap):void {
			_smallImgBmp = value;
		}

		public function get bigImgBmp():Bitmap {
			return _bigImgBmp;
		}

		public function set bigImgBmp(value:Bitmap):void {
			_bigImgBmp = value;
		}
	}
}
