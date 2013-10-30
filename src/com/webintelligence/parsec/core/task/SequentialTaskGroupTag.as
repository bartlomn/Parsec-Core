package com.webintelligence.parsec.core.task
{

import com.webintelligence.parsec.core.task.parsleyTaskClasses.SequentialTaskGroup;
import com.webintelligence.parsec.core.task.parsleyTaskClasses.Task;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

//--------------------------------------
//   Other metadata
//--------------------------------------

[DefaultProperty("tasks")]

/**
 *  MXML wrapper for the <code>SequentialTaskGroup</code> from the spicelib
 *  Task framework.   Allows for declarative instantiation.
 *
 *  @see http://www.spicefactory.org/parsley/docs/2.4/manual/task.php
 */
public class SequentialTaskGroupTag 
    extends SequentialTaskGroup
{

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const LOG:Logger = LogContext.getLogger(SequentialTaskGroup);

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function SequentialTaskGroupTag()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  tasks
    //--------------------------------------

    [ArrayElementType("com.webintelligence.parsec.core.task.parsleyTaskClasses.Task")]

    /**
     *  List of Tasks to be executed sequentially.
     */
    public function get tasks():Array
    {
        return allTasks.toArray();
    }

    /**
     *  @private
     */
    public function set tasks(value:Array):void
    {
        removeAllTasks();
        for each (var task:Task in value)
            addTask(task)
    }

    //--------------------------------------
    //  name
    //--------------------------------------
    
    /**
     *  @private
     */
    private var _name:String;
    
    /**
     *  The name of this task, used for log output
     */
    public function get name():String
    {
        return _name;
    }
    
    /**
     *  @private
     */
    public function set name(value:String):void
    {
        _name = value;
        setName(value); // sync parent's private field
    }

    //--------------------------------------
    //  restartable
    //--------------------------------------

    /**
     *  @private
     */
    public function set restartable(value:Boolean):void
    {
        setRestartable(value);
    }

    //--------------------------------------
    //  enabled
    //--------------------------------------

    /**
     *  If <code>false</code> task will be skipped automatically
     */
    public var enabled:Boolean = true;

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
        if (!enabled)
        {
            skip();
            return;
        }
        super.doStart();
    }

    /**
     *   @private
     */
    override protected function complete():Boolean
    {
        LOG.debug("Task '{0}' complete", this);
        return super.complete();
    }

    /**
     *  @private
     */
    override protected function error(message:String):Boolean
    {
        LOG.error("Task '{0}' error: {1}", this, message);
        return super.error(message);
    }
}
}
