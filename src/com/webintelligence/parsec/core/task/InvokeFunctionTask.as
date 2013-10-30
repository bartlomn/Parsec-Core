package com.webintelligence.parsec.core.task
{

import flash.events.TimerEvent;
import flash.utils.Timer;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

/**
 *  Invokes a function.
 *  Note that this class a ultra simple right now and has obvious
 *  potential for more features, but they were not needed
 *  at the time of writing!
 */
public class InvokeFunctionTask 
    extends TaskBase
{

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const LOG:Logger = LogContext.getLogger(InvokeFunctionTask);

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function InvokeFunctionTask()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  fn
    //--------------------------------------

    /**
     *  The no-arg function to call
     */
    public var fn:Function;

    //--------------------------------------------------------------------------
    //
    //  Overriden methods: Task
    //
    //--------------------------------------------------------------------------

    /**
     *  Invoke the function
     */
    override protected function doStart():void
    {
        super.doStart();
        if (enabled)
        {
            if (fn == null)
            {
                complete();
                return;
            }
            try
            {
                fn();
                complete();
            }
            catch (e:Error)
            {
                error("Function invocation failed: " + e);
            }
        }
    }
}
}
