package data.infos {
	public class BookInfo {
		private var _totalPageNum:int;
		private var _pageInfoList:Vector.<PageInfo>;
		private var _year:String;
		private var _num:String;
		private var _subject:String;
		private var _version:String;
		private var _grade:String;
		private var _answer:PageInfo;
		private var _id:String;
		private var _issueid:String;

		public function BookInfo() {
			_pageInfoList = new Vector.<PageInfo>();
		}

		public function get totalPageNum():int {
			return _totalPageNum;
		}

		public function set totalPageNum(value:int):void {
			_totalPageNum = value;
		}

		public function get pageInfoList():Vector.<PageInfo> {
			return _pageInfoList;
		}

		public function set pageInfoList(value:Vector.<PageInfo>):void {
			_pageInfoList = value;
		}

		public function get year():String {
			return _year;
		}

		public function set year(value:String):void {
			_year = value;
		}

		public function get num():String {
			return _num;
		}

		public function set num(value:String):void {
			_num = value;
		}

		public function get subject():String {
			return _subject;
		}

		public function set subject(value:String):void {
			_subject = value;
		}

		public function get version():String {
			return _version;
		}

		public function set version(value:String):void {
			_version = value;
		}

		public function get grade():String {
			return _grade;
		}

		public function set grade(value:String):void {
			_grade = value;
		}

		public function get answer():PageInfo {
			return _answer;
		}

		public function set answer(value:PageInfo):void {
			_answer = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get issueid():String {
			return _issueid;
		}

		public function set issueid(value:String):void {
			_issueid = value;
		}
	}
}
