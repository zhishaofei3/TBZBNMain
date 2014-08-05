package events {

	import flash.events.Event;

	public class TBZBEvent extends Event {
		public function TBZBEvent(t:String, _data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
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
			return formatToString("TBZBEvent:", "type", "bubbles", "cancelable", "data");
		}

		override public function clone():Event {
			return new TBZBEvent(type, data, bubbles, cancelable);
		}
	}
}
