package com.webintelligence.parsec.core.task 
{

import com.webintelligence.parsec.core.message.lifecycle.NotifyInternalErrorMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleErrorMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleProgressMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleReadyMsg;
import com.webintelligence.parsec.core.message.module.ModuleContextReadyMsg;
import com.webintelligence.parsec.core.browser.BrowserLocationUtil;

import org.spicefactory.lib.task.enum.TaskState;

/**
 *  Task that will trigger a module load and will complete once the module is
 *  ready.  Works in conjunction with <code>ModuleViewLoaders</code>
 *  configured with a <code>ExplicitLoadPolicy</code> class.
 *
 *  @see http://sourceforge.net/adobe/cairngorm/wiki/HowToUseCairngormModule
 */
[Deprecated("Use new command architecture")]
public class LoadModuleTask 
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
    public function LoadModuleTask(moduleId:String = null)
    {
        super();
        this.moduleId = moduleId;
        timeout = 30000; // 30 seconds of inactivity
        
        // for testing
        var loadTimeout:Number = Number(BrowserLocationUtil.getQueryParameter("load_timeout"));
        if (loadTimeout)
            timeout = Number(loadTimeout);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  dispatcher
    //--------------------------------------

    [MessageDispatcher]

    /**
     *  Parsley message dispatcher.
     */
    public var dispatcher:Function;

    //--------------------------------------
    //  moduleId
    //--------------------------------------

    /**
     *  Id of the module to be loaded.
     */
    public var moduleId:String;

    //--------------------------------------
    //  waitForContextReady
    //--------------------------------------

    /**
     *  If <code>true</code> the task will wait for the context to be ready
     *  before completing.  Otherwise, the task will complete on stock flex
     *  module ready.
     */
    public var waitForContextReady:Boolean = true;
    
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
        super.doStart();
        
        // timeout for module-load is tied to progress (or lack of it), 
        // so stop the timer that was just started in the super-class
        cancelTimer();

        if (enabled)
        {
            var msg:LoadModuleMsg = new LoadModuleMsg(moduleId);
            dispatcher(msg);
        }
    }
    
    /**
     *  @private 
     */    
    override protected function doError(message:String):void
    {
        super.doError(message);
        dispatcher(new NotifyInternalErrorMsg(this, name, message));
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  True if this task is the given module's load-module task and is active
     */
    private function isActiveForModule(moduleId:String):Boolean
    {
        return state == TaskState.ACTIVE && moduleId == this.moduleId;
    }

    //--------------------------------------------------------------------------
    //
    //  Message handlers.
    //
    //--------------------------------------------------------------------------

    [MessageHandler]

    /**
     *  @private
     */
    public function loadModuleReadyHandler(msg:LoadModuleReadyMsg):void
    {
        if (!isActiveForModule(msg.moduleId))
            return;

        if (waitForContextReady)
            return;

        complete();
    }

    [MessageHandler]

    /**
     *  @private
     */
    public function loadModuleProgressHandler(msg:LoadModuleProgressMsg):void
    {
        if (!isActiveForModule(msg.moduleId))
            return;

        startTimer(); // or re-start
    }

    [MessageHandler]

    /**
     *  @private
     */
    public function moduleContextReadyHandler(msg:ModuleContextReadyMsg):void
    {
        if (!isActiveForModule(msg.moduleId))
            return;
        
        if (!waitForContextReady)
            return;

        complete();
    }

    [MessageHandler]

    /**
     *  @private
     */
    public function loadModuleErrorHandler(msg:LoadModuleErrorMsg):void
    {
        if (!isActiveForModule(msg.moduleId))
            return;
        
        error("Error loading module '" + moduleId + "':" + msg.detail);
    }
}
}
