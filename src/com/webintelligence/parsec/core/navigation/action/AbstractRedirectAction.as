/**
 * User: Bart
 * Date: 09/04/2014
 * Time: 13:15
 * Description:
 */

package com.webintelligence.parsec.core.navigation.action
{
import com.webintelligence.parsec.core.navigation.NavigationRequest;
import com.webintelligence.parsec.core.navigation.destination.Destination;

public class AbstractRedirectAction extends AbstractNavigationControllerAction
{

   /**
    *  @private
    */
   private var _redirectTo:Destination;

   /**
    *  @private
    */
   public function get redirectTo() : Destination
   {
      return _redirectTo;
   }
   /**
    *  @private
    */
   public function set redirectTo( value : Destination ) : void
   {
      _redirectTo = value;
   }

   /**
    *  Constructor
    */
   public function AbstractRedirectAction()
   {
      super();
   }


   /**
    *  @private
    */
   override public function execute() : void
   {
      super.execute();
      if( redirectTo )
      {
         _log.debug( "Redirecting navigation to {0}", redirectTo.id );
         dispatchMessage( NavigationRequest.createFor( redirectTo ));
      }
   }
}
}
