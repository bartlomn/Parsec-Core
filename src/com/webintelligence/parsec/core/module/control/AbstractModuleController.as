/**
 * User: Bart
 * Date: 12/04/2014
 * Time: 18:10
 * Description:
 */

package com.webintelligence.parsec.core.module.control
{
import com.webintelligence.parsec.core.invalidating.InvalidatingEventDispatcher;
import com.webintelligence.parsec.core.module.event.ModuleControllerEvent;

[Event(name="moduleDestinationsChanged",
      type="com.webintelligence.parsec.core.module.event.ModuleControllerEvent")]

public class AbstractModuleController extends InvalidatingEventDispatcher implements IParsecModuleController
{

   /**
    *  @private
    */
   private var _moduleDestinations:Array;

   [Bindable(event="moduleDestinationsChanged")]
   /**
    *  @return List of destination descriptors that the module exposes
    */
   public function get moduleDestinations():Array
   {
      return _moduleDestinations;
   }
   /**
    *  @private
    */
   public function set moduleDestinations( value:Array ):void
   {
      if( value != _moduleDestinations )
      {
         _moduleDestinations = value;
         _log.debug( "Setting destinations available for module" );
         moduleDestinationsChangedHandler();
         dispatchEvent( new ModuleControllerEvent( ModuleControllerEvent.MODULE_DESTINATIONS_CHANGED ));
      }
   }

   /**
    *  Constructor
    */
   public function AbstractModuleController()
   {
      super();
   }

   [Init]
   /**
    *  @private
    */
   public function initHandler():void
   {
      if( !isInitialized )
         initialize();
   }

   /**
    *  @private
    */
   protected function moduleDestinationsChangedHandler():void
   {
      // abstract;
   }
}
}
