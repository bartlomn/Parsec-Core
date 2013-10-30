package com.webintelligence.parsec.core.task
{

import com.webintelligence.parsec.core.util.LocationUtil;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 20 Dec 2012
 *   Task based wrapper for loading external files
 * 
 ***************************************************************************/

//--------------------------------------
//  EVENTS
//--------------------------------------

/**
 *  Http status response
 */
[Event(name="httpResponseStatus", type="flash.events.HTTPStatusEvent")]

/**
 *  progress
 */
[Event(name="progress", type="flash.events.ProgressEvent")]

/**
 *  load completed
 */
[Event(name="complete", type="flash.events.Event")]

public class LoadExternalFileTask 
   extends TaskBase
{
   
   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   private static const LOG:Logger = LogContext.getLogger(LoadExternalFileTask);
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function LoadExternalFileTask()
   {
      super();
      timeout = 30000; // 30 seconds of inactivity
      
      // for testing
      var loadTimeout:Number = Number(LocationUtil.getQueryParameter("load_timeout"));
      if (loadTimeout)
         timeout = Number(loadTimeout);
   }
   
   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    *  URLLoader instance doing the actual loading
    */
   private var loader:URLLoader;
   
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
   //  bytesLoaded
   //--------------------------------------
   
   [Bindable("progress")]
   
   /**
    *  exposes bytesLoaded property of internal loader
    */
   public function get bytesLoaded():uint
   {
      return loader ?
         loader.bytesLoaded :
         0;
   }
   
   //--------------------------------------
   //  bytesTotal
   //--------------------------------------
   
   [Bindable("progress")]
   
   /**
    *  exposes bytesTotal property of internal loader
    */
   public function get bytesTotal():uint
   {
      return loader ?
         loader.bytesTotal :
         0;
   }
   
   //--------------------------------------
   //  data
   //--------------------------------------
   
   [Bindable("complete")]
   
   /**
    *  exposes data loaded
    */
   override public function get data():*
   {
      return loader ?
         loader.data :
         null;
   }
   
   /**
    *  data setter override
    */
   override public function set data(data:*):void
   {
      throw new IllegalOperationError("Cannot set data on loader!");
   }
   
   //--------------------------------------
   //  dataFormat
   //--------------------------------------
   /**
    *  @private
    *  property storage
    */
   private var _dataFormat:String = URLLoaderDataFormat.TEXT;
      
   /**
    *  data format for the laoder
    *  @default: URLLoaderDataFormat.TEXT
    */
   public function get dataFormat():String
   {
      return _dataFormat;
   }
   public function set dataFormat(value:String):void
   {
      if(value != _dataFormat)
      {
         if(loader && loader.bytesTotal != 0)
            throw new IllegalOperationError("Cannot change data format during ongoing load operation.");
         _dataFormat = value;
      }
   }
   
   //--------------------------------------------------------------------------
   //
   //  Overriden methods: TaskBase
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   override public function initialized(document:Object, id:String):void
   {
      super.initialized(document, id);
      loader = new URLLoader();
      loader.dataFormat = dataFormat;
   }
   
   /**
    *  @private
    */
   override protected function doStart():void 
   {
      super.doStart();
      if (enabled)
      {
         if (!url || url == "")
            throw new Error("Invalid or no url specified");
         
         LOG.debug("Start loading file: {0}", url);
         registerEventListeners();
         loader.load(new URLRequest(url));
      }
   }
   
   //--------------------------------------------------------------------------
   //
   //  Private methods
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    *  register loeader's event listeners
    */
   private function registerEventListeners():void
   {
      loader.addEventListener(Event.COMPLETE, loader_completeHandler);
      loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
      loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
      loader.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
   }
   
   /**
    *  @private
    *  unregister loader's event listeners
    */
   private function unregisterEventListeners():void
   {
      loader.removeEventListener(Event.COMPLETE, loader_completeHandler);
      loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
      loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
      loader.removeEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
   }
   
   //--------------------------------------------------------------------------
   //
   //  Event Handlers
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   private function loader_completeHandler(event:Event):void
   {
      LOG.debug("Finished loading file: {0}", url);
      unregisterEventListeners();
      event.stopPropagation();
      dispatchEvent(event);
      complete();
   }
   
   /**
    *  @private
    */
   private function loader_httpResponseStatusHandler(event:HTTPStatusEvent):void
   {
      LOG.debug("HTTP response status for file: {0}, status: {1}", url, event.status);
      event.stopPropagation();
      dispatchEvent(event);
   }
   
   /**
    *  @private
    */
   private function loader_progressHandler(event:ProgressEvent):void
   {
      event.stopPropagation();
      startTimer(); // or re-start
      dispatchEvent(event);
      LOG.debug("Progress loading file: {0}, {1} of {2} bytes", url, event.bytesLoaded, event.bytesTotal);
   }
   
   /**
    *  @private
    */
   private function loader_errorHandler(event:*):void
   {
      unregisterEventListeners();
      LOG.debug("Error loading file: {0}, error: {1}", url, event.text);
      error("Failed to load file '" + url + "', error: " + event.text);
   }
}
}