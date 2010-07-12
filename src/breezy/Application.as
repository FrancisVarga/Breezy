package breezy
{
	import breezy.Route;
	import breezy.StaticHandler;
	
	import flash.net.Socket;

	public class Application{
		public var handlers:Array;
		
		public function Application(handlers:Array){
			this.handlers = handlers;
			this.handlers.push(new Route(/\/static\/(.*)/g, StaticHandler));
		}
		
		public function __call__(request:Object, socket:Socket):Object{
			var hit:Boolean = false;
			for(var i:int = 0; i<this.handlers.length; i++){
				var route:Route = this.handlers[i];
				if(String(request.path).search(route.spec) > -1){
					var spec_matches:Array = String(request.path).match(route.spec);
					var controller:* = new route.controller(request, socket);
					if(!route.action){
						route.action = String(request.method).toLowerCase();
					}
					spec_matches.shift();
					controller[route.action].apply(this, spec_matches);
					break;
				}
			}
			return controller;
		}
	}
}