//
//  LLMusicPlayerManager.h
//  LLMusicDemo
//
//  Created by linhui on 2018/2/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface LLMusicPlayerManager : NSObject

@property(nonatomic,strong)AVPlayer *musicPlayer;
@property(nonatomic,strong)AVPlayerItem *songItem;
//单利
+(LLMusicPlayerManager*)sharedInstance;
//初始化播放源
-(void)setPlaySongItem:(NSString*)songURL;
//设置播放源
-(void)setPlaySong;
//开始播放
-(void)startPlay;
//暂停
-(void)stopPlay;

@end
