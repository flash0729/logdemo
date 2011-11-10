package view
{
	import com.adobe.air.logging.FileTarget;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	public class CorelibLog extends VBox
	{
		public function CorelibLog()
		{
			super();
		}		
		[Bindable]
		protected var myData:ArrayCollection;
		
		[Bindable]
		protected var fileTarget:FileTarget;
		protected var logFilePath:String;
		
		[Bindable]
		protected var logContent:String;
		
		protected function initLogging():void
		{
			logFilePath = File.applicationDirectory.nativePath + "\\"+ new Date().toLocaleDateString()+".txt";
			
			var file:File = new File(logFilePath);
			
			fileTarget = new FileTarget(file);				
			fileTarget.filters=["mx.rpc.*","mx.messaging.*"];								
			fileTarget.level = LogEventLevel.ALL;				
			fileTarget.includeDate = true;
			fileTarget.includeTime = true;
			fileTarget.includeCategory = true;
			fileTarget.includeLevel = true;            	
			
			Log.addTarget(fileTarget);
		}
		
		protected function showLog():void			
		{
			var file:File = new File(logFilePath);
			if(	file.exists)
			{
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE,fileLoadCompleteHandler);
				loader.load(new URLRequest(logFilePath));
			}
		}
		
		private function fileLoadCompleteHandler(event:Event):void
		{
			logContent = String(event.currentTarget.data);
		}
		
		protected function clearLog():void
		{
			fileTarget.clear();
			showLog();
		}
		
		protected function srv_ResultHandler(event:Event):void
		{
			myData = event.currentTarget.lastResult.data.result;
		}
	}
}