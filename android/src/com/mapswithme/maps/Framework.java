package com.mapswithme.maps;

/**
 *  This class wraps android::Framework.cpp class
 *  via static methods
 */
public class Framework
{

  public interface OnApiPointActivatedListener
  {
    public void onApiPointActivated(double lat, double lon, String name, String id);
  }
  
  public interface OnPoiActivatedListener 
  {
    public void onPoiActivated(String name, String type, String address, double lat, double lon);
  }
  
  public interface OnBookmarkActivatedListener
  {
    public void onBookmarkActivated(int category, int bookmarkIndex);
  }

  // Interface

  public static String getNameAndAddress4Point(double pixelX, double pixelY)
  {
    return nativeGetNameAndAddress4Point(pixelX, pixelY);
  }
  
  public static void passApiUrl(String url) 
  {
    nativePassApiUrl(url);
  }

  public static void setOnApiPointActivatedListener(OnApiPointActivatedListener listener)
  {
    nativeSetApiPointActivatedListener(listener);
  }

  public static void clearOnApiPointActivatedListener()
  {
    nativeClearApiPointActivatedListener();
  }
  
  public static void setOnPoiActivatedListener(OnApiPointActivatedListener listener)
  {
    nativeSetOnPoiActivatedListener(listener);
  }
  
  public static void clearOnPoiActivatedListener()
  {
    nativeClearOnPoiActivatedListener();
  }
  
  public static void setOnBookmarkActivatedListener(OnBookmarkActivatedListener listener)
  {
    nativeSetOnBookmarkActivatedListener(listener);
  }
  
  public static void clearOnBookmarkActivatedListener()
  {
    nativeClearOnBookmarkActivatedListener();
  }

  public static void clearApiPoints()
  {
    nativeClearApiPoints();
  }

  /*
   *  "Implementation" - native methods
   */
  
  private native static void nativePassApiUrl(String url);

  private native static String nativeGetNameAndAddress4Point(double pointX, double pointY);
  
  // API point
  private native static void nativeSetApiPointActivatedListener(OnApiPointActivatedListener listener);
  private native static void nativeClearApiPointActivatedListener();
  // POI
  private native static void nativeSetOnPoiActivatedListener(OnApiPointActivatedListener listener);
  private native static void nativeClearOnPoiActivatedListener();
  // Bookmark
  private native static void nativeSetOnBookmarkActivatedListener(OnBookmarkActivatedListener listener);
  private native static void nativeClearOnBookmarkActivatedListener();

  private native static void nativeClearApiPoints();

  // this class is just bridge between Java and C++ worlds, we must not create it
  private Framework() {}
}
