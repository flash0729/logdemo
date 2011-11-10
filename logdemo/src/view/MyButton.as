package view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class MyButton extends Button
	{
		private var myLogger:ILogger;
		
		public function MyButton()
		{
			super();
			initListeners();
			initLogger();
		}
		
		private function initListeners():void 
		{
			// Add event listeners life cycle events.
			addEventListener("preinitialize", logLifeCycleEvent);
			addEventListener("initialize", logLifeCycleEvent);
			addEventListener("creationComplete", logLifeCycleEvent);
			addEventListener("updateComplete", logLifeCycleEvent);
			
			// Add event listeners for other common events.
			addEventListener("click", logUIEvent);      
			addEventListener("mouseUp", logUIEvent);        
			addEventListener("mouseDown", logUIEvent);      
			addEventListener("mouseOver", logUIEvent);      
			addEventListener("mouseOut", logUIEvent);       
		}
		private function initLogger():void 
		{
			myLogger = Log.getLogger("view.MyButton");
		}
		
		private function logLifeCycleEvent(e:Event):void 
		{
			if (Log.isInfo()) 
			{
				myLogger.info(" STARTUP: {0}:{1}",e.target,e.type);
			}
		}
		
		private function logUIEvent(e:MouseEvent):void 
		{
			if (Log.isDebug()) 
			{
				myLogger.debug(" UI EVENT: " + e.target + ":" + e.type);
			}
		}
	}
}