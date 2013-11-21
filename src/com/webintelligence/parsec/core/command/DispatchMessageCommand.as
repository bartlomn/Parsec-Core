/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 21/11/2013
 * Time: 22:22
 * Description: Dispatches Parsley message
 */

package com.webintelligence.parsec.core.command
{
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;

public class DispatchMessageCommand
{

   /**
    *  @private
    */
   private static const LOG:Logger    = LogContext.getLogger( DispatchMessageCommand );

   /**
    *  Class or instance of message dispatched when task is performed
    */
   public var payload:Object;

   [MessageDispatcher]

   /**
    *  @private
    */
   public var dispatchMessage:Function;

   /**
    *  command execute method
    */
   public function execute():void
   {
      if ( payload )
      {
         var payloadinstance:Object = payload is Class ? new payload() : payload;
         LOG.debug( "Dispatching message: '{0}'", ClassInfo.forInstance( payloadinstance ).simpleName )
         dispatchMessage( payloadinstance );
      }
      else
      {
         throw new IllegalArgumentError("Unexpected null payload");
      }
   }

}
}
