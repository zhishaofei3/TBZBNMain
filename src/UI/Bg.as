package UI {
	import flash.display.Sprite;
	import flash.events.Event;

	import tbzb.ui.UIBg;

	public class Bg extends Sprite {
		private var ui:UIBg;

		public function Bg() {
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onStage(e:Event):void {
			ui = new UIBg();
			addChild(ui);
		}

		public function resize():void {
			ui.width = TBZBNMain.st.stageWidth;
			ui.height = TBZBNMain.st.stageHeight;
		}
	}
}
