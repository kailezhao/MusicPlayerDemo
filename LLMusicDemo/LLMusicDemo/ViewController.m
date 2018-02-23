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

@property(nonatomic,strong)AVPlayer *musicPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
        
    
   
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
-(AVPlayer *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer = [[AVPlayer alloc]init];
        
        
        
    }
    return _musicPlayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
