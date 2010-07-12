package breezy
{
	public class Mime
	{
		public static var extensionMap:Object = {
			'.css':'text/css', '.gif':'image/gif', '.html':'text/html', 
			'.htm': 'text/html', '.ico': 'image/x-icon', '.jpg':'image/jpeg', 
			'.js': 'application/x-javascript', '.png':'image/png'
		};
		public function Mime(){}
		public static function getFilePathMimeType(path:String):String{
			var mimeType:String;
			var index:int = path.lastIndexOf(".");
			if (index > -1){
				mimeType = Mime.extensionMap[path.substring(index)];
			}
			return mimeType == null ? "text/html" : mimeType; // default to text/html for unknown mime types
		}
	}
}