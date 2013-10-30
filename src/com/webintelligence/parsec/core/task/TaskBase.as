package com.webintelligence.parsec.core.task
{

import com.webintelligence.parsec.core.task.parsleyTaskClasses.Task;

import mx.core.IMXMLObject;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

/**
 *  Basic task extension that exposes the timeout property.  It also has a
 *  default timeout value configured.
 */
public class TaskBase 
    extends Task
    implements IMXMLObject
{

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const LOG:Logger = LogContext.getLogger(TaskBase);

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     */
    public function TaskBase()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  enabled 
    //--------------------------------------
    
    /**
     *  If <code>false</code> will skip automatically upon being called.
     */
    public var enabled:Boolean = true;
    
    //--------------------------------------
    //  timeout
    //--------------------------------------

    /**
     *  @private
     */
    public function set timeout(value:uint):void
    {
        setTimeout(value);
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

    //--------------------------------------------------------------------------
    //
    //  METHODS
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  IMXMLObject implementation
     *  Adds task to the Parsley container if not placed in the context 
     */
    public function initialized(document:Object, id:String):void
    {
        //  TODO: Hook to introduce auto-wiring into parsley context
    }

    //--------------------------------------------------------------------------
    //
    //  Overriden methods: Task
    //
    //--------------------------------------------------------------------------

    /**
     *   @private
     */
    override protected function doStart():void
    {
        super.doStart();
        
        if (!enabled)
        {
            skip();
            return;
        }
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
