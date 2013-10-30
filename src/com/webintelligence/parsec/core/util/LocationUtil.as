package com.webintelligence.parsec.core.util
{
import flash.external.ExternalInterface;

/**
 *  Helper for interacting with the HTML page location object
 */
final public /* abstract */
class LocationUtil
{
   /**
    *  The protocol used to serve this Flex app, eg, "http" or "file"
    */
   public static function getProtocol() : String
   {
      var protocol : String = ExternalInterface.call( 'eval', 'document.location.protocol' ); // eg, "http:"
      return protocol.substr( 0, protocol.length - 1 ); // chop off the ":" and return only "http"
   }

   /**
    *  Return all query parameters as a map of key + values
    */
   public static function getQueryParameters() : Object
   {
      if ( ExternalInterface.available )
      {
         try
         {
         var search : String = ExternalInterface.call( 'eval', 'document.location.search' );
         if ( search.charAt( 0 ) == "?" )
            search = search.substring( 1, search.length );
         var params : Object = {};
         var pairs : Array = search.split( "&" );
         for each ( var pair : String in pairs )
         {
            var kv : Array = pair.split( "=" );
            if ( params[kv[0]] == undefined )
            {
               params[kv[0]] = kv[1];
            }
            else if ( params[kv[0]] is Array )
            {
               (params[kv[0]] as Array).push( kv[1] );
            }
            else
            {
               params[kv[0]] = [params[kv[0]], kv[1]];
            }
         }
         return params;
         }
         catch( e:Error )
         {
            return {};
         }
      }
      return {};
   }

   /**
    *  Get the value of a single named query parameter
    */
   public static function getQueryParameter( name : String ) : Object
   {
      return getQueryParameters()[name];
   }
}
}