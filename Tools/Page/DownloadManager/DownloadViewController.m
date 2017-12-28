//
//  DownloadViewController.m
//  Tools
//
//  Created by 张书孟 on 2017/12/20.
//  Copyright © 2017年 张书孟. All rights reserved.
//

#import "DownloadViewController.h"
#import "FileDownloadManager.h"

#import "DownloadTestCell.h"

#define FileName @"PDF"

@interface DownloadViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation DownloadViewController

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[FileDownloadManager sharedInstance] cancelAllTasks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"getCacheSize : %lf",[[FileDownloadManager sharedInstance] getCacheSize]);
    
    NSLog(@"沙盒路径： %@",[[FileDownloadManager sharedInstance] getFileRoute]);
    NSLog(@"---------------------");
    NSLog(@"%@",[[FileDownloadManager sharedInstance] getAttribute:FileName]);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"清 空" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self addTableView];
}

- (void)btnClick {
    [[FileDownloadManager sharedInstance] suspendAllTasks];
    [self.tableView reloadData];
}

#pragma mark 按钮状态
- (NSString *)getTitleWithDownloadState:(DownloadState)state
{
    switch (state) {
        case DownloadStateStart:
            return @"暂停";
        case DownloadStateSuspended:
        case DownloadStateFailed:
            return @"开始";
        case DownloadStateCompleted:
            return @"完成";
        default:
            break;
    }
}

#pragma mark 刷新数据（用来判断程序刚进来时候下载的文件本地是否存在过，进度咋样）
- (void)refreshDataWithState:(DownloadState)state url:(NSString *)url
{
    self.progress = [[FileDownloadManager sharedInstance] progress:url fileName:FileName] * 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self refreshDataWithState:DownloadStateSuspended url:self.dataSource[indexPath.row][@"url"]];
    
    DownloadTestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadTestCell"];
    [cell setConfig:self.dataSource[indexPath.row]];
    [cell setProgress:self.progress];
    __weak typeof(self) weakSelf = self;
    cell.downloadBtnClick = ^(UIButton *sender, UILabel *label) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[FileDownloadManager sharedInstance] downloadWithUrl:strongSelf.dataSource[indexPath.row][@"url"] fileName:FileName attribute:strongSelf.dataSource[indexPath.row] progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
                NSLog(@"---progress---: %lf",progress * 100);
            });
        } state:^(DownloadState state) {
            NSLog(@"state == %u", state);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:[strongSelf getTitleWithDownloadState:state] forState:UIControlStateNormal];
            });
        }];
    };
    cell.deleteBtnClick = ^(UILabel *label) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [[FileDownloadManager sharedInstance] deleteFile:strongSelf.dataSource[indexPath.row][@"url"] fileName:FileName];
        label.text = @"0%";
    };
    return cell;
}

- (void)addTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DownloadTestCell class] forCellReuseIdentifier:@"DownloadTestCell"];
        [self.view addSubview:_tableView];
    }
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@{@"url": @"http://news.iciba.com/admin/tts/2013-11-15.mp3",
                          @"fileId" : @"1",
                          @"create_time" : @"2017.12.26",
                          @"att_name" : @"测试1",
                          @"live_id" : @"123",
                          },
                        @{@"url" : @"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
                          @"fileId" : @"2",
                          @"create_time" : @"2017.12.27",
                          @"att_name" : @"测试2",
                          @"live_id" : @"456",
                          },
                        @{@"url" : @"http://120.25.226.186:32812/resources/videos/minion_01.mp4",
                          @"fileId" : @"3",
                          @"create_time" : @"2017.12.28",
                          @"att_name" : @"测试123456789",
                          @"live_id" : @"789",
                          }];
    }
    return _dataSource;
}

@end
