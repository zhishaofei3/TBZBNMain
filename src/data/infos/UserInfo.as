package data.infos {
	public class UserInfo {

		private var _email:String;
		private var _level:String;
		private var _role:String;
		private var _uid:String;
		private var _username:String;

		public function UserInfo() {
		}

		public function get email():String {
			return _email;
		}

		public function set email(value:String):void {
			_email = value;
		}

		public function get level():String {
			return _level;
		}

		public function set level(value:String):void {
			_level = value;
		}

		public function get role():String {
			return _role;
		}

		public function set role(value:String):void {
			_role = value;
		}

		public function get uid():String {
			return _uid;
		}

		public function set uid(value:String):void {
			_uid = value;
		}

		public function get username():String {
			return _username;
		}

		public function set username(value:String):void {
			_username = value;
		}
	}
}
