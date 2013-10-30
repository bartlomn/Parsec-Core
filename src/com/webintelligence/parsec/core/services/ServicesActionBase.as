package com.webintelligence.parsec.core.services
{
import com.webintelligence.parsec.core.message.lifecycle.NotifyCriticalErrorMsg;
import com.webintelligence.parsec.core.util.InvalidatingObject;

import flash.errors.IllegalOperationError;

import mx.rpc.Responder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;


/***************************************************************************
 * 
 *   @author bnowak 
 *   @created Jan 8, 2013
 *
 *   base class for all the service actions.
 *   responsible for initialising the invalidation mechanism
 * 
 ***************************************************************************/

public class ServicesActionBase 
   extends InvalidatingObject
{
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function ServicesActionBase()
   {
      super();
      initialize();
   }
   
   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    *  are we _initialized - flag
    */
   protected var _initialized:Boolean;
   
   /**
    *  @private
    *  request start time
    */
   protected var startTime:int;
   
   /**
    *  @private
    *  inernal rpc responder 
    */
   protected var responder:Responder;
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  messageDispatcher
   //--------------------------------------
   
   [MessageDispatcher]
   
   /**
    *  parsley message dispatcher
    */
   public var dispatchMessage:Function;
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   /**
    *  initializes the action
    *  @inheritDoc
    */
   override public function initialize(document:Object=null):void
   {
      super.initialize();
      responder = new Responder(actionSuccess, actionFault);
      _initialized = true;
   }
   
   /**
    *  called on action success
    */
   protected /*abstract*/ function actionSuccess(event:ResultEvent):void
   {
      throw new IllegalOperationError("Concrete actionSuccess method not implemented.");
   }
   
   /**
    *  called on action error
    */
   protected /*abstract*/ function actionFault(event:FaultEvent):void
   {
      dispatchMessage(new NotifyCriticalErrorMsg(
         this, event.fault.faultString, event.fault.faultDetail, event.fault.faultCode, event.fault));
   }
   
}
}