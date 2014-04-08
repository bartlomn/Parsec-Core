/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 05/03/2014
 * Time: 20:42
 * Description: Enables common logging capability for singleton EventDispatcher based classes
 */

package com.webintelligence.parsec.core.log
{
import flash.events.EventDispatcher;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;

public class LogAwareEventDispatcher
   extends EventDispatcher
{

   /**
    *  @private
    */
   private static var _LOG:Logger = LogContext.getLogger( LogAwareEventDispatcher );

   /**
    *  logger instance
    */
   protected var _log:Logger;

   /**
    *  class info instance
    */
   protected var _info:ClassInfo;

   /**
    *  Constructor
    */
   public function LogAwareEventDispatcher()
   {
      _info = ClassInfo.forInstance( this );
      try
      {
         _log  = LogContext.getLogger( _info.name );
         _LOG.debug( "Logger instance created for {0}", _info.simpleName );
      } catch( e:Error )
      {
         _LOG.error( "Logger instance creation failed for {0}, error: {1}", _info.simpleName, e.message );
      }
   }
}
}
