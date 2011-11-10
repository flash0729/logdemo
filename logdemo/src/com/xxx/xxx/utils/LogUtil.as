package com.xxx.xxx.utils
{
	import com.adobe.air.logging.FileTarget;
	
	import flash.filesystem.File;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	/**
	 *  AIR程序中记录日志的工具类 (对as3corelib官方类库中类com.adobe.air.logging.FileTarget的封装)
	 *  
	 *  @author Sakura
	 *  博客地址：http://www.cnblogs.com/god_bless_you
	 */
	public final class LogUtil
	{
		private static var _fileTarget:FileTarget;
		
		private static var _level:int = LogEventLevel.INFO;
		
		/**
	     *  Provides access to the level this target is currently set at.
	     *  Value values are:
	     *    <ul>
	     *      <li><code>LogEventLevel.FATAL (1000)</code> designates events that are very
	     *      harmful and will eventually lead to application failure</li>
	     *
	     *      <li><code>LogEventLevel.ERROR (8)</code> designates error events that might
	     *      still allow the application to continue running.</li>
	     *
	     *      <li><code>LogEventLevel.WARN (6)</code> designates events that could be
	     *      harmful to the application operation</li>
	     *
	     *      <li><code>LogEventLevel.INFO (4)</code> designates informational messages
	     *      that highlight the progress of the application at
	     *      coarse-grained level.</li>
	     *
	     *      <li><code>LogEventLevel.DEBUG (2)</code> designates informational
	     *      level messages that are fine grained and most helpful when
	     *      debugging an application.</li>
	     *
	     *      <li><code>LogEventLevel.ALL (0)</code> intended to force a target to
	     *      process all messages.</li>
	     *    </ul>
	     *  
	     */
		public static function get level():int
    	{
     		return _level;
    	}

    	public static function set level(value:int):void
    	{
        	// A change of level may impact the target level for Log.
        	if (checkFileTarget())
        	{
        		Log.removeTarget(_fileTarget);
        		_fileTarget = null;
        		_level = value;		
        	}
        	initLogging();        
    	}
		
		private static var _logFilePath:String = File.applicationStorageDirectory.resolvePath( "Logs\\" + new Date().toLocaleDateString() + ".log" ).nativePath;
		
		public static function get logFilePath():String
		{
			return _logFilePath;
		}
		
		public static function set logFilePath(value:String):void
    	{
        	if (checkFileTarget())
        	{
        		Log.removeTarget(_fileTarget);
        		_fileTarget = null;
        		_logFilePath = value;		
        	}
        	initLogging();        
    	}
		
		private static function getLogger(category:String):ILogger
		{
			return Log.getLogger(category);
		}
		
		private static function initLogging():void
		{
			if (checkFileTarget())
				return;
				
			var file:File = new File(_logFilePath);		
			_fileTarget = new FileTarget(file);									
			_fileTarget.level = _level;				
			_fileTarget.includeDate = true;
			_fileTarget.includeTime = true;
			_fileTarget.includeCategory = true;
			_fileTarget.includeLevel = true;            	
			
			Log.addTarget(_fileTarget);
		}
		
		private static function checkFileTarget():Boolean
		{
			return (_fileTarget) ? true : false;
		}
		
		private static function generateMessage(message:String,rest:Array):String
		{
			for (var i:int = 0; i < rest.length; i++)
			{
				message = message.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			return message;
		}
		
		/**
     	 *  Logs the specified data using the <code>LogEventLevel.DEBUG</code>
     	 *  level.
	     *  <code>LogEventLevel.DEBUG</code> designates informational level
	     *  messages that are fine grained and most helpful when debugging
	     *  an application.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param category The category for which this log sends messages.
	     * 
	     *  @param message The information to log.
	     *  This string can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     * 
	     */
		public static function debug(category:String, message:String, ... rest):void
		{
			initLogging();
			
			if (Log.isDebug())
			{
				var logger:ILogger = getLogger(category);
				logger.debug(generateMessage(message,rest));
			}
		}
		
		
		/**
     	 *  Logs the specified data using the <code>LogEvent.INFO</code> level.
     	 *  <code>LogEventLevel.INFO</code> designates informational messages that 
     	 *  highlight the progress of the application at coarse-grained level.
     	 *  
     	 *  <p>The string specified for logging can contain braces with an index
     	 *  indicating which additional parameter should be inserted
     	 *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param category The category for which this log sends messages.
	     * 
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     */
		public static function info(category:String, message:String, ... rest):void
		{
			initLogging();
			
			if (Log.isInfo())
			{	
				var logger:ILogger = getLogger(category);
				logger.info(generateMessage(message,rest));
			}
		}
		
		/**
	     *  Logs the specified data using the <code>LogEventLevel.WARN</code> level.
	     *  <code>LogEventLevel.WARN</code> designates events that could be harmful 
	     *  to the application operation.
	     *      
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *  
	     *  @param category The category for which this log sends messages.
	     * 
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Aadditional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     */
		public static function warn(category:String, message:String, ... rest):void
		{
			initLogging();
			
			if (Log.isWarn())
			{	
				var logger:ILogger = getLogger(category);
				logger.warn(generateMessage(message,rest));
			}
		}
		
		/**
	     *  Logs the specified data using the <code>LogEventLevel.ERROR</code>
	     *  level.
	     *  <code>LogEventLevel.ERROR</code> designates error events
	     *  that might still allow the application to continue running.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param category The category for which this log sends messages.
	     * 
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     */
		public static function error(category:String, message:String, ... rest):void
		{
			initLogging();
			
			if (Log.isError())
			{
				var logger:ILogger = getLogger(category);
				logger.error(generateMessage(message,rest));
			}
		}
		
		/**
	     *  Logs the specified data using the <code>LogEventLevel.FATAL</code> 
	     *  level.
	     *  <code>LogEventLevel.FATAL</code> designates events that are very 
	     *  harmful and will eventually lead to application failure
	     *
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param category The category for which this log sends messages.
	     * 
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     */
		public static function fatal(category:String, message:String, ... rest):void
		{
			initLogging();
			
			if (Log.isFatal())
			{
				var logger:ILogger = getLogger(category);
				logger.fatal(generateMessage(message,rest));
			}
		}
		
		/**
	     *  Clear all logs.
	     */
		public static function clear():void
		{
			initLogging();
			_fileTarget.clear();
		}
	}
}