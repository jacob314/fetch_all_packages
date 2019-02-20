package com.example.flutterfolioreader

import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Rect
import android.net.Uri
import android.os.Build
import android.support.v4.content.LocalBroadcastManager
import android.support.v4.view.PagerAdapter
import android.support.v4.view.ViewPager
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.TextView
import com.folioreader.Config
import com.folioreader.Constants
import com.folioreader.FolioReader
import com.folioreader.model.HighLight
import com.folioreader.model.HighlightImpl
import com.folioreader.model.ReadPosition
import com.folioreader.model.event.MediaOverlayPlayPauseEvent
import com.folioreader.ui.folio.activity.FolioActivity
import com.folioreader.ui.folio.activity.FolioActivityCallback
import com.folioreader.ui.folio.adapter.FolioPageFragmentAdapter
import com.folioreader.ui.folio.adapter.FolioPageViewAdapter
import com.folioreader.ui.folio.fragment.FolioPageFragment
import com.folioreader.util.AppUtil
import com.folioreader.util.FileUtil
import com.folioreader.util.OnHighlightListener
import com.folioreader.view.DirectionalViewpager
import com.folioreader.view.FolioPageView
import com.mcxiaoke.koi.ext.getWindowService
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.greenrobot.eventbus.EventBus
import org.readium.r2.shared.Link
import org.readium.r2.shared.Publication
import org.readium.r2.streamer.parser.CbzParser
import org.readium.r2.streamer.parser.EpubParser
import org.readium.r2.streamer.parser.PubBox
import org.readium.r2.streamer.server.Server
import java.lang.ref.WeakReference

public class FlutterFolioViewPager(val context: Context, val messenger: BinaryMessenger, val id: Int, val epubFilePath: String) :
    PlatformView, FolioActivityCallback, MethodChannel.MethodCallHandler {

  private val LOG_TAG = "FlutterFolioViewPager"
  private lateinit var bookFileName: String
  private var pubBox: PubBox? = null
  private lateinit var r2StreamerServer: Server
  private lateinit var spine: MutableList<Link>
  private var mBookId: String? = null
  private var searchUri: Uri? = null
  private lateinit var mFolioPageViewPager: DirectionalViewpager
  private lateinit var mFolioPageViewAdapter: FolioPageViewAdapter
  private var entryReadPosition: ReadPosition? = null
  private var currentChapterIndex = 0
  private var lastReadPosition: ReadPosition? = null
  private lateinit var direction: Config.Direction
  private lateinit var folioReader: FolioReader
  private val channel = MethodChannel(messenger, "flutter_folioreader")

  init {
    setConfig()
    setupBook()
  }

  /**
   * required
   */
  private fun setConfig() {
    val config = Config()
    AppUtil.saveConfig(context, config)
    direction = config.direction
  }

  private fun setupBook() {
    try {
      initBook()
      onBookInitSuccess()
      initFolioReader()
    } catch (e: Exception) {
      Log.e(LOG_TAG, e.message)
    }
  }

  @Throws(Exception::class)
  private fun initBook() {
    bookFileName = FileUtil.getEpubFilename(context, FolioActivity.EpubSourceType.SD_CARD, epubFilePath, 0)
    val path = FileUtil.saveEpubFileAndLoadLazyBook(context, FolioActivity.EpubSourceType.SD_CARD, epubFilePath,
        0, bookFileName)
    val extension: Publication.EXTENSION
    var extensionString: String? = null
    try {
      extensionString = FileUtil.getExtensionUppercase(path)
      extension = Publication.EXTENSION.valueOf(extensionString)
    } catch (e: IllegalArgumentException) {
      throw Exception("-> Unknown book file extension `$extensionString`", e)
    }

    when (extension) {
      Publication.EXTENSION.EPUB -> {
        val epubParser = EpubParser()
        pubBox = epubParser.parse(path, "")
      }
      Publication.EXTENSION.CBZ -> {
        val cbzParser = CbzParser()
        pubBox = cbzParser.parse(path, "")
      }
    }

    val portNumber = 8080 //getIntent().getIntExtra(Config.INTENT_PORT, Constants.PORT_NUMBER)
    r2StreamerServer = Server(portNumber)
    r2StreamerServer.start()
    r2StreamerServer.addEpub(pubBox!!.publication, pubBox!!.container,
        "/$bookFileName", null)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "highlight" -> {
        print("onMethodCall-------highlight")
        val style = call.argument<Int>("style")!!
        print("onMethodCall-------highlight: ${style})")
        print(HighlightImpl.HighlightStyle.values()[style])
        mFolioPageViewAdapter.getItem(mFolioPageViewPager.currentItem).highlight(HighlightImpl.HighlightStyle.values()[style], false)
      }
      "delete_highlight" -> mFolioPageViewAdapter.getItem(mFolioPageViewPager.currentItem).deleteHighlight()
    }
  }

  private fun initFolioReader() {
    channel.setMethodCallHandler(this)
    println("------------initFolioReader-------------")
    folioReader = FolioReader.get()
        .setOnHighlightListener(object : OnHighlightListener() {
          override fun onHighlight(highlight: HighLight?, type: HighLight.HighLightAction?) {
            val data: HashMap<String, Any> = HashMap()
            data["rangy"] = highlight!!.rangy
            data["bookId"] = highlight.bookId
            data["content"] = highlight.content
            data["type"] = highlight.type
            data["pageNumber"] = highlight.pageNumber
            data["pageId"] = highlight.pageId
            data["uuid"] = highlight.uuid
            if (highlight.note != null) data["note"] = highlight.note
            channel.invokeMethod("highlight", data)
          }

          override fun onTriggerHighlight(rect: Rect?, highlightId: String?) {
            val data: HashMap<String, Any> = HashMap()
            data["left"] = rect!!.left
            data["top"] = rect.top
            data["right"] = rect.right
            data["bottom"] = rect.bottom
            if (highlightId != null) {
              data["id"] = highlightId
            }
            channel.invokeMethod("trigger_highlight", data)
          }

          override fun onDeleteHighlight(highLight: HighLight?) {
            val data: HashMap<String, Any> = HashMap()
            data["highlightId"] = highLight!!.uuid
            channel.invokeMethod("deleteHighlight", data)
          }

          override fun onDismissPopup() {
            channel.invokeMethod("dismiss_popup", null)
          }
        })
  }

  /**
   * correct book id, init spine and search uri
   */
  fun onBookInitSuccess() {
    val publication = pubBox!!.publication
    spine = publication.spine

    if (mBookId == null) {
      if (!publication.metadata.identifier.isEmpty()) {
        mBookId = publication.metadata.identifier
      } else {
        if (!publication.metadata.title.isEmpty()) {
          mBookId = publication.metadata.title.hashCode().toString()
        } else {
          mBookId = bookFileName.hashCode().toString()
        }
      }
    }

    for (link in publication.links) {
      if (link.rel.contains("search")) {
        searchUri = Uri.parse("http://" + link.href!!)
        break
      }
    }
    if (searchUri == null)
      searchUri = Uri.parse(Constants.LOCALHOST + bookFileName + "/search")

    configFolio()
  }

  private fun configFolio() {
    mFolioPageViewPager = DirectionalViewpager(context)
    // Replacing with addOnPageChangeListener(), onPageSelected() is not invoked
    mFolioPageViewPager.setOnPageChangeListener(object : DirectionalViewpager.OnPageChangeListener {
      override fun onPageScrolled(position: Int, positionOffset: Float, positionOffsetPixels: Int) {}

      override fun onPageSelected(position: Int) {
        Log.v(LOG_TAG, "-> onPageSelected -> DirectionalViewpager -> position = $position")

//        EventBus.getDefault().post(MediaOverlayPlayPauseEvent(
//            spine[currentChapterIndex].href, false, true))
//        mediaControllerFragment.setPlayButtonDrawable()
        currentChapterIndex = position
      }

      override fun onPageScrollStateChanged(state: Int) {

        if (state == DirectionalViewpager.SCROLL_STATE_IDLE) {
          val position = mFolioPageViewPager.getCurrentItem()
          Log.v(LOG_TAG, "-> onPageScrollStateChanged -> DirectionalViewpager -> " + "position = " + position)

          var folioPageView = mFolioPageViewAdapter.getItem(position - 1)
          if (folioPageView != null) {
            folioPageView.scrollToLast()
            if (folioPageView.mWebview != null)
              folioPageView.mWebview.dismissPopupWindow()
          }

          folioPageView = mFolioPageViewAdapter.getItem(position + 1)
          if (folioPageView != null) {
            folioPageView.scrollToFirst()
            if (folioPageView.mWebview != null)
              folioPageView.mWebview.dismissPopupWindow()
          }
        }
      }
    })

    mFolioPageViewPager.setDirection(direction)

    mFolioPageViewAdapter = FolioPageViewAdapter(context, spine, bookFileName, mBookId)
    mFolioPageViewAdapter.setActivityCallback(this)
    mFolioPageViewPager.setAdapter(mFolioPageViewAdapter)


    // In case if SearchActivity is recreated due to screen rotation then FolioActivity
    // will also be recreated, so searchItem is checked here.
//    if (searchItem != null) {
//
//      currentChapterIndex = getChapterIndex(Constants.HREF, searchItem.getHref())
//      mFolioPageViewPager.setCurrentItem(currentChapterIndex)
//      val folioPageFragment = getCurrentFragment() ?: return
//      folioPageFragment!!.highlightSearchItem(searchItem)
//      searchItem = null
//
//    } else {
//
//      val readPosition: ReadPosition?
//      if (savedInstanceState == null) {
//        readPosition = getIntent().getParcelableExtra(FolioActivity.EXTRA_READ_POSITION)
//        entryReadPosition = readPosition
//      } else {
//        readPosition = savedInstanceState.getParcelable(BUNDLE_READ_POSITION_CONFIG_CHANGE)
//        lastReadPosition = readPosition
//      }
//      currentChapterIndex = getChapterIndex(readPosition)
//      mFolioPageViewPager.setCurrentItem(currentChapterIndex)
//    }

//    LocalBroadcastManager.getInstance(context).registerReceiver(searchReceiver,
//        IntentFilter(ACTION_SEARCH_CLEAR))
  }

  override fun getView(): View {
    return mFolioPageViewPager
  }

  fun getCurrentPageView(): FolioPageView {
    return mFolioPageViewAdapter.getItem(mFolioPageViewPager.currentItem)
  }

  override fun dispose() {
    r2StreamerServer.stop()
//    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun getCurrentChapterIndex(): Int {
    return currentChapterIndex
  }

  override fun getActivity(): WeakReference<FolioActivity>? {
    return null
  }

  override fun getEntryReadPosition(): ReadPosition? {
    if (entryReadPosition != null) {
      val tempReadPosition = entryReadPosition
      entryReadPosition = null
      return tempReadPosition
    }
    return null
  }

  override fun onDirectionChange(newDirection: Config.Direction?) {
    Log.v(LOG_TAG, "-> onDirectionChange")

//    var folioPageView = getCurrentFragment() ?: return
//    entryReadPosition = folioPageFragment!!.getLastReadPosition()
//    val searchItemVisible = folioPageFragment!!.searchItemVisible
//
//    direction = newDirection
//
//    mFolioPageViewPager.setDirection(newDirection)
//    mFolioPageFragmentAdapter = FolioPageFragmentAdapter(getSupportFragmentManager(),
//        spine, bookFileName, mBookId)
//    val adapter = FolioPageViewAdapter(this, spine, bookFileName, mBookId)
//    adapter.setActivityCallback(this)
//    mFolioPageViewPager.adapter = adapter
//    mFolioPageViewPager.currentItem = currentChapterIndex
//
//    folioPageFragment = getCurrentFragment()
//    if (folioPageFragment == null) return
//    if (searchItemVisible != null)
//      folioPageFragment!!.highlightSearchItem(searchItemVisible!!)
  }

  override fun getBottomDistraction(): Int {
    return 0
  }

  override fun setNightMode() {
//    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun toggleSystemUI() {
//    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun goToChapter(href: String?): Boolean {
    for (link in spine) {
      if (href?.contains(link.href!!) ?: false) {
        currentChapterIndex = spine.indexOf(link)
        mFolioPageViewPager.currentItem = currentChapterIndex
        val folioPageView = getCurrentPageView()
        folioPageView!!.scrollToFirst()
        folioPageView!!.scrollToAnchorId(href)
        return true
      }
    }
    return false
  }

  override fun setDayMode() {
//    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun getTopDistraction(): Int {
    return 0
  }

  override fun getDirection(): Config.Direction {
    return direction
  }

  override fun storeLastReadPosition(lastReadPosition: ReadPosition?) {
    this.lastReadPosition = lastReadPosition
  }

  override fun getViewportRect(): Rect {
    val displayMetrics = context.getResources().getDisplayMetrics();
    return Rect(0, 0, displayMetrics.widthPixels, displayMetrics.heightPixels)
  }

//  fun showSystemUI() {
//    Log.v(LOG_TAG, "-> showSystemUI")
//
//    if (Build.VERSION.SDK_INT >= 16) {
//      val decorView = getWindow().getDecorView()
//      decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//          or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//          or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
//    } else {
//      context.getWindowService().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
//      if (appBarLayout != null)
//        appBarLayout.setTopMargin(getStatusBarHeight())
//      onSystemUiVisibilityChange(View.SYSTEM_UI_FLAG_VISIBLE)
//    }
//  }
//
//  fun hideSystemUI() {
//    Log.v(LOG_TAG, "-> hideSystemUI")
//
//    if (Build.VERSION.SDK_INT >= 16) {
//      val decorView = getWindow().getDecorView()
//      decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_IMMERSIVE
//          // Set the content to appear under the system bars so that the
//          // content doesn't resize when the system bars hide and show.
//          or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//          or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
//          or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
//          // Hide the nav bar and status bar
//          or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
//          or View.SYSTEM_UI_FLAG_FULLSCREEN)
//    } else {
//      getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
//          WindowManager.LayoutParams.FLAG_FULLSCREEN or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
//      // Specified 1 just to mock anything other than View.SYSTEM_UI_FLAG_VISIBLE
//      onSystemUiVisibilityChange(1)
//    }
//  }

//  override fun onHighlight(highlight: HighLight?, type: HighLight.HighLightAction?) {
//    val data: HashMap<String, Any> = HashMap()
//    data["rangy"] = highlight!!.rangy
//    data["bookId"] = highlight.bookId
//    data["content"] = highlight.content
//    data["type"] = highlight.type
//    data["pageNumber"] = highlight.pageNumber
//    data["pageId"] = highlight.pageId
//    data["uuid"] = highlight.uuid
//    if (highlight.note != null) data["note"] = highlight.note
//    channel.invokeMethod("highlight", data)
//  }
//
//  override fun onTriggerHighlight(rect: Rect?) {
//    print("22222222222222222222222222222222222")
//    val data: HashMap<String, Any> = HashMap()
//    data["left"] = rect!!.left
//    data["top"] = rect.top
//    data["right"] = rect.right
//    data["bottom"] = rect.bottom
//    channel.invokeMethod("trigger_highlight", data)
//  }
}