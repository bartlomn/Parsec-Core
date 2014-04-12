/**
 * User: Bart
 * Date: 09/04/2014
 * Time: 13:30
 * Description:
 */

package com.webintelligence.parsec.core.navigation.trigger
{
import com.webintelligence.parsec.core.action.IAction;

import org.spicefactory.parsley.core.context.Context;

public class MessageReceivedTrigger extends AbstractMessageTrigger
{

   /**
    *  Constructor
    */
   public function MessageReceivedTrigger( context:Context, message:Class, action:IAction )
   {
      super( context, message, action );
   }

   /**
    *  @private
    */
   override  public function messageReceivedHandler( msg:Object ):void
   {
      action.execute();
   }
}
}
