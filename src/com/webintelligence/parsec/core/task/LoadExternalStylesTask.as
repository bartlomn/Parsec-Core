package com.webintelligence.parsec.core.task
{

import com.webintelligence.parsec.core.util.LocationUtil;

import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;

import mx.core.FlexGlobals;
import mx.events.StyleEvent;
import mx.styles.IStyleManager2;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

/***************************************************************************
 *
 *   @author nowabart
 *   @created 12 Oct 2011
 *   Task based wrapper for loading external compiled stylesheets
 *
 ***************************************************************************/

public class LoadExternalStylesTask extends TaskBase
{

   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   private static const LOG:Logger    = LogContext.getLogger( LoadExternalStylesTask );

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   [Deprecated("Use MapCommandTag now")]
   /**
    *  Constructor
    */
   public function LoadExternalStylesTask()
   {
      super();
      timeout = 30000; // 30 seconds of inactivity

      // for testing
      var loadTimeout:Number = Number( LocationUtil.getQueryParameter( "load_timeout" ));
      if ( loadTimeout )
         timeout = Number( loadTimeout );
   }

   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    *  event dispatcher instance returned by the load styles call
    */
   private var styleLoader:IEventDispatcher;

   /**
    *  @private
    *  style manager pointer
    */
   private var styleManager:IStyleManager2;

   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  url
   //--------------------------------------
   /**
    *  url of the styles swf to load
    */
   public var url:String;

   //--------------------------------------
   //  immediateUpdate
   //--------------------------------------
   /**
    *  if <code>true</code> updates displayList immediately after succesful load
    */
   public var immediateUpdate:Boolean = true;

   //--------------------------------------
   //  targetDomain
   //--------------------------------------
   /**
    *  which domain to load the styles to
    */
   public var targetDomain:ApplicationDomain;

   //--------------------------------------------------------------------------
   //
   //  Overriden methods: TaskBase
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   override public function initialized( document:Object, id:String ):void
   {
      styleManager = getStyleManager();
      if ( !targetDomain )
         targetDomain = ApplicationDomain.currentDomain;
   }

   /**
    *  @private
    */
   override protected function doStart():void
   {
      super.doStart();
      if ( enabled )
      {
         if ( !url || url == "" )
            throw new Error( "Invalid or no url specified" );

         LOG.debug( "Start loading styles: {0}", url );
         styleLoader = styleManager.loadStyleDeclarations2( url, immediateUpdate, targetDomain );

         registerEventListeners();
      }
   }

   //--------------------------------------------------------------------------
   //
   //  Private methods
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    *  get IStyleManager2 instance
    */
   private function getStyleManager():IStyleManager2
   {
      var tla:Object = FlexGlobals.topLevelApplication;
      if ( !tla.hasOwnProperty( "styleManager" || !( tla.styleManager is IStyleManager2 )))
         throw new Error( "Can't get IStyleManager2 implementation" );

      return tla.styleManager;
   }

   /**
    *  @private
    */
   private function registerEventListeners():void
   {
      styleLoader.addEventListener( StyleEvent.COMPLETE, styleLoader_completeHandler );
      styleLoader.addEventListener( StyleEvent.PROGRESS, styleLoader_progressHandler );
      styleLoader.addEventListener( StyleEvent.ERROR, styleLoader_errorHandler );
   }

   /**
    *  @private
    */
   private function unregisterEventListeners():void
   {
      styleLoader.removeEventListener( StyleEvent.COMPLETE, styleLoader_completeHandler );
      styleLoader.removeEventListener( StyleEvent.PROGRESS, styleLoader_progressHandler );
      styleLoader.removeEventListener( StyleEvent.ERROR, styleLoader_errorHandler );
   }

   //--------------------------------------------------------------------------
   //
   //  Event Handlers
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   private function styleLoader_completeHandler( event:StyleEvent ):void
   {
      LOG.debug( "Finished loading styles: {0}", url );
      unregisterEventListeners();
      complete();
   }

   /**
    *  @private
    */
   private function styleLoader_progressHandler( event:StyleEvent ):void
   {
      startTimer(); // or re-start
      var p:int = ( event.bytesLoaded / event.bytesTotal ) * 100;
      if ( p % 10 == 0 )
         LOG.debug( "Progress loading styles ({0}): {1}% complete", url, p );
   }

   /**
    *  @private
    */
   private function styleLoader_errorHandler( event:StyleEvent ):void
   {
      LOG.error( "Error loading styles: {0}, error: {1}", url, event.errorText );
      error( "Failed to load styles '" + url + "', error: " + event.errorText );
   }
}
}
