package com.webintelligence.parsec.core.popup
{
import com.webintelligence.parsec.core.locale.AbstractLocalizablePM;

import flash.events.Event;
import flash.events.IEventDispatcher;


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
   public function AbstractPopUpPM(target:IEventDispatcher=null)
   {
      super(target);
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
   
   [Bindable("popUpOpenPropertyChanged")]
   
   /**
    *  @see IPopUpPM
    */
   public function get open():Boolean
   {
      return _open;
   }
   
   public function set open(value:Boolean):void
   {
      if(_open != value)
      {
         _open = value;
         dispatchEvent(new Event(OPEN_PROP_CHANGED));
      }
   }
   
}
}