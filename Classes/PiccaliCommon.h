//
//  PiccaliCommon.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define CONFIG_TWITTER_ENABLE @"config_twitter_enable"
#define CONFIG_WASSR_ENABLE @"config_wassr_enable"
#define CONFIG_TWITTER_USERNAME @"config_twitter_username"
#define CONFIG_WASSR_USERNAME @"config_wassr_username"
#define CONFIG_TWITTER_PASSWORD @"config_twitter_password"
#define CONFIG_WASSR_PASSWORD @"config_wassr_password"
#define CONFIG_IMAGE_SIZE @"config_image_size"
#define TWITTER_ENABLE @"twitter_enable"
#define WASSR_ENABLE @"wassr_enable"
#define DEFAULT_IMAGE_SIZE 1024
#define REGEXP_IMAGE_SIZE @"^[0-9]{1,4}$"
#define MAX_LENGTH_TWITTER 140
#define MAX_LENGTH_WASSR 255
#define MAX_LENGTH_OTHER 0
#define TWITTER_API_KEY @"4fce0ca104faed9553f10acc3b9133f8"
#define TWITTER_API_URL @"http://twitter.com/api/upload"
#define TWITTER_API_METHOD @"POST"
#define WASSR_API_URL @"http://api.wassr.jp/statuses/update.json"
#define WASSR_CHANNEL_API_URL @"http://api.wassr.jp/channel_message/update.json?name_en=%@"
#define WASSR_CHANNEL_LIST_API_URL @"http://api.wassr.jp/channel_user/user_list.json?login_id=%@"
#define WASSR_API_METHOD @"POST"
#define WASSR_API_SOURCE @"Piccali"