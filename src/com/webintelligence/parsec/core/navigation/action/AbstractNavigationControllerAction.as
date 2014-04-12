/**
 * User: Bart
 * Date: 09/04/2014
 * Time: 12:20
 * Description:
 */

package com.webintelligence.parsec.core.navigation.action
{
import com.webintelligence.parsec.core.log.LogAware;

import org.spicefactory.parsley.core.context.Context;

public class AbstractNavigationControllerAction extends LogAware implements INavigationControllerAction
{

   [MessageDispatcher]
   /**
    *  @private
    */
   public var dispatchMessage:Function;

   /**
    *  @private
    */
   protected var context:Context;


   /**
    *  Constructor
    */
   public function AbstractNavigationControllerAction()
   {
      super();
   }


   /**
    *  @private
    */
   public function register( context:Context ):void
   {
      this.context = context;
   }

   /**
    *  @private
    */
   public function execute():void
   {
      // abstract
   }
}
}
