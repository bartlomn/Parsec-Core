/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 21/11/2013
 * Time: 21:03
 * Description:
 */

package com.webintelligence.parsec.core.command
{
import com.webintelligence.parsec.core.message.lifecycle.NotifyInternalErrorMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleErrorMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleProgressMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleReadyMsg;
import com.webintelligence.parsec.core.message.module.ModuleContextReadyMsg;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

public class LoadModuleCommand
{

   /**
    *  @private
    */
   private static const LOG:Logger    = LogContext.getLogger( LoadModuleCommand );

   /**
    *  @private
    */
   private var _isActive:Boolean;

   /**
    *  @private
    */
   private var _lastLog:int;

   [MessageDispatcher]
   /**
    *  @private
    */
   public var dispatchMessage:Function;

   /**
    *  Id of the module to be loaded.
    */
   public var moduleId:String;

   /**
    *  command callback
    */
   public var callback:Function;

   /**
    *  If <code>true</code> the task will wait for the context to be ready
    *  before completing.  Otherwise, the task will complete on stock flex
    *  module ready.
    */
   public var waitForContextReady:Boolean = true;

   /**
    *  executes the command
    */
   public function execute():void
   {
      LOG.debug( "Kick off loading module {0}", moduleId );
      _isActive = true;
      var msg:LoadModuleMsg = new LoadModuleMsg( moduleId );
      dispatchMessage( msg );
   }

   [MessageHandler]

   /**
    *  @private
    */
   public function loadModuleProgressHandler( msg:LoadModuleProgressMsg ):void
   {
      if (!isActiveForModule(msg.moduleId))
         return;
      var p:int = ( msg.bytesLoaded / msg.bytesTotal ) * 100;
      if ( p % 10 == 0 && p != _lastLog )
      {
         var tk:int = Math.floor( ( msg.bytesTotal + 1023 ) / 1024 );
         var lk:int = Math.floor( ( msg.bytesLoaded + 1023 ) / 1024 );
         LOG.debug( "Progress loading module ({0}): {2}kB/{3}kB ({1}%) complete", moduleId, p, lk, tk );
         _lastLog = p;
      }
   }

   /**
    *  True if this task is the given module's load-module task and is active
    */
   private function isActiveForModule(moduleId:String):Boolean
   {
      return _isActive && moduleId == this.moduleId;
   }

   [MessageHandler]

   /**
    *  @private
    */
   public function loadModuleReadyHandler( msg:LoadModuleReadyMsg ):void
   {
      if (!isActiveForModule(msg.moduleId))
         return;

      if (waitForContextReady)
         return;

      LOG.debug( "Module {0} is ready", moduleId );
      callback( 1 );
   }

   [MessageHandler]

   /**
    *  @private
    */
   public function moduleContextReadyHandler( msg:ModuleContextReadyMsg ):void
   {
      if (!isActiveForModule(msg.moduleId))
         return;

      if (!waitForContextReady)
         return;

      LOG.debug( "Module {0} is ready", moduleId );
      callback( 1 );
   }

   [MessageHandler]

   /**
    *  @private
    */
   public function loadModuleErrorHandler( msg:LoadModuleErrorMsg ):void
   {
      if (!isActiveForModule(msg.moduleId))
         return;

      dispatchMessage( new NotifyInternalErrorMsg( this, "Error loading module", msg.detail ));
      callback( -1 )
   }
}
}
