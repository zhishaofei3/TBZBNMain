package events {

	import flash.events.Event;

	public class UIEvent extends Event {
		public static const Page:String = "Page";
		public static const ToolBarEvent:String = "ToolBarEvent";
		public static const SingleFlipEvent:String = "SingleFilpEvent";
		public static const PageFilpClassEvent:String = "PageFilpClassEvent";
		public function UIEvent(t:String, _data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(t, bubbles, cancelable);
			this.data = _data;
		}

		private var _data:Object = {};

		public function get data():Object {
			return _data;
		}

		public function set data(data:Object):void {
			_data = data;
		}

		override public function toString():String {
			return formatToString("UIEvent:", "type", "bubbles", "cancelable", "data");
		}

		override public function clone():Event {
			return new UIEvent(type, data, bubbles, cancelable);
		}
	}
}
