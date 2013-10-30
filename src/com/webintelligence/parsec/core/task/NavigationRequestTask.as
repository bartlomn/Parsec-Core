package com.webintelligence.parsec.core.task
{


import com.bnowak.parsec.util.integration.parsley.MessageHandlerProvider;
import com.webintelligence.parsec.core.navigation.NavigationRequest;
import com.webintelligence.parsec.core.navigation.destination.Destination;
import com.webintelligence.parsec.core.navigation.message.DestinationReadyMessage;

import flash.errors.IllegalOperationError;

import org.spicefactory.lib.task.enum.TaskState;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 *  Wraps a navigation gesture in a SequenceTask-friendly task.
 */
public class NavigationRequestTask 
    extends TaskBase
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function NavigationRequestTask()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  Dynamically registered Parsley message target
     */
    private var target:MessageTarget; 

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  destination
    //--------------------------------------

    /**
     *  Navigation destination
     */
    public var destination:Destination;

    //--------------------------------------
    //  context
    //--------------------------------------
    
    [Inject]
    
    /**
     *  Parsley context
     */
    public var context:Context;

    //--------------------------------------
    //  dispatcher
    //--------------------------------------

    [MessageDispatcher]

    /**
     *  Parsley message dispatcher
     */
    public var dispatcher:Function;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  if message comes from our destination, we're complete
     */
    public function destinationReadyMsgHandler(msg:DestinationReadyMessage):void
    {
        if (state != TaskState.ACTIVE || msg.destination != destination)
            return;

        complete();
        MessageHandlerProvider.deregister( context, target );
        target = null;
    }

    /**
     *  @private
     */
    override protected function doStart():void
    {
        if (!destination)
            throw IllegalOperationError("Destination is not specified!");
        super.doStart();
        if (enabled)
        {
           target = MessageHandlerProvider.register( context, DestinationReadyMessage, this, "destinationReadyMsgHandler");
            dispatcher(NavigationRequest.createFor(destination));
        }
    }
}
}
