//
//  PiccaliCommon.h
//  Piccali
//
//  Created by 筒井 隆次 on 11/03/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define USERDEFAULTS_TWITPIC_ENABLE @"twitpic_enable"
#define USERDEFAULTS_WASSR_ENABLE @"wassr_enable"
#define USERDEFAULTS_TWITPIC_USERNAME @"twitpic_username"
#define USERDEFAULTS_WASSR_USERNAME @"wassr_username"
#define USERDEFAULTS_TWITPIC_PASSWORD @"twitpic_password"
#define USERDEFAULTS_WASSR_PASSWORD @"wassr_password"
#define USERDEFAULTS_IMAGE_SIZE @"image_size"
#define DEFAULT_IMAGE_SIZE 1024
#define REGEXP_IMAGE_SIZE @"^[0-9]{1,4}$"
#define MAX_LENGTH_TWITPIC 140
#define MAX_LENGTH_WASSR 255
#define MAX_LENGTH_OTHER 0
#define TWITPIC_API_KEY @"4fce0ca104faed9553f10acc3b9133f8"
#define TWITPIC_API_URL @"http://twitpic.com/api/upload"
#define TWITPIC_API_METHOD @"POST"
#define WASSR_API_URL @"http://api.wassr.jp/statuses/update.json"
#define WASSR_CHANNEL_API_URL @"http://api.wassr.jp/channel_message/update.json?name_en=%@"
#define WASSR_CHANNEL_LIST_API_URL @"http://api.wassr.jp/channel_user/user_list.json?login_id=%@"
#define WASSR_API_METHOD @"POST"
#define WASSR_API_SOURCE @"Piccali"