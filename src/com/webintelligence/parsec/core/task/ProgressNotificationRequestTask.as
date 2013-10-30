package com.webintelligence.parsec.core.task
{

import com.webintelligence.parsec.core.notification.ProgressNotificationRequest;
import com.webintelligence.parsec.core.notification.ProgressNotificationType;

import flash.errors.IllegalOperationError;

/**
 *  Wraps a navigation gesture in a SequenceTask-friendly task.
 */
public class ProgressNotificationRequestTask 
    extends TaskBase
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  type
    //--------------------------------------

    /**
     *  progress notification type
     */
    public var type:ProgressNotificationType;

    //--------------------------------------
    //   dispatchMessage
    //--------------------------------------

    [MessageDispatcher]

    /**
     *  Parsley message dispatcher
     */
    public var dispatchMessage:Function;

    //--------------------------------------------------------------------------
    //
    //  Overriden methods: Task
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function doStart():void
    {
        if(!type)
            throw IllegalOperationError("Type is not specified!");
        super.doStart();
        if(enabled)
        {
            dispatchMessage(ProgressNotificationRequest.createFor(type));
            complete();
        }
    }
}
}
