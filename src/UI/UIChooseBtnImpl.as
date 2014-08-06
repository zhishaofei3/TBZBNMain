package UI {
	import tbzb.ui.UIChooseBtn;

	import utils.common.component.display.AbstractDisplayObject;

	public class UIChooseBtnImpl extends AbstractDisplayObject {
		private var ui:UIChooseBtn;
		private var data:Object;

		public function UIChooseBtnImpl(txt:String, d:Object) {
			data = d;
			ui = new UIChooseBtn();
			ui.buttonMode = true;
			ui.txt.text = txt;
			addChild(ui);
		}

		public function changeTxt(txt:String):void {
			ui.txt.text = txt;
		}

		public function gotoActive():void {
			ui.gotoAndStop("active");
		}

		public function gotoMouseOut():void {
			ui.gotoAndStop(1);
		}

		public function gotoMouseOver():void {
			ui.gotoAndStop(2);
		}

		public function getCurrentFrame():int {
			return ui.currentFrame;
		}

		public function getData():Object {
			return data;
		}
	}
}
