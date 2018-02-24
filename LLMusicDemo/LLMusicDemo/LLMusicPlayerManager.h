//
//  LLMusicPlayerManager.h
//  LLMusicDemo
//
//  Created by linhui on 2018/2/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define MusicTimeInterval @"musicTimeIntervalName"

@interface LLMusicPlayerManager : NSObject
{
    id _timeObserve;
}


@property(nonatomic,strong)AVPlayer *musicPlayer;
@property(nonatomic,strong)AVPlayerItem *songItem;
//单利
+(LLMusicPlayerManager*)sharedInstance;
//设置音频允许在后台播放
-(void)setMusicPlayBackgroundAction;
//设置音乐在锁屏和状态栏下都能显示
-(void)setShowMusicInfo;

//初始化播放源
-(void)setPlaySongItem:(NSString*)songURL;
//设置播放源
-(void)setPlaySong;
//开始播放
-(void)startPlay;
//暂停
-(void)stopPlay;

//播放时间进度监听
-(void)timeObserver;
/**
 设置锁屏状态下的显示
 */
-(void)updateLockedScreenMusic:(NSString*)songTitle andSinger:(NSString*)singer andAlbumName:(NSString*)albumName andImgName:(NSString*)imgName;

@end
