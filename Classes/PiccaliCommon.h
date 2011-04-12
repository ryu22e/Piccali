//
//  PiccaliCommon.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// PiccaliAPIKey.hというAPI Keyを定義したファイルもあるけど、githubに公開するとセキュリティ上の問題がありそうなので、これは非公開。
#define SERVICENAME_TWITTER @"PiccaliTwitter"
#define SERVICENAME_WASSR @"PiccaliWassr"
#define SERVICENAME_TWITTER_TOKEN @"PiccaliTwitterToken"

#define CONFIG_TWITTER_ENABLE @"config_twitter_enable"
#define CONFIG_WASSR_ENABLE @"config_wassr_enable"
#define CONFIG_TWITTER_USERNAME @"config_twitter_username"
#define CONFIG_WASSR_USERNAME @"config_wassr_username"
#define CONFIG_TWITTER_PASSWORD @"config_twitter_password"
#define CONFIG_WASSR_PASSWORD @"config_wassr_password"
#define CONFIG_IMAGE_SIZE @"config_image_size"
#define CONFIG_SAVE_IMAGE @"config_save_image"
#define CONFIG_CACHED_XAUTH_ACCESS_TOKEN_KEY @"cached_xauth_access_token_key"

#define TWITTER_ENABLE @"twitter_enable"
#define WASSR_ENABLE @"wassr_enable"

#define DEFAULT_IMAGE_SIZE 1024
#define REGEXP_IMAGE_SIZE @"^[0-9]{1,4}$"

#define MAX_LENGTH_TWITTER 140
#define MAX_LENGTH_WASSR 255
#define MAX_LENGTH_OTHER 0