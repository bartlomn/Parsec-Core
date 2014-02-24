/**
 * User: Bart
 * Date: 07/02/2014
 * Time: 22:28
 * Description: Calls a method of a target object
 */

package com.webintelligence.parsec.core.command
{
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;

public class CallMethodCommand
{

   /**
    *  @private
    */
   private static const LOG:Logger    = LogContext.getLogger( CallMethodCommand );

   [Inject]
   /**
    *  context reference
    */
   public var context:Context;

   /**
    *  Class or instance of the target object to call method on
    */
   public var target:Object;

   /**
    *  Method to call on target
    */
   public var method:String;

   /**
    *  arguments to pass to the method
    */
   public var methodArguments:Array;

  /**
    *  command execute method
    */
   public function execute():void
   {
      if( !target || !context || !method )
         throw new IllegalStateError( "Invalid Parameters" );
      var targetInstance:Object =  ( target is Class ) ?
            context.getObjectByType( target as Class ) :
            target;
      if( targetInstance.hasOwnProperty( method ))
      {
         var methodInstance:Function = targetInstance[ method ] as Function;
         LOG.debug( "Calling {0}.{1}", ClassInfo.forInstance( targetInstance ).simpleName, method )
         try
         {
            methodInstance.apply( null, methodArguments );
         }
         catch( e:ArgumentError )
         {
            LOG.error("Error: {0}", e.toString());
         }
      }
   }

}
}
