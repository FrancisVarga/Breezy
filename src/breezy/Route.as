package breezy
{
	public class Route
	{
		public var spec:RegExp;
		public var controller:*;
		public var action:String;
		public var async:Boolean = false;
		
		public function Route(spec:RegExp, controller:*, action:String=null, async:Boolean=false)
		{
			this.spec = spec;
			this.controller = controller;
			this.action = action;
			this.async = async;
		}
	}
}