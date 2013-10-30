package com.webintelligence.parsec.core.popup
{
import flash.events.Event;
import flash.events.IEventDispatcher;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 25 Oct 2011
 *   Abstract PM class for pop-ups featuring title
 * 
 ***************************************************************************/

//-------------------------------------------
//  Events
//-------------------------------------------
/*
*   Dispatched after title change
*/
[Event(name="notificationPopUpTitleChanged", type="flash.events.Event")]

public class TitleEnabledPopUpPM 
   extends AbstractPopUpPM
{
   
   //--------------------------------------------------------------------------
   //
   //  Class variables
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   protected static const TITLE_CHANGED:String = "notificationPopUpTitleChanged";
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function TitleEnabledPopUpPM(target:IEventDispatcher=null)
   {
      super(target);
      useResources = true;
   }
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  title
   //--------------------------------------
   
   /**
    *  @private
    *  title property internal storage
    */
   private var _title:String;
   
   [Bindable("notificationPopUpTitleChanged")]
   [Bindable("change")]
   
   /**
    *  checks if title set can be found in resources and returns it
    *  if not, throws an error
    */
   public function get title():String
   {
      if(!_title || !_title.length)
         return "";
      if(useResources)
      {
         var resourceLabel:String = getLabel(_title);
         if(resourceLabel == null)
            throw new Error("String not found in locale! Check aproproiate .properies file.");
         return resourceLabel;
      }
      return _title;
   }
   
   /**
    *  sets the id of the resource entry to be returned
    */
   public function set title(value:String):void
   {
      if(_title != value)
      {
         _title = value;
         dispatchEvent(new Event(TITLE_CHANGED));
      }
   }
   
   //--------------------------------------
   //  useResources
   //--------------------------------------
   
   /**
    *  flag indicating whether to use resource files when returning title
    */
   protected var useResources:Boolean;
   
}
}