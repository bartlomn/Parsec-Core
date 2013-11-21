package com.webintelligence.parsec.core.task
{

import com.webintelligence.parsec.core.message.lifecycle.NotifyInternalErrorMsg;

import org.spicefactory.lib.task.enum.TaskState;
import org.spicefactory.parsley.core.context.Context;

//--------------------------------------
//   Other metadata
//--------------------------------------

[DefaultProperty( "dispatchMsg" )]

/**
 * The ParsleyMessageTask allows interaction between Cairngorm Tasks framework
 * and Parsley message bus
 */
[Deprecated("Use new command architecture")]
public class ParsleyMessageTask extends TaskBase
{

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function ParsleyMessageTask()
   {
      super();
   }

   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   /**
    *  Class or instance of message dispatched when task is performed
    */
   public var dispatchMsg:Object;

   [Inject]
   public var context:Context;

   [MessageDispatcher]
   public var dispatcher:Function;


   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------

   protected var msgReceived:Boolean = false;

   //--------------------------------------------------------------------------
   //
   //  Overridden methods: TimeoutTask
   //
   //--------------------------------------------------------------------------

   override protected function doStart():void
   {
      super.doStart();
      if ( enabled )
      {
         if ( dispatchMsg )
            dispatcher( dispatchMsg is Class ? new dispatchMsg() : dispatchMsg );
         complete();
      }
   }

   override protected function doError( message:String ):void
   {
      super.doError( message );
      dispatcher( new NotifyInternalErrorMsg( this, name, message ) );
   }

   //--------------------------------------------------------------------------
   //
   //  Message handlers
   //
   //--------------------------------------------------------------------------

   public function completeMsgHandler( msg:Object ):void
   {
      msgReceived = true;
      if ( state == TaskState.ACTIVE )
         complete();
   }

   public function failMsgHandler( msg:Object ):void
   {
      if ( state == TaskState.ACTIVE )
      {
         error( "Fault message received" );
      }
   }
}
}
