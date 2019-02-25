
// for oauth2.0
const String APP_KEY = '1561262668';
const String APP_SECRET = 'ff7da65c3ba73caafa1607358edf9792';
const String REDIRECT_URI = 'https://api.weibo.com/oauth2/default.html';

String kAccessToken = '';

// for net
const String host = 'https://api.weibo.com';
enum URLType{
  home,
}
const Map<URLType,String> urls = {
    URLType.home : host + '/2/statuses/home_timeline.json',
};

// for app
const String kWBAssetsPackage = 'assets/image';







