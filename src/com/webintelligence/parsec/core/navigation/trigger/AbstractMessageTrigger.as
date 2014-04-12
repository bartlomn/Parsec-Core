/**
 * User: Bart
 * Date: 09/04/2014
 * Time: 13:30
 * Description:
 */

package com.webintelligence.parsec.core.navigation.trigger
{
import com.bnowak.parsec.util.integration.parsley.MessageHandlerProvider;
import com.webintelligence.parsec.core.action.IAction;

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

public class AbstractMessageTrigger
{

   /**
    *  @private
    */
   protected var action:IAction;

   /**
    *  @private
    */
   private var _message:Class;

   /**
    *  @private
    */
   private var _target:MessageTarget;

   /**
    *  @private
    */
   private var _context:Context;

   /**
    *  Constructor
    */
   public function AbstractMessageTrigger( context:Context, message:Class, action:IAction )
   {
      super();
      this.action = action;
      _message = message;
      _target = MessageHandlerProvider.register( context, message, this, "messageReceivedHandler" );
   }

   /**
    *  @private
    */
   public function destroy():void
   {
      if( _target )
      {
         MessageHandlerProvider.deregister( _context, _target );
         _target = null;
      }
   }

   /**
    *  @private
    */
   public function messageReceivedHandler( msg:Object ):void
   {
      // abstract
   }
}
}
