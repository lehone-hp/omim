fileprivate enum DeeplinkType {
  case geo
  case file
  case common
}

@objc @objcMembers class DeepLinkHandler: NSObject {
  static let shared = DeepLinkHandler()

  private(set) var isLaunchedByDeeplink = false
  private(set) var deeplinkURL: URL?

  var needExtraWelcomeScreen: Bool {
    guard let host = deeplinkURL?.host else { return false }
    return host == "catalogue" || host == "guides_page"
  }

  private var canHandleLink = false
  private var deeplinkType: DeeplinkType = .common

  private override init() {
    super.init()
  }

  func applicationDidFinishLaunching(_ options: [UIApplication.LaunchOptionsKey : Any]? = nil) {
    if let userActivityOptions = options?[.userActivityDictionary] as? [UIApplication.LaunchOptionsKey : Any],
      let userActivityType = userActivityOptions[.userActivityType] as? String,
      userActivityType == NSUserActivityTypeBrowsingWeb {
      isLaunchedByDeeplink = true
    }

    if let launchDeeplink = options?[UIApplication.LaunchOptionsKey.url] as? URL {
      isLaunchedByDeeplink = true
      deeplinkURL = launchDeeplink
    }
  }

  func applicationDidOpenUrl(_ url: URL) -> Bool {
    guard let dlType = deeplinkType(url) else { return false }
    deeplinkType = dlType
    deeplinkURL = url
    if canHandleLink {
      handleInternal()
    }
    return true
  }

  private func setUniversalLink(_ url: URL) -> Bool {
    let dlUrl = convertUniversalLink(url)
    guard let dlType = deeplinkType(dlUrl), deeplinkURL == nil else { return false }
    deeplinkType = dlType
    deeplinkURL = dlUrl
    return true
  }

  func applicationDidReceiveUniversalLink(_ url: URL) -> Bool {
    var result = false
    if let host = url.host, host == "mapsme.onelink.me" {
      URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
        if $0.name == "af_dp" {
          guard let value = $0.value, let dl = URL(string: value) else { return }
          result = setUniversalLink(dl)
        }
      }
    } else {
      result = setUniversalLink(url)
    }
    if canHandleLink {
      handleInternal()
    }
    return result
  }

  func handleDeeplink() {
    canHandleLink = true
    if deeplinkURL != nil {
      handleInternal()
    }
  }

  func handleDeeplink(_ url: URL) {
    deeplinkURL = url
    handleDeeplink()
  }

  func reset() {
    isLaunchedByDeeplink = false
    deeplinkURL = nil
  }

  private func convertUniversalLink(_ universalLink: URL) -> URL {
    let convertedLink = String(format: "mapsme:/%@?%@", universalLink.path, universalLink.query ?? "")
    return URL(string: convertedLink)!
  }

  private func deeplinkType(_ deeplink: URL) -> DeeplinkType? {
    switch deeplink.scheme {
    case "geo", "ge0":
      return .geo
    case "file":
      return .file
    case "mapswithme", "mapsme", "mwm":
      return .common
    default:
      return nil
    }
  }

  private func handleInternal() {
    guard let url = deeplinkURL else {
      assertionFailure()
      return
    }
    switch deeplinkType {
    case .geo:
      DeepLinkHelper.handleGeoUrl(url)
    case .file:
      DeepLinkHelper.handleFileUrl(url)
    case .common:
      DeepLinkHelper.handleCommonUrl(url)
    }
  }
}
