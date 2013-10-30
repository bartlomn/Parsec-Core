package com.webintelligence.parsec.core.task
{

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 *  A simple task that will pause for a certain amount of time.  Can be
 *  configured to fail or complete (or even randomly fail or complete within a
 *  specificed weight) if necessary.
 */
public class PauseTask 
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
    private static const LOG:Logger = LogContext.getLogger(PauseTask);

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function PauseTask()
    {
        super();
        timeout = 0;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var timer:Timer;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  duration
    //--------------------------------------

    /**
     *  Milliseconds to pause.
     */
    public var duration:Number = 500;

    /**
     *  Random error threshold between 0.0 and 1.0; the probability of a
     *  random fault to occur.  Used for testing task sequences' error
     *  handling.
     */
    public var errorThreshold:Number = 0.0;

    //--------------------------------------------------------------------------
    //
    //  Overriden methods: Task
    //
    //--------------------------------------------------------------------------

    /**
     *  Begin pause
     */
    override protected function doStart():void
    {
        super.doStart();
        if(enabled)
        {
            timer = new Timer(duration, 1);
            timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
            timer.start();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function timer_timerHandler(event:TimerEvent):void
    {
        LOG.debug("timer_timerHandler");
        timer.removeEventListener(TimerEvent.TIMER, timer_timerHandler);
        if (Math.random() > errorThreshold)
            complete();
        else
            error("a random error");
    }
}
}
