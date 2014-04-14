package com.webintelligence.parsec.core.popup
{
import com.webintelligence.parsec.core.locale.AbstractLocalizablePM;

import flash.events.Event;
import flash.events.IEventDispatcher;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;

/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 24 Oct 2011
 *   Description
 * 
 ***************************************************************************/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched after open property changes
 */
[Event(name="popUpOpenPropertyChanged", type="flash.events.Event")]

public /* abstract */ class AbstractPopUpPM
   extends AbstractLocalizablePM 
   implements IPopUpPM
{
   
   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   protected var LOG:Logger = LogContext.getLogger( ClassInfo.forInstance( this ).getClass() );

   /**
    *  enumerates open property change event type
    */
   protected static const OPEN_PROP_CHANGED:String = "popUpOpenPropertyChanged";
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function AbstractPopUpPM()
   {
      super();
   }
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  modal
   //--------------------------------------
   
   [Bindable]
   
   /**
    *  is the popup modal ?
    */
   public var modal:Boolean;
   
   //--------------------------------------
   //  open
   //--------------------------------------

   /**
    *  @private
    */
   private var _open:Boolean;
   
   /**
    *  @private
    */
   private var _openChanged:Boolean;

   [Bindable("popUpOpenPropertyChanged")]
   /**
    *  @see IPopUpPM
    */
   public function get open():Boolean
   {
      return _open;
   }
   /**
    *  @private
    */
   public function set open(value:Boolean):void
   {
      if( !isInitialized )
         initialize();

      if(_open != value)
      {
         _open = value;
         _openChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _openChanged )
      {
         dispatchEvent(new Event(OPEN_PROP_CHANGED));
         _openChanged = false;
      }
   }
}
}