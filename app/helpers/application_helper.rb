require 'numeric'

module ApplicationHelper
  def format_date(date)
    date.try(:strftime, '%a, %d %b %Y')
  end

  def format_datetime(date_time)
    date_time.try(:strftime, '%d %b %Y %I:%M %p')
  end
  
  def currency_codes
    currencies = []
    Money::Currency.table.values.each do |currency|
      currencies = currencies + [[currency[:name] + ' (' + currency[:iso_code] + ')', currency[:iso_code]]]
    end
    currencies
  end

  def sortable(column, title: nil, kclass: controller_path.classify.constantize)
    column = column.to_s
    title ||= kclass.human_attribute_name(column)
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction), {:class => css_class}
  end
  
  def image_tag_retina_detection(name_at_1x, options={})
    name_at_2x = name_at_1x.gsub(%r{\.\w+$}, '-2x\0')
    image_tag(name_at_1x, options.merge("data-at2x" => ActionController::Base.helpers.asset_path(name_at_2x)))
  end

  def both_prices(food_item)
    arr = []
    if food_item.has_special_price?
      arr << "<i><strike>#{humanized_money_with_symbol(food_item.unit_price_without_promotion)}</strike></i>"
    end
    arr << humanized_money_with_symbol(food_item.unit_price)
    arr.join(' / ').html_safe
  end

  def format_price(price, currency_code)
    humanized_money_with_symbol(Money.from_amount(price.to_f, currency_code))
  end

  def icons
    [
    "access-point",
    "access-point-network",
    "account",
    "account-alert",
    "account-box",
    "account-box-outline",
    "account-card-details",
    "account-check",
    "account-circle",
    "account-convert",
    "account-key",
    "account-location",
    "account-minus",
    "account-multiple",
    "account-multiple-minus",
    "account-multiple-outline",
    "account-multiple-plus",
    "account-network",
    "account-off",
    "account-outline",
    "account-plus",
    "account-remove",
    "account-search",
    "account-settings",
    "account-settings-variant",
    "account-star",
    "account-star-variant",
    "account-switch",
    "adjust",
    "air-conditioner",
    "airballoon",
    "airplane",
    "airplane-landing",
    "airplane-off",
    "airplane-takeoff",
    "airplay",
    "alarm",
    "alarm-check",
    "alarm-multiple",
    "alarm-off",
    "alarm-plus",
    "alarm-snooze",
    "album",
    "alert",
    "alert-box",
    "alert-circle",
    "alert-circle-outline",
    "alert-octagon",
    "alert-outline",
    "alpha",
    "alphabetical",
    "altimeter",
    "amazon",
    "amazon-clouddrive",
    "ambulance",
    "amplifier",
    "anchor",
    "android",
    "android-debug-bridge",
    "android-studio",
    "angular",
    "animation",
    "apple",
    "apple-finder",
    "apple-ios",
    "apple-keyboard-caps",
    "apple-keyboard-command",
    "apple-keyboard-control",
    "apple-keyboard-option",
    "apple-keyboard-shift",
    "apple-mobileme",
    "apple-safari",
    "application",
    "appnet",
    "apps",
    "archive",
    "arrange-bring-forward",
    "arrange-bring-to-front",
    "arrange-send-backward",
    "arrange-send-to-back",
    "arrow-all",
    "arrow-bottom-left",
    "arrow-bottom-right",
    "arrow-compress",
    "arrow-compress-all",
    "arrow-down",
    "arrow-down-bold",
    "arrow-down-bold-circle",
    "arrow-down-bold-circle-outline",
    "arrow-down-bold-hexagon-outline",
    "arrow-down-drop-circle",
    "arrow-down-drop-circle-outline",
    "arrow-expand",
    "arrow-expand-all",
    "arrow-left",
    "arrow-left-bold",
    "arrow-left-bold-circle",
    "arrow-left-bold-circle-outline",
    "arrow-left-bold-hexagon-outline",
    "arrow-left-drop-circle",
    "arrow-left-drop-circle-outline",
    "arrow-right",
    "arrow-right-bold",
    "arrow-right-bold-circle",
    "arrow-right-bold-circle-outline",
    "arrow-right-bold-hexagon-outline",
    "arrow-right-drop-circle",
    "arrow-right-drop-circle-outline",
    "arrow-top-left",
    "arrow-top-right",
    "arrow-up",
    "arrow-up-bold",
    "arrow-up-bold-circle",
    "arrow-up-bold-circle-outline",
    "arrow-up-bold-hexagon-outline",
    "arrow-up-drop-circle",
    "arrow-up-drop-circle-outline",
    "assistant",
    "at",
    "attachment",
    "audiobook",
    "auto-fix",
    "auto-upload",
    "autorenew",
    "av-timer",
    "baby",
    "baby-buggy",
    "backburger",
    "backspace",
    "backup-restore",
    "bandcamp",
    "bank",
    "barcode",
    "barcode-scan",
    "barley",
    "barrel",
    "basecamp",
    "basket",
    "basket-fill",
    "basket-unfill",
    "battery",
    "battery-10",
    "battery-20",
    "battery-30",
    "battery-40",
    "battery-50",
    "battery-60",
    "battery-70",
    "battery-80",
    "battery-90",
    "battery-alert",
    "battery-charging",
    "battery-charging-100",
    "battery-charging-20",
    "battery-charging-30",
    "battery-charging-40",
    "battery-charging-60",
    "battery-charging-80",
    "battery-charging-90",
    "battery-minus",
    "battery-negative",
    "battery-outline",
    "battery-plus",
    "battery-positive",
    "battery-unknown",
    "beach",
    "beaker",
    "beats",
    "beer",
    "behance",
    "bell",
    "bell-off",
    "bell-outline",
    "bell-plus",
    "bell-ring",
    "bell-ring-outline",
    "bell-sleep",
    "beta",
    "bible",
    "bike",
    "bing",
    "binoculars",
    "bio",
    "biohazard",
    "bitbucket",
    "black-mesa",
    "blackberry",
    "blender",
    "blinds",
    "block-helper",
    "blogger",
    "bluetooth",
    "bluetooth-audio",
    "bluetooth-connect",
    "bluetooth-off",
    "bluetooth-settings",
    "bluetooth-transfer",
    "blur",
    "blur-linear",
    "blur-off",
    "blur-radial",
    "bomb",
    "bone",
    "book",
    "book-minus",
    "book-multiple",
    "book-multiple-variant",
    "book-open",
    "book-open-page-variant",
    "book-open-variant",
    "book-plus",
    "book-variant",
    "bookmark",
    "bookmark-check",
    "bookmark-music",
    "bookmark-outline",
    "bookmark-plus",
    "bookmark-plus-outline",
    "bookmark-remove",
    "boombox",
    "border-all",
    "border-bottom",
    "border-color",
    "border-horizontal",
    "border-inside",
    "border-left",
    "border-none",
    "border-outside",
    "border-right",
    "border-style",
    "border-top",
    "border-vertical",
    "bow-tie",
    "bowl",
    "bowling",
    "box",
    "box-cutter",
    "box-shadow",
    "bridge",
    "briefcase",
    "briefcase-check",
    "briefcase-download",
    "briefcase-upload",
    "brightness-1",
    "brightness-2",
    "brightness-3",
    "brightness-4",
    "brightness-5",
    "brightness-6",
    "brightness-7",
    "brightness-auto",
    "broom",
    "brush",
    "buffer",
    "bug",
    "bulletin-board",
    "bullhorn",
    "bullseye",
    "burst-mode",
    "bus",
    "cached",
    "cake",
    "cake-layered",
    "cake-variant",
    "calculator",
    "calendar",
    "calendar-blank",
    "calendar-check",
    "calendar-clock",
    "calendar-multiple",
    "calendar-multiple-check",
    "calendar-plus",
    "calendar-question",
    "calendar-range",
    "calendar-remove",
    "calendar-text",
    "calendar-today",
    "call-made",
    "call-merge",
    "call-missed",
    "call-received",
    "call-split",
    "camcorder",
    "camcorder-box",
    "camcorder-box-off",
    "camcorder-off",
    "camera",
    "camera-burst",
    "camera-enhance",
    "camera-front",
    "camera-front-variant",
    "camera-iris",
    "camera-off",
    "camera-party-mode",
    "camera-rear",
    "camera-rear-variant",
    "camera-switch",
    "camera-timer",
    "candle",
    "candycane",
    "car",
    "car-battery",
    "car-connected",
    "car-wash",
    "cards",
    "cards-outline",
    "cards-playing-outline",
    "carrot",
    "cart",
    "cart-off",
    "cart-outline",
    "cart-plus",
    "case-sensitive-alt",
    "cash",
    "cash-100",
    "cash-multiple",
    "cash-usd",
    "cast",
    "cast-connected",
    "castle",
    "cat",
    "cellphone",
    "cellphone-android",
    "cellphone-basic",
    "cellphone-dock",
    "cellphone-iphone",
    "cellphone-link",
    "cellphone-link-off",
    "cellphone-settings",
    "certificate",
    "chair-school",
    "chart-arc",
    "chart-areaspline",
    "chart-bar",
    "chart-bubble",
    "chart-gantt",
    "chart-histogram",
    "chart-line",
    "chart-pie",
    "chart-scatterplot-hexbin",
    "chart-timeline",
    "check",
    "check-all",
    "check-circle",
    "check-circle-outline",
    "checkbox-blank",
    "checkbox-blank-circle",
    "checkbox-blank-circle-outline",
    "checkbox-blank-outline",
    "checkbox-marked",
    "checkbox-marked-circle",
    "checkbox-marked-circle-outline",
    "checkbox-marked-outline",
    "checkbox-multiple-blank",
    "checkbox-multiple-blank-circle",
    "checkbox-multiple-blank-circle-outline",
    "checkbox-multiple-blank-outline",
    "checkbox-multiple-marked",
    "checkbox-multiple-marked-circle",
    "checkbox-multiple-marked-circle-outline",
    "checkbox-multiple-marked-outline",
    "checkerboard",
    "chemical-weapon",
    "chevron-double-down",
    "chevron-double-left",
    "chevron-double-right",
    "chevron-double-up",
    "chevron-down",
    "chevron-left",
    "chevron-right",
    "chevron-up",
    "chip",
    "church",
    "cisco-webex",
    "city",
    "clipboard",
    "clipboard-account",
    "clipboard-alert",
    "clipboard-arrow-down",
    "clipboard-arrow-left",
    "clipboard-check",
    "clipboard-outline",
    "clipboard-text",
    "clippy",
    "clock",
    "clock-alert",
    "clock-end",
    "clock-fast",
    "clock-in",
    "clock-out",
    "clock-start",
    "close",
    "close-box",
    "close-box-outline",
    "close-circle",
    "close-circle-outline",
    "close-network",
    "close-octagon",
    "close-octagon-outline",
    "closed-caption",
    "cloud",
    "cloud-check",
    "cloud-circle",
    "cloud-download",
    "cloud-outline",
    "cloud-outline-off",
    "cloud-print",
    "cloud-print-outline",
    "cloud-sync",
    "cloud-upload",
    "code-array",
    "code-braces",
    "code-brackets",
    "code-equal",
    "code-greater-than",
    "code-greater-than-or-equal",
    "code-less-than",
    "code-less-than-or-equal",
    "code-not-equal",
    "code-not-equal-variant",
    "code-parentheses",
    "code-string",
    "code-tags",
    "code-tags-check",
    "codepen",
    "coffee",
    "coffee-to-go",
    "coin",
    "coins",
    "collage",
    "color-helper",
    "comment",
    "comment-account",
    "comment-account-outline",
    "comment-alert",
    "comment-alert-outline",
    "comment-check",
    "comment-check-outline",
    "comment-multiple-outline",
    "comment-outline",
    "comment-plus-outline",
    "comment-processing",
    "comment-processing-outline",
    "comment-question-outline",
    "comment-remove-outline",
    "comment-text",
    "comment-text-outline",
    "compare",
    "compass",
    "compass-outline",
    "console",
    "contact-mail",
    "content-copy",
    "content-cut",
    "content-duplicate",
    "content-paste",
    "content-save",
    "content-save-all",
    "content-save-settings",
    "contrast",
    "contrast-box",
    "contrast-circle",
    "cookie",
    "copyright",
    "counter",
    "cow",
    "creation",
    "credit-card",
    "credit-card-multiple",
    "credit-card-off",
    "credit-card-plus",
    "credit-card-scan",
    "crop",
    "crop-free",
    "crop-landscape",
    "crop-portrait",
    "crop-rotate",
    "crop-square",
    "crosshairs",
    "crosshairs-gps",
    "crown",
    "cube",
    "cube-outline",
    "cube-send",
    "cube-unfolded",
    "cup",
    "cup-off",
    "cup-water",
    "currency-btc",
    "currency-eur",
    "currency-gbp",
    "currency-inr",
    "currency-ngn",
    "currency-rub",
    "currency-try",
    "currency-usd",
    "currency-usd-off",
    "cursor-default",
    "cursor-default-outline",
    "cursor-move",
    "cursor-pointer",
    "cursor-text",
    "database",
    "database-minus",
    "database-plus",
    "debug-step-into",
    "debug-step-out",
    "debug-step-over",
    "decimal-decrease",
    "decimal-increase",
    "delete",
    "delete-circle",
    "delete-forever",
    "delete-sweep",
    "delete-variant",
    "delta",
    "deskphone",
    "desktop-mac",
    "desktop-tower",
    "details",
    "developer-board",
    "deviantart",
    "dialpad",
    "diamond",
    "dice-1",
    "dice-2",
    "dice-3",
    "dice-4",
    "dice-5",
    "dice-6",
    "dice-d20",
    "dice-d4",
    "dice-d6",
    "dice-d8",
    "dictionary",
    "directions",
    "directions-fork",
    "discord",
    "disk",
    "disk-alert",
    "disqus",
    "disqus-outline",
    "division",
    "division-box",
    "dna",
    "dns",
    "do-not-disturb",
    "do-not-disturb-off",
    "dolby",
    "domain",
    "dots-horizontal",
    "dots-vertical",
    "douban",
    "download",
    "drag",
    "drag-horizontal",
    "drag-vertical",
    "drawing",
    "drawing-box",
    "dribbble",
    "dribbble-box",
    "drone",
    "dropbox",
    "drupal",
    "duck",
    "dumbbell",
    "earth",
    "earth-off",
    "edge",
    "eject",
    "elevation-decline",
    "elevation-rise",
    "elevator",
    "email",
    "email-open",
    "email-open-outline",
    "email-outline",
    "email-secure",
    "email-variant",
    "emby",
    "emoticon",
    "emoticon-cool",
    "emoticon-dead",
    "emoticon-devil",
    "emoticon-excited",
    "emoticon-happy",
    "emoticon-neutral",
    "emoticon-poop",
    "emoticon-sad",
    "emoticon-tongue",
    "engine",
    "engine-outline",
    "equal",
    "equal-box",
    "eraser",
    "eraser-variant",
    "escalator",
    "ethernet",
    "ethernet-cable",
    "ethernet-cable-off",
    "etsy",
    "ev-station",
    "evernote",
    "exclamation",
    "exit-to-app",
    "export",
    "eye",
    "eye-off",
    "eyedropper",
    "eyedropper-variant",
    "face",
    "face-profile",
    "facebook",
    "facebook-box",
    "facebook-messenger",
    "factory",
    "fan",
    "fast-forward",
    "fax",
    "ferry",
    "file",
    "file-chart",
    "file-check",
    "file-cloud",
    "file-delimited",
    "file-document",
    "file-document-box",
    "file-excel",
    "file-excel-box",
    "file-export",
    "file-find",
    "file-hidden",
    "file-image",
    "file-import",
    "file-lock",
    "file-multiple",
    "file-music",
    "file-outline",
    "file-pdf",
    "file-pdf-box",
    "file-powerpoint",
    "file-powerpoint-box",
    "file-presentation-box",
    "file-restore",
    "file-send",
    "file-tree",
    "file-video",
    "file-word",
    "file-word-box",
    "file-xml",
    "film",
    "filmstrip",
    "filmstrip-off",
    "filter",
    "filter-outline",
    "filter-remove",
    "filter-remove-outline",
    "filter-variant",
    "fingerprint",
    "fire",
    "firefox",
    "fish",
    "flag",
    "flag-checkered",
    "flag-outline",
    "flag-outline-variant",
    "flag-triangle",
    "flag-variant",
    "flash",
    "flash-auto",
    "flash-off",
    "flash-red-eye",
    "flashlight",
    "flashlight-off",
    "flask",
    "flask-empty",
    "flask-empty-outline",
    "flask-outline",
    "flattr",
    "flip-to-back",
    "flip-to-front",
    "floppy",
    "flower",
    "folder",
    "folder-account",
    "folder-download",
    "folder-google-drive",
    "folder-image",
    "folder-lock",
    "folder-lock-open",
    "folder-move",
    "folder-multiple",
    "folder-multiple-image",
    "folder-multiple-outline",
    "folder-outline",
    "folder-plus",
    "folder-remove",
    "folder-star",
    "folder-upload",
    "food",
    "food-apple",
    "food-fork-drink",
    "food-off",
    "food-variant",
    "football",
    "football-australian",
    "football-helmet",
    "format-align-center",
    "format-align-justify",
    "format-align-left",
    "format-align-right",
    "format-annotation-plus",
    "format-bold",
    "format-clear",
    "format-color-fill",
    "format-color-text",
    "format-float-center",
    "format-float-left",
    "format-float-none",
    "format-float-right",
    "format-header-1",
    "format-header-2",
    "format-header-3",
    "format-header-4",
    "format-header-5",
    "format-header-6",
    "format-header-decrease",
    "format-header-equal",
    "format-header-increase",
    "format-header-pound",
    "format-horizontal-align-center",
    "format-horizontal-align-left",
    "format-horizontal-align-right",
    "format-indent-decrease",
    "format-indent-increase",
    "format-italic",
    "format-line-spacing",
    "format-line-style",
    "format-line-weight",
    "format-list-bulleted",
    "format-list-bulleted-type",
    "format-list-numbers",
    "format-paint",
    "format-paragraph",
    "format-quote",
    "format-section",
    "format-size",
    "format-strikethrough",
    "format-strikethrough-variant",
    "format-subscript",
    "format-superscript",
    "format-text",
    "format-textdirection-l-to-r",
    "format-textdirection-r-to-l",
    "format-title",
    "format-underline",
    "format-vertical-align-bottom",
    "format-vertical-align-center",
    "format-vertical-align-top",
    "format-wrap-inline",
    "format-wrap-square",
    "format-wrap-tight",
    "format-wrap-top-bottom",
    "forum",
    "forward",
    "foursquare",
    "fridge",
    "fridge-filled",
    "fridge-filled-bottom",
    "fridge-filled-top",
    "fullscreen",
    "fullscreen-exit",
    "function",
    "gamepad",
    "gamepad-variant",
    "gas-cylinder",
    "gas-station",
    "gate",
    "gauge",
    "gavel",
    "gender-female",
    "gender-male",
    "gender-male-female",
    "gender-transgender",
    "ghost",
    "gift",
    "git",
    "github-box",
    "github-circle",
    "glass-flute",
    "glass-mug",
    "glass-stange",
    "glass-tulip",
    "glassdoor",
    "glasses",
    "gmail",
    "gnome",
    "gondola",
    "google",
    "google-cardboard",
    "google-chrome",
    "google-circles",
    "google-circles-communities",
    "google-circles-extended",
    "google-circles-group",
    "google-controller",
    "google-controller-off",
    "google-drive",
    "google-earth",
    "google-glass",
    "google-maps",
    "google-nearby",
    "google-pages",
    "google-physical-web",
    "google-play",
    "google-plus",
    "google-plus-box",
    "google-translate",
    "google-wallet",
    "gradient",
    "grease-pencil",
    "grid",
    "grid-off",
    "group",
    "guitar-electric",
    "guitar-pick",
    "guitar-pick-outline",
    "hackernews",
    "hamburger",
    "hand-pointing-right",
    "hanger",
    "hangouts",
    "harddisk",
    "headphones",
    "headphones-box",
    "headphones-settings",
    "headset",
    "headset-dock",
    "headset-off",
    "heart",
    "heart-box",
    "heart-box-outline",
    "heart-broken",
    "heart-outline",
    "heart-pulse",
    "help",
    "help-circle",
    "help-circle-outline",
    "hexagon",
    "hexagon-outline",
    "highway",
    "history",
    "hololens",
    "home",
    "home-map-marker",
    "home-modern",
    "home-outline",
    "home-variant",
    "hops",
    "hospital",
    "hospital-building",
    "hospital-marker",
    "hotel",
    "houzz",
    "houzz-box",
    "human",
    "human-child",
    "human-female",
    "human-greeting",
    "human-handsdown",
    "human-handsup",
    "human-male",
    "human-male-female",
    "human-pregnant",
    "image",
    "image-album",
    "image-area",
    "image-area-close",
    "image-broken",
    "image-broken-variant",
    "image-filter",
    "image-filter-black-white",
    "image-filter-center-focus",
    "image-filter-center-focus-weak",
    "image-filter-drama",
    "image-filter-frames",
    "image-filter-hdr",
    "image-filter-none",
    "image-filter-tilt-shift",
    "image-filter-vintage",
    "image-multiple",
    "import",
    "inbox",
    "inbox-arrow-down",
    "inbox-arrow-up",
    "incognito",
    "information",
    "information-outline",
    "information-variant",
    "instagram",
    "instapaper",
    "internet-explorer",
    "invert-colors",
    "itunes",
    "jeepney",
    "jira",
    "jsfiddle",
    "json",
    "keg",
    "kettle",
    "key",
    "key-change",
    "key-minus",
    "key-plus",
    "key-remove",
    "key-variant",
    "keyboard",
    "keyboard-backspace",
    "keyboard-caps",
    "keyboard-close",
    "keyboard-off",
    "keyboard-return",
    "keyboard-tab",
    "keyboard-variant",
    "kodi",
    "label",
    "label-outline",
    "lambda",
    "lamp",
    "lan",
    "lan-connect",
    "lan-disconnect",
    "lan-pending",
    "language-c",
    "language-cpp",
    "language-csharp",
    "language-css3",
    "language-html5",
    "language-javascript",
    "language-php",
    "language-python",
    "language-python-text",
    "laptop",
    "laptop-chromebook",
    "laptop-mac",
    "laptop-windows",
    "lastfm",
    "launch",
    "layers",
    "layers-off",
    "lead-pencil",
    "leaf",
    "led-off",
    "led-on",
    "led-outline",
    "led-variant-off",
    "led-variant-on",
    "led-variant-outline",
    "library",
    "library-books",
    "library-music",
    "library-plus",
    "lightbulb",
    "lightbulb-outline",
    "link",
    "link-off",
    "link-variant",
    "link-variant-off",
    "linkedin",
    "linkedin-box",
    "linux",
    "lock",
    "lock-open",
    "lock-open-outline",
    "lock-outline",
    "lock-plus",
    "login",
    "login-variant",
    "logout",
    "logout-variant",
    "looks",
    "loupe",
    "lumx",
    "magnet",
    "magnet-on",
    "magnify",
    "magnify-minus",
    "magnify-plus",
    "mail-ru",
    "map",
    "map-marker",
    "map-marker-circle",
    "map-marker-minus",
    "map-marker-multiple",
    "map-marker-off",
    "map-marker-plus",
    "map-marker-radius",
    "margin",
    "markdown",
    "marker",
    "marker-check",
    "martini",
    "material-ui",
    "math-compass",
    "matrix",
    "maxcdn",
    "medium",
    "memory",
    "menu",
    "menu-down",
    "menu-down-outline",
    "menu-left",
    "menu-right",
    "menu-up",
    "menu-up-outline",
    "message",
    "message-alert",
    "message-bulleted",
    "message-bulleted-off",
    "message-draw",
    "message-image",
    "message-outline",
    "message-plus",
    "message-processing",
    "message-reply",
    "message-reply-text",
    "message-text",
    "message-text-outline",
    "message-video",
    "meteor",
    "microphone",
    "microphone-off",
    "microphone-outline",
    "microphone-settings",
    "microphone-variant",
    "microphone-variant-off",
    "microscope",
    "microsoft",
    "minecraft",
    "minus",
    "minus-box",
    "minus-circle",
    "minus-circle-outline",
    "minus-network",
    "mixcloud",
    "monitor",
    "monitor-multiple",
    "more",
    "motorbike",
    "mouse",
    "mouse-off",
    "mouse-variant",
    "mouse-variant-off",
    "move-resize",
    "move-resize-variant",
    "movie",
    "multiplication",
    "multiplication-box",
    "music-box",
    "music-box-outline",
    "music-circle",
    "music-note",
    "music-note-bluetooth",
    "music-note-bluetooth-off",
    "music-note-eighth",
    "music-note-half",
    "music-note-off",
    "music-note-quarter",
    "music-note-sixteenth",
    "music-note-whole",
    "nature",
    "nature-people",
    "navigation",
    "near-me",
    "needle",
    "nest-protect",
    "nest-thermostat",
    "new-box",
    "newspaper",
    "nfc",
    "nfc-tap",
    "nfc-variant",
    "nodejs",
    "note",
    "note-multiple",
    "note-multiple-outline",
    "note-outline",
    "note-plus",
    "note-plus-outline",
    "note-text",
    "notification-clear-all",
    "nuke",
    "numeric",
    "numeric-0-box",
    "numeric-0-box-multiple-outline",
    "numeric-0-box-outline",
    "numeric-1-box",
    "numeric-1-box-multiple-outline",
    "numeric-1-box-outline",
    "numeric-2-box",
    "numeric-2-box-multiple-outline",
    "numeric-2-box-outline",
    "numeric-3-box",
    "numeric-3-box-multiple-outline",
    "numeric-3-box-outline",
    "numeric-4-box",
    "numeric-4-box-multiple-outline",
    "numeric-4-box-outline",
    "numeric-5-box",
    "numeric-5-box-multiple-outline",
    "numeric-5-box-outline",
    "numeric-6-box",
    "numeric-6-box-multiple-outline",
    "numeric-6-box-outline",
    "numeric-7-box",
    "numeric-7-box-multiple-outline",
    "numeric-7-box-outline",
    "numeric-8-box",
    "numeric-8-box-multiple-outline",
    "numeric-8-box-outline",
    "numeric-9-box",
    "numeric-9-box-multiple-outline",
    "numeric-9-box-outline",
    "numeric-9-plus-box",
    "numeric-9-plus-box-multiple-outline",
    "numeric-9-plus-box-outline",
    "nutrition",
    "oar",
    "octagon",
    "octagon-outline",
    "odnoklassniki",
    "office",
    "oil",
    "oil-temperature",
    "omega",
    "onedrive",
    "opacity",
    "open-in-app",
    "open-in-new",
    "openid",
    "opera",
    "ornament",
    "ornament-variant",
    "owl",
    "package",
    "package-down",
    "package-up",
    "package-variant",
    "package-variant-closed",
    "page-first",
    "page-last",
    "palette",
    "palette-advanced",
    "panda",
    "pandora",
    "panorama",
    "panorama-fisheye",
    "panorama-horizontal",
    "panorama-vertical",
    "panorama-wide-angle",
    "paper-cut-vertical",
    "paperclip",
    "parking",
    "pause",
    "pause-circle",
    "pause-circle-outline",
    "pause-octagon",
    "pause-octagon-outline",
    "paw",
    "paw-off",
    "pen",
    "pencil",
    "pencil-box",
    "pencil-box-outline",
    "pencil-lock",
    "pencil-off",
    "percent",
    "pharmacy",
    "phone",
    "phone-bluetooth",
    "phone-classic",
    "phone-forward",
    "phone-hangup",
    "phone-in-talk",
    "phone-incoming",
    "phone-locked",
    "phone-log",
    "phone-minus",
    "phone-missed",
    "phone-outgoing",
    "phone-paused",
    "phone-plus",
    "phone-settings",
    "phone-voip",
    "pi",
    "pi-box",
    "piano",
    "pig",
    "pill",
    "pin",
    "pin-off",
    "pine-tree",
    "pine-tree-box",
    "pinterest",
    "pinterest-box",
    "pizza",
    "plane-shield",
    "play",
    "play-box-outline",
    "play-circle",
    "play-circle-outline",
    "play-pause",
    "play-protected-content",
    "playlist-check",
    "playlist-minus",
    "playlist-play",
    "playlist-plus",
    "playlist-remove",
    "playstation",
    "plex",
    "plus",
    "plus-box",
    "plus-circle",
    "plus-circle-multiple-outline",
    "plus-circle-outline",
    "plus-network",
    "plus-one",
    "pocket",
    "pokeball",
    "polaroid",
    "poll",
    "poll-box",
    "polymer",
    "pool",
    "popcorn",
    "pot",
    "pot-mix",
    "pound",
    "pound-box",
    "power",
    "power-plug",
    "power-plug-off",
    "power-settings",
    "power-socket",
    "presentation",
    "presentation-play",
    "printer",
    "printer-3d",
    "printer-alert",
    "priority-high",
    "priority-low",
    "professional-hexagon",
    "projector",
    "projector-screen",
    "publish",
    "pulse",
    "puzzle",
    "qqchat",
    "qrcode",
    "qrcode-scan",
    "quadcopter",
    "quality-high",
    "quicktime",
    "radar",
    "radiator",
    "radio",
    "radio-handheld",
    "radio-tower",
    "radioactive",
    "radiobox-blank",
    "radiobox-marked",
    "raspberrypi",
    "ray-end",
    "ray-end-arrow",
    "ray-start",
    "ray-start-arrow",
    "ray-start-end",
    "ray-vertex",
    "rdio",
    "read",
    "readability",
    "receipt",
    "record",
    "record-rec",
    "recycle",
    "reddit",
    "redo",
    "redo-variant",
    "refresh",
    "regex",
    "relative-scale",
    "reload",
    "remote",
    "rename-box",
    "reorder-horizontal",
    "reorder-vertical",
    "repeat",
    "repeat-off",
    "repeat-once",
    "replay",
    "reply",
    "reply-all",
    "reproduction",
    "resize-bottom-right",
    "responsive",
    "restore",
    "rewind",
    "ribbon",
    "road",
    "road-variant",
    "robot",
    "rocket",
    "rotate-3d",
    "rotate-90",
    "rotate-left",
    "rotate-left-variant",
    "rotate-right",
    "rotate-right-variant",
    "rounded-corner",
    "router-wireless",
    "routes",
    "rowing",
    "rss",
    "rss-box",
    "ruler",
    "run",
    "sale",
    "satellite",
    "satellite-variant",
    "saxophone",
    "scale",
    "scale-balance",
    "scale-bathroom",
    "scanner",
    "school",
    "screen-rotation",
    "screen-rotation-lock",
    "screwdriver",
    "script",
    "sd",
    "seal",
    "seat-flat",
    "seat-flat-angled",
    "seat-individual-suite",
    "seat-legroom-extra",
    "seat-legroom-normal",
    "seat-legroom-reduced",
    "seat-recline-extra",
    "seat-recline-normal",
    "security",
    "security-home",
    "security-network",
    "select",
    "select-all",
    "select-inverse",
    "select-off",
    "selection",
    "send",
    "serial-port",
    "server",
    "server-minus",
    "server-network",
    "server-network-off",
    "server-off",
    "server-plus",
    "server-remove",
    "server-security",
    "settings",
    "settings-box",
    "shape-circle-plus",
    "shape-plus",
    "shape-polygon-plus",
    "shape-rectangle-plus",
    "shape-square-plus",
    "share",
    "share-variant",
    "shield",
    "shield-outline",
    "shopping",
    "shopping-music",
    "shredder",
    "shuffle",
    "shuffle-disabled",
    "shuffle-variant",
    "sigma",
    "sigma-lower",
    "sign-caution",
    "signal",
    "signal-variant",
    "silverware",
    "silverware-fork",
    "silverware-spoon",
    "silverware-variant",
    "sim",
    "sim-alert",
    "sim-off",
    "sitemap",
    "skip-backward",
    "skip-forward",
    "skip-next",
    "skip-next-circle",
    "skip-next-circle-outline",
    "skip-previous",
    "skip-previous-circle",
    "skip-previous-circle-outline",
    "skull",
    "skype",
    "skype-business",
    "slack",
    "sleep",
    "sleep-off",
    "smoking",
    "smoking-off",
    "snapchat",
    "snowman",
    "soccer",
    "sofa",
    "solid",
    "sort",
    "sort-alphabetical",
    "sort-ascending",
    "sort-descending",
    "sort-numeric",
    "sort-variant",
    "soundcloud",
    "source-branch",
    "source-fork",
    "source-merge",
    "source-pull",
    "speaker",
    "speaker-off",
    "speedometer",
    "spellcheck",
    "spotify",
    "spotlight",
    "spotlight-beam",
    "spray",
    "square-inc",
    "square-inc-cash",
    "stackexchange",
    "stackoverflow",
    "stairs",
    "star",
    "star-circle",
    "star-half",
    "star-off",
    "star-outline",
    "steam",
    "steering",
    "step-backward",
    "step-backward-2",
    "step-forward",
    "step-forward-2",
    "stethoscope",
    "sticker",
    "stocking",
    "stop",
    "stop-circle",
    "stop-circle-outline",
    "store",
    "store-24-hour",
    "stove",
    "subdirectory-arrow-left",
    "subdirectory-arrow-right",
    "subway",
    "subway-variant",
    "sunglasses",
    "surround-sound",
    "swap-horizontal",
    "swap-vertical",
    "swim",
    "switch",
    "sword",
    "sync",
    "sync-alert",
    "sync-off",
    "tab",
    "tab-unselected",
    "table",
    "table-column-plus-after",
    "table-column-plus-before",
    "table-column-remove",
    "table-column-width",
    "table-edit",
    "table-large",
    "table-row-height",
    "table-row-plus-after",
    "table-row-plus-before",
    "table-row-remove",
    "tablet",
    "tablet-android",
    "tablet-ipad",
    "tag",
    "tag-faces",
    "tag-heart",
    "tag-multiple",
    "tag-outline",
    "tag-text-outline",
    "target",
    "taxi",
    "teamviewer",
    "telegram",
    "television",
    "television-guide",
    "temperature-celsius",
    "temperature-fahrenheit",
    "temperature-kelvin",
    "tennis",
    "tent",
    "terrain",
    "test-tube",
    "text-shadow",
    "text-to-speech",
    "text-to-speech-off",
    "textbox",
    "texture",
    "theater",
    "theme-light-dark",
    "thermometer",
    "thermometer-lines",
    "thumb-down",
    "thumb-down-outline",
    "thumb-up",
    "thumb-up-outline",
    "thumbs-up-down",
    "ticket",
    "ticket-account",
    "ticket-confirmation",
    "tie",
    "timelapse",
    "timer",
    "timer-10",
    "timer-3",
    "timer-off",
    "timer-sand",
    "timer-sand-empty",
    "timetable",
    "toggle-switch",
    "toggle-switch-off",
    "tooltip",
    "tooltip-edit",
    "tooltip-image",
    "tooltip-outline",
    "tooltip-outline-plus",
    "tooltip-text",
    "tooth",
    "tor",
    "tower-beach",
    "tower-fire",
    "traffic-light",
    "train",
    "tram",
    "transcribe",
    "transcribe-close",
    "transfer",
    "transit-transfer",
    "translate",
    "tree",
    "trello",
    "trending-down",
    "trending-neutral",
    "trending-up",
    "triangle",
    "triangle-outline",
    "trophy",
    "trophy-award",
    "trophy-outline",
    "trophy-variant",
    "trophy-variant-outline",
    "truck",
    "truck-delivery",
    "tshirt-crew",
    "tshirt-v",
    "tumblr",
    "tumblr-reblog",
    "tune",
    "tune-vertical",
    "twitch",
    "twitter",
    "twitter-box",
    "twitter-circle",
    "twitter-retweet",
    "ubuntu",
    "umbraco",
    "umbrella",
    "umbrella-outline",
    "undo",
    "undo-variant",
    "unfold-less",
    "unfold-more",
    "ungroup",
    "unity",
    "untappd",
    "update",
    "upload",
    "usb",
    "vector-arrange-above",
    "vector-arrange-below",
    "vector-circle",
    "vector-circle-variant",
    "vector-combine",
    "vector-curve",
    "vector-difference",
    "vector-difference-ab",
    "vector-difference-ba",
    "vector-intersection",
    "vector-line",
    "vector-point",
    "vector-polygon",
    "vector-polyline",
    "vector-rectangle",
    "vector-selection",
    "vector-square",
    "vector-triangle",
    "vector-union",
    "verified",
    "vibrate",
    "video",
    "video-off",
    "video-switch",
    "view-agenda",
    "view-array",
    "view-carousel",
    "view-column",
    "view-dashboard",
    "view-day",
    "view-grid",
    "view-headline",
    "view-list",
    "view-module",
    "view-quilt",
    "view-stream",
    "view-week",
    "vimeo",
    "vine",
    "violin",
    "visualstudio",
    "vk",
    "vk-box",
    "vk-circle",
    "vlc",
    "voice",
    "voicemail",
    "volume-high",
    "volume-low",
    "volume-medium",
    "volume-off",
    "vpn",
    "walk",
    "wallet",
    "wallet-giftcard",
    "wallet-membership",
    "wallet-travel",
    "wan",
    "watch",
    "watch-export",
    "watch-import",
    "watch-vibrate",
    "water",
    "water-off",
    "water-percent",
    "water-pump",
    "watermark",
    "weather-cloudy",
    "weather-fog",
    "weather-hail",
    "weather-lightning",
    "weather-lightning-rainy",
    "weather-night",
    "weather-partlycloudy",
    "weather-pouring",
    "weather-rainy",
    "weather-snowy",
    "weather-snowy-rainy",
    "weather-sunny",
    "weather-sunset",
    "weather-sunset-down",
    "weather-sunset-up",
    "weather-windy",
    "weather-windy-variant",
    "web",
    "webcam",
    "webhook",
    "wechat",
    "weight",
    "weight-kilogram",
    "whatsapp",
    "wheelchair-accessibility",
    "white-balance-auto",
    "white-balance-incandescent",
    "white-balance-iridescent",
    "white-balance-sunny",
    "wifi",
    "wifi-off",
    "wii",
    "wikipedia",
    "window-close",
    "window-closed",
    "window-maximize",
    "window-minimize",
    "window-open",
    "window-restore",
    "windows",
    "wordpress",
    "worker",
    "wrap",
    "wrench",
    "wunderlist",
    "xaml",
    "xbox",
    "xbox-controller",
    "xbox-controller-off",
    "xda",
    "xing",
    "xing-box",
    "xing-circle",
    "xml",
    "yeast",
    "yelp",
    "yin-yang",
    "youtube-play",
    "zip-box"]
  end
end