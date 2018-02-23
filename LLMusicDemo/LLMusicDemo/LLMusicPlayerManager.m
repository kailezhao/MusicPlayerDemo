//
//  LLMusicPlayerManager.m
//  LLMusicDemo
//
//  Created by linhui on 2018/2/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "LLMusicPlayerManager.h"
static LLMusicPlayerManager *_manager = nil;
@implementation LLMusicPlayerManager
+(LLMusicPlayerManager*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc]init];
        
        // 后台播放音频设置,需要在Capabilities->Background Modes中勾选Audio,Airplay,and Picture in Picture
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
    });
    return _manager;
}

//初始化播放源
-(void)setPlaySongItem:(NSString*)songURL{
    NSURL *url = [[NSURL alloc]initWithString:songURL];
    NSLog(@"音频文件路径-->%@",url);
    if (self.songItem != nil) {
        //移除上一首的状态监听
        //移除观察者
        [self.songItem removeObserver:self forKeyPath:@"status"];
        [self.songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        
    }
    
    self.songItem = [[AVPlayerItem alloc]initWithURL:url];
    
    //KVO监听音频文件的状态和缓冲进度
    [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
//设置播放源
-(void)setPlaySong{
    if (self.songItem != nil) {
       [self.musicPlayer replaceCurrentItemWithPlayerItem:self.songItem];
    }
}

//开始播放
-(void)startPlay{
    [self.musicPlayer play];
}
//暂停
-(void)stopPlay{
    [self.musicPlayer pause];
}

//观察者回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //注意这里查看的是self.player.status属性
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.musicPlayer.status) {
            case AVPlayerStatusUnknown:
            {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;
            default:
                break;
        }
    }
    //监听文件的缓冲进度
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray * timeRanges = self.musicPlayer.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.musicPlayer.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        NSLog(@"%lf",scale);
        
    }
    
    
}


#pragma; mark - getter
-(AVPlayer *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer = [[AVPlayer alloc]init];
    }
    return _musicPlayer;
}
@end
