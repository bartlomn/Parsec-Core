/**
 * User: Bart
 * Date: 09/04/2014
 * Time: 13:30
 * Description:
 */

package com.webintelligence.parsec.core.navigation.trigger
{
import com.webintelligence.parsec.core.action.IAction;
import com.webintelligence.parsec.core.navigation.destination.Destination;
import com.webintelligence.parsec.core.navigation.message.DestinationReadyMessage;

import org.spicefactory.parsley.core.context.Context;

public class DestinationReadyTrigger extends AbstractMessageTrigger
{

   /**
    *  @private
    */
   private var _destination:Destination;

   /**
    *  Constructor
    */
   public function DestinationReadyTrigger( context:Context, destination:Destination, action:IAction )
   {
      super( context, DestinationReadyMessage, action );
      _destination = destination;
   }

   /**
    *  @private
    */
   override public function messageReceivedHandler( msg : Object ) : void
   {
      if(( msg as DestinationReadyMessage ).destination == _destination )
         action.execute();
   }
}
}
