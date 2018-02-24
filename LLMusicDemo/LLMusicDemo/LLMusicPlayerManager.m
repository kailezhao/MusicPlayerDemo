//
//  LLMusicPlayerManager.m
//  LLMusicDemo
//
//  Created by linhui on 2018/2/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "LLMusicPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>
static LLMusicPlayerManager *_manager = nil;
@implementation LLMusicPlayerManager
+(LLMusicPlayerManager*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc]init];

    });
    return _manager;
}
//设置音频允许在后台播放
-(void)setMusicPlayBackgroundAction{
    // 后台播放音频设置,需要在Capabilities->Background Modes中勾选Audio,Airplay,and Picture in Picture
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
//设置音乐在锁屏和状态栏下都能显示
-(void)setShowMusicInfo{
    // 设置接受远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

//初始化播放源
-(void)setPlaySongItem:(NSString*)songURL{
    NSURL *url = [[NSURL alloc]initWithString:songURL];
    NSLog(@"音频文件路径-->%@",url);
    
    if (self.songItem != nil) {
        //移除上一首的状态监听和缓冲进度监听
        [self.songItem removeObserver:self forKeyPath:@"status"];
        [self.songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        
    }
    
    self.songItem = [[AVPlayerItem alloc]initWithURL:url];
    
    //KVO监听音频文件的状态和缓冲进度
    [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //音乐播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.songItem];
}
#pragma mark - 设置播放源
-(void)setPlaySong{
    if (self.songItem != nil) {
       [self.musicPlayer replaceCurrentItemWithPlayerItem:self.songItem];
    }
}

#pragma mark -开始播放
-(void)startPlay{
    [self.musicPlayer play];
}
#pragma mark -暂停
-(void)stopPlay{
    [self.musicPlayer pause];
}

#pragma mark - KVO 监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //注意这里查看的是self.musicPlayer.status属性
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
#pragma mark - 音乐播放结束
-(void)musicPlayFinished:(NSNotification*)info{
    NSLog(@"音乐播放结束");
}
#pragma mark - 播放时间进度的监听
-(void)timeObserver{
    if (_timeObserve) {
        [self.musicPlayer removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    
_timeObserve = [self.musicPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//    CGFloat currentTime = CMTimeGetSeconds(time);
//    NSLog(@"当前播放时间->%f",currentTime);
    
    //播放进度通知
    [[NSNotificationCenter defaultCenter] postNotificationName:MusicTimeInterval object:nil userInfo:nil];
}];

}
#pragma mark - 锁屏状态下的设置
-(void)updateLockedScreenMusic:(NSString*)songTitle andSinger:(NSString*)singer andAlbumName:(NSString*)albumName andImgName:(NSString*)imgName{
    //初始化音频的信息一用作锁屏下的显示
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc]init];
    //设置音频标题
    [songInfo setObject:songTitle.length>0?songTitle:@"" forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songInfo setObject:singer.length>0?singer:@"" forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songInfo setObject:albumName.length>0?albumName:@"" forKey:MPMediaItemPropertyAlbumTitle];
    //设置图片
    if (imgName.length != 0) {
      [songInfo setObject:[[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:imgName]] forKey:MPMediaItemPropertyArtwork];
    }
    
    //设置歌曲的总时间
    [songInfo setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.musicPlayer.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲的当前播放的时间
    [songInfo setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.musicPlayer.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    //这是关键的代码
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}



#pragma; mark - getter
-(AVPlayer *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer = [[AVPlayer alloc]init];
    }
    return _musicPlayer;
}
@end
