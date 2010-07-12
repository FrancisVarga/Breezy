package breezy
{
	import breezy.BaseHandler;
	
	import flash.net.Socket;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray; 
	import breezy.Mime;
	
	public class StaticHandler extends BaseHandler
	{
		public function StaticHandler(request:Object, socket:Socket)
		{
			super(request, socket);
		}
		
		private function readFile(file:File):void{
			var stream:FileStream = new FileStream();
			stream.open( file, FileMode.READ );
			var content:ByteArray = new ByteArray();
			stream.readBytes(content);
			stream.close();
			this.body = content;
		}
		
		public function get(path:String):void{
			var file:File = File.applicationStorageDirectory.resolvePath("static/" + path);
			if (file.exists && !file.isDirectory){
				this.contentType = Mime.getFilePathMimeType(path);
				this.write(this.body,true);
			}
			else{
				//this.notFound();
			}
		}
	}
}