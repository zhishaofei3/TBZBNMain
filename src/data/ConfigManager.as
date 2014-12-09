package data {
	import data.infos.BookInfo;
	import data.infos.PageInfo;
	import data.infos.UserInfo;

	import events.TBZBEvent;

	import flash.external.ExternalInterface;

	import utils.common.util.LoadUtil;
	import utils.common.util.MethodUtil;

	public class ConfigManager {
		private static var id:String;
		private static var _appData:AppData = new AppData();
		public static var baseInfo:Object;
		public static var bookInfo:BookInfo;
		public static var banbielist:Object;
		public static var userInfo:UserInfo;

		public function ConfigManager() {
		}

		public static function init():void {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("jsLoggedin", jsLoggedin);
				ExternalInterface.addCallback("showAnswer", showAnswer);
				ExternalInterface.addCallback("hui", huiAll);
				ExternalInterface.addCallback("shouhui", shouHui);
			}
			initFlashVars();
		}

		private static function shouHui():void {
			TBZBNMain.showDatiBtn();
		}

		private static function showAnswer(b:Boolean):void {
			TBZBNMain.showAnswer(b);
		}

		private static function huiAll(b:Boolean):void {
			TBZBNMain.hui(b);
			TBZBNMain.huiToolBar(b);
		}

		private static function jsLoggedin(userObj:Object):void {
			userInfo = new UserInfo();
			userInfo.uid = userObj.uid;
			userInfo.username = userObj.username;
			userInfo.email = userObj.email;
			userInfo.role = userObj.role;
			userInfo.level = userObj.level;
		}

		private static function initFlashVars():void {
			id = TBZBNMain.st.root.loaderInfo.parameters["pdfId"];
			getBaseInfo();
		}

		private static function getBaseInfo():void {
			var getBaseInfoUtil:LoadUtil = new LoadUtil();
			getBaseInfoUtil.addEventListener("getBaseInfo", getBaseInfoResult);
			getBaseInfoUtil.load("getBaseInfo", "/Flash/GetBaseInfo");
		}

		private static function getBaseInfoResult(e:TBZBEvent):void {
			var getBaseInfoUtil:LoadUtil = e.target as LoadUtil;
			getBaseInfoUtil.removeEventListener("getBaseInfo", getBaseInfoResult);
			var o:Object = e.data as Object;
			baseInfo = o.data.baseinfo;
			loadBookData();
		}

		public static function loadBookData():void {
			var loadUtil:LoadUtil = new LoadUtil();
			loadUtil.addEventListener("loadBookData", onLoadBookDataComplete);
			loadUtil.load("loadBookData", "/Flash/GetContent", {id: id});
		}

		private static function onLoadBookDataComplete(e:TBZBEvent):void {
			e.target.removeEventListener("loadBookData", onLoadBookDataComplete);
			var o:Object = e.data as Object;
			if (o.status == 1) {
				var userObj:Object = o.data.userinfo;
				if (userObj.uid) {
					userInfo = new UserInfo();
					userInfo.email = userObj.email;
					userInfo.level = userObj.level;
					userInfo.role = userObj.role;
					userInfo.uid = userObj.uid;
					userInfo.username = userObj.username;
				}
				var paper:Object = o.data.paper;
				TBZBNMain.lastAD = paper.list.big.length % 2 == 0;//偶数有广告

				paper.list.big.push(paper.cover.big);
				paper.list.big.splice(0, 0, paper.cover.big);
				paper.list.small.push(paper.cover.small);
				paper.list.small.splice(0, 0, paper.cover.small);

				bookInfo = new BookInfo();
				bookInfo.id = id;
				bookInfo.num = paper.info.num;//1
				bookInfo.issueid = paper.info.issueid;//1
				bookInfo.year = paper.info.year;//2013
				bookInfo.subject = paper.info.subject;//2
				bookInfo.version = paper.info.version;//57
				bookInfo.grade = paper.info.grade;//11
				bookInfo.issuename = paper.info.issuename;
				bookInfo.answer = new PageInfo(paper.answer.small, paper.answer.big);
				for (var i:String in paper.list.big) {
					bookInfo.pageInfoList.push(new PageInfo(paper.list.small[i], paper.list.big[i]));
				}
				bookInfo.totalPageNum = paper.list.big.length;
				TBZBNMain.setBookConfig(bookInfo);
			}
		}

		public static function getBanBieList():void {//获取年级、科目、版本信息
			var getBaseInfoUtil:LoadUtil = new LoadUtil();
			getBaseInfoUtil.addEventListener("getBanBieList", getBanBieListResult);
			getBaseInfoUtil.load("getBanBieList", "/Flash/GetBanBieList");
		}

		private static function getBanBieListResult(e:TBZBEvent):void {//获取版本信息结果
			e.target.removeEventListener("getBanBieList", getBanBieListResult);
			var o:Object = e.data as Object;
			if (o.status == 1) {
				banbielist = o.data.banbielist;
				getQiCiList({gradeid: bookInfo.grade, subjectid: bookInfo.subject, versionid: bookInfo.version}, "toolbar");
			}
		}

		public static function getQiCiList(data:Object, type:String):void {//获取期次信息
			var getBaseInfoUtil:LoadUtil = new LoadUtil();
			getBaseInfoUtil.addEventListener("getQiCiList", MethodUtil.create(getQiCiResult, type, data));
			getBaseInfoUtil.load("getQiCiList", "/Flash/GetIssueList", data, "get");
		}

		private static function getQiCiResult(e:TBZBEvent, type:String, data:Object):void {//获取期次信息结果
			e.target.removeEventListener("getQiCiList", getQiCiResult);
			var o:Object = e.data as Object;
			if (o.status == 1) {
				TBZBNMain.getQiCiList(o.data.issuelist, type, data);
			}
		}

		public static function get appData():AppData {
			return _appData;
		}
	}
}

















