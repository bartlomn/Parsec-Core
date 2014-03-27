package com.webintelligence.parsec.core.invalidating
{

import com.webintelligence.parsec.core.log.LogAwareEventDispatcher;

import mx.core.FlexGlobals;
import mx.core.IMXMLObject;
import mx.core.UIComponent;

import org.spicefactory.lib.errors.IllegalStateError;

/***************************************************************************
 * 
 *   @author bnowak 
 *   @created Dec 20, 2012
 *
 *   Base for non-display objects that require invalidation / validation 
 * 
 ***************************************************************************/

public class InvalidatingEventDispatcher
   extends LogAwareEventDispatcher
   implements IMXMLObject
{
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function InvalidatingEventDispatcher()
   {
      super();
   }
   
   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    *  UIComponent reference, can be the used to access the framework's
    *  callLater mechanism.  This can be the enclosing object, if it is a
    *  UIComponent, otherwise this class will try to use the top level
    *  application instance.
    */
   private var uiComponent:UIComponent;
   
   /**
    *  @private
    *  Invalidation might have been requested the component had access to the
    *  UIComponent#callLater function.  This flag allows the request to be
    *  remembered  So once the uiComponent has been set, the first round of
    *  validation can be triggered.
    */
   private var callLaterPending:Boolean;
   
   /**
    *  @private
    */
   private var invalidatePropertiesFlag:Boolean;
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  isInitialized
   //--------------------------------------
   
   /**
    *  @private
    *  Storage for the isInitialized property
    */
   private var _isInitialized:Boolean;
   
   /**
    *  If <code>true</code>, property validation has updated at least once.
    */
   public function get isInitialized():Boolean
   {
      return _isInitialized;
   }
   
   //--------------------------------------------------------------------------
   //
   //  Methods: IMXMLObject
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   public function initialized(document:Object, id:String):void
   {
      initialize(document);
   }
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   public function initialize(document:Object = null):void
   {
      uiComponent =
            UIComponent(( document is UIComponent ) ? document : FlexGlobals.topLevelApplication );

      invalidateProperties();
   }
   
   /**
    *  Trigger a call to commitProperties
    */
   public function invalidateProperties():void
   {
      if( !isInitialized )
         _log.warn( "Cannot invalidate. Component not initialised." );

      if (invalidatePropertiesFlag && !callLaterPending)
         return;
      
      invalidatePropertiesFlag = true;
      
      if (uiComponent)
      {
         callLaterPending = false;
         uiComponent.callLater(validateProperties);
      }
      else
      {
         callLaterPending = true;
      }
   }
   
   /**
    *  Trigger immediate validation.
    */
   public function validateNow():void
   {
      validateProperties();
   }
   
   /**
    *  @private
    */
   private function validateProperties():void
   {
      if (invalidatePropertiesFlag)
      {
         invalidatePropertiesFlag = false;
         commitProperties();
      }
      _isInitialized = true;
   }
   
   /**
    *  @private
    */
   protected function commitProperties():void
   {
      // Abstract
   }
}
}