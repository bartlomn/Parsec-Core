package com.webintelligence.parsec.core.locale
{
import com.webintelligence.parsec.core.invalidating.InvalidatingEventDispatcher;

import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 24 Oct 2011
 *   Base class for all PMs with localization capabilities
 * 
 ***************************************************************************/

public /* abstract */ class AbstractLocalizablePM 
   extends InvalidatingEventDispatcher
   implements ILocalizablePM
{
   
   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    *  pointer to the resource manager
    */
   protected static var RESOURCE:IResourceManager = ResourceManager.getInstance();
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function AbstractLocalizablePM()
   {
      super();
   }
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  property
   //--------------------------------------
   /**
    *  which resource package to use with class implementation
    */
   public var resourcePackage:String;
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  public method
   //--------------------------------------
   
   [Bindable("change")]
   
   /**
    *  @see ILocalizablePM
    */
   public function getLabel(id:String, params:Array = null):String
   {
      if(!resourcePackage || !resourcePackage.length)
         throw new Error("Resource package name not defined in " + this);
      
      return RESOURCE.getString(resourcePackage, id, params);
   }
   
}
}