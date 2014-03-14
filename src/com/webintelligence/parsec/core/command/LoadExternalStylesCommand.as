/**
 * Parsec
 * User: Bart
 * Date: 21/11/2013
 * Time: 19:55
 * Description:
 */

package com.webintelligence.parsec.core.command
{
import com.webintelligence.parsec.core.message.lifecycle.NotifyInternalErrorMsg;

import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;

import mx.core.FlexGlobals;
import mx.core.IMXMLObject;
import mx.events.StyleEvent;
import mx.styles.IStyleManager2;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

public class LoadExternalStylesCommand implements IMXMLObject
{

   /**
    *  @private
    */
   private static const LOG:Logger    = LogContext.getLogger( LoadExternalStylesCommand );

   /**
    *  @private
    */
   private var _lastLog:int;

   /**
    *  @private
    *  style manager pointer
    */
   private var styleManager:IStyleManager2;

   /**
    *  @private
    *  event dispatcher instance returned by the load styles call
    */
   private var styleLoader:IEventDispatcher;

   [MessageDispatcher]
   /**
    *  @private
    */
   public var dispatchMessage:Function;

   /**
    *  url of the styles swf to load
    */
   public var url:String;

   /**
    *  command callback
    */
   public var callback:Function;

   /**
    *  Constructor
    */
   public function LoadExternalStylesCommand()
   {
      super();
   }

   //--------------------------------------------------------------------------
   //
   //   methods
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   public function initialized( document:Object, id:String ):void
   {
      styleManager = getStyleManager();
   }

   /**
    *  executes the command
    */
   public function execute():void
   {
      if ( !url || url == "" )
      {
         LOG.fatal( "Invalid or no url specified" );
         throw new Error( "Invalid or no url specified" );
      }

      LOG.debug( "Start loading styles: {0}", url );

      styleManager = getStyleManager();
      styleLoader = styleManager.loadStyleDeclarations2( url, true, ApplicationDomain.currentDomain );
      registerEventListeners();
   }

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


   /**
    *  @private
    */
   private function styleLoader_completeHandler( event:StyleEvent ):void
   {
      LOG.debug( "Finished loading styles: {0}", url );
      unregisterEventListeners();
      callback( 1 );
   }

   /**
    *  @private
    */
   private function styleLoader_progressHandler( event:StyleEvent ):void
   {
      var p:int = ( event.bytesLoaded / event.bytesTotal ) * 100;
      if ( p % 10 == 0 && p != _lastLog )
      {
         var tk:int = Math.floor( ( event.bytesTotal + 1023 ) / 1024 );
         var lk:int = Math.floor( ( event.bytesLoaded + 1023 ) / 1024 );
         LOG.debug( "Progress loading styles ({0}): {2}kB/{3}kB ({1}%) complete", url, p, lk, tk );
         _lastLog = p;
      }
   }

   /**
    *  @private
    */
   private function styleLoader_errorHandler( event:StyleEvent ):void
   {
      LOG.error( "Error loading styles: {0}, error: {1}", url, event.errorText );
      callback( -1 );
      dispatchMessage(new NotifyInternalErrorMsg( this, "Error loading styles", event.errorText ));
   }

}
}
