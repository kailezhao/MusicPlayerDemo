//
//  ViewController.m
//  LLMusicDemo
//
//  Created by linhui on 2018/2/23.
//  Copyright © 2018年 frank. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "LLMusicPlayerManager.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *musicArr;//音乐URl数组
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;

//@property(nonatomic,strong)AVPlayer *musicPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    [[LLMusicPlayerManager sharedInstance] setMusicPlayBackgroundAction];
    [[LLMusicPlayerManager sharedInstance] setShowMusicInfo];
    
    //当前播放的时间监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicTimeAction:)
                                                 name:MusicTimeInterval
                                               object:nil];
}
#pragma mark - 当前播放时间进度
-(void)musicTimeAction:(NSNotification*)info{
    //当前播放进度
    CGFloat current = CMTimeGetSeconds([[LLMusicPlayerManager sharedInstance].musicPlayer.currentItem currentTime]);
    //总时长
    CGFloat total = CMTimeGetSeconds([[LLMusicPlayerManager sharedInstance].musicPlayer.currentItem duration]);
    NSLog(@"%lf--%lf",current,total);
    
    [self.musicSlider setValue:current/total animated:YES];
    
    [[LLMusicPlayerManager sharedInstance] updateLockedScreenMusic:@"阿斯顿发文"
                                                         andSinger:@"演唱歌手"
                                                      andAlbumName:@"专辑名"
                                                        andImgName:@""];
    
}

- (IBAction)playOrPauseAction:(UIButton *)sender {
   sender.selected = !sender.selected;
    if (sender.selected) {
        NSLog(@"暂停");
        [[LLMusicPlayerManager sharedInstance] stopPlay];
    }else{
        NSLog(@"播放");
        [[LLMusicPlayerManager sharedInstance] startPlay];
    }
}


- (IBAction)NextAction {
    NSLog(@"下一首");
}
- (IBAction)UpAction {
    NSLog(@"上一首");
}
//滑动条拖动结束
- (IBAction)sliderChangeFinishAction:(UISlider *)sender {
    
    CGFloat total = CMTimeGetSeconds([[LLMusicPlayerManager sharedInstance].musicPlayer.currentItem duration]);
    Float64 currentTime = (Float64)(self.musicSlider.value)*total;
    
    if (currentTime <= total) {
        CMTime cmttime = CMTimeMake((int16_t)(currentTime), 1);
        [[LLMusicPlayerManager sharedInstance].musicPlayer seekToTime:cmttime];
    }
    
}
//滑动条拖动中
- (IBAction)musicSliderAction {
//    CGFloat total = CMTimeGetSeconds([[LLMusicPlayerManager sharedInstance].musicPlayer.currentItem duration]);
    
    
    
}


#pragma mark - 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellid"];
    }
    cell.backgroundColor = [UIColor redColor];
    cell.textLabel.text = self.musicArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlStr = self.musicArr[indexPath.row];
    
//   NSURL *musicURL = [NSURL URLWithString:urlStr];
//   AVPlayerItem *musicItem = [[AVPlayerItem alloc]initWithURL:musicURL];
//    [self.musicPlayer replaceCurrentItemWithPlayerItem:musicItem];
//    [self.musicPlayer play];
    
    [[LLMusicPlayerManager sharedInstance] setPlaySongItem:urlStr];
    [[LLMusicPlayerManager sharedInstance] setPlaySong];
    [[LLMusicPlayerManager sharedInstance] startPlay];
    
    [[LLMusicPlayerManager sharedInstance] timeObserver];//监听播放时间

}
//远程控制事件监听
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
        {
            if ([LLMusicPlayerManager sharedInstance].musicPlayer.currentItem != nil) {
            
                if ([LLMusicPlayerManager sharedInstance].musicPlayer.rate) {
                    [[LLMusicPlayerManager sharedInstance] stopPlay];
                }else{
                    [[LLMusicPlayerManager sharedInstance] startPlay];
                }
                
            }
            
            break;
        }
            case UIEventSubtypeRemoteControlNextTrack://下一首
        {
            NSLog(@"下一首");
            break;
        }
        case UIEventSubtypeRemoteControlPreviousTrack://上一首
        {
            NSLog(@"上一首");
            break;
        }
        default:
            break;
    }
}

-(NSMutableArray *)musicArr{
    if (!_musicArr) {
        _musicArr = [NSMutableArray array];

        [_musicArr addObjectsFromArray:@[@"http://zhangmenshiting.qianqian.com/data2/music/a3e87efc66543570c5df9614d15401d8/257539349/257539349.mp3?xcode=40937f76ebd89b5048ae5c20176c0886",
                                         @"http://zhangmenshiting.qianqian.com/data2/music/b0bfa23ef8f3680c402882ee88769adf/265047008/265047008.mp3?xcode=5a3802dae374cd927ed60eb536e08c87",
                                         @"http://zhangmenshiting.qianqian.com/data2/music/a342ba9e7d4d1fa142d53daad02d0c93/572596293/572596293.mp3?xcode=264292f73ece996e08a65907a49a17b0",
                                         @"http://zhangmenshiting.qianqian.com/data2/music/c58d4471f97e6e91ef6f2e9cf6538d5e/548216776/548216776.mp3?xcode=7268396b00fdbb7606d3b5c82f9312a3",
                                         @"http://zhangmenshiting.qianqian.com/data2/music/124529180/124529180.mp3?xcode=70597faef2de856a43e6e1d8249fc792",
                                         @"http://zhangmenshiting.qianqian.com/data2/music/9e28f925e358d14041d6ebdab3e5726b/544170797/544170797.mp3?xcode=519737661e7ca526c7d4e558c0a93524"]];
    }
    return _musicArr;
}
//-(AVPlayer *)musicPlayer{
//    if (!_musicPlayer) {
//        _musicPlayer = [[AVPlayer alloc]init];
//        
//        
//        
//    }
//    return _musicPlayer;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
