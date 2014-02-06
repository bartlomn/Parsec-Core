package com.webintelligence.parsec.core.debug
{

import com.webintelligence.parsec.core.message.lifecycle.NotifyCriticalErrorMsg;

import flash.display.LoaderInfo;
import flash.events.UncaughtErrorEvent;

import mx.core.FlexGlobals;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;


/***************************************************************************
 * 
 *   @author bnowak 
 *   @created Dec 6, 2012
 * 
 *   Broadcasts uncaught Flash player errors as Parsley messages
 * 
 ***************************************************************************/

public class UncaughtErrorHandler
{
   
   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   private static const LOG:Logger =
      LogContext.getLogger(UncaughtErrorHandler);
   
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
    *  @private
    *  Parsley Message Dispatcher
    */
   public var dispatcher:Function;
   
   //--------------------------------------
   //  loaderInfo
   //--------------------------------------
   
   /**
    *  @private
    *  The loaderInfo allowing us access to the uncaught errors hook
    */
   private function get loaderInfo():LoaderInfo
   {
      return FlexGlobals.topLevelApplication.loaderInfo
   }
   
   //--------------------------------------------------------------------------
   //
   //  Message Handlers
   //
   //--------------------------------------------------------------------------
   
   [Init]
   
   /**
    *  @private
    *  executed on successful init
    */
   public function initHandler():void
   {
      loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
   }
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
   {
      event.preventDefault();
      event.stopImmediatePropagation();
      if (dispatcher != null)
      {
         dispatcher(new NotifyCriticalErrorMsg(
            this,
            "Internal Application Error",
            "Critical error, the application must be reloaded.",
            "UncaughtErrorEvent:\n" + event.toString(),
            event.error));
      }
      LOG.fatal("UncaughtErrorEvent caught {0}: {1}", event.toString(), event.error.toString());
   }
   
}
}